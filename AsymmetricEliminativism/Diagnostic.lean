/-
  AsymmetricEliminativism/Diagnostic.lean

  Discriminator sub-conditions D1–D3 and threshold rules R1 / R2
  (`\label{def:discriminator}`), with structural derived
  consequences.

  Companion to: Li 2026, "Asymmetric Eliminativism …"
  (SSRN 6723220 / Zenodo 10.5281/zenodo.20041562).

  *Scope.*  The paper's calibration narrative (ten historical
  cases retrodicted) is not formalised — the case-by-case
  empirical judgements are not structural content Lean can check.
  What IS formalised here is:

    * The 3-valued rating type `DiagnosticRating` with values
      `yes`, `weak`, `no`.
    * A `DiscriminatorRow` carrying ratings for D1, D2, D3.
    * The two threshold rules `R1_strictTwoOfThree` and
      `R2_oneStrongPlusTwoWeak` as Boolean-valued predicates.
    * Structural lemmas: R1 fires on `(yes, yes, yes)` and on
      `(yes, yes, weak)` etc.; R2 fires on `(yes, weak, weak)` only
      under the counterfactual-independence side-condition.
    * The combined discriminator verdict.
-/

import AsymmetricEliminativism.Basic

namespace AsymmetricEliminativism

/--
  Three-valued judgement for a discriminator sub-condition
  (Definition `\label{def:discriminator}`):

  * `yes`  — the sub-condition clearly holds;
  * `no`   — the sub-condition clearly fails;
  * `weak` — the sub-condition partially holds.

  *On `weak`.*  The paper's `weak` rating is itself a disjunction of
  three readings (property obtains in some respects but not others;
  holds for some operationalisations but not all; obtains
  intermittently across the historical window).  The disjunctive
  reading is not formalised; we treat `weak` as an opaque tag.
-/
inductive DiagnosticRating
  | yes
  | weak
  | no
  deriving DecidableEq, Repr

/--
  A row of the discriminator table for a single (concept, target-
  class) pair: ratings for D1 (substrate-tracking failure), D2
  (predictive-purchase asymmetry), D3 (successor-program
  productivity).

  The `counterfactualIndependence` field carries the
  counterfactual-independence test for the (R2) rule: two `weak`
  ratings are counterfactually independent iff there exists an
  epistemically-live scenario in which one of them would shift to
  `yes` or `no` while the other remained `weak`.  The paper
  formalises this for the LLM case via a dissociation scenario;
  we carry the Prop abstractly.
-/
structure DiscriminatorRow where
  D1 : DiagnosticRating
  D2 : DiagnosticRating
  D3 : DiagnosticRating
  /-- Counterfactual-independence test for the two `weak` ratings
       under (R2).  Carried as a Prop; the paper's specific
       dissociation-scenario instantiation lives in the narrative. -/
  counterfactualIndependence : Prop

/-- Helper: count the number of `yes` ratings in a row. -/
def DiscriminatorRow.numYes (r : DiscriminatorRow) : Nat :=
  (if r.D1 = DiagnosticRating.yes then 1 else 0) +
  (if r.D2 = DiagnosticRating.yes then 1 else 0) +
  (if r.D3 = DiagnosticRating.yes then 1 else 0)

/-- Helper: count the number of `weak` ratings in a row. -/
def DiscriminatorRow.numWeak (r : DiscriminatorRow) : Nat :=
  (if r.D1 = DiagnosticRating.weak then 1 else 0) +
  (if r.D2 = DiagnosticRating.weak then 1 else 0) +
  (if r.D3 = DiagnosticRating.weak then 1 else 0)

/--
  Rule (R1) — *strict two-of-three*: the discriminator's
  eliminate-trajectory verdict fires when at least two of D1, D2,
  D3 register `yes`.
-/
def DiscriminatorRow.R1_strictTwoOfThree (r : DiscriminatorRow) : Bool :=
  decide (r.numYes ≥ 2)

/--
  Rule (R2) — *one-strong-plus-two-weak*: the discriminator's
  eliminate-trajectory verdict fires when exactly one of D1, D2,
  D3 registers `yes` and the other two both register `weak`,
  provided the counterfactual-independence side-condition holds.

  *Note.*  The side-condition `counterfactualIndependence` is
  Prop-valued; the *Boolean* `R2_oneStrongPlusTwoWeak` checks the
  numerical pattern only.  The full (R2) verdict is the
  conjunction of the Boolean pattern check and the
  counterfactual-independence Prop, exposed as
  `DiscriminatorRow.R2_satisfied`.
-/
def DiscriminatorRow.R2_oneStrongPlusTwoWeak (r : DiscriminatorRow) : Bool :=
  decide (r.numYes = 1 ∧ r.numWeak = 2)

/--
  Full (R2) verdict: Boolean pattern AND counterfactual
  independence.
-/
def DiscriminatorRow.R2_satisfied (r : DiscriminatorRow) : Prop :=
  r.R2_oneStrongPlusTwoWeak = true ∧ r.counterfactualIndependence

/--
  Combined discriminator verdict: the row predicts the eliminate
  trajectory iff either (R1) or the full (R2) verdict fires.
-/
def DiscriminatorRow.predictsEliminate (r : DiscriminatorRow) : Prop :=
  r.R1_strictTwoOfThree = true ∨ r.R2_satisfied

/-! ### Structural sanity-check theorems about the threshold rules. -/

/-- Helper: a `numYes` computation reduces to `3` when all three
    ratings are `yes`. -/
private lemma numYes_all_yes (r : DiscriminatorRow)
    (h1 : r.D1 = DiagnosticRating.yes)
    (h2 : r.D2 = DiagnosticRating.yes)
    (h3 : r.D3 = DiagnosticRating.yes) :
    r.numYes = 3 := by
  unfold DiscriminatorRow.numYes
  rw [h1, h2, h3]
  decide

/-- Helper: `numYes = 2` when two ratings are `yes` and one is `weak`. -/
private lemma numYes_yes_yes_weak (r : DiscriminatorRow)
    (h1 : r.D1 = DiagnosticRating.yes)
    (h2 : r.D2 = DiagnosticRating.yes)
    (h3 : r.D3 = DiagnosticRating.weak) :
    r.numYes = 2 := by
  unfold DiscriminatorRow.numYes
  rw [h1, h2, h3]
  decide

/-- Helper: `numYes = 1` when one rating is `yes` and two are `weak`. -/
private lemma numYes_yes_weak_weak (r : DiscriminatorRow)
    (h1 : r.D1 = DiagnosticRating.yes)
    (h2 : r.D2 = DiagnosticRating.weak)
    (h3 : r.D3 = DiagnosticRating.weak) :
    r.numYes = 1 := by
  unfold DiscriminatorRow.numYes
  rw [h1, h2, h3]
  decide

/-- Helper: `numWeak = 2` when one rating is `yes` and two are `weak`. -/
private lemma numWeak_yes_weak_weak (r : DiscriminatorRow)
    (h1 : r.D1 = DiagnosticRating.yes)
    (h2 : r.D2 = DiagnosticRating.weak)
    (h3 : r.D3 = DiagnosticRating.weak) :
    r.numWeak = 2 := by
  unfold DiscriminatorRow.numWeak
  rw [h1, h2, h3]
  decide

/-- (R1) fires on the all-`yes` row. -/
theorem R1_fires_on_all_yes
    (r : DiscriminatorRow)
    (h1 : r.D1 = DiagnosticRating.yes)
    (h2 : r.D2 = DiagnosticRating.yes)
    (h3 : r.D3 = DiagnosticRating.yes) :
    r.R1_strictTwoOfThree = true := by
  have hN : r.numYes = 3 := numYes_all_yes r h1 h2 h3
  unfold DiscriminatorRow.R1_strictTwoOfThree
  rw [hN]
  decide

/-- (R1) fires on the `(yes, yes, weak)` row (and analogous). -/
theorem R1_fires_on_yes_yes_weak
    (r : DiscriminatorRow)
    (h1 : r.D1 = DiagnosticRating.yes)
    (h2 : r.D2 = DiagnosticRating.yes)
    (h3 : r.D3 = DiagnosticRating.weak) :
    r.R1_strictTwoOfThree = true := by
  have hN : r.numYes = 2 := numYes_yes_yes_weak r h1 h2 h3
  unfold DiscriminatorRow.R1_strictTwoOfThree
  rw [hN]
  decide

/-- (R1) does *not* fire on the `(yes, weak, weak)` row (matching
    the LLM-row pattern in the paper's calibration table).  The
    eliminate verdict on the LLM row therefore relies on (R2)
    plus the counterfactual-independence side-condition. -/
theorem R1_does_not_fire_on_yes_weak_weak
    (r : DiscriminatorRow)
    (h1 : r.D1 = DiagnosticRating.yes)
    (h2 : r.D2 = DiagnosticRating.weak)
    (h3 : r.D3 = DiagnosticRating.weak) :
    r.R1_strictTwoOfThree = false := by
  have hN : r.numYes = 1 := numYes_yes_weak_weak r h1 h2 h3
  unfold DiscriminatorRow.R1_strictTwoOfThree
  rw [hN]
  decide

/-- (R2)'s Boolean-pattern check *does* fire on the `(yes, weak,
    weak)` row — the LLM-row pattern.  The full (R2) verdict
    additionally requires the counterfactual-independence side-
    condition. -/
theorem R2_pattern_fires_on_yes_weak_weak
    (r : DiscriminatorRow)
    (h1 : r.D1 = DiagnosticRating.yes)
    (h2 : r.D2 = DiagnosticRating.weak)
    (h3 : r.D3 = DiagnosticRating.weak) :
    r.R2_oneStrongPlusTwoWeak = true := by
  have hYes : r.numYes = 1 := numYes_yes_weak_weak r h1 h2 h3
  have hWeak : r.numWeak = 2 := numWeak_yes_weak_weak r h1 h2 h3
  unfold DiscriminatorRow.R2_oneStrongPlusTwoWeak
  rw [hYes, hWeak]
  decide

/-- (R1)-only verdict on the all-`yes` row: predicts elimination. -/
theorem predictsEliminate_of_all_yes
    (r : DiscriminatorRow)
    (h1 : r.D1 = DiagnosticRating.yes)
    (h2 : r.D2 = DiagnosticRating.yes)
    (h3 : r.D3 = DiagnosticRating.yes) :
    r.predictsEliminate :=
  Or.inl (R1_fires_on_all_yes r h1 h2 h3)

/-- (R2)-licensed verdict on the LLM-row pattern: predicts
    elimination *provided* counterfactual independence holds. -/
theorem predictsEliminate_of_yes_weak_weak_with_indep
    (r : DiscriminatorRow)
    (h1 : r.D1 = DiagnosticRating.yes)
    (h2 : r.D2 = DiagnosticRating.weak)
    (h3 : r.D3 = DiagnosticRating.weak)
    (hIndep : r.counterfactualIndependence) :
    r.predictsEliminate :=
  Or.inr ⟨R2_pattern_fires_on_yes_weak_weak r h1 h2 h3, hIndep⟩

/-- Without counterfactual independence, the LLM-row pattern does
    *not* yield an (R2)-licensed verdict: the predicate
    `R2_satisfied` is rejected.  Combined with (R1)-non-firing
    (above), this means the discriminator does *not* predict
    elimination on `(yes, weak, weak)` rows that fail the
    counterfactual-independence test. -/
theorem not_R2_satisfied_without_indep
    (r : DiscriminatorRow)
    (_h1 : r.D1 = DiagnosticRating.yes)
    (_h2 : r.D2 = DiagnosticRating.weak)
    (_h3 : r.D3 = DiagnosticRating.weak)
    (hNotIndep : ¬ r.counterfactualIndependence) :
    ¬ r.R2_satisfied := by
  intro hSat
  exact hNotIndep hSat.2

end AsymmetricEliminativism
