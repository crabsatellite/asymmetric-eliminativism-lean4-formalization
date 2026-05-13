/-
  AsymmetricEliminativism/Ledger.lean

  Gap ledger.  Every atomic axiom, every Cat 3 carrier, and every
  closed top-level result is recorded as a typed `GapEntry` with
  three orthogonal classifications plus a broken-link dependency
  list:

    * 7-tier status:    gapOpen / gapPartial / gapBlocked / gapDeadEnd /
                        gapClosed / gapClosedConditional / gapDefinitional
                        (the 7th tier `gapDefinitional` —
                        paper-novel Cat 3 atoms that ARE the paper's
                        starting commitments, not gaps to close;
                        covers the three definitional sub-types
                        carrier / hypothesisPredicate /
                        structuralEquation — was added 2026-05-14
                        per v6 §1.1 / Manufactured Recognition
                        R-#27/R-#28)
    * 4-input-category: cat1Mathlib / cat2External / cat3PaperNovel / notInput
    * Cat 3 sub-type:   carrier / hypothesisPredicate / structuralEquation /
                        workingAssumption / conditionalHypothesis /
                        phenomenologicalConjecture / notCat3
                        (the 6th sub-type `phenomenologicalConjecture` —
                        framework-paper PUBLISHED substantive claim about
                        a phenomenon awaiting external validation —
                        was added 2026-05-14 per v6 §3.4.6 /
                        Manufactured Recognition R-#27)
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

/-- 7-tier status tag attached to each gap.  `gapClosedConditional`
    is used when Phase 4 catches a defect breaking a typed-bridge
    chain: the downstream closure is preserved as conditional on a
    named `Hyp_*` broken-link hypothesis (recorded in the entry's
    `conditionalOn` field) pending repair or independent derivation.
    `gapDefinitional` (7th tier, ratified 2026-05-14 per v6 §1.1 /
    Manufactured Recognition R-#27/R-#28) marks paper-novel Cat 3
    atoms that are starting commitments, not gaps to close — the
    three definitional sub-types (carrier / hypothesisPredicate /
    structuralEquation).  Distinguished from `gapOpen` (no attack /
    inconclusive attempts): `gapDefinitional` says "by design
    axiomatic, no Lean derivation expected".  See
    `feedback_gap_ledger_in_lean4` §1.1, §2, §12, §15. -/
inductive GapStatus
  | gapOpen
  | gapPartial
  | gapBlocked
  | gapDeadEnd
  | gapClosed
  | gapClosedConditional
  | gapDefinitional
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
  /-- Framework paper's PUBLISHED substantive claim about a phenomenon,
      awaiting EXTERNAL validation (empirical study, cohort data,
      philosophical-foundations debate).  Distinguished from
      `workingAssumption` (which mandates close before publication —
      applies to Millennium-grade derivational work) AND from
      `definitional atom` (which is paper-stipulated structure, not
      phenomenological assertion).  Never Lean-closeable; resolution
      path = battery / cohort study / interpretive debate, NOT
      derivation.  Status remains `gapOpen`.  Added 2026-05-14 per
      v6 §3.4.6 (Manufactured Recognition R-#27). -/
  | phenomenologicalConjecture
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

/-! ### Cat 3 paper-novel single working-assumption for Lemma `\label{lem:prw}`.

  *v0.6.0 R2 honest revert (defect #1 / #2 / #3 fix).*  The v0.5.0
  R1 decomposition into five atomic stipulations + four case-tag
  `def`s was COSMETIC: the case-tag predicates `isUniformWarrant`,
  `usesTypeAFeature`, `usesTypeBFeature`,
  `usesTypeCStructuralProperty` were axiomatised as `Prop := True`,
  so the case-exhaustion atom reduced to a triviality and the four
  case-specific atoms collectively asserted exactly the original
  `lem_prw_reduction` content (in fact stronger: `∀ A,
  A.partitionRelative` once any single carrier-Prop was inhabited).

  Hostile audit verdict: the paper's `\label{lem:prw}` proof body
  case-analyses the warrant by LINGUISTIC structural sub-form
  (uniform vs. contextual; type-(a)/(b)/(c) on the warrant's
  *justification*-prose), not by a typed predicate on the
  `ArbitrationProcedure` carrier itself.  Making the case-tags
  substantive requires a typed `Warrant` sub-structure paper-
  extension (refining `ArbitrationProcedure` to carry an explicit
  warrant-form classifier).  That work is not yet in the paper;
  encoding via `Prop := True` case-tags is anti-pattern #13
  (conclusion-as-axiom in cosmetic-decomposition form).

  Round 2 fix: revert to a single Cat 3 `workingAssumption` axiom
  with close-target = typed-Warrant refinement.  All five atomic
  stipulations + four case-tag carrier entries from R1 are
  removed; their content is consolidated into the single
  `gap_lem_prw_reduction` entry below.
-/

/--
  Lemma `\label{lem:prw}` — *Partition-Relative-Weighting
  Reduction*.  Derived theorem composing 9 per-case Cat 3
  `structuralEquation` atoms (v0.8.0 R5 substantive paper-faithful
  decomposition).

  *Status.*  `gapClosed` notInput — `theorem` (no longer `axiom`).
  The downstream theorem `lem_prw_reduction` is derived from
  nine atomic Cat 3 stipulations via case-exhaustion `match` on
  the paper-faithful `WarrantFeatureType` inductive on
  `ArbitrationProcedure.warrantForm`.
-/
def gap_lem_prw_reduction : GapEntry := {
  name := "lem_prw_reduction"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.notInput
  cat3SubType := Cat3SubType.notCat3
  paperSource :=
    "Li 2026, `\\label{lem:prw}` (Partition-Relative-Weighting " ++
    "Reduction) — paper Lemma 1 of the impossibility theorem's " ++
    "proof (paper lines 2079-2270).  Statement (v0.8.0 R5 paper-" ++
    "faithful disjunctive form): for any arbitration procedure `A` " ++
    "whose adjudication-warrant derives from `\\E` alone (i.e., " ++
    "`A.warrantInternalToE`), either `A` reduces to a partition-" ++
    "relative weighting (`A.partitionRelative` — paper options " ++
    "(i.a) / (c.1) / (c.2) / (c.4.a) / contextual-internal) or `A` " ++
    "fails to produce a non-trivial ranking (`A.failsAdjudication` " ++
    "— paper option (ii), the typeB clause).  The external-feature " ++
    "cases (typeC3, typeC4b) are unreachable under " ++
    "`warrantInternalToE` by paper hypothesis (H).  The derivation " ++
    "is case-exhaustion `match` on `A.warrantForm : " ++
    "WarrantFeatureType` discharging each of the nine constructors " ++
    "via the corresponding atomic Cat 3 stipulation: " ++
    "`prw_uniform_to_pr`, `prw_typeA_to_pr`, `prw_typeB_no_ranking`, " ++
    "`prw_typeC1_to_pr`, `prw_typeC2_recursive_to_pr`, " ++
    "`prw_warrantInternalToE_excludes_typeC3` (excluder), " ++
    "`prw_typeC4a_internal_track_to_pr`, " ++
    "`prw_warrantInternalToE_excludes_typeC4b` (excluder), " ++
    "`prw_contextual_to_pr`."
  attackHistory := [
    "v0.2.0 audit (2026-05-13): kept as single atomic axiom on " ++
      "paper's `Lemma carries the load; sub-claims verify " ++
      "exhaustiveness` structure.",
    "v0.3.0 reductionism Cat 1?: CLEAR-NO — Mathlib has no " ++
      "predicate for `warrant derived from \\E alone reduces to " ++
      "partition-relative weighting` on paper-novel " ++
      "`ArbitrationProcedure`.",
    "v0.3.0 reductionism Cat 2?: CLEAR-NO — surveyed external " ++
      "social-choice / arbitration literature (Arrow 1951; Sen " ++
      "1970; Gibbard-Satterthwaite; Saari; Topkis; Brandom): none " ++
      "covers the reduction on these typed carriers.",
    "v0.4.0 v6 §3.4.6 ≥2-round reductionism review: CLEAR-NO " ++
      "outcomes on Cat 1 + Cat 2 reductions for the composite " ++
      "axiom.",
    "v0.5.0 R1 decomposition (2026-05-13): converted axiom→theorem " ++
      "by introducing five paper-novel atomic stipulations " ++
      "(uniform / type-(a) / type-(b) / Partition-Internality / " ++
      "case-exhaustion) on four `Prop`-valued case-tag `def`s " ++
      "(`isUniformWarrant`, `usesTypeAFeature`, `usesTypeBFeature`, " ++
      "`usesTypeCStructuralProperty`) on `ArbitrationProcedure`.  " ++
      "Anti-pattern #13 (conclusion-as-axiom) and #14 (composite-" ++
      "axiom bundling) declared addressed.",
    "v0.6.0 R2 honest revert (2026-05-14): R1 decomposition was " ++
      "COSMETIC — the four case-tag `def`s were axiomatised as " ++
      "`Prop := True`, so the case-exhaustion atom reduced to a " ++
      "triviality (every `A` satisfies all four `True`-tags) and " ++
      "the four case-specific atoms collectively asserted " ++
      "`∀ A, A.partitionRelative` once any single carrier-Prop " ++
      "was inhabited — STRONGER than the original `lem_prw_" ++
      "reduction` content.  Hostile audit verdict: the paper's " ++
      "`\\label{lem:prw}` proof body case-analyses the warrant by " ++
      "LINGUISTIC structural sub-form (uniform vs.\\ contextual; " ++
      "type-(a)/(b)/(c) on the warrant's *justification*-prose), " ++
      "not by a typed predicate on the `ArbitrationProcedure` " ++
      "carrier itself.  Honest revert: single Cat 3 " ++
      "`workingAssumption` axiom with close-target = typed-Warrant " ++
      "refinement.  Five atomic stipulation entries and four " ++
      "case-tag carrier entries from R1 removed; their content " ++
      "consolidated into this single entry pending R5.",
    "v0.8.0 R5 substantive paper-faithful decomposition " ++
      "(2026-05-14): user flagged v0.7.0 stopping point as LAZY; " ++
      "round-5 hostile validator confirmed `lem_prw_reduction` " ++
      "single-axiom encoding as defect #2 (CORE).  R5 fix: " ++
      "introduced typed `WarrantFeatureType` inductive in " ++
      "`Basic.lean` with 9 constructors per paper-case (uniform / " ++
      "typeA / typeB / typeC1 / typeC2_recursive / " ++
      "typeC3_external / typeC4a_internal_track / " ++
      "typeC4b_external_track / contextual), `ArbitrationProcedure` " ++
      "extended with `warrantForm : WarrantFeatureType` field + " ++
      "`failsAdjudication : Prop` field, nine per-case Cat 3 " ++
      "`structuralEquation` atoms in `Impossibility.lean` " ++
      "(seven typed bridges `warrantForm = X → partitionRelative` " ++
      "or `failsAdjudication`, plus two non-occurrence excluders " ++
      "for typeC3 / typeC4b under `warrantInternalToE`), and " ++
      "`lem_prw_reduction` converted axiom → derived theorem " ++
      "via case-exhaustion `match` on the inductive's nine " ++
      "constructors.  Conclusion form is paper-faithful disjunctive " ++
      "`partitionRelative ∨ failsAdjudication` (paper option (i) " ++
      "and option (ii) per `\\label{lem:prw}` proof body + paper " ++
      "lines 2307-2326's three-failure-mode analysis).  P2 " ++
      "definition correspondingly extended with " ++
      "`¬ A.failsAdjudication` conjunct (paper line 2304 'no $A$ " ++
      "satisfying the independence requirement of P2 exists').  " ++
      "Status `gapOpen workingAssumption` → `gapClosed notInput`.  " ++
      "Sub-type `workingAssumption` → `notCat3` (entry is now a " ++
      "derived theorem, not a paper-novel input).",
    "v0.8.0 R5 reductionism Cat 1?: CLEAR-NO — the case-" ++
      "exhaustion derivation uses Lean kernel `match` on a Lean " ++
      "inductive, which is `propext` + `Quot.sound` only.  No " ++
      "Mathlib derivation closed the original gap; the closure " ++
      "is via composition of nine Cat 3 atoms, not via Mathlib.",
    "v0.8.0 R5 reductionism Cat 2?: CLEAR-NO — the nine Cat 3 " ++
      "atoms are individually paper-novel (paper-line cited; no " ++
      "external textbook covers them on these typed carriers)."
  ]
  scope :=
    "`∀ A, A.warrantInternalToE → A.partitionRelative ∨ " ++
    "A.failsAdjudication` on the paper-novel `ArbitrationProcedure` " ++
    "carrier with paper-faithful `WarrantFeatureType` warrant-form " ++
    "classifier.  Derived theorem composing nine atomic Cat 3 " ++
    "`structuralEquation` stipulations via case-exhaustion `match` " ++
    "on the inductive's nine constructors.  Downstream theorems " ++
    "(`thm_impossibility` and its corollaries) consume this " ++
    "derived theorem; P2 definition extended with " ++
    "`¬ A.failsAdjudication` conjunct to match paper option (ii) " ++
    "(adjudication-failure) as a P2-failure mode parallel to " ++
    "option (i) (partition-relativity)."
}

/-! ### v0.8.0 R5 — 9 per-case Cat 3 atomic stipulations
     decomposing `lem_prw_reduction`.

  Each entry is a single-step typed-bridge axiom from a
  `WarrantFeatureType` constructor case-tag to a partition-
  relativity / adjudication-failure conclusion.  Cat 3 sub-type
  `structuralEquation` per v6 §3.4.3.  Status `gapDefinitional`
  per v6 §1.1: paper-stipulated definitional reduction, not
  derivable in Lean.  Paper-line citations on each entry's
  `paperSource` field; cross-citation to the corresponding
  constructor docstring in `Basic.lean WarrantFeatureType` and
  axiom docstring in `Impossibility.lean`.
-/

def gap_WarrantFeatureType_carrier : GapEntry := {
  name := "WarrantFeatureType (inductive)"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.carrier
  paperSource :=
    "Li 2026, `\\label{lem:prw}` proof body (paper lines " ++
    "2079-2270) — warrant-form taxonomy with nine sub-forms: " ++
    "uniform (lines 2092-2102), typeA (lines 2127-2131), typeB " ++
    "(lines 2131-2134), typeC1 (lines 2151-2185), " ++
    "typeC2_recursive (lines 2186-2196), typeC3_external (lines " ++
    "2189-2191), typeC4a_internal_track (lines 2210-2218), " ++
    "typeC4b_external_track (lines 2220-2237), contextual (lines " ++
    "2257-2270)."
  attackHistory := [
    "v0.8.0 R5 introduction (2026-05-14): typed inductive added " ++
      "to `Basic.lean` to surface the paper's `\\label{lem:prw}` " ++
      "warrant-form sub-form taxonomy.  Replaces the v0.6.0 R2 " ++
      "and v0.7.0 R4 single-axiom encoding of `lem_prw_reduction` " ++
      "(which the user flagged as LAZY).  Each constructor cites " ++
      "its paper-line range in its docstring; consumed by the " ++
      "nine per-case atomic Cat 3 stipulations in " ++
      "`Impossibility.lean`.  Sub-type `carrier` per v6 §3.4.1: " ++
      "paper-introduced typed enumeration of warrant sub-forms.",
    "v0.8.0 R5 reductionism Cat 1?: CLEAR-NO — Mathlib has no " ++
      "predicate for 'warrant-form sub-form taxonomy on " ++
      "arbitration procedures'; the inductive's nine constructors " ++
      "correspond one-to-one with paper-cited sub-cases.",
    "v0.8.0 R5 reductionism Cat 2?: CLEAR-NO — the taxonomy is " ++
      "paper-specific to `\\label{lem:prw}`; no external textbook " ++
      "(social-choice, arbitration theory, decision theory) " ++
      "supplies a comparable case-decomposition."
  ]
  scope :=
    "Typed inductive carrier for the paper-faithful 9-case " ++
    "taxonomy on the warrant's structural sub-form from " ++
    "`\\label{lem:prw}` proof body (paper lines 2079-2270).  " ++
    "Encoded as a Lean `inductive`, not an `axiom`; consumed by " ++
    "the nine per-case atomic Cat 3 stipulations in " ++
    "`Impossibility.lean` via `match` exhaustion.  Definitional " ++
    "atom (v6 §3.4.1); never to close (it IS the paper's " ++
    "taxonomy)."
}

def gap_prw_uniform_to_pr : GapEntry := {
  name := "prw_uniform_to_pr"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource :=
    "Li 2026, `\\label{lem:prw}` uniform case (paper lines " ++
    "2092-2102): 'Uniform case: $W$ assigns the same $k$ to all " ++
    "disagreement-cases of $\\Op_i$ vs.\\ $\\Op_j$.  The constant " ++
    "assignment to $\\{i,j\\}$ selects a single $E_m \\in " ++
    "\\{E_i, E_j\\}$ as preferred globally, which is direct " ++
    "single-$E_m$ privileging — explicitly the P2-failure mode " ++
    "forbidden by Definition~\\ref{def:op-properties}'s " ++
    "independence clause.'"
  attackHistory := [
    "v0.8.0 R5 decomposition extracted from `\\label{lem:prw}` " ++
      "case-analysis (2026-05-14).  Sub-type `structuralEquation` " ++
      "per v6 §3.4.3: paper-stated definitional reduction on the " ++
      "paper-novel `ArbitrationProcedure` + `WarrantFeatureType` " ++
      "carriers."
  ]
  scope :=
    "`A.warrantForm = WarrantFeatureType.uniform → " ++
    "A.partitionRelative` on the paper-novel " ++
    "`ArbitrationProcedure` carrier.  Single-step typed bridge."
}

def gap_prw_typeA_to_pr : GapEntry := {
  name := "prw_typeA_to_pr"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource :=
    "Li 2026, `\\label{lem:prw}` type-(a) case (paper lines " ++
    "2127-2131): 'Type-(a): $f$ belongs to some $E_m$.  Then " ++
    "$R$'s appeal to $f$ privileges $E_m$, and the resulting " ++
    "ranking just is single-$E_m$ privileging — option (i).'"
  attackHistory := [
    "v0.8.0 R5 decomposition extracted from `\\label{lem:prw}` " ++
      "case-analysis (2026-05-14).  Sub-type `structuralEquation`."
  ]
  scope :=
    "`A.warrantForm = WarrantFeatureType.typeA → " ++
    "A.partitionRelative` on the paper-novel " ++
    "`ArbitrationProcedure` carrier.  Single-step typed bridge."
}

def gap_prw_typeB_no_ranking : GapEntry := {
  name := "prw_typeB_no_ranking"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.notInput
  cat3SubType := Cat3SubType.notCat3
  paperSource :=
    "Li 2026, `\\label{lem:prw}` type-(b) case (paper lines " ++
    "2131-2134): 'Type-(b): $f$ is shared by all $E_i$ " ++
    "symmetrically, in which case $R$'s output is constant " ++
    "across the $E_i$ and fails to produce a non-trivial " ++
    "ranking — option (ii).'"
  attackHistory := [
    "v0.8.0 R5 Issue 2 decomposition extracted from `\\label{lem:prw}` " ++
      "case-analysis (2026-05-14) as Cat 3 `structuralEquation` " ++
      "axiom.  Distinguished from the other eight per-case atoms: " ++
      "paper option (ii) NOT option (i).",
    "v0.8.0 R5 Issue 3 concretization (2026-05-14): " ++
      "`failsAdjudication` concretized in `Basic.lean` as " ++
      "`A.warrantForm = WarrantFeatureType.typeB` (paper-faithful " ++
      "decidable predicate per paper option (ii) typeB clause).  " ++
      "This atom is now a derived `theorem` (proof: `intro h; " ++
      "exact h`), no longer a Cat 3 axiom.  Status " ++
      "`gapDefinitional` → `gapClosed`; inputCategory " ++
      "`cat3PaperNovel` → `notInput`; sub-type `structuralEquation` " ++
      "→ `notCat3`."
  ]
  scope :=
    "`A.warrantForm = WarrantFeatureType.typeB → " ++
    "A.failsAdjudication` on the paper-novel " ++
    "`ArbitrationProcedure` carrier.  Now a derived theorem " ++
    "(v0.8.0 R5 Issue 3 concretization)."
}

def gap_prw_typeC1_to_pr : GapEntry := {
  name := "prw_typeC1_to_pr"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource :=
    "Li 2026, `\\label{lem:prw}` type-(c.1) case (paper lines " ++
    "2151-2185, esp. 2155-2170): 'the procedure ''adjudicate " ++
    "$\\Op_i$ vs.\\ $\\Op_j$ by routing to whichever of $E_i, " ++
    "E_j$ is higher under the $f^*$-induced ranking $R_{f^*}$'' " ++
    "is a partition-relative weighting of $\\{E_1, \\ldots, " ++
    "E_n\\}$ in the sense forbidden by P2's independence " ++
    "requirement.'"
  attackHistory := [
    "v0.8.0 R5 decomposition extracted from `\\label{lem:prw}` " ++
      "case-analysis (2026-05-14).  Sub-type `structuralEquation`.  " ++
      "Carries the paper's *Partition-Internality of " ++
      "$\\E$-Internal Structural Stipulations* sub-claim."
  ]
  scope :=
    "`A.warrantForm = WarrantFeatureType.typeC1 → " ++
    "A.partitionRelative` on the paper-novel " ++
    "`ArbitrationProcedure` carrier.  Single-step typed bridge."
}

def gap_prw_typeC2_recursive_to_pr : GapEntry := {
  name := "prw_typeC2_recursive_to_pr"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource :=
    "Li 2026, `\\label{lem:prw}` type-(c.2) recursive case (paper " ++
    "lines 2186-2196): '(c.2) appeals to further $\\E$-features to " ++
    "warrant the meta-choice (returning recursively to the type-" ++
    "(a) / type-(b) / type-(c) trichotomy at the meta-level) … " ++
    "Recursive appeal terminates only at types (a), (b), (c.1), " ++
    "or (c.3); none yields admissible adjudication-warrant within " ++
    "the (H)-discourse-state.'"
  attackHistory := [
    "v0.8.0 R5 decomposition extracted from `\\label{lem:prw}` " ++
      "case-analysis (2026-05-14).  Sub-type `structuralEquation`.  " ++
      "Carries paper's recursive descent termination sub-claim: " ++
      "under (H), termination is at (a) / (b) / (c.1) which " ++
      "collectively reduce to partition-relativity."
  ]
  scope :=
    "`A.warrantForm = WarrantFeatureType.typeC2_recursive → " ++
    "A.partitionRelative` on the paper-novel " ++
    "`ArbitrationProcedure` carrier.  Single-step typed bridge."
}

def gap_prw_warrantInternalToE_excludes_typeC3 : GapEntry := {
  name := "prw_warrantInternalToE_excludes_typeC3"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.notInput
  cat3SubType := Cat3SubType.notCat3
  paperSource :=
    "Li 2026, `\\label{lem:prw}` type-(c.3) exclusion (paper lines " ++
    "2189-2191): '(c.3) appeals to features outside $\\E$, which " ++
    "is forbidden by (H); this sub-case's closure is conditional " ++
    "on (H), and within the discourse-state where (H) holds, " ++
    "(c.3) is inadmissible.'"
  attackHistory := [
    "v0.8.0 R5 Issue 2 decomposition extracted from `\\label{lem:prw}` " ++
      "case-analysis (2026-05-14) as Cat 3 `structuralEquation` " ++
      "axiom.  Non-occurrence excluder.",
    "v0.8.0 R5 Issue 3 concretization (2026-05-14): " ++
      "`warrantInternalToE` concretized in `Basic.lean` as the " ++
      "conjunction `warrantForm ≠ typeC3_external ∧ warrantForm ≠ " ++
      "typeC4b_external_track` (paper-faithful decidable predicate " ++
      "per paper hypothesis (H) + paper `\\label{lem:prw}` external-" ++
      "feature case taxonomy).  This excluder is now a derived " ++
      "`theorem` (proof: `intro h; exact h.1`), no longer a Cat 3 " ++
      "axiom.  Status `gapDefinitional` → `gapClosed`; " ++
      "inputCategory `cat3PaperNovel` → `notInput`; sub-type " ++
      "`structuralEquation` → `notCat3`."
  ]
  scope :=
    "`A.warrantInternalToE → A.warrantForm ≠ " ++
    "WarrantFeatureType.typeC3_external` on the paper-novel " ++
    "`ArbitrationProcedure` carrier.  Now a derived theorem " ++
    "(v0.8.0 R5 Issue 3 concretization)."
}

def gap_prw_typeC4a_internal_track_to_pr : GapEntry := {
  name := "prw_typeC4a_internal_track_to_pr"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource :=
    "Li 2026, `\\label{lem:prw}` type-(c.4.a) internal track case " ++
    "(paper lines 2210-2218): '(c.4.a) The track record is " ++
    "internal to $\\E$ (uses only $\\E$-feature-based assessments " ++
    "of past cases): then the meta-criterion is type-(c) and " ++
    "recursively returns to the trichotomy at the meta-level.'"
  attackHistory := [
    "v0.8.0 R5 decomposition extracted from `\\label{lem:prw}` " ++
      "case-analysis (2026-05-14).  Sub-type `structuralEquation`.  " ++
      "The recursive descent terminates at (a) / (b) / (c.1) " ++
      "under (H), reducing to partition-relativity by the " ++
      "typeC2_recursive case treatment."
  ]
  scope :=
    "`A.warrantForm = WarrantFeatureType.typeC4a_internal_track " ++
    "→ A.partitionRelative` on the paper-novel " ++
    "`ArbitrationProcedure` carrier.  Single-step typed bridge."
}

def gap_prw_warrantInternalToE_excludes_typeC4b : GapEntry := {
  name := "prw_warrantInternalToE_excludes_typeC4b"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.notInput
  cat3SubType := Cat3SubType.notCat3
  paperSource :=
    "Li 2026, `\\label{lem:prw}` type-(c.4.b) exclusion (paper " ++
    "lines 2220-2237): '(c.4.b) The track record uses external-" ++
    "to-$\\E$ predictive success … this is exactly the heat-" ++
    "reform escape route.  If such a track record exists and is " ++
    "recognised within $D$ as adjudication-warrant for " ++
    "$\\C$-verdicts, (H) ceases to hold; the discourse-state has " ++
    "changed and the theorem no longer applies.'"
  attackHistory := [
    "v0.8.0 R5 Issue 2 decomposition extracted from `\\label{lem:prw}` " ++
      "case-analysis (2026-05-14) as Cat 3 `structuralEquation` " ++
      "axiom.  Non-occurrence excluder parallel to typeC3.",
    "v0.8.0 R5 Issue 3 concretization (2026-05-14): " ++
      "`warrantInternalToE` concretized in `Basic.lean` as the " ++
      "conjunction `warrantForm ≠ typeC3_external ∧ warrantForm ≠ " ++
      "typeC4b_external_track`.  This excluder is now a derived " ++
      "`theorem` (proof: `intro h; exact h.2`), no longer a Cat 3 " ++
      "axiom.  Status `gapDefinitional` → `gapClosed`; " ++
      "inputCategory `cat3PaperNovel` → `notInput`; sub-type " ++
      "`structuralEquation` → `notCat3`."
  ]
  scope :=
    "`A.warrantInternalToE → A.warrantForm ≠ " ++
    "WarrantFeatureType.typeC4b_external_track` on the paper-" ++
    "novel `ArbitrationProcedure` carrier.  Now a derived theorem " ++
    "(v0.8.0 R5 Issue 3 concretization)."
}

def gap_warrantInternalToE_def : GapEntry := {
  name := "ArbitrationProcedure.warrantInternalToE (def)"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource :=
    "Li 2026, `\\label{thm:impossibility}` hypothesis (H) + " ++
    "`\\label{lem:prw}` external-feature case taxonomy (paper " ++
    "lines 2189-2191 typeC3 + 2220-2237 typeC4b).  Paper " ++
    "hypothesis (H): 'every admissible arbitration procedure " ++
    "within $D$ for adjudicating operationalisations of $\\C$ " ++
    "derives its adjudication-warrant from $\\E$.'"
  attackHistory := [
    "v0.8.0 R5 Issue 3 substantive concretization (2026-05-14): " ++
      "the previously-bare-Prop field `warrantInternalToE` was " ++
      "extracted from `ArbitrationProcedure` and re-encoded as a " ++
      "derived `def` on the paper-faithful `WarrantFeatureType` " ++
      "taxonomy.  Definitional equation: `A.warrantInternalToE` " ++
      "iff `A.warrantForm ∉ {typeC3_external, " ++
      "typeC4b_external_track}`.  Sub-type `structuralEquation` " ++
      "per v6 §3.4.3: paper-stated definitional reduction tying " ++
      "paper hypothesis (H) to the `\\label{lem:prw}` warrant-form " ++
      "taxonomy.  Status `gapDefinitional` (paper-stipulated " ++
      "definitional equation; never to close).  Consequence: the " ++
      "two excluder axioms (`prw_warrantInternalToE_excludes_typeC3` " ++
      "and `prw_warrantInternalToE_excludes_typeC4b`) are now " ++
      "derivable theorems."
  ]
  scope :=
    "Paper-faithful definitional equation `A.warrantInternalToE " ++
    ":= A.warrantForm ≠ typeC3_external ∧ A.warrantForm ≠ " ++
    "typeC4b_external_track` on the paper-novel " ++
    "`ArbitrationProcedure` carrier.  Decidable predicate."
}

def gap_failsAdjudication_def : GapEntry := {
  name := "ArbitrationProcedure.failsAdjudication (def)"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource :=
    "Li 2026, `\\label{lem:prw}` typeB clause (paper line 2133): " ++
    "'$R$'s output is constant across the $E_i$ and fails to " ++
    "produce a non-trivial ranking — option (ii).'"
  attackHistory := [
    "v0.8.0 R5 Issue 3 substantive concretization (2026-05-14): " ++
      "the previously-bare-Prop field `failsAdjudication` was " ++
      "extracted from `ArbitrationProcedure` and re-encoded as a " ++
      "derived `def` on the paper-faithful `WarrantFeatureType` " ++
      "taxonomy.  Definitional equation: `A.failsAdjudication " ++
      "iff A.warrantForm = typeB`.  Sub-type `structuralEquation` " ++
      "per v6 §3.4.3: paper-stated definitional reduction tying " ++
      "paper option (ii) (no-ranking failure mode) to the " ++
      "`\\label{lem:prw}` typeB warrant-form constructor.  Status " ++
      "`gapDefinitional` (paper-stipulated definitional equation; " ++
      "never to close).  Consequence: the typeB stipulation atom " ++
      "(`prw_typeB_no_ranking`) is now a derivable theorem."
  ]
  scope :=
    "Paper-faithful definitional equation `A.failsAdjudication " ++
    ":= A.warrantForm = typeB` on the paper-novel " ++
    "`ArbitrationProcedure` carrier.  Decidable predicate."
}

def gap_prw_contextual_to_pr : GapEntry := {
  name := "prw_contextual_to_pr"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource :=
    "Li 2026, `\\label{lem:prw}` contextual case (paper lines " ++
    "2257-2270): 'In case (ii), the contextual features used by " ++
    "$A$ to discriminate among $\\Tcls$-members are themselves " ++
    "either features of the folk extension $\\E$ or features " ++
    "external to $\\E$.  In the $\\E$-internal sub-case, " ++
    "contextual adjudication assigns each disagreement-case to " ++
    "one of $\\Op_i, \\Op_j$ on the basis of which $\\E$-features " ++
    "the case exhibits; the mapping (which $\\E$-features → which " ++
    "operationalisation) is itself a partition-relative weighting " ++
    "of the $E_i$ over $\\Tcls$.'"
  attackHistory := [
    "v0.8.0 R5 decomposition extracted from `\\label{lem:prw}` " ++
      "case-analysis (2026-05-14).  Sub-type `structuralEquation`.  " ++
      "Encodes the paper's case (ii) (contextual adjudication) " ++
      "reduction in the `\\E`-internal sub-case; the external sub-" ++
      "case of (ii) is excluded by the same (H)-mechanism as " ++
      "typeC3."
  ]
  scope :=
    "`A.warrantForm = WarrantFeatureType.contextual → " ++
    "A.partitionRelative` on the paper-novel " ++
    "`ArbitrationProcedure` carrier.  Single-step typed bridge."
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
  status := GapStatus.gapDefinitional
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
  status := GapStatus.gapDefinitional
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
  status := GapStatus.gapDefinitional
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
  status := GapStatus.gapDefinitional
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
  status := GapStatus.gapDefinitional
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
  status := GapStatus.gapDefinitional
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
  status := GapStatus.gapDefinitional
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
  status := GapStatus.gapDefinitional
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
  status := GapStatus.gapDefinitional
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
  status := GapStatus.gapDefinitional
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
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.hypothesisPredicate
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
      "Net change: 0 reductions found; stays Cat 3.",
    "v0.6.0 R2 (2026-05-14, defect #7): sub-type changed " ++
      "carrier→hypothesisPredicate for consistency with " ++
      "`SessionalCognition` and `BridgingPrinciple` (D3 " ++
      "reclassified in v0.5.0).  Hostile audit verdict: the six " ++
      "abstract `Type` fields (TokenSpace, WeightSpace, " ++
      "ActivationSpace, SessionIndex, InstanceIndex, Context) are " ++
      "stub names never reasoned-with downstream; the load-bearing " ++
      "content lives in the six bare-Prop DSC-axis fields " ++
      "(sessionalP / concurrentP / stateInferenceP / " ++
      "distributionalP / homogeneousP / inversionP) consumed by " ++
      "`SatisfiesDSC`.  Same structural pattern as " ++
      "`SessionalCognition` (Prop bundle V1-V6) and " ++
      "`BridgingPrinciple` (Prop bundle B1.ii/B1.iii/B2 + " ++
      "Mathlib-typed B1.i conjunction).  Per v6 §3.4.2 a Prop-" ++
      "bundle scope-condition structure is sub-type " ++
      "hypothesisPredicate.  The v0.5.0 D3 dominant-content " ++
      "rationale (`CognitiveSystem` retained as carrier on `mixed " ++
      "typing-dominant`) was an inconsistency with the rest of the " ++
      "Prop-bundle classification — the abstract Types are not " ++
      "actually reasoned-with as the load-bearing content."
  ]
  scope :=
    "Typed scope-condition bundle for an abstract cognitive " ++
    "system: six stub `Type` fields (TokenSpace, WeightSpace, " ++
    "ActivationSpace, SessionIndex, InstanceIndex, Context) + " ++
    "inferenceOp + six paper-stipulated bare-Prop DSC-axis " ++
    "fields.  The load-bearing content is the DSC-axis Prop " ++
    "bundle consumed by `SatisfiesDSC`; the stub Types are " ++
    "never reasoned-with downstream.  Encoded as a Lean " ++
    "`structure`."
}

def gap_SessionalCognition_carrier : GapEntry := {
  name := "SessionalCognition (structure)"
  status := GapStatus.gapDefinitional
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
  status := GapStatus.gapDefinitional
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

def gap_thesis_independence_OPEN : GapEntry := {
  name := "thesis_independence (DSC axis mutual independence)"
  status := GapStatus.gapOpen
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.phenomenologicalConjecture
  paperSource :=
    "Li 2026, `\\label{thesis:independence}` (Mutual independence " ++
    "of the six DSC axes; paper §2547-2582 — six paper-supplied " ++
    "independence-witness arguments: `¬Sessional, others held` " ++
    "continuously-running inference daemon; `¬Concurrent, others " ++
    "held` serially-deployed single-instance; `¬State-inference, " ++
    "others held` online-learning LLM with test-time training; " ++
    "`¬Distributional, others held` embodied-RL simulator-trained " ++
    "agent; `¬Homogeneous, others held` hybrid scratchpad " ++
    "architecture; `¬Inversion, others held` exposed-introspective-" ++
    "access system).  Paper §2583-2584: 'The six independence " ++
    "witnesses show that the axes carve genuinely distinct " ++
    "dimensions of LLM-versus-biological structure.'  Resolution " ++
    "path: external philosophical-foundations debate about whether " ++
    "the six counter-model witnesses are architecturally coherent " ++
    "(does the `continuously-running inference daemon` preserve " ++
    "the other five axes? does the `embodied-RL simulator-trained " ++
    "agent` actually fail distributional origin while preserving " ++
    "the rest?).  Resolution is interpretive-debate over paper-" ++
    "stipulated witnesses, NOT Lean derivation."
  attackHistory := [
    "v0.5.0 D6 audit (2026-05-13): retained as gapBlocked.  " ++
      "Reasoning: paper articulates a structural claim about the " ++
      "DSC axis-space (mutual independence) supported by six " ++
      "`coherent hypothetical system` witnesses whose *coherence* " ++
      "is a conceptual-philosophical judgement.  Reclassification " ++
      "to `workingAssumption` (Cat 3) was considered and REJECTED " ++
      "on the rationale `the thesis is not pending derivation, it " ++
      "is a paper-conclusion argued discursively`.",
    "v0.6.0 R2 reclassification (2026-05-14, defect #8): " ++
      "reclassified `gapBlocked → gapOpen` Cat 3 " ++
      "`workingAssumption`.  Hostile audit verdict: the paper " ++
      "EXHIBITS six counter-model witnesses (canonical " ++
      "mathematical independence-proof pattern: for each axis " ++
      "`A_i`, a coherent system satisfying `¬A_i ∧ (∧_{j≠i} A_j)`).  " ++
      "Per v6 §2 the substrate-independence reclassification " ++
      "precedent (R2 in v0.5.0) applies uniformly: paper-" ++
      "articulated substantive claims about phenomena, awaiting " ++
      "future fine-grained-architecture validation, are Cat 3 " ++
      "`workingAssumption`-encoded.  Close-target: Lean " ++
      "encoding of six counter-model witnesses as " ++
      "`CognitiveSystem`-instantiations with explicit Prop-axis " ++
      "assignments (paper-extension work: requires a typed " ++
      "carrier for `architecturally-coherent system " ++
      "instantiation` capturing the paper's coherence judgement).  " ++
      "v0.5.0 D6 retention rationale superseded: distinguishing " ++
      "`paper-conclusion argued discursively` (gapBlocked) from " ++
      "`paper-articulated atomic claim pending typed-witness " ++
      "encoding` (gapOpen workingAssumption) requires the same " ++
      "discipline as substrate-independence — both are paper-" ++
      "exhibited via empirical/conceptual witnesses pending " ++
      "structured Lean encoding.  Uniform application restores " ++
      "v6 precedent consistency.",
    "v0.6.0 R2 reductionism Cat 1?: CLEAR-NO — Mathlib has no " ++
      "`mutually-independent six-axis cognitive-system family` " ++
      "predicate.",
    "v0.6.0 R2 reductionism Cat 2?: CLEAR-NO — paper-novel " ++
      "DSC axis-space; no external textbook theorem covers " ++
      "the six-axis independence on these paper-novel Prop " ++
      "fields.",
    "v0.7.0 R4 reclassification (2026-05-14, R3-MC2 per v6 " ++
      "§3.4.6 Manufactured Recognition R-#27): sub-type " ++
      "changed `workingAssumption` → `phenomenologicalConjecture`.  " ++
      "Hostile-validator verdict: `workingAssumption` (v6 §3.4.4) " ++
      "REQUIRES close before publication via Lean derivation; the " ++
      "v0.6.0 R2 close-target framing (`Lean encoding of six " ++
      "counter-model witnesses as `CognitiveSystem`-instantiations " ++
      "with explicit Prop-axis assignments — paper-extension work`) " ++
      "was a category error.  The paper §2547-2582 EXHIBITS the " ++
      "six counter-model witnesses as paper-stipulated content " ++
      "(continuously-running inference daemon; serially-deployed " ++
      "single-instance; etc.); the load-bearing question is not " ++
      "`encode them in Lean` but `are they architecturally " ++
      "coherent under the paper's coherence judgement?` — a " ++
      "philosophical-foundations debate over architectural " ++
      "feasibility, not a Lean encoding task.  Per v6 §3.4.6, " ++
      "`phenomenologicalConjecture` is the canonical sub-type " ++
      "for paper-published substantive claims awaiting external " ++
      "philosophical-foundations debate.  Status remains " ++
      "`gapOpen` (not Lean-closeable; resolution is external " ++
      "interpretive debate over the paper-stipulated counter-" ++
      "model witnesses)."
  ]
  scope :=
    "The paper §2547-2582 supplies six `coherent hypothetical " ++
    "system` witnesses — for each axis, a paper-stipulated " ++
    "system that fails it while satisfying the other five.  " ++
    "Encoded as a Cat 3 `phenomenologicalConjecture` ledger entry " ++
    "per v6 §3.4.6 (2026-05-14).  Resolution path: external " ++
    "philosophical-foundations debate about whether the six " ++
    "counter-model witnesses are architecturally coherent — i.e., " ++
    "whether each paper-stipulated system actually fails its " ++
    "named axis while preserving the residual five.  This is not " ++
    "Lean encoding work (paper §2547-2582 is paper-stipulated " ++
    "content, not pending derivation); it is interpretive debate " ++
    "over architectural feasibility of the paper-stipulated " ++
    "witnesses.  Resolution is external (philosophy-of-mind / " ++
    "cognitive-architecture community), NOT Lean derivation.  " ++
    "Status `gapOpen` indefinitely."
}

def gap_thesis_joint_OPEN : GapEntry := {
  name := "thesis_joint (DSC joint satisfaction for current LLMs)"
  status := GapStatus.gapOpen
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.phenomenologicalConjecture
  paperSource :=
    "Li 2026, `\\label{thesis:joint}` (Joint satisfaction for " ++
    "current LLMs; paper §2586-2624 — 'The six axes are jointly " ++
    "satisfied by all contemporary deployed LLM systems, where " ++
    "''contemporary'' designates transformer-based autoregressive " ++
    "language models trained on internet-scale text corpora and " ++
    "deployed in stateless inference servers' + per-axis " ++
    "evidence chain).  Paper §2598-2605 `Re-evaluation trigger`: " ++
    "'This thesis must be reapplied to any deployed system that " ++
    "departs from the contemporary-LLM definition by design " ++
    "(e.g., persistent-memory architectures, online-learning " ++
    "systems, multi-modal embodied systems).  The thesis is " ++
    "target-class-relative; applying it to non-contemporary " ++
    "systems requires fresh axis-by-axis assessment.  Future " ++
    "deployed systems satisfying fewer axes would require either " ++
    "redefinition of the target class or modification of the " ++
    "axis set.'  Resolution path: empirical observation of " ++
    "deployed LLM architectures + per-axis re-assessment when " ++
    "next-generation systems (persistent-memory, online-learning, " ++
    "multi-modal embodied) deploy at scale.  Resolution is " ++
    "empirical, NOT Lean derivation."
  attackHistory := [
    "v0.7.0 R4 reclassification (2026-05-14, R3-RC1 per v6 " ++
      "§3.4.6 Manufactured Recognition R-#27): status changed " ++
      "`gapBlocked` → `gapOpen`; inputCategory changed " ++
      "`notInput` → `cat3PaperNovel`; cat3SubType changed " ++
      "`notCat3` → `phenomenologicalConjecture`; entry-binder " ++
      "renamed `gap_thesis_joint_BLOCKED` → " ++
      "`gap_thesis_joint_OPEN`; `name` field dropped any " ++
      "`blocked` suffix (now `thesis_joint (DSC joint " ++
      "satisfaction for current LLMs)`).  Hostile-validator " ++
      "verdict: the v0.6.0 R2 `gapBlocked` + `notInput` " ++
      "classification (with scope `not Lean-formalisable as " ++
      "structural content`) was a category error.  `gapBlocked` " ++
      "is reserved for genuine no-acceptance-possible routes " ++
      "(folkloric with no specific paper, externally-conjectured-" ++
      "unproven, OR no source at all) per v6 §2; `thesis_joint` " ++
      "is a paper-PUBLISHED substantive claim about phenomena " ++
      "(current deployed LLM architectures) awaiting external " ++
      "validation (empirical observation of next-generation " ++
      "deployed systems; paper §2598-2605 explicit reapplication-" ++
      "trigger language identifies the exact trigger conditions: " ++
      "`persistent-memory architectures, online-learning systems, " ++
      "multi-modal embodied systems`).  Per v6 §3.4.6, " ++
      "`phenomenologicalConjecture` is the canonical sub-type " ++
      "for paper-published substantive claims about phenomena " ++
      "awaiting external (empirical / interpretive) validation.  " ++
      "Resolution path is empirical, NOT Lean derivation.",
    "v0.7.0 R4 reductionism Cat 1?: CLEAR-NO — Mathlib has no " ++
      "predicate for `joint satisfaction of six DSC axes on " ++
      "contemporary deployed transformer LLMs`.",
    "v0.7.0 R4 reductionism Cat 2?: CLEAR-NO — paper-novel " ++
      "DSC axis-space; no external textbook theorem covers " ++
      "joint satisfaction on these paper-novel Prop fields " ++
      "applied to contemporary deployed LLM systems."
  ]
  scope :=
    "Empirical-substantive claim: contemporary transformer-based " ++
    "autoregressive LLMs jointly satisfy the six DSC axes.  " ++
    "Encoded as a Cat 3 `phenomenologicalConjecture` ledger " ++
    "entry per v6 §3.4.6 (2026-05-14).  Resolution path " ++
    "(paper §2598-2605 `Re-evaluation trigger`): empirical " ++
    "re-assessment when next-generation deployed systems " ++
    "(persistent-memory architectures, online-learning systems, " ++
    "multi-modal embodied systems) reach scale.  Paper " ++
    "EXPLICITLY supplies the reapplication trigger: future " ++
    "deployed systems satisfying fewer axes would require " ++
    "either redefinition of the target class or modification " ++
    "of the axis set.  Resolution is empirical, NOT Lean " ++
    "derivation.  Status `gapOpen` indefinitely (target-class-" ++
    "relative; reapplied per generation of deployed systems)."
}

def gap_thesis_minimality_OPEN : GapEntry := {
  name := "thesis_minimality (DSC minimality wrt blocking jobs)"
  status := GapStatus.gapOpen
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.phenomenologicalConjecture
  paperSource :=
    "Li 2026, `\\label{thesis:minimality}` (Minimality with " ++
    "respect to identified blocking jobs; paper §2629-2699 " ++
    "exhibits six locution-axis-blocking witnesses — `Drop " ++
    "sessional existence` ⇒ inter-session reflection unblocked; " ++
    "`Drop concurrent multiplicity` ⇒ system-wide-unified-" ++
    "subject locution unblocked; `Drop state-inference " ++
    "dichotomy` ⇒ continuous-coupling locution unblocked; " ++
    "`Drop distributional origin` ⇒ perception locution " ++
    "unblocked; `Drop homogeneous generation` ⇒ silent-" ++
    "deliberation locution unblocked; `Drop interpretability " ++
    "inversion` ⇒ privileged-access locution unblocked).  " ++
    "Resolution path (paper §2701-2716 `Relativity of the " ++
    "minimality claim`): paper EXPLICITLY frames the " ++
    "minimality claim as relative-to-the-taxonomy, not " ++
    "absolute — 'the framework does not foreclose [the " ++
    "possibility that a different six-leak taxonomy could be " ++
    "addressed by a smaller axis-set]'; 'the burden is on the " ++
    "alternative proposer to identify the leak taxonomy and the " ++
    "smaller blocking axis-set jointly.'  Resolution = " ++
    "identification of alternative leak taxonomies / " ++
    "philosophical-foundations debate about whether the six " ++
    "identified blocking categories are exhaustive or " ++
    "recombinable.  Resolution is external interpretive debate, " ++
    "NOT Lean derivation."
  attackHistory := [
    "v0.5.0 D6 audit (2026-05-13): retained as gapBlocked.  " ++
      "Reasoning: paper articulates a structural minimality claim " ++
      "supported by six paper-supplied natural-language locutions " ++
      "plus informal arguments about which axes block which " ++
      "locutions.  Reclassification to `workingAssumption` (Cat 3) " ++
      "was considered and REJECTED on the rationale `the thesis " ++
      "is not pending derivation; it is a paper-conclusion argued " ++
      "via natural-language locutions, and the absence of a typed " ++
      "locution-space is a paper-side framing choice (not a " ++
      "Mathlib gap)`.",
    "v0.6.0 R2 reclassification (2026-05-14, defect #8): " ++
      "reclassified `gapBlocked → gapOpen` Cat 3 " ++
      "`workingAssumption`.  Hostile audit verdict: the paper " ++
      "EXHIBITS six locution-axis-blocking witnesses (canonical " ++
      "minimality-proof pattern: for each axis `A_i`, a locution " ++
      "`L_i` that the residual five `{A_j : j ≠ i}` jointly fail " ++
      "to block).  Per v6 §2 the substrate-independence " ++
      "reclassification precedent (R2 in v0.5.0) applies " ++
      "uniformly: paper-articulated substantive claims supported " ++
      "by paper-exhibited witnesses are Cat 3 `workingAssumption`-" ++
      "encoded.  Close-target: Lean encoding of six locution-axis-" ++
      "blocking witnesses — a typed carrier for `biological-" ++
      "vocabulary leak categories`, a typed `blocks` relation " ++
      "between axes and locutions, and the six per-axis " ++
      "locution-axis-blocking-failure witnesses (paper-extension " ++
      "work).  v0.5.0 D6 retention rationale superseded for the " ++
      "same precedent-consistency reason as `thesis_independence` " ++
      "above.",
    "v0.6.0 R2 reductionism Cat 1?: CLEAR-NO — Mathlib has no " ++
      "`locution-axis-blocking` predicate on cognitive-system " ++
      "axis-families.",
    "v0.6.0 R2 reductionism Cat 2?: CLEAR-NO — paper-novel " ++
      "DSC-blocking taxonomy; no external textbook theorem " ++
      "covers minimality on these paper-novel Prop fields.",
    "v0.7.0 R4 reclassification (2026-05-14, R3-MC3 per v6 " ++
      "§3.4.6 Manufactured Recognition R-#27): sub-type " ++
      "changed `workingAssumption` → `phenomenologicalConjecture`.  " ++
      "Hostile-validator verdict: paper §2701-2716 `Relativity " ++
      "of the minimality claim` EXPLICITLY frames the " ++
      "minimality argument as relative-to-the-taxonomy, not " ++
      "absolute — 'the framework does not foreclose [the " ++
      "possibility that a different six-leak taxonomy could be " ++
      "addressed by a smaller axis-set]'; 'the burden is on " ++
      "the alternative proposer to identify the leak taxonomy " ++
      "and the smaller blocking axis-set jointly.'  This is not " ++
      "a Lean-derivation close-target (the paper's claim is " ++
      "explicitly the weaker conditional one, not the universal); " ++
      "the resolution path is identification of alternative " ++
      "leak taxonomies via philosophical-foundations debate, " ++
      "NOT Lean encoding.  The v0.6.0 R2 close-target framing " ++
      "(`introduce a typed `LeakCategory` carrier + `blocks` " ++
      "relation, then exhibit six counter-witnesses showing " ++
      "minimality — paper-extension work`) was a category " ++
      "error: even with the typed carrier, the load-bearing " ++
      "question is `is the six-leak taxonomy itself the right " ++
      "taxonomy?` — paper §2701-2716 declines to foreclose this " ++
      "interpretively.  Per v6 §3.4.6, " ++
      "`phenomenologicalConjecture` is the canonical sub-type.  " ++
      "Status remains `gapOpen` (not Lean-closeable; " ++
      "resolution is external interpretive debate over " ++
      "alternative leak taxonomies)."
  ]
  scope :=
    "For each of the six DSC axes, the paper §2629-2699 exhibits " ++
    "a biological-vocabulary locution that the remaining five " ++
    "jointly fail to block.  Encoded as a Cat 3 " ++
    "`phenomenologicalConjecture` ledger entry per v6 §3.4.6 " ++
    "(2026-05-14).  Resolution path (paper §2701-2716 " ++
    "`Relativity of the minimality claim`): identification of " ++
    "alternative leak taxonomies + philosophical-foundations " ++
    "debate about whether the paper's six-leak taxonomy is " ++
    "exhaustive or recombinable.  Paper EXPLICITLY frames the " ++
    "minimality claim as relative-to-the-taxonomy not " ++
    "absolute, with the burden of identifying an alternative " ++
    "taxonomy + smaller blocking axis-set on the alternative " ++
    "proposer.  Resolution is external interpretive debate, NOT " ++
    "Lean derivation.  Status `gapOpen` indefinitely."
}

def gap_substrate_independence_triple_use_OPEN : GapEntry := {
  name := "substrate_independence_triple_use_premise"
  status := GapStatus.gapOpen
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.phenomenologicalConjecture
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
    "or four independent premises.'  Paper also: `Symmetric " ++
    "epistemic posture: the framework\\'s substrate-independence " ++
    "claim is defeasible by future fine-grained substrate " ++
    "findings`; `Operational threshold for substrate-independence " ++
    "reapplication: should be reapplied if either (a) a finer-" ++
    "grained substrate decomposition achieves consensus in " ++
    "cognitive neuroscience or (b) the cross-substrate " ++
    "disagreements among IIT/GWT/HOT/AST are shown to track that " ++
    "finer-grained substrate.'  Resolution path (paper lines 485-" ++
    "492): operational reapplication threshold — Cochrane/PRISMA-" ++
    "style systematic review or major-society position statement " ++
    "endorsing a finer-grained substrate decomposition OR a " ++
    "finding that IIT/GWT/HOT/AST cross-substrate disagreements " ++
    "track that finer-grained substrate.  Resolution is empirical-" ++
    "consensus, NOT Lean derivation."
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
      "citation docstring (status gapOpen).'  An `axiom " ++
      "SubstrateIndependenceTripleUse : Prop` was added to " ++
      "`Basic.lean`.",
    "v0.5.0 R2 reductionism Cat 1?: CLEAR-NO — Mathlib has no " ++
      "`substrate-independence` predicate on `CognitiveSystem`-pairs.",
    "v0.5.0 R2 reductionism Cat 2?: CLEAR-NO — substrate-" ++
      "independence is the paper\\'s own empirical-discursive " ++
      "premise; no external textbook theorem corresponds to the " ++
      "paper\\'s specific triple-use framing across E2b/D1 Route " ++
      "2/impossibility-theorem-application.",
    "v0.6.0 R2 (2026-05-14, defects #4 + #5 + #6): the " ++
      "underlying naked-`Prop` axiom `SubstrateIndependenceTripleUse " ++
      ": Prop` was DELETED from `Basic.lean`.  Defect #4: the " ++
      "naked `Prop` axiom violated `AxiomAudit.lean` line 30 " ++
      "self-policy `No (E) custom-scaffolding axioms (naked " ++
      "constants, abstract-type-inhabitation stipulations)`.  " ++
      "Defect #5: anti-pattern #7 phantom downstream user — no " ++
      "theorem consumed the axiom, so the axiom was scaffolding-" ++
      "only with no Lean dependency consumption.  Defect #6: " ++
      "sub-type changed `hypothesisPredicate` → `workingAssumption` " ++
      "per v6 §3.4.4.  Paper frames the premise EXPLICITLY as " ++
      "defeasible / pending validation ('Symmetric epistemic " ++
      "posture: defeasible by future fine-grained substrate " ++
      "findings'; 'Operational threshold for substrate-" ++
      "independence reapplication: should be reapplied if " ++
      "[fine-grained substrate consensus] or [cross-substrate " ++
      "disagreement tracks finer-grained substrate]').  This is " ++
      "explicitly working-assumption phrasing (an empirical " ++
      "premise pending validation/falsification), not a " ++
      "hypothesisPredicate (which would be a paper-stipulated " ++
      "scope condition NOT pending validation).  Per v6 §3.4.4, " ++
      "the premise is a temporarily-axiomatized higher-level " ++
      "claim pending derivation/validation; close-target = wire " ++
      "into a typed downstream theorem (LLM-target extension of " ++
      "the impossibility theorem) when paper-extension work " ++
      "introduces the appropriate typed carrier.  Until then, " ++
      "the premise lives as a ledger entry without an underlying " ++
      "Lean axiom; the reclassification precedent here is what " ++
      "drives the uniform application to `thesis_independence` " ++
      "and `thesis_minimality` (defect #8).",
    "v0.7.0 R4 reclassification (2026-05-14, R3-MC1 per v6 " ++
      "§3.4.6 Manufactured Recognition R-#27): sub-type changed " ++
      "`workingAssumption` → `phenomenologicalConjecture`.  " ++
      "Hostile-validator verdict: `workingAssumption` (v6 §3.4.4) " ++
      "REQUIRES close before publication and is intended for " ++
      "Millennium-grade DERIVATIONAL work where the close-target " ++
      "is a Lean proof.  Substrate-independence is a published " ++
      "substantive empirical claim awaiting EXTERNAL validation " ++
      "(cognitive-neuroscience consensus on finer-grained " ++
      "substrate decomposition OR finding that IIT/GWT/HOT/AST " ++
      "cross-substrate disagreements track that finer-grained " ++
      "substrate) — paper lines 485-492 specify the operational " ++
      "threshold for reapplication: Cochrane/PRISMA-style " ++
      "systematic review or major-society position statement.  " ++
      "Resolution path is empirical-consensus, NOT Lean derivation; " ++
      "the close-target framing under `workingAssumption` " ++
      "(`wire into a typed downstream theorem when paper-" ++
      "extension work introduces the appropriate typed carrier`) " ++
      "was a category error: the premise is not pending a " ++
      "derivation, it is pending external falsification or " ++
      "endorsement.  Per v6 §3.4.6, `phenomenologicalConjecture` " ++
      "is the canonical sub-type for framework-paper PUBLISHED " ++
      "substantive claims about phenomena awaiting external " ++
      "validation.  Status remains `gapOpen` (NOT closeable via " ++
      "Lean; resolution is external)."
  ]
  scope :=
    "Paper-articulated phenomenological-conjecture premise: a " ++
    "single discourse-state empirical claim (substrate-" ++
    "independence at current cognitive-neuroscience resolution) " ++
    "underwriting three downstream framework uses for the LLM-" ++
    "elimination verdict (E2b transferability; D1 Route 2; " ++
    "impossibility-theorem application to the LLM target).  " ++
    "Encoded as a ledger entry WITHOUT an underlying Lean axiom " ++
    "(the v0.5.0 naked-Prop axiom `SubstrateIndependenceTripleUse " ++
    ": Prop` was deleted in v0.6.0).  Sub-type " ++
    "`phenomenologicalConjecture` per v6 §3.4.6 (2026-05-14): " ++
    "the paper publishes the premise as a defeasible empirical " ++
    "claim, with an explicit operational reapplication threshold " ++
    "(paper lines 485-492: Cochrane/PRISMA-style systematic " ++
    "review of finer-grained substrate decomposition OR major-" ++
    "society position statement that IIT/GWT/HOT/AST cross-" ++
    "substrate disagreements track a finer-grained substrate).  " ++
    "Resolution path = empirical-consensus falsification or " ++
    "endorsement, NOT Lean derivation.  Status remains `gapOpen` " ++
    "indefinitely (never Lean-closeable; resolution is external)."
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

def gap_calibration_table_OPEN : GapEntry := {
  name := "tab_calibration (ten-case historical retrodiction)"
  status := GapStatus.gapOpen
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.phenomenologicalConjecture
  paperSource :=
    "Li 2026, `\\label{tab:calibration}` and `\\label{sec:" ++
    "calibration}` (ten paradigm cases — heat, gene, force, " ++
    "attention, memory, phlogiston, vital force, race, witchcraft, " ++
    "instinct — retrodicted by the discriminator); also " ++
    "`\\label{thesis:calibration}` ('The discriminator correctly " ++
    "retrodicts the eliminate-versus-reform trajectory of all ten " ++
    "historical paradigm cases when applied with information " ++
    "available at peak contestation').  Paper §1653-1668 " ++
    "`Caveat on retrodictive D3`: 'D3 (successor-program " ++
    "productivity) is the discriminator condition most vulnerable " ++
    "to retrodictive bias: in five of the eliminated cases, the " ++
    "analyst knows in advance that a successor consolidated.  " ++
    "The retrodiction status of D3 in the historical cases is " ++
    "therefore weaker than D1 and D2, both of which can be " ++
    "assessed from contemporaneous publications.'  Resolution " ++
    "path: historian / philosopher-of-science debate about the " ++
    "retrodictive D1/D2/D3 labels (e.g., does `heat` warrant " ++
    "(D1=no, D2=no) at peak contestation? does `phlogiston` " ++
    "warrant (D1=yes, D2=yes, D3=yes)?).  Resolution is " ++
    "interpretive-historical, NOT Lean derivation."
  attackHistory := [
    "v0.7.0 R4 reclassification (2026-05-14, R3-RC2 per v6 " ++
      "§3.4.6 Manufactured Recognition R-#27): status changed " ++
      "`gapBlocked` → `gapOpen`; inputCategory changed " ++
      "`notInput` → `cat3PaperNovel`; cat3SubType changed " ++
      "`notCat3` → `phenomenologicalConjecture`; entry-binder " ++
      "renamed `gap_calibration_table_BLOCKED` → " ++
      "`gap_calibration_table_OPEN`; `name` field dropped any " ++
      "`blocked` suffix (now `tab_calibration (ten-case " ++
      "historical retrodiction)`).  Hostile-validator verdict: " ++
      "the v0.6.0 R2 `gapBlocked` + `notInput` classification " ++
      "(with scope `empirical content outside Lean's structural-" ++
      "skeleton scope`) was a category error.  `gapBlocked` is " ++
      "reserved for genuine no-acceptance-possible routes per " ++
      "v6 §2; `tab_calibration` is a paper-PUBLISHED substantive " ++
      "claim about phenomena (per-case D1/D2/D3 ratings on ten " ++
      "historical concepts + the overall retrodiction-correctness " ++
      "verdict `\\label{thesis:calibration}`) awaiting external " ++
      "validation (historian / philosopher-of-science debate " ++
      "about the retrodictive labels; paper §1653-1668 " ++
      "EXPLICITLY hedges D3 as 'most vulnerable to retrodictive " ++
      "bias' and supplies a D1+D2-only sub-rule retrodicting " ++
      "9/10 unambiguously plus 1/10 borderline as a falsifiability " ++
      "anchor).  Per v6 §3.4.6, `phenomenologicalConjecture` is " ++
      "the canonical sub-type for paper-published substantive " ++
      "claims about phenomena awaiting external interpretive " ++
      "validation.  Resolution path is interpretive-historical, " ++
      "NOT Lean derivation.",
    "v0.7.0 R4 reductionism Cat 1?: CLEAR-NO — Mathlib has no " ++
      "predicate for `historical-concept retrodiction with " ++
      "D1/D2/D3 ratings`.",
    "v0.7.0 R4 reductionism Cat 2?: CLEAR-NO — paper-novel " ++
      "ten-case retrodiction structure; no external textbook " ++
      "theorem covers the per-case rating assignments on " ++
      "these paper-novel Prop fields."
  ]
  scope :=
    "Paper-published substantive claim about phenomena: per-case " ++
    "D1/D2/D3 rating assignments to ten historical paradigm " ++
    "concepts (heat, gene, force, attention, memory, " ++
    "phlogiston, vital force, race-as-natural-kind, witchcraft, " ++
    "instinct) underwriting `\\label{thesis:calibration}` " ++
    "('The discriminator correctly retrodicts the eliminate-" ++
    "versus-reform trajectory of all ten historical paradigm " ++
    "cases when applied with information available at peak " ++
    "contestation').  Encoded as a Cat 3 " ++
    "`phenomenologicalConjecture` ledger entry per v6 §3.4.6 " ++
    "(2026-05-14).  Resolution path (paper §1653-1668 " ++
    "`Caveat on retrodictive D3` + `\\label{thesis:calibration}`): " ++
    "historian / philosopher-of-science debate about the " ++
    "retrodictive D1/D2/D3 labels per case.  Paper EXPLICITLY " ++
    "hedges D3 as `most vulnerable to retrodictive bias` and " ++
    "supplies a D1+D2-only sub-rule (9/10 unambiguous + 1/10 " ++
    "borderline) as a falsifiability anchor.  The discriminator " ++
    "*rules* themselves are Lean-formalised in " ++
    "`Diagnostic.lean`; the per-case *labels* + the " ++
    "10/10-retrodiction *verdict* are the phenomenological " ++
    "content awaiting external validation.  Resolution is " ++
    "interpretive-historical, NOT Lean derivation.  Status " ++
    "`gapOpen` indefinitely."
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
  -- Lemma `\label{lem:prw}` — derived theorem composing 9 per-case
  -- atomic stipulations (v0.8.0 R5 substantive decomposition).
  gap_lem_prw_reduction,
  -- 9 per-case Cat 3 atomic stipulations + WarrantFeatureType carrier
  -- (v0.8.0 R5 decomposition of `lem_prw_reduction`).
  gap_WarrantFeatureType_carrier,
  gap_prw_uniform_to_pr,
  gap_prw_typeA_to_pr,
  gap_prw_typeB_no_ranking,
  gap_prw_typeC1_to_pr,
  gap_prw_typeC2_recursive_to_pr,
  gap_prw_warrantInternalToE_excludes_typeC3,
  gap_prw_typeC4a_internal_track_to_pr,
  gap_prw_warrantInternalToE_excludes_typeC4b,
  gap_prw_contextual_to_pr,
  -- 2 paper-faithful definitional-equation `def`s tying paper
  -- scope conditions to the `WarrantFeatureType` taxonomy
  -- (v0.8.0 R5 Issue 3 substantive concretization).
  gap_warrantInternalToE_def,
  gap_failsAdjudication_def,
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
  -- Cat 3 phenomenologicalConjecture entries (paper-published
  -- substantive claims about phenomena awaiting external
  -- validation; v0.7.0 R4 reclassification per v6 §3.4.6
  -- Manufactured Recognition R-#27)
  gap_thesis_independence_OPEN,
  gap_thesis_minimality_OPEN,
  gap_thesis_joint_OPEN,
  gap_calibration_table_OPEN,
  gap_substrate_independence_triple_use_OPEN,
  -- gapBlocked entries (protocol / policy design proposals, not
  -- substantive empirical claims awaiting external validation)
  gap_testimony_protocol_BLOCKED,
  gap_ai_governance_applications_BLOCKED
]

/-- Status-keyed counts:
    `(open, partial, blocked, deadEnd, closed, closedConditional,
       definitional)`.
    The 7th slot (`gapDefinitional`) was added 2026-05-14 per
    v6 §1.1 / Manufactured Recognition R-#27/R-#28. -/
def gapCounts : Nat × Nat × Nat × Nat × Nat × Nat × Nat :=
  let countWhere (s : GapStatus) : Nat :=
    (allGaps.filter (fun g => g.status = s)).length
  ( countWhere GapStatus.gapOpen
  , countWhere GapStatus.gapPartial
  , countWhere GapStatus.gapBlocked
  , countWhere GapStatus.gapDeadEnd
  , countWhere GapStatus.gapClosed
  , countWhere GapStatus.gapClosedConditional
  , countWhere GapStatus.gapDefinitional )

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
       conditionalHypothesis, phenomenologicalConjecture, notCat3)`.
    The 6th slot (`phenomenologicalConjecture`) was added 2026-05-14
    per v6 §3.4.6. -/
def cat3SubTypeCounts : Nat × Nat × Nat × Nat × Nat × Nat × Nat :=
  let countWhere (s : Cat3SubType) : Nat :=
    (allGaps.filter (fun g => g.cat3SubType = s)).length
  ( countWhere Cat3SubType.carrier
  , countWhere Cat3SubType.hypothesisPredicate
  , countWhere Cat3SubType.structuralEquation
  , countWhere Cat3SubType.workingAssumption
  , countWhere Cat3SubType.conditionalHypothesis
  , countWhere Cat3SubType.phenomenologicalConjecture
  , countWhere Cat3SubType.notCat3 )

#eval s!"AsymmetricEliminativism gap-ledger inventory (status):    open={(gapCounts).1} partial={(gapCounts).2.1} blocked={(gapCounts).2.2.1} deadEnd={(gapCounts).2.2.2.1} closed={(gapCounts).2.2.2.2.1} closedConditional={(gapCounts).2.2.2.2.2.1} definitional={(gapCounts).2.2.2.2.2.2}"

#eval s!"AsymmetricEliminativism gap-ledger inventory (input):     cat1Mathlib={(inputCategoryCounts).1} cat2External={(inputCategoryCounts).2.1} cat3PaperNovel={(inputCategoryCounts).2.2.1} notInput={(inputCategoryCounts).2.2.2}"

#eval s!"AsymmetricEliminativism gap-ledger inventory (Cat 3 sub): carrier={(cat3SubTypeCounts).1} hypothesisPredicate={(cat3SubTypeCounts).2.1} structuralEquation={(cat3SubTypeCounts).2.2.1} workingAssumption={(cat3SubTypeCounts).2.2.2.1} conditionalHypothesis={(cat3SubTypeCounts).2.2.2.2.1} phenomenologicalConjecture={(cat3SubTypeCounts).2.2.2.2.2.1} notCat3={(cat3SubTypeCounts).2.2.2.2.2.2}"

#eval s!"Total entries: {allGaps.length}"

/-! ### Inventory summary (v0.7.0 post-R4 v6 §3.4.6 compliance)

  The live status / input-category / Cat 3 sub-type counts are
  printed by the `#eval` calls above (run `lake env lean
  AsymmetricEliminativism/Ledger.lean` to see them).

  *Cat 3 atomic inputs (paper-side atomic-input inventory):*

    Cat 3 paper-novel working-assumption for Lemma `\label{lem:prw}`
    (1 entry; sub-type `workingAssumption`; v0.6.0 R2 honest
    revert):
      lem_prw_reduction.

    Cat 3 paper-novel typed carriers
    (sub-type `carrier`; encoded as Lean `structure` /
    `def` / `class`, NOT as `axiom` declarations):
      ReverseDefinedConcept, ReverseDefinedWitness,
      DiagnosticProfile, MutuallyUnrankedPartition,
      Operationalisation, DiscriminatorRow.

    Cat 3 paper-novel hypothesis/scope-condition bundles
    (sub-type `hypothesisPredicate`; encoded as Lean
    `structure` bundling Prop-valued scope conditions):
      AsymmetricEliminationVerdict, UseSeparability,
      FaithfulP1, ArbitrationProcedure (D2 reclassified),
      CognitiveSystem (v0.6.0 R2 D7 reclassified for
      consistency with the other Prop-bundle scope
      structures),
      SessionalCognition (D3 reclassified),
      BridgingPrinciple (D3 reclassified).

    Cat 3 paper-novel phenomenological-conjecture entries
    (sub-type `phenomenologicalConjecture`; v0.7.0 R4
    reclassification per v6 §3.4.6 / Manufactured Recognition
    R-#27 — framework-paper PUBLISHED substantive claims about
    phenomena awaiting EXTERNAL validation; resolution path =
    battery / cohort study / interpretive debate, NOT Lean
    derivation; status remains `gapOpen` indefinitely):
      substrate_independence_triple_use_premise (R4 R3-MC1
        sub-type `workingAssumption` → `phenomenologicalConjecture`;
        resolution path = operational reapplication threshold
        per paper lines 485-492),
      thesis_independence (R4 R3-MC2 sub-type
        `workingAssumption` → `phenomenologicalConjecture`;
        resolution path = philosophical-foundations debate about
        architectural coherence of the six counter-model
        witnesses per paper §2547-2582),
      thesis_minimality (R4 R3-MC3 sub-type
        `workingAssumption` → `phenomenologicalConjecture`;
        resolution path = identification of alternative leak
        taxonomies per paper §2701-2716),
      thesis_joint (R4 R3-RC1 status `gapBlocked` → `gapOpen`,
        inputCategory `notInput` → `cat3PaperNovel`, sub-type
        `notCat3` → `phenomenologicalConjecture`; resolution
        path = empirical reapplication trigger for
        persistent-memory / online-learning / multi-modal
        embodied architectures per paper §2598-2605),
      tab_calibration (R4 R3-RC2 status `gapBlocked` →
        `gapOpen`, inputCategory `notInput` → `cat3PaperNovel`,
        sub-type `notCat3` → `phenomenologicalConjecture`;
        resolution path = historian / philosopher-of-science
        debate about the retrodictive D1/D2/D3 labels per
        paper §1653-1668).

  *Derived theorems and `notInput`-classified entries* (encoded as
  Lean `theorem` declarations, NOT as `axiom`):

    * Top-level theorems: `thm_impossibility`,
      `thm_impossibility_paper_form`, `bridging_dsc_iff_sc`,
      `satisfiesP3_of_boolean`.
    * Discriminator threshold-rule lemmas (7 entries).
    * Impossibility-theorem corollaries (3 entries).
    * gapBlocked retentions (protocol / policy design proposals,
      NOT substantive empirical claims awaiting external
      validation — `prot_testimony` is an
      epistemology-of-evidence protocol design proposal for
      LLM self-report sampling; `ai_governance_applications`
      is a policy-application sketch).  These retentions are
      CORRECT per v6 §2 `gapBlocked` reservation (no-acceptance-
      possible: outside Lean's structural-mathematical scope
      as protocol / policy proposals, NOT paper-published
      substantive empirical-phenomenological claims awaiting
      external validation).

  Lean kernel (Cat 0; not declared here):
    propext, Classical.choice, Quot.sound.

  *Project has zero Cat 1 axioms* (no Mathlib-derivability claims
  pending discharge) and *zero Cat 2 axioms* (no external
  textbook citations).  All atomic inputs are Cat 3 paper-novel.

  *Cat 3 sub-types not used in this project:* `structuralEquation`
  (no paper-stated structural-defining-equation atoms beyond what
  is encoded inside the paper-novel structure definitions
  themselves), `conditionalHypothesis` (no external-open-problem-
  conditional results).  Both `workingAssumption` and
  `phenomenologicalConjecture` sub-types are now populated
  (1 entry / 5 entries respectively post-R4).

  *v0.7.0 changelog summary (round 4 v6 §3.4.6 compliance —
  phenomenologicalConjecture sub-type added per Manufactured
  Recognition R-#27; R3 hostile-validator priority-ordered):*

    * R3-A (CRITICAL): `Cat3SubType` inductive — added 6th
      constructor `phenomenologicalConjecture` between
      `conditionalHypothesis` and `notCat3`.  Framework-paper
      PUBLISHED substantive claim about a phenomenon awaiting
      EXTERNAL validation; distinguished from
      `workingAssumption` (which mandates close before
      publication via Lean derivation — applies to Millennium-
      grade derivational work) AND from `definitional atom`
      (which is paper-stipulated structure, not phenomenological
      assertion).  Never Lean-closeable; resolution path =
      battery / cohort study / interpretive debate, NOT
      derivation.  Status remains `gapOpen`.

    * R3-B (CRITICAL): `cat3SubTypeCounts` def extended to
      7-tuple `Nat × Nat × Nat × Nat × Nat × Nat × Nat`
      (added `phenomenologicalConjecture` slot between
      `conditionalHypothesis` and `notCat3`).  Corresponding
      `#eval` print line updated.

    * R3-MC1: `substrate_independence_triple_use_premise`
      reclassified `workingAssumption` →
      `phenomenologicalConjecture`.  The v0.6.0 R2 close-
      target framing (`wire into a typed downstream theorem
      when paper-extension work introduces the appropriate
      typed carrier`) was a category error: the premise is
      not pending Lean derivation, it is pending external
      empirical falsification or endorsement.  Paper lines
      485-492 supply the operational reapplication threshold
      (Cochrane/PRISMA systematic review or major-society
      position statement).

    * R3-MC2: `thesis_independence` reclassified
      `workingAssumption` → `phenomenologicalConjecture`.  The
      v0.6.0 R2 close-target framing (`Lean encoding of six
      counter-model witnesses — paper-extension work`) was a
      category error: paper §2547-2582 EXHIBITS the six
      counter-model witnesses as paper-stipulated content; the
      load-bearing question is `are they architecturally
      coherent under the paper's coherence judgement?` — a
      philosophical-foundations debate, not a Lean encoding
      task.

    * R3-MC3: `thesis_minimality` reclassified
      `workingAssumption` → `phenomenologicalConjecture`.
      Paper §2701-2716 `Relativity of the minimality claim`
      EXPLICITLY frames the minimality argument as relative-
      to-the-taxonomy, not absolute; resolution path =
      identification of alternative leak taxonomies via
      philosophical-foundations debate.

    * R3-RC1: `thesis_joint` reclassified `gapBlocked` →
      `gapOpen` + `notInput` → `cat3PaperNovel` + `notCat3`
      → `phenomenologicalConjecture`; entry-binder renamed
      `gap_thesis_joint_BLOCKED` → `gap_thesis_joint_OPEN`.
      The v0.6.0 R2 `gapBlocked` classification was a category
      error: `thesis_joint` is a paper-PUBLISHED substantive
      claim about phenomena (current deployed LLM
      architectures) awaiting external validation (empirical
      observation of next-generation deployed systems; paper
      §2598-2605 explicit reapplication-trigger language).

    * R3-RC2: `tab_calibration` reclassified `gapBlocked` →
      `gapOpen` + `notInput` → `cat3PaperNovel` + `notCat3`
      → `phenomenologicalConjecture`; entry-binder renamed
      `gap_calibration_table_BLOCKED` →
      `gap_calibration_table_OPEN`.  Paper-PUBLISHED
      substantive claim about phenomena (per-case D1/D2/D3
      ratings + `\\label{thesis:calibration}`
      10/10-retrodiction verdict) awaiting external validation
      (historian / philosopher-of-science debate per paper
      §1653-1668 `Caveat on retrodictive D3`).

    * R3-C / R3-D: root module + Ledger top docstring
      narratives updated to list 6 sub-types (the 6th sub-type
      `phenomenologicalConjecture`).

    * `prot_testimony` + `ai_governance_applications`
      CORRECTLY retained as `gapBlocked` (protocol / policy
      design proposals, not substantive empirical claims
      awaiting external validation).

    * `lakefile.toml` version bumped 0.6.0 → 0.7.0.

  *v0.6.0 changelog summary (round 2 v6 compliance — defect-
  driven fixes from hostile validator):*

    * DEFECT #1 (CORE): `lem_prw_reduction` R1 cosmetic
      decomposition reverted.  Round 1 (v0.5.0) introduced five
      atomic stipulations + four case-tag `Prop := True` `def`s;
      the case-tag predicates were tautologically `True`, so the
      five-atom encoding asserted `∀ A, A.partitionRelative`
      once any single carrier-Prop was inhabited — STRONGER than
      the original `lem_prw_reduction` content, with the
      case-decomposition adding zero substantive paper-content.
      Hostile audit verdict: the paper's `\label{lem:prw}` proof
      body case-analyses the warrant by LINGUISTIC structural
      sub-form (uniform vs.\\ contextual; type-(a)/(b)/(c) on the
      warrant's *justification*-prose), not by a typed predicate
      on the `ArbitrationProcedure` carrier.  Making the case-
      tags substantive requires a typed `Warrant` sub-structure
      paper-extension not yet present in the paper.  Honest
      revert: single Cat 3 `workingAssumption` axiom with close-
      target = typed-Warrant refinement.  Five atomic stipulation
      entries + four case-tag carrier entries from R1 all
      removed; their content consolidated into the single
      `gap_lem_prw_reduction` entry.

    * DEFECT #2: dissolved by DEFECT #1 fix (no per-case atoms
      exist anymore; the type-(b) feature conclusion-clause
      mismatch no longer arises).

    * DEFECT #3: dissolved by DEFECT #1 fix (no case-exhaustion
      atom exists anymore).

    * DEFECT #4: `axiom SubstrateIndependenceTripleUse : Prop`
      DELETED from `Basic.lean`.  The naked-`Prop` axiom violated
      the project trust policy (`AxiomAudit.lean` line 30 No
      naked-constant / abstract-type-inhabitation stipulations).
      The premise remains paper-articulated and is recorded as a
      Cat 3 `workingAssumption` ledger entry without an
      underlying Lean axiom.

    * DEFECT #5: dissolved by DEFECT #4 fix (the deleted naked-
      Prop axiom was anti-pattern #7 phantom downstream user; no
      theorem consumed it).

    * DEFECT #6: substrate-independence sub-type reclassified
      `hypothesisPredicate → workingAssumption`.  Paper
      EXPLICITLY frames the premise as defeasible / pending
      validation ('Symmetric epistemic posture: defeasible by
      future fine-grained substrate findings'; 'Operational
      threshold for substrate-independence reapplication'); per
      v6 §3.4.4, this is `workingAssumption` (temporarily
      axiomatized higher-level claim pending validation), not
      `hypothesisPredicate` (paper-stipulated scope condition
      NOT pending validation).

    * DEFECT #7: `CognitiveSystem` reclassified
      `carrier → hypothesisPredicate` for consistency with
      `SessionalCognition` and `BridgingPrinciple` (D3
      reclassified in v0.5.0).  The six abstract `Type` fields
      are stub names never reasoned-with downstream; the load-
      bearing content is the six bare-Prop DSC-axis fields
      consumed by `SatisfiesDSC`.  Same Prop-bundle scope-
      condition pattern as the other reclassified structures;
      the v0.5.0 D3 mixed-typing-dominant retention was an
      inconsistency.

    * DEFECT #8: `thesis_independence` and `thesis_minimality`
      reclassified `gapBlocked → gapOpen` Cat 3
      `workingAssumption`.  Paper exhibits six counter-model
      witnesses (canonical mathematical independence-proof
      pattern) for `thesis_independence` and six locution-axis-
      blocking witnesses for `thesis_minimality`.  Per v6 §2,
      the substrate-independence reclassification precedent (R2
      v0.5.0) applies uniformly.  Close-target: Lean encoding
      of the six counter-model witnesses (paper-extension work
      requires typed carriers the paper does not formalise).
      v0.5.0 D6 retention rationale superseded — the same
      discipline applied to substrate-independence (paper-
      articulated premise pending typed witness encoding) is
      applied here.

    * `lakefile.toml` version bumped 0.5.0 → 0.6.0.

    * `AxiomAudit.lean` updated to reflect the post-R2 axiom
      inventory: one Cat 3 `axiom` (`lem_prw_reduction`); no
      `SubstrateIndependenceTripleUse` axiom; no case-tag
      `def`s; no per-case atomic stipulations.
-/

end AsymmetricEliminativism.Ledger
