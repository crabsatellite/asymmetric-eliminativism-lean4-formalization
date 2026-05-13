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
            atomic defining equation (encoded as `axiom`).  Cited
            only to Li 2026 `\label{...}` claims.

  Plus the Lean kernel axioms (`propext`, `Classical.choice`,
  `Quot.sound`), provided by Lean / Mathlib core.

  Constraints.  No (E) custom-scaffolding axioms (naked constants,
  abstract-type-inhabitation stipulations).  No composite axioms
  bundling multiple independent paper claims.

  Inventory by category (live counts: see `lake env lean
  AsymmetricEliminativism/Ledger.lean`):

    Cat 3 atomic axiom (Li 2026):
      lem_prw_reduction
        ← Lemma `\label{lem:prw}` Partition-Relative-Weighting
          Reduction; carries the load-bearing structural
          consequence used by `thm_impossibility`.

    Cat 3 typed carriers (Lean `structure` / `def` / `class`, NOT
    `axiom` — appears in source but not in `#print axioms`):
      ReverseDefinedConcept, ReverseDefinedWitness,
      AsymmetricEliminationVerdict, DiagnosticProfile,
      UseSeparability, MutuallyUnrankedPartition,
      Operationalisation, FaithfulP1, ArbitrationProcedure,
      CognitiveSystem, SessionalCognition, BridgingPrinciple,
      DiscriminatorRow.

  Per-axiom citations live in the corresponding `axiom` docstring
  in the source file.  Round-history (prior retracted citations +
  atomic refactor steps) lives in `gap_*.attackHistory` fields
  inside `AsymmetricEliminativism.Ledger`.

  Per-theorem axiom dependency profile (verified by `#print
  axioms` below):

    * Lean kernel only (`propext`, `Classical.choice`,
      `Quot.sound`):
        satisfiesP3_of_boolean, bridging_dsc_iff_sc,
        R1_fires_on_all_yes, R1_fires_on_yes_yes_weak,
        R1_does_not_fire_on_yes_weak_weak,
        R2_pattern_fires_on_yes_weak_weak,
        predictsEliminate_of_all_yes,
        predictsEliminate_of_yes_weak_weak_with_indep,
        not_R2_satisfied_without_indep.

    * Lean kernel + Cat 3 atomic `lem_prw_reduction`:
        thm_impossibility, no_partition_independent_admissible_warrant,
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

-- Impossibility theorem and its corollaries.
#print axioms AsymmetricEliminativism.thm_impossibility
#print axioms AsymmetricEliminativism.no_partition_independent_admissible_warrant
#print axioms AsymmetricEliminativism.ensemble_methods_fail_P2
#print axioms AsymmetricEliminativism.impossibility_uniform_family
