# Asymmetric Eliminativism — Lean 4 Formalization

Formal verification of the structural mathematics of

> Li, Alex Chengyu. *Asymmetric Eliminativism: A Diagnostic Framework
> for Reverse-Defined Concepts, with the LLM Consciousness Debate as
> Anchor Case, a Methodological Apparatus, a Replacement Vocabulary,
> and Applications to AI Governance.* 2026.

**Paper:**
- SSRN abstract id [6723220](https://papers.ssrn.com/sol3/papers.cfm?abstract_id=6723220)
- Zenodo DOI: [10.5281/zenodo.20041562](https://doi.org/10.5281/zenodo.20041562)

## Status

The formalization machine-checks the **structural mathematics** of
the paper inside Lean 4 + Mathlib.  Every paper-internal deduction
is a genuine Lean 4 theorem — **zero `sorry`**.

This paper is primarily a diagnostic framework in the philosophy of
mind / philosophy of science: it specifies *what makes a concept
reverse-defined*, *when asymmetric elimination is warranted*, and
*how to construct a replacement vocabulary*.  The substantive
philosophical content (the LLM-consciousness application, the
historical calibration narrative, the AI-governance applications,
the testimony-protocol epistemology) is the paper's contribution
and is not — and need not be — Lean-formalised.

What IS Lean-formalised is the structural skeleton on which those
arguments rest:

* The typed apparatus for **reverse-defined concepts**, **mutually
  unranked partitions**, **operationalisation individuation**, and
  **operationalisation properties P1 / P2 / P3**
  (`AsymmetricEliminativism/Basic.lean`).
* The **discriminator** rules (R1) and (R2) and their structural
  consequences (`AsymmetricEliminativism/Diagnostic.lean`).
* The **impossibility theorem** `\label{thm:impossibility}` and its
  load-bearing Lemma `\label{lem:prw}`
  (`AsymmetricEliminativism/Impossibility.lean`).
* The **replacement vocabulary** structural axes (DSC) and SC
  commitments, plus the **bridging principle**
  (`AsymmetricEliminativism/Basic.lean`).

All axioms are atomic minimal units, classified as one of:

* **Cat 3** — paper-novel atomic defining equations from Li 2026.
  The Cat 3 atomic axioms are the six per-case warrant-form
  case-bridges from Lemma `\label{lem:prw}`'s proof body:
  `prw_uniform_to_pr`, `prw_typeA_to_pr`, `prw_typeC1_to_pr`,
  `prw_typeC2_recursive_to_pr`, `prw_typeC4a_internal_track_to_pr`,
  `prw_contextual_to_pr`.  Each is a paper-stipulated single-step
  typed-bridge reduction from a `WarrantFeatureType` 9-constructor
  inductive case to the `A.partitionRelative` field on the paper-
  novel `ArbitrationProcedure` carrier (sub-type
  `structuralEquation` per v6 §3.4.3).  The downstream
  `lem_prw_reduction` is a derived `theorem` (not an axiom),
  obtained by case-exhaustion `match` on `A.warrantForm :
  WarrantFeatureType` composing the six case-bridge atoms with the
  three derived theorems for the remaining constructors
  (`prw_typeB_no_ranking`, `prw_warrantInternalToE_excludes_typeC3`,
  `prw_warrantInternalToE_excludes_typeC4b`).

  Iteration history.  v0.6.0 R2 first axiomatised the lemma as a
  single Cat 3 `workingAssumption`, after honest revert of the
  v0.5.0 R1 cosmetic four-case-tag-`Prop := True` decomposition.
  v0.8.0 R5 introduced the paper-faithful `WarrantFeatureType`
  inductive + 9 per-case atoms and converted `lem_prw_reduction`
  from axiom to derived theorem.  v0.9.0 R7 attempted RHS
  concretization of `partitionRelative` via a new `Weighting`
  carrier; v0.10.0 R9 honestly reverted that concretization after
  the Round 8 hostile validator machine-verified it VACUOUS
  (discharged by constant-weight witness for every procedure).
  v0.10.0 R9 restored the v0.8.0 R5 bare-Prop RHS, retaining the
  paper-faithful taxonomy + case-exhaustion structure.
* **Lean kernel** — `propext`, `Classical.choice`, `Quot.sound`.

The project has zero Cat 1 axioms (no Mathlib-derivability
claims pending discharge) and zero Cat 2 axioms (no external
textbook citations).

Most paper-novel content (the typed carriers for reverse-defined
concepts, partitions, operationalisations, etc.) is encoded as
Lean `structure` / `def` / `class`, not as `axiom`; these
declarations are recorded in the gap ledger for trust-audit
completeness but do not appear in `#print axioms` output.

Several paper-side claims of structural flavour are recorded as
`phenomenologicalConjecture` Cat 3 sub-type entries rather than
`gapClosed` — independence and joint-satisfaction theses for the
DSC axes; minimality with respect to biological-vocabulary
blocking jobs; the substrate-independence premise's triple-use
structure; the ten-case historical calibration.  Each
`phenomenologicalConjecture` entry is a paper-PUBLISHED
substantive claim about a phenomenon awaiting EXTERNAL validation
(empirical observation, philosophical-foundations debate, or
historian / philosopher-of-science interpretive debate) — these
are never Lean-closeable; resolution path = battery / cohort
study / interpretive debate, NOT Lean derivation.  Status remains
`gapOpen` indefinitely.

Two remaining `gapBlocked` entries (`prot_testimony`,
`ai_governance_applications`) are protocol / policy design
proposals — not substantive empirical claims awaiting external
validation, but operational / policy sketches outside Lean's
structural-mathematical scope.

The 7-tier status taxonomy is `gapOpen` / `gapPartial` /
`gapBlocked` / `gapDeadEnd` / `gapClosed` /
`gapClosedConditional` / `gapDefinitional` per v6 §1.1 (the 7th
tier `gapDefinitional`, ratified 2026-05-14, marks paper-novel
Cat 3 atoms that are starting commitments rather than gaps to
close — covers the three definitional sub-types `carrier` /
`hypothesisPredicate` / `structuralEquation`).

The 6 Cat 3 sub-types tracked per v6 §3.4 (with the 6th sub-type
`phenomenologicalConjecture` added 2026-05-14 per v6 §3.4.6 /
Manufactured Recognition R-#27): `carrier` (paper-introduced
primitive type), `hypothesisPredicate` (paper-introduced
scope/regime predicate), `structuralEquation` (paper-stated
definitional equation on primitives), `workingAssumption`
(higher-level claim temporarily axiomatized while derivation is
developed — closes via Lean derivation), `conditionalHypothesis`
(paper's conclusion conditional on an external open problem),
`phenomenologicalConjecture` (framework-paper PUBLISHED
substantive claim about a phenomenon awaiting external
validation — resolution path is external, never Lean-closeable).

The authoritative current inventory of axiom names, citations, and
per-theorem dependencies is the `lake env lean
AsymmetricEliminativism/AxiomAudit.lean` output combined with the
`#eval` printout at the bottom of
[`AsymmetricEliminativism/Ledger.lean`](AsymmetricEliminativism/Ledger.lean).

## File structure

| File | Paper component |
|------|-----------------|
| [`AsymmetricEliminativism/Basic.lean`](AsymmetricEliminativism/Basic.lean) | Definitions `def:reverse`, `def:asym-elim`, `def:edc`, `def:separability`, `def:unranked`, `def:op-individuation`, `def:op-properties`; replacement-vocabulary definitions `def:sessional`, `def:concurrent`, `def:state-inference`, `def:distributional`, `def:homogeneous`, `def:inversion`, `def:sc`, `def:bridging`; structural lemma `bridging_dsc_iff_sc` |
| [`AsymmetricEliminativism/Diagnostic.lean`](AsymmetricEliminativism/Diagnostic.lean) | Discriminator (`def:discriminator`) rules (R1) and (R2), with derived structural lemmas on threshold-rule firing patterns |
| [`AsymmetricEliminativism/Impossibility.lean`](AsymmetricEliminativism/Impossibility.lean) | Theorem `\label{thm:impossibility}` (Lean-form `¬ P2`) + `thm_impossibility_paper_form` (paper-form `¬ (P2 ∧ P3)` derived from `thm_impossibility` + trivial-P3) + Lemma `\label{lem:prw}` (derived theorem `lem_prw_reduction` composing the six Cat 3 atomic case-bridge axioms `prw_{uniform,typeA,typeC1,typeC2_recursive,typeC4a_internal_track,contextual}_to_pr` with three derived case-theorems via case-exhaustion on the `WarrantFeatureType` 9-constructor inductive) + corollaries: `no_partition_independent_admissible_warrant`, `ensemble_methods_fail_P2`, `impossibility_uniform_family` |
| [`AsymmetricEliminativism/AxiomAudit.lean`](AsymmetricEliminativism/AxiomAudit.lean) | Trust audit: prints `#print axioms` for every paper-level theorem |
| [`AsymmetricEliminativism/Ledger.lean`](AsymmetricEliminativism/Ledger.lean) | Typed gap ledger: `GapStatus` × `InputCategory` orthogonal classification, with one `GapEntry` per atomic axiom, paper-novel carrier, and closed top-level result |

## Building

Requires Lean 4 toolchain `v4.30.0-rc2` (managed via `elan`).

```bash
# Install elan + Lean toolchain if not already
curl -sSf https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh | sh

# Get Mathlib cache (MUST run before `lake build` to avoid rebuilding Mathlib)
lake exe cache get

# Build
lake build

# Run axiom audit
lake env lean AsymmetricEliminativism/AxiomAudit.lean
```

## Trust verification

For an independent trust check, after `lake build`:

```bash
# Count of `sorry` (expect 0)
grep -rn '\bsorry\b' AsymmetricEliminativism/

# Print axiom dependencies of every paper-level theorem
lake env lean AsymmetricEliminativism/AxiomAudit.lean

# Print live gap-ledger inventory (status counts, input-category counts)
lake env lean AsymmetricEliminativism/Ledger.lean
```

## Audit history

The formalization has been built to mirror the Einstein-test
companion formalization (see
`research-line/academic-papers/projects/verification-asymmetry-internal/companion-einstein-test/lean4/`)
in structure, naming, and Cat 1/2/3 ledger discipline.  Per-axiom
attack history is preserved in the `attackHistory` field of the
corresponding `GapEntry` in
[`AsymmetricEliminativism/Ledger.lean`](AsymmetricEliminativism/Ledger.lean).

## Scope and limits

The paper has substantial philosophical content that is not
amenable to Lean formalization, by design:

* The **LLM-consciousness application** (Part I) is a substantive
  empirical-discursive argument turning on substrate-independence
  evidence in cognitive neuroscience.  This is empirical content,
  not structural mathematics.
* The **ten-case historical calibration** (Section
  `\label{sec:calibration}`) involves case-by-case empirical
  judgement about heat, gene, phlogiston, etc.  The discriminator
  *rule* is formalised; the *retrodictive labels* are not.
* The **AI-governance applications** (Part IV) port the diagnostic
  to four contested predicates (moral status, autonomy,
  responsibility, personhood); these are sketches of how the
  framework operates in policy contexts, not theorems.
* The **testimony protocol** (Section `\label{sec:testimony}`) is
  an evidential-status proposal for collecting AI self-reports
  under contamination-minimising conditions — an
  epistemology-of-evidence proposal, not a structural claim Lean
  checks.

The Lean side captures the *structural skeleton* on which these
substantive arguments rest: the typed apparatus, the discriminator
rules, the impossibility theorem, the replacement-vocabulary
structural axes, the bridging principle.  The philosophical
exposition is the paper's contribution and is documented there.

## Companion paper

| Resource | Identifier |
|----------|------------|
| SSRN abstract id | [6723220](https://papers.ssrn.com/sol3/papers.cfm?abstract_id=6723220) |
| Zenodo DOI | [10.5281/zenodo.20041562](https://doi.org/10.5281/zenodo.20041562) |

The paper accompanies the Lean formalization in the same directory
tree under
`asymmetric-eliminativism-full-internal/paper/asymmetric_eliminativism_full.tex`.
It is part of the broader LLM-consciousness research line.

## License

[MIT](LICENSE) (c) 2026 Alex Li.
