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

The formalization machine-checks the **structural mathematics** of the
paper inside Lean 4 + Mathlib.  Every paper-internal deduction is a
genuine Lean 4 theorem — **zero `sorry`**.

The paper is primarily a diagnostic framework in the philosophy of
mind / philosophy of science.  What is Lean-formalised is its
structural skeleton: the typed apparatus for reverse-defined concepts,
mutually-unranked partitions, operationalisation individuation, and
operationalisation properties P1/P2/P3; the discriminator threshold
rules (R1)/(R2); the impossibility theorem and its load-bearing
Lemma; and the replacement-vocabulary structural axes (DSC), sessional
cognition, and the bridging principle.  The substantive philosophical
content — the LLM-consciousness application, the historical
calibration narrative, the AI-governance applications, the
testimony-protocol epistemology — is the paper's contribution and is
not, and need not be, Lean-formalised.

All axioms are atomic minimal units, classified as one of:

* **Cat 3** — paper-novel: typed primitive carriers or paper-stated
  atomic predicates from Li 2026.  The only Cat 3 atomic *axiom* is
  `admissibleIn`, the discourse-regime predicate of hypothesis (H);
  `thm_impossibility` is closed conditionally on (H) and depends on
  this axiom alone.  All other paper-novel content (typed carriers,
  structural-equation definitions) is encoded as Lean
  `inductive` / `structure` / `def`, not as `axiom`.
* **Lean kernel** — `propext`, `Classical.choice`, `Quot.sound`.

The project has **zero Cat 1 axioms** (no Mathlib-derivability claims
pending) and **zero Cat 2 axioms** (no external textbook citations).

Lemma `lem:prw` is a derived theorem.  At the typed level its
reduction is the definitional identity `partitionRelative :=
featureExtractsAreEInternal` (paper Definition `def:warrant`
E-internality identification), so it carries no axiom dependency; the
substantive content of the impossibility argument lives in the
`WarrantFeatureType` taxonomy and the (H)-scoping `admissibleIn` axiom.

The authoritative current inventory of axiom names, citations, and
per-theorem dependencies is the `lake env lean
AsymmetricEliminativism/AxiomAudit.lean` output combined with the
`#eval` printout at the bottom of
[`AsymmetricEliminativism/Ledger.lean`](AsymmetricEliminativism/Ledger.lean);
see those sources for the live counts.

## File structure

| File | Paper component |
|------|-----------------|
| [`AsymmetricEliminativism/Basic.lean`](AsymmetricEliminativism/Basic.lean) | Reverse-defined concepts, asymmetric eliminativism, diagnostic conditions E1–E3, use-separability S1–S2, mutually-unranked partitions, operationalisation individuation and properties P1/P2/P3; the six DSC structural axes, sessional cognition, the bridging principle; structural lemma `bridging_dsc_iff_sc` |
| [`AsymmetricEliminativism/Diagnostic.lean`](AsymmetricEliminativism/Diagnostic.lean) | Discriminator threshold rules (R1)/(R2) and their structural firing-pattern lemmas |
| [`AsymmetricEliminativism/Impossibility.lean`](AsymmetricEliminativism/Impossibility.lean) | Definition `def:warrant`, Lemma `lem:prw` (derived theorem), Theorem `thm:impossibility` (conditional on hypothesis (H)) and `thm_impossibility_paper_form`; downstream corollaries |
| [`AsymmetricEliminativism/AxiomAudit.lean`](AsymmetricEliminativism/AxiomAudit.lean) | Trust audit: prints `#print axioms` for every paper-level theorem |
| [`AsymmetricEliminativism/VacuityCheck.lean`](AsymmetricEliminativism/VacuityCheck.lean) | Kernel-pure vacuity, consistency, and paper-faithfulness checks |
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

The formalization has been through multiple hostile audit rounds.
Per-axiom attack history (encoding refactors, prior retractions,
inconsistency fixes) is preserved in the `attackHistory` field of the
corresponding `GapEntry` in
[`AsymmetricEliminativism/Ledger.lean`](AsymmetricEliminativism/Ledger.lean);
release-level milestones are recorded in commit history and git tags.

## Scope and limits

The paper has substantial philosophical content not amenable to Lean
formalization, by design: the LLM-consciousness application; the
ten-case historical calibration (the discriminator *rule* is
formalised, the retrodictive *labels* are not); the AI-governance
applications; and the testimony protocol.  The Lean side captures the
structural skeleton on which these arguments rest; the philosophical
exposition is the paper's contribution and is documented there.

## Companion paper

| Resource | Identifier |
|----------|------------|
| SSRN abstract id | [6723220](https://papers.ssrn.com/sol3/papers.cfm?abstract_id=6723220) |
| Zenodo DOI | [10.5281/zenodo.20041562](https://doi.org/10.5281/zenodo.20041562) |

The paper accompanies the Lean formalization in the same directory
tree under
`asymmetric-eliminativism-full-internal/paper/asymmetric_eliminativism.tex`.
It is part of the broader LLM-consciousness research line.

## License

[MIT](LICENSE) © 2026 Alex Li.
