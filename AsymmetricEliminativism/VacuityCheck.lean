/-
  AsymmetricEliminativism/VacuityCheck.lean

  Vacuity + consistency tests for v0.16.0 R24 FINAL HONEST
  CONVERGENCE per round-24 brief.

  *v0.16.0 R24 FINAL HONEST CONVERGENCE per round-24 brief.*  R23
  hostile validator machine-verified that v0.15.0 R22 Fix A
  (`partitionRelative` non-degeneracy strengthening) introduced
  axiom inconsistency: paper's uniform case (paper lines 2127-2132)
  has CONSTANT single-$E_m$ adjudication (degenerate ranker), but
  `prw_uniform_to_pr` under R22 derived `partitionRelative`
  (including non-degeneracy) on the uniform witness, yielding
  kernel-pure `False`.  R24 final honest convergence:

  - REVERT R22 Fix A.  `partitionRelative` reverts to R18 form:
    literally `featureExtractsAreEInternal` (no non-degeneracy).
    Per paper line 2109-2112, this IS paper-faithful.

  - KEEP R22 Fix B.  `admissibleIn` axiom + restricted
    `DiscourseHypothesisH := ∀ A, admissibleIn A Op →
    warrantInternalToE`.  Makes (H) non-vacuously-true and
    non-vacuously-false depending on the discourse state.

  - 6 case-bridges converted to derived theorems `fun _ hW => hW.2`.
    Anti-pattern #13 GENUINELY BROKEN: zero Cat 3 axioms for the
    partition-relativity derivation chain.

  - `lem_prw_reduction` reducible to 1-line `Or.inl hW.2`
    (functionally equivalent to the preserved case-exhaustion
    surface presentation).

  - `thm_impossibility` substantively uses (H) via admissibleIn
    discharge from each P2 witness.

  *Anti-pattern history.*
   - R7  v0.9.0: cosmetic Weighting → R8 killed (vacuity).
   - R14 v0.11.0: missing antecedent → R15 killed.
   - R16 v0.12.0: composite predicate → R17 killed.
   - R18 v0.13.0: definitional smuggling in SatisfiesP2 → R19 killed.
   - R20 v0.14.0: 2-line bypass + (H) universal-false → R21 killed.
   - R22 v0.15.0: uniform-case axiom inconsistency → R23 killed.
   - R24 v0.16.0: HONEST CONVERGENCE — accept paper line 2109-2112
     typed-level trivialization; keep R22 Fix B admissibleIn.

  This file proves:

  (V1)  `∀ A, A.partitionRelative` is NOT provable.

  (V2)  `∃ A, ¬ A.partitionRelative` is constructible
        (`nonFactorisingA` witness).

  (V3)  Case-bridge unconditional form `warrantForm = uniform →
        partitionRelative` (without `warrantInternalToE`) is NOT
        a Lean theorem (`nonFactorisingA` refutes it).

  (V4)  R16 consistency preserved: `¬ nonFactorisingA.warrantInternalToE`
        (the R15 attack vector's antecedent is unprovable
        kernel-pure).

  (V5)  Companion positive instance: `factorisingA` satisfies
        `warrantForm = uniform ∧ warrantInternalToE ∧
        partitionRelative` under R24's reverted predicate.

  (V6)  R15 attack vector verifiably blocked.

  (V7)  **R24 paper-faithful identification (preserved from R18)**:
        `partitionRelative ↔ featureExtractsAreEInternal` is
        `Iff.rfl` (kernel-pure, depends on no axioms).  Paper line
        2109-2112 identification.

  (V8)  R18/R24 case-bridge derivation: derived theorems
        `fun _ hW => hW.2` apply to any factorising witness.

  (V9)  R20 structural-validity (preserved + updated for R22 Fix B
        which R24 retains): post-R22 SatisfiesP2 has 3 conjuncts;
        R19 4-binding rintro pattern is blocked.

  (V10) **R22 Fix B preserved** — `DiscourseHypothesisH`
        satisfiability / non-trivial-constraint tests:
        (V10.a) Construct a discourse-state where (H) HOLDS by
          stipulating `admissibleIn` is empty.
        (V10.b) Construct a discourse-state where (H) FAILS by
          stipulating `admissibleIn := True` for all A — then
          `nonFactorisingA` refutes (H).

  (V11) **R24 R21 bypass IS the canonical proof, paper-faithfully**.
        Under R24, `partitionRelative ↔ featureExtractsAreEInternal`
        per paper line 2109-2112; the 2-line `(hH A hAdm).2` IS
        the structurally honest reduction.  The non-vacuous content
        of `thm_impossibility` lives in (H)'s admissibleIn
        antecedent (R22 Fix B): without (H), the proof cannot
        proceed.

  (V12) **R23 inconsistency ELIMINATED**: under R24's reverted
        `partitionRelative`, the R23 `uniform_case_bridge_inconsistency`
        attack vector NO LONGER EXISTS because case-bridges are
        derived theorems (not axioms) — no axiomatic non-degeneracy
        claim to refute on degenerate-ranker witnesses.

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
    Kernel-pure proof. -/
theorem exists_non_partition_relative :
    ∃ A : ArbitrationProcedure Bool Bool toyPart, ¬ A.partitionRelative := by
  refine ⟨nonFactorisingA, ?_⟩
  -- Under R24, partitionRelative = featureExtractsAreEInternal.
  intro hPR
  obtain ⟨memberClass, featByClass, hF⟩ := hPR
  have h_true : nonFactorisingA.warrant.featureExtract true
      = featByClass (memberClass true) :=
    hF true true rfl
  have h_false : nonFactorisingA.warrant.featureExtract false
      = featByClass (memberClass true) :=
    hF false true rfl
  exact Bool.noConfusion (h_true.trans h_false.symm)

/-- (V1)-negation, derived from (V2). -/
theorem not_forall_partition_relative :
    ¬ (∀ A : ArbitrationProcedure Bool Bool toyPart, A.partitionRelative) := by
  intro hAll
  obtain ⟨A, hNot⟩ := exists_non_partition_relative
  exact hNot (hAll A)

/-! ## (V2.b) Companion construction: a procedure that IS
    partition-relative (the predicate is NOT just universally
    false either — it genuinely distinguishes).

    *v0.16.0 R24 update.*  Under R24's reverted predicate
    `partitionRelative := featureExtractsAreEInternal`, the
    factorising witness `factorisingA` (constant featureExtract,
    trivially factorising) satisfies the predicate. -/

/-- A partition-relative arbitration procedure under R24: constant
    `featureExtract` trivially factorises via any `memberClass` +
    `featByClass` sending the relevant class index to that constant
    value. -/
def factorisingA : ArbitrationProcedure Bool Bool toyPart where
  warrant := {
    FeatureSpace := Bool
    featureExtract := fun _ => true
    ranker := fun b => if b then ⟨0, by decide⟩ else ⟨1, by decide⟩
  }
  warrantForm := WarrantFeatureType.uniform
  exhibits := fun _ _ => True

/-- (V2.b) Companion witness: a partition-relative procedure
    exists under R24's reverted predicate.  Demonstrates the
    predicate is satisfiable, NOT universally false. -/
theorem exists_partition_relative :
    ∃ A : ArbitrationProcedure Bool Bool toyPart, A.partitionRelative := by
  refine ⟨factorisingA, ?_⟩
  -- Under R24, partitionRelative = featureExtractsAreEInternal:
  -- provide explicit witnesses.
  refine ⟨fun _ => ⟨0, by decide⟩, fun _ => true, ?_⟩
  intro _ _ _
  -- featureExtract x = true; featByClass _ = true.
  rfl

/-! ## (V3) Case-bridge atomicity: under R24, the case-bridge
    derived theorems have signature `warrantForm = X →
    warrantInternalToE → partitionRelative`.  Without the
    `warrantInternalToE` antecedent, the unconditional form
    `∀ A, warrantForm = uniform → partitionRelative` is REFUTABLE
    by `nonFactorisingA`. -/

theorem case_bridge_uniform_unconditional_not_derivable :
    ¬ (∀ A : ArbitrationProcedure Bool Bool toyPart,
        A.warrantForm = WarrantFeatureType.uniform → A.partitionRelative) := by
  intro hAll
  have hPR : nonFactorisingA.partitionRelative :=
    hAll nonFactorisingA rfl
  -- Under R24, partitionRelative = featureExtractsAreEInternal.
  obtain ⟨memberClass, featByClass, hF⟩ := hPR
  have h_true : nonFactorisingA.warrant.featureExtract true
      = featByClass (memberClass true) :=
    hF true true rfl
  have h_false : nonFactorisingA.warrant.featureExtract false
      = featByClass (memberClass true) :=
    hF false true rfl
  exact Bool.noConfusion (h_true.trans h_false.symm)

/-! ## (V4) R16 consistency verification (preserved across R24).

    The R15 attack vector requires `nonFactorisingA.warrantInternalToE`.
    Under R16+, this antecedent is itself unprovable kernel-pure
    because `nonFactorisingA.featureExtract = id` does not factor
    through any (memberClass, featByClass). -/

theorem nonFactorisingA_not_warrantInternalToE :
    ¬ nonFactorisingA.warrantInternalToE := by
  intro hWITE
  obtain ⟨_hTag, hFactConj⟩ := hWITE
  obtain ⟨memberClass, featByClass, hFact⟩ := hFactConj
  have h_true : nonFactorisingA.warrant.featureExtract true
      = featByClass (memberClass true) :=
    hFact true true rfl
  have h_false : nonFactorisingA.warrant.featureExtract false
      = featByClass (memberClass true) :=
    hFact false true rfl
  exact Bool.noConfusion (h_true.trans h_false.symm)

theorem exists_uniform_not_warrantInternalToE :
    ∃ A : ArbitrationProcedure Bool Bool toyPart,
      A.warrantForm = WarrantFeatureType.uniform ∧
      ¬ A.warrantInternalToE := by
  exact ⟨nonFactorisingA, rfl, nonFactorisingA_not_warrantInternalToE⟩

/-! ## (V5) Companion positive instance — R24 updated to use
    `factorisingA` under the reverted `partitionRelative`.

    There exist procedures with `warrantForm = uniform ∧
    warrantInternalToE`, and they have `partitionRelative` under
    R24. -/

theorem factorisingA_satisfies_all_antecedents :
    factorisingA.warrantForm = WarrantFeatureType.uniform ∧
    factorisingA.warrantInternalToE ∧
    factorisingA.partitionRelative := by
  refine ⟨rfl, ?_, ?_⟩
  · -- warrantInternalToE = caseFormIsInternal ∧ featureExtractsAreEInternal.
    refine ⟨⟨?_, ?_⟩, ?_⟩
    · decide
    · decide
    · refine ⟨fun _ => ⟨0, by decide⟩, fun _ => true, ?_⟩
      intro _ _ _; rfl
  · -- partitionRelative = featureExtractsAreEInternal (R24 revert).
    refine ⟨fun _ => ⟨0, by decide⟩, fun _ => true, ?_⟩
    intro _ _ _; rfl

/-! ## (V6) R15 kill blocked — explicit demonstration.

    The case-bridge applied to `nonFactorisingA` with `rfl`
    yields a function expecting `warrantInternalToE`, which (V4)
    refutes kernel-pure. -/

theorem r15_attack_requires_unprovable_antecedent :
    ¬ ∃ (_ : nonFactorisingA.warrantInternalToE),
        nonFactorisingA.partitionRelative := by
  rintro ⟨hWITE, _⟩
  exact nonFactorisingA_not_warrantInternalToE hWITE

/-! ## (V7) R24 paper-faithful identification (preserved from R18).

    Per paper line 2109-2112, paper's typed `\label{def:warrant}`
    E-internality clause IS the typed-structure version of
    partition-relative-weighting.  Under R24's reverted
    `partitionRelative := featureExtractsAreEInternal`, this
    identification is `Iff.rfl` — kernel-pure, no axioms.

    This formal verification of paper line 2109-2112 is the
    structural triviality R18 first identified and R24 finally
    accepts after R22's failed strengthening attempt. -/

theorem partitionRelative_iff_featureExtractsAreEInternal
    {FolkObj Tcls : Type} {Part : MutuallyUnrankedPartition FolkObj}
    (A : ArbitrationProcedure FolkObj Tcls Part) :
    A.partitionRelative ↔ A.featureExtractsAreEInternal :=
  Iff.rfl

/-! ## (V8) R24 case-bridge derivation: case-bridges are derived
    theorems with proof body `fun _ hW => hW.2`. -/

theorem prw_uniform_to_pr_applied_to_factorisingA :
    factorisingA.partitionRelative := by
  obtain ⟨hForm, hWITE, _hPR⟩ :=
    factorisingA_satisfies_all_antecedents
  exact prw_uniform_to_pr toyPart factorisingA hForm hWITE

theorem lem_prw_reduction_applied_to_factorisingA :
    factorisingA.partitionRelative ∨
    factorisingA.failsAdjudication := by
  obtain ⟨_, hWITE, _⟩ := factorisingA_satisfies_all_antecedents
  exact lem_prw_reduction toyPart factorisingA hWITE

/-! ## (V9) v0.14.0 R20 STRUCTURAL FIX — verification block,
    R22-updated (preserved across R24).

    Post-R22/R24 SatisfiesP2 has 3 conjuncts (admissibleIn,
    ¬ partitionRelative, ¬ failsAdjudication).
    DiscourseHypothesisH := ∀ A, admissibleIn A Op → warrantInternalToE.
-/

/-- (V9.b) Post-R22/R24 SatisfiesP2 destructuring has exactly 3
    conjuncts (A + 3 = 4 bindings).  R19's pattern
    `⟨A, hNotPR, _, hWITE⟩` matches 4 bindings, but the second
    binding corresponds to `admissibleIn` (a paper axiom predicate),
    not a conjunction with `.2` — so the `hWITE.2` projection
    in R19's body is type-incorrect. -/
theorem r19_kill_destructuring_has_three_conjuncts
    (Op : Operationalisation Bool Bool toyPart) :
    SatisfiesP2 Bool Bool toyPart Op → True := by
  rintro ⟨_A, _hAdm, _hNotPR, _hNotFails⟩
  trivial

/-! ## (V10) R22 Fix B preserved (R24) — DiscourseHypothesisH
    non-vacuity tests.

    Under v0.14.0 R20, `DiscourseHypothesisH := ∀ A, warrantInternalToE`
    was UNIVERSALLY FALSE on any non-trivial (Part, Op).  Under
    v0.15.0+ R22 Fix B (retained in R24), `DiscourseHypothesisH
    := ∀ A, admissibleIn A Op → warrantInternalToE`.  The
    `admissibleIn` predicate is a paper-stipulated axiom-level
    Prop that does NOT automatically hold for arbitrary
    Lean-constructed procedures. -/

/-- (V10.a) `DiscourseHypothesisH` is non-trivially satisfiable on
    toyPart: if `admissibleIn` is empty (no procedure admissible),
    then (H) is vacuously true. -/
theorem discourseHypothesisH_satisfiable_when_admissibleIn_empty
    (Op : Operationalisation Bool Bool toyPart)
    (hEmpty : ∀ A : ArbitrationProcedure Bool Bool toyPart,
              ¬ A.admissibleIn Op) :
    DiscourseHypothesisH toyPart Op := by
  intro A hAdm
  exact absurd hAdm (hEmpty A)

/-- (V10.b) `DiscourseHypothesisH` is non-trivially refutable on
    toyPart: if `admissibleIn` is universal (every procedure
    admissible), then `nonFactorisingA` is a counter-witness with
    `admissibleIn ∧ ¬ warrantInternalToE`, refuting (H). -/
theorem discourseHypothesisH_fails_when_admissibleIn_universal
    (Op : Operationalisation Bool Bool toyPart)
    (hUniv : ∀ A : ArbitrationProcedure Bool Bool toyPart,
             A.admissibleIn Op) :
    ¬ DiscourseHypothesisH toyPart Op := by
  intro hH
  have hWITE : nonFactorisingA.warrantInternalToE :=
    hH nonFactorisingA (hUniv nonFactorisingA)
  exact nonFactorisingA_not_warrantInternalToE hWITE

/-! ## (V11) R24 honest acknowledgment: under reverted
    `partitionRelative = featureExtractsAreEInternal`, the 2-line
    bypass `(hH A hAdm).2` IS the canonical proof, paper-faithfully
    per paper line 2109-2112.  Non-vacuous theorem content lives
    in (H)'s `admissibleIn` antecedent (R22 Fix B). -/

/-- (V11.a) Post-R22/R24 `hH A` is an implication, not a direct
    value.  Discharge requires both `A` and an `admissibleIn`
    proof. -/
theorem discourseHypothesisH_is_implication_typecheck
    (Op : Operationalisation Bool Bool toyPart)
    (hH : DiscourseHypothesisH toyPart Op)
    (A : ArbitrationProcedure Bool Bool toyPart)
    (hAdm : A.admissibleIn Op) :
    A.warrantInternalToE :=
  hH A hAdm

/-- (V11.b) Under R24, `.2` projection of `warrantInternalToE`
    yields `featureExtractsAreEInternal`, which is definitionally
    `partitionRelative` per V7 `Iff.rfl`.  The 2-line bypass IS
    the canonical reduction, paper-faithfully per paper line
    2109-2112. -/
theorem hW_dot_2_is_featureExtractsAreEInternal_eq_partitionRelative
    (A : ArbitrationProcedure Bool Bool toyPart)
    (hW : A.warrantInternalToE) :
    A.partitionRelative :=
  hW.2

/-- (V11.c) R24 honest convergence: `thm_impossibility`
    substantively requires (H)'s `admissibleIn` antecedent.  The
    non-vacuous content of the theorem lives in this antecedent
    (R22 Fix B), not in the partition-relativity derivation. -/
theorem thm_impossibility_uses_H_via_admissibleIn
    (Op : Operationalisation Bool Bool toyPart)
    (hH : DiscourseHypothesisH toyPart Op) :
    ¬ SatisfiesP2 Bool Bool toyPart Op :=
  thm_impossibility toyPart Op hH

/-! ## (V12) R23 inconsistency ELIMINATED under R24.

    Under R22, `prw_uniform_to_pr` was a Cat 3 axiom asserting
    non-degeneracy of the ranker on the uniform witness.  R23
    derived kernel-pure `False` by applying the axiom to a
    uniform-constant-ranker witness (paper's actual uniform case
    per paper lines 2127-2132 has CONSTANT $E_m$ adjudication).

    Under R24, `prw_uniform_to_pr` is a derived theorem with
    proof body `fun _ hW => hW.2`.  Applied to ANY witness
    (including a uniform-constant-ranker witness), it yields
    `partitionRelative = featureExtractsAreEInternal` —
    paper-faithful, no inconsistency.

    We exhibit the uniform-constant-ranker witness and confirm
    that applying `prw_uniform_to_pr` does NOT yield `False`. -/

/-- A uniform-form procedure with constant featureExtract AND
    constant ranker (paper's actual uniform case "constant $k$"
    per paper lines 2127-2132). -/
def uniformConstantRankerA : ArbitrationProcedure Bool Bool toyPart where
  warrant := {
    FeatureSpace := Bool
    featureExtract := fun _ => true
    ranker := fun _ => ⟨0, by decide⟩  -- CONSTANT ranker.
  }
  warrantForm := WarrantFeatureType.uniform
  exhibits := fun _ _ => True

/-- (V12.a) Under R24, the uniform-constant-ranker witness
    satisfies `warrantInternalToE` (caseFormIsInternal + constant
    featureExtract trivially factorises). -/
theorem uniformConstantRankerA_warrantInternalToE :
    uniformConstantRankerA.warrantInternalToE := by
  refine ⟨⟨?_, ?_⟩, ?_⟩
  · decide
  · decide
  · refine ⟨fun _ => ⟨0, by decide⟩, fun _ => true, ?_⟩
    intro _ _ _; rfl

/-- (V12.b) Under R24, the uniform-constant-ranker witness has
    `partitionRelative` (= `featureExtractsAreEInternal`).  R22's
    R23 attack vector (deriving `False` via non-degeneracy
    refutation) NO LONGER APPLIES because non-degeneracy is no
    longer a conjunct. -/
theorem uniformConstantRankerA_partitionRelative :
    uniformConstantRankerA.partitionRelative := by
  refine ⟨fun _ => ⟨0, by decide⟩, fun _ => true, ?_⟩
  intro _ _ _; rfl

/-- (V12.c) The R23 inconsistency vector is ELIMINATED: applying
    `prw_uniform_to_pr` (now a derived theorem) to the uniform-
    constant-ranker witness yields `partitionRelative`, which is
    consistent — no `False`. -/
theorem r23_inconsistency_eliminated :
    uniformConstantRankerA.partitionRelative := by
  exact prw_uniform_to_pr toyPart uniformConstantRankerA
    rfl uniformConstantRankerA_warrantInternalToE

/-! ## Axiom-profile checks — kernel-pure unless otherwise noted. -/

-- V1–V2.
#print axioms exists_non_partition_relative
#print axioms not_forall_partition_relative
#print axioms exists_partition_relative

-- V3.
#print axioms case_bridge_uniform_unconditional_not_derivable

-- V4 R16 consistency.
#print axioms nonFactorisingA_not_warrantInternalToE
#print axioms exists_uniform_not_warrantInternalToE

-- V5 positive instance (R24: factorisingA).
#print axioms factorisingA_satisfies_all_antecedents

-- V6 R15 attack vector blocked.
#print axioms r15_attack_requires_unprovable_antecedent

-- V7 R24 paper-faithful identification (Iff.rfl, no axioms).
#print axioms partitionRelative_iff_featureExtractsAreEInternal

-- V8 R24 case-bridge derivation on factorisingA.
#print axioms prw_uniform_to_pr_applied_to_factorisingA
#print axioms lem_prw_reduction_applied_to_factorisingA

-- V9 R20 structural-validity (R22-updated 3-conjunct P2).
#print axioms r19_kill_destructuring_has_three_conjuncts

-- V10 R22 Fix B (retained R24) — DiscourseHypothesisH non-vacuity.
#print axioms discourseHypothesisH_satisfiable_when_admissibleIn_empty
#print axioms discourseHypothesisH_fails_when_admissibleIn_universal

-- V11 R24 honest acknowledgment: (hH A hAdm).2 IS canonical.
#print axioms discourseHypothesisH_is_implication_typecheck
#print axioms hW_dot_2_is_featureExtractsAreEInternal_eq_partitionRelative
#print axioms thm_impossibility_uses_H_via_admissibleIn

-- V12 R23 inconsistency ELIMINATED (R24 revert).
#print axioms uniformConstantRankerA_warrantInternalToE
#print axioms uniformConstantRankerA_partitionRelative
#print axioms r23_inconsistency_eliminated

end AsymmetricEliminativism.VacuityCheck
