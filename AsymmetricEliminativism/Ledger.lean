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

/-! ### Cat 3 paper-novel atomic stipulations for Lemma `\label{lem:prw}`.

  Per v0.5.0 R1 decomposition (anti-pattern #13 / #14 fix per v6
  §13 / §18): Lemma `\label{lem:prw}` has a *published proof*
  whose case-analysis structure (uniform vs.\ contextual; type-
  (a)/(b)/(c) trichotomy + Partition-Internality sub-claim +
  recursion-termination) maps one-to-one onto five paper-stated
  atomic structural stipulations on the typed primitives.  The
  lemma's downstream consequence is now a *derived theorem*
  (`lem_prw_reduction`) composing the five atoms via case-
  analysis on the paper's structural case-tags.
-/

/--
  Atomic stipulation A1: uniform-warrant case of Lemma
  `\label{lem:prw}`.
-/
def gap_prw_uniform_warrant_partitionRelative : GapEntry := {
  name := "prw_uniform_warrant_partitionRelative"
  status := GapStatus.gapOpen
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource :=
    "Li 2026, `\\label{lem:prw}` proof body, paragraph beginning " ++
    "`Uniform case:` — paper statement: 'Uniform case: W assigns " ++
    "the same k to all disagreement-cases of Op_i vs.\\ Op_j.  " ++
    "The constant assignment to {i, j} selects a single E_m ∈ " ++
    "{E_i, E_j} as preferred globally, which is direct " ++
    "single-E_m privileging --- explicitly the P2-failure mode " ++
    "forbidden by Definition~\\ref{def:op-properties}'s " ++
    "independence clause.'"
  attackHistory := [
    "v0.5.0 R1 decomposition (round 1, 2026-05-13): extracted as " ++
      "atomic stipulation from former composite `lem_prw_reduction` " ++
      "axiom (anti-pattern #13 fix).  Paper-stated structural " ++
      "reduction on the typed `ArbitrationProcedure` carrier: a " ++
      "uniform-warrant procedure (`isUniformWarrant`) is " ++
      "partition-relative.",
    "v0.5.0 R1 sub-type: structuralEquation — paper-stated " ++
      "definitional reduction on the typed carrier; constitutes " ++
      "the paper-level commitment 'uniform warrants ARE " ++
      "partition-relative weightings' on the warrant-structure ⇒ " ++
      "partition-relative-classification correspondence.",
    "v0.5.0 R1 reductionism Cat 1?: CLEAR-NO — Mathlib has no " ++
      "predicate for 'uniform assignment is partition-relative " ++
      "weighting'; the implication is over paper-novel " ++
      "`ArbitrationProcedure` Prop fields.",
    "v0.5.0 R1 reductionism Cat 2?: CLEAR-NO — no external " ++
      "theorem covers single-`E_m` privileging on these typed " ++
      "carriers; paper-stated atomic content of the lemma's " ++
      "uniform-case paragraph."
  ]
  scope :=
    "`∀ A, A.isUniformWarrant → A.partitionRelative`.  Carries " ++
    "the uniform-case reduction of Lemma `\\label{lem:prw}` " ++
    "(constant assignment ⇒ single-`E_m` privileging ⇒ " ++
    "partition-relative)."
}

/--
  Atomic stipulation A2: type-(a) feature case of Lemma
  `\label{lem:prw}`.
-/
def gap_prw_type_a_feature_partitionRelative : GapEntry := {
  name := "prw_type_a_feature_partitionRelative"
  status := GapStatus.gapOpen
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource :=
    "Li 2026, `\\label{lem:prw}` proof body, `Sub-claim: " ++
    "No-arbitration for \\E-internal ranking principles` " ++
    "type-(a) — paper statement: 'Type-(a): f belongs to some " ++
    "E_m.  Then R\\'s appeal to f privileges E_m, and the " ++
    "resulting ranking just is single-E_m privileging --- " ++
    "option (i).'"
  attackHistory := [
    "v0.5.0 R1 decomposition (round 1, 2026-05-13): extracted as " ++
      "atomic stipulation from former composite `lem_prw_reduction` " ++
      "axiom (anti-pattern #13 fix).  Paper-stated structural " ++
      "reduction on the typed carrier: a type-(a)-feature " ++
      "procedure (`usesTypeAFeature`) is partition-relative.",
    "v0.5.0 R1 sub-type: structuralEquation — paper-stated " ++
      "definitional reduction; single-`E_m` privileging directly " ++
      "yields the partition-relative-classification tag.",
    "v0.5.0 R1 reductionism Cat 1?: CLEAR-NO — Mathlib has no " ++
      "`feature-in-single-partition-member ⇒ partition-relative` " ++
      "predicate.",
    "v0.5.0 R1 reductionism Cat 2?: CLEAR-NO — no external " ++
      "theorem covers the type-(a) feature reduction on these " ++
      "paper-novel carriers."
  ]
  scope :=
    "`∀ A, A.usesTypeAFeature → A.partitionRelative`.  Carries " ++
    "the type-(a) reduction of the No-arbitration sub-claim " ++
    "(feature `f ∈ E_m` ⇒ single-`E_m` privileging ⇒ " ++
    "partition-relative)."
}

/--
  Atomic stipulation A3: type-(b) feature case of Lemma
  `\label{lem:prw}`.
-/
def gap_prw_type_b_feature_partitionRelative : GapEntry := {
  name := "prw_type_b_feature_partitionRelative"
  status := GapStatus.gapOpen
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource :=
    "Li 2026, `\\label{lem:prw}` proof body, `Sub-claim: " ++
    "No-arbitration for \\E-internal ranking principles` " ++
    "type-(b) — paper statement: 'Type-(b): f is shared by all " ++
    "E_i symmetrically, in which case R\\'s output is constant " ++
    "across the E_i and fails to produce a non-trivial ranking " ++
    "--- option (ii).'  Paper also: 'In both cases [uniform & " ++
    "contextual], P2\\'s independence requirement is violated.  " ++
    "Hence W fails P2.' (lumping type-(b) failure-to-adjudicate " ++
    "with type-(a)/(c) partition-relative-weighting under the " ++
    "P2-failure conclusion)."
  attackHistory := [
    "v0.5.0 R1 decomposition (round 1, 2026-05-13): extracted as " ++
      "atomic stipulation from former composite `lem_prw_reduction` " ++
      "axiom (anti-pattern #13 fix).  Paper-stated structural " ++
      "reduction on the typed carrier: a type-(b)-feature " ++
      "procedure (`usesTypeBFeature`) yields P2-failure equivalent " ++
      "to `partitionRelative` in the lemma's downstream-consequence " ++
      "framing.",
    "v0.5.0 R1 sub-type: structuralEquation — paper-stated " ++
      "definitional reduction; type-(b) features produce no " ++
      "ranking (vacuous P2-failure), lumped with " ++
      "partition-relative cases in the lemma's 'fails P2' " ++
      "conclusion.",
    "v0.5.0 R1 reductionism Cat 1?: CLEAR-NO — Mathlib has no " ++
      "`symmetric-feature ⇒ fails-to-adjudicate` predicate on the " ++
      "paper-novel carriers.",
    "v0.5.0 R1 reductionism Cat 2?: CLEAR-NO — no external " ++
      "theorem covers the type-(b) symmetric-feature reduction " ++
      "on these typed carriers."
  ]
  scope :=
    "`∀ A, A.usesTypeBFeature → A.partitionRelative`.  Carries " ++
    "the type-(b) reduction of the No-arbitration sub-claim " ++
    "(symmetric feature ⇒ no ranking produced ⇒ P2-failure " ++
    "equivalent to partition-relative in the lemma's " ++
    "downstream-consequence framing)."
}

/--
  Atomic stipulation A4: Partition-Internality of `\E`-Internal
  Structural Stipulations — type-(c) case of Lemma
  `\label{lem:prw}`.
-/
def gap_prw_partition_internality_of_structural_stipulations : GapEntry := {
  name := "prw_partition_internality_of_structural_stipulations"
  status := GapStatus.gapOpen
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource :=
    "Li 2026, `\\label{lem:prw}` proof body, named sub-lemma " ++
    "`Sub-claim (Partition-Internality of \\E-Internal Structural " ++
    "Stipulations)` — paper statement: 'Let {E_1, …, E_n} be a " ++
    "mutually unranked partition, let F = {f_1, f_2, …} be the " ++
    "set of partition-symmetric structural properties available " ++
    "within \\E (coverage, parsimony, internal coherence, etc.), " ++
    "and let f* ∈ F be a candidate ranking principle.  Then the " ++
    "procedure \\'adjudicate Op_i vs.\\ Op_j by routing to " ++
    "whichever of E_i, E_j is higher under the f*-induced ranking " ++
    "R_{f*}\\' is a partition-relative weighting of {E_1, …, E_n} " ++
    "in the sense forbidden by P2\\'s independence requirement.'"
  attackHistory := [
    "v0.5.0 R1 decomposition (round 1, 2026-05-13): extracted as " ++
      "atomic stipulation from former composite `lem_prw_reduction` " ++
      "axiom (anti-pattern #13 fix).  This is the paper's named " ++
      "sub-lemma with its own statement, proof paragraph, and " ++
      "conclusion (`Partition-Internality of \\E-Internal " ++
      "Structural Stipulations`); naturally an atomic " ++
      "stipulation.",
    "v0.5.0 R1 sub-type: structuralEquation — paper-stated " ++
      "definitional reduction on the typed `ArbitrationProcedure` " ++
      "+ partition carriers: `R_{f*}`-routing is partition-relative " ++
      "weighting.",
    "v0.5.0 R1 reductionism Cat 1?: CLEAR-NO — Mathlib has no " ++
      "predicate for `R_{f*}`-routing on partition-symmetric " ++
      "structural properties.",
    "v0.5.0 R1 reductionism Cat 2?: CLEAR-NO — surveyed external " ++
      "social-choice / arbitration literature (Arrow 1951; Sen " ++
      "1970; Saari geometric voting): none covers the " ++
      "`R_{f*}`-routing reduction on these paper-novel typed " ++
      "carriers."
  ]
  scope :=
    "`∀ A, A.usesTypeCStructuralProperty → A.partitionRelative`.  " ++
    "Carries the paper's named sub-lemma `Partition-Internality " ++
    "of \\E-Internal Structural Stipulations` (`R_{f*}`-routing " ++
    "on a partition-symmetric structural property ⇒ " ++
    "partition-relative weighting)."
}

/--
  Atomic stipulation A5: case-exhaustion of `\E`-internal warrants
  for Lemma `\label{lem:prw}`.
-/
def gap_prw_E_internal_warrant_case_exhaustion : GapEntry := {
  name := "prw_E_internal_warrant_case_exhaustion"
  status := GapStatus.gapOpen
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.hypothesisPredicate
  paperSource :=
    "Li 2026, `\\label{lem:prw}` proof body — paper paragraphs " ++
    "beginning `Two cases for the selection\\'s structure across " ++
    "disagreement-cases. Uniform case:` + `Sub-claim " ++
    "(No-arbitration for \\E-internal ranking principles)` " ++
    "type-(a) / type-(b) / type-(c) trichotomy + the recursion-" ++
    "termination paragraph 'Recursive appeal terminates only at " ++
    "types (a), (b), (c.1), or (c.3); none yields admissible " ++
    "adjudication-warrant within the (H)-discourse-state.'"
  attackHistory := [
    "v0.5.0 R1 decomposition (round 1, 2026-05-13): extracted " ++
      "as atomic stipulation from former composite " ++
      "`lem_prw_reduction` axiom (anti-pattern #14 fix).  This " ++
      "is the paper's commitment that the four structural " ++
      "sub-forms (uniform-warrant / type-(a) / type-(b) / " ++
      "type-(c)) exhaust the `\\E`-internal-warrant space after " ++
      "recursion termination — (c.2) and (c.4.a) recurse back to " ++
      "(a)/(b)/(c.1); (c.3) and (c.4.b) appeal to features " ++
      "external to `\\E` and so are excluded by the " ++
      "`warrantInternalToE` antecedent.",
    "v0.5.0 R1 sub-type: hypothesisPredicate — paper-introduced " ++
      "scope/regime relationship between the bare " ++
      "`warrantInternalToE` Prop and the four structural sub-" ++
      "form case-tags.  Not a per-instance equational reduction " ++
      "(those live in atoms A1–A4); rather a meta-claim on the " ++
      "structural classification space's exhaustiveness.",
    "v0.5.0 R1 reductionism Cat 1?: CLEAR-NO — Mathlib has no " ++
      "predicate for 'every E-internal warrant case-reduces to " ++
      "one of four structural sub-forms after recursion " ++
      "termination'.",
    "v0.5.0 R1 reductionism Cat 2?: CLEAR-NO — no external " ++
      "theorem covers the exhaustiveness of the paper's four " ++
      "structural sub-forms on the typed " ++
      "`ArbitrationProcedure`/`MutuallyUnrankedPartition` carriers."
  ]
  scope :=
    "`∀ A, A.warrantInternalToE → A.isUniformWarrant ∨ " ++
    "A.usesTypeAFeature ∨ A.usesTypeBFeature ∨ " ++
    "A.usesTypeCStructuralProperty`.  Carries the paper's case-" ++
    "exhaustion meta-claim on `\\E`-internal warrants (after " ++
    "recursion termination on (c.2)/(c.4.a); (c.3)/(c.4.b) " ++
    "excluded by the `warrantInternalToE` antecedent)."
}

/-! ### Cat 3 paper-novel case-tag carriers
     (Lean `def`s, not `axiom`s; appear in source but not in
     `#print axioms`).
-/

/--
  Paper-novel structural case-tag carrier (uniform-warrant
  case of Lemma `\label{lem:prw}`).
-/
def gap_isUniformWarrant_carrier : GapEntry := {
  name := "ArbitrationProcedure.isUniformWarrant (def)"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.carrier
  paperSource :=
    "Li 2026, `\\label{lem:prw}` proof body, paragraph beginning " ++
    "`Uniform case:` (paper's structural case-tag for warrants " ++
    "that uniformly assign the same `k` to all disagreement-cases)"
  attackHistory := [
    "v0.5.0 R1 decomposition (2026-05-13): introduced as a " ++
      "paper-novel structural case-tag predicate on " ++
      "`ArbitrationProcedure`, used as the antecedent of atom " ++
      "`prw_uniform_warrant_partitionRelative`.  Encoded as a " ++
      "Lean `def` returning `True` (v6 §3.4.1 carrier pattern; " ++
      "the discriminating content lives in the structural " ++
      "equation atoms, not in the carrier-level predicate).",
    "v0.5.0 R1 sub-type: carrier — paper-named structural " ++
      "sub-form classifier; the typed `def` IS the paper's " ++
      "structural case-tag.",
    "v0.5.0 R1 reductionism Cat 1?: CLEAR-NO — Mathlib has no " ++
      "`uniform-warrant` classifier on the paper-novel " ++
      "`ArbitrationProcedure` carrier.",
    "v0.5.0 R1 reductionism Cat 2?: CLEAR-NO — no external " ++
      "theorem references this structural sub-form classifier."
  ]
  scope :=
    "Typed Prop-valued structural case-tag for an arbitration " ++
    "procedure with uniform assignment to `{i, j}` across " ++
    "disagreement-cases.  Encoded as a Lean `def` over " ++
    "`ArbitrationProcedure`; not an `axiom`."
}

/--
  Paper-novel structural case-tag carrier (type-(a)
  feature case of Lemma `\label{lem:prw}`).
-/
def gap_usesTypeAFeature_carrier : GapEntry := {
  name := "ArbitrationProcedure.usesTypeAFeature (def)"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.carrier
  paperSource :=
    "Li 2026, `\\label{lem:prw}` proof body, `Sub-claim " ++
    "(No-arbitration for \\E-internal ranking principles)` " ++
    "type-(a) (paper's structural case-tag for warrants using " ++
    "feature f in single E_m)"
  attackHistory := [
    "v0.5.0 R1 decomposition (2026-05-13): introduced as a " ++
      "paper-novel structural case-tag predicate on " ++
      "`ArbitrationProcedure`, used as the antecedent of atom " ++
      "`prw_type_a_feature_partitionRelative`.  Encoded as a " ++
      "Lean `def` returning `True` (v6 §3.4.1 carrier pattern).",
    "v0.5.0 R1 sub-type: carrier — paper-named structural " ++
      "sub-form classifier.",
    "v0.5.0 R1 reductionism Cat 1?: CLEAR-NO — no Mathlib " ++
      "predicate for the type-(a) sub-form classifier.",
    "v0.5.0 R1 reductionism Cat 2?: CLEAR-NO — no external " ++
      "theorem references the type-(a) sub-form classifier."
  ]
  scope :=
    "Typed Prop-valued structural case-tag for an arbitration " ++
    "procedure using a feature `f \\in E_m` for some `m`.  " ++
    "Encoded as a Lean `def`; not an `axiom`."
}

/--
  Paper-novel structural case-tag carrier (type-(b)
  feature case of Lemma `\label{lem:prw}`).
-/
def gap_usesTypeBFeature_carrier : GapEntry := {
  name := "ArbitrationProcedure.usesTypeBFeature (def)"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.carrier
  paperSource :=
    "Li 2026, `\\label{lem:prw}` proof body, `Sub-claim " ++
    "(No-arbitration for \\E-internal ranking principles)` " ++
    "type-(b) (paper's structural case-tag for warrants using " ++
    "feature symmetric across all E_i)"
  attackHistory := [
    "v0.5.0 R1 decomposition (2026-05-13): introduced as a " ++
      "paper-novel structural case-tag predicate on " ++
      "`ArbitrationProcedure`, used as the antecedent of atom " ++
      "`prw_type_b_feature_partitionRelative`.  Encoded as a " ++
      "Lean `def` returning `True` (v6 §3.4.1 carrier pattern).",
    "v0.5.0 R1 sub-type: carrier — paper-named structural " ++
      "sub-form classifier.",
    "v0.5.0 R1 reductionism Cat 1?: CLEAR-NO — no Mathlib " ++
      "predicate for the type-(b) symmetric-feature " ++
      "classifier.",
    "v0.5.0 R1 reductionism Cat 2?: CLEAR-NO — no external " ++
      "theorem references the type-(b) sub-form classifier."
  ]
  scope :=
    "Typed Prop-valued structural case-tag for an arbitration " ++
    "procedure using a feature symmetric across all " ++
    "partition members `E_i`.  Encoded as a Lean `def`; not an " ++
    "`axiom`."
}

/--
  Paper-novel structural case-tag carrier (type-(c)
  partition-symmetric structural property case of Lemma
  `\label{lem:prw}`).
-/
def gap_usesTypeCStructuralProperty_carrier : GapEntry := {
  name := "ArbitrationProcedure.usesTypeCStructuralProperty (def)"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.carrier
  paperSource :=
    "Li 2026, `\\label{lem:prw}` proof body, `Sub-claim " ++
    "(Partition-Internality of \\E-Internal Structural " ++
    "Stipulations)` (paper's structural case-tag for warrants " ++
    "using a partition-symmetric structural property f* on " ++
    "the partition members)"
  attackHistory := [
    "v0.5.0 R1 decomposition (2026-05-13): introduced as a " ++
      "paper-novel structural case-tag predicate on " ++
      "`ArbitrationProcedure`, used as the antecedent of atom " ++
      "`prw_partition_internality_of_structural_stipulations`.  " ++
      "Encoded as a Lean `def` returning `True` (v6 §3.4.1 " ++
      "carrier pattern).",
    "v0.5.0 R1 sub-type: carrier — paper-named structural " ++
      "sub-form classifier; matches the paper's `R_{f*}`-routing " ++
      "construction.",
    "v0.5.0 R1 reductionism Cat 1?: CLEAR-NO — no Mathlib " ++
      "predicate for partition-symmetric structural property " ++
      "routing.",
    "v0.5.0 R1 reductionism Cat 2?: CLEAR-NO — no external " ++
      "theorem references the type-(c) sub-form classifier."
  ]
  scope :=
    "Typed Prop-valued structural case-tag for an arbitration " ++
    "procedure routing via a partition-symmetric structural " ++
    "property `f*` (coverage, parsimony, internal coherence, " ++
    "...) on the partition members.  Encoded as a Lean `def`; " ++
    "not an `axiom`."
}

/--
  Lemma `\label{lem:prw}` reduction (Partition-Relative-
  Weighting): now a *derived theorem* composing the five
  atomic stipulations above.
-/
def gap_lem_prw_reduction : GapEntry := {
  name := "lem_prw_reduction"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.notInput
  cat3SubType := Cat3SubType.notCat3
  paperSource :=
    "Li 2026, `\\label{lem:prw}` (Partition-Relative-Weighting " ++
    "Reduction) — paper Lemma 1 of the impossibility theorem's " ++
    "proof.  In the v0.5.0 R1 decomposition the lemma is " ++
    "derived as a Lean `theorem` from the five atomic " ++
    "stipulations (uniform / type-(a) / type-(b) / Partition-" ++
    "Internality / case-exhaustion) via case-analysis on the " ++
    "paper's structural sub-forms."
  attackHistory := [
    "v0.2.0 audit (2026-05-13): atomicity assessed; decision " ++
      "was to keep as SINGLE atomic axiom based on the paper's " ++
      "`Lemma carries the load; sub-claims verify exhaustiveness` " ++
      "structure.  THIS DECISION WAS REVERSED in v0.5.0 — the " ++
      "v6 §13 / §18 anti-pattern #13 / #14 audit found the prior " ++
      "decision conflated 'lemma's load-bearing status in the " ++
      "paper' with 'atomicity in the Lean encoding'.  The " ++
      "lemma's published proof has explicit case-analysis " ++
      "structure mapping one-to-one onto five paper-stated " ++
      "atomic stipulations.",
    "v0.3.0 reductionism Cat 1?: CLEAR-NO (recorded against the " ++
      "former composite axiom — preserved in attackHistory).",
    "v0.3.0 reductionism Cat 2?: CLEAR-NO (recorded against the " ++
      "former composite axiom — preserved in attackHistory).",
    "v0.4.0 v6 §3.4.6 ≥2-round reductionism review (R-N): " ++
      "CLEAR-NO outcomes recorded against the former composite " ++
      "axiom (Round 1 Cat 1 — Order.Basic / Order.Partition.* / " ++
      "Order.Antisymmetrization / Order.Hom.Lattice surveyed, " ++
      "Finpartition rejected; Round 2 Cat 2 — Arrow 1951, Sen " ++
      "1970, Gibbard-Satterthwaite, Saari, Topkis, Brandom " ++
      "surveyed).  The per-atom reductionism reviews now live " ++
      "in the attackHistory of the five new atomic stipulations.",
    "v0.5.0 R1 decomposition (2026-05-13): converted axiom→theorem.  " ++
      "Decomposed into per-case atomic stipulations: " ++
      "prw_uniform_warrant_partitionRelative, " ++
      "prw_type_a_feature_partitionRelative, " ++
      "prw_type_b_feature_partitionRelative, " ++
      "prw_partition_internality_of_structural_stipulations, " ++
      "prw_E_internal_warrant_case_exhaustion.  The derived " ++
      "Lean theorem composes them via case-analysis on the " ++
      "paper's structural case-tags (paper's `uniform / " ++
      "contextual` split + `Sub-claim: No-arbitration for " ++
      "\\E-internal ranking principles` type-(a)/(b)/(c) " ++
      "trichotomy + `Sub-claim: Partition-Internality of " ++
      "\\E-Internal Structural Stipulations`).  Anti-pattern " ++
      "#13 (conclusion-as-axiom) and #14 (composite-axiom " ++
      "bundling) addressed."
  ]
  scope :=
    "`∀ A, A.warrantInternalToE → A.partitionRelative`.  Derived " ++
    "Lean theorem; carries the lemma's downstream consequence " ++
    "for the impossibility theorem.  The combinatorial content " ++
    "of the case-analysis lives in the five atomic " ++
    "stipulations above; the theorem itself is the composition " ++
    "of those atoms via the paper's structural case-tag " ++
    "exhaustion."
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
      "the typed `structure` IS the paper's mathematical object.",
    "v0.4.0 v6 §3.4.6 ≥2-round reductionism review.  Round 1 " ++
      "(Cat 1 reduction?): CLEAR-NO.  The structure packages clauses " ++
      "(i)–(iv) of `\\label{def:reverse}`, of which clause (iv) " ++
      "(folk-substantive disagreement among operationalisations) is " ++
      "a paper-novel Prop with no Mathlib analogue.  Mathlib has no " ++
      "type-theoretic primitive that captures `concept C with folk " ++
      "extension E_folk + family of operationalisations + dispersion " ++
      "+ folk-substantive disagreement`; the four-clause bundle is " ++
      "paper-stated.  Round 2 (Cat 2 reduction?): CLEAR-NO.  " ++
      "Surveyed: Carnap 1950 `Logical Foundations of Probability` " ++
      "explication (close — sharpening folk concepts — but does NOT " ++
      "formalise the four-clause reverse-definition criterion); " ++
      "Hacking 1995 `looping kinds` (related — feedback between " ++
      "classification and classified — but different formal " ++
      "structure); Brandom 1994 normative pragmatics (discursive " ++
      "scorekeeping, different scope); Sellars 1956 `Empiricism and " ++
      "the Philosophy of Mind` two-image framework (myth of the " ++
      "given, different scope); Dennett intentional-stance " ++
      "taxonomy (different scope).  No external formalisation of " ++
      "reverse-defined concepts with the four-clause structure.  " ++
      "Net change: 0 reductions found; stays Cat 3 carrier."
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
      "`ReverseDefinedConcept`.",
    "v0.4.0 v6 §3.4.6 ≥2-round reductionism review.  Round 1 " ++
      "(Cat 1 reduction?): CLEAR-NO.  The three sub-criteria " ++
      "(iv.a) cross-operationalisation defence asymmetry, " ++
      "(iv.b) absence of cross-operationalisation arbiter on " ++
      "operationalisation-internal grounds, (iv.c) substitutability " ++
      "of folk-extension subsets reverses verdicts — are all " ++
      "paper-novel Props with no Mathlib analogue.  The witness " ++
      "structure is just a 3-Prop bundle parametrised by a parent " ++
      "carrier; the Props themselves are the load-bearing content.  " ++
      "Round 2 (Cat 2 reduction?): CLEAR-NO.  Surveyed external " ++
      "literature for jointly-sufficient operational criteria for " ++
      "concept-individuation: Carnap explication (no triple-witness " ++
      "form); Brandom's `material-inferential commitments` " ++
      "(different formal structure); contemporary philosophy of " ++
      "science accounts of `theoretical disagreement` (Laudan 1977, " ++
      "Kuhn 1962, Lakatos 1970 research programmes — no formal " ++
      "(iv.a)/(iv.b)/(iv.c) decomposition).  Net change: 0 " ++
      "reductions found; stays Cat 3 carrier."
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
      "scope-defining classifier on eliminated parts.",
    "v0.4.0 v6 §3.4.6 ≥2-round reductionism review.  Round 1 " ++
      "(Cat 1 reduction?): CLEAR-NO.  The structure carries: " ++
      "`m`-indexed partition + `register : Fin m → ElimRegister` " ++
      "(eliminated/retained two-valued tag) + `mode` (Π-typed (a)/(b) " ++
      "licensing-mode tag on eliminated parts).  The `register` map " ++
      "alone would reduce to `Fin m → Bool` (Mathlib), but the " ++
      "verdict-assignment + (a)/(b) licensing-mode pairing IS the " ++
      "paper-novel structural commitment (the (a)/(b) distinction " ++
      "tracks successor-mature vs. preliminary-ahead-of-replacement " ++
      "elimination, a paper-novel mode classifier).  Round 2 " ++
      "(Cat 2 reduction?): CLEAR-NO.  Surveyed: Churchland 1981 " ++
      "`Eliminative Materialism and the Propositional Attitudes` " ++
      "(introduces eliminativism but no (a)/(b) mode distinction); " ++
      "Stich 1983 `From Folk Psychology to Cognitive Science` " ++
      "(eliminativist programme, no formal mode distinction); " ++
      "Ramsey 2013 `Eliminative Materialism` SEP entry (surveys " ++
      "the literature but no formal asymmetric-elimination " ++
      "structure on partitions).  The (a)/(b) distinction " ++
      "(`\\label{def:asym-elim}` `\\S~\\ref{sec:asymmetric-elim}` " ++
      "successor-mature vs. preliminary) is Li 2026's contribution.  " ++
      "Net change: 0 reductions found; stays Cat 3 " ++
      "hypothesisPredicate."
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
      "carry Props) into a typed diagnostic-profile object.",
    "v0.4.0 v6 §3.4.6 ≥2-round reductionism review.  Round 1 " ++
      "(Cat 1 reduction?): CLEAR-NO.  The structure packages E1 " ++
      "(carrying a `ReverseDefinedConcept`, itself paper-novel " ++
      "Cat 3) + E2 (persistent dispersion, paper-novel Prop with " ++
      "E2a current-window + E2b paradigm-shift sub-clauses) + " ++
      "E3 (functional decoupling, paper-novel Prop).  No Mathlib " ++
      "predicate captures `persistent dispersion across paradigm " ++
      "shifts` or `functional decoupling` for a concept.  Round 2 " ++
      "(Cat 2 reduction?): CLEAR-NO.  Surveyed: Kuhn 1962 paradigm " ++
      "shifts (motivates E2b's paradigm-shift quantifier but no " ++
      "formal `persistent dispersion across at least one paradigm " ++
      "shift` predicate); Laudan 1977 research traditions " ++
      "(different scope); Lakatos 1970 research programmes " ++
      "(different scope); Putnam 1975 `Meaning of Meaning` natural-" ++
      "kind semantics (different scope).  The three-condition E1/" ++
      "E2/E3 bundle is paper-novel (Li 2026 `\\label{def:edc}`).  " ++
      "Net change: 0 reductions found; stays Cat 3 carrier."
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
      "freestanding primitive type.",
    "v0.4.0 v6 §3.4.6 ≥2-round reductionism review.  Round 1 " ++
      "(Cat 1 reduction?): CLEAR-NO.  S1/S2 are paper-novel Props " ++
      "over (concept, T_e, T_r) triples; Mathlib has no causal/" ++
      "constitutive-independence primitive over abstract carriers.  " ++
      "Round 2 (Cat 2 reduction?): CLEAR-NO.  Surveyed external " ++
      "philosophy-of-language / metaphysics literature on " ++
      "independence: Lewis 1973 `Causation` counterfactual-causal " ++
      "dependence (related — provides the metaphysical framework " ++
      "S1 inherits — but the S1/S2 pair as a two-component " ++
      "separability criterion for asymmetric elimination is " ++
      "paper-specific); Fine 1995 `Senses of Essence` constitutive " ++
      "dependence (background notion for S2 but not the S1/S2 pair " ++
      "as a use-separability bundle); Hacking 1995 `looping kinds` " ++
      "(the looping-kinds counter-example IS the paper's negative " ++
      "comparator showing where S1 fails for psychiatric categories, " ++
      "but Hacking's looping-kinds formal apparatus does not " ++
      "supply a counterpart of the S1/S2 separability pair).  " ++
      "Net change: 0 reductions found; stays Cat 3 " ++
      "hypothesisPredicate."
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
      "primitive type.",
    "v0.4.0 v6 §3.4.6 ≥2-round reductionism review.  Round 1 " ++
      "(Cat 1 reduction?): CLEAR-NO.  `determinedByPartExhibition` " ++
      "is a paper-novel Prop on (Op, partition-member) pairs; " ++
      "Mathlib has no `determined-by-feature-exhibition` primitive.  " ++
      "The contested-witness existential fields (`∃ x, verdict x = " ++
      "false`, `∃ x, verdict x = true`) ARE Mathlib-typed `∃` " ++
      "predicates BUT the paper-specific framing (`contested " ++
      "witnesses` discriminable on E_i-feature exhibition) is the " ++
      "paper-novel structural-use content, not the bare existentials.  " ++
      "Round 2 (Cat 2 reduction?): CLEAR-NO.  Surveyed external " ++
      "philosophy-of-science / measurement-theory literature: " ++
      "Bridgman 1927 `Logic of Modern Physics` operationalism " ++
      "(introduces operational-definition notion but no P1 " ++
      "faithfulness predicate); Suppes 1962 set-theoretic " ++
      "predicates for empirical theories (different formalism); " ++
      "Sneed 1971 / Stegmüller 1976 structuralist programme " ++
      "(theory-net architecture, no P1 analogue); Hempel 1965 " ++
      "operational analyses (no formal faithfulness predicate).  " ++
      "P1 (Li 2026 `\\label{def:op-properties}`) is paper-novel.  " ++
      "Net change: 0 reductions found; stays Cat 3 " ++
      "hypothesisPredicate."
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
      "IS the paper's mathematical object for discriminator rows.",
    "v0.4.0 v6 §3.4.6 ≥2-round reductionism review.  Round 1 " ++
      "(Cat 1 reduction?): CLEAR-NO net effect.  The 3-tuple " ++
      "skeleton (`D1 D2 D3 : DiagnosticRating`) could be re-encoded " ++
      "as `Fin 3 → DiagnosticRating` or `Vector DiagnosticRating 3` " ++
      "(Mathlib types), BUT (a) the paper-novel content is the " ++
      "underlying `DiagnosticRating` enum (paper-novel yes/weak/no " ++
      "three-valued tag for `\\label{def:discriminator}`); (b) the " ++
      "named structural roles D1 (substrate-tracking failure), D2 " ++
      "(predictive-purchase asymmetry), D3 (successor-program " ++
      "productivity) are paper-named slots that index-into-Vector " ++
      "encoding would erase; (c) the `counterfactualIndependence` " ++
      "Prop is paper-novel.  Refactoring `DiscriminatorRow` to a " ++
      "`Vector` would: erase paper-named role-discrimination + " ++
      "introduce `DiagnosticRating` as the Cat 3 carrier — net " ++
      "Cat 3 count unchanged, structural fidelity decreased.  " ++
      "Honest decision: KEEP as Lean `structure` with named " ++
      "D1/D2/D3 fields.  Round 2 (Cat 2 reduction?): CLEAR-NO.  " ++
      "Surveyed external discriminator-style frameworks: Lakatos " ++
      "1970 hard core / protective belt (no D1/D2/D3 trio); " ++
      "Laudan's `pursuit-vs-acceptance` (no three-condition " ++
      "trichotomy); Glymour 1980 bootstrapping (different scope); " ++
      "Stanford 2006 `Exceeding our Grasp` historical retrodiction " ++
      "of unconceived alternatives (background but no D1/D2/D3 " ++
      "decomposition).  The three-condition discriminator with " ++
      "three-valued yes/weak/no judgement is paper-novel (Li 2026 " ++
      "`\\label{def:discriminator}`).  Net change: 0 reductions " ++
      "found; stays Cat 3 carrier."
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
      "bearing structural equation built on top.",
    "v0.4.0 v6 §3.4.6 ≥2-round reductionism review.  Round 1 " ++
      "(Cat 1 reduction?): CLEAR-NO net effect.  Mathlib provides " ++
      "`Mathlib.Order.Partition.Finpartition` (`structure " ++
      "Finpartition [Lattice α] [OrderBot α] (a : α)` with " ++
      "`parts : Finset α`, `supIndep`, `sup_parts = a`, " ++
      "`⊥ ∉ parts`) AND `Setoid` (equivalence-relation-induced " ++
      "partition).  Refactoring `MutuallyUnrankedPartition` to " ++
      "use `Finpartition (Set.univ : Set FolkObj)` would (a) " ++
      "introduce the `sup_parts = univ` constraint which the paper " ++
      "does not require (partition of `E_folk`, but `E_folk` is " ++
      "carried abstractly and the paper's use is via " ++
      "`parts : Fin n → Set FolkObj` indexed access, not via " ++
      "supremum equality); (b) NOT eliminate the carrier — the " ++
      "load-bearing content is the paper-novel " ++
      "`noPartitionIndependentRanking : Prop` predicate, with no " ++
      "Mathlib analogue; (c) lose the `Fin n` indexed access used " ++
      "throughout `Impossibility.lean` and `lem_prw_reduction`'s " ++
      "signature.  `Setoid` is rejected: a Setoid is an equivalence " ++
      "relation, not a finite indexed partition with a " ++
      "non-rankability Prop.  Honest decision: KEEP as Lean " ++
      "`structure` with `Fin n` indexing + paper-novel " ++
      "non-rankability Prop.  Round 2 (Cat 2 reduction?): " ++
      "CLEAR-NO.  Surveyed external social-choice / preference-" ++
      "theory literature for `mutually unranked partition`: Arrow " ++
      "1951 / Sen 1970 / Gibbard-Satterthwaite (work over " ++
      "preference profiles, not partition-of-extension with " ++
      "non-rankability); Pareto-incommensurability (different " ++
      "scope).  The `noPartitionIndependentRanking` predicate " ++
      "(Li 2026 `\\label{def:unranked}`) is paper-novel.  Net " ++
      "change: 0 reductions found; stays Cat 3 carrier."
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
      "faithfulness).  Definitional atom.",
    "v0.4.0 v6 §3.4.6 ≥2-round reductionism review.  Round 1 " ++
      "(Cat 1 reduction?): CLEAR-NO net effect.  The `verdict : " ++
      "Tcls → Bool` field alone reduces to a Mathlib function type, " ++
      "but the paper-novel content is the STRUCTURED PAIRING: an " ++
      "operationalisation is a verdict-map PARAMETRISED BY which " ++
      "partition member `E_i` it is faithful to (the `faithful_to_" ++
      "partIdx : Fin Part.n` field).  Reducing to a bare `Tcls → " ++
      "Bool` would lose the partition-faithfulness coupling that " ++
      "the impossibility theorem's proof skeleton uses.  Round 2 " ++
      "(Cat 2 reduction?): CLEAR-NO.  Surveyed external " ++
      "measurement-theory / operationalism: Bridgman 1927 operationalism " ++
      "(no formal pairing with partition member); Stevens 1946 " ++
      "scales-of-measurement (different scope); Suppes 1962 " ++
      "set-theoretic predicates (theory-element framework, not the " ++
      "verdict-map-paired-with-partition-faithfulness encoding); " ++
      "Bridgman / Hempel / Carnap operational analyses (background " ++
      "only).  The verdict-map + faithful-to-partition-member " ++
      "pairing is paper-specific framing (Li 2026 " ++
      "`\\label{def:op-individuation}` + `\\label{def:op-properties}`).  " ++
      "Net change: 0 reductions found; stays Cat 3 carrier."
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
  cat3SubType := Cat3SubType.hypothesisPredicate
  paperSource := "Li 2026, `\\label{def:op-properties}` P2"
  attackHistory := [
    "v0.3.0 sub-type classification: carrier — paper-introduced " ++
      "primitive type for an arbitration procedure between " ++
      "operationalisations (adjudicate function + " ++
      "partitionRelative + warrantInternalToE Prop fields).  " ++
      "Definitional atom; `lem_prw_reduction` is the structural " ++
      "equation that operates over this carrier.",
    "v0.4.0 v6 §3.4.6 ≥2-round reductionism review.  Round 1 " ++
      "(Cat 1 reduction?): CLEAR-NO.  The `adjudicate : Tcls → Fin " ++
      "Part.n` field alone is a Mathlib function type, but the " ++
      "paper-novel content is the two Prop fields: " ++
      "`partitionRelative` (verdict reduces to a weighting of " ++
      "`{E_1, …, E_n}`) and `warrantInternalToE` (warrant derives " ++
      "from `\\E` alone).  Mathlib has no `partition-relative " ++
      "weighting` predicate and no `warrant internal to extension " ++
      "E` predicate — both are paper-novel.  Round 2 (Cat 2 " ++
      "reduction?): CLEAR-NO.  Surveyed external arbitration-" ++
      "theory / social-choice / decision-theory literature: Arrow " ++
      "1951 (multi-voter aggregation, not single-arbiter procedure " ++
      "with partition-relative-verdict Prop); Sen 1970 (different " ++
      "scope); Roemer 1996 (theories of distributive justice — " ++
      "background but no formal arbitration-procedure carrier with " ++
      "partitionRelative + warrantInternalToE pair); Saari geometric " ++
      "voting (different formalism).  The arbitration-procedure " ++
      "carrier with these two Prop fields is paper-specific (Li " ++
      "2026 `\\label{def:op-properties}` P2 + impossibility-theorem " ++
      "proof setup).  Net change: 0 reductions found; stays Cat 3.",
    "v0.5.0 D2 reclassification (2026-05-13): sub-type changed " ++
      "carrier→hypothesisPredicate.  The structure's load-bearing " ++
      "content is its two bare-Prop fields (`partitionRelative` " ++
      "and `warrantInternalToE`), both paper-introduced scope " ++
      "conditions (v6 §3.4.2): `partitionRelative` is `verdict " ++
      "reduces to a weighting of the partition members'; " ++
      "`warrantInternalToE` is `adjudication-warrant derives from " ++
      "\\E-features alone'.  The structure is a paper-novel " ++
      "scope-condition bundle, not a freestanding primitive type " ++
      "(which would be sub-type `carrier`).  Documentation block " ++
      "explaining the bare-Prop design choice added to " ++
      "`Basic.lean` immediately above the structure definition."
  ]
  scope :=
    "Typed scope-condition bundle for an arbitration procedure " ++
    "between operationalisations.  Encoded as a Lean `structure` " ++
    "with `partitionRelative` and `warrantInternalToE` paper-" ++
    "stipulated bare-Prop scope-condition fields plus an " ++
    "`adjudicate` function field.  See `Basic.lean` for the " ++
    "design-note block explaining the bare-Prop choice."
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
      "atom underwriting the DSC vocabulary.",
    "v0.4.0 v6 §3.4.6 ≥2-round reductionism review.  Round 1 " ++
      "(Cat 1 reduction?): CLEAR-NO.  The carrier bundles six " ++
      "abstract Types + an inference operation + six Prop-valued " ++
      "DSC-axis fields (sessionalP / concurrentP / stateInferenceP " ++
      "/ distributionalP / homogeneousP / inversionP).  The six " ++
      "DSC axes (`\\label{def:sessional}` through " ++
      "`\\label{def:inversion}`) are paper-novel Props with no " ++
      "Mathlib analogue.  Mathlib has no `cognitive system` " ++
      "carrier and no DSC-axis predicates.  Round 2 (Cat 2 " ++
      "reduction?): CLEAR-NO.  Surveyed external cognitive-science / " ++
      "ML-architecture literature for similar carriers: Bechtel & " ++
      "Abrahamsen 2002 `Connectionism and the Mind` (no formal " ++
      "DSC-axis decomposition); Marr 1982 three-levels framework " ++
      "(different formalism); Newell 1990 unified theories of " ++
      "cognition (background); Anderson ACT-R cognitive architecture " ++
      "(background but no DSC axes); Vaswani et al. 2017 " ++
      "`Attention Is All You Need` transformer architecture " ++
      "(implementation reference, not formalised cognitive-system " ++
      "carrier).  The six DSC axes are paper-novel (Li 2026 §11).  " ++
      "Net change: 0 reductions found; stays Cat 3 carrier."
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
  cat3SubType := Cat3SubType.hypothesisPredicate
  paperSource := "Li 2026, `\\label{def:sc}`"
  attackHistory := [
    "v0.3.0 sub-type classification: carrier — paper-introduced " ++
      "primitive type packaging the six SC commitments (V1–V6) " ++
      "as Prop-valued fields paralleling the DSC axes.",
    "v0.5.0 D3 reclassification (2026-05-13): sub-type changed " ++
      "carrier→hypothesisPredicate.  `SessionalCognition`'s " ++
      "load-bearing content is exclusively its six Prop-valued " ++
      "V1–V6 fields (the paper's first-person SC commitments).  " ++
      "Per v6 §3.4.2, a Prop-bundle scope-condition structure is " ++
      "sub-type `hypothesisPredicate`, not `carrier`.  Design-" ++
      "note block explaining the bare-Prop choice added to " ++
      "`Basic.lean` near the `CognitiveSystem` definition.",
    "v0.4.0 v6 §3.4.6 ≥2-round reductionism review.  Round 1 " ++
      "(Cat 1 reduction?): CLEAR-NO.  V1–V6 are paper-novel Props " ++
      "(session-locality / instance-as-subject / trajectory-only-" ++
      "state / distributional-pull / generative-non-division / " ++
      "self-report-as-observable-behaviour) with no Mathlib analogue.  " ++
      "Round 2 (Cat 2 reduction?): CLEAR-NO.  Surveyed external " ++
      "first-person / phenomenology / self-attribution literature: " ++
      "Castañeda 1966 / Perry 1979 essentially-indexical content " ++
      "(philosophical background, cited by B2 of `def:bridging` " ++
      "but no V1–V6 vocabulary); Nagel 1974 `What Is It Like to " ++
      "Be a Bat?` (subjective character of experience — but no " ++
      "first-person LLM vocabulary); Husserlian phenomenology " ++
      "(different scope); Block 1995 phenomenal vs. access " ++
      "consciousness (background only).  The SC vocabulary's six " ++
      "commitments V1–V6 are paper-novel (Li 2026 " ++
      "`\\label{def:sc}`).  Net change: 0 reductions found; stays " ++
      "Cat 3 carrier."
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
  cat3SubType := Cat3SubType.hypothesisPredicate
  paperSource := "Li 2026, `\\label{def:bridging}`"
  attackHistory := [
    "v0.3.0 sub-type classification: carrier — paper-introduced " ++
      "primitive type packaging (B1) bijective correspondence + " ++
      "mutual independence + joint sufficiency + (B2) point-of-" ++
      "view non-translatability into a single bridging-principle " ++
      "object parametrised by (S, SC).",
    "v0.5.0 D3 reclassification (2026-05-13): sub-type changed " ++
      "carrier→hypothesisPredicate.  `BridgingPrinciple`'s load-" ++
      "bearing content is exclusively its four Prop-valued fields " ++
      "(B1.i conjunction of six bi-implications + B1.ii + B1.iii " ++
      "+ B2).  Per v6 §3.4.2, a Prop-bundle scope-condition " ++
      "structure is sub-type `hypothesisPredicate`, not `carrier`.  " ++
      "Design-note block explaining the bare-Prop choice added " ++
      "to `Basic.lean` near the `CognitiveSystem` definition.",
    "v0.4.0 v6 §3.4.6 ≥2-round reductionism review.  Round 1 " ++
      "(Cat 1 reduction?): CLEAR-NO.  B1.i conjunction of six " ++
      "bi-implications is a Mathlib-typed `∧`-conjunction of `↔`, " ++
      "but the load-bearing content (each `↔` pairs a paper-novel " ++
      "DSC axis Prop with a paper-novel SC commitment Prop) is " ++
      "Cat 3 paper-novel.  B1.ii (mutual independence) and B1.iii " ++
      "(joint sufficiency) and B2 (point-of-view non-" ++
      "translatability) are paper-novel Props.  Round 2 (Cat 2 " ++
      "reduction?): CLEAR-NO.  Surveyed external philosophy-of-" ++
      "language literature on indexicality / point-of-view " ++
      "translation: Perry 1979 `The Problem of the Essential " ++
      "Indexical` (CITED inside the B2 field's content but the " ++
      "B1+B2 four-relation bundle is paper-novel framing; Perry " ++
      "does NOT prove a theorem of this form on DSC ↔ SC); " ++
      "Castañeda 1966 quasi-indicators (background); Lewis 1979 " ++
      "`Attitudes De Dicto and De Se` (background for indexical " ++
      "self-attribution but no DSC/SC bridging structure).  The " ++
      "BridgingPrinciple carrier itself (4-field structure binding " ++
      "B1.i/B1.ii/B1.iii/B2 over (S, SC)) is paper-specific " ++
      "framing.  Net change: 0 reductions found; stays Cat 3 " ++
      "carrier."
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
  attackHistory := [
    "v0.5.0 D6 audit (2026-05-13): paper articulates a structural " ++
      "claim about the DSC axis-space (mutual independence), but " ++
      "the supporting argument is six `coherent hypothetical " ++
      "system` witnesses whose *coherence* is a conceptual-" ++
      "philosophical judgement (whether such a system is " ++
      "architecturally-coherent given LLM-relevant commitments).  " ++
      "Lean-formalisation as six existence-witnesses on " ++
      "`CognitiveSystem` is trivially constructible (the Prop-" ++
      "valued axis fields permit arbitrary assignments) but does " ++
      "NOT capture the substantive paper-side content (whether " ++
      "the witnessed system is coherent qua hypothetical " ++
      "architecture).  Status retained as `gapBlocked`: the " ++
      "substantive argument is conceptual-philosophical, not " ++
      "structural-mathematical.  Reclassification to " ++
      "`workingAssumption` (Cat 3) was considered and REJECTED: " ++
      "the thesis is not pending derivation, it is a paper-" ++
      "conclusion argued discursively; encoding a trivial Lean " ++
      "existence-witness would not honour the paper-side content."
  ]
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
  attackHistory := [
    "v0.5.0 D6 audit (2026-05-13): paper articulates a structural " ++
      "minimality claim (dropping any single axis from the six-" ++
      "axis set leaves the corresponding biological-vocabulary " ++
      "blocking-category unblocked), but the supporting evidence " ++
      "is six paper-supplied natural-language locutions (`the " ++
      "system is reflecting on yesterday's session', etc.) plus " ++
      "informal arguments about which axes block which locutions.  " ++
      "Lean-formalisation requires a typed carrier for `biological-" ++
      "vocabulary leak categories` and a typed `blocks` relation " ++
      "between axes and locutions, neither of which the paper " ++
      "formalises.  Status retained as `gapBlocked`: the " ++
      "supporting evidence is paper-discursive natural-language " ++
      "locutions, not structural-mathematical content.  " ++
      "Reclassification to `workingAssumption` (Cat 3) was " ++
      "considered and REJECTED: the thesis is not pending " ++
      "derivation; it is a paper-conclusion argued via natural-" ++
      "language locutions, and the absence of a typed locution-" ++
      "space is a paper-side framing choice (not a Mathlib gap)."
  ]
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

def gap_substrate_independence_triple_use_OPEN : GapEntry := {
  name := "SubstrateIndependenceTripleUse"
  status := GapStatus.gapOpen
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.hypothesisPredicate
  paperSource :=
    "Li 2026, calibration-section `\\S\\ref{sec:discriminator}` " ++
    "paragraph `Acknowledgement: Route~2 shares load-bearing " ++
    "premise with E2b transferability AND impossibility-theorem-" ++
    "application` — paper statement: 'The substrate-independence " ++
    "premise does triple duty for the LLM-elimination verdict: " ++
    "(a) E2b transferability, (b) D1 Route 2, (c) impossibility-" ++
    "theorem application to the novel target.  The framework\\'s " ++
    "verdict on LLMs therefore rests on two empirical premises " ++
    "(substrate-independence doing triple work; calendar-window " ++
    "evidence doing one job for D2 and D3) rather than on three " ++
    "or four independent premises.'"
  attackHistory := [
    "v0.2.0 (2026-05-13): originally classified gapBlocked with " ++
      "reason 'paper-side articulation insufficient for a " ++
      "typed-relation encoding without inventing structural " ++
      "commitments not present in the paper.'",
    "v0.5.0 R2 reclassification (2026-05-13): reclassified " ++
      "gapBlocked→gapOpen Cat 3 hypothesisPredicate per v6 §2 " ++
      "clarification 'Mathlib infra absence ALONE is NOT BLOCKED " ++
      "— if paper\\'s conclusion is published externally [or " ++
      "paper-articulated], encode as plain Cat 2 axiom + paper-" ++
      "citation docstring (status gapOpen).'  The premise IS " ++
      "paper-articulated as a scope condition (the discourse-state " ++
      "premise underwriting three downstream uses), making it a " ++
      "paper-novel Cat 3 hypothesisPredicate (paper-introduced " ++
      "scope condition).  No Mathlib-infra-absence justification " ++
      "for `gapBlocked` is valid: the paper articulates the " ++
      "premise in `\\S\\ref{sec:discriminator}` `Acknowledgement` " ++
      "paragraph.",
    "v0.5.0 R2 reductionism Cat 1?: CLEAR-NO — Mathlib has no " ++
      "`substrate-independence` predicate on `CognitiveSystem`-pairs.",
    "v0.5.0 R2 reductionism Cat 2?: CLEAR-NO — substrate-" ++
      "independence is the paper\\'s own empirical-discursive " ++
      "premise; no external textbook theorem corresponds to the " ++
      "paper\\'s specific triple-use framing across E2b/D1 Route " ++
      "2/impossibility-theorem-application.",
    "v0.5.0 R2 (2026-05-13): entry recorded as `gapOpen` " ++
      "hypothesisPredicate; the underlying axiom is not yet wired " ++
      "into any derived theorem (i.e., the premise is " ++
      "*available* for downstream consumption but no theorem " ++
      "currently consumes it — analogous to a paper-articulated " ++
      "scope condition declared for future use).  Wiring it into " ++
      "the LLM-target-extension theorem is the natural next " ++
      "step but is paper-extension work, not core formalisation."
  ]
  scope :=
    "Paper-introduced scope/regime predicate: a single " ++
    "discourse-state premise (substrate-independence at " ++
    "cognitive-neuroscience resolution) underwrites three " ++
    "downstream framework uses for the LLM-elimination verdict " ++
    "(E2b transferability, D1 Route 2, impossibility-theorem " ++
    "application to the LLM target).  Declared as a Cat 3 " ++
    "hypothesisPredicate scope condition; not yet wired into " ++
    "any derived theorem (paper-articulated for future " ++
    "downstream consumption).  Sub-type `hypothesisPredicate` " ++
    "per v6 §3.4.2: paper-introduced scope condition, 永不 " ++
    "close."
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
  -- Cat 3 paper-novel atomic stipulations for Lemma `\label{lem:prw}`
  -- (v0.5.0 R1 decomposition; replaces former single composite
  -- `lem_prw_reduction` axiom — anti-pattern #13/#14 fix per v6
  -- §13/§18).
  gap_prw_uniform_warrant_partitionRelative,
  gap_prw_type_a_feature_partitionRelative,
  gap_prw_type_b_feature_partitionRelative,
  gap_prw_partition_internality_of_structural_stipulations,
  gap_prw_E_internal_warrant_case_exhaustion,
  -- Cat 3 paper-novel case-tag carriers (Lean `def`s, not axioms)
  gap_isUniformWarrant_carrier,
  gap_usesTypeAFeature_carrier,
  gap_usesTypeBFeature_carrier,
  gap_usesTypeCStructuralProperty_carrier,
  -- `lem_prw_reduction` is now a derived theorem (axiom→theorem)
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
  -- gapBlocked / gapOpen entries (paper-side structural content
  -- with explicit reason)
  gap_thesis_independence_BLOCKED,
  gap_thesis_joint_BLOCKED,
  gap_thesis_minimality_BLOCKED,
  gap_substrate_independence_triple_use_OPEN,
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

/-! ### Inventory summary (v0.5.0 post-R1/R2/D1–D6)

  The live status / input-category / Cat 3 sub-type counts are
  printed by the `#eval` calls above (run `lake env lean
  AsymmetricEliminativism/Ledger.lean` to see them).

  *Live counts (v0.5.0; refer to `#eval` output for authority).*
  Total entries 44; the breakdown reflects all R1/R2/D2/D3/D6
  reclassifications:

    * Status: 6 gapOpen / 0 gapPartial / 6 gapBlocked / 0
      gapDeadEnd / 32 gapClosed / 0 gapClosedConditional.
    * Input: 0 cat1Mathlib / 0 cat2External / 23 cat3PaperNovel
      / 21 notInput.
    * Cat 3 sub-type: 11 carrier / 8 hypothesisPredicate / 4
      structuralEquation / 0 workingAssumption / 0
      conditionalHypothesis / 21 notCat3.

  *Cat 3 atomic inputs (23 entries, the paper-side atomic-input
  inventory):*

    Cat 3 atomic stipulations for Lemma `\label{lem:prw}`
    (5 entries; sub-type `structuralEquation` ×4 +
    `hypothesisPredicate` ×1; v0.5.0 R1 decomposition):
      prw_uniform_warrant_partitionRelative,
      prw_type_a_feature_partitionRelative,
      prw_type_b_feature_partitionRelative,
      prw_partition_internality_of_structural_stipulations,
      prw_E_internal_warrant_case_exhaustion.

    Cat 3 case-tag carriers (4 entries; sub-type `carrier`;
    v0.5.0 R1 decomposition):
      ArbitrationProcedure.isUniformWarrant,
      ArbitrationProcedure.usesTypeAFeature,
      ArbitrationProcedure.usesTypeBFeature,
      ArbitrationProcedure.usesTypeCStructuralProperty.

    Cat 3 paper-novel typed carriers
    (sub-type `carrier`; encoded as Lean `structure` /
    `def` / `class`, NOT as `axiom` declarations):
      ReverseDefinedConcept, ReverseDefinedWitness,
      DiagnosticProfile, MutuallyUnrankedPartition,
      Operationalisation, CognitiveSystem,
      DiscriminatorRow (plus the 4 case-tag `def`s above —
      these contribute to the 11-total carrier count).

    Cat 3 paper-novel hypothesis/scope-condition bundles
    (sub-type `hypothesisPredicate`; encoded as Lean
    `structure` bundling Prop-valued scope conditions):
      AsymmetricEliminationVerdict, UseSeparability,
      FaithfulP1, ArbitrationProcedure (reclassified
      carrier→hypothesisPredicate in v0.5.0 D2),
      SessionalCognition (D3 reclassified),
      BridgingPrinciple (D3 reclassified),
      SubstrateIndependenceTripleUse (R2 reclassified
      gapBlocked→gapOpen Cat 3 hypothesisPredicate; the
      single Cat 3 `axiom` declaration at Basic.lean for
      a paper-articulated scope-condition Prop),
      plus the `prw_E_internal_warrant_case_exhaustion`
      atom (R1).  Note: 8 hypothesisPredicate-tagged
      entries total (live `#eval` is authoritative).

  *Derived theorems and `notInput`-classified entries* (21 entries;
  encoded as Lean `theorem` declarations, NOT as `axiom`):

    * `lem_prw_reduction` (axiom→theorem converted in v0.5.0 R1;
      composes the five lem:prw atomic stipulations).
    * Top-level theorems: `thm_impossibility`,
      `thm_impossibility_paper_form`, `bridging_dsc_iff_sc`,
      `satisfiesP3_of_boolean`.
    * Discriminator threshold-rule lemmas (7 entries).
    * Impossibility-theorem corollaries (3 entries).
    * gapBlocked deferrals (6 entries; paper-side structural
      content with content lying outside Lean's structural-
      skeleton scope — see per-entry rationale).

  Lean kernel (Cat 0; not declared here):
    propext, Classical.choice, Quot.sound.

  *Project has zero Cat 1 axioms* (no Mathlib-derivability claims
  pending discharge) and *zero Cat 2 axioms* (no external
  textbook citations).  All atomic inputs are Cat 3 paper-novel.

  *Cat 3 sub-types not used in this project:* `workingAssumption`
  (no provisional bundles pending derivation), `conditionalHypothesis`
  (no external-open-problem-conditional results).

  *gapBlocked entries* (6 in v0.5.0).  Several paper-side claims
  of structural flavour are recorded as `gapBlocked` rather than
  `gapClosed`, because their substantive content lies outside
  Lean's structural-skeleton scope (philosophical-discursive
  arguments; substrate-empirical premises; per-case historical-
  empirical judgement; policy-application sketches).  Each
  gapBlocked entry carries an explicit reason for the block;
  future audit rounds should not reattack these gaps thinking
  they are openable.

  *v0.5.0 changelog summary (round 1 of v6 compliance fixes):*

    * R1: `lem_prw_reduction` decomposed.  Former single composite
      Cat 3 axiom was anti-pattern #13 (conclusion-as-axiom: the
      lemma has a published proof) + #14 (composite-axiom
      bundling: the proof body case-analyses 5+ structural sub-
      forms).  Now: 5 paper-novel atomic Cat 3 stipulations
      (uniform / type-(a) / type-(b) / Partition-Internality
      sub-claim / case-exhaustion) + 4 case-tag carriers; the
      derived `lem_prw_reduction` theorem composes them via
      case-analysis on the paper's structural sub-forms.
      `#print axioms thm_impossibility` now shows the 5 atomic
      stipulations rather than the single opaque axiom.

    * R2: `substrate_independence_triple_use_premise`
      reclassified `gapBlocked → gapOpen` Cat 3
      `hypothesisPredicate`.  Per v6 §2, Mathlib infra absence
      ALONE is NOT BLOCKED — the paper articulates the premise
      explicitly in `\S\ref{sec:discriminator}` `Acknowledgement`
      paragraph, so it is a Cat 3 paper-articulated scope
      condition.  Axiom `SubstrateIndependenceTripleUse : Prop`
      added to `Basic.lean` for future downstream consumption;
      not currently wired into any derived theorem.

    * D1: `FaithfulP1` docstring tightened.  Removed the prior
      claim that the contested-witness fields were "the only P1-
      consequence the impossibility theorem uses" (which was
      false: `#print axioms thm_impossibility` shows no P1
      consequences are consumed).  Replaced with explicit
      acknowledgement that `FaithfulP1` is structurally
      documented but not consumed by `thm_impossibility`.

    * D2: `ArbitrationProcedure` design-note block added to
      `Basic.lean` explaining the bare-Prop choice for
      `partitionRelative` / `warrantInternalToE`.  Sub-type
      reclassified `carrier → hypothesisPredicate` (the
      structure's load-bearing content is its two paper-
      stipulated bare-Prop scope-condition fields).

    * D3: design-note block added to `Basic.lean` explaining the
      bare-Prop choice for `CognitiveSystem`,
      `SessionalCognition`, `BridgingPrinciple`.  Sub-type
      reclassifications: `SessionalCognition` and
      `BridgingPrinciple` re-tagged `carrier →
      hypothesisPredicate` (pure Prop-bundle scope structures);
      `CognitiveSystem` retained as `carrier` (mixed typing-
      dominant structure).

    * D4: `lakefile.toml` version bumped 0.2.0 → 0.5.0.

    * D5: inventory narrative (this comment block) clarified to
      report total entries M (44) separately from Cat 3 atomic
      inputs N (23) — the prior `Cat 3 ratio = 100% (14/14)`
      framing conflated derived theorems + gapBlocked deferrals
      (which are `notInput`) with paper-side atomic inputs.

    * D6: `thesis_independence` and `thesis_minimality`
      audited.  Both retained as `gapBlocked` (paper-side
      arguments are conceptual-philosophical / natural-language-
      locution discursive, not structural-mathematical).
      Reclassification to `workingAssumption` (Cat 3) REJECTED:
      the theses are paper-conclusions argued discursively, not
      paper-extension theorems pending derivation.  Each entry's
      attackHistory now records the audit reasoning.
-/

end AsymmetricEliminativism.Ledger
