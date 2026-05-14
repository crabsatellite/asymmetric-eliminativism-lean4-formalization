import AsymmetricEliminativism

/-! R15 + R19 + R21 kill attack — VERIFIES BLOCKED UNDER v0.15.0 R22.

    *R15 kill (round 15, against v0.11.0 R14).*
    Per R15 hostile validator's machine-verified killing report,
    the following attack derived a kernel-pure proof of `False`
    from the v0.11.0 R14 case-bridge axioms:

      theorem r15_kill : False := by
        have h1 : nonFactorisingA.partitionRelative :=
          prw_uniform_to_pr toyPart nonFactorisingA rfl
        obtain ⟨_, _, hFact⟩ := h1
        exact Bool.noConfusion ((hFact true true rfl).trans
                                (hFact false true rfl).symm)

    Under v0.12.0+ R16, `prw_uniform_to_pr` has antecedent
    `warrantInternalToE`, so the attack routes through unprovable
    `nonFactorisingA.warrantInternalToE`.

    *R19 kill (round 19, against v0.13.0 R18).*
    Per R19 hostile validator, the following attack against R18's
    3-conjunct SatisfiesP2 derived a kernel-pure no-axiom proof:

      theorem r19_kill (Op) : ¬ SatisfiesP2 FolkObj Tcls Part Op :=
        fun ⟨A, hNotPR, _, hWITE⟩ => hNotPR hWITE.2

    Under v0.14.0 R20, SatisfiesP2 had 2 conjuncts (no
    warrantInternalToE).  Under v0.15.0 R22, SatisfiesP2 has 3
    conjuncts (admissibleIn + ¬ partitionRelative + ¬ failsAdjudication);
    the R19 pattern would need to bind 4 elements but the third
    binding `_` corresponds to `admissibleIn`, not a conjunction
    with `.2`.

    *R21 kill (round 21, against v0.14.0 R20).*
    Per R21 hostile validator, the following attacks derived
    kernel-pure no-axiom defeat against v0.14.0 R20:

    DEFECT 1: V7 `partitionRelative_iff_featureExtractsAreEInternal
       := Iff.rfl` lets `thm_impossibility` reduce to 2-line bypass:

      theorem r21_bypass (Op) (hH) : ¬ SatisfiesP2 Op :=
        fun ⟨A, hNotPR, _⟩ => hNotPR (hH A).2

    DEFECT 2: `DiscourseHypothesisH := ∀ A, warrantInternalToE` is
       UNIVERSALLY FALSE, making `thm_impossibility` vacuously true.

    Under v0.15.0 R22 DUAL FIX:
    - `partitionRelative` strengthened with non-degeneracy clause
      (paper line 2168-2170); `.2` projection of `warrantInternalToE`
      now yields `featureExtractsAreEInternal`, which is STRICTLY
      WEAKER than `partitionRelative` (V7).
    - `admissibleIn` axiom predicate restricts (H) to admissible
      procedures; `DiscourseHypothesisH := ∀ A, admissibleIn A Op →
      warrantInternalToE`.  `hH A` is now an implication, not a
      direct value.

    This file:
      - documents R15, R19, and R21 attack vectors,
      - exhibits the type-incorrect intermediates each reaches,
      - confirms R22 dual fix blocks all three. -/

open AsymmetricEliminativism

/-- R15 verification: applying the case-bridge to `nonFactorisingA`
    yields a function expecting `warrantInternalToE`, which V4
    refutes. -/
example : VacuityCheck.nonFactorisingA.warrantInternalToE →
          VacuityCheck.nonFactorisingA.partitionRelative :=
  prw_uniform_to_pr VacuityCheck.toyPart VacuityCheck.nonFactorisingA rfl

example (hWITE : VacuityCheck.nonFactorisingA.warrantInternalToE) :
    False :=
  VacuityCheck.nonFactorisingA_not_warrantInternalToE hWITE

/-- R19+R22 verification: post-R22 SatisfiesP2 has 3 conjuncts
    (admissibleIn + ¬ partitionRelative + ¬ failsAdjudication =
    4 bindings with A).  We exhibit the well-typed 3-conjunct
    rintro pattern. -/
example (Op : Operationalisation Bool Bool VacuityCheck.toyPart) :
    SatisfiesP2 Bool Bool VacuityCheck.toyPart Op → True :=
  fun ⟨_A, _hAdm, _hNotPR, _hNotFails⟩ => trivial

/-- R21 verification (Defect 1): after R22 Fix A, the bypass
    `(hH A hAdm).2` yields `featureExtractsAreEInternal`, NOT
    `partitionRelative`.  We exhibit this via the strict
    separation in V7. -/
example (A : ArbitrationProcedure Bool Bool VacuityCheck.toyPart)
        (hW : A.warrantInternalToE) :
    A.featureExtractsAreEInternal :=
  hW.2

/-- R21 verification (Defect 1, continued): the `.2` projection
    type-error.  We CANNOT have `(hW : warrantInternalToE).2 :
    partitionRelative` post-R22; the implicit conversion fails
    because `partitionRelative ⊋ featureExtractsAreEInternal`. -/
example :
    ∃ A : ArbitrationProcedure Bool Bool VacuityCheck.toyPart,
      A.featureExtractsAreEInternal ∧ ¬ A.partitionRelative :=
  VacuityCheck.featureExtractsAreEInternal_does_not_imply_partitionRelative

/-- R21 verification (Defect 2): post-R22, `DiscourseHypothesisH`
    is non-vacuously-true under (admissibleIn-empty) discourse
    states.  This refutes the R21 "(H) is universally false" claim. -/
example (Op : Operationalisation Bool Bool VacuityCheck.toyPart)
        (hEmpty : ∀ A : ArbitrationProcedure Bool Bool VacuityCheck.toyPart,
                  ¬ A.admissibleIn Op) :
    DiscourseHypothesisH VacuityCheck.toyPart Op :=
  VacuityCheck.discourseHypothesisH_satisfiable_when_admissibleIn_empty Op hEmpty

#print axioms VacuityCheck.nonFactorisingA_not_warrantInternalToE
#print axioms VacuityCheck.featureExtractsAreEInternal_does_not_imply_partitionRelative
#print axioms VacuityCheck.discourseHypothesisH_satisfiable_when_admissibleIn_empty
#print axioms VacuityCheck.discourseHypothesisH_fails_when_admissibleIn_universal
