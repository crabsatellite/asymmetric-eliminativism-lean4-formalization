/-
  AsymmetricEliminativism/AxiomAudit.lean

  Prints the axiom dependency list for every paper-level theorem.

  Trust policy.  Every `axiom` declaration in the project falls
  into exactly one of three categories (per `feedback_gap_ledger_in_lean4`
  ATOMIC MINIMAL UNITS interpretation):

    Cat 1 — Mathlib-derivable: claim closes via Mathlib + kernel.
            Must be encoded as `theorem`, not `axiom`.  Project has
            no Cat 1 axioms.

    Cat 2 — External published (textbook / peer-reviewed paper):
            opaque-carrier-bound atomic axiom + precise citation.
            Project has no Cat 2 axioms (the paper's mathematical
            content is paper-novel; no external textbook results
            are required by the impossibility theorem's structural
            skeleton beyond Lean kernel + Mathlib basic types).

    Cat 3 — Paper-novel: typed primitive carrier (encoded as Lean
            `structure` / `def` / `class`), paper-novel predicate
            (also typically encoded as `def`), or paper-stated
            atomic stipulation (encoded as `axiom`).  Cited
            only to Li 2026 `\label{...}` claims.

  Plus the Lean kernel axioms (`propext`, `Classical.choice`,
  `Quot.sound`), provided by Lean / Mathlib core.

  Constraints.  No (E) custom-scaffolding axioms (naked constants,
  abstract-type-inhabitation stipulations).  No composite axioms
  bundling multiple independent paper claims.

  Inventory by category (v0.15.0 R22 DUAL FIX per round-22 brief;
  v0.14.0 R20 structural fix preserved where applicable; v0.13.0
  R18 baseline superseded — case-bridges are Cat 3 axioms again;
  v0.12.0 R16 / v0.11.0 R14 / v0.8.0 R5 paper-faithful structure
  preserved.  Live counts: see `lake env lean
  AsymmetricEliminativism/Ledger.lean`).

    **v0.15.0 R22 DUAL FIX** — R21 hostile validator machine-
    verified 2 critical defects in v0.14.0 R20:
      DEFECT 1 (highest): V7 `partitionRelative_iff_featureExtractsAreEInternal
        := Iff.rfl` lets `thm_impossibility` reduce to 2-line
        bypass `exact hNotPR (hH A).2`, bypassing all R5/R14/
        R16/R18/R20 substantive machinery.
      DEFECT 2 (high): `DiscourseHypothesisH := ∀ A, warrantInternalToE`
        is UNIVERSALLY FALSE for any non-trivial (Part, Op).

    R22 dual fix:
    - Fix A: `partitionRelative` strengthened with paper line
      2168-2170 non-degeneracy conjunct.  Now strictly stronger
      than `featureExtractsAreEInternal`; case-bridges CANNOT
      be proved by `And.right` projection; reinstated as Cat 3
      axioms with paper-cited justification.
    - Fix B: `admissibleIn` Cat 3 hypothesisPredicate axiom
      restricting paper hypothesis (H) to admissible-within-D
      procedures.  `DiscourseHypothesisH := ∀ A, admissibleIn
      A Op → warrantInternalToE`.  `SatisfiesP2` adds an
      `admissibleIn` conjunct.  `thm_impossibility` extracts
      `hH A hAdm` for each P2 witness.

    Anti-pattern history:
      - R7  v0.9.0: cosmetic Weighting → R8 killed.
      - R14 v0.11.0: missing antecedent → R15 killed.
      - R16 v0.12.0: composite predicate → R17 killed.
      - R18 v0.13.0: definitional smuggling → R19 killed.
      - R20 v0.14.0: P2 vs (H) restructure but partitionRelative
        still literally = featureExtractsAreEInternal AND (H)
        universally false → R21 killed (2 defects).
      - R22 v0.15.0: DUAL FIX — partitionRelative strengthened
        with non-degeneracy + admissibleIn predicate restricts
        (H) → R23-target.

    *Project now has 7 Cat 3 axioms post-R22*:
    - 6 case-bridge axioms (reinstated from R18 derived theorems
      because partitionRelative is now strictly stronger than
      featureExtractsAreEInternal): prw_uniform_to_pr, prw_typeA_to_pr,
      prw_typeC1_to_pr, prw_typeC2_recursive_to_pr,
      prw_typeC4a_internal_track_to_pr, prw_contextual_to_pr.
    - 1 admissibleIn axiom: ArbitrationProcedure.admissibleIn
      (Cat 3 hypothesisPredicate; paper-stipulated scope-condition
      predicate per paper line 1999-2002).

    **v0.13.0 R18 Honest Acceptance** — converted the 6 R16
    case-bridge `axiom` declarations to `theorem` declarations.
    R17 hostile validator found that R16's `warrantInternalToE`
    contains `featureExtractsAreEInternal` as its second conjunct,
    which is *definitionally* identical to `partitionRelative`
    (paper line 2109-2112: "the typed-structure version of the
    prose-level description following Lemma~\ref{lem:prw} of
    $R_{f^*}$ being constructed from $f^*$-values on each $E_i$
    that are distributed unequally across the partition members").
    Consequence: each `prw_X_to_pr` reduces to `fun _ hW => hW.2`
    — kernel-pure derivable.  R18 (Option C) accepts the
    structural triviality: paper's `lem:prw` IS Lean-trivial under
    typed Definition `\label{def:warrant}`; the substantive paper
    content lives in (i) the `WarrantFeatureType` 9-constructor
    taxonomy and (ii) hypothesis (H) exclusion of
    `typeC3`/`typeC4b` (captured by `caseFormIsInternal`).  Each
    of the 6 case-bridges is now a derived theorem with proof
    body `fun _ hW => hW.2` — genuinely breaking anti-pattern #13
    (no Cat 3 conclusion-as-axiom remains for the partition-
    relativity chain).

    *Project now has ZERO project axioms* (only Lean kernel
    `propext` / `Quot.sound` appear in `VacuityCheck` outputs;
    `thm_impossibility` and its corollaries depend on NO axioms
    at all).

      prw_uniform_to_pr  (R18: axiom → theorem)
        ← `\label{lem:prw}` uniform case (paper lines 2092-2102);
          R18 signature: `A.warrantForm = uniform →
          A.warrantInternalToE → A.partitionRelative` (same as
          R16).  Proof body `fun _ hW => hW.2` — projects
          `featureExtractsAreEInternal` conjunct (= `partitionRelative`
          definitionally per paper line 2109-2112).
      prw_typeA_to_pr  (R18: axiom → theorem)
        ← `\label{lem:prw}` type-(a) case (paper lines 2127-2131);
          same R18 conversion.
      prw_typeB_no_ranking
        ← `\label{lem:prw}` type-(b) case (paper lines 2131-2134);
          single-step typed bridge `A.warrantForm = typeB →
          A.failsAdjudication`.  Derived theorem (v0.8.0 R5
          Issue 3 concretization).  Unchanged R18.
      prw_typeC1_to_pr  (R18: axiom → theorem)
        ← `\label{lem:prw}` type-(c.1) case (paper lines 2151-2185);
          same R18 conversion.  Paper's `R_{f^*}` ranking is
          ρ_W (the `ranker` field of the typed `Warrant` carrier)
          per paper `\label{def:warrant}`.
      prw_typeC2_recursive_to_pr  (R18: axiom → theorem)
        ← `\label{lem:prw}` type-(c.2) recursive case (paper lines
          2186-2196); same R18 conversion.
      prw_warrantInternalToE_excludes_typeC3
        ← `\label{lem:prw}` type-(c.3) exclusion (paper lines
          2189-2191); non-occurrence excluder `A.warrantInternalToE
          → A.warrantForm ≠ typeC3_external`.  Derived theorem;
          projects the `caseFormIsInternal.1` conjunct via `.1.1`
          on the new R18 decomposition `caseFormIsInternal ∧
          featureExtractsAreEInternal`.  Unchanged structurally.
      prw_typeC4a_internal_track_to_pr  (R18: axiom → theorem)
        ← `\label{lem:prw}` type-(c.4.a) internal track case (paper
          lines 2210-2218); same R18 conversion.
      prw_warrantInternalToE_excludes_typeC4b
        ← `\label{lem:prw}` type-(c.4.b) exclusion (paper lines
          2220-2237); non-occurrence excluder
          `A.warrantInternalToE → A.warrantForm ≠
          typeC4b_external_track`.  Derived theorem; projects
          `caseFormIsInternal.2` via `.1.2`.  Unchanged
          structurally.
      prw_contextual_to_pr  (R18: axiom → theorem)
        ← `\label{lem:prw}` contextual case (paper lines 2257-2270);
          same R18 conversion.

    All nine are now derived theorems.  Status `gapClosed`
    inputCategory `notInput` sub-type `notCat3` for the 6
    R18-converted entries (uniform / typeA / typeC1 /
    typeC2_recursive / typeC4a_internal_track / contextual).
    The 3 already-derived entries (typeB / excluders) retain
    their R5-Issue-3 `gapClosed notInput notCat3` classification.

    Cat 3 typed carriers / scope-condition bundles (encoded as
    Lean `structure` / `def` / `class` / `inductive`, NOT `axiom`
    — appears in source but not in `#print axioms`):

      Structures: ReverseDefinedConcept, ReverseDefinedWitness,
      AsymmetricEliminationVerdict, DiagnosticProfile,
      UseSeparability, MutuallyUnrankedPartition,
      Operationalisation, FaithfulP1, ArbitrationProcedure
      (v0.11.0 R14 refactored to carry `warrant : Warrant` +
      `warrantForm` + `exhibits` fields), Warrant (NEW v0.11.0
      R14 — paper `\label{def:warrant}` typed triple),
      CognitiveSystem, SessionalCognition, BridgingPrinciple,
      DiscriminatorRow.
      [v0.10.0 R9: `Weighting` carrier REMOVED — it was cosmetic
      (vacuous concretization of `partitionRelative` via constant-
      weight witness).  v0.11.0 R14: `Warrant` carrier ADDED —
      machine-verified non-vacuous via `test/VacuityCheck.lean`.]

      Inductive (added v0.8.0 R5): WarrantFeatureType.

  Per-axiom citations live in the corresponding `axiom` docstring
  in the source file.  Round-history (R1 cosmetic decomposition,
  R2 honest revert, R5 substantive paper-faithful decomposition,
  R7 attempted RHS concretization, R9 honest revert of R7 cosmetic
  concretization, R14 substantive paper-faithful Warrant typed-
  structure refactor per v6 §11 + §13 + §18) lives in
  `gap_*.attackHistory` fields inside
  `AsymmetricEliminativism.Ledger`.

  Per-theorem axiom dependency profile (verified by `#print
  axioms` below; v0.15.0 R22 DUAL FIX):

    * Depends on no axioms whatsoever:
        satisfiesP3_of_boolean, bridging_dsc_iff_sc,
        R1_fires_on_all_yes, R1_fires_on_yes_yes_weak,
        R1_does_not_fire_on_yes_weak_weak,
        R2_pattern_fires_on_yes_weak_weak,
        predictsEliminate_of_all_yes,
        predictsEliminate_of_yes_weak_weak_with_indep,
        not_R2_satisfied_without_indep,
        prw_typeB_no_ranking (R5 Issue 3 derived),
        prw_warrantInternalToE_excludes_typeC3,
        prw_warrantInternalToE_excludes_typeC4b.

    * Cat 3 axiom (reinstated v0.15.0 R22 per round-22 brief):
        prw_uniform_to_pr, prw_typeA_to_pr, prw_typeC1_to_pr,
        prw_typeC2_recursive_to_pr,
        prw_typeC4a_internal_track_to_pr, prw_contextual_to_pr.
      Each axiom carries the 6-case paper-cited per-case
      structural reduction (paper lines 2092-2270).

    * Cat 3 axiom (NEW v0.15.0 R22 per round-22 brief):
        ArbitrationProcedure.admissibleIn — paper-stipulated
        scope-condition predicate per paper `\label{thm:impossibility}`
        line 1999-2002 ("every arbitration procedure $A$
        admissible within $D$ for adjudicating operationalisations
        of $\C$").  Cat 3 `hypothesisPredicate` per v6 §3.4.2.

    * Depends on the 6 case-bridge axioms via
      `lem_prw_reduction` case-exhaustion:
        lem_prw_reduction, no_partition_independent_admissible_warrant,
        ensemble_methods_fail_P2.

    * Depends on the 6 case-bridge axioms + admissibleIn
      (via `thm_impossibility` proof body discharging
      admissibility from each P2 witness, then applying
      `lem_prw_reduction`):
        thm_impossibility, thm_impossibility_paper_form,
        impossibility_uniform_family.

    * Depends only on kernel axioms `[propext, Quot.sound]`
      (vacuity / consistency machine-verified):
        VacuityCheck.exists_non_partition_relative,
        VacuityCheck.not_forall_partition_relative,
        VacuityCheck.exists_partition_relative,
        VacuityCheck.case_bridge_uniform_unconditional_not_derivable,
        VacuityCheck.nonFactorisingA_not_warrantInternalToE,
        VacuityCheck.exists_uniform_not_warrantInternalToE,
        VacuityCheck.partitionRelativeA_satisfies_all_antecedents
          (R22 update: was factorisingA_*, now partitionRelativeA_*),
        VacuityCheck.r15_attack_requires_unprovable_antecedent,
        VacuityCheck.featureExtractsAreEInternal_does_not_imply_partitionRelative
          (R22 V7 separation),
        VacuityCheck.hW_dot_2_is_featureExtractsAreEInternal_not_partitionRelative
          (R22 V11.b R21 bypass type analysis),
        VacuityCheck.r21_bypass_blocked_by_separation
          (R22 V11.c R21 bypass blocked by witness),
        VacuityCheck.degenerateRankerA_not_partitionRelative
          (R22 V12 non-degeneracy non-triviality),
        VacuityCheck.partitionRelative_non_degeneracy_non_trivial
          (R22 V12 corollary).

    * Depends on `[propext, Quot.sound, admissibleIn]`
      (R22 NEW; tests consuming the admissibleIn axiom):
        VacuityCheck.r19_kill_destructuring_has_three_conjuncts,
        VacuityCheck.discourseHypothesisH_satisfiable_when_admissibleIn_empty,
        VacuityCheck.discourseHypothesisH_fails_when_admissibleIn_universal,
        VacuityCheck.discourseHypothesisH_is_implication_typecheck.

    * V8 (R22 update — applied to partitionRelativeA witness):
      depends on `[propext, prw_uniform_to_pr, Quot.sound]` etc.:
        VacuityCheck.prw_uniform_to_pr_applied_to_partitionRelativeA,
        VacuityCheck.lem_prw_reduction_applied_to_partitionRelativeA.

    * `partitionRelative_to_featureExtractsAreEInternal`
      (R22 V7 forward direction): does not depend on any axioms
      (`.1` projection).

  Any axiom outside the inventory above is a RED FLAG —
  investigate.

  *Honest scope statement (v0.15.0 R22).*  After R22 DUAL FIX,
  the project has 7 Cat 3 axioms (6 case-bridges + admissibleIn).
  This is REINSTATEMENT (not anti-pattern #13): under v0.13.0 R18,
  the case-bridges were derived theorems `fun _ hW => hW.2`
  because `partitionRelative` was literally `featureExtractsAreEInternal`;
  R21 hostile found that this trivialised the impossibility theorem.
  R22 Fix A adds the paper-stipulated non-degeneracy clause (paper
  line 2168-2170), making `partitionRelative` strictly stronger;
  the case-bridges now carry genuine paper-content per case (paper
  lines 2092-2270).

  What the typed Lean encoding captures of paper's substantive
  content (v0.15.0 R22):
   (a) the `WarrantFeatureType` 9-constructor taxonomy (Cat 3
       `carrier`, paper-cited per case);
   (b) the typed `Warrant` carrier structure (Cat 3 `carrier`,
       paper `\label{def:warrant}`);
   (c) the `caseFormIsInternal` hypothesis (H) tag-exclusion
       predicate (Cat 3 `hypothesisPredicate`, paper lines
       2188-2237);
   (d) the `featureExtractsAreEInternal` typed-structure
       factorisation predicate (Cat 3 `structuralEquation`, paper
       lines 2099-2107);
   (e) the `warrantInternalToE` composite predicate
       `caseFormIsInternal ∧ featureExtractsAreEInternal`
       (Cat 3 `structuralEquation`);
   (f) the `partitionRelative` STRENGTHENED predicate
       `featureExtractsAreEInternal ∧ non-degeneracy` per
       paper line 2168-2170 (R22 Fix A);
   (g) the `admissibleIn` Cat 3 hypothesisPredicate axiom (R22
       Fix B; paper line 1999-2002);
   (h) the `DiscourseHypothesisH` predicate restricted to
       `∀ A, admissibleIn A Op → warrantInternalToE` (R22
       Fix B refinement).

  *R22 substantive use of (H) in `thm_impossibility` proof.*
  The proof body extracts the P2 witness `⟨A, hAdm, hNotPR,
  hNotFails⟩` (4 bindings post-R22), applies `hH A hAdm` to
  obtain `warrantInternalToE`, then threads through
  `lem_prw_reduction` to obtain `partitionRelative ∨
  failsAdjudication` (each disjunct contradicting one P2
  conjunct).  Both R22 fixes are load-bearing:
  - Without Fix A's non-degeneracy strengthening, `(hH A hAdm).2`
    would project to `featureExtractsAreEInternal`, which is
    literally `partitionRelative` (R18 V7 Iff.rfl), yielding
    the R21 bypass.
  - Without Fix B's admissibility restriction, `DiscourseHypothesisH`
    is universally false; the impossibility theorem becomes
    vacuously true (false antecedent → anything).

  Usage:
    lake exe cache get
    lake env lean AsymmetricEliminativism/AxiomAudit.lean
-/

import AsymmetricEliminativism

-- Lean-kernel-only theorems.
#print axioms AsymmetricEliminativism.satisfiesP3_of_boolean
#print axioms AsymmetricEliminativism.bridging_dsc_iff_sc

-- Discriminator threshold-rule lemmas (kernel only).
#print axioms AsymmetricEliminativism.R1_fires_on_all_yes
#print axioms AsymmetricEliminativism.R1_fires_on_yes_yes_weak
#print axioms AsymmetricEliminativism.R1_does_not_fire_on_yes_weak_weak
#print axioms AsymmetricEliminativism.R2_pattern_fires_on_yes_weak_weak
#print axioms AsymmetricEliminativism.predictsEliminate_of_all_yes
#print axioms AsymmetricEliminativism.predictsEliminate_of_yes_weak_weak_with_indep
#print axioms AsymmetricEliminativism.not_R2_satisfied_without_indep

-- Nine derived theorems for Lemma `\label{lem:prw}` per-case
-- bridges (v0.8.0 R5 introduced the 9-case decomposition with 6
-- axioms + 3 derived theorems; v0.13.0 R18 Honest Acceptance
-- converted the 6 remaining axioms to derived theorems with proof
-- body `fun _ hW => hW.2` — the partition-relativity is recovered
-- by projecting `warrantInternalToE`'s `featureExtractsAreEInternal`
-- conjunct, which is definitionally `partitionRelative` per paper
-- line 2109-2112).  All nine expected to show "does not depend on
-- any axioms" post-R18.
#print axioms AsymmetricEliminativism.prw_uniform_to_pr
#print axioms AsymmetricEliminativism.prw_typeA_to_pr
#print axioms AsymmetricEliminativism.prw_typeB_no_ranking
#print axioms AsymmetricEliminativism.prw_typeC1_to_pr
#print axioms AsymmetricEliminativism.prw_typeC2_recursive_to_pr
#print axioms AsymmetricEliminativism.prw_warrantInternalToE_excludes_typeC3
#print axioms AsymmetricEliminativism.prw_typeC4a_internal_track_to_pr
#print axioms AsymmetricEliminativism.prw_warrantInternalToE_excludes_typeC4b
#print axioms AsymmetricEliminativism.prw_contextual_to_pr

-- Derived theorem (v0.8.0 R5: was axiom, now `theorem`; v0.13.0
-- R18: now depends on no axioms because all per-case bridges are
-- also derived theorems).
#print axioms AsymmetricEliminativism.lem_prw_reduction

-- Impossibility theorem and its corollaries.
#print axioms AsymmetricEliminativism.thm_impossibility
#print axioms AsymmetricEliminativism.thm_impossibility_paper_form
#print axioms AsymmetricEliminativism.no_partition_independent_admissible_warrant
#print axioms AsymmetricEliminativism.ensemble_methods_fail_P2
#print axioms AsymmetricEliminativism.impossibility_uniform_family

-- v0.11.0 R14 vacuity verification + v0.12.0 R16 consistency
-- verification + v0.13.0 R18 definitional-equivalence verification
-- + v0.14.0 R20 STRUCTURAL FIX verification.  Kernel-pure proofs
-- that:
--   - the substantive paper-faithful `partitionRelative` def is
--     non-vacuous (R14),
--   - the R15 attack vector is closed under R16 (R16),
--   - R18 Honest Acceptance is structurally correct (paper's
--     `lem:prw` reduction = paper's E-internality factorisation
--     per paper line 2109-2112) (R18),
--   - the R19 attack vector is closed under R20 by structural
--     restructure of SatisfiesP2 (R20).
-- All expected to show only `[propext, Quot.sound]` (or empty).
#print axioms AsymmetricEliminativism.VacuityCheck.exists_non_partition_relative
#print axioms AsymmetricEliminativism.VacuityCheck.not_forall_partition_relative
#print axioms AsymmetricEliminativism.VacuityCheck.exists_partition_relative
#print axioms AsymmetricEliminativism.VacuityCheck.case_bridge_uniform_unconditional_not_derivable
-- v0.12.0 R16 consistency verification (added round-16):
#print axioms AsymmetricEliminativism.VacuityCheck.nonFactorisingA_not_warrantInternalToE
#print axioms AsymmetricEliminativism.VacuityCheck.exists_uniform_not_warrantInternalToE
#print axioms AsymmetricEliminativism.VacuityCheck.r15_attack_requires_unprovable_antecedent
-- v0.15.0 R22 DUAL FIX tests — V5 positive instance updated to
-- use partitionRelativeA (with non-degenerate ranker):
#print axioms AsymmetricEliminativism.VacuityCheck.partitionRelativeA_satisfies_all_antecedents
-- v0.15.0 R22 V7 separation (R18 Iff.rfl removed; partitionRelative
-- now strictly stronger than featureExtractsAreEInternal):
#print axioms AsymmetricEliminativism.VacuityCheck.partitionRelative_to_featureExtractsAreEInternal
#print axioms AsymmetricEliminativism.VacuityCheck.featureExtractsAreEInternal_does_not_imply_partitionRelative
-- v0.15.0 R22 V8 case-bridge transparency (R22 updated witness):
#print axioms AsymmetricEliminativism.VacuityCheck.prw_uniform_to_pr_applied_to_partitionRelativeA
#print axioms AsymmetricEliminativism.VacuityCheck.lem_prw_reduction_applied_to_partitionRelativeA
-- v0.15.0 R22 STRUCTURAL FIX tests (3-conjunct SatisfiesP2):
#print axioms AsymmetricEliminativism.VacuityCheck.r19_kill_destructuring_has_three_conjuncts
-- v0.15.0 R22 V10 DiscourseHypothesisH non-vacuity:
#print axioms AsymmetricEliminativism.VacuityCheck.discourseHypothesisH_satisfiable_when_admissibleIn_empty
#print axioms AsymmetricEliminativism.VacuityCheck.discourseHypothesisH_fails_when_admissibleIn_universal
-- v0.15.0 R22 V11 R21 bypass type-incorrect:
#print axioms AsymmetricEliminativism.VacuityCheck.discourseHypothesisH_is_implication_typecheck
#print axioms AsymmetricEliminativism.VacuityCheck.hW_dot_2_is_featureExtractsAreEInternal_not_partitionRelative
#print axioms AsymmetricEliminativism.VacuityCheck.r21_bypass_blocked_by_separation
-- v0.15.0 R22 V12 non-degeneracy non-trivially constrains ranker:
#print axioms AsymmetricEliminativism.VacuityCheck.degenerateRankerA_not_partitionRelative
#print axioms AsymmetricEliminativism.VacuityCheck.partitionRelative_non_degeneracy_non_trivial
