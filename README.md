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

Axioms are atomic minimal units.  Axiom history (7-round
anti-pattern spiral, resolved at R24):

- **v0.9.0 R7**: cosmetic Weighting carrier vacuity → R8 killed.
- **v0.11.0 R14**: missing antecedent inconsistency → R15 killed.
- **v0.12.0 R16**: composite predicate trivialization → R17 killed.
- **v0.13.0 R18**: definitional smuggling in SatisfiesP2 → R19
  killed via P2 internal contradiction.
- **v0.14.0 R20**: 2-line bypass + (H) universal-false → R21
  killed (2 defects).
- **v0.15.0 R22**: uniform-case axiom inconsistency → R23 killed
  via constant-ranker contradiction.
- **v0.16.0 R24**: FINAL HONEST CONVERGENCE — accept paper line
  2109-2112 typed-level trivialization; keep R22 Fix B
  admissibleIn.  **1 Cat 3 axiom total** (admissibleIn only).

**v0.16.0 R24 FINAL HONEST CONVERGENCE details.**  R23 hostile
validator machine-verified that v0.15.0 R22 Fix A
(`partitionRelative` non-degeneracy strengthening) introduced
axiom inconsistency.  Paper's uniform case (paper lines 2127-2132)
explicitly says "constant assignment ... selects a single $E_m$
globally" — i.e., paper's actual uniform case has CONSTANT $E_m$
adjudication (degenerate ranker by construction).  R22's
`prw_uniform_to_pr` axiom + uniform-constant-ranker witness
derived kernel-pure `False`.

Per R24 root-cause analysis: paper's `lem:prw` at typed
`\label{def:warrant}` level is STRUCTURALLY TRIVIAL.  Paper line
2109-2112 explicitly identifies E-internality factorisation with
partition-relative-weighting at the typed structure level.  Prior
rounds (R7/R14/R16/R18/R20/R22) all tried to make `lem:prw` non-
trivial at the typed level via encoding strengthenings; each
strengthening relocated the defect (vacuity / inconsistency /
trivialization / bypass / inconsistency).

R24 final honest convergence:

- **Revert R22 Fix A.**  `partitionRelative` reverts to R18 form,
  literally `featureExtractsAreEInternal`.  Per paper line
  2109-2112 identification, this IS paper-faithful.
- **Keep R22 Fix B.**  `admissibleIn` Cat 3 hypothesisPredicate
  axiom retained.  `DiscourseHypothesisH := ∀ A, admissibleIn A
  Op → warrantInternalToE`.  `SatisfiesP2` has 3 conjuncts
  (admissibleIn + ¬ partitionRelative + ¬ failsAdjudication).
- **6 case-bridges → derived theorems.**  Proof body
  `fun _ hW => hW.2` (with `unfold` step for `partitionRelative`).
  Anti-pattern #13 GENUINELY BROKEN: zero Cat 3 axioms for the
  partition-relativity chain.
- **`lem_prw_reduction` → derived theorem.**  Composes 9 derived
  case theorems via case-exhaustion `match` on `WarrantFeatureType`.
  `#print axioms lem_prw_reduction` shows NO axioms.
- **`thm_impossibility` → substantively uses (H) via admissibleIn
  discharge.**  Proof body extracts `⟨A, hAdm, hNotPR, hNotFails⟩`
  from P2 witness, applies `hH A hAdm` to obtain
  `warrantInternalToE`, threads through `lem_prw_reduction`.
  `#print axioms thm_impossibility` shows ONLY admissibleIn.

R23 inconsistency ELIMINATED: under R24's reverted predicate,
applying `prw_uniform_to_pr` (now derived theorem) to the
uniform-constant-ranker witness yields `partitionRelative =
featureExtractsAreEInternal` consistently, NO `False`.  See
`VacuityCheck.r23_inconsistency_eliminated`.

Substantive paper content preserved in:
1. `WarrantFeatureType` 9-constructor taxonomy (Cat 3 carrier).
2. `admissibleIn` axiom restricting (H) scope (Cat 3
   hypothesisPredicate; R22 Fix B retained; paper line 1999-2002).
3. `caseFormIsInternal` hypothesis (H) tag-exclusion (Cat 3
   structuralEquation; paper lines 2188-2237).
4. `featureExtractsAreEInternal` typed factorisation (Cat 3
   structuralEquation; paper lines 2099-2107).
5. `DiscourseHypothesisH` restricted predicate (R22 Fix B
   retained; paper line 1999-2009).

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
  (paper lines 2099-2107 typed factorisation; under v0.16.0 R24
  reverted predicate, definitionally identical to
  `partitionRelative` per paper line 2109-2112).
* **`warrantInternalToE`** — Cat 3 `structuralEquation`
  (composite `caseFormIsInternal ∧ featureExtractsAreEInternal`).
* **`partitionRelative`** — Cat 3 `structuralEquation`
  (v0.16.0 R24 reverted: literally `featureExtractsAreEInternal`
  per paper line 2109-2112 identification).
* **`admissibleIn`** — Cat 3 `hypothesisPredicate` AXIOM (v0.15.0
  R22 NEW, retained v0.16.0 R24: paper-stipulated discourse-D
  admissibility predicate per paper line 1999-2002).
* **`DiscourseHypothesisH`** — Cat 3 `hypothesisPredicate`
  (paper hypothesis (H); v0.15.0 R22 restricted, retained v0.16.0
  R24: `∀ A, A.admissibleIn Op → A.warrantInternalToE`).

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

**v0.15.0 R22 DUAL FIX (Fix A reverted v0.16.0 R24; Fix B retained).**
R21 hostile validator found 2 critical defects in v0.14.0 R20:

- **Defect 1**: V7 `partitionRelative_iff_featureExtractsAreEInternal
  := Iff.rfl` lets `thm_impossibility` reduce to 2-line bypass
  `exact hNotPR (hH A).2`.
- **Defect 2**: `DiscourseHypothesisH := ∀ A : ArbitrationProcedure,
  A.warrantInternalToE` is UNIVERSALLY FALSE because
  `nonFactorisingA`-style witnesses are always Lean-constructible.

R22 dual fix:

- **Fix A** (REVERTED v0.16.0 R24): `partitionRelative` strengthened
  with paper line 2168-2170 non-degeneracy conjunct.  R23 hostile
  validator found this introduced axiom inconsistency on paper's
  uniform case (constant ranker required by paper).  R24 reverts;
  case-bridges back to derived theorems.
- **Fix B** (RETAINED v0.16.0 R24): `admissibleIn` axiom added.
  `DiscourseHypothesisH` restricted to admissible procedures:
  `∀ A, admissibleIn A Op → warrantInternalToE`.  `SatisfiesP2`
  adds `admissibleIn` conjunct.  `thm_impossibility` proof body
  discharges `hAdm` from P2 witness.

**v0.16.0 R24 FINAL HONEST CONVERGENCE.**  R23 hostile validator
machine-verified R22 Fix A inconsistency: paper's uniform case
has constant ranker (paper lines 2127-2132), failing R22's
non-degeneracy requirement; R22 axiom + uniform-constant-ranker
witness derived kernel-pure `False`.  R24 reverts R22 Fix A;
keeps R22 Fix B.

Post-R24 axiom count: **1** (admissibleIn only).
`thm_impossibility` depends only on `admissibleIn`.

Consistency + vacuity verified kernel-pure via 18 theorems in
`VacuityCheck.lean`: (V1)-(V2) vacuity preserved + (V3)
unconditional case-bridge refutable + (V4)
`nonFactorisingA_not_warrantInternalToE` + (V5)
`factorisingA_satisfies_all_antecedents` + (V6)
`r15_attack_requires_unprovable_antecedent` + (V7)
`partitionRelative_iff_featureExtractsAreEInternal` (`Iff.rfl`,
no axioms — paper line 2109-2112 identification verified) +
(V8) case-bridge derivation on factorisingA + (V9) R20 structural
verification (R22 Fix B 3-conjunct P2) + (V10.a)
`discourseHypothesisH_satisfiable_when_admissibleIn_empty` (R22
Fix B: (H) non-vacuously satisfiable on admissibleIn-empty states) +
(V10.b) `discourseHypothesisH_fails_when_admissibleIn_universal`
(R22 Fix B: (H) non-vacuously refutable when admissibleIn is
universal — `nonFactorisingA` is the counter-witness) + (V11)
R24 honest acknowledgment: `(hH A hAdm).2` IS the canonical
2-line reduction per paper line 2109-2112 + (V12) R23
inconsistency ELIMINATED:
`uniformConstantRankerA_partitionRelative` is a consistent
positive theorem, NOT a `False` derivation.

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
textbook citations).  Post-v0.16.0 R24: **1 Cat 3 atomic axiom**
(`admissibleIn` only; R22 Fix B retained, paper line 1999-2002).
The 6 case-bridges (`prw_uniform_to_pr`, etc.) are derived
theorems with proof body `fun _ hW => hW.2` per paper line
2109-2112 identification.

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
| [`AsymmetricEliminativism/Impossibility.lean`](AsymmetricEliminativism/Impossibility.lean) | Theorem `\label{thm:impossibility}` (post-R20 signature: `(Part) (Op) (hH : DiscourseHypothesisH Part Op) : ¬ SatisfiesP2 Op`; depends only on `admissibleIn` axiom post-R24) + `thm_impossibility_paper_form` (paper-form `¬ (P2 ∧ P3)` derived from `thm_impossibility` + trivial-P3) + Lemma `\label{lem:prw}` (derived theorem `lem_prw_reduction` composing 6 R24-converted case-bridge derived theorems with 3 derived case-theorems via case-exhaustion on `WarrantFeatureType`; depends on NO axioms post-R24) + `DiscourseHypothesisH` (R22 Fix B retained: paper hypothesis (H) restricted to `∀ A, admissibleIn A Op → warrantInternalToE`) + corollaries: `no_partition_independent_admissible_warrant`, `ensemble_methods_fail_P2`, `impossibility_uniform_family` |
| [`AsymmetricEliminativism/AxiomAudit.lean`](AsymmetricEliminativism/AxiomAudit.lean) | Trust audit: prints `#print axioms` for every paper-level theorem.  Post-R24: `thm_impossibility` depends ONLY on `admissibleIn` axiom; all 6 case-bridges and `lem_prw_reduction` depend on NO axioms. |
| [`AsymmetricEliminativism/VacuityCheck.lean`](AsymmetricEliminativism/VacuityCheck.lean) | Vacuity + consistency + paper-line-2109-2112 identification + R22 Fix B + R23 inconsistency elimination verification: 18 kernel-pure theorems — (V1)-(V3) vacuity preserved (nonFactorisingA refutes partitionRelative; factorisingA witnesses partition-relativity; unconditional case-bridge refutable) + (V4)-(V6) R16 consistency preserved + (V7) `partitionRelative_iff_featureExtractsAreEInternal` (`Iff.rfl`, no axioms — paper line 2109-2112 identification) + (V8) case-bridge derivation on factorisingA + (V9) post-R22 3-conjunct P2 structural verification + (V10.a)-(V10.b) `DiscourseHypothesisH` non-vacuously-true and non-vacuously-false on admissibleIn-empty / admissibleIn-universal states + (V11) R24 honest acknowledgment of (hH A hAdm).2 canonical reduction + (V12) R23 inconsistency ELIMINATED: `uniformConstantRankerA_partitionRelative` is a consistent positive theorem |
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
