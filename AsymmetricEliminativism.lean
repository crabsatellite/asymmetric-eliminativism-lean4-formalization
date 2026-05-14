/-
  AsymmetricEliminativism.lean

  Root module.  Machine-checked formalization of the structural
  mathematics of:

    Li, Alex Chengyu. "Asymmetric Eliminativism: A Diagnostic
    Framework for Reverse-Defined Concepts, with the LLM Consciousness
    Debate as Anchor Case, a Methodological Apparatus, a Replacement
    Vocabulary, and Applications to AI Governance." 2026.
    SSRN abstract id 6723220; Zenodo DOI 10.5281/zenodo.20041562.

  Scope of the formalization.  The paper is primarily a diagnostic
  framework in the philosophy of mind / philosophy of science.  The
  Lean side captures the structural skeleton:

    * The typed apparatus for reverse-defined concepts, mutually
      unranked partitions of folk extensions, operationalisation
      individuation, and operationalisation properties (P1)/(P2)/(P3).
    * The discriminator (D1)/(D2)/(D3) and threshold rules (R1)/(R2).
    * The use-separability (S1)/(S2) predicate.
    * The replacement-vocabulary structural axes (DSC: sessional,
      concurrent, state-inference, distributional, homogeneous,
      inversion) and the SC commitments, plus the bridging
      principle (B1)/(B2).
    * The impossibility theorem `\label{thm:impossibility}` and its
      load-bearing Lemma `\label{lem:prw}`.

  The paper's philosophy-of-language commentary, the historical
  calibration narrative, the AI-governance applications, and the
  testimony-protocol epistemology are *not* formalized — they have
  no structural-mathematical content that Lean checks; they are
  documented in the paper.  See `Diagnostic.lean` for the small
  fragment of the calibration table that *does* have formal content
  (the discriminator rule applied to row-typed inputs).

  Submodules:
    AsymmetricEliminativism/Basic.lean
      Definitions:
        `\label{def:reverse}`         — reverse-defined concept
        `\label{def:asym-elim}`       — asymmetric eliminativism
        `\label{def:edc}`             — diagnostic conditions E1–E3
        `\label{def:separability}`    — use-separability (S1, S2)
        `\label{def:unranked}`        — mutually unranked partition
        `\label{def:op-individuation}`— operationalisation individuation
        `\label{def:op-properties}`   — P1, P2, P3
        `\label{def:sessional}`       — sessional existence (DSC axis 1)
        `\label{def:concurrent}`      — concurrent multiplicity (axis 2)
        `\label{def:state-inference}` — state-inference dichotomy (axis 3)
        `\label{def:distributional}`  — distributional origin (axis 4)
        `\label{def:homogeneous}`     — homogeneous generation (axis 5)
        `\label{def:inversion}`       — interpretability inversion (axis 6)
        `\label{def:sc}`              — sessional cognition
        `\label{def:bridging}`        — structural homomorphism with
                                         content non-translation

    AsymmetricEliminativism/Diagnostic.lean
      Discriminator threshold rules (R1) strict two-of-three and
      (R2) one-strong-plus-two-weak, with derived consequences
      (`\label{def:discriminator}`).

    AsymmetricEliminativism/Impossibility.lean
      Theorem `\label{thm:impossibility}` and the load-bearing
      Lemma `\label{lem:prw}`.  Paper Definition `\label{def:warrant}`
      (added v0.11.0 R14 per v6 §11 paper-Lean unification)
      introduces the typed Warrant triple consumed by the
      substantive `partitionRelative` def in `Basic.lean`.
      v0.14.0 R20 STRUCTURAL FIX: `DiscourseHypothesisH` (Cat 3
      `hypothesisPredicate`) added to realise paper hypothesis
      (H) at `\label{thm:impossibility}` as a
      separate explicit theorem hypothesis (NOT a conjunct of
      `SatisfiesP2`).

  Soundness audit:
    AsymmetricEliminativism/AxiomAudit.lean — prints axiom
    dependencies of every paper-level theorem.

  Vacuity + consistency + R18 definitional-equivalence + R20
  structural-validity verification (v0.11.0 R14 + v0.12.0 R16 +
  v0.13.0 R18 + v0.14.0 R20, MANDATORY per round briefs):
    AsymmetricEliminativism/VacuityCheck.lean — machine-verifies
    kernel-pure that the substantive paper-faithful
    `partitionRelative` def is NON-VACUOUS (R14), the
    R15-machine-verified inconsistency is CLOSED under R16,
    paper `\label{def:warrant}` typed-level identification of
    `partitionRelative` with `featureExtractsAreEInternal` holds
    definitionally (R18), the R20 structural fix lifts hypothesis
    (H) to an explicit theorem hypothesis, and the R22 Fix B
    `admissibleIn` axiom restricts (H)'s quantifier to the
    admissibility-positive discourse regime (R23/R24 honest
    convergence).  V1-V12 theorems, all kernel-pure
    `[propext, Quot.sound]` / `[propext]` / empty:
      * V1-V3 — `partitionRelative` non-vacuity:
        `exists_non_partition_relative` + `not_forall_partition_relative`
        + `exists_partition_relative` exhibit both polarities.
      * V4 — `case_bridge_uniform_unconditional_not_derivable`
        refutes the v0.11.0 R14 case-bridge signature.
      * V5-V6 — R16 antecedent-existence: `nonFactorisingA_not_warrantInternalToE`,
        `exists_uniform_not_warrantInternalToE`,
        `factorisingA_satisfies_all_antecedents`,
        `r15_attack_requires_unprovable_antecedent`.
      * V7 (R18) — `partitionRelative_iff_featureExtractsAreEInternal`
        is `Iff.rfl`, depends on NO axioms.  Formal verification
        of paper `\label{def:warrant}` typed-level identification:
        paper's `\label{lem:prw}` reduction = paper's
        `\label{def:warrant}` E-internality factorisation.  This
        is the structural triviality that R18 Honest Acceptance
        accepts.
      * V8 (R18) — `prw_uniform_to_pr_applied_to_factorisingA`
        and `lem_prw_reduction_applied_to_factorisingA` route
        correctly via `prw_uniform_to_pr`'s `And.right` derivation.
      * V9 (R22) — `r19_kill_destructuring_has_three_conjuncts`:
        post-R22 `SatisfiesP2` has exactly 3 conjuncts
        (`admissibleIn ∧ ¬partitionRelative ∧ ¬failsAdjudication`);
        R19's destructuring pattern FAILS to type-check.
      * V10 (R22 Fix B) — `DiscourseHypothesisH` non-vacuity:
        `discourseHypothesisH_satisfiable_when_admissibleIn_empty`
        and `discourseHypothesisH_fails_when_admissibleIn_universal`
        exhibit both regimes (vacuously-true on empty
        `admissibleIn`; refutable via `nonFactorisingA` on
        universal `admissibleIn`).
      * V11 (R24) — honest acknowledgment of the typed-level
        identification: `discourseHypothesisH_is_implication_typecheck`,
        `hW_dot_2_is_featureExtractsAreEInternal_eq_partitionRelative`,
        `thm_impossibility_uses_H_via_admissibleIn` — the
        2-line `(hH A hAdm).2` bypass IS the canonical proof,
        paper-faithfully per paper `\label{def:warrant}` typed-level
        identification.  Non-vacuous theorem content lives in
        (H)'s `admissibleIn` antecedent.
      * V12 (R24) — `r23_inconsistency_eliminated`: under reverted
        derived-theorem status of `prw_uniform_to_pr`, the R23
        attack vector no longer yields `False` (a uniform-constant-
        ranker witness `uniformConstantRankerA` is constructible
        with both `warrantInternalToE` and `partitionRelative`).

  Gap ledger:
    AsymmetricEliminativism/Ledger.lean — typed record of every
    atomic axiom and every closed top-level result, with TWO
    orthogonal mandatory classifications per entry plus a Cat 3
    sub-type tag:
      * 7-tier status: gapOpen / gapPartial / gapBlocked /
        gapDeadEnd / gapClosed / gapClosedConditional /
        gapDefinitional
        (the 7th tier `gapDefinitional` — paper-novel Cat 3
        atoms that ARE the paper's starting commitments,
        not gaps to close; covers carrier / hypothesisPredicate /
        structuralEquation definitional sub-types — was added
        2026-05-14 per v6 §1.1 / Manufactured Recognition
        R-#27/R-#28)
      * 4-input-category: cat1Mathlib / cat2External /
        cat3PaperNovel / notInput  (Cat 0 = Lean kernel axioms is
        the always-present system layer, not tracked here per
        v6 §3.1)
      * Cat 3 sub-type: carrier / hypothesisPredicate /
        structuralEquation / workingAssumption /
        conditionalHypothesis / phenomenologicalConjecture /
        notCat3
        (the 6th sub-type `phenomenologicalConjecture` —
        framework-paper PUBLISHED substantive claim about a
        phenomenon awaiting external validation — was added
        2026-05-14 per v6 §3.4.6 / Manufactured Recognition
        R-#27)
    `conditionalOn : List String := []` field records broken-link
    hypothesis predicates per v6 §12; invariant: non-empty iff
    status = gapClosedConditional.
-/

import AsymmetricEliminativism.Basic
import AsymmetricEliminativism.Diagnostic
import AsymmetricEliminativism.Impossibility
import AsymmetricEliminativism.VacuityCheck
