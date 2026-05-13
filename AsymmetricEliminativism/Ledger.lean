/-
  AsymmetricEliminativism/Ledger.lean

  Gap ledger.  Every atomic axiom, every Cat 3 carrier, and every
  closed top-level result is recorded as a typed `GapEntry` with
  TWO orthogonal classifications:

    * 5-tier status:   gapOpen / gapPartial / gapBlocked / gapDeadEnd / gapClosed
    * 3-input-category: cat1Mathlib / cat2External / cat3PaperNovel / notInput

  Pre-attack discipline.  Scan this ledger before launching new
  attacks.  Re-attempting a `gapBlocked` or `gapDeadEnd` route is
  a context-drift failure mode.

  `attackHistory` is the canonical location for round metadata
  (citation revisions, atomic refactors, prior retractions);
  docstrings and `scope` fields are kept to current-state content
  only.

  Companion to: Li 2026, "Asymmetric Eliminativism: A Diagnostic
  Framework for Reverse-Defined Concepts …" (SSRN 6723220 /
  Zenodo 10.5281/zenodo.20041562).
-/

import AsymmetricEliminativism

namespace AsymmetricEliminativism.Ledger

/-- 5-tier status tag attached to each gap. -/
inductive GapStatus
  | gapOpen
  | gapPartial
  | gapBlocked
  | gapDeadEnd
  | gapClosed
  deriving DecidableEq, Repr

/-- 3-input-category tag attached to each gap.  Orthogonal to status. -/
inductive InputCategory
  /-- Mathlib-derivable theorem (no axiom).  Project has zero such. -/
  | cat1Mathlib
  /-- External published; opaque-carrier-bound axiom + citation. -/
  | cat2External
  /-- Paper-novel: typed primitive carrier, paper-novel predicate, or
       paper-stated atomic defining equation. -/
  | cat3PaperNovel
  /-- Not an atomic input: derived theorem (gapClosed) or blocked
       Mathlib-derivation route (gapBlocked). -/
  | notInput
  deriving DecidableEq, Repr

/-- Typed record for a single gap. -/
structure GapEntry where
  /-- Identifier matching the underlying axiom / theorem name. -/
  name : String
  /-- 5-tier status (orthogonal to inputCategory). -/
  status : GapStatus
  /-- Input category (orthogonal to status). -/
  inputCategory : InputCategory
  /-- Operative paper / obstacle citation. -/
  paperSource : String
  /-- Per-round attack trace (canonical location for round
       metadata). -/
  attackHistory : List String
  /-- What content the entry carries; what it does NOT claim. -/
  scope : String

/-! ### Cat 3 paper-novel atomic defining axioms. -/

/--
  Lemma `\label{lem:prw}` reduction (Partition-Relative-Weighting):
  the lemma's load-bearing structural consequence carried as a
  single atomic Cat 3 axiom.
-/
def gap_lem_prw_reduction : GapEntry := {
  name := "lem_prw_reduction"
  status := GapStatus.gapOpen
  inputCategory := InputCategory.cat3PaperNovel
  paperSource :=
    "Li 2026, `\\label{lem:prw}` (Partition-Relative-Weighting " ++
    "Reduction) proof body — paper proof case analysis of " ++
    "`\\E`-internal arbitration warrants (uniform / contextual / " ++
    "type-(c) partition-symmetric property selection); the " ++
    "lemma's substantive content is the reduction of every " ++
    "`\\E`-internal warrant to a partition-relative weighting of " ++
    "`{E_1, …, E_n}`"
  attackHistory := []
  scope :=
    "`∀ A, A.warrantInternalToE → A.partitionRelative`.  Carries " ++
    "the lemma's downstream consequence for the impossibility " ++
    "theorem; the lemma's justification (case analysis) lives in " ++
    "the paper proof and is not separately encoded."
}

/-! ### Cat 3 paper-novel carrier types and predicates.

  *These are not Lean `axiom`s.*  The paper-novel carriers below
  are encoded as Lean `structure` / `def` / `class` (paper-novel
  predicates), per `feedback_gap_ledger_in_lean4`'s Cat 3 allowance
  for "typed primitive carriers" and "paper-novel predicates".  We
  record them in the ledger for trust-audit completeness even
  though they are not `axiom` declarations.  None contributes to a
  `#print axioms` audit.
-/

def gap_ReverseDefinedConcept_carrier : GapEntry := {
  name := "ReverseDefinedConcept (structure)"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat3PaperNovel
  paperSource := "Li 2026, `\\label{def:reverse}`"
  attackHistory := []
  scope :=
    "Typed structural carrier for the paper's clauses (i)–(iv) of " ++
    "reverse-definition.  Encoded as a Lean `structure`, not an " ++
    "`axiom`; appears in the ledger for completeness of paper-side " ++
    "carrier inventory."
}

def gap_MutuallyUnrankedPartition_carrier : GapEntry := {
  name := "MutuallyUnrankedPartition (structure)"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat3PaperNovel
  paperSource := "Li 2026, `\\label{def:unranked}`"
  attackHistory := []
  scope :=
    "Typed structural carrier for a mutually unranked partition " ++
    "of a folk extension.  Encoded as a Lean `structure` with " ++
    "`pairwise_disjoint` and `noPartitionIndependentRanking` " ++
    "fields; not an `axiom`."
}

def gap_Operationalisation_carrier : GapEntry := {
  name := "Operationalisation (structure)"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat3PaperNovel
  paperSource :=
    "Li 2026, `\\label{def:op-individuation}` and " ++
    "`\\label{def:op-properties}`"
  attackHistory := []
  scope :=
    "Typed structural carrier for an operationalisation as a " ++
    "Boolean-valued verdict-map parametrised by its partition-" ++
    "member faithfulness.  Encoded as a Lean `structure`."
}

def gap_ArbitrationProcedure_carrier : GapEntry := {
  name := "ArbitrationProcedure (structure)"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat3PaperNovel
  paperSource := "Li 2026, `\\label{def:op-properties}` P2"
  attackHistory := []
  scope :=
    "Typed structural carrier for an arbitration procedure " ++
    "between operationalisations.  Encoded as a Lean `structure` " ++
    "with `partitionRelative` and `warrantInternalToE` " ++
    "predicate fields."
}

def gap_CognitiveSystem_carrier : GapEntry := {
  name := "CognitiveSystem (structure)"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat3PaperNovel
  paperSource :=
    "Li 2026, §11 (Distributed Statistical Cognition replacement " ++
    "vocabulary preliminaries)"
  attackHistory := []
  scope :=
    "Typed structural carrier for an abstract cognitive system " ++
    "with token / weight / activation / session / instance / " ++
    "context spaces and an inference operation.  Sufficient to " ++
    "state the six DSC axes; encoded as a Lean `structure`."
}

def gap_SessionalCognition_carrier : GapEntry := {
  name := "SessionalCognition (structure)"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat3PaperNovel
  paperSource := "Li 2026, `\\label{def:sc}`"
  attackHistory := []
  scope :=
    "Typed structural carrier for the six SC commitments (V1–V6) " ++
    "as Prop-valued fields paralleling the DSC axes.  Encoded " ++
    "as a Lean `structure`."
}

def gap_BridgingPrinciple_carrier : GapEntry := {
  name := "BridgingPrinciple (structure)"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat3PaperNovel
  paperSource := "Li 2026, `\\label{def:bridging}`"
  attackHistory := []
  scope :=
    "Typed structural carrier for the (B1) bijective " ++
    "correspondence + mutual independence + joint sufficiency " ++
    "relations and (B2) point-of-view non-translatability.  " ++
    "Encoded as a Lean `structure`."
}

/-! ### gapClosed entries — top-level theorems proven without `sorry`. -/

/-- Theorem `\label{thm:impossibility}`: impossibility for unranked-
    extension concepts. -/
def gap_thm_impossibility_CLOSED : GapEntry := {
  name := "thm_impossibility"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.notInput
  paperSource := "Li 2026, `\\label{thm:impossibility}`"
  attackHistory := []
  scope :=
    "Under (H) and `\\label{def:unranked}`, no operationalisation " ++
    "satisfies P2 of `\\label{def:op-properties}`.  Proof: by " ++
    "`lem_prw_reduction` applied to the witness arbitration " ++
    "procedure; standard kernel only.  Lean conclusion is the " ++
    "`¬ P2` form; P3 is trivially satisfied by the Boolean-" ++
    "verdict encoding (see `satisfiesP3_of_boolean`) so the " ++
    "paper-level `¬ (P2 ∧ P3)` reduces to `¬ P2`."
}

/-- Bridging-principle consequence:
    `SatisfiesDSC ↔ conjunction-of-V_i`. -/
def gap_bridging_dsc_iff_sc_CLOSED : GapEntry := {
  name := "bridging_dsc_iff_sc"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.notInput
  paperSource :=
    "Li 2026, `\\label{def:bridging}` (B1.i) bijective " ++
    "correspondence consequence"
  attackHistory := []
  scope :=
    "Lean transfer of the six bi-implications in B1.i to a single " ++
    "conjunction-level bi-implication: `SatisfiesDSC S ↔ V1 ∧ … ∧ V6`."
}

/-- Trivial P3 from Boolean-valued verdicts. -/
def gap_satisfiesP3_of_boolean_CLOSED : GapEntry := {
  name := "satisfiesP3_of_boolean"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.notInput
  paperSource := "Li 2026, `\\label{def:op-properties}` P3"
  attackHistory := []
  scope :=
    "Boolean-valued `Operationalisation.verdict` discharges P3 " ++
    "structurally: every `x : Tcls` has a determinate Boolean " ++
    "verdict.  This is the Lean-formalised content P3 carries " ++
    "given the Boolean-verdict encoding; the substantive paper-" ++
    "side content of P3 (decidability under contestation) lives " ++
    "in `FaithfulP1`'s contested-witness fields."
}

/-! ### Discriminator threshold-rule structural lemmas. -/

def gap_R1_fires_on_all_yes_CLOSED : GapEntry := {
  name := "R1_fires_on_all_yes"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.notInput
  paperSource :=
    "Li 2026, `\\label{def:discriminator}` rule (R1) " ++
    "(strict two-of-three)"
  attackHistory := []
  scope :=
    "(R1) fires on the `(yes, yes, yes)` row.  Pure-`simp` proof; " ++
    "standard kernel only."
}

def gap_R1_fires_on_yes_yes_weak_CLOSED : GapEntry := {
  name := "R1_fires_on_yes_yes_weak"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.notInput
  paperSource :=
    "Li 2026, `\\label{def:discriminator}` rule (R1)"
  attackHistory := []
  scope :=
    "(R1) fires on `(yes, yes, weak)`; matches the historical " ++
    "calibration `instinct` row.  Pure-`simp` proof."
}

def gap_R1_does_not_fire_on_yes_weak_weak_CLOSED : GapEntry := {
  name := "R1_does_not_fire_on_yes_weak_weak"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.notInput
  paperSource :=
    "Li 2026, `\\label{def:discriminator}` rule (R1) " ++
    "non-firing on the LLM-row pattern"
  attackHistory := []
  scope :=
    "(R1) does NOT fire on `(yes, weak, weak)`.  This is why the " ++
    "LLM-row verdict relies on (R2) and is labelled preliminary " ++
    "in the paper."
}

def gap_R2_pattern_fires_on_yes_weak_weak_CLOSED : GapEntry := {
  name := "R2_pattern_fires_on_yes_weak_weak"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.notInput
  paperSource :=
    "Li 2026, `\\label{def:discriminator}` rule (R2) Boolean-" ++
    "pattern check"
  attackHistory := []
  scope :=
    "(R2)'s Boolean pattern fires on `(yes, weak, weak)`; the " ++
    "full (R2) verdict additionally requires the counterfactual-" ++
    "independence side-condition."
}

def gap_predictsEliminate_of_all_yes_CLOSED : GapEntry := {
  name := "predictsEliminate_of_all_yes"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.notInput
  paperSource :=
    "Li 2026, `\\label{def:discriminator}` (R1) eliminate verdict"
  attackHistory := []
  scope :=
    "Compose: (R1) firing on `(yes, yes, yes)` ⟹ eliminate " ++
    "verdict.  Used by the calibration table's four cleanly " ++
    "eliminated cases."
}

def gap_predictsEliminate_of_yes_weak_weak_with_indep_CLOSED : GapEntry := {
  name := "predictsEliminate_of_yes_weak_weak_with_indep"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.notInput
  paperSource :=
    "Li 2026, `\\label{def:discriminator}` (R2) eliminate verdict " ++
    "on the LLM-row pattern under counterfactual independence"
  attackHistory := []
  scope :=
    "Compose: (R2) Boolean pattern + counterfactual-independence " ++
    "side-condition ⟹ eliminate verdict on `(yes, weak, weak)`.  " ++
    "Captures the LLM-row preliminary-elimination structure."
}

def gap_not_R2_satisfied_without_indep_CLOSED : GapEntry := {
  name := "not_R2_satisfied_without_indep"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.notInput
  paperSource :=
    "Li 2026, `\\label{def:discriminator}` (R2) defeat by " ++
    "counterfactual-independence-test failure"
  attackHistory := []
  scope :=
    "Without counterfactual independence, the LLM-row pattern " ++
    "does NOT yield an (R2)-licensed verdict.  This is the " ++
    "framework's defeasibility-margin built into (R2)."
}

/-! ### Impossibility-theorem corollaries. -/

def gap_no_partition_independent_admissible_warrant_CLOSED : GapEntry := {
  name := "no_partition_independent_admissible_warrant"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.notInput
  paperSource :=
    "Li 2026, `\\label{thm:impossibility}` consequence — " ++
    "contrapositive form of `\\label{lem:prw}`"
  attackHistory := []
  scope :=
    "Every admissible-warrant arbitration procedure reduces to " ++
    "partition-relative weighting; package of `lem_prw_reduction`."
}

def gap_ensemble_methods_fail_P2_CLOSED : GapEntry := {
  name := "ensemble_methods_fail_P2"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.notInput
  paperSource :=
    "Li 2026, `\\label{thm:impossibility}` `Consequences` " ++
    "paragraph: 'ensemble methods aggregating verdicts inherit " ++
    "P2's failure'"
  attackHistory := []
  scope :=
    "Specialisation of `lem_prw_reduction` to an ensemble-flavoured " ++
    "arbitration procedure; structurally identical reduction."
}

def gap_impossibility_uniform_family_CLOSED : GapEntry := {
  name := "impossibility_uniform_family"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.notInput
  paperSource :=
    "Li 2026, `\\label{thm:impossibility}` (uniform application " ++
    "to the family `{Op_1, …, Op_n}`)"
  attackHistory := []
  scope :=
    "Impossibility transfers uniformly across the operationalisation " ++
    "family.  Pure pointwise application of `thm_impossibility`."
}

/-! ### Aggregated ledger inventory. -/

/-- All gap entries in canonical order. -/
def allGaps : List GapEntry := [
  -- Cat 3 paper-novel atomic axiom (impossibility-theorem load-bearer)
  gap_lem_prw_reduction,
  -- Cat 3 paper-novel carrier types and predicates (structures, not axioms)
  gap_ReverseDefinedConcept_carrier,
  gap_MutuallyUnrankedPartition_carrier,
  gap_Operationalisation_carrier,
  gap_ArbitrationProcedure_carrier,
  gap_CognitiveSystem_carrier,
  gap_SessionalCognition_carrier,
  gap_BridgingPrinciple_carrier,
  -- gapClosed top-level results
  gap_thm_impossibility_CLOSED,
  gap_bridging_dsc_iff_sc_CLOSED,
  gap_satisfiesP3_of_boolean_CLOSED,
  -- Discriminator threshold-rule lemmas
  gap_R1_fires_on_all_yes_CLOSED,
  gap_R1_fires_on_yes_yes_weak_CLOSED,
  gap_R1_does_not_fire_on_yes_weak_weak_CLOSED,
  gap_R2_pattern_fires_on_yes_weak_weak_CLOSED,
  gap_predictsEliminate_of_all_yes_CLOSED,
  gap_predictsEliminate_of_yes_weak_weak_with_indep_CLOSED,
  gap_not_R2_satisfied_without_indep_CLOSED,
  -- Impossibility-theorem corollaries
  gap_no_partition_independent_admissible_warrant_CLOSED,
  gap_ensemble_methods_fail_P2_CLOSED,
  gap_impossibility_uniform_family_CLOSED
]

/-- Status-keyed counts: `(open, partial, blocked, deadEnd, closed)`. -/
def gapCounts : Nat × Nat × Nat × Nat × Nat :=
  let countWhere (s : GapStatus) : Nat :=
    (allGaps.filter (fun g => g.status = s)).length
  ( countWhere GapStatus.gapOpen
  , countWhere GapStatus.gapPartial
  , countWhere GapStatus.gapBlocked
  , countWhere GapStatus.gapDeadEnd
  , countWhere GapStatus.gapClosed )

/-- InputCategory-keyed counts:
    `(cat1Mathlib, cat2External, cat3PaperNovel, notInput)`. -/
def inputCategoryCounts : Nat × Nat × Nat × Nat :=
  let countWhere (c : InputCategory) : Nat :=
    (allGaps.filter (fun g => g.inputCategory = c)).length
  ( countWhere InputCategory.cat1Mathlib
  , countWhere InputCategory.cat2External
  , countWhere InputCategory.cat3PaperNovel
  , countWhere InputCategory.notInput )

#eval s!"AsymmetricEliminativism gap-ledger inventory (status): open={(gapCounts).1} partial={(gapCounts).2.1} blocked={(gapCounts).2.2.1} deadEnd={(gapCounts).2.2.2.1} closed={(gapCounts).2.2.2.2}"

#eval s!"AsymmetricEliminativism gap-ledger inventory (input):  cat1Mathlib={(inputCategoryCounts).1} cat2External={(inputCategoryCounts).2.1} cat3PaperNovel={(inputCategoryCounts).2.2.1} notInput={(inputCategoryCounts).2.2.2}"

#eval s!"Total entries: {allGaps.length}"

/-! ### Inventory summary

  The live status counts and input-category counts are printed by
  the `#eval` calls above (run
  `lake env lean AsymmetricEliminativism/Ledger.lean` to see them).
  The axiom inventory:

    Cat 3 paper-novel atomic axioms (Li 2026 internal claims):
      lem_prw_reduction
        — Lemma `\label{lem:prw}`; load-bearing for
          `thm_impossibility`.

    Cat 3 paper-novel typed carriers (encoded as Lean structures /
    classes, NOT as `axiom` declarations):
      ReverseDefinedConcept, ReverseDefinedWitness,
      AsymmetricEliminationVerdict, DiagnosticProfile,
      UseSeparability, MutuallyUnrankedPartition,
      Operationalisation, FaithfulP1, ArbitrationProcedure,
      CognitiveSystem, SessionalCognition, BridgingPrinciple,
      DiscriminatorRow.

  Lean kernel (not declared here):
    propext, Classical.choice, Quot.sound.

  Project has *zero* Cat 1 axioms (no Mathlib-derivability claims
  pending discharge) and *zero* Cat 2 axioms (no external
  textbook citations).  The single Cat 3 atomic axiom
  `lem_prw_reduction` captures the load-bearing structural
  consequence of paper Lemma `\label{lem:prw}`; the lemma's
  *justification* is the paper's case-analysis proof and is not
  separately formalised.
-/

end AsymmetricEliminativism.Ledger
