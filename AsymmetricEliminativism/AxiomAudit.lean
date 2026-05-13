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

  Inventory by category (v0.5.0 post-R1 decomposition; live counts:
  see `lake env lean AsymmetricEliminativism/Ledger.lean`):

    Cat 3 atomic stipulations for Lemma `\label{lem:prw}`
    (Li 2026), all `axiom` declarations in
    `AsymmetricEliminativism/Impossibility.lean`:

      prw_uniform_warrant_partitionRelative
        ← `\label{lem:prw}` proof body, uniform-case paragraph;
          structuralEquation; constant assignment to `{i, j}` ⇒
          single-`E_m` privileging ⇒ partition-relative.

      prw_type_a_feature_partitionRelative
        ← `\label{lem:prw}` proof body, `Sub-claim:
          No-arbitration for \E-internal ranking principles`
          type-(a); structuralEquation; feature `f ∈ E_m` ⇒
          single-`E_m` privileging ⇒ partition-relative.

      prw_type_b_feature_partitionRelative
        ← `\label{lem:prw}` proof body, type-(b);
          structuralEquation; symmetric feature ⇒ no ranking ⇒
          P2-failure equivalent to partition-relative.

      prw_partition_internality_of_structural_stipulations
        ← `\label{lem:prw}` proof body, `Sub-claim
          (Partition-Internality of \E-Internal Structural
          Stipulations)`; structuralEquation;
          `R_{f*}`-routing ⇒ partition-relative weighting.

      prw_E_internal_warrant_case_exhaustion
        ← `\label{lem:prw}` proof body, trichotomy +
          recursion-termination paragraph; hypothesisPredicate;
          every `\E`-internal warrant case-reduces to one of
          (uniform / type-(a) / type-(b) /
          type-(c) partition-symmetric).

    Cat 3 paper-articulated scope-condition Prop axiom (v0.5.0 R2):

      SubstrateIndependenceTripleUse : Prop
        ← `\S\ref{sec:discriminator}` `Acknowledgement` paragraph
          (substrate-independence premise doing triple duty for
          E2b transferability + D1 Route 2 +
          impossibility-theorem-application).  `hypothesisPredicate`
          sub-type; not currently consumed by any derived theorem
          (paper-articulated for future downstream wiring).

    Cat 3 typed carriers / scope-condition bundles (encoded as
    Lean `structure` / `def` / `class`, NOT `axiom` — appears in
    source but not in `#print axioms`):

      Structures: ReverseDefinedConcept, ReverseDefinedWitness,
      AsymmetricEliminationVerdict, DiagnosticProfile,
      UseSeparability, MutuallyUnrankedPartition,
      Operationalisation, FaithfulP1, ArbitrationProcedure,
      CognitiveSystem, SessionalCognition, BridgingPrinciple,
      DiscriminatorRow.

      Case-tag `def`s on `ArbitrationProcedure`:
      isUniformWarrant, usesTypeAFeature, usesTypeBFeature,
      usesTypeCStructuralProperty.

  Per-axiom citations live in the corresponding `axiom` docstring
  in the source file.  Round-history (prior retracted citations +
  atomic refactor steps + R1 decomposition + R2 reclassification)
  lives in `gap_*.attackHistory` fields inside
  `AsymmetricEliminativism.Ledger`.

  Per-theorem axiom dependency profile (verified by `#print
  axioms` below; post-v0.5.0 R1 decomposition):

    * Depends on no axioms whatsoever (does not even use
      `propext` / `Classical.choice` / `Quot.sound`):
        satisfiesP3_of_boolean, bridging_dsc_iff_sc,
        R1_fires_on_all_yes, R1_fires_on_yes_yes_weak,
        R1_does_not_fire_on_yes_weak_weak,
        R2_pattern_fires_on_yes_weak_weak,
        predictsEliminate_of_all_yes,
        predictsEliminate_of_yes_weak_weak_with_indep,
        not_R2_satisfied_without_indep.

    * Cat 3 atomic stipulations for Lemma `\label{lem:prw}`
      (5 atoms; v0.5.0 R1):
        thm_impossibility, thm_impossibility_paper_form,
        lem_prw_reduction (now derived theorem),
        no_partition_independent_admissible_warrant,
        ensemble_methods_fail_P2, impossibility_uniform_family.

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

-- Cat 3 atomic stipulations for Lemma `\label{lem:prw}`
-- (v0.5.0 R1 decomposition).
#print axioms AsymmetricEliminativism.prw_uniform_warrant_partitionRelative
#print axioms AsymmetricEliminativism.prw_type_a_feature_partitionRelative
#print axioms AsymmetricEliminativism.prw_type_b_feature_partitionRelative
#print axioms AsymmetricEliminativism.prw_partition_internality_of_structural_stipulations
#print axioms AsymmetricEliminativism.prw_E_internal_warrant_case_exhaustion

-- Derived theorem `lem_prw_reduction` (v0.5.0 axiom→theorem).
#print axioms AsymmetricEliminativism.lem_prw_reduction

-- Cat 3 paper-articulated scope-condition Prop axiom
-- (v0.5.0 R2 reclassification gapBlocked→gapOpen).
#print axioms AsymmetricEliminativism.SubstrateIndependenceTripleUse

-- Impossibility theorem and its corollaries.
#print axioms AsymmetricEliminativism.thm_impossibility
#print axioms AsymmetricEliminativism.thm_impossibility_paper_form
#print axioms AsymmetricEliminativism.no_partition_independent_admissible_warrant
#print axioms AsymmetricEliminativism.ensemble_methods_fail_P2
#print axioms AsymmetricEliminativism.impossibility_uniform_family
