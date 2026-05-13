/-
  AsymmetricEliminativism/Ledger.lean

  Gap ledger.  Every atomic axiom, every Cat 3 carrier, and every
  closed top-level result is recorded as a typed `GapEntry` with
  three orthogonal classifications plus a broken-link dependency
  list:

    * 6-tier status:    gapOpen / gapPartial / gapBlocked / gapDeadEnd /
                        gapClosed / gapClosedConditional
    * 4-input-category: cat1Mathlib / cat2External / cat3PaperNovel / notInput
    * Cat 3 sub-type:   carrier / hypothesisPredicate / structuralEquation /
                        workingAssumption / conditionalHypothesis / notCat3
    * conditionalOn :   list of `Hyp_*` broken-link predicate names
                        (non-empty iff status is `gapClosedConditional`;
                        see v6 §12)

  Pre-attack discipline.  Scan this ledger before launching new
  attacks.  Re-attempting a `gapBlocked` or `gapDeadEnd` route is
  a context-drift failure mode.

  `attackHistory` is the canonical location for round metadata
  (citation revisions, atomic refactors, prior retractions,
  Cat 3 reductionism check outcomes); docstrings and `scope`
  fields are kept to current-state content only.

  Companion to: Li 2026, "Asymmetric Eliminativism: A Diagnostic
  Framework for Reverse-Defined Concepts …" (SSRN 6723220 /
  Zenodo 10.5281/zenodo.20041562).
-/

import AsymmetricEliminativism

namespace AsymmetricEliminativism.Ledger

/-- 6-tier status tag attached to each gap.  `gapClosedConditional`
    is used when Phase 4 catches a defect breaking a typed-bridge
    chain: the downstream closure is preserved as conditional on a
    named `Hyp_*` broken-link hypothesis (recorded in the entry's
    `conditionalOn` field) pending repair or independent derivation.
    See `feedback_gap_ledger_in_lean4` §12. -/
inductive GapStatus
  | gapOpen
  | gapPartial
  | gapBlocked
  | gapDeadEnd
  | gapClosed
  | gapClosedConditional
  deriving DecidableEq, Repr

/-- 4-input-category tag attached to each gap.  Orthogonal to status.
    (Cat 0 = Lean kernel axioms — `propext` / `Classical.choice` /
    `Quot.sound` — is the always-present system layer and is not
    tracked here per v6 §3.1.) -/
inductive InputCategory
  /-- Mathlib-derivable theorem (no axiom).  Project has zero such. -/
  | cat1Mathlib
  /-- External published; opaque-carrier-bound axiom + citation.
      Project has zero such (paper is fundamentally philosophical;
      no external textbook citations underwrite its atoms). -/
  | cat2External
  /-- Paper-novel: carrier, hypothesis predicate, structural defining
      equation, working assumption, or conditional hypothesis.
      Refine via the `cat3SubType` field. -/
  | cat3PaperNovel
  /-- Not an atomic input: derived theorem (gapClosed) or genuine
      no-acceptance-possible route (gapBlocked / gapDeadEnd). -/
  | notInput
  deriving DecidableEq, Repr

/-- Cat 3 paper-novel sub-types per v6 §3.4.  Orthogonal to status
    and input-category; only meaningful when
    `inputCategory = cat3PaperNovel`. -/
inductive Cat3SubType
  /-- Paper-introduced primitive type or typed-primitive value
      (e.g. `ReverseDefinedConcept`, `MutuallyUnrankedPartition`).
      Definitional atom; 永不 close. -/
  | carrier
  /-- Paper-introduced scope/regime predicate or Prop-bundle scope
      condition (e.g. `UseSeparability` S1/S2, `FaithfulP1` P1).
      Definitional atom; 永不 close. -/
  | hypothesisPredicate
  /-- Paper-stated definitional equation / structural reduction on
      its primitives (e.g. `lem_prw_reduction` carrying the load-
      bearing implication `A.warrantInternalToE → A.partitionRelative`
      on the typed `ArbitrationProcedure` + `MutuallyUnrankedPartition`
      carriers).  Definitional atom; 永不 close — constitutes the
      paper's commitments to how its primitives behave. -/
  | structuralEquation
  /-- Higher-level claim temporarily axiomatized while derivation is
      developed.  必须 close before paper submission. -/
  | workingAssumption
  /-- Paper's conclusion conditional on an external open problem
      (RH, BSD, Hodge, P≠NP).  永不 close; encoded as theorem-
      signature antecedent `theorem T (hRH : RiemannHypothesis) : ...`,
      NOT as an axiom.  Listed for completeness; project has none. -/
  | conditionalHypothesis
  /-- This entry is not Cat 3 paper-novel. -/
  | notCat3
  deriving DecidableEq, Repr

/-- Typed record for a single gap. -/
structure GapEntry where
  /-- Identifier matching the underlying axiom / theorem name. -/
  name : String
  /-- 6-tier status. -/
  status : GapStatus
  /-- Input category (orthogonal to status). -/
  inputCategory : InputCategory
  /-- Cat 3 sub-type (orthogonal; `notCat3` unless
      `inputCategory = cat3PaperNovel`). -/
  cat3SubType : Cat3SubType
  /-- Operative paper / obstacle citation. -/
  paperSource : String
  /-- Per-round attack trace (canonical location for round metadata).
      For Cat 3 entries, MUST include ≥2 reductionism check outcomes
      (Cat 1? Cat 2?) per v6 §5. -/
  attackHistory : List String
  /-- What content the entry carries; what it does NOT claim. -/
  scope : String
  /-- Names of `Hyp_*` broken-link predicates this entry's proof
      depends on.  Invariant: non-empty iff
      `status = gapClosedConditional`.  See v6 §12. -/
  conditionalOn : List String := []

/-! ### Cat 3 paper-novel atomic structural reduction. -/

/--
  Lemma `\label{lem:prw}` reduction (Partition-Relative-Weighting):
  the lemma's load-bearing structural consequence carried as a
  single atomic Cat 3 axiom.
-/
def gap_lem_prw_reduction : GapEntry := {
  name := "lem_prw_reduction"
  status := GapStatus.gapOpen
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource :=
    "Li 2026, `\\label{lem:prw}` (Partition-Relative-Weighting " ++
    "Reduction) proof body — paper proof case analysis of " ++
    "`\\E`-internal arbitration warrants (uniform / contextual " ++
    "cases); the lemma's substantive content is the reduction of " ++
    "every `\\E`-internal warrant to a partition-relative " ++
    "weighting of `{E_1, …, E_n}`.  The paper itself states that " ++
    "the lemma `carries the load` and the type-(a)/(b)/(c) " ++
    "trichotomy sub-claims `serve as exhaustiveness-check rather " ++
    "than as the load-bearing proof` (paragraph immediately after " ++
    "the lemma's proof in `asymmetric_eliminativism_full.tex`)."
  attackHistory := [
    "v0.2.0 audit (2026-05-13): atomicity confirmed.  Decision: " ++
      "keep as SINGLE atomic axiom.  The paper's own structure " ++
      "(`Lemma~\\ref{lem:prw}` carries the load; sub-claims verify " ++
      "exhaustiveness) treats the uniform/contextual split + the " ++
      "type-(a)/(b)/(c) trichotomy as exhaustiveness-checks on a " ++
      "single bi-implication, not as separable atoms.  Decomposing " ++
      "would invert the paper's load-bearing structure.  Citation " ++
      "tightened to reference the load-bearing paragraph by " ++
      "content rather than by pp.",
    "v0.3.0 reductionism Cat 1?: CLEAR-NO — the implication " ++
      "`A.warrantInternalToE → A.partitionRelative` is stated over " ++
      "the paper-novel `ArbitrationProcedure` + `MutuallyUnranked" ++
      "Partition` carriers; Mathlib has no order-theoretic primitive " ++
      "that captures this paper-specific reduction.",
    "v0.3.0 reductionism Cat 2?: CLEAR-NO — the reduction is the " ++
      "paper's own Lemma 1 (`\\label{lem:prw}`); no external " ++
      "textbook covers warrant-to-partition-weighting reductions " ++
      "on these paper-novel typed carriers.",
    "v0.3.0 sub-type classification: structuralEquation — the " ++
      "axiom carries a paper-stated structural reduction on its " ++
      "primitives (the typed `ArbitrationProcedure` + " ++
      "`MutuallyUnrankedPartition` carriers), encoding the lemma's " ++
      "load-bearing implication.  Not a carrier (not introducing a " ++
      "new primitive type); not a hypothesis predicate (not a scope " ++
      "condition); not a working assumption (atomicity confirmed " ++
      "in v0.2.0)."
  ]
  scope :=
    "`∀ A, A.warrantInternalToE → A.partitionRelative`.  Carries " ++
    "the lemma's downstream consequence for the impossibility " ++
    "theorem; the lemma's justification (case analysis) lives in " ++
    "the paper proof and is not separately encoded."
}

/-! ### Cat 3 paper-novel carrier types and predicates.

  *These are not Lean `axiom`s.*  The paper-novel carriers below
  are encoded as Lean `structure` / `def` / `class` (paper-novel
  predicates), per `feedback_gap_ledger_in_lean4` v6 §3.4's Cat 3
  allowance for "typed primitive carriers" (sub-type `carrier`)
  and "paper-novel scope/regime predicates" (sub-type
  `hypothesisPredicate`).  We record them in the ledger for trust-
  audit completeness even though they are not `axiom` declarations.
  None contributes to a `#print axioms` audit.
-/

def gap_ReverseDefinedConcept_carrier : GapEntry := {
  name := "ReverseDefinedConcept (structure)"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.carrier
  paperSource := "Li 2026, `\\label{def:reverse}`"
  attackHistory := [
    "v0.3.0 sub-type classification: carrier — paper-introduced " ++
      "primitive type for clauses (i)–(iv) of reverse-definition; " ++
      "the typed `structure` IS the paper's mathematical object."
  ]
  scope :=
    "Typed structural carrier for the paper's clauses (i)–(iv) of " ++
    "reverse-definition.  Encoded as a Lean `structure`, not an " ++
    "`axiom`; appears in the ledger for completeness of paper-side " ++
    "carrier inventory."
}

def gap_ReverseDefinedWitness_carrier : GapEntry := {
  name := "ReverseDefinedWitness (structure)"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.carrier
  paperSource :=
    "Li 2026, `\\label{def:reverse}` clauses (iv.a)/(iv.b)/(iv.c) " ++
    "(the three sub-criteria jointly sufficient for clause (iv))"
  attackHistory := [
    "v0.3.0 sub-type classification: carrier — paper-introduced " ++
      "primitive type packaging the (iv.a)/(iv.b)/(iv.c) sub-" ++
      "criteria into a structured witness object parametrised by " ++
      "a parent `ReverseDefinedConcept`.  The structure itself is " ++
      "the typed primitive (a witness-type), parallel in role to " ++
      "`ReverseDefinedConcept`."
  ]
  scope :=
    "Typed structural carrier exposing the three jointly-sufficient " ++
    "sub-criteria for the hard clause (iv) of reverse-definition: " ++
    "defenceAsymmetry, noInternalArbiter, folkSubsetReverses.  " ++
    "Encoded as a Lean `structure` over a `ReverseDefinedConcept`, " ++
    "not an `axiom`."
}

def gap_AsymmetricEliminationVerdict_carrier : GapEntry := {
  name := "AsymmetricEliminationVerdict (structure)"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.hypothesisPredicate
  paperSource := "Li 2026, `\\label{def:asym-elim}` (with (a)/(b) " ++
    "licensing mode distinction from \\S~\\ref{sec:asymmetric-elim})"
  attackHistory := [
    "v0.3.0 sub-type classification: hypothesisPredicate — the " ++
      "structure encodes a verdict-assignment (eliminated/retained " ++
      "register + licensing mode) over a partition; it functions as " ++
      "a paper-introduced scope/regime predicate on partitions " ++
      "into target classes rather than as a freestanding primitive " ++
      "type.  The (a)/(b) `LicensingMode` distinction is itself a " ++
      "scope-defining classifier on eliminated parts."
  ]
  scope :=
    "Typed scope/regime predicate for an asymmetric-eliminativist " ++
    "verdict-assignment over a partition into target classes.  " ++
    "Includes the (a)/(b) `LicensingMode` distinction for " ++
    "eliminated parts (successor-mature vs. preliminary-ahead-of-" ++
    "replacement).  Encoded as a Lean `structure`."
}

def gap_DiagnosticProfile_carrier : GapEntry := {
  name := "DiagnosticProfile (structure)"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.carrier
  paperSource := "Li 2026, `\\label{def:edc}` (E1, E2, E3)"
  attackHistory := [
    "v0.3.0 sub-type classification: carrier — paper-introduced " ++
      "primitive type packaging the three eliminative diagnostic " ++
      "conditions (E1 carries a `ReverseDefinedConcept`; E2/E3 " ++
      "carry Props) into a typed diagnostic-profile object."
  ]
  scope :=
    "Typed structural carrier for the three eliminative diagnostic " ++
    "conditions (E1 reverse-definition; E2 persistent dispersion; " ++
    "E3 functional decoupling).  Encoded as a Lean `structure` " ++
    "with E1 carrying a `ReverseDefinedConcept` and E2/E3 as Prop-" ++
    "valued fields (substantive defeasibility content is paper-" ++
    "empirical and not Lean-checked)."
}

def gap_UseSeparability_carrier : GapEntry := {
  name := "UseSeparability (structure)"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.hypothesisPredicate
  paperSource := "Li 2026, `\\label{def:separability}` (S1, S2)"
  attackHistory := [
    "v0.3.0 sub-type classification: hypothesisPredicate — " ++
      "use-separability is a paper-introduced scope/regime " ++
      "condition (S1 causal independence + S2 constitutive " ++
      "independence) on a (concept, T_elim, T_retained) triple.  " ++
      "The structure is a Prop-bundle scope predicate, not a " ++
      "freestanding primitive type."
  ]
  scope :=
    "Typed scope/regime predicate for use-separability: S1 (causal " ++
    "independence of analytic-verdict transmission) and S2 " ++
    "(constitutive independence of retained-use criteria).  " ++
    "Encoded as a Lean `structure` with Prop-valued S1/S2 fields; " ++
    "the paper's evidential-temporal reading + load-bearing " ++
    "threshold are paper-empirical and not Lean-checked."
}

def gap_FaithfulP1_carrier : GapEntry := {
  name := "FaithfulP1 (structure)"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.hypothesisPredicate
  paperSource := "Li 2026, `\\label{def:op-properties}` (P1)"
  attackHistory := [
    "v0.3.0 sub-type classification: hypothesisPredicate — P1 " ++
      "faithfulness is the paper-introduced scope condition on an " ++
      "operationalisation (it must be determined by partition-" ++
      "member exhibition) plus the contested-witness structural-" ++
      "use fields.  Functions as a paper-novel predicate over " ++
      "(Op, partition-member) pairs, not as a freestanding " ++
      "primitive type."
  ]
  scope :=
    "Typed scope/regime predicate for P1 faithfulness: the Prop " ++
    "`determinedByPartExhibition` + the contested-witness " ++
    "structural-use fields `hasContestedNegativeWitness` and " ++
    "`hasContestedPositiveWitness`.  Encoded as a Lean `structure`; " ++
    "the contested-witness fields capture the structural use of P1 " ++
    "in the impossibility-theorem proof and are the substantive " ++
    "paper-side content of P3 (decidability under contestation)."
}

def gap_DiscriminatorRow_carrier : GapEntry := {
  name := "DiscriminatorRow (structure)"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.carrier
  paperSource :=
    "Li 2026, `\\label{def:discriminator}` (D1, D2, D3 three-valued " ++
    "judgement with counterfactual-independence side-condition)"
  attackHistory := [
    "v0.3.0 sub-type classification: carrier — paper-introduced " ++
      "primitive type for a discriminator-table row (D1/D2/D3 " ++
      "ratings + counterfactual-independence Prop).  The structure " ++
      "IS the paper's mathematical object for discriminator rows."
  ]
  scope :=
    "Typed structural carrier for a discriminator-table row: " ++
    "D1/D2/D3 ratings from `DiagnosticRating` (yes/weak/no) plus " ++
    "the counterfactual-independence Prop for the (R2) side-" ++
    "condition.  Encoded as a Lean `structure`."
}

def gap_MutuallyUnrankedPartition_carrier : GapEntry := {
  name := "MutuallyUnrankedPartition (structure)"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.carrier
  paperSource := "Li 2026, `\\label{def:unranked}`"
  attackHistory := [
    "v0.3.0 sub-type classification: carrier — paper-introduced " ++
      "primitive type for a mutually unranked partition of a folk " ++
      "extension (n parts + pairwise disjointness + no-partition-" ++
      "independent-ranking Prop).  Definitional atom for the " ++
      "impossibility theorem; `lem_prw_reduction` is the load-" ++
      "bearing structural equation built on top."
  ]
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
  cat3SubType := Cat3SubType.carrier
  paperSource :=
    "Li 2026, `\\label{def:op-individuation}` and " ++
    "`\\label{def:op-properties}`"
  attackHistory := [
    "v0.3.0 sub-type classification: carrier — paper-introduced " ++
      "primitive type for an operationalisation (Boolean-valued " ++
      "verdict-map parametrised by its partition-member " ++
      "faithfulness).  Definitional atom."
  ]
  scope :=
    "Typed structural carrier for an operationalisation as a " ++
    "Boolean-valued verdict-map parametrised by its partition-" ++
    "member faithfulness.  Encoded as a Lean `structure`."
}

def gap_ArbitrationProcedure_carrier : GapEntry := {
  name := "ArbitrationProcedure (structure)"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.carrier
  paperSource := "Li 2026, `\\label{def:op-properties}` P2"
  attackHistory := [
    "v0.3.0 sub-type classification: carrier — paper-introduced " ++
      "primitive type for an arbitration procedure between " ++
      "operationalisations (adjudicate function + " ++
      "partitionRelative + warrantInternalToE Prop fields).  " ++
      "Definitional atom; `lem_prw_reduction` is the structural " ++
      "equation that operates over this carrier."
  ]
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
  cat3SubType := Cat3SubType.carrier
  paperSource :=
    "Li 2026, §11 (Distributed Statistical Cognition replacement " ++
    "vocabulary preliminaries)"
  attackHistory := [
    "v0.3.0 sub-type classification: carrier — paper-introduced " ++
      "primitive type for an abstract cognitive system (token / " ++
      "weight / activation / session / instance / context spaces " ++
      "+ inferenceOp + six DSC-axis Prop fields).  Definitional " ++
      "atom underwriting the DSC vocabulary."
  ]
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
  cat3SubType := Cat3SubType.carrier
  paperSource := "Li 2026, `\\label{def:sc}`"
  attackHistory := [
    "v0.3.0 sub-type classification: carrier — paper-introduced " ++
      "primitive type packaging the six SC commitments (V1–V6) " ++
      "as Prop-valued fields paralleling the DSC axes."
  ]
  scope :=
    "Typed structural carrier for the six SC commitments (V1–V6) " ++
    "as Prop-valued fields paralleling the DSC axes.  Encoded " ++
    "as a Lean `structure`."
}

def gap_BridgingPrinciple_carrier : GapEntry := {
  name := "BridgingPrinciple (structure)"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.carrier
  paperSource := "Li 2026, `\\label{def:bridging}`"
  attackHistory := [
    "v0.3.0 sub-type classification: carrier — paper-introduced " ++
      "primitive type packaging (B1) bijective correspondence + " ++
      "mutual independence + joint sufficiency + (B2) point-of-" ++
      "view non-translatability into a single bridging-principle " ++
      "object parametrised by (S, SC)."
  ]
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
  cat3SubType := Cat3SubType.notCat3
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
  cat3SubType := Cat3SubType.notCat3
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
  cat3SubType := Cat3SubType.notCat3
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
  cat3SubType := Cat3SubType.notCat3
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
  cat3SubType := Cat3SubType.notCat3
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
  cat3SubType := Cat3SubType.notCat3
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
  cat3SubType := Cat3SubType.notCat3
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
  cat3SubType := Cat3SubType.notCat3
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
  cat3SubType := Cat3SubType.notCat3
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
  cat3SubType := Cat3SubType.notCat3
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
  cat3SubType := Cat3SubType.notCat3
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
  cat3SubType := Cat3SubType.notCat3
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
  cat3SubType := Cat3SubType.notCat3
  paperSource :=
    "Li 2026, `\\label{thm:impossibility}` (uniform application " ++
    "to the family `{Op_1, …, Op_n}`)"
  attackHistory := []
  scope :=
    "Impossibility transfers uniformly across the operationalisation " ++
    "family.  Pure pointwise application of `thm_impossibility`."
}

def gap_thm_impossibility_paper_form_CLOSED : GapEntry := {
  name := "thm_impossibility_paper_form"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.notInput
  cat3SubType := Cat3SubType.notCat3
  paperSource :=
    "Li 2026, `\\label{thm:impossibility}` (paper-level " ++
    "`¬ (P2 ∧ P3)` conclusion) + paragraph `The load-bearing " ++
    "clause and its Lean encoding` (Boolean-encoding bridge)"
  attackHistory := [
    "v0.2.0 audit (2026-05-13): added to capture the paper-level " ++
      "`¬ (P2 ∧ P3)` form as a derived corollary of `thm_" ++
      "impossibility` (load-bearing `¬ P2`) + `satisfiesP3_of_" ++
      "boolean` (trivial-P3 from Boolean-typing).  Paper " ++
      "modification: paragraph `The load-bearing clause and its " ++
      "Lean encoding` added immediately after the proof of " ++
      "`\\label{thm:impossibility}` to make the equivalence " ++
      "explicit."
  ]
  scope :=
    "`¬ (SatisfiesP2 ∧ SatisfiesP3)` under (H) and " ++
    "`\\label{def:unranked}`.  Derived by `thm_impossibility` " ++
    "(load-bearing `¬ P2`) plus `And` elimination; the P3 " ++
    "conjunct is discharged by the Boolean-verdict encoding " ++
    "(see `satisfiesP3_of_boolean`).  No new axiom required."
}

/-! ### gapBlocked entries — structural content deferred from the
     formalization with an explicit reason.

  Each gapBlocked entry records structural mathematics in the paper
  that *could* be partially Lean-formalized but where the
  substantive content lies in philosophical-discursive argument or
  empirical premises outside Lean's structural-skeleton scope.
  These are recorded here so that future audit rounds do not re-
  attack the gap thinking it is openable; the gap is intentionally
  blocked with reason.
-/

def gap_thesis_independence_BLOCKED : GapEntry := {
  name := "thesis_independence (DSC axis mutual independence)"
  status := GapStatus.gapBlocked
  inputCategory := InputCategory.notInput
  cat3SubType := Cat3SubType.notCat3
  paperSource :=
    "Li 2026, `\\label{thesis:independence}` (Mutual independence " ++
    "of the six DSC axes; six independence-witness arguments)"
  attackHistory := []
  scope :=
    "The paper supplies six `coherent hypothetical system` " ++
    "witnesses — for each axis, a system that fails it while " ++
    "satisfying the other five.  Lean-formalisation as six " ++
    "existence-of-`CognitiveSystem`-with-Boolean-axis-assignments " ++
    "is trivial (the Prop-valued axis fields permit arbitrary " ++
    "assignments), but the substantive content is the *coherent* " ++
    "system argument (whether such a system is conceptually " ++
    "possible given LLM-relevant architectural commitments), which " ++
    "is philosophical-discursive, not structural-mathematical.  " ++
    "Blocked: substantive content lies outside Lean's structural " ++
    "skeleton.  Reattempting would require carriers for " ++
    "`architecturally-coherent system instantiation` that the " ++
    "paper does not formalise."
}

def gap_thesis_joint_BLOCKED : GapEntry := {
  name := "thesis_joint (DSC joint satisfaction for current LLMs)"
  status := GapStatus.gapBlocked
  inputCategory := InputCategory.notInput
  cat3SubType := Cat3SubType.notCat3
  paperSource :=
    "Li 2026, `\\label{thesis:joint}` (Joint satisfaction for " ++
    "current LLMs)"
  attackHistory := []
  scope :=
    "Empirical claim: contemporary transformer-based " ++
    "autoregressive LLMs jointly satisfy the six DSC axes.  This " ++
    "is a substrate-empirical assertion about contemporary " ++
    "deployed systems, not a structural-mathematical claim.  " ++
    "Blocked: not Lean-formalisable as structural content."
}

def gap_thesis_minimality_BLOCKED : GapEntry := {
  name := "thesis_minimality (DSC minimality wrt blocking jobs)"
  status := GapStatus.gapBlocked
  inputCategory := InputCategory.notInput
  cat3SubType := Cat3SubType.notCat3
  paperSource :=
    "Li 2026, `\\label{thesis:minimality}` (Minimality with " ++
    "respect to identified blocking jobs)"
  attackHistory := []
  scope :=
    "For each of the six DSC axes, the paper exhibits a " ++
    "biological-vocabulary locution that the remaining five " ++
    "jointly fail to block.  Lean-formalisation would require a " ++
    "carrier type for `biological-vocabulary leak categories` and " ++
    "a `blocks` relation between axes and locutions; the paper " ++
    "supplies natural-language locutions (`the system is " ++
    "reflecting on yesterday's session` etc.) rather than a " ++
    "typed locution-space.  Blocked: paper-supplied locutions are " ++
    "outside Lean's structural-mathematical scope.  Future " ++
    "formalisation would require an additional carrier the paper " ++
    "does not define."
}

def gap_substrate_independence_triple_use_BLOCKED : GapEntry := {
  name := "substrate_independence_triple_use_premise"
  status := GapStatus.gapBlocked
  inputCategory := InputCategory.notInput
  cat3SubType := Cat3SubType.notCat3
  paperSource :=
    "Li 2026, calibration-section `\\S\\ref{sec:discriminator}` " ++
    "paragraph `Acknowledgement: Route~2 shares load-bearing " ++
    "premise with E2b transferability AND impossibility-theorem-" ++
    "application` (the substrate-independence premise does triple " ++
    "duty: (a) E2b transferability; (b) D1 Route 2; (c) " ++
    "impossibility-theorem application to LLM target)"
  attackHistory := []
  scope :=
    "Paper-stated structural relationship: a single empirical " ++
    "premise (substrate-independence at cognitive-neuroscience " ++
    "resolution) underwrites three downstream framework uses.  " ++
    "Lean-formalisation as a single `Prop` premise with three " ++
    "downstream conclusions is possible but requires the framework " ++
    "to commit to a specific structural form for substrate-" ++
    "independence (e.g., as a relation over " ++
    "`CognitiveSystem`-pairs) that the paper articulates " ++
    "informally.  Blocked: paper-side articulation insufficient " ++
    "for a typed-relation encoding without inventing structural " ++
    "commitments not present in the paper.  Future formalisation " ++
    "would require axiomatising substrate-independence at a " ++
    "level the paper does not."
}

def gap_testimony_protocol_BLOCKED : GapEntry := {
  name := "prot_testimony (T1–T4 testimony conditions)"
  status := GapStatus.gapBlocked
  inputCategory := InputCategory.notInput
  cat3SubType := Cat3SubType.notCat3
  paperSource :=
    "Li 2026, `\\label{prot:testimony}` (T1–T4 evidential-status " ++
    "conditions for LLM self-reports)"
  attackHistory := []
  scope :=
    "Protocol with four conditions (non-eliciting prompt; cross-" ++
    "instance corroboration; intra-context stability under " ++
    "temperature sampling; etc.) for granting LLM self-reports " ++
    "evidential status relative to the SC vocabulary.  This is " ++
    "an epistemology-of-evidence proposal — operational criteria " ++
    "for sampling-based corroboration of self-reports — not " ++
    "structural mathematics that Lean checks.  Blocked: outside " ++
    "Lean's structural-mathematical scope."
}

def gap_calibration_table_BLOCKED : GapEntry := {
  name := "tab_calibration (ten-case historical retrodiction)"
  status := GapStatus.gapBlocked
  inputCategory := InputCategory.notInput
  cat3SubType := Cat3SubType.notCat3
  paperSource :=
    "Li 2026, `\\label{tab:calibration}` and `\\label{sec:" ++
    "calibration}` (ten paradigm cases — heat, gene, force, " ++
    "attention, memory, phlogiston, vital force, race, witchcraft, " ++
    "instinct — retrodicted by the discriminator)"
  attackHistory := []
  scope :=
    "Per-case empirical-judgement assignments of D1/D2/D3 ratings " ++
    "to ten historical concepts.  The discriminator *rules* are " ++
    "Lean-formalised (`Diagnostic.lean`); the per-case *labels* " ++
    "rest on historical-empirical judgement and are not " ++
    "structural mathematics.  Blocked: empirical content outside " ++
    "Lean's structural-skeleton scope."
}

def gap_ai_governance_applications_BLOCKED : GapEntry := {
  name := "ai_governance_applications (Part IV)"
  status := GapStatus.gapBlocked
  inputCategory := InputCategory.notInput
  cat3SubType := Cat3SubType.notCat3
  paperSource :=
    "Li 2026, Part IV (Applications to AI Governance) — moral " ++
    "status, autonomy, responsibility, personhood as four " ++
    "contested AI-governance predicates"
  attackHistory := []
  scope :=
    "Sketches of how the diagnostic framework operates on four " ++
    "contested AI-governance predicates, with operational " ++
    "structural-property substitutes proposed for each.  These " ++
    "are policy-application sketches, not theorems.  Blocked: " ++
    "outside Lean's structural-mathematical scope; substantive " ++
    "content is policy design downstream of the framework."
}

/-! ### Aggregated ledger inventory. -/

/-- All gap entries in canonical order. -/
def allGaps : List GapEntry := [
  -- Cat 3 paper-novel atomic structural reduction
  gap_lem_prw_reduction,
  -- Cat 3 paper-novel carrier types and predicates (structures, not axioms)
  gap_ReverseDefinedConcept_carrier,
  gap_ReverseDefinedWitness_carrier,
  gap_AsymmetricEliminationVerdict_carrier,
  gap_DiagnosticProfile_carrier,
  gap_UseSeparability_carrier,
  gap_FaithfulP1_carrier,
  gap_DiscriminatorRow_carrier,
  gap_MutuallyUnrankedPartition_carrier,
  gap_Operationalisation_carrier,
  gap_ArbitrationProcedure_carrier,
  gap_CognitiveSystem_carrier,
  gap_SessionalCognition_carrier,
  gap_BridgingPrinciple_carrier,
  -- gapClosed top-level results
  gap_thm_impossibility_CLOSED,
  gap_thm_impossibility_paper_form_CLOSED,
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
  gap_impossibility_uniform_family_CLOSED,
  -- gapBlocked entries (paper-side structural content with explicit reason)
  gap_thesis_independence_BLOCKED,
  gap_thesis_joint_BLOCKED,
  gap_thesis_minimality_BLOCKED,
  gap_substrate_independence_triple_use_BLOCKED,
  gap_testimony_protocol_BLOCKED,
  gap_calibration_table_BLOCKED,
  gap_ai_governance_applications_BLOCKED
]

/-- Status-keyed counts:
    `(open, partial, blocked, deadEnd, closed, closedConditional)`. -/
def gapCounts : Nat × Nat × Nat × Nat × Nat × Nat :=
  let countWhere (s : GapStatus) : Nat :=
    (allGaps.filter (fun g => g.status = s)).length
  ( countWhere GapStatus.gapOpen
  , countWhere GapStatus.gapPartial
  , countWhere GapStatus.gapBlocked
  , countWhere GapStatus.gapDeadEnd
  , countWhere GapStatus.gapClosed
  , countWhere GapStatus.gapClosedConditional )

/-- InputCategory-keyed counts:
    `(cat1Mathlib, cat2External, cat3PaperNovel, notInput)`. -/
def inputCategoryCounts : Nat × Nat × Nat × Nat :=
  let countWhere (c : InputCategory) : Nat :=
    (allGaps.filter (fun g => g.inputCategory = c)).length
  ( countWhere InputCategory.cat1Mathlib
  , countWhere InputCategory.cat2External
  , countWhere InputCategory.cat3PaperNovel
  , countWhere InputCategory.notInput )

/-- Cat3SubType-keyed counts:
    `(carrier, hypothesisPredicate, structuralEquation, workingAssumption,
       conditionalHypothesis, notCat3)`. -/
def cat3SubTypeCounts : Nat × Nat × Nat × Nat × Nat × Nat :=
  let countWhere (s : Cat3SubType) : Nat :=
    (allGaps.filter (fun g => g.cat3SubType = s)).length
  ( countWhere Cat3SubType.carrier
  , countWhere Cat3SubType.hypothesisPredicate
  , countWhere Cat3SubType.structuralEquation
  , countWhere Cat3SubType.workingAssumption
  , countWhere Cat3SubType.conditionalHypothesis
  , countWhere Cat3SubType.notCat3 )

#eval s!"AsymmetricEliminativism gap-ledger inventory (status):    open={(gapCounts).1} partial={(gapCounts).2.1} blocked={(gapCounts).2.2.1} deadEnd={(gapCounts).2.2.2.1} closed={(gapCounts).2.2.2.2.1} closedConditional={(gapCounts).2.2.2.2.2}"

#eval s!"AsymmetricEliminativism gap-ledger inventory (input):     cat1Mathlib={(inputCategoryCounts).1} cat2External={(inputCategoryCounts).2.1} cat3PaperNovel={(inputCategoryCounts).2.2.1} notInput={(inputCategoryCounts).2.2.2}"

#eval s!"AsymmetricEliminativism gap-ledger inventory (Cat 3 sub): carrier={(cat3SubTypeCounts).1} hypothesisPredicate={(cat3SubTypeCounts).2.1} structuralEquation={(cat3SubTypeCounts).2.2.1} workingAssumption={(cat3SubTypeCounts).2.2.2.1} conditionalHypothesis={(cat3SubTypeCounts).2.2.2.2.1} notCat3={(cat3SubTypeCounts).2.2.2.2.2}"

#eval s!"Total entries: {allGaps.length}"

/-! ### Inventory summary

  The live status / input-category / Cat 3 sub-type counts are
  printed by the `#eval` calls above (run `lake env lean
  AsymmetricEliminativism/Ledger.lean` to see them).  The axiom /
  carrier / predicate inventory:

    Cat 3 paper-novel atomic structural reduction (Li 2026 internal
    claim; sub-type `structuralEquation`):
      lem_prw_reduction
        — Lemma `\label{lem:prw}`; load-bearing for
          `thm_impossibility` (and, transitively, for
          `thm_impossibility_paper_form`).

    Cat 3 paper-novel typed carriers (encoded as Lean structures /
    classes, NOT as `axiom` declarations; sub-type `carrier`):
      ReverseDefinedConcept, ReverseDefinedWitness,
      DiagnosticProfile, MutuallyUnrankedPartition,
      Operationalisation, ArbitrationProcedure,
      CognitiveSystem, SessionalCognition, BridgingPrinciple,
      DiscriminatorRow.

    Cat 3 paper-novel hypothesis/scope predicates (encoded as Lean
    structures bundling Prop-valued scope conditions; sub-type
    `hypothesisPredicate`):
      AsymmetricEliminationVerdict, UseSeparability, FaithfulP1.

  Lean kernel (Cat 0; not declared here):
    propext, Classical.choice, Quot.sound.

  Project has *zero* Cat 1 axioms (no Mathlib-derivability claims
  pending discharge) and *zero* Cat 2 axioms (no external
  textbook citations).  The single Cat 3 atomic structural
  reduction `lem_prw_reduction` carries the load-bearing
  consequence of paper Lemma `\label{lem:prw}`; the lemma's
  *justification* is the paper's case-analysis proof and is not
  separately formalised.

  Cat 3 sub-types not used in this project: `workingAssumption`
  (no provisional bundles pending derivation), `conditionalHypothesis`
  (no external-open-problem-conditional results).

  *gapBlocked entries.*  Several paper-side claims of structural
  flavour are recorded as `gapBlocked` rather than `gapClosed`,
  because their substantive content lies outside Lean's structural-
  skeleton scope (philosophical-discursive arguments; substrate-
  empirical premises; per-case historical-empirical judgement;
  policy-application sketches).  Each gapBlocked entry carries an
  explicit reason for the block; future audit rounds should not
  reattack these gaps thinking they are openable.

  *Cat 3 ratio guard (v6 §3.4.6).*  Cat 3 ratio = 100% (14/14
  paper-side atomic inputs are Cat 3; 0 Cat 1, 0 Cat 2).  The
  paper is fundamentally philosophical (per v0.2.0 audit report)
  and the only axiom is `lem_prw_reduction`; the remaining 13
  Cat 3 entries are typed carriers / scope predicates encoded as
  Lean `structure` declarations, not opaque-axiom Cat 3 claims.
  The ratio is high BECAUSE all paper-novel structural objects
  are carriers/predicates (Cat 3 sub-types `carrier` /
  `hypothesisPredicate`), not because reductionism rounds were
  skipped.  The v6 §3.4.6 ≥2-round hostile reductionism review
  should focus on:
    (a) verifying each carrier is genuinely paper-novel typed
        primitive (not derivable from Mathlib type theory — e.g.
        is `MutuallyUnrankedPartition` more than a Mathlib
        `Setoid`-like decomposition? is `DiscriminatorRow` more
        than a Mathlib `Vector`-of-`DiagnosticRating`?);
    (b) verifying `lem_prw_reduction` is genuinely paper-novel
        (not a Cat 2 reduction missed — e.g. is the warrant-to-
        partition-weighting reduction covered by any external
        social-choice or arbitration-theory result on similarly-
        typed objects?).
  v0.3.0 records per-entry reductionism notes in `attackHistory`
  fields with CLEAR-NO verdicts on (a) and (b) for
  `lem_prw_reduction`; per-carrier deep reductionism rounds
  (Cat 1 / Cat 2 / Cat 3 carrier-novelty audit) are
  deferred to a separate workflow.
-/

end AsymmetricEliminativism.Ledger
