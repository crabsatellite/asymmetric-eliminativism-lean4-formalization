/-
  AsymmetricEliminativism/VacuityCheck.lean

  Vacuity tests for v0.11.0 R14 substantive paper-faithful
  Warrant-typed `partitionRelative` encoding.

  Round 14 brief: BEFORE claiming success, the encoding MUST be
  tested against the constant-witness attack that killed R7.
  Specifically:

  (V1) `∀ A, A.partitionRelative` must NOT be provable kernel-pure
       (if it were, the predicate would be vacuous and downstream
       conclusions would have zero substantive content).

  (V2) `∃ A, ¬ A.partitionRelative` must be constructible (the
       predicate distinguishes among `ArbitrationProcedure`
       instances — some are partition-relative, some aren't).

  (V3) `∀ A, A.warrantForm = uniform → A.partitionRelative` must
       NOT be trivially provable without the `prw_uniform_to_pr`
       atom — the structural-equation reduction still does
       paper-substantive work.

  This file PROVES (V1)-negation via the (V2) construction (an A
  exists with `¬ A.partitionRelative`, refuting `∀ A,
  A.partitionRelative`), and provides the explicit witness for
  (V2).  (V3)'s analogue is exhibited as a `#print axioms` check
  showing `prw_uniform_to_pr` is required for the case-bridge
  conclusion.

  Companion to: Li 2026, "Asymmetric Eliminativism: A Diagnostic
  Framework for Reverse-Defined Concepts …" (SSRN 6723220 /
  Zenodo 10.5281/zenodo.20041562).
-/

import AsymmetricEliminativism.Basic
import AsymmetricEliminativism.Impossibility

namespace AsymmetricEliminativism.VacuityCheck

open AsymmetricEliminativism

/-! ## (V2) Construction: an `ArbitrationProcedure` whose warrant's
    feature-extraction genuinely depends on the target-class input,
    paired with an `exhibits` relation that does not licence a
    factorisation through partition-membership.

    This refutes `∀ A, A.partitionRelative` (V1) and provides the
    explicit witness for `∃ A, ¬ A.partitionRelative` (V2). -/

/-- A toy 2-element partition of `Bool` folk-extension.  Two
    singleton parts: `{true}` and `{false}`, pairwise-disjoint
    by `Bool.noConfusion`.  This is sufficient structure to
    expose the vacuity question.

    The `noPartitionIndependentRanking` Prop is supplied as
    `True` (the paper-stipulated Prop content is not load-bearing
    for the vacuity test). -/
def toyPart : MutuallyUnrankedPartition Bool where
  n := 2
  n_ge_two := by decide
  parts := fun i => if i.val = 0 then {true} else {false}
  pairwise_disjoint := by
    intro i j hij
    -- For Fin 2 with i ≠ j, one has val 0 and the other val 1.
    -- The corresponding parts are {true} and {false}; their
    -- intersection is empty.
    have hi : i.val = 0 ∨ i.val = 1 := by
      have := i.isLt; omega
    have hj : j.val = 0 ∨ j.val = 1 := by
      have := j.isLt; omega
    have hij_val : i.val ≠ j.val := fun h => hij (Fin.ext h)
    rcases hi with hi | hi <;> rcases hj with hj | hj
    · exact absurd (hi.trans hj.symm) hij_val
    · simp [hi, hj]
    · simp [hi, hj]
    · exact absurd (hi.trans hj.symm) hij_val
  noPartitionIndependentRanking := True

/-- The "non-factorising" arbitration procedure: a warrant whose
    `featureExtract` returns the target-class member's `Bool`
    value, an `exhibits` relation under which every target-class
    member exhibits the folk-object `true` (a single point of
    the partition's first member).  Then any candidate
    factorisation `featByClass ∘ memberClass` would have to map
    `true` (the folk-object) to a SINGLE feature value — but
    `featureExtract = id : Bool → Bool` returns two distinct
    values across Tcls.  Hence NO factorisation exists; the
    predicate fails. -/
def nonFactorisingA : ArbitrationProcedure Bool Bool toyPart where
  warrant := {
    FeatureSpace := Bool
    featureExtract := id
    ranker := fun b => if b then ⟨0, by decide⟩ else ⟨1, by decide⟩
  }
  warrantForm := WarrantFeatureType.uniform
  exhibits := fun _ f => f = true

/-- (V2) Explicit witness: `∃ A, ¬ A.partitionRelative`.
    Kernel-pure proof (no `Classical.choice`, no `decide` on
    non-ground propositions). -/
theorem exists_non_partition_relative :
    ∃ A : ArbitrationProcedure Bool Bool toyPart, ¬ A.partitionRelative := by
  refine ⟨nonFactorisingA, ?_⟩
  -- Unfold the substantive partitionRelative predicate.
  intro hPR
  obtain ⟨memberClass, featByClass, hFact⟩ := hPR
  -- `hFact true true rfl` says
  -- `featureExtract true = featByClass (memberClass true)`,
  -- i.e. `true = featByClass (memberClass true)`.
  have h_true : nonFactorisingA.warrant.featureExtract true
      = featByClass (memberClass true) :=
    hFact true true rfl
  -- `hFact false true rfl` says
  -- `featureExtract false = featByClass (memberClass true)`,
  -- i.e. `false = featByClass (memberClass true)`.
  have h_false : nonFactorisingA.warrant.featureExtract false
      = featByClass (memberClass true) :=
    hFact false true rfl
  -- featureExtract = id, so the two equalities give true = false.
  -- Combine and derive contradiction via Bool.noConfusion.
  have h_eq : (true : Bool) = (false : Bool) := by
    have := h_true.trans h_false.symm
    -- `this : id true = id false`, i.e., `true = false`.
    exact this
  exact Bool.noConfusion h_eq

/-- (V1)-negation, derived from (V2): `∀ A, A.partitionRelative`
    is NOT provable, because `nonFactorisingA` is a counter-
    example. -/
theorem not_forall_partition_relative :
    ¬ (∀ A : ArbitrationProcedure Bool Bool toyPart, A.partitionRelative) := by
  intro hAll
  obtain ⟨A, hNot⟩ := exists_non_partition_relative
  exact hNot (hAll A)

/-! ## (V2.b) Companion construction: a procedure that IS
    partition-relative (the predicate is NOT just universally
    false either — it genuinely distinguishes). -/

/-- A constant-extraction arbitration procedure: `featureExtract`
    returns the same `Bool` value for every input.  Then ANY
    `(memberClass, featByClass)` with `featByClass (memberClass f)
    = true` (for any `f`) discharges the factorisation. -/
def factorisingA : ArbitrationProcedure Bool Bool toyPart where
  warrant := {
    FeatureSpace := Bool
    featureExtract := fun _ => true
    ranker := fun _ => ⟨0, by decide⟩
  }
  warrantForm := WarrantFeatureType.uniform
  exhibits := fun _ _ => True

/-- (V2.b) Companion witness: a partition-relative procedure
    exists.  Demonstrates the predicate is satisfiable, NOT
    universally false. -/
theorem exists_partition_relative :
    ∃ A : ArbitrationProcedure Bool Bool toyPart, A.partitionRelative := by
  refine ⟨factorisingA, ?_⟩
  -- Provide explicit (memberClass, featByClass) witnesses.
  refine ⟨fun _ => ⟨0, by decide⟩, fun _ => true, ?_⟩
  intro _ _ _
  -- `factorisingA.warrant.featureExtract x = true` for every x;
  -- `featByClass _ = true` by construction.  Reduces to rfl.
  rfl

/-! ## (V3) Case-bridge atomicity: the `prw_uniform_to_pr` axiom
    is genuinely required for the case-bridge conclusion.  We
    cannot prove `∀ A, A.warrantForm = uniform → A.partitionRelative`
    kernel-pure without consuming the axiom — `nonFactorisingA`
    has `warrantForm = uniform` AND `¬ A.partitionRelative`,
    refuting the universally-quantified case-bridge statement
    without the atom. -/

/-- Refutation of the case-bridge as a universal Lean theorem
    (i.e., WITHOUT the `prw_uniform_to_pr` atom).  Demonstrates
    the atom carries genuine paper-content. -/
theorem case_bridge_uniform_not_derivable_without_atom :
    ¬ (∀ A : ArbitrationProcedure Bool Bool toyPart,
        A.warrantForm = WarrantFeatureType.uniform → A.partitionRelative) := by
  intro hAll
  -- nonFactorisingA has warrantForm = uniform AND ¬partitionRelative.
  have hPR : nonFactorisingA.partitionRelative :=
    hAll nonFactorisingA rfl
  -- Apply the (V2) non-factorisation argument directly.
  obtain ⟨memberClass, featByClass, hFact⟩ := hPR
  have h_true : nonFactorisingA.warrant.featureExtract true
      = featByClass (memberClass true) :=
    hFact true true rfl
  have h_false : nonFactorisingA.warrant.featureExtract false
      = featByClass (memberClass true) :=
    hFact false true rfl
  exact Bool.noConfusion (h_true.trans h_false.symm)

/-! ## Axiom-profile checks — kernel-pure unless otherwise noted. -/

-- `exists_non_partition_relative` is kernel-pure.
#print axioms exists_non_partition_relative

-- `not_forall_partition_relative` is kernel-pure.
#print axioms not_forall_partition_relative

-- `exists_partition_relative` is kernel-pure.
#print axioms exists_partition_relative

-- `case_bridge_uniform_not_derivable_without_atom` is kernel-pure
-- (does NOT consume `prw_uniform_to_pr`).  This is the key
-- verification: the case-bridge axiom is genuinely required for
-- the structural-equation reduction — the new `partitionRelative`
-- predicate does not collapse to a Lean-derivable triviality.
#print axioms case_bridge_uniform_not_derivable_without_atom

end AsymmetricEliminativism.VacuityCheck
