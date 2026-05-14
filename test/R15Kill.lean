import AsymmetricEliminativism

/-! R15 + R19 kill attack — VERIFIES BLOCKED UNDER v0.14.0 R20.

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
      -- depends on axioms: [propext, prw_uniform_to_pr, Quot.sound]

    Root cause: each `prw_X_to_pr` axiom had signature `A.warrantForm
    = X → A.partitionRelative`, dropping paper `\label{lem:prw}` line
    2116 "constructible from E alone" antecedent.  With R14's
    substantive `partitionRelative`, non-factorising warrants with
    `warrantForm = uniform` were direct counter-witnesses
    (`nonFactorisingA`).

    Under v0.12.0 R16 Option B fix, `prw_uniform_to_pr` has signature
    `warrantForm = uniform → warrantInternalToE → partitionRelative`.
    The application `prw_uniform_to_pr toyPart nonFactorisingA rfl`
    now returns a `warrantInternalToE → partitionRelative` function,
    NOT a `partitionRelative` witness.  To proceed, the attacker
    would need `nonFactorisingA.warrantInternalToE`, but this is
    itself unprovable kernel-pure (see VacuityCheck
    `nonFactorisingA_not_warrantInternalToE`).

    Under v0.13.0 R18 Honest Acceptance, `prw_uniform_to_pr` is now
    a derived theorem with the same signature as R16 (and proof
    body `fun _ hW => hW.2`).  The R15 attack vector remains
    blocked for the same reason: the antecedent
    `nonFactorisingA.warrantInternalToE` is still kernel-pure
    refutable.

    *R19 kill (round 19, against v0.13.0 R18).*
    Per R19 hostile validator's machine-verified killing report,
    the following attack derived a kernel-pure no-axiom proof
    against the v0.13.0 R18 `SatisfiesP2`:

      theorem r19_kill (Op) : ¬ SatisfiesP2 FolkObj Tcls Part Op :=
        fun ⟨A, hNotPR, _, hWITE⟩ => hNotPR hWITE.2

    Root cause: R18's `SatisfiesP2 := ∃ A, ¬ A.partitionRelative ∧
    ¬ A.failsAdjudication ∧ A.warrantInternalToE`.  Since R18's
    `warrantInternalToE.2 = featureExtractsAreEInternal =
    partitionRelative` definitionally (paper line 2109-2112), the
    existential body's first conjunct `¬ A.partitionRelative` and
    third conjunct `A.warrantInternalToE` (via `.2`) are mutually
    exclusive — `SatisfiesP2 ↔ False` provable by typing alone.
    The R19 kill was a kernel-pure no-axiom theorem, trivializing
    `thm_impossibility`.

    Under v0.14.0 R20 STRUCTURAL FIX, `SatisfiesP2` is restructured
    to `∃ A, ¬ A.partitionRelative ∧ ¬ A.failsAdjudication` (TWO
    conjuncts, NO warrantInternalToE).  The R19 attack pattern
    `fun ⟨A, hNotPR, _, hWITE⟩ => …` (expecting 4 bindings)
    FAILS to type-check against the 3-binding post-R20 P2.

    This file:
      - documents both R15 and R19 attack vectors,
      - exhibits the type-incomplete intermediate that R15 reaches,
      - exhibits the R19-style attack that no longer type-checks,
      - exhibits a positive R19-redux refutation: the R19-style
        statement IS satisfiable (V9.c witness), so it cannot be
        trivially refuted post-R20. -/

open AsymmetricEliminativism

/-- Verification: the v0.11.0 R14 kill cannot reach `False` under
    R16+.  Attempting the original R15 attack yields a
    type-incomplete intermediate (a function expecting
    `warrantInternalToE` instead of a `partitionRelative` witness),
    which `VacuityCheck.nonFactorisingA_not_warrantInternalToE`
    blocks. -/
example : VacuityCheck.nonFactorisingA.warrantInternalToE →
          VacuityCheck.nonFactorisingA.partitionRelative :=
  prw_uniform_to_pr VacuityCheck.toyPart VacuityCheck.nonFactorisingA rfl

/-- Under R16+, attempting to discharge the R16 antecedent leads
    directly to contradiction with
    `nonFactorisingA_not_warrantInternalToE`.  This `example`
    succeeds (kernel-pure), demonstrating the R15 attack vector
    routes through an unprovable antecedent. -/
example (hWITE : VacuityCheck.nonFactorisingA.warrantInternalToE) :
    False :=
  VacuityCheck.nonFactorisingA_not_warrantInternalToE hWITE

/-- v0.14.0 R20 verification: under post-R20 `SatisfiesP2` (two
    conjuncts, no `warrantInternalToE`), the R19 attack pattern
    `fun ⟨A, hNotPR, _, hWITE⟩ => …` would expect 4 bindings;
    Lean accepts only 3-binding patterns.  We exhibit the
    well-typed 3-binding pattern for the post-R20 P2.

    *Critical observation.*  The R19-style proof body
    `fun ⟨_, hNotPR, _, hWITE⟩ => hNotPR hWITE.2` would
    require a third conjunct `hWITE` bindable to
    `A.warrantInternalToE`.  Under R20, the third existential
    conjunct does NOT exist in `SatisfiesP2`, so the rintro
    pattern with 4 bindings fails to type-check.  We demonstrate
    by writing the well-typed 3-binding version:
-/
example (Op : Operationalisation Bool Bool VacuityCheck.toyPart) :
    SatisfiesP2 Bool Bool VacuityCheck.toyPart Op → True :=
  fun ⟨_A, _hNotPR, _hNotFails⟩ => trivial

/-- Under R20, the R19-style refutation `theorem r19_redux
    (Op) : ¬ SatisfiesP2 Op` is NOT provable kernel-pure: V9.c
    (`r19_redux_blocked_by_satisfiability`) exhibits a witness
    `nonFactorisingA` satisfying the existential body, so the
    refutation FAILS.  The post-R20 impossibility theorem
    requires `DiscourseHypothesisH` as an EXPLICIT hypothesis
    to derive the contradiction. -/
example (Op : Operationalisation Bool Bool VacuityCheck.toyPart) :
    SatisfiesP2 Bool Bool VacuityCheck.toyPart Op :=
  VacuityCheck.r19_redux_blocked_by_satisfiability Op

#print axioms VacuityCheck.nonFactorisingA_not_warrantInternalToE
#print axioms VacuityCheck.r19_redux_blocked_by_satisfiability
#print axioms VacuityCheck.thm_impossibility_substantively_uses_H
