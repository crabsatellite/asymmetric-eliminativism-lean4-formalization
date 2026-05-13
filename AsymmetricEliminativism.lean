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
      Lemma `\label{lem:prw}`.

  Soundness audit:
    AsymmetricEliminativism/AxiomAudit.lean — prints axiom
    dependencies of every paper-level theorem.

  Gap ledger:
    AsymmetricEliminativism/Ledger.lean — typed record of every
    atomic axiom and every closed top-level result, with TWO
    orthogonal mandatory classifications per entry plus a Cat 3
    sub-type tag:
      * 6-tier status: gapOpen / gapPartial / gapBlocked /
        gapDeadEnd / gapClosed / gapClosedConditional
      * 4-input-category: cat1Mathlib / cat2External /
        cat3PaperNovel / notInput  (Cat 0 = Lean kernel axioms is
        the always-present system layer, not tracked here per
        v6 §3.1)
      * Cat 3 sub-type: carrier / hypothesisPredicate /
        structuralEquation / workingAssumption /
        conditionalHypothesis / notCat3
    `conditionalOn : List String := []` field records broken-link
    hypothesis predicates per v6 §12; invariant: non-empty iff
    status = gapClosedConditional.
-/

import AsymmetricEliminativism.Basic
import AsymmetricEliminativism.Diagnostic
import AsymmetricEliminativism.Impossibility
