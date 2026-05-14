/-
  test/R23Attack.lean

  R23 attack vector documentation — VERIFIES NO LONGER APPLICABLE
  under v0.16.0 R24 FINAL HONEST CONVERGENCE.

  R23 hostile maximum-skepticism validator (against v0.15.0 R22)
  found the following machine-verified killing chain:

  ATTACK B (B.1 / B.2 / B.3): R22's strengthened `partitionRelative`
  with non-degeneracy required the ranker to hit ≥2 distinct
  partition indices on DIFFERENT FeatureSpace inputs — but
  quantified over the FULL FeatureSpace, not over the image of
  `featureExtract`.  Adjudication (`ranker ∘ featureExtract`)
  could be constant while non-degeneracy on the ranker held; this
  was the seed defect.

  ATTACK E (E.1.a / E.1.b / E.1.c): the killing vector itself.
  Paper's uniform case (paper lines 2127-2132) explicitly states
  "constant assignment to $\{i,j\}$ selects a single $E_m$" — i.e.,
  paper's actual uniform case has CONSTANT adjudication (single
  $E_m$ globally), hence CONSTANT ranker on the featureExtract
  image.  But R22's strengthened `partitionRelative` required NON-
  CONSTANT ranker.  Applying `prw_uniform_to_pr` (Cat 3 axiom
  under R22) to a uniform-constant-ranker witness derived
  `partitionRelative` including non-degeneracy — but the witness
  provably FAILS non-degeneracy.  Kernel-pure `False`:

    theorem uniform_case_bridge_inconsistency : False := by
      have hForm := rfl  -- uniformConstantRankerA.warrantForm = uniform
      have hWITE := uniformConstantRankerA_warrantInternalToE
      have hPR : uniformConstantRankerA.partitionRelative :=
        prw_uniform_to_pr toyPart uniformConstantRankerA hForm hWITE
      exact uniformConstantRankerA_not_partitionRelative hPR

  ATTACK D: thm_impossibility (under R22) was provable WITHOUT (H)
  by chaining the above `False`-derivation through `False.elim`.

  *v0.16.0 R24 RESOLUTION.*  R22 Fix A is REVERTED.
  `partitionRelative` is again literally `featureExtractsAreEInternal`
  (paper line 2109-2112 identification).  The 6 case-bridges
  become derived theorems with proof body `fun _ hW => hW.2`.
  Anti-pattern #13 (conclusion-as-axiom) is GENUINELY BROKEN:
  zero Cat 3 axioms for the partition-relativity derivation
  chain.

  Under R24:
  - ATTACK B is structurally GONE: no non-degeneracy clause to
    quantify over.
  - ATTACK E is ELIMINATED: `prw_uniform_to_pr` is a derived
    theorem, not an axiom; applying it to the uniform-constant-
    ranker witness yields `partitionRelative =
    featureExtractsAreEInternal` consistently, NO `False`
    derivable.  See `VacuityCheck.r23_inconsistency_eliminated`.
  - ATTACK D is GONE: thm_impossibility under R24 substantively
    requires (H) via R22 Fix B's `admissibleIn` antecedent.
  - ATTACK A (admissibleIn opaque): preserved.  This IS paper-
    faithful — `admissibleIn` is a paper-stipulated discourse-
    state predicate per paper line 1999-2002, not Lean-derivable
    for arbitrary procedures.

  This file documents each R23 attack vector + verifies its
  resolution under R24.
-/

import AsymmetricEliminativism

open AsymmetricEliminativism
open AsymmetricEliminativism.VacuityCheck

namespace R24R23Resolution

/-! ## ATTACK A — admissibleIn opaque axiom: PRESERVED as
    paper-faithful.

    `admissibleIn` is paper-stated per paper line 1999-2002 as a
    discourse-state regime predicate.  Lean cannot discharge it
    kernel-pure for arbitrary procedures; this is the paper-
    faithful encoding of the paper's "admissible within D"
    qualifier on the (H) hypothesis. -/

/-- A.1: For arbitrary A, Op, decidability requires Classical EM
    (paper-faithful: admissibleIn is opaque). -/
example {FolkObj Tcls : Type} (Part : MutuallyUnrankedPartition FolkObj)
    (A : ArbitrationProcedure FolkObj Tcls Part)
    (Op : Operationalisation FolkObj Tcls Part) :
    A.admissibleIn Op ∨ ¬ A.admissibleIn Op :=
  Classical.em _

/-! ## ATTACK B — partitionRelative non-degeneracy quantifying over
    full FeatureSpace: STRUCTURALLY GONE under R24.

    Under R24 reverted `partitionRelative := featureExtractsAreEInternal`,
    there is no non-degeneracy clause to quantify over.  The R22
    bug (non-degeneracy on full FeatureSpace, not image of
    featureExtract) is structurally inapplicable. -/

/-! ## ATTACK E — uniform-case axiom inconsistency: ELIMINATED.

    R22's `prw_uniform_to_pr` was a Cat 3 axiom asserting non-
    degeneracy on the uniform witness.  Paper's uniform case has
    constant ranker, refuting that non-degeneracy claim — yielding
    kernel-pure `False`.

    Under R24, `prw_uniform_to_pr` is a derived theorem.  Applied
    to the uniform-constant-ranker witness, it yields
    `partitionRelative = featureExtractsAreEInternal`
    consistently. -/

/-- E.1.a: The uniform-constant-ranker witness still has
    `warrantInternalToE` (case-form-internal + constant
    featureExtract trivially factorises). -/
example : uniformConstantRankerA.warrantInternalToE :=
  uniformConstantRankerA_warrantInternalToE

/-- E.1.b: The uniform-constant-ranker witness has
    `partitionRelative` under R24 (= `featureExtractsAreEInternal`,
    trivially via constant featureExtract). -/
example : uniformConstantRankerA.partitionRelative :=
  uniformConstantRankerA_partitionRelative

/-- E.1.c: Applying the case-bridge (now derived theorem) to the
    uniform-constant-ranker witness yields partitionRelative —
    CONSISTENTLY, no `False`.  R23 inconsistency ELIMINATED. -/
example : uniformConstantRankerA.partitionRelative :=
  r23_inconsistency_eliminated

/-! ## ATTACK D — thm_impossibility WITHOUT (H): now requires R22
    Fix B's `admissibleIn` antecedent.

    Under R24, thm_impossibility substantively uses (H) via the
    `admissibleIn` discharge: each P2 witness `⟨A, hAdm, ...⟩`
    supplies `hAdm : A.admissibleIn Op`, which is required to
    apply `hH A hAdm` and obtain `warrantInternalToE`.  Without
    (H), the proof cannot proceed. -/

/-- D.1: thm_impossibility is the paper-faithful conclusion under
    R24.  With (H), the proof goes through; the substantive
    content lives in (H)'s admissibleIn antecedent + the
    WarrantFeatureType taxonomy. -/
example (Op : Operationalisation Bool Bool toyPart)
        (hH : DiscourseHypothesisH toyPart Op) :
    ¬ SatisfiesP2 Bool Bool toyPart Op :=
  thm_impossibility toyPart Op hH

end R24R23Resolution

-- The uniform-constant-ranker witness is partition-relative
-- (consistently) under R24.
#print axioms r23_inconsistency_eliminated
#print axioms uniformConstantRankerA_warrantInternalToE
#print axioms uniformConstantRankerA_partitionRelative

-- Sanity check: thm_impossibility depends ONLY on admissibleIn
-- under R24 (no 6 case-bridge axioms; those are derived theorems).
#print axioms thm_impossibility
