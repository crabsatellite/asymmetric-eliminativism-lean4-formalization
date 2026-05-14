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

  Inventory by category (v0.12.0 R16 critical fix per round-16
  brief Option B; v0.11.0 R14 substantive paper-faithful Warrant
  typed-structure refactor per v6 §11 + §13 + §18; v0.8.0 R5
  substantive decomposition + v0.10.0 R9 baseline preserved where
  applicable; live counts: see `lake env lean
  AsymmetricEliminativism/Ledger.lean`):

    Cat 3 paper-novel atomic stipulations for Lemma `\label{lem:prw}`
    (Li 2026), the SIX `axiom` declarations in
    `AsymmetricEliminativism/Impossibility.lean`.  v0.8.0 R5
    Issue 3 concretization reduced 9 axioms → 6 axioms + 3 derived
    theorems; v0.11.0 R14 substantive paper-faithful refactor:
    axiom RHS conclusions consume the substantive
    `\label{def:warrant}` E-internality factorisation predicate
    via the new `Warrant` carrier; v0.12.0 R16 critical fix:
    each case-bridge axiom signature extended with a
    `warrantInternalToE` antecedent (paper `\label{lem:prw}`
    line 2116 "constructible from E alone" antecedent), resolving
    the R15-machine-verified inconsistency.  Machine-verified
    non-vacuous + consistent per `AsymmetricEliminativism/
    VacuityCheck.lean`:

      prw_uniform_to_pr
        ← `\label{lem:prw}` uniform case (paper lines 2092-2102);
          v0.12.0 R16 signature: `A.warrantForm = uniform →
          A.warrantInternalToE → A.partitionRelative` (the
          `warrantInternalToE` antecedent IS paper `\label{lem:prw}`
          line 2116 "constructible from E alone" antecedent, the
          typed-structure version being paper `\label{def:warrant}`
          E-internality clause lines 2099-2107).  R16 antecedent
          addition resolves the R15 inconsistency.  RHS still the
          substantive `\label{def:warrant}` factorisation predicate.
      prw_typeA_to_pr
        ← `\label{lem:prw}` type-(a) case (paper lines 2127-2131);
          same R16 signature (`warrantForm = X → warrantInternalToE
          → partitionRelative`).
      prw_typeB_no_ranking
        ← `\label{lem:prw}` type-(b) case (paper lines 2131-2134);
          single-step typed bridge `A.warrantForm = typeB →
          A.failsAdjudication`.  Derived theorem (v0.8.0 R5
          Issue 3 concretization).
      prw_typeC1_to_pr
        ← `\label{lem:prw}` type-(c.1) case (paper lines 2151-2185);
          same R16 signature.  Paper's `R_{f^*}` ranking is now
          ρ_W (the `ranker` field of the typed `Warrant` carrier)
          per paper `\label{def:warrant}`.
      prw_typeC2_recursive_to_pr
        ← `\label{lem:prw}` type-(c.2) recursive case (paper lines
          2186-2196); same R16 signature.
      prw_warrantInternalToE_excludes_typeC3
        ← `\label{lem:prw}` type-(c.3) exclusion (paper lines
          2189-2191); non-occurrence excluder `A.warrantInternalToE
          → A.warrantForm ≠ typeC3_external`.  Derived theorem;
          under v0.12.0 R16 projects the tag-exclusion conjunct
          via `.1.1` (the first conjunct of `warrantInternalToE`).
      prw_typeC4a_internal_track_to_pr
        ← `\label{lem:prw}` type-(c.4.a) internal track case (paper
          lines 2210-2218); same R16 signature.
      prw_warrantInternalToE_excludes_typeC4b
        ← `\label{lem:prw}` type-(c.4.b) exclusion (paper lines
          2220-2237); non-occurrence excluder `A.warrantInternalToE
          → A.warrantForm ≠ typeC4b_external_track`.  Derived
          theorem; under v0.12.0 R16 projects the tag-exclusion
          conjunct via `.1.2` (the first conjunct of
          `warrantInternalToE`).
      prw_contextual_to_pr
        ← `\label{lem:prw}` contextual case (paper lines 2257-2270);
          same R16 signature.

    All nine carry sub-type Cat 3 `structuralEquation` (v6 §3.4.3),
    status `gapDefinitional` (v6 §1.1) — paper-stipulated
    definitional reduction on paper-novel carriers.  The 6 axioms
    have substantive paper-faithful RHS (`A.partitionRelative`
    unfolds to the `\label{def:warrant}` E-internality
    factorisation predicate) per v0.11.0 R14; v0.12.0 R16
    extended each axiom signature with the
    `warrantInternalToE` antecedent (paper `\label{lem:prw}`
    line 2116 "constructible from E alone" antecedent), resolving
    the R15-machine-verified inconsistency.

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
  axioms` below; post-v0.8.0 R5 substantive decomposition):

    * Depends on no axioms whatsoever (does not even use
      `propext` / `Classical.choice` / `Quot.sound`):
        satisfiesP3_of_boolean, bridging_dsc_iff_sc,
        R1_fires_on_all_yes, R1_fires_on_yes_yes_weak,
        R1_does_not_fire_on_yes_weak_weak,
        R2_pattern_fires_on_yes_weak_weak,
        predictsEliminate_of_all_yes,
        predictsEliminate_of_yes_weak_weak_with_indep,
        not_R2_satisfied_without_indep.

    * Depends on the SIX Cat 3 atomic axioms (paper-faithful
      `\label{lem:prw}` decomposition; v0.8.0 R5 Issue 3
      concretized 3 of the original 9 atoms to derived theorems):
        lem_prw_reduction (now a derived `theorem`),
        thm_impossibility, thm_impossibility_paper_form,
        no_partition_independent_admissible_warrant,
        ensemble_methods_fail_P2, impossibility_uniform_family.

    * Now derived theorems by `decide` on `WarrantFeatureType`
      decidable-equality (Issue 3 concretization of the
      ArbitrationProcedure bare-Prop fields `warrantInternalToE`
      and `failsAdjudication`):
        prw_typeB_no_ranking,
        prw_warrantInternalToE_excludes_typeC3,
        prw_warrantInternalToE_excludes_typeC4b.

  Any axiom outside the inventory above is a RED FLAG —
  investigate.

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

-- Nine Cat 3 atomic axioms for Lemma `\label{lem:prw}` (v0.8.0 R5
-- substantive paper-faithful decomposition; replaces v0.6.0 R2
-- single-axiom encoding).
#print axioms AsymmetricEliminativism.prw_uniform_to_pr
#print axioms AsymmetricEliminativism.prw_typeA_to_pr
#print axioms AsymmetricEliminativism.prw_typeB_no_ranking
#print axioms AsymmetricEliminativism.prw_typeC1_to_pr
#print axioms AsymmetricEliminativism.prw_typeC2_recursive_to_pr
#print axioms AsymmetricEliminativism.prw_warrantInternalToE_excludes_typeC3
#print axioms AsymmetricEliminativism.prw_typeC4a_internal_track_to_pr
#print axioms AsymmetricEliminativism.prw_warrantInternalToE_excludes_typeC4b
#print axioms AsymmetricEliminativism.prw_contextual_to_pr

-- Derived theorem (v0.8.0 R5: was axiom, now `theorem`).
#print axioms AsymmetricEliminativism.lem_prw_reduction

-- Impossibility theorem and its corollaries.
#print axioms AsymmetricEliminativism.thm_impossibility
#print axioms AsymmetricEliminativism.thm_impossibility_paper_form
#print axioms AsymmetricEliminativism.no_partition_independent_admissible_warrant
#print axioms AsymmetricEliminativism.ensemble_methods_fail_P2
#print axioms AsymmetricEliminativism.impossibility_uniform_family

-- v0.11.0 R14 vacuity verification + v0.12.0 R16 consistency
-- verification — kernel-pure proofs that the new substantive
-- paper-faithful `partitionRelative` def is non-vacuous AND that
-- the R15 attack vector is closed under R16.  All eight expected
-- to show only `[propext, Quot.sound]` (or less).
#print axioms AsymmetricEliminativism.VacuityCheck.exists_non_partition_relative
#print axioms AsymmetricEliminativism.VacuityCheck.not_forall_partition_relative
#print axioms AsymmetricEliminativism.VacuityCheck.exists_partition_relative
#print axioms AsymmetricEliminativism.VacuityCheck.case_bridge_uniform_unconditional_not_derivable
-- v0.12.0 R16 consistency verification (added round-16):
#print axioms AsymmetricEliminativism.VacuityCheck.nonFactorisingA_not_warrantInternalToE
#print axioms AsymmetricEliminativism.VacuityCheck.exists_uniform_not_warrantInternalToE
#print axioms AsymmetricEliminativism.VacuityCheck.factorisingA_satisfies_all_antecedents
#print axioms AsymmetricEliminativism.VacuityCheck.r15_attack_requires_unprovable_antecedent
