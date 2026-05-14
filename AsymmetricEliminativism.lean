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

  Soundness audit:
    AsymmetricEliminativism/AxiomAudit.lean — prints axiom
    dependencies of every paper-level theorem.

  Vacuity + consistency + R18 definitional-equivalence
  verification (v0.11.0 R14 + v0.12.0 R16 + v0.13.0 R18,
  MANDATORY per round briefs):
    AsymmetricEliminativism/VacuityCheck.lean — machine-verifies
    kernel-pure that the substantive paper-faithful
    `partitionRelative` def is NON-VACUOUS (R14), the
    R15-machine-verified inconsistency is CLOSED under R16, AND
    paper line 2109-2112's identification of `partitionRelative`
    with `featureExtractsAreEInternal` holds definitionally
    (R18).  Eleven theorems, all kernel-pure `[propext,
    Quot.sound]` or empty:
      * `exists_non_partition_relative` — `∃ A, ¬ A.partitionRelative`
        constructible via explicit `nonFactorisingA` witness.
      * `not_forall_partition_relative` — `¬ (∀ A, A.partitionRelative)`
        follows from the above.
      * `exists_partition_relative` — `∃ A, A.partitionRelative`
        (the predicate is satisfiable, not universally-false).
      * `case_bridge_uniform_unconditional_not_derivable` —
        kernel-pure refutation of `∀ A, warrantForm = uniform →
        A.partitionRelative` (the v0.11.0 R14 case-bridge
        signature was REFUTABLE).
      * `nonFactorisingA_not_warrantInternalToE` (v0.12.0 R16
        consistency verification) — the R15 attack's would-be
        antecedent is itself kernel-pure refutable.
      * `exists_uniform_not_warrantInternalToE` (v0.12.0 R16) —
        existence form: `∃ A, A.warrantForm = uniform ∧ ¬
        A.warrantInternalToE`.
      * `factorisingA_satisfies_all_antecedents` (v0.12.0 R16) —
        positive instance: `factorisingA` satisfies both
        case-bridge antecedents AND the conclusion (theorem is
        non-trivially applicable post-R18).
      * `r15_attack_requires_unprovable_antecedent` (v0.12.0 R16)
        — the R15 attack vector is verifiably blocked.
      * `partitionRelative_iff_featureExtractsAreEInternal`
        (v0.13.0 R18) — `Iff.rfl`, depends on NO axioms.
        Formal verification of paper line 2109-2112's
        identification: paper's `lem:prw` reduction = paper's
        `\label{def:warrant}` E-internality factorisation.  This
        is the structural triviality that R18 Honest Acceptance
        accepts.
      * `prw_uniform_to_pr_applied_to_factorisingA` (v0.13.0
        R18) — R18 case-bridge transparency test on `factorisingA`.
      * `lem_prw_reduction_applied_to_factorisingA` (v0.13.0
        R18) — derived theorem post-R18 routes correctly via
        `prw_uniform_to_pr`'s `And.right` derivation.

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
