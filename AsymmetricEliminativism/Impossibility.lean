/-
  AsymmetricEliminativism/Impossibility.lean

  Theorem `\label{thm:impossibility}` — *impossibility for unranked-
  extension concepts* — and its load-bearing Lemma
  `\label{lem:prw}` (Partition-Relative-Weighting Reduction).

  Companion to: Li 2026, "Asymmetric Eliminativism: A Diagnostic
  Framework for Reverse-Defined Concepts …" (SSRN 6723220 /
  Zenodo 10.5281/zenodo.20041562).

  *Statement (paper-level).*  Let `C` be a reverse-defined concept
  whose folk extension `E` admits a mutually unranked partition
  `{E_1, …, E_n}` with `n ≥ 2`.  Let `{Op_1, …, Op_n}` be
  operationalisations of `C` within discourse `D`, where `Op_i` is
  faithful to `E_i`.  Assume the *discourse-internality hypothesis*
  (H): every admissible arbitration warrant within `D` for
  adjudicating operationalisations of `C` derives from `\E`.
  Then no member of `{Op_i}` can simultaneously satisfy P2 and P3
  on novel target classes that fit some `E_j` but not others.

  *Lean-encoding choice (v0.8.0 R5 substantive paper-faithful
  decomposition; preserved in v0.10.0 R9).*  The v0.7.0 R4
  single-axiom `lem_prw_reduction` was flagged LAZY by the
  round-5 hostile validator: paper lines 2079-2270 supply a
  9-case taxonomy on the warrant's structural sub-form (uniform
  / typeA / typeB / typeC1 / typeC2_recursive / typeC3_external
  / typeC4a_internal_track / typeC4b_external_track / contextual),
  each with paper-prose justification of its reduction-conclusion.
  R5 fix: the case taxonomy is now a typed `WarrantFeatureType`
  carrier on `ArbitrationProcedure`, and `lem_prw_reduction` is a
  DERIVED theorem composing nine per-case atomic Cat 3
  stipulations — one per constructor of `WarrantFeatureType` —
  via case-exhaustion `match` on the inductive's `Fintype`
  structure.  Eight stipulations are typed bridges from a
  case-tag equality to a partition-relativity / no-ranking
  conclusion; the typeC3 and typeC4b stipulations are
  vacuous-antecedent forbid-by-(H) excluders, faithful to paper
  lines 2189-2191 ("forbidden by (H)") and 2220-2237 (heat-reform
  boundary).

  *v0.10.0 R9 honest revert of R7 cosmetic concretization
  (Option B per round-9 brief).*  Round 8 hostile validator
  catastrophically verified that v0.9.0 R7's `partitionRelative`
  concretization via the `Weighting` carrier was VACUOUSLY
  satisfied by constant weight: take `w := ⟨fun _ => 0⟩`, then
  `0 ≤ 0` discharges the predicate for every `A`.  Machine-
  verified kernel-pure.  The R7 `Weighting`-based `partitionRelative`
  def added zero mathematical content beyond the v0.8.0 bare-Prop
  encoding — it re-introduced anti-pattern #13 (conclusion-as-
  cosmetic-shape) at one level removed.

  R9 honestly reverts to the v0.8.0 bare-Prop `partitionRelative`
  encoding.  The 6 case-bridge axioms (`prw_uniform_to_pr`,
  `prw_typeA_to_pr`, `prw_typeC1_to_pr`, `prw_typeC2_recursive_to_pr`,
  `prw_typeC4a_internal_track_to_pr`, `prw_contextual_to_pr`) revert
  to bare-RHS atoms with shape `warrantForm = X → A.partitionRelative`
  (Cat 3 `structuralEquation`, `gapDefinitional`).

  *v0.12.0 R16 critical fix — Option B per round-16 brief.*  R15
  hostile validator machine-verified that the v0.11.0 R14
  6 case-bridge axioms produced kernel-pure proof of `False`
  (inconsistency).  Root cause: the axioms had signature
  `warrantForm = X → partitionRelative`, dropping paper
  `\label{lem:prw}` line 2116's "constructible from E alone"
  antecedent.  With R14's substantive `partitionRelative`
  predicate (E-feature factorisation), non-factorising warrants
  with `warrantForm = uniform` are counter-witnesses
  (`VacuityCheck.nonFactorisingA`), refuting each case-bridge
  axiom by direct construction:
    have h_kill := prw_uniform_to_pr Part nonFactorisingA rfl
    -- h_kill : nonFactorisingA.partitionRelative — but
    --   nonFactorisingA does NOT factor, so this proves False.

  R16 fix (Option B per round-16 brief):
  (1) `warrantInternalToE` extended in `Basic.lean` to encode
      the paper-faithful E-internality clause per
      `\label{def:warrant}` lines 2099-2107 (typed-structure
      version per paper line 2109-2112), i.e., conjunction of
      tag-exclusion (warrantForm ∉ external tags) AND factoring
      through E-features.
  (2) Each of the 6 case-bridge axioms now takes BOTH antecedents:
      `warrantForm = X → warrantInternalToE → partitionRelative`.
  (3) `lem_prw_reduction` threads `hW` to each case-bridge
      invocation.
  (4) `nonFactorisingA.warrantInternalToE` is now itself
      unprovable (no factoring witness for `featureExtract = id`),
      so the R15 attack vector fails to discharge the new
      antecedent — R15 kill verifiably FAILS.

  *What is preserved.*  The v0.8.0 R5 substantive achievements
  remain intact: `WarrantFeatureType` 9-constructor inductive;
  `failsAdjudication` / `warrantInternalToE` as `def`s on
  `WarrantFeatureType` (now extended in R16 with the factoring
  conjunct); `prw_typeB_no_ranking` /
  `prw_warrantInternalToE_excludes_typeC3` /
  `prw_warrantInternalToE_excludes_typeC4b` as derived theorems
  (updated R16 to use `.1.1`/`.1.2` projection on the conjunction);
  `lem_prw_reduction` as a derived theorem composing 6 atoms + 3
  derived theorems (updated R16 to thread `hW`).  v0.11.0 R14
  typed `Warrant` carrier + factoring-based `partitionRelative`
  predicate remain unchanged.
-/

import AsymmetricEliminativism.Basic

namespace AsymmetricEliminativism

/-! ## Lemma `\label{lem:prw}` — 9 per-case Cat 3 atomic stipulations.

  v0.8.0 R5 substantive decomposition.  The single
  `workingAssumption` axiom of v0.7.0 is decomposed into nine
  atomic Cat 3 structural-equation stipulations, each tied to
  one constructor of `WarrantFeatureType`, one citing paper-line
  range, and one paper-prose justification of its reduction-
  conclusion.  Downstream theorems compose the per-case atoms via
  case-exhaustion `match` on the typed warrant-form classifier.
-/

/--
  Paper `\label{lem:prw}` uniform case (paper lines 2092-2102).

  Statement (v0.15.0 R22 dual-fix per round-22 brief Step 1):
  if `A.warrantForm = uniform` AND `A.warrantInternalToE` (the
  paper-faithful E-internality predicate per `\label{def:warrant}`)
  then `A.partitionRelative` (the strengthened v0.15.0 R22
  predicate: featureExtractsAreEInternal ∧ non-degeneracy).

  *v0.15.0 R22 reinstated as Cat 3 axiom* per round-22 Step 1.
  Under v0.13.0 R18, this was converted to a derived theorem
  `fun _ hW => hW.2` because `featureExtractsAreEInternal`
  WAS literally `partitionRelative` (V7 `Iff.rfl`).  R21 hostile
  validator showed this trivialised `thm_impossibility` (2-line
  bypass `exact hNotPR (hH A).2`).  R22 Fix A strengthens
  `partitionRelative` by adding a paper line 2168-2170 non-
  degeneracy conjunct (paper: "some $E_m$ ranks first by virtue
  of $E_m$'s $f^*$-value"); now `partitionRelative` is STRICTLY
  STRONGER than `featureExtractsAreEInternal`, and the case-
  bridge can no longer be proved by `And.right` projection.

  The case-bridge atomically asserts: in the *uniform* sub-case
  (paper lines 2092-2102: "Uniform case: $W$ assigns the same
  $k$ to all disagreement-cases of $\Op_i$ vs.\ $\Op_j$.  The
  constant assignment to $\{i,j\}$ selects a single $E_m \in
  \{E_i, E_j\}$ as preferred globally, which is direct single-
  $E_m$ privileging — explicitly the P2-failure mode forbidden
  by Definition~\ref{def:op-properties}'s independence clause"),
  the warrant's ranker DOES distinguish partition members.  This
  is a paper-stipulated structural content per case (the "single
  $E_m$" in paper's clause distinguishes that $E_m$ from the
  others — i.e., the ranker hits at least two distinct $E$-
  indices at distinct FeatureSpace values).

  *Status / Cat 3 sub-type.*  Cat 3 `structuralEquation` per
  v6 §3.4.3.  Status `gapDefinitional` per v6 §1.1.

  Paper-prose justification (lines 2092-2102):
  "Uniform case: $W$ assigns the same $k$ to all disagreement-cases
  of $\Op_i$ vs.\ $\Op_j$.  The constant assignment to $\{i,j\}$
  selects a single $E_m \in \{E_i, E_j\}$ as preferred globally,
  which is direct single-$E_m$ privileging — explicitly the
  P2-failure mode forbidden by Definition~\ref{def:op-properties}'s
  independence clause."

  *Honest scope statement.*  Under R22, the per-case bridge
  carries Cat 3 axiomatic content: given `warrantForm = uniform`
  AND `warrantInternalToE`, the warrant's typed ranker witnesses
  the non-degeneracy clause of paper line 2168-2170.  This is the
  substantive paper content; the axiom is paper-cited per case
  rather than Lean-derivable.
-/
axiom prw_uniform_to_pr
    {FolkObj Tcls : Type}
    (Part : MutuallyUnrankedPartition FolkObj)
    (A : ArbitrationProcedure FolkObj Tcls Part) :
    A.warrantForm = WarrantFeatureType.uniform →
      A.warrantInternalToE → A.partitionRelative

/--
  Paper `\label{lem:prw}` type-(a) case (paper lines 2127-2131).

  Statement (v0.15.0 R22 dual-fix per round-22 brief):
  if `A.warrantForm = typeA` AND `A.warrantInternalToE` then
  `A.partitionRelative`.  See `prw_uniform_to_pr` docstring for
  the full R15/R16/R17/R18/R20/R21/R22 history and the R22
  reinstatement rationale.

  *v0.15.0 R22 reinstated as Cat 3 axiom.*  Same R22 rationale
  as `prw_uniform_to_pr`: strengthened `partitionRelative` (with
  non-degeneracy conjunct) is STRICTLY STRONGER than
  `featureExtractsAreEInternal`, so the case-bridge cannot be
  proved by `And.right` projection.  Status `gapDefinitional`
  / inputCategory `cat3PaperNovel` / sub-type
  `structuralEquation`.

  Paper-prose justification (lines 2127-2131):
  "Type-(a): $f$ belongs to some $E_m$.  Then $R$'s appeal to $f$
  privileges $E_m$, and the resulting ranking just is single-$E_m$
  privileging — option (i)."
-/
axiom prw_typeA_to_pr
    {FolkObj Tcls : Type}
    (Part : MutuallyUnrankedPartition FolkObj)
    (A : ArbitrationProcedure FolkObj Tcls Part) :
    A.warrantForm = WarrantFeatureType.typeA →
      A.warrantInternalToE → A.partitionRelative

/--
  Paper `\label{lem:prw}` type-(b) case (paper lines 2131-2134).

  Statement: if `A.warrantForm = typeB` then `A.failsAdjudication`.

  Distinguished from the other eight: typeB's paper-stated conclusion
  is `option (ii) — fails to produce a ranking`, NOT partition-
  relativity.  The unified `lem_prw_reduction` therefore has
  disjunctive conclusion `partitionRelative ∨ failsAdjudication`.

  *v0.8.0 R5 Issue 3 concretization.*  Was a Cat 3
  `structuralEquation` axiom in Issue 2; now derivable as a
  theorem because `failsAdjudication` is concretized as
  `A.warrantForm = typeB` in `Basic.lean`.  Sub-type
  `structuralEquation` retained for v6 §3.4.3 compliance
  documentation (the definitional reduction is paper-stipulated);
  status `gapClosed notInput` (derived theorem).

  Paper-prose justification (lines 2131-2134):
  "Type-(b): $f$ is shared by all $E_i$ symmetrically, in which
  case $R$'s output is constant across the $E_i$ and fails to
  produce a non-trivial ranking — option (ii)."
-/
theorem prw_typeB_no_ranking
    {FolkObj Tcls : Type}
    (Part : MutuallyUnrankedPartition FolkObj)
    (A : ArbitrationProcedure FolkObj Tcls Part) :
    A.warrantForm = WarrantFeatureType.typeB → A.failsAdjudication := by
  intro h; exact h

/--
  Paper `\label{lem:prw}` type-(c.1) case (paper lines 2151-2185).

  Statement (v0.15.0 R22 dual-fix per round-22 brief):
  if `A.warrantForm = typeC1` AND `A.warrantInternalToE` then
  `A.partitionRelative`.  See `prw_uniform_to_pr` docstring for
  the full R15/R16/R17/R18/R20/R21/R22 history and the R22
  reinstatement rationale.

  *v0.15.0 R22 reinstated as Cat 3 axiom.*  Same R22 rationale.
  Status `gapDefinitional` / inputCategory `cat3PaperNovel` /
  sub-type `structuralEquation`.

  Paper-prose justification (lines 2151-2185, esp. 2155-2170):
  "the procedure 'adjudicate $\Op_i$ vs.\ $\Op_j$ by routing to
  whichever of $E_i, E_j$ is higher under the $f^*$-induced ranking
  $R_{f^*}$' is a partition-relative weighting of $\{E_1, \ldots,
  E_n\}$ in the sense forbidden by P2's independence requirement."
  Paper line 2168-2170 explicitly cites the non-degeneracy clause:
  "$R_{f^*}$ outputs an ordering of the $E_i$ in which some $E_m$
  ranks first by virtue of $E_m$'s $f^*$-value".  Under typed
  Definition `\label{def:warrant}`, $R_{f^*}$ is the case-specific
  `ranker` field; the typeC1 case is the paradigm case for
  partition-relativity-via-ranker-distinguishing.
-/
axiom prw_typeC1_to_pr
    {FolkObj Tcls : Type}
    (Part : MutuallyUnrankedPartition FolkObj)
    (A : ArbitrationProcedure FolkObj Tcls Part) :
    A.warrantForm = WarrantFeatureType.typeC1 →
      A.warrantInternalToE → A.partitionRelative

/--
  Paper `\label{lem:prw}` type-(c.2) recursive-meta-appeal case
  (paper lines 2186-2196).

  Statement (v0.15.0 R22 dual-fix): if `A.warrantForm =
  typeC2_recursive` AND `A.warrantInternalToE` then
  `A.partitionRelative`.  See `prw_uniform_to_pr` docstring for
  the full history and the R22 reinstatement rationale.

  *v0.15.0 R22 reinstated as Cat 3 axiom.*  Status
  `gapDefinitional` / inputCategory `cat3PaperNovel` /
  sub-type `structuralEquation`.

  Paper-prose justification (lines 2186-2196):
  "(c.2) appeals to further $\E$-features to warrant the meta-
  choice (returning recursively to the type-(a) / type-(b) /
  type-(c) trichotomy at the meta-level) … Recursive appeal
  terminates only at types (a), (b), (c.1), or (c.3); none yields
  admissible adjudication-warrant within the (H)-discourse-state.
  Hence option (iii) collapses into options (i), (ii), or
  stipulation."  The reductive descent terminates in a ranker-
  distinguishing case (paper line 2168-2170 non-degeneracy).
-/
axiom prw_typeC2_recursive_to_pr
    {FolkObj Tcls : Type}
    (Part : MutuallyUnrankedPartition FolkObj)
    (A : ArbitrationProcedure FolkObj Tcls Part) :
    A.warrantForm = WarrantFeatureType.typeC2_recursive →
      A.warrantInternalToE → A.partitionRelative

/--
  Paper `\label{lem:prw}` type-(c.3) external-feature exclusion
  under (H) (paper lines 2189-2191).

  Statement: if `A.warrantInternalToE` then
  `A.warrantForm ≠ typeC3_external`.

  Sub-type Cat 3 `structuralEquation` per v6 §3.4.3.  The atom is
  a non-occurrence (case-exclusion) theorem: under the (H)-
  hypothesis `warrantInternalToE`, the typeC3 case-tag CANNOT
  apply because the antecedent stipulates the warrant derives
  from `\E`-features alone — i.e., precisely excludes external-
  feature warrants.

  Paper-prose justification (lines 2189-2191):
  "(c.3) appeals to features outside $\E$, which is forbidden by
  (H); this sub-case's closure is conditional on (H), and within
  the discourse-state where (H) holds, (c.3) is inadmissible."

  *v0.8.0 R5 Issue 3 concretization.*  Was a Cat 3
  `structuralEquation` axiom in Issue 2; now derivable as a
  theorem because `warrantInternalToE` is concretized as the
  conjunction of `warrantForm ≠ typeC3 ∧ warrantForm ≠ typeC4b`
  in `Basic.lean`.  Status `gapClosed notInput` (derived
  theorem).
-/
theorem prw_warrantInternalToE_excludes_typeC3
    {FolkObj Tcls : Type}
    (Part : MutuallyUnrankedPartition FolkObj)
    (A : ArbitrationProcedure FolkObj Tcls Part) :
    A.warrantInternalToE → A.warrantForm ≠ WarrantFeatureType.typeC3_external := by
  intro h; exact h.1.1

/--
  Paper `\label{lem:prw}` type-(c.4.a) internal track-record case
  (paper lines 2210-2218).

  Statement (v0.15.0 R22 dual-fix): if `A.warrantForm =
  typeC4a_internal_track` AND `A.warrantInternalToE` then
  `A.partitionRelative`.  See `prw_uniform_to_pr` docstring for
  the full history and the R22 reinstatement rationale.

  *v0.15.0 R22 reinstated as Cat 3 axiom.*  Status
  `gapDefinitional` / inputCategory `cat3PaperNovel` /
  sub-type `structuralEquation`.

  Paper-prose justification (lines 2210-2218):
  "(c.4.a) The track record is internal to $\E$ (uses only
  $\E$-feature-based assessments of past cases): then the
  meta-criterion is type-(c) and recursively returns to the
  trichotomy at the meta-level."  The recursive descent
  terminates at (a) / (b) / (c.1) under (H), reducing to
  partition-relativity by the typeC2_recursive case (paper line
  2168-2170 non-degeneracy).
-/
axiom prw_typeC4a_internal_track_to_pr
    {FolkObj Tcls : Type}
    (Part : MutuallyUnrankedPartition FolkObj)
    (A : ArbitrationProcedure FolkObj Tcls Part) :
    A.warrantForm = WarrantFeatureType.typeC4a_internal_track →
      A.warrantInternalToE → A.partitionRelative

/--
  Paper `\label{lem:prw}` type-(c.4.b) external track-record
  exclusion under (H) (paper lines 2220-2237).

  Statement: if `A.warrantInternalToE` then
  `A.warrantForm ≠ typeC4b_external_track`.

  Sub-type Cat 3 `structuralEquation` per v6 §3.4.3.  Non-
  occurrence (case-exclusion) theorem parallel to typeC3.

  Paper-prose justification (lines 2220-2237):
  "(c.4.b) The track record uses external-to-$\E$ predictive
  success … this is exactly the heat-reform escape route.  If
  such a track record exists and is recognised within $D$ as
  adjudication-warrant for $\C$-verdicts, (H) ceases to hold;
  the discourse-state has changed and the theorem no longer
  applies."  Under `warrantInternalToE` (the (H)-discourse-state
  the theorem ranges over), the typeC4b case-tag is unreachable
  because external-track-record warrant violates the warrant-
  internality stipulation.

  *v0.8.0 R5 Issue 3 concretization.*  Was a Cat 3
  `structuralEquation` axiom in Issue 2; now derivable as a
  theorem because `warrantInternalToE` is concretized as the
  conjunction of `warrantForm ≠ typeC3 ∧ warrantForm ≠ typeC4b`
  in `Basic.lean`.  Status `gapClosed notInput` (derived
  theorem).
-/
theorem prw_warrantInternalToE_excludes_typeC4b
    {FolkObj Tcls : Type}
    (Part : MutuallyUnrankedPartition FolkObj)
    (A : ArbitrationProcedure FolkObj Tcls Part) :
    A.warrantInternalToE → A.warrantForm ≠ WarrantFeatureType.typeC4b_external_track := by
  intro h; exact h.1.2

/--
  Paper `\label{lem:prw}` contextual case (paper lines 2257-2270).

  Statement (v0.15.0 R22 dual-fix): if `A.warrantForm =
  contextual` AND `A.warrantInternalToE` then `A.partitionRelative`.
  See `prw_uniform_to_pr` docstring for the full history and the
  R22 reinstatement rationale.

  *v0.15.0 R22 reinstated as Cat 3 axiom.*  Status
  `gapDefinitional` / inputCategory `cat3PaperNovel` /
  sub-type `structuralEquation`.

  Paper-prose justification (lines 2257-2270):
  "In case (ii), the contextual features used by $A$ to discriminate
  among $\Tcls$-members are themselves either features of the folk
  extension $\E$ or features external to $\E$.  In the $\E$-internal
  sub-case, contextual adjudication assigns each disagreement-case
  to one of $\Op_i, \Op_j$ on the basis of which $\E$-features the
  case exhibits; the mapping (which $\E$-features → which
  operationalisation) is itself a partition-relative weighting of
  the $E_i$ over $\Tcls$."  Paper line 2168-2170 non-degeneracy
  is realised by the assignment "distinguishing" partition members.
-/
axiom prw_contextual_to_pr
    {FolkObj Tcls : Type}
    (Part : MutuallyUnrankedPartition FolkObj)
    (A : ArbitrationProcedure FolkObj Tcls Part) :
    A.warrantForm = WarrantFeatureType.contextual →
      A.warrantInternalToE → A.partitionRelative

/-! ## Lemma `\label{lem:prw}` — derived theorem.

  Composes the nine per-case atomic stipulations above via case-
  exhaustion `match` on the `WarrantFeatureType` enumeration.  No
  longer an axiom — `axiom` → `theorem`.
-/

/--
  Lemma `\label{lem:prw}` — *Partition-Relative-Weighting
  Reduction*.

  v0.8.0 R5 substantive paper-faithful derivation: composes the
  nine per-case atomic Cat 3 stipulations
  (`prw_uniform_to_pr` through `prw_contextual_to_pr` plus the
  two non-occurrence excluders `prw_warrantInternalToE_excludes_typeC3`
  and `prw_warrantInternalToE_excludes_typeC4b`) via case-
  exhaustion `match` on the paper-faithful `WarrantFeatureType`
  inductive on `ArbitrationProcedure.warrantForm`.

  *v0.10.0 R9 honest revert.*  The v0.9.0 R7 `partitionRelative`
  concretization via the `Weighting` carrier was machine-verified
  VACUOUS (constant-weight discharges the predicate for every `A`).
  R9 reverts to v0.8.0 bare-Prop `partitionRelative` field on
  `ArbitrationProcedure`; the 6 case-bridge atoms revert to bare-
  RHS shape `warrantForm = X → A.partitionRelative` (Cat 3
  `structuralEquation`, `gapDefinitional`).  Honest close-target:
  process-level Warrant refinement modeling external-vs-partition
  feature distinction — paper-extension work.

  *Statement (R5 paper-faithful form).*  For any arbitration
  procedure `A` whose adjudication-warrant derives from `\E` alone
  (i.e., `A.warrantInternalToE`), either `A` reduces to a partition-
  relative weighting (`A.partitionRelative` — paper options (i.a)
  / (c.1) / (c.2) / (c.4.a) / contextual-internal) or `A` fails to
  produce a non-trivial ranking (`A.failsAdjudication` — paper
  option (ii), the typeB clause).  The external-feature cases
  (typeC3, typeC4b) are unreachable under `warrantInternalToE`
  by paper hypothesis (H).

  *Disjunctive conclusion vs the v0.7.0 unconditional one.*  The
  paper's `\label{thm:impossibility}` proof on lines 2307-2326
  ("If P2 fails, then $\Op_i$'s verdict on $x$ is one of three:
  (a) determinate but without arbitration, (b) indeterminate,
  failing P3, or (c) determinate by stipulation") confirms that
  options (a) and (c) are P2-failures (partition-relativity-via-
  stipulation) and option (b) is P3-failure (no-ranking).  The
  R5 disjunctive conclusion `partitionRelative ∨ failsAdjudication`
  is paper-faithful: failure of `lem_prw_reduction`'s P2-independence
  arises from either of these two structural failure modes.  Both
  modes still violate P2's independence requirement (`option (ii)`
  / `failsAdjudication` is paper line 2304's "no $A$ satisfying
  the independence requirement of P2 exists").
-/
theorem lem_prw_reduction
    {FolkObj Tcls : Type}
    (Part : MutuallyUnrankedPartition FolkObj)
    (A : ArbitrationProcedure FolkObj Tcls Part)
    (hW : A.warrantInternalToE) :
    A.partitionRelative ∨ A.failsAdjudication := by
  -- Case-exhaustion on the paper-faithful warrant-form taxonomy.
  -- v0.12.0 R16: each non-excluded case-bridge takes both
  -- `warrantForm = X` AND `warrantInternalToE` as antecedents; we
  -- thread `hW` through every per-case invocation.
  match h : A.warrantForm with
  | WarrantFeatureType.uniform =>
      exact Or.inl (prw_uniform_to_pr Part A h hW)
  | WarrantFeatureType.typeA =>
      exact Or.inl (prw_typeA_to_pr Part A h hW)
  | WarrantFeatureType.typeB =>
      exact Or.inr (prw_typeB_no_ranking Part A h)
  | WarrantFeatureType.typeC1 =>
      exact Or.inl (prw_typeC1_to_pr Part A h hW)
  | WarrantFeatureType.typeC2_recursive =>
      exact Or.inl (prw_typeC2_recursive_to_pr Part A h hW)
  | WarrantFeatureType.typeC3_external =>
      -- Forbidden by (H) — paper lines 2189-2191.
      exact absurd h (prw_warrantInternalToE_excludes_typeC3 Part A hW)
  | WarrantFeatureType.typeC4a_internal_track =>
      exact Or.inl (prw_typeC4a_internal_track_to_pr Part A h hW)
  | WarrantFeatureType.typeC4b_external_track =>
      -- Forbidden by (H) — paper lines 2220-2237.
      exact absurd h (prw_warrantInternalToE_excludes_typeC4b Part A hW)
  | WarrantFeatureType.contextual =>
      exact Or.inl (prw_contextual_to_pr Part A h hW)

/-! ## Hypothesis (H) — discourse-internality.

  Hypothesis (H) of the impossibility theorem: *every admissible
  arbitration procedure within `D` for adjudicating
  operationalisations of `C` derives its adjudication-warrant from
  `\E`*.  In the discourse-state where `C` remains reverse-defined
  and no external warrant has yet emerged, (H) holds.

  *Lean encoding (v0.14.0 R20 STRUCTURAL FIX).*  Under R20 per
  round-20 brief, (H) is lifted to a discourse-state hypothesis
  ON the impossibility theorem, NOT a conjunct of `SatisfiesP2`.
  This matches paper's actual structure (paper P2 at
  `def:op-properties` line 1976-1986 doesn't include admissibility
  as conjunct; admissibility is a discourse-state regime predicate
  per paper `\label{thm:impossibility}` hypothesis statement
  (paper line 1999-2009) and paper `\label{lem:prw}` (paper line
  2114-2120)).

  *Paper-faithful form.*  Paper says: "assume every arbitration
  procedure $A$ admissible within $D$ for adjudicating
  operationalisations of $\C$ derives its adjudication-warrant
  from $\E$" (paper line 1999-2002 + 2114-2116).  In the typed
  Lean encoding, this is the statement that EVERY procedure
  `A : ArbitrationProcedure` satisfies `A.warrantInternalToE`
  (i.e., its warrant is E-internal per
  `\label{def:warrant}`).  An "inadmissible-within-D" procedure
  doesn't exist within the discourse-state; (H) ranges only over
  admissible procedures, and the abstract Lean encoding of "A
  is admissible within D" is "A is an inhabitant of the
  `ArbitrationProcedure` type" — i.e., universally quantified.
-/

/--
  *Discourse-state hypothesis (H)* — paper's load-bearing
  hypothesis on the impossibility theorem (paper
  `\label{thm:impossibility}` line 1999-2009 + paper
  `\label{lem:prw}` line 2114-2120).

  *v0.15.0 R22 Fix B per round-22 brief.*  Restricted from the
  v0.14.0 R20 `∀ A : ArbitrationProcedure, A.warrantInternalToE`
  (universally false because non-factorising procedures are
  always Lean-constructible) to `∀ A, A.admissibleIn Op →
  A.warrantInternalToE` (paper-faithful: ranges only over
  admissible-within-D procedures, per paper line 1999-2002
  explicit "every arbitration procedure $A$ admissible within
  $D$ for adjudicating operationalisations of $\C$").

  *Definition.*  `DiscourseHypothesisH Part Op` holds iff every
  arbitration procedure `A` THAT IS ADMISSIBLE WITHIN D FOR
  ADJUDICATING `Op` (i.e., satisfies `A.admissibleIn Op`)
  satisfies `A.warrantInternalToE`.

  *Paper-faithful interpretation.*  Paper states (H) (paper line
  1999-2009): "every arbitration procedure $A$ admissible within
  $D$ for adjudicating operationalisations of $\C$ derives its
  adjudication-warrant from $\E$".  The post-R22 Lean encoding
  is the direct paper-transcription: the quantifier `∀ A` is
  restricted by `A.admissibleIn Op →`.

  *Sub-type / status.*  Cat 3 paper-novel `hypothesisPredicate`
  per v6 §3.4.2: a paper-stated discourse-state regime predicate
  consuming the paper-novel `admissibleIn` carrier.  Status
  `gapDefinitional` per v6 §1.1 — the predicate IS the paper's
  hypothesis (H), not a gap to close.

  *NOT a logical truth (post-R22).*  (H) is a hypothesis on the
  *discourse-state*, not a logical truth.  For forward-defined
  concepts (electron, gene) or for heat post-reform, (H) fails:
  there exist admissible arbitration procedures with external
  warrants (kinetic-theory-anchored predictive success for heat).

  *NOT universally-false (post-R22, breaks R21 defect 2).*  Under
  v0.14.0 R20, (H) was `∀ A : ArbitrationProcedure,
  A.warrantInternalToE`.  Since arbitrary `nonFactorisingA`-
  style procedures are Lean-constructible (their `featureExtract`
  may not factor through partition-membership), the unrestricted
  universal was UNIVERSALLY FALSE on any non-trivial (Part, Op).
  Result: `thm_impossibility`'s hypothesis was vacuously
  refutable, trivialising the theorem.  R22 Fix B adds the
  `admissibleIn` antecedent: arbitrary `nonFactorisingA` is
  Lean-constructible, but `nonFactorisingA.admissibleIn Op` is
  NOT discharged from the axiom (it is a paper-stipulated
  predicate without a Lean reduction), so the universal does
  NOT range over `nonFactorisingA` automatically.

  *NOT trivially-true (post-R22).*  In a discourse-state where
  `admissibleIn` admits non-factorising procedures, the
  universal-implication still fails for the non-factorising
  witnesses.  See `VacuityCheck.discourseHypothesisH_satisfiable`
  and `discourseHypothesisH_non_trivially_constrained`. -/
def DiscourseHypothesisH
    {FolkObj Tcls : Type}
    (Part : MutuallyUnrankedPartition FolkObj)
    (Op : Operationalisation FolkObj Tcls Part) : Prop :=
  ∀ A : ArbitrationProcedure FolkObj Tcls Part,
    A.admissibleIn Op → A.warrantInternalToE

/-! ## Theorem `\label{thm:impossibility}`.  -/

/--
  **Theorem `\label{thm:impossibility}`: impossibility for
  unranked-extension concepts.**

  Let `Part : MutuallyUnrankedPartition FolkObj` with `n ≥ 2`.  Let
  `Op_i` be an operationalisation faithful to some part `E_i`.
  Assume hypothesis (H): every admissible arbitration procedure
  has warrant internal to `\E` (`DiscourseHypothesisH Part Op_i`).
  Then `Op_i` cannot satisfy P2 — i.e., no admissible arbitration
  procedure can adjudicate `Op_i` against rivals on grounds
  *independent* of the partition.

  *v0.14.0 R20 STRUCTURAL FIX per round-20 brief.*  The R18
  encoding bundled `warrantInternalToE` as the third conjunct of
  `SatisfiesP2`'s existential body; R19 hostile validator found
  this trivialised the theorem because the existential body was
  provably `False` by typing alone (R19 kill:
  `fun ⟨A, hNotPR, _, hWITE⟩ => hNotPR hWITE.2` is a kernel-pure
  no-axiom proof of `¬ SatisfiesP2`).  R20 restructures
  `SatisfiesP2` (in `Basic.lean`) to drop the
  `warrantInternalToE` conjunct, and lifts hypothesis (H) to an
  explicit theorem hypothesis `(hH : DiscourseHypothesisH Part Op)`
  on `thm_impossibility`.  This matches paper's actual structure:
  paper P2 (def:op-properties line 1976-1986) doesn't include
  admissibility-as-conjunct; admissibility is the discourse-state
  hypothesis (H) per paper line 1999-2009 + 2114-2120.

  *Why P3 is omitted from the conclusion.*  Given the Boolean-
  verdict encoding of `Operationalisation.verdict`, P3 holds
  trivially (every `x : Tcls` has a determinate Boolean verdict;
  see `satisfiesP3_of_boolean`).  The paper-level form of the
  theorem says "no `Op_i` can simultaneously satisfy P2 and P3";
  under the strict Boolean encoding, the binding constraint
  reduces to `¬ P2`.  The paper-level `¬ (P2 ∧ P3)` form is
  available as the derived `thm_impossibility_paper_form` (below
  this theorem in the file), which packages the reduction
  explicitly.

  *Hypotheses.*

  * `Part : MutuallyUnrankedPartition FolkObj` — the folk extension's
     unranked partition.
  * `Op_i : Operationalisation FolkObj Tcls Part` — the
     operationalisation under attack.
  * `hH : DiscourseHypothesisH Part Op_i` — the discourse-state
     hypothesis (H): every arbitration procedure has E-internal
     warrant.

  *Conclusion.*  Under (H), `Op_i` cannot satisfy P2 — formally:
     the negation of `SatisfiesP2`.

  *Proof (post-R20 substantive structure).*  Suppose `Op_i`
  satisfied P2.  Then there exists an arbitration procedure `A`
  with `¬ A.partitionRelative` and `¬ A.failsAdjudication`.
  By (H), `A.warrantInternalToE` holds.  By Lemma
  `\label{lem:prw}` (`lem_prw_reduction`), `A.warrantInternalToE`
  implies `A.partitionRelative ∨ A.failsAdjudication`.  Either
  disjunct contradicts the P2 witness.  Hence `Op_i` cannot
  satisfy P2 under (H).

  *Note on substantive use of (H).*  The proof body USES (H)
  to extract `A.warrantInternalToE` from the existential
  witness `A`.  Without (H), the proof cannot proceed: the
  witness `A` may have external warrant, in which case
  `lem_prw_reduction` doesn't apply, and `Op_i` may legitimately
  satisfy P2 (this is the heat-post-reform discourse state
  per paper line 2036-2053).
-/
theorem thm_impossibility
    {FolkObj Tcls : Type}
    (Part : MutuallyUnrankedPartition FolkObj)
    (Op : Operationalisation FolkObj Tcls Part)
    (hH : DiscourseHypothesisH Part Op) :
    ¬ SatisfiesP2 FolkObj Tcls Part Op := by
  -- Suppose P2 holds: extract the arbitration witness with
  -- 3 conjuncts post-R22 (admissibleIn + ¬ partitionRelative
  -- + ¬ failsAdjudication).
  rintro ⟨A, hAdm, hNotPR, hNotFails⟩
  -- Apply hypothesis (H) to A using A's admissibility to obtain
  -- A.warrantInternalToE.  This is the SUBSTANTIVE use of (H)
  -- post-R22: the application discharges the admissibility
  -- antecedent from the P2 witness's first conjunct.
  have hWarrant : A.warrantInternalToE := hH A hAdm
  -- By the (H)-bound lem_prw_reduction, A's warrant being
  -- internal to E forces it into the disjunctive failure mode:
  -- either partition-relativity (paper option (a)/(c)) or
  -- adjudication-failure (paper option (ii)).
  rcases lem_prw_reduction Part A hWarrant with hPR | hFails
  · -- Partition-relativity contradicts hNotPR.
    exact hNotPR hPR
  · -- Adjudication-failure contradicts hNotFails.
    exact hNotFails hFails

/-! ## Downstream consequences (`\label{thm:impossibility}` corollaries). -/

/--
  *Corollary (impossibility ⟹ no admissible arbitration).*  Under
  the impossibility theorem's hypotheses, *every* arbitration
  procedure with admissible warrant (i.e., `warrantInternalToE`)
  either reduces to a partition-relative weighting OR fails to
  produce a non-trivial ranking.  This is the contrapositive form
  of `lem_prw_reduction` packaged as a derived statement, in the
  paper-faithful disjunctive shape (v0.8.0 R5).
-/
theorem no_partition_independent_admissible_warrant
    {FolkObj Tcls : Type}
    (Part : MutuallyUnrankedPartition FolkObj)
    (A : ArbitrationProcedure FolkObj Tcls Part) :
    A.warrantInternalToE → A.partitionRelative ∨ A.failsAdjudication :=
  lem_prw_reduction Part A

/--
  *Corollary (ensemble methods fail).*  An ensemble method
  aggregating verdicts across `{Op_1, …, Op_n}` is itself an
  arbitration procedure; if its warrant is internal to `\E`, it
  too reduces to partition-relative weighting OR fails adjudication.
  Hence ensemble-based adjudication does not escape P2.

  *Note.*  The Lean statement specialises `lem_prw_reduction` to an
  *ensemble-flavoured* arbitration procedure; the substantive
  reduction is identical because the underlying theorem is
  arbitration-procedure-agnostic.
-/
theorem ensemble_methods_fail_P2
    {FolkObj Tcls : Type}
    (Part : MutuallyUnrankedPartition FolkObj)
    (ensembleArbiter : ArbitrationProcedure FolkObj Tcls Part)
    (hWarrant : ensembleArbiter.warrantInternalToE) :
    ensembleArbiter.partitionRelative ∨ ensembleArbiter.failsAdjudication :=
  lem_prw_reduction Part ensembleArbiter hWarrant

/--
  *Corollary (impossibility transfers across operationalisations).*
  The impossibility theorem applies *uniformly* to every
  operationalisation in the family `{Op_1, …, Op_n}` faithful to
  the partition members.  Under (H) for each `Op_k`, none satisfies
  P2.

  *v0.14.0 R20 update.*  Hypothesis (H) is now per-operationalisation
  on the theorem statement: each `Op_k` requires its own
  `DiscourseHypothesisH Part (Op k)`.  We thread the family-
  indexed (H) through the `thm_impossibility` invocation per `k`.
-/
theorem impossibility_uniform_family
    {FolkObj Tcls : Type}
    (Part : MutuallyUnrankedPartition FolkObj)
    (Op : Fin Part.n → Operationalisation FolkObj Tcls Part)
    (hH : ∀ k : Fin Part.n, DiscourseHypothesisH Part (Op k)) :
    ∀ k : Fin Part.n, ¬ SatisfiesP2 FolkObj Tcls Part (Op k) := by
  intro k
  exact thm_impossibility Part (Op k) (hH k)

/--
  *Paper-form impossibility theorem.*  The paper states
  `\label{thm:impossibility}` as: "no member of `{Op_i}` can
  simultaneously satisfy P2 and P3", i.e., `¬ (P2 ∧ P3)`.  The Lean
  statement `thm_impossibility` is the load-bearing `¬ P2` clause.

  Under the strict Boolean-determinate encoding of an
  `Operationalisation` (verdict-map `Tcls → Bool`), P3 holds
  trivially (`satisfiesP3_of_boolean`): every `x : Tcls` has a
  determinate Boolean verdict by typing.  Hence `¬ (P2 ∧ P3)`
  follows from `¬ P2` directly: the conjunction's P3-conjunct is
  always true under the Boolean encoding, so the conjunction
  reduces to P2.

  *v0.14.0 R20 update.*  Hypothesis (H) is now explicit:
  `thm_impossibility_paper_form` takes
  `(hH : DiscourseHypothesisH Part Op)` and threads it through
  `thm_impossibility`.

  *Citation.*  Li 2026, `\label{thm:impossibility}` (paper-level
  conclusion); the reduction to the Boolean-encoding form is
  explicit in the paper's paragraph "The load-bearing clause and
  its Lean encoding" following the proof.

  *Why this is `theorem` rather than `axiom`.*  This is a derived
  consequence of `thm_impossibility` + `satisfiesP3_of_boolean`;
  no new axiom is required.  The reduction `¬ (P2 ∧ P3) ⟸ ¬ P2`
  uses the trivial-P3 fact and standard `And` elimination.
-/
theorem thm_impossibility_paper_form
    {FolkObj Tcls : Type}
    (Part : MutuallyUnrankedPartition FolkObj)
    (Op : Operationalisation FolkObj Tcls Part)
    (hH : DiscourseHypothesisH Part Op) :
    ¬ (SatisfiesP2 FolkObj Tcls Part Op ∧ SatisfiesP3 FolkObj Tcls Part Op) := by
  rintro ⟨hP2, _hP3⟩
  exact thm_impossibility Part Op hH hP2

end AsymmetricEliminativism
