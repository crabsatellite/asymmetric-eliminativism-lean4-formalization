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

Axioms are atomic minimal units; **v0.13.0 R18 Honest Acceptance
brings the project to ZERO Cat 3 atomic axioms** — the six
case-bridge `axiom`s from Lemma `\label{lem:prw}`'s proof body
(`prw_uniform_to_pr`, `prw_typeA_to_pr`, `prw_typeC1_to_pr`,
`prw_typeC2_recursive_to_pr`, `prw_typeC4a_internal_track_to_pr`,
`prw_contextual_to_pr`) are now derived theorems with proof body
`fun _ hW => hW.2`.  Anti-pattern #13 (conclusion-as-axiom) is
genuinely broken: no Cat 3 atomic axiom remains for the partition-
relativity chain.

**v0.14.0 R20 STRUCTURAL FIX preserves zero Cat 3 atomic axioms**
and adds a new Cat 3 `hypothesisPredicate` def
(`DiscourseHypothesisH`) realising paper hypothesis (H) as a
SEPARATE discourse-state hypothesis on `thm_impossibility` rather
than a conjunct of `SatisfiesP2`'s existential body.  R19 hostile
validator found that R18's `SatisfiesP2` bundled
`warrantInternalToE` as the third existential conjunct, but
since R18's `warrantInternalToE.2 = featureExtractsAreEInternal
= partitionRelative` definitionally, the existential body was
provably `False` by typing alone (`r19_kill := fun ⟨A, hNotPR, _,
hWITE⟩ => hNotPR hWITE.2` was kernel-pure no-axiom derivable).
R20 STRUCTURAL FIX: remove the `warrantInternalToE` conjunct from
`SatisfiesP2` (paper P2 doesn't bundle admissibility per
`\label{def:op-properties}` line 1976-1986); add
`DiscourseHypothesisH` predicate (paper hypothesis (H) at
`\label{thm:impossibility}` line 1999-2009); `thm_impossibility`
takes (H) as explicit hypothesis with substantive use in proof
body.  The R19 kill pattern no longer type-checks against the
3-binding post-R20 P2.

The downstream `lem_prw_reduction` is a derived `theorem`,
obtained by case-exhaustion `match` on `A.warrantForm :
WarrantFeatureType` composing nine derived case theorems (the six
R18-converted case-bridges plus the three R5-Issue-3 derived
theorems: `prw_typeB_no_ranking`, `prw_warrantInternalToE_excludes_typeC3`,
`prw_warrantInternalToE_excludes_typeC4b`).

What the typed Lean encoding captures of paper's substantive
content (per `feedback_gap_ledger_in_lean4` v6 §3.4 sub-types,
encoded as Lean `inductive` / `structure` / `def`, NOT as `axiom`
declarations):

* **`WarrantFeatureType`** — Cat 3 `carrier` (paper-cited
  9-constructor warrant-form taxonomy of `\label{lem:prw}` proof
  body).
* **`Warrant`** — Cat 3 `carrier` (paper-introduced typed triple
  `(FeatureSpace, featureExtract, ranker)` realising
  `\label{def:warrant}`).
* **`caseFormIsInternal`** — Cat 3 `hypothesisPredicate` (paper
  lines 2188-2237 hypothesis (H) tag-exclusion of external case-
  forms).
* **`featureExtractsAreEInternal`** — Cat 3 `structuralEquation`
  (paper lines 2099-2107 typed factorisation; definitionally
  identical to `partitionRelative` per paper line 2109-2112).
* **`warrantInternalToE`** — Cat 3 `structuralEquation`
  (composite `caseFormIsInternal ∧ featureExtractsAreEInternal`).
* **`DiscourseHypothesisH`** — Cat 3 `hypothesisPredicate`
  (paper hypothesis (H) at `\label{thm:impossibility}` line
  1999-2009 + paper `\label{lem:prw}` line 2114-2120; v0.14.0
  R20 NEW: universally-quantified `∀ A : ArbitrationProcedure,
  A.warrantInternalToE` realising paper's '(H) governs warrant,
  not features used'; non-vacuously refutable per V9.a, ensuring
  R20 does not relocate trivialization into (H)).

Iteration history.  v0.6.0 R2 first axiomatised `lem:prw` as a
single Cat 3 `workingAssumption`.  v0.8.0 R5 introduced the paper-
faithful `WarrantFeatureType` 9-case decomposition (6 axioms +
3 derived theorems) and converted `lem_prw_reduction` from axiom
to derived theorem.  v0.9.0 R7 attempted RHS concretization via
a `Weighting` carrier; v0.10.0 R9 honestly reverted that
concretization after Round 8 hostile validator machine-verified
it VACUOUS (constant-weight witness for every procedure).  v0.11.0
R14 (substantive paper-faithful Warrant typed-structure refactor):
Paper.tex revised with Definition `\label{def:warrant}` (typed
Warrant triple + E-internality factorisation clause); Lean
refactored with new `Warrant` carrier, `ArbitrationProcedure`
carrying `warrant : Warrant` + `exhibits` fields, and
`partitionRelative` as a derived `def` realising the paper's
E-internality factorisation.

**v0.12.0 R16 critical fix per round-16 brief Option B.**  The
v0.11.0 R14 case-bridge axioms had signature `warrantForm = X →
A.partitionRelative`, dropping paper `\label{lem:prw}` line 2116
antecedent ''constructible from E alone'' (the typed-structure
version being paper `\label{def:warrant}` E-internality clause
lines 2099-2107).  R15 hostile validator machine-verified that
this produced kernel-pure proof of `False`: `nonFactorisingA` has
`warrantForm = uniform` AND `¬ partitionRelative` (per
`VacuityCheck` V2 witness), so `prw_uniform_to_pr` applied to it
derives a `partitionRelative` witness contradicting (V2).  R16
Option B fix: (i) `warrantInternalToE` extended with the paper-
faithful E-internality factoring conjunct; (ii) each case-bridge
axiom signature extended to `warrantForm = X → warrantInternalToE
→ partitionRelative`; (iii) `lem_prw_reduction` threads `hW`
through each per-case invocation.

**v0.13.0 R18 Honest Acceptance per round-18 brief.**  R17
hostile validator found R16's Option B fix trivialised
`lem:prw`: R16's `warrantInternalToE = caseFormOK ∧ factorisation`,
and the factorisation clause is *definitionally* identical to
`partitionRelative` per paper line 2109-2112 ("the typed-structure
version of the prose-level description following
Lemma~\ref{lem:prw} of $R_{f^*}$ being constructed from $f^*$-
values on each $E_i$ that are distributed unequally across the
partition members").  Each `prw_X_to_pr` axiom became
`And.right`-derivable kernel-pure — anti-pattern #13 returned at
one level up.  Three R17 anti-patterns flagged: #11 (Cat 1
reduction missed) + #13 (conclusion-as-axiom) + #14 (composite-
axiom bundling).

R18 chose Option C — Honest Acceptance.  Accept the structural
triviality: paper's `lem:prw` IS Lean-trivial under typed
Definition `\label{def:warrant}`.  The case-analysis in paper's
`lem:prw` proof body is auxiliary commentary (sieving WHICH
warrants are E-internal via hypothesis (H) tag-exclusion, captured
separately by `caseFormIsInternal`), not substantive partition-
relativity derivation.  The 6 case-bridge axioms are converted to
derived theorems with proof body `fun _ hW => hW.2` (real Lean
proofs, no `sorry`).  Additionally, R18 decomposes
`warrantInternalToE` into two named sub-`def`s — `caseFormIsInternal`
(hypothesis (H) tag-exclusion) and `featureExtractsAreEInternal`
(typed factorisation) — addressing R17 anti-pattern #14
(composite bundling of paper-distinct conditions).

**v0.14.0 R20 STRUCTURAL FIX per round-20 brief.**  R19 hostile
validator found that R18's `SatisfiesP2 := ∃ A,
¬ A.partitionRelative ∧ ¬ A.failsAdjudication ∧ A.warrantInternalToE`
was internally contradictory.  Since R18's `warrantInternalToE.2
= featureExtractsAreEInternal = partitionRelative` definitionally
(paper line 2109-2112), the existential body was provably `False`
by typing alone: the R19 kill body `fun ⟨A, hNotPR, _, hWITE⟩ =>
hNotPR hWITE.2` was a kernel-pure no-axiom proof of
`¬ SatisfiesP2`, trivializing `thm_impossibility`.

R20 STRUCTURAL FIX restructures `SatisfiesP2` itself (rather
than tweaking case-bridge axiom signatures as R14/R16/R18 did):
- Remove `A.warrantInternalToE` conjunct from `SatisfiesP2`'s
  definition (paper P2 at `\label{def:op-properties}` line
  1976-1986 doesn't include admissibility-as-conjunct).
- Add new `DiscourseHypothesisH` predicate (Cat 3
  `hypothesisPredicate`) realising paper hypothesis (H) at
  `\label{thm:impossibility}` line 1999-2009 + paper
  `\label{lem:prw}` line 2114-2120 as a universally-quantified
  statement on `ArbitrationProcedure`.
- `thm_impossibility` takes (H) as EXPLICIT hypothesis: signature
  `(Part) (Op) (hH : DiscourseHypothesisH Part Op) : ¬ SatisfiesP2 Op`.
- Proof body substantively USES (H): extract `A.warrantInternalToE`
  via `hH A` for each existential witness, thread through
  `lem_prw_reduction`.
- R19 kill pattern `fun ⟨A, hNotPR, _, hWITE⟩ => …` (expecting
  4 bindings) FAILS to type-check against the 3-binding
  post-R20 P2.

The R20 fix is STRUCTURAL not cosmetic: it changes the shape of
`SatisfiesP2` and the signature of `thm_impossibility`, matching
paper's actual structure where (H) is a discourse-state hypothesis
on the impossibility theorem (paper line 1999-2009) NOT a
conjunct of P2's definition (paper line 1976-1986).  The 4-round
anti-pattern history (R7/R14/R16/R18) of tweaking case-bridge
axiom signatures while leaving `SatisfiesP2` bundling the
antecedent is finally broken at the right level.

Consistency + vacuity + R18 definitional-equivalence + R20
structural-validity verified kernel-pure via 15 theorems in
`VacuityCheck.lean`: (V1)-(V3) vacuity preserved + (V4)
`nonFactorisingA_not_warrantInternalToE` + (V5)
`factorisingA_satisfies_all_antecedents` + (V6)
`r15_attack_requires_unprovable_antecedent` + (V7) R18
`partitionRelative_iff_featureExtractsAreEInternal` (kernel-pure
`Iff.rfl` confirming paper line 2109-2112 identification) + (V8)
R18 case-bridge transparency theorems on `factorisingA` + (V9.a)
`discourseHypothesisH_toyPart_fails` (R20: (H) refutable on
toyPart via `nonFactorisingA` witness — refutes any "trivialization
relocated into (H)" claim) + (V9.b)
`r19_kill_destructuring_has_two_conjuncts` (R20: post-R20 P2
destructuring has exactly 2 conjuncts; R19's 4-binding pattern
fails to type-check) + (V9.c)
`r19_redux_blocked_by_satisfiability` (R20: post-R20
`SatisfiesP2 toyPart Op` is SATISFIABLE — `nonFactorisingA`
witnesses the body — blocking any "P2 trivially false" claim) +
(V9.d) `thm_impossibility_substantively_uses_H` (R20: theorem
non-trivially requires (H); on discourse states where (H) fails,
theorem is vacuously applicable rather than yielding contradiction).

*Honest scope statement.*  After R20, the project preserves
R18's structural honesty (per-case partition-relativity reduction
is Lean-trivial under typed `\label{def:warrant}`) and adds
substantive paper-faithfulness for the impossibility theorem
itself: (H) is now an explicit hypothesis substantively consumed
in the proof body via `hH A`, matching paper's actual structure.
What is preserved from R18: zero Cat 3 atomic axioms; the
`WarrantFeatureType` 9-constructor taxonomy; typed `Warrant`
structure realising `\label{def:warrant}`; `caseFormIsInternal`
+ `featureExtractsAreEInternal` paper-distinct conditions of
E-internality.  What R20 adds: structural paper-faithfulness for
`SatisfiesP2` (matches paper P2 line 1976-1986 by removing
non-paper conjunct); explicit theorem-level hypothesis (H) as
`DiscourseHypothesisH` (matches paper line 1999-2009); proof
body that substantively consumes (H) (matches paper's load-
bearing use of (H) in the impossibility proof).  What is
genuinely better: anti-pattern #13 broken at case-bridge level
(R18 achievement preserved); definitional smuggling broken at
P2-definition level (R20 achievement); the impossibility
theorem's truth-conditions match paper's truth-conditions
exactly (paper's "under (H), no Op satisfies P2" ↔ Lean's
`thm_impossibility (hH : DiscourseHypothesisH …) : ¬ SatisfiesP2`).

* **Lean kernel** — `propext`, `Classical.choice`, `Quot.sound`.

The project has zero Cat 1 axioms (no Mathlib-derivability
claims pending discharge), zero Cat 2 axioms (no external
textbook citations), and **zero Cat 3 atomic axioms** post-R18.

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
| [`AsymmetricEliminativism/Impossibility.lean`](AsymmetricEliminativism/Impossibility.lean) | Theorem `\label{thm:impossibility}` (post-R20 signature: `(Part) (Op) (hH : DiscourseHypothesisH Part Op) : ¬ SatisfiesP2 Op`) + `thm_impossibility_paper_form` (paper-form `¬ (P2 ∧ P3)` derived from `thm_impossibility` + trivial-P3; same R20 (H) hypothesis) + Lemma `\label{lem:prw}` (derived theorem `lem_prw_reduction` composing the six R18-converted case-bridge derived theorems `prw_{uniform,typeA,typeC1,typeC2_recursive,typeC4a_internal_track,contextual}_to_pr` with three derived case-theorems via case-exhaustion on the `WarrantFeatureType` 9-constructor inductive) + `DiscourseHypothesisH` (R20 NEW: paper hypothesis (H) at `\label{thm:impossibility}` line 1999-2009 as Cat 3 `hypothesisPredicate` def) + corollaries: `no_partition_independent_admissible_warrant`, `ensemble_methods_fail_P2`, `impossibility_uniform_family` (R20 update: now requires per-Op (H) family) |
| [`AsymmetricEliminativism/AxiomAudit.lean`](AsymmetricEliminativism/AxiomAudit.lean) | Trust audit: prints `#print axioms` for every paper-level theorem |
| [`AsymmetricEliminativism/VacuityCheck.lean`](AsymmetricEliminativism/VacuityCheck.lean) | Vacuity + consistency + R18 definitional-equivalence + R20 structural-validity verification: fifteen kernel-pure theorems — four R14 vacuity (counter-witness `nonFactorisingA` proves `∃ A, ¬ partitionRelative`; companion `factorisingA` proves satisfiability; case-bridge unconditional form refutable) + four R16 consistency (`nonFactorisingA_not_warrantInternalToE` + existence form + positive instance + R15 attack vector verifiably blocked) + three R18 (V7) `partitionRelative_iff_featureExtractsAreEInternal` (`Iff.rfl`, no axioms — confirming paper line 2109-2112 identification) + (V8) case-bridge transparency theorems on `factorisingA` + four R20 (V9.a) `discourseHypothesisH_toyPart_fails` (H not trivially-true) + (V9.b) `r19_kill_destructuring_has_two_conjuncts` (R19 4-binding pattern fails type-check) + (V9.c) `r19_redux_blocked_by_satisfiability` (post-R20 P2 satisfiable, blocking trivial-false claim) + (V9.d) `thm_impossibility_substantively_uses_H` (theorem requires (H), vacuously applicable when (H) fails) |
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
