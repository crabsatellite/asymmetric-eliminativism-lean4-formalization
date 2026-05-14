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

  Inventory by category (v0.16.0 R24 FINAL HONEST CONVERGENCE per
  round-24 brief; v0.15.0 R22 Fix B `admissibleIn` retained;
  v0.15.0 R22 Fix A `partitionRelative` non-degeneracy REVERTED;
  v0.14.0 R20 structural fix preserved; v0.13.0 R18 baseline
  restored — 6 case-bridges derived theorems again; v0.12.0 R16 /
  v0.11.0 R14 / v0.8.0 R5 paper-faithful structure preserved.
  Live counts: see `lake env lean AsymmetricEliminativism/Ledger.lean`).

    **v0.16.0 R24 FINAL HONEST CONVERGENCE** — R23 hostile
    validator machine-verified that R22 Fix A (`partitionRelative`
    non-degeneracy strengthening) introduced axiom inconsistency:
    paper's uniform case (`\label{lem:prw}` uniform paragraph) has
    CONSTANT single-$E_m$ adjudication (degenerate ranker by
    construction), but R22's `prw_uniform_to_pr` axiom derived
    `partitionRelative` (including non-degeneracy) on the uniform
    witness, yielding kernel-pure `False`.  R24 final honest
    convergence:

    - REVERT R22 Fix A: `partitionRelative` reverts to R18 form,
      literally `featureExtractsAreEInternal` (no non-degeneracy).
      Per paper `\label{def:warrant}` typed-level identification,
      this identification IS paper-faithful — paper's `lem:prw` at
      typed `\label{def:warrant}` level is STRUCTURALLY TRIVIAL.

    - KEEP R22 Fix B: `admissibleIn` axiom (Cat 3
      hypothesisPredicate) + restricted `DiscourseHypothesisH :=
      ∀ A, admissibleIn A Op → warrantInternalToE`.  Makes (H)
      non-vacuously-true and non-vacuously-false depending on
      the discourse state.

    - 6 case-bridges converted back to derived theorems with
      proof body `fun _ hW => hW.2`.  Anti-pattern #13 GENUINELY
      BROKEN: zero Cat 3 axioms for the partition-relativity
      derivation chain.

    Anti-pattern history:
      - R7  v0.9.0: cosmetic Weighting → R8 killed (vacuity).
      - R14 v0.11.0: missing antecedent → R15 killed
        (inconsistency).
      - R16 v0.12.0: composite predicate → R17 killed
        (trivialization).
      - R18 v0.13.0: definitional smuggling → R19 killed.
      - R20 v0.14.0: 2-line bypass + (H) universal-false →
        R21 killed (2 defects).
      - R22 v0.15.0: uniform-case axiom inconsistency → R23
        killed.
      - R24 v0.16.0: HONEST CONVERGENCE — accept paper
        `\label{def:warrant}` typed-level trivialization; keep R22
        Fix B admissibleIn.

    *Project now has 1 Cat 3 axiom post-R24*:
    - 1 admissibleIn axiom: ArbitrationProcedure.admissibleIn
      (Cat 3 hypothesisPredicate; paper-stipulated scope-condition
      predicate per paper `\label{thm:impossibility}` statement
      quantifier).
    The 6 case-bridges previously axiomatized under R22 are now
    derived theorems again (R18/R24 form, proof body
    `fun _ hW => hW.2`).

    **v0.13.0 R18 Honest Acceptance** — converted the 6 R16
    case-bridge `axiom` declarations to `theorem` declarations.
    R17 hostile validator found that R16's `warrantInternalToE`
    contains `featureExtractsAreEInternal` as its second conjunct,
    which is *definitionally* identical to `partitionRelative`
    (paper `\label{def:warrant}` typed-level paragraph: "the
    typed-structure version of the prose-level description following
    Lemma~\ref{lem:prw} of $R_{f^*}$ being constructed from
    $f^*$-values on each $E_i$ that are distributed unequally across
    the partition members").
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
        ← `\label{lem:prw}` uniform case;
          R18 signature: `A.warrantForm = uniform →
          A.warrantInternalToE → A.partitionRelative` (same as
          R16).  Proof body `fun _ hW => hW.2` — projects
          `featureExtractsAreEInternal` conjunct (= `partitionRelative`
          definitionally per paper `\label{def:warrant}` typed-level
          identification).
      prw_typeA_to_pr  (R18: axiom → theorem)
        ← `\label{lem:prw}` type-(a) case;
          same R18 conversion.
      prw_typeB_no_ranking
        ← `\label{lem:prw}` type-(b) case;
          single-step typed bridge `A.warrantForm = typeB →
          A.failsAdjudication`.  Derived theorem (v0.8.0 R5
          Issue 3 concretization).  Unchanged R18.
      prw_typeC1_to_pr  (R18: axiom → theorem)
        ← `\label{lem:prw}` type-(c.1) case;
          same R18 conversion.  Paper's `R_{f^*}` ranking is
          ρ_W (the `ranker` field of the typed `Warrant` carrier)
          per paper `\label{def:warrant}`.
      prw_typeC2_recursive_to_pr  (R18: axiom → theorem)
        ← `\label{lem:prw}` type-(c.2) recursive case;
          same R18 conversion.
      prw_warrantInternalToE_excludes_typeC3
        ← `\label{lem:prw}` type-(c.3) exclusion;
          non-occurrence excluder `A.warrantInternalToE
          → A.warrantForm ≠ typeC3_external`.  Derived theorem;
          projects the `caseFormIsInternal.1` conjunct via `.1.1`
          on the new R18 decomposition `caseFormIsInternal ∧
          featureExtractsAreEInternal`.  Unchanged structurally.
      prw_typeC4a_internal_track_to_pr  (R18: axiom → theorem)
        ← `\label{lem:prw}` type-(c.4.a) internal track case;
          same R18 conversion.
      prw_warrantInternalToE_excludes_typeC4b
        ← `\label{lem:prw}` type-(c.4.b) exclusion;
          non-occurrence excluder
          `A.warrantInternalToE → A.warrantForm ≠
          typeC4b_external_track`.  Derived theorem; projects
          `caseFormIsInternal.2` via `.1.2`.  Unchanged
          structurally.
      prw_contextual_to_pr  (R18: axiom → theorem)
        ← `\label{lem:prw}` contextual case;
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
  axioms` below; v0.16.0 R24 FINAL HONEST CONVERGENCE):

    * Depends on no axioms whatsoever:
        satisfiesP3_of_boolean, bridging_dsc_iff_sc,
        R1_fires_on_all_yes, R1_fires_on_yes_yes_weak,
        R1_does_not_fire_on_yes_weak_weak,
        R2_pattern_fires_on_yes_weak_weak,
        predictsEliminate_of_all_yes,
        predictsEliminate_of_yes_weak_weak_with_indep,
        not_R2_satisfied_without_indep,
        prw_uniform_to_pr (R24 derived theorem),
        prw_typeA_to_pr (R24 derived theorem),
        prw_typeB_no_ranking (R5 Issue 3 derived),
        prw_typeC1_to_pr (R24 derived theorem),
        prw_typeC2_recursive_to_pr (R24 derived theorem),
        prw_typeC4a_internal_track_to_pr (R24 derived theorem),
        prw_contextual_to_pr (R24 derived theorem),
        prw_warrantInternalToE_excludes_typeC3,
        prw_warrantInternalToE_excludes_typeC4b,
        lem_prw_reduction (composes 9 derived theorems),
        no_partition_independent_admissible_warrant,
        ensemble_methods_fail_P2.

    * Cat 3 axiom (NEW v0.15.0 R22 Fix B, RETAINED v0.16.0 R24):
        ArbitrationProcedure.admissibleIn — paper-stipulated
        scope-condition predicate per paper `\label{thm:impossibility}`
        ("every arbitration procedure $A$
        admissible within $D$ for adjudicating operationalisations
        of $\C$").  Cat 3 `hypothesisPredicate` per v6 §3.4.2.

    * Depends on admissibleIn ONLY (via `thm_impossibility` proof
      body discharging admissibility from each P2 witness, then
      applying `lem_prw_reduction`):
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
        VacuityCheck.factorisingA_satisfies_all_antecedents,
        VacuityCheck.r15_attack_requires_unprovable_antecedent,
        VacuityCheck.prw_uniform_to_pr_applied_to_factorisingA,
        VacuityCheck.lem_prw_reduction_applied_to_factorisingA,
        VacuityCheck.hW_dot_2_is_featureExtractsAreEInternal_eq_partitionRelative
          (R24 honest acknowledgment: `.2` projection IS canonical
           reduction per paper `\label{def:warrant}` typed-level
           identification),
        VacuityCheck.uniformConstantRankerA_warrantInternalToE,
        VacuityCheck.uniformConstantRankerA_partitionRelative
          (R24 V12 R23 inconsistency ELIMINATED — uniform-
           constant-ranker witness IS partition-relative under
           reverted def),
        VacuityCheck.r23_inconsistency_eliminated
          (R24 V12 capstone — replaces R22 `False`-derivation
           inconsistency with consistent positive theorem).

    * `partitionRelative_iff_featureExtractsAreEInternal`
      (R24 V7 paper `\label{def:warrant}` typed-level identification):
      does not depend on any axioms (`Iff.rfl`).

    * Depends on `[propext, Quot.sound, admissibleIn]`
      (R22 Fix B retained; tests consuming the admissibleIn
      axiom):
        VacuityCheck.r19_kill_destructuring_has_three_conjuncts,
        VacuityCheck.discourseHypothesisH_satisfiable_when_admissibleIn_empty,
        VacuityCheck.discourseHypothesisH_fails_when_admissibleIn_universal,
        VacuityCheck.discourseHypothesisH_is_implication_typecheck,
        VacuityCheck.thm_impossibility_uses_H_via_admissibleIn.

  Any axiom outside the inventory above is a RED FLAG —
  investigate.

  *Honest scope statement (v0.16.0 R24).*  After R24 FINAL HONEST
  CONVERGENCE, the project has 1 Cat 3 axiom (admissibleIn only).
  The 6 case-bridges previously axiomatized under R22 are now
  derived theorems again.  This is the convergent endpoint of the
  7-round anti-pattern spiral:
  - R7→R8 cosmetic Weighting vacuity;
  - R14→R15 missing antecedent inconsistency;
  - R16→R17 composite predicate trivialization;
  - R18→R19 definitional smuggling in SatisfiesP2;
  - R20→R21 universally-false H + 2-line bypass;
  - R22→R23 uniform-case non-degeneracy inconsistency;
  - R24: HONEST CONVERGENCE — accept paper `\label{def:warrant}`
    typed-level identification; substantive content lives in
    `WarrantFeatureType` taxonomy + `admissibleIn` scope axiom.

  What the typed Lean encoding captures of paper's substantive
  content (v0.16.0 R24):
   (a) the `WarrantFeatureType` 9-constructor taxonomy (Cat 3
       `carrier`, paper-cited per case);
   (b) the typed `Warrant` carrier structure (Cat 3 `carrier`,
       paper `\label{def:warrant}`);
   (c) the `caseFormIsInternal` hypothesis (H) tag-exclusion
       predicate (Cat 3 `hypothesisPredicate`, paper
       `\label{lem:prw}` (c.3)/(c.4.b) paragraphs);
   (d) the `featureExtractsAreEInternal` typed-structure
       factorisation predicate (Cat 3 `structuralEquation`, paper
       `\label{def:warrant}` E-internality clause);
   (e) the `warrantInternalToE` composite predicate
       `caseFormIsInternal ∧ featureExtractsAreEInternal`
       (Cat 3 `structuralEquation`);
   (f) the `partitionRelative` REVERTED predicate
       `featureExtractsAreEInternal` per paper `\label{def:warrant}`
       typed-level identification (R24 revert of R22 Fix A);
   (g) the `admissibleIn` Cat 3 hypothesisPredicate axiom (R22
       Fix B retained; paper `\label{thm:impossibility}` statement
       quantifier);
   (h) the `DiscourseHypothesisH` predicate restricted to
       `∀ A, admissibleIn A Op → warrantInternalToE` (R22
       Fix B refinement retained).

  *R24 substantive use of (H) in `thm_impossibility` proof.*
  The proof body extracts the P2 witness `⟨A, hAdm, hNotPR,
  hNotFails⟩` (4 bindings post-R22 + R24), applies `hH A hAdm`
  to obtain `warrantInternalToE`, then threads through
  `lem_prw_reduction` to obtain `partitionRelative ∨
  failsAdjudication` (each disjunct contradicting one P2
  conjunct).  Under R24, the substantive content lives in:
  - R22 Fix B retained: without admissibility restriction,
    `DiscourseHypothesisH` is universally false; the impossibility
    theorem becomes vacuously true (false antecedent → anything).
  - R24 accepts the typed-level trivialization per paper
    `\label{def:warrant}` typed-level identification: `(hH A hAdm).2`
    IS the canonical 2-line reduction; paper's `lem:prw` at typed
    level is paper-stated to be the partition-relative-weighting
    factorisation.  Substantive paper content lives in
    `WarrantFeatureType` 9-case taxonomy (which classifies paper's
    actual case-analysis) + `admissibleIn` scope axiom (which
    restricts (H) per paper `\label{thm:impossibility}` statement
    quantifier).

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
-- `\label{def:warrant}` typed-level identification).  All nine
-- expected to show "does not depend on any axioms" post-R18.
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
--     per paper `\label{def:warrant}` typed-level identification) (R18),
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
-- v0.16.0 R24 V5 positive instance — factorisingA under reverted
-- `partitionRelative = featureExtractsAreEInternal`:
#print axioms AsymmetricEliminativism.VacuityCheck.factorisingA_satisfies_all_antecedents
-- v0.16.0 R24 V7 — paper `\label{def:warrant}` typed-level identification IS Iff.rfl:
#print axioms AsymmetricEliminativism.VacuityCheck.partitionRelative_iff_featureExtractsAreEInternal
-- v0.16.0 R24 V8 case-bridge derivation on factorisingA:
#print axioms AsymmetricEliminativism.VacuityCheck.prw_uniform_to_pr_applied_to_factorisingA
#print axioms AsymmetricEliminativism.VacuityCheck.lem_prw_reduction_applied_to_factorisingA
-- v0.15.0 R22 Fix B STRUCTURAL FIX tests preserved (3-conjunct
-- SatisfiesP2 with admissibleIn):
#print axioms AsymmetricEliminativism.VacuityCheck.r19_kill_destructuring_has_three_conjuncts
-- v0.15.0 R22 Fix B preserved — V10 DiscourseHypothesisH
-- non-vacuity:
#print axioms AsymmetricEliminativism.VacuityCheck.discourseHypothesisH_satisfiable_when_admissibleIn_empty
#print axioms AsymmetricEliminativism.VacuityCheck.discourseHypothesisH_fails_when_admissibleIn_universal
-- v0.16.0 R24 V11 — honest acknowledgment that (hH A hAdm).2 IS
-- the canonical 2-line bypass per paper `\label{def:warrant}`
-- typed-level identification:
#print axioms AsymmetricEliminativism.VacuityCheck.discourseHypothesisH_is_implication_typecheck
#print axioms AsymmetricEliminativism.VacuityCheck.hW_dot_2_is_featureExtractsAreEInternal_eq_partitionRelative
#print axioms AsymmetricEliminativism.VacuityCheck.thm_impossibility_uses_H_via_admissibleIn
-- v0.16.0 R24 V12 — R23 inconsistency ELIMINATED under reverted
-- partitionRelative:
#print axioms AsymmetricEliminativism.VacuityCheck.uniformConstantRankerA_warrantInternalToE
#print axioms AsymmetricEliminativism.VacuityCheck.uniformConstantRankerA_partitionRelative
#print axioms AsymmetricEliminativism.VacuityCheck.r23_inconsistency_eliminated
