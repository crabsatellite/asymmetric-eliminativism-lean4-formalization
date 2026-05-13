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
  The single Cat 3 atomic axiom is `lem_prw_reduction`, capturing
  Lemma `\label{lem:prw}`'s load-bearing structural consequence
  (the partition-relative-weighting reduction is a single
  bi-implication; the paper's own structure treats the
  uniform / contextual case-split + type-(a)/(b)/(c) sub-claims as
  exhaustiveness checks on this single atomic fact, not as
  separable atoms).
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
`gapBlocked` rather than `gapClosed` — independence and joint-
satisfaction theses for the DSC axes; minimality with respect to
biological-vocabulary blocking jobs; the substrate-independence
premise's triple-use structure; the testimony protocol; the
ten-case historical calibration; the AI-governance applications.
Each `gapBlocked` entry carries an explicit reason: substantive
content lies in philosophical-discursive argument, substrate-
empirical premises, per-case historical judgement, or policy
sketches — outside Lean's structural-skeleton scope.

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
| [`AsymmetricEliminativism/Impossibility.lean`](AsymmetricEliminativism/Impossibility.lean) | Theorem `\label{thm:impossibility}` (Lean-form `¬ P2`) + `thm_impossibility_paper_form` (paper-form `¬ (P2 ∧ P3)` derived from `thm_impossibility` + trivial-P3) + Lemma `\label{lem:prw}` (the single Cat 3 atomic axiom) + corollaries: `no_partition_independent_admissible_warrant`, `ensemble_methods_fail_P2`, `impossibility_uniform_family` |
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
