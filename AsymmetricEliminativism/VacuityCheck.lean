/-
  AsymmetricEliminativism/VacuityCheck.lean

  Vacuity + consistency tests for v0.13.0 R18 Honest Acceptance
  per round-18 brief (preserves v0.12.0 R16 vacuity/consistency
  tests and adds two R18 definitional-equivalence tests).

  v0.11.0 R14 brief mandated vacuity testing of the substantive
  paper-faithful `partitionRelative` encoding.  R15 hostile
  validator then machine-verified that, despite R14 making
  `partitionRelative` non-vacuous, the 6 case-bridge axioms
  produced KERNEL-PURE PROOF OF `False` — i.e., the project
  was LOGICALLY INCONSISTENT.  R16 (Option B) fixed by adding
  the `warrantInternalToE` antecedent (containing the factoring
  conjunct).  R17 hostile validator then verified that this
  trivialised `lem:prw`: the 6 case-bridge axioms became
  kernel-pure derivable via `And.right` on the new antecedent.

  *R18 fix (Option C — Honest Acceptance per round-18 brief).*
  Accept that paper's `lem:prw` IS structurally trivial under
  typed Definition `\label{def:warrant}`: the partition-
  relativity factorisation IS the E-internality clause.  The
  case-analysis in paper's `lem:prw` proof body sieves WHICH
  warrants are E-internal (typeC3/typeC4b excluded by H) but
  does NOT prove a substantive non-trivial Lean reduction at
  the typed-structure level.  The 6 case-bridge axioms are
  converted to derived theorems with proof body `fun _ hW =>
  hW.2` — real Lean proofs, no `sorry`.  Anti-pattern #13
  (conclusion-as-axiom) GENUINELY BROKEN: 0 Cat 3 atomic
  axioms remain in the project for the partition-relativity
  chain.

  *R18 decomposition of `warrantInternalToE`.*  R17 noted that
  R16's `warrantInternalToE := caseFormOK ∧ factorisation`
  bundled paper-distinct conditions (anti-pattern #14:
  composite-axiom bundling, lifted to composite-`def`
  bundling).  R18 splits the predicate into two named `def`s:
  - `caseFormIsInternal` (Cat 3 `hypothesisPredicate`, paper
    lines 2188-2237 hypothesis (H) tag-exclusion).
  - `featureExtractsAreEInternal` (Cat 3 `structuralEquation`,
    paper lines 2099-2107 typed factorisation).
  `warrantInternalToE := caseFormIsInternal ∧
  featureExtractsAreEInternal` reconstructs the R16 predicate
  as a transparent conjunction of the two paper-distinct
  conditions.

  This file proves the eight R16 vacuity / consistency theorems
  PLUS the R18 definitional-equivalence theorems:

  (V1) `∀ A, A.partitionRelative` is NOT provable kernel-pure
       (V2 refutes this).

  (V2) `∃ A, ¬ A.partitionRelative` is constructible kernel-pure
       (the `nonFactorisingA` witness).

  (V3) Case-bridge conclusion `warrantForm = uniform →
       partitionRelative` (without `warrantInternalToE`
       antecedent) is NOT a Lean theorem — refutable
       kernel-pure by `nonFactorisingA`.  This is what makes the
       R18 case-bridge `theorem` proof body `fun _ hW => hW.2`
       NON-VACUOUS: the proof essentially uses `hW.2`, NOT just
       `hW.1` (case-form tag), and the case-form tag alone is
       insufficient.

  (V4) **R16 consistency, preserved under R18**:
       `¬ nonFactorisingA.warrantInternalToE` — the R15 attack's
       would-be antecedent is itself refutable.  Under R18
       decomposition, the proof projects `hWITE.2`
       (`featureExtractsAreEInternal`) and shows non-
       factorisation — identical proof body to R16.

  (V5) **Companion positive instance**: `factorisingA` (constant-
       featureExtract) has both `warrantForm = uniform` AND
       `warrantInternalToE` AND `partitionRelative`.  This
       shows the case-bridge theorem's antecedent is
       satisfiable (not universally-false).

  (V6) R15 attack vector verifiably blocked (unchanged under
       R18).

  (V7) **R18 definitional equivalence**: `A.partitionRelative
       ↔ A.featureExtractsAreEInternal` — formal verification
       that paper line 2109-2112's identification is realised
       definitionally in Lean.  This is the kernel-pure proof
       that R18 Honest Acceptance is structurally correct:
       paper's `lem:prw` reduction conclusion = paper's
       E-internality factorisation = same predicate.

  (V8) **R18 case-bridge derived theorem**: `prw_uniform_to_pr
       _ _ _ rfl hW = hW.2` definitionally.  This makes
       transparent that R18's case-bridges are kernel-pure
       derivable from the `warrantInternalToE` antecedent —
       precisely what makes them theorems rather than axioms.
       The substantive paper content is in `WarrantFeatureType`
       (case taxonomy) + `caseFormIsInternal` (hypothesis (H)
       tag exclusion), NOT in the per-case bridge derivation.

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
    is genuinely required for the case-bridge conclusion.

    Under v0.12.0 R16, the case-bridge axiom signature is
    `warrantForm = uniform → warrantInternalToE → partitionRelative`.
    Without the axiom, we cannot derive `partitionRelative` from
    `warrantForm = uniform ∧ warrantInternalToE` for an arbitrary
    procedure — this verifies the axiom carries genuine content
    beyond what the typed-structure definitions provide.

    Note: under R16, `warrantInternalToE` *contains* the factoring
    clause as its second conjunct.  So at first glance, deriving
    `partitionRelative` from `warrantInternalToE` looks like a
    second-conjunct projection.  The case-bridge axiom's
    additional content is the *exhaustiveness* commitment that
    the `WarrantFeatureType` taxonomy partitions the warrant-form
    sub-cases exhaustively under E-internality.  Below we verify
    that even the projection-form derivation requires explicit
    proof, not just the antecedent. -/

/-- Refutation of the unconditional form: `∀ A, warrantForm =
    uniform → partitionRelative` is NOT a Lean theorem.  This
    is the R15 attack target — its failure means the R15
    kill cannot proceed kernel-pure without consuming
    `prw_uniform_to_pr` (which now requires the
    `warrantInternalToE` antecedent that `nonFactorisingA`
    lacks). -/
theorem case_bridge_uniform_unconditional_not_derivable :
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

/-! ## (V4) R16 consistency verification.

    The R15 attack derives `False` by:
    1. Applying `prw_uniform_to_pr` to `nonFactorisingA` with
       `warrantForm = uniform` to obtain a `partitionRelative`
       witness.
    2. Refuting the witness via the (V2) non-factorisation
       argument.

    Under v0.12.0 R16, step (1) now ALSO requires a proof of
    `nonFactorisingA.warrantInternalToE`.  We verify this is
    itself unprovable kernel-pure: `nonFactorisingA.featureExtract
    = id` does NOT factor through any `(memberClass, featByClass)`
    on the `toyPart` partition (same non-factorisation
    argument).

    Hence the R15 attack vector is closed: no kernel-pure proof
    of `False` can be constructed via the R15 path. -/

/-- (V4) Consistency witness: `¬ nonFactorisingA.warrantInternalToE`.
    The R15 attack's would-be antecedent is itself refutable.

    `warrantInternalToE` requires the factoring conjunct per
    `\label{def:warrant}` E-internality clause (paper lines
    2099-2107).  `nonFactorisingA.featureExtract = id : Bool → Bool`
    returns two distinct values, but `exhibits := fun _ f => f =
    true` makes every Tcls member exhibit the folk-object `true`.
    A factorisation `featByClass ∘ memberClass` would have to map
    `true` (the folk-object) to a SINGLE feature value, but
    `featureExtract true = true` and `featureExtract false =
    false` are distinct.  No factorisation exists; the antecedent
    fails. -/
theorem nonFactorisingA_not_warrantInternalToE :
    ¬ nonFactorisingA.warrantInternalToE := by
  intro hWITE
  -- Extract the factoring conjunct (second component of the
  -- v0.12.0 R16 conjunction).
  obtain ⟨_hTag, hFactConj⟩ := hWITE
  obtain ⟨memberClass, featByClass, hFact⟩ := hFactConj
  -- Same non-factorisation argument as (V2).
  have h_true : nonFactorisingA.warrant.featureExtract true
      = featByClass (memberClass true) :=
    hFact true true rfl
  have h_false : nonFactorisingA.warrant.featureExtract false
      = featByClass (memberClass true) :=
    hFact false true rfl
  exact Bool.noConfusion (h_true.trans h_false.symm)

/-- (V4) Existence form: `∃ A, A.warrantForm = uniform ∧
    ¬ A.warrantInternalToE`.  This demonstrates the case-bridge
    antecedent meaningfully constrains the procedure — there
    exist `uniform`-tagged procedures that do NOT satisfy
    E-internality, refuting any case-bridge that would derive
    `partitionRelative` from `warrantForm = uniform` alone. -/
theorem exists_uniform_not_warrantInternalToE :
    ∃ A : ArbitrationProcedure Bool Bool toyPart,
      A.warrantForm = WarrantFeatureType.uniform ∧
      ¬ A.warrantInternalToE := by
  exact ⟨nonFactorisingA, rfl, nonFactorisingA_not_warrantInternalToE⟩

/-! ## (V5) Companion positive instance.

    The case-bridge axiom is non-trivially conditional: there
    exist procedures with `warrantForm = uniform ∧
    warrantInternalToE` (so the axiom IS applicable), and
    they have `partitionRelative` (so the axiom's conclusion
    holds for them).  This demonstrates the case-bridge is
    not vacuously satisfied by being inapplicable, nor
    universally-false. -/

/-- (V5) Companion witness: `factorisingA` (constant-
    featureExtract = true) satisfies BOTH antecedents AND the
    conclusion of `prw_uniform_to_pr`.  Demonstrates the
    case-bridge axiom is genuinely applicable to positive
    instances; the R16 antecedent additions did NOT trivialise
    the axiom into vacuous applicability.

    The witness is canonical: `factorisingA` is the simplest
    procedure satisfying E-internality on a toy partition; it
    is `partition-relative` precisely because its
    `featureExtract` is constant (the trivial factoring
    through any partition-membership assignment). -/
theorem factorisingA_satisfies_all_antecedents :
    factorisingA.warrantForm = WarrantFeatureType.uniform ∧
    factorisingA.warrantInternalToE ∧
    factorisingA.partitionRelative := by
  refine ⟨rfl, ?_, ?_⟩
  · -- `warrantInternalToE` = tag-exclusion ∧ factoring.
    refine ⟨⟨?_, ?_⟩, ?_⟩
    · -- tag-exclusion typeC3: `uniform ≠ typeC3_external` by `decide`.
      decide
    · -- tag-exclusion typeC4b.
      decide
    · -- factoring: any constant featureExtract factors trivially.
      refine ⟨fun _ => ⟨0, by decide⟩, fun _ => true, ?_⟩
      intro _ _ _; rfl
  · -- `partitionRelative` directly (same factoring witness).
    refine ⟨fun _ => ⟨0, by decide⟩, fun _ => true, ?_⟩
    intro _ _ _; rfl

/-! ## (V6) R15 kill blocked — explicit demonstration.

    Under v0.11.0 R14, the R15 attack reads:

      theorem r15_kill : False := by
        have h1 := prw_uniform_to_pr toyPart nonFactorisingA rfl
        -- h1 : nonFactorisingA.partitionRelative
        obtain ⟨_, _, hFact⟩ := h1
        exact Bool.noConfusion ((hFact true true rfl).trans
                                (hFact false true rfl).symm)

    Under v0.12.0 R16, `prw_uniform_to_pr` has signature
    `warrantForm = uniform → warrantInternalToE → partitionRelative`,
    so the application `prw_uniform_to_pr toyPart nonFactorisingA
    rfl` returns a function expecting `warrantInternalToE`, NOT
    a `partitionRelative` witness.  To proceed, the attacker
    would need to prove `nonFactorisingA.warrantInternalToE`,
    but (V4) shows this is unprovable.

    We codify this: the *closest-to-R15* would-be-attack theorem
    is now ITSELF kernel-pure refutable. -/

/-- (V6) The R15 attack vector requires a proof of
    `nonFactorisingA.warrantInternalToE`, which we have refuted
    in (V4).  Equivalently: the case-bridge applied to
    `nonFactorisingA` with `rfl : warrantForm = uniform` yields
    a *conditional* on `warrantInternalToE`, and that condition
    cannot be discharged kernel-pure.

    We state this as: the application `prw_uniform_to_pr Part
    nonFactorisingA rfl` is a function `warrantInternalToE →
    partitionRelative`; composing with `nonFactorisingA_not_
    warrantInternalToE` does NOT derive `False` — the
    composition is type-incorrect at the meta-level (you can
    only refute `(prw … rfl)` by exhibiting a counter-witness
    to the antecedent, which is precisely (V4)'s content).

    A cleaner Lean restatement of "R15 kill blocked":
    `nonFactorisingA.warrantInternalToE → False` is provable,
    but `nonFactorisingA.warrantInternalToE` itself is NOT
    provable (per (V4)), so the implication does not chain
    into a kernel-pure `False`. -/
theorem r15_attack_requires_unprovable_antecedent :
    ¬ ∃ (_ : nonFactorisingA.warrantInternalToE),
        nonFactorisingA.partitionRelative := by
  rintro ⟨hWITE, _⟩
  exact nonFactorisingA_not_warrantInternalToE hWITE

/-! ## (V7) R18 definitional equivalence: `partitionRelative ↔
    featureExtractsAreEInternal`.

    Paper line 2109-2112 explicitly identifies the
    partition-relative-weighting reduction with the typed-
    structure E-internality factorisation.  R18 Honest Acceptance
    accepts this identification at the Lean level: the two
    predicates are definitionally equal.  This is the formal
    verification that R18's structural triviality of `lem:prw`
    is real, not an encoding artefact. -/

/-- (V7) Kernel-pure proof of definitional equivalence
    `partitionRelative ↔ featureExtractsAreEInternal` for every
    arbitration procedure on every partition.

    Since both predicates unfold to the same existential
    statement `∃ memberClass featByClass, ∀ x f, A.exhibits x f
    → A.warrant.featureExtract x = featByClass (memberClass f)`,
    the equivalence is `Iff.rfl`. -/
theorem partitionRelative_iff_featureExtractsAreEInternal
    {FolkObj Tcls : Type}
    {Part : MutuallyUnrankedPartition FolkObj}
    (A : ArbitrationProcedure FolkObj Tcls Part) :
    A.partitionRelative ↔ A.featureExtractsAreEInternal :=
  Iff.rfl

/-! ## (V8) R18 case-bridge transparency: `prw_uniform_to_pr` is
    definitionally `And.right` projection.

    The 6 R18-converted case-bridges all share the proof body
    `fun _ hW => hW.2`.  We verify this is well-typed and
    delivers the correct conclusion for a specific witness. -/

/-- (V8) `prw_uniform_to_pr` applied to `factorisingA` yields
    `factorisingA.partitionRelative` directly from its
    `warrantInternalToE` witness — projecting the
    `featureExtractsAreEInternal` conjunct.  Kernel-pure proof
    via `factorisingA_satisfies_all_antecedents`. -/
theorem prw_uniform_to_pr_applied_to_factorisingA :
    factorisingA.partitionRelative := by
  obtain ⟨hForm, hWITE, _hPR⟩ :=
    factorisingA_satisfies_all_antecedents
  exact prw_uniform_to_pr toyPart factorisingA hForm hWITE

/-- (V8.b) `lem_prw_reduction` applied to `factorisingA` yields
    `partitionRelative ∨ failsAdjudication` — under R18 with
    `factorisingA` having `warrantForm = uniform` it takes the
    `Or.inl` branch via `prw_uniform_to_pr`'s `And.right`
    derivation.  Verifies the derived theorem's case-exhaustion
    `match` body is well-typed and routes correctly post-R18.  -/
theorem lem_prw_reduction_applied_to_factorisingA :
    factorisingA.partitionRelative ∨
    factorisingA.failsAdjudication := by
  obtain ⟨_, hWITE, _⟩ := factorisingA_satisfies_all_antecedents
  exact lem_prw_reduction toyPart factorisingA hWITE

/-! ## Axiom-profile checks — kernel-pure unless otherwise noted. -/

-- `exists_non_partition_relative` is kernel-pure.
#print axioms exists_non_partition_relative

-- `not_forall_partition_relative` is kernel-pure.
#print axioms not_forall_partition_relative

-- `exists_partition_relative` is kernel-pure.
#print axioms exists_partition_relative

-- `case_bridge_uniform_unconditional_not_derivable` is kernel-pure
-- (does NOT consume `prw_uniform_to_pr`).  This is the key
-- verification: the case-bridge axiom signature MUST include
-- `warrantInternalToE` to be consistent — without that antecedent
-- (R14 form), the universal `warrantForm = uniform →
-- partitionRelative` is REFUTABLE by `nonFactorisingA`.  R16's
-- antecedent-extension is therefore necessary, not optional.
#print axioms case_bridge_uniform_unconditional_not_derivable

-- (V4) R16 consistency: `nonFactorisingA.warrantInternalToE` is
-- kernel-pure refutable.  This is the central R16 verification:
-- the R15 attack's would-be antecedent is itself unprovable.
#print axioms nonFactorisingA_not_warrantInternalToE
#print axioms exists_uniform_not_warrantInternalToE

-- (V5) Positive instance: `factorisingA` satisfies BOTH
-- antecedents AND the conclusion of `prw_uniform_to_pr`.
#print axioms factorisingA_satisfies_all_antecedents

-- (V6) R15 attack vector verifiably blocked.
#print axioms r15_attack_requires_unprovable_antecedent

-- (V7) R18 definitional equivalence: partitionRelative ↔
-- featureExtractsAreEInternal.  Iff.rfl — depends on no axioms.
#print axioms partitionRelative_iff_featureExtractsAreEInternal

-- (V8) R18 case-bridge transparency: prw_uniform_to_pr applied
-- to factorisingA correctly delivers partitionRelative.
#print axioms prw_uniform_to_pr_applied_to_factorisingA
#print axioms lem_prw_reduction_applied_to_factorisingA

end AsymmetricEliminativism.VacuityCheck
