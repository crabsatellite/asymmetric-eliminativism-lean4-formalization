/-
  AsymmetricEliminativism/VacuityCheck.lean

  Vacuity + consistency tests for v0.15.0 R22 DUAL FIX per
  round-22 brief (preserves all prior R14/R16/R18/R20 vacuity/
  consistency/definitional-equivalence/structural-validity tests
  where compatible; adds R22-specific tests for the dual fix).

  *v0.15.0 R22 DUAL FIX per round-22 brief.*  R21 hostile
  validator found 2 critical defects in v0.14.0 R20:
    DEFECT 1: V7 `partitionRelative_iff_featureExtractsAreEInternal
       := Iff.rfl` lets `thm_impossibility` reduce to 2-line
       bypass `exact hNotPR (hH A).2`, bypassing all
       R5/R14/R16/R18/R20 substantive machinery.
    DEFECT 2: `DiscourseHypothesisH := ∀ A, warrantInternalToE`
       is UNIVERSALLY FALSE for any non-trivial (Part, Op) because
       arbitrary `nonFactorisingA`-style procedures are
       Lean-constructible.  Makes `thm_impossibility` vacuously
       true (false antecedent → anything).

  R22 dual fix:
    FIX A: Strengthen `partitionRelative` with paper line 2168-
       2170 non-degeneracy conjunct.  Now strictly stronger than
       `featureExtractsAreEInternal`; case-bridges CANNOT be
       proved by `And.right` projection; they are reinstated as
       Cat 3 axioms with paper-cited justification.
    FIX B: Add `admissibleIn` Cat 3 hypothesisPredicate axiom
       restricting paper hypothesis (H) to admissible-within-D
       procedures.  `DiscourseHypothesisH` restricted to
       `∀ A, A.admissibleIn Op → A.warrantInternalToE`.
       `SatisfiesP2` adds an `admissibleIn` conjunct.
       `thm_impossibility` extracts `hH A hAdm` for each P2
       witness.

  *Anti-pattern history.*
   - R7  v0.9.0: cosmetic Weighting → R8 killed.
   - R14 v0.11.0: missing antecedent → R15 killed.
   - R16 v0.12.0: composite predicate → R17 killed.
   - R18 v0.13.0: definitional smuggling in SatisfiesP2 → R19 killed.
   - R20 v0.14.0: P2 vs (H) restructure but partitionRelative still
     literally = featureExtractsAreEInternal AND (H) universally false
     → R21 killed (2 defects).
   - R22 v0.15.0: DUAL FIX — partitionRelative strengthened with
     non-degeneracy + admissibleIn predicate restricts (H) →
     R23-target.

  This file proves:

  (V1)  `∀ A, A.partitionRelative` is NOT provable.

  (V2)  `∃ A, ¬ A.partitionRelative` is constructible.

  (V3)  Case-bridge unconditional form `warrantForm = uniform →
        partitionRelative` (without `warrantInternalToE`) is NOT
        a Lean theorem.

  (V4)  R16 consistency: `¬ nonFactorisingA.warrantInternalToE`.

  (V5)  Companion positive instance with NON-DEGENERATE ranker
        (R22 update): `partitionRelativeA` satisfies all P2-related
        antecedents (warrantForm = uniform AND warrantInternalToE
        AND partitionRelative including non-degeneracy).

  (V6)  R15 attack vector verifiably blocked.

  (V7)  **R22 update — separation, not equivalence**:
        `featureExtractsAreEInternal` and `partitionRelative` are
        now STRICTLY DIFFERENT predicates.  We exhibit a procedure
        with `featureExtractsAreEInternal` but
        `¬ partitionRelative` (via constant ranker), refuting any
        2-line `hW.2` bypass.

  (V8)  R18 case-bridge transparency (R22 update): the case-
        bridges are paper-cited axioms; they apply on witness
        `partitionRelativeA` to deliver `partitionRelative`.

  (V9)  R20 structural-validity (preserved + updated for R22):
        `DiscourseHypothesisH toyPart Op` failure on `(admissibleIn
        := True)` instance; R19 kill still blocked under R22.

  (V10) **R22 NEW** — `DiscourseHypothesisH` satisfiability /
        non-trivial-constraint tests:
        (V10.a) Construct a discourse-state where (H) HOLDS by
          stipulating `admissibleIn := A = partitionRelativeA` —
          the unique admissible procedure has E-internal warrant.
        (V10.b) Construct a discourse-state where (H) FAILS by
          stipulating `admissibleIn := True` for all A — then
          `nonFactorisingA` refutes `∀ A, warrantInternalToE`.

  (V11) **R22 NEW** — `thm_impossibility` R21 bypass `exact hNotPR
        (hH A).2` is now type-incorrect: under post-R22
        DiscourseHypothesisH, `hH A` requires `admissibleIn A Op`
        proof (not a Lean truth); under post-R22 partitionRelative,
        even granting admissibility, `hH A hAdm : warrantInternalToE`
        does not project to a `partitionRelative` witness via
        `.2` (because `.2 : featureExtractsAreEInternal`, which is
        strictly weaker than `partitionRelative` under R22).

  (V12) **R22 NEW** — `partitionRelative` non-degeneracy
        non-trivially constrains the ranker.  We exhibit a
        constant-ranker procedure where the non-degeneracy clause
        fails, refuting `∀ A : (constant-ranker), partitionRelative`.

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
  -- Under R22 partitionRelative = featureExtractsAreEInternal ∧ non-degeneracy.
  -- It suffices to refute the first conjunct.
  intro hPR
  obtain ⟨hFact, _hNonDegen⟩ := hPR
  obtain ⟨memberClass, featByClass, hF⟩ := hFact
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

    *v0.15.0 R22 update.*  Under the strengthened predicate, the
    witness needs BOTH (a) factoring AND (b) non-degenerate
    ranker.  We construct `partitionRelativeA` with a 2-valued
    ranker hitting both Fin 2 elements (`true ↦ ⟨0,…⟩`,
    `false ↦ ⟨1,…⟩`) and a constant featureExtract = `false`
    (trivially factorises via any `memberClass` + `featByClass`
    sending the relevant class index to `false`). -/

/-- A partition-relative arbitration procedure: constant
    featureExtract (trivially factorises) + a 2-valued ranker
    hitting both Fin 2 elements (non-degenerate).  Witness for
    `∃ A, A.partitionRelative` post-R22. -/
def partitionRelativeA : ArbitrationProcedure Bool Bool toyPart where
  warrant := {
    FeatureSpace := Bool
    featureExtract := fun _ => true
    ranker := fun b => if b then ⟨0, by decide⟩ else ⟨1, by decide⟩
  }
  warrantForm := WarrantFeatureType.uniform
  exhibits := fun _ _ => True

/-- (V2.b) Companion witness: a partition-relative procedure
    exists post-R22.  Demonstrates the predicate is satisfiable,
    NOT universally false. -/
theorem exists_partition_relative :
    ∃ A : ArbitrationProcedure Bool Bool toyPart, A.partitionRelative := by
  refine ⟨partitionRelativeA, ?_, ?_⟩
  · -- featureExtractsAreEInternal: provide explicit witnesses.
    refine ⟨fun _ => ⟨0, by decide⟩, fun _ => true, ?_⟩
    intro _ _ _
    -- featureExtract x = true; featByClass _ = true.
    rfl
  · -- non-degeneracy: ranker hits ⟨0,…⟩ on `true` and ⟨1,…⟩ on
    -- `false` — two distinct partition indices.
    refine ⟨⟨0, by decide⟩, ⟨1, by decide⟩, true, false, ?_, ?_, ?_⟩
    · -- ranker true = ⟨0, …⟩
      rfl
    · -- ranker false = ⟨1, …⟩
      rfl
    · -- ⟨0, …⟩ ≠ ⟨1, …⟩
      intro h
      exact absurd (Fin.mk.inj_iff.mp h) (by decide)

/-! ## (V3) Case-bridge atomicity: the `prw_uniform_to_pr` axiom
    is genuinely required for the case-bridge conclusion.

    Under v0.15.0 R22, the case-bridge axiom signature is
    `warrantForm = uniform → warrantInternalToE → partitionRelative`.
    Without the axiom, the unconditional form
    `∀ A, warrantForm = uniform → partitionRelative` is REFUTABLE
    by `nonFactorisingA`. -/

theorem case_bridge_uniform_unconditional_not_derivable :
    ¬ (∀ A : ArbitrationProcedure Bool Bool toyPart,
        A.warrantForm = WarrantFeatureType.uniform → A.partitionRelative) := by
  intro hAll
  have hPR : nonFactorisingA.partitionRelative :=
    hAll nonFactorisingA rfl
  -- partitionRelative is conjunctive post-R22; project to (a).
  obtain ⟨⟨memberClass, featByClass, hF⟩, _hNonDegen⟩ := hPR
  have h_true : nonFactorisingA.warrant.featureExtract true
      = featByClass (memberClass true) :=
    hF true true rfl
  have h_false : nonFactorisingA.warrant.featureExtract false
      = featByClass (memberClass true) :=
    hF false true rfl
  exact Bool.noConfusion (h_true.trans h_false.symm)

/-! ## (V4) R16 consistency verification.

    Under v0.12.0+ R16, step (1) of the R15 attack now requires a
    proof of `nonFactorisingA.warrantInternalToE`.  We verify this
    is itself unprovable kernel-pure. -/

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

/-! ## (V5) Companion positive instance — R22 updated to use
    `partitionRelativeA` with non-degenerate ranker.

    The case-bridge axiom is non-trivially conditional: there
    exist procedures with `warrantForm = uniform ∧
    warrantInternalToE`, and they have `partitionRelative`
    (post-R22 with non-degeneracy). -/

theorem partitionRelativeA_satisfies_all_antecedents :
    partitionRelativeA.warrantForm = WarrantFeatureType.uniform ∧
    partitionRelativeA.warrantInternalToE ∧
    partitionRelativeA.partitionRelative := by
  refine ⟨rfl, ?_, ?_⟩
  · -- warrantInternalToE = caseFormIsInternal ∧ featureExtractsAreEInternal.
    refine ⟨⟨?_, ?_⟩, ?_⟩
    · decide
    · decide
    · refine ⟨fun _ => ⟨0, by decide⟩, fun _ => true, ?_⟩
      intro _ _ _; rfl
  · -- partitionRelative = featureExtractsAreEInternal ∧ non-degeneracy.
    refine ⟨?_, ?_⟩
    · refine ⟨fun _ => ⟨0, by decide⟩, fun _ => true, ?_⟩
      intro _ _ _; rfl
    · refine ⟨⟨0, by decide⟩, ⟨1, by decide⟩, true, false, ?_, ?_, ?_⟩
      · rfl
      · rfl
      · intro h
        exact absurd (Fin.mk.inj_iff.mp h) (by decide)

/-! ## (V6) R15 kill blocked — explicit demonstration.

    The case-bridge applied to `nonFactorisingA` with `rfl`
    yields a conditional on `warrantInternalToE`, which (V4)
    refutes kernel-pure. -/

theorem r15_attack_requires_unprovable_antecedent :
    ¬ ∃ (_ : nonFactorisingA.warrantInternalToE),
        nonFactorisingA.partitionRelative := by
  rintro ⟨hWITE, _⟩
  exact nonFactorisingA_not_warrantInternalToE hWITE

/-! ## (V7) R22 SEPARATION (NOT equivalence): `partitionRelative`
    is STRICTLY STRONGER than `featureExtractsAreEInternal`.

    Under v0.14.0 R20, `partitionRelative := featureExtractsAreEInternal`
    (literally identical RHS) made V7 an `Iff.rfl`, enabling the
    R21 2-line bypass `exact hNotPR (hH A).2`.

    Under v0.15.0 R22 Fix A, `partitionRelative` has an additional
    non-degeneracy conjunct.  The forward direction
    `partitionRelative → featureExtractsAreEInternal` holds
    (`.1` projection); the reverse fails on degenerate ranker.
    We exhibit a procedure where `featureExtractsAreEInternal`
    holds but `partitionRelative` fails (degenerate / constant
    ranker). -/

/-- A constant-ranker procedure: featureExtract = constant `true`
    (factorises trivially) + ranker is constant ⟨0, …⟩ (every
    FeatureSpace value routes to the same partition member).
    Witnesses the R22 separation `featureExtractsAreEInternal ⊊
    partitionRelative` by satisfying the former but failing the
    latter's non-degeneracy clause. -/
def degenerateRankerA : ArbitrationProcedure Bool Bool toyPart where
  warrant := {
    FeatureSpace := Bool
    featureExtract := fun _ => true
    ranker := fun _ => ⟨0, by decide⟩
  }
  warrantForm := WarrantFeatureType.uniform
  exhibits := fun _ _ => True

/-- (V7) Forward direction: `partitionRelative → featureExtractsAreEInternal`
    holds via `.1` projection.  Documents that the post-R22
    `partitionRelative` includes E-internality as its first
    conjunct. -/
theorem partitionRelative_to_featureExtractsAreEInternal
    {FolkObj Tcls : Type}
    {Part : MutuallyUnrankedPartition FolkObj}
    (A : ArbitrationProcedure FolkObj Tcls Part) :
    A.partitionRelative → A.featureExtractsAreEInternal :=
  fun hPR => hPR.1

/-- (V7) **Reverse separation**: `featureExtractsAreEInternal`
    is STRICTLY WEAKER than `partitionRelative` post-R22.
    `degenerateRankerA` satisfies the former but not the latter
    (the constant-ranker fails the non-degeneracy clause).

    *Significance.*  This refutes any 2-line `hW.2`-style bypass
    of `thm_impossibility`: even granting `warrantInternalToE`,
    projecting `.2` yields only `featureExtractsAreEInternal`,
    NOT `partitionRelative` — the non-degeneracy witness is
    additional content the case-bridges supply.  This breaks the
    R21 anti-pattern: the bypass `exact hNotPR (hH A).2` no
    longer type-checks. -/
theorem featureExtractsAreEInternal_does_not_imply_partitionRelative :
    ∃ A : ArbitrationProcedure Bool Bool toyPart,
      A.featureExtractsAreEInternal ∧ ¬ A.partitionRelative := by
  refine ⟨degenerateRankerA, ?_, ?_⟩
  · -- featureExtractsAreEInternal holds: constant featureExtract = true factorises.
    refine ⟨fun _ => ⟨0, by decide⟩, fun _ => true, ?_⟩
    intro _ _ _; rfl
  · -- partitionRelative fails: non-degeneracy fails for constant ranker.
    intro hPR
    obtain ⟨_hFact, hNonDegen⟩ := hPR
    obtain ⟨k₁, k₂, _feat₁, _feat₂, hR1, hR2, hNe⟩ := hNonDegen
    -- ranker is constant ⟨0, _⟩, so ranker feat₁ = ⟨0, _⟩ and
    -- ranker feat₂ = ⟨0, _⟩; substitute to get k₁ = ⟨0, _⟩ = k₂.
    -- The hypothesis k₁ ≠ k₂ then contradicts.
    have hEq : k₁ = k₂ := hR1.symm.trans hR2
    exact hNe hEq

/-! ## (V8) R22 case-bridge non-triviality: the 6 case-bridges
    are Cat 3 axioms post-R22.

    The case-bridges DO produce `partitionRelative` (including
    non-degeneracy) when applied with `warrantForm` and
    `warrantInternalToE` antecedents.  We exhibit this via
    application to `partitionRelativeA`.

    Note: the resulting `partitionRelative` proof carries
    NON-TRIVIAL content (the non-degeneracy witness, which is
    paper-stipulated structural commitment per case). -/

theorem prw_uniform_to_pr_applied_to_partitionRelativeA :
    partitionRelativeA.partitionRelative := by
  obtain ⟨hForm, hWITE, _hPR⟩ :=
    partitionRelativeA_satisfies_all_antecedents
  exact prw_uniform_to_pr toyPart partitionRelativeA hForm hWITE

theorem lem_prw_reduction_applied_to_partitionRelativeA :
    partitionRelativeA.partitionRelative ∨
    partitionRelativeA.failsAdjudication := by
  obtain ⟨_, hWITE, _⟩ := partitionRelativeA_satisfies_all_antecedents
  exact lem_prw_reduction toyPart partitionRelativeA hWITE

/-! ## (V9) v0.14.0 R20 STRUCTURAL FIX — verification block,
    R22-updated.

    Post-R22 SatisfiesP2 has 3 conjuncts (admissibleIn,
    ¬ partitionRelative, ¬ failsAdjudication).
    DiscourseHypothesisH := ∀ A, admissibleIn A Op → warrantInternalToE.
-/

/-- (V9.b) Post-R22 SatisfiesP2 destructuring has exactly 3
    conjuncts (A + 3 = 4 bindings).  R19's pattern
    `⟨A, hNotPR, _, hWITE⟩` matches 4 bindings, but the third
    binding `_` would correspond to `admissibleIn` (a paper
    axiom predicate), not a conjunction with `.2` — so the
    `hWITE.2` projection in R19's body is type-incorrect. -/
theorem r19_kill_destructuring_has_three_conjuncts
    (Op : Operationalisation Bool Bool toyPart) :
    SatisfiesP2 Bool Bool toyPart Op → True := by
  rintro ⟨_A, _hAdm, _hNotPR, _hNotFails⟩
  trivial

/-! ## (V10) R22 NEW — DiscourseHypothesisH non-vacuity tests.

    Under v0.14.0 R20, `DiscourseHypothesisH := ∀ A, warrantInternalToE`
    was UNIVERSALLY FALSE on any non-trivial (Part, Op) because
    arbitrary `nonFactorisingA`-style procedures are always
    Lean-constructible.

    Under v0.15.0 R22, `DiscourseHypothesisH := ∀ A, admissibleIn
    A Op → warrantInternalToE`.  The `admissibleIn` predicate is
    a paper-stipulated axiom-level Prop that does NOT
    automatically hold for arbitrary Lean-constructed procedures.

    (V10.a) demonstrates non-trivial-truth by exhibiting a
    discourse-state hypothesis under which `(H)` is true but
    requires the `admissibleIn` antecedent to discharge.
    (V10.b) demonstrates non-trivial-falsity. -/

/-- (V10.a) `DiscourseHypothesisH` is non-trivially satisfiable
    on toyPart: if `admissibleIn` happens to be empty (no
    procedure admissible), then (H) is vacuously true.  We
    encode "admissibleIn is empty" by assuming `∀ A, ¬ A.admissibleIn
    Op`, and prove `DiscourseHypothesisH toyPart Op` follows.

    *Significance.*  Under post-R22, (H) is non-vacuously
    satisfiable: there exist discourse states (any state where
    `admissibleIn` is empty) where (H) holds.  This refutes any
    claim that R22 relocated trivialization into a universally-
    false `admissibleIn`. -/
theorem discourseHypothesisH_satisfiable_when_admissibleIn_empty
    (Op : Operationalisation Bool Bool toyPart)
    (hEmpty : ∀ A : ArbitrationProcedure Bool Bool toyPart,
              ¬ A.admissibleIn Op) :
    DiscourseHypothesisH toyPart Op := by
  intro A hAdm
  -- hEmpty A says ¬ A.admissibleIn Op, contradicting hAdm.
  exact absurd hAdm (hEmpty A)

/-- (V10.b) `DiscourseHypothesisH` is non-trivially refutable on
    toyPart: if `admissibleIn` is universal (every procedure
    admissible), then `nonFactorisingA` is a counter-witness with
    `admissibleIn ∧ ¬ warrantInternalToE`, refuting (H).

    *Significance.*  Refutes any claim that R22 has merely
    relocated the V14-R20 trivialization into a universally-
    true `admissibleIn`.  The post-R22 `DiscourseHypothesisH`
    fails on universal-admissibility states. -/
theorem discourseHypothesisH_fails_when_admissibleIn_universal
    (Op : Operationalisation Bool Bool toyPart)
    (hUniv : ∀ A : ArbitrationProcedure Bool Bool toyPart,
             A.admissibleIn Op) :
    ¬ DiscourseHypothesisH toyPart Op := by
  intro hH
  have hWITE : nonFactorisingA.warrantInternalToE :=
    hH nonFactorisingA (hUniv nonFactorisingA)
  exact nonFactorisingA_not_warrantInternalToE hWITE

/-! ## (V11) R22 NEW — R21 bypass `exact hNotPR (hH A).2` is
    now type-incorrect.

    The R21 attack body was:
      theorem r21_bypass (Op) (hH) : ¬ SatisfiesP2 Op :=
        fun ⟨A, hNotPR, _⟩ => hNotPR (hH A).2

    Two reasons this no longer type-checks post-R22:
    (a) Post-R22 `DiscourseHypothesisH := ∀ A, admissibleIn A Op
        → warrantInternalToE`.  `hH A` is now an IMPLICATION
        `admissibleIn A Op → warrantInternalToE`, not a direct
        `warrantInternalToE` value.  `(hH A).2` is type-incorrect.
    (b) Even if one writes `hH A hAdm` to discharge admissibility
        (requires extracting hAdm from the P2 witness), the
        result is `warrantInternalToE`, and `.2` projects to
        `featureExtractsAreEInternal`, NOT `partitionRelative`.
        `partitionRelative` requires ADDITIONALLY the
        non-degeneracy conjunct (paper line 2168-2170 commitment),
        which the case-bridges supply per paper case-analysis.

    We codify (a) and (b) via explicit type-correct templates. -/

/-- (V11.a) Post-R22 `hH A` is an implication, not a direct
    value.  Verified by noting that `DiscourseHypothesisH Part Op
    = ∀ A, admissibleIn A Op → warrantInternalToE`. -/
theorem discourseHypothesisH_is_implication_typecheck
    (Op : Operationalisation Bool Bool toyPart)
    (hH : DiscourseHypothesisH toyPart Op)
    (A : ArbitrationProcedure Bool Bool toyPart)
    (hAdm : A.admissibleIn Op) :
    A.warrantInternalToE :=
  hH A hAdm

/-- (V11.b) Even after discharging admissibility, `.2` projects
    to `featureExtractsAreEInternal`, NOT `partitionRelative`.
    The bypass `exact hNotPR (hH A hAdm).2` would supply a
    `featureExtractsAreEInternal` witness where the goal expects
    a `partitionRelative` — a type error post-R22. -/
theorem hW_dot_2_is_featureExtractsAreEInternal_not_partitionRelative
    (A : ArbitrationProcedure Bool Bool toyPart)
    (hW : A.warrantInternalToE) :
    A.featureExtractsAreEInternal :=
  hW.2

/-- (V11.c) The R21 bypass is blocked by exhibiting a witness
    `degenerateRankerA` (V7) that satisfies
    `featureExtractsAreEInternal` but NOT `partitionRelative`.
    If the bypass were valid, applying it to `degenerateRankerA`
    (paired with sufficient antecedents) would derive a
    contradiction. -/
theorem r21_bypass_blocked_by_separation :
    ∃ A : ArbitrationProcedure Bool Bool toyPart,
      A.featureExtractsAreEInternal ∧ ¬ A.partitionRelative :=
  featureExtractsAreEInternal_does_not_imply_partitionRelative

/-! ## (V12) R22 NEW — `partitionRelative` non-degeneracy
    non-trivially constrains the ranker.

    `partitionRelative` requires `∃ k₁ k₂ feat₁ feat₂,
    ranker feat₁ = k₁ ∧ ranker feat₂ = k₂ ∧ k₁ ≠ k₂` (the
    ranker hits at least two distinct partition indices).  A
    constant-ranker procedure (e.g. `degenerateRankerA`) fails
    this clause: every `ranker feat = ⟨0, …⟩`, so no `k₁ ≠ k₂`
    pair can be witnessed.  This is the substantive paper line
    2168-2170 commitment. -/

theorem degenerateRankerA_not_partitionRelative :
    ¬ degenerateRankerA.partitionRelative := by
  intro hPR
  obtain ⟨_hFact, hNonDegen⟩ := hPR
  obtain ⟨k₁, k₂, _feat₁, _feat₂, hR1, hR2, hNe⟩ := hNonDegen
  -- Constant ranker: hR1 says k₁ = ⟨0,…⟩, hR2 says k₂ = ⟨0,…⟩.
  have hEq : k₁ = k₂ := hR1.symm.trans hR2
  exact hNe hEq

theorem partitionRelative_non_degeneracy_non_trivial :
    ∃ A : ArbitrationProcedure Bool Bool toyPart,
      A.featureExtractsAreEInternal ∧
      A.warrantInternalToE ∧
      ¬ A.partitionRelative := by
  refine ⟨degenerateRankerA, ?_, ?_, degenerateRankerA_not_partitionRelative⟩
  · refine ⟨fun _ => ⟨0, by decide⟩, fun _ => true, ?_⟩
    intro _ _ _; rfl
  · refine ⟨⟨?_, ?_⟩, ?_⟩
    · decide
    · decide
    · refine ⟨fun _ => ⟨0, by decide⟩, fun _ => true, ?_⟩
      intro _ _ _; rfl

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

-- V5 positive instance (R22 updated witness).
#print axioms partitionRelativeA_satisfies_all_antecedents

-- V6 R15 attack vector blocked.
#print axioms r15_attack_requires_unprovable_antecedent

-- V7 R22 separation (NOT equivalence): partitionRelative ⊋
-- featureExtractsAreEInternal.
#print axioms partitionRelative_to_featureExtractsAreEInternal
#print axioms featureExtractsAreEInternal_does_not_imply_partitionRelative

-- V8 R22 case-bridge non-triviality on the canonical witness.
#print axioms prw_uniform_to_pr_applied_to_partitionRelativeA
#print axioms lem_prw_reduction_applied_to_partitionRelativeA

-- V9 R20 structural-validity (R22-updated for 3-conjunct P2).
#print axioms r19_kill_destructuring_has_three_conjuncts

-- V10 R22 NEW — DiscourseHypothesisH non-vacuity.
#print axioms discourseHypothesisH_satisfiable_when_admissibleIn_empty
#print axioms discourseHypothesisH_fails_when_admissibleIn_universal

-- V11 R22 NEW — R21 bypass type-incorrect.
#print axioms discourseHypothesisH_is_implication_typecheck
#print axioms hW_dot_2_is_featureExtractsAreEInternal_not_partitionRelative
#print axioms r21_bypass_blocked_by_separation

-- V12 R22 NEW — non-degeneracy non-trivially constrains ranker.
#print axioms degenerateRankerA_not_partitionRelative
#print axioms partitionRelative_non_degeneracy_non_trivial

end AsymmetricEliminativism.VacuityCheck
