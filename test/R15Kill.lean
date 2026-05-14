import AsymmetricEliminativism

/-! R15 kill attack — VERIFIES BLOCKED UNDER v0.12.0 R16.

    Per R15 hostile validator's machine-verified killing report (round
    15), the following attack derived a kernel-pure proof of `False`
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

    This file does NOT define the kill proof (which would fail to
    typecheck); it documents the attack vector and points to the
    blocking witness. -/

open AsymmetricEliminativism

/-- Verification: the v0.11.0 R14 kill cannot reach `False` under
    R16.  Attempting the original R15 attack yields a
    type-incomplete intermediate (a function expecting
    `warrantInternalToE` instead of a `partitionRelative` witness),
    which `VacuityCheck.nonFactorisingA_not_warrantInternalToE`
    blocks. -/
example : VacuityCheck.nonFactorisingA.warrantInternalToE →
          VacuityCheck.nonFactorisingA.partitionRelative :=
  prw_uniform_to_pr VacuityCheck.toyPart VacuityCheck.nonFactorisingA rfl

/-- Under R16, attempting to discharge the R16 antecedent leads
    directly to contradiction with
    `nonFactorisingA_not_warrantInternalToE`.  This `example`
    succeeds (kernel-pure), demonstrating the R15 attack vector
    routes through an unprovable antecedent. -/
example (hWITE : VacuityCheck.nonFactorisingA.warrantInternalToE) :
    False :=
  VacuityCheck.nonFactorisingA_not_warrantInternalToE hWITE

#print axioms VacuityCheck.nonFactorisingA_not_warrantInternalToE
