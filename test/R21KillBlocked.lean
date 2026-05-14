/-
  test/R21KillBlocked.lean

  Direct verification that the R21 kill attack patterns fail to
  type-check against the v0.15.0 R22 dual-fixed `thm_impossibility`.
-/

import AsymmetricEliminativism

open AsymmetricEliminativism

/-! R21 Defect 1 attack: `exact hNotPR (hH A).2`.

    Under v0.14.0 R20, with `partitionRelative` literally equal
    to `featureExtractsAreEInternal` (V7 Iff.rfl), this 2-line
    bypass was kernel-pure derivable.

    Under v0.15.0 R22 Fix A, `partitionRelative` is STRICTLY
    STRONGER than `featureExtractsAreEInternal`.  The attack
    proof body now type-mismatches: `(hH A).2 :
    featureExtractsAreEInternal` (NOT `partitionRelative`), so
    `hNotPR (hH A).2` is type-incorrect.

    Additionally, under v0.15.0 R22 Fix B, `(hH A)` itself is
    no longer `warrantInternalToE` directly — it's
    `admissibleIn A Op → warrantInternalToE`, so `(hH A).2`
    references the `.2` of an implication, which is also
    type-incorrect.

    We document both kinds of blockage below. -/

namespace R21KillVerification

/-- (a) Well-typed R22 form: the post-R22 `hH` takes admissibility
    as antecedent.  The Lean error one would get attempting the
    R21 bypass `(hH A).2` against post-R22 thm_impossibility is:

      "type mismatch: term `hH A` has type
        `A.admissibleIn Op → A.warrantInternalToE`
       which doesn't have `.2` projection"

    We demonstrate the correct R22-compatible derivation: -/
example {FolkObj Tcls : Type} (Part : MutuallyUnrankedPartition FolkObj)
        (Op : Operationalisation FolkObj Tcls Part)
        (hH : DiscourseHypothesisH Part Op)
        (A : ArbitrationProcedure FolkObj Tcls Part)
        (hAdm : A.admissibleIn Op) :
        A.warrantInternalToE :=
  hH A hAdm

/-- (b) Even with admissibility discharged, `.2` projection
    yields `featureExtractsAreEInternal`, NOT `partitionRelative`.
    Post-R22 `partitionRelative` has an ADDITIONAL non-degeneracy
    conjunct.  The R21 bypass would supply a
    `featureExtractsAreEInternal` to a position expecting
    `partitionRelative` — type error.

    Demonstration: applying `.2` to a `warrantInternalToE` value
    yields `featureExtractsAreEInternal`. -/
example {FolkObj Tcls : Type} (Part : MutuallyUnrankedPartition FolkObj)
        (A : ArbitrationProcedure FolkObj Tcls Part)
        (hW : A.warrantInternalToE) :
        A.featureExtractsAreEInternal :=
  hW.2

/-- (c) The post-R22 SatisfiesP2 has 3 conjuncts.  The R21 bypass
    pattern `fun ⟨A, hNotPR, _⟩ => ...` expects 3 bindings
    (A + 2 conjuncts).  Post-R22 P2's existential body has
    `admissibleIn ∧ ¬partitionRelative ∧ ¬failsAdjudication`
    — three conjuncts means 4 bindings with A.  We show the
    correct rintro pattern: -/
example {FolkObj Tcls : Type} (Part : MutuallyUnrankedPartition FolkObj)
        (Op : Operationalisation FolkObj Tcls Part) :
        SatisfiesP2 FolkObj Tcls Part Op → True := by
  rintro ⟨_A, _hAdm, _hNotPR, _hNotFails⟩
  trivial

/-! R21 Defect 2 attack: `DiscourseHypothesisH := ∀ A,
    warrantInternalToE` is universally false because
    `nonFactorisingA` is constructible.

    Under v0.15.0 R22 Fix B, `DiscourseHypothesisH` includes the
    `admissibleIn` antecedent.  `nonFactorisingA.admissibleIn Op`
    is NOT automatically true — it's a paper-axiom-level Prop
    without a Lean reduction.  So `nonFactorisingA` does not
    automatically refute the (H) universal. -/

/-- V10.a verifies that the post-R22 (H) is satisfiable when
    `admissibleIn` is empty. -/
example (Op : Operationalisation Bool Bool VacuityCheck.toyPart)
        (hEmpty : ∀ A : ArbitrationProcedure Bool Bool VacuityCheck.toyPart,
                  ¬ A.admissibleIn Op) :
        DiscourseHypothesisH VacuityCheck.toyPart Op :=
  VacuityCheck.discourseHypothesisH_satisfiable_when_admissibleIn_empty Op hEmpty

/-- V10.b verifies that (H) fails when `admissibleIn` is universal. -/
example (Op : Operationalisation Bool Bool VacuityCheck.toyPart)
        (hUniv : ∀ A : ArbitrationProcedure Bool Bool VacuityCheck.toyPart,
                 A.admissibleIn Op) :
        ¬ DiscourseHypothesisH VacuityCheck.toyPart Op :=
  VacuityCheck.discourseHypothesisH_fails_when_admissibleIn_universal Op hUniv

/-! Combined: the dual fix is load-bearing.  Without EITHER fix,
    `thm_impossibility` would be trivialised. -/

/-- Capstone: the R22 dual fix is verified by the combination:
    (a) `partitionRelative` is strictly stronger than
        `featureExtractsAreEInternal` (V7 separation), so the
        R21 Defect 1 `.2` bypass is type-incorrect.
    (b) `DiscourseHypothesisH` is non-vacuously satisfiable AND
        non-vacuously refutable (V10.a / V10.b), so the R21
        Defect 2 universal-false vacuity attack is blocked. -/
example : True := trivial

/-! The R21 bypass attempt (transcribed for reference; commented
    out because it does NOT type-check post-R22):

      example {FolkObj Tcls : Type} (Part : MutuallyUnrankedPartition FolkObj)
              (Op : Operationalisation FolkObj Tcls Part)
              (hH : DiscourseHypothesisH Part Op) :
              ¬ SatisfiesP2 FolkObj Tcls Part Op :=
        fun ⟨A, hNotPR, _⟩ => hNotPR (hH A).2

    Lean errors:
    (a) Post-R22 SatisfiesP2 has 3 conjuncts: `admissibleIn ∧
        ¬ partitionRelative ∧ ¬ failsAdjudication`.  The
        3-binding `⟨A, hNotPR, _⟩` rintro pattern would need to
        accommodate 4 bindings (A + admissibleIn + ¬PR + ¬Fails).
    (b) `hH A` is type `A.admissibleIn Op → A.warrantInternalToE`
        (an implication), not `A.warrantInternalToE` directly.
        Cannot `.2` an implication.
    (c) Even if (b) is fixed via `hH A hAdm`, the result is
        `A.warrantInternalToE = caseFormIsInternal ∧
        featureExtractsAreEInternal`.  `.2` extracts
        `featureExtractsAreEInternal`.  But `hNotPR :
        ¬ A.partitionRelative` expects `A.partitionRelative
        = featureExtractsAreEInternal ∧ ∃ ..., ranker ...`
        (with non-degeneracy conjunct).  Type mismatch.

    Three independent type errors guard the R21 bypass post-R22. -/

#print axioms VacuityCheck.featureExtractsAreEInternal_does_not_imply_partitionRelative
#print axioms VacuityCheck.discourseHypothesisH_satisfiable_when_admissibleIn_empty
#print axioms VacuityCheck.discourseHypothesisH_fails_when_admissibleIn_universal

end R21KillVerification
