/-
  AsymmetricEliminativism/Impossibility.lean

  Theorem `\label{thm:impossibility}` — *impossibility for unranked-
  extension concepts* — and its load-bearing Lemma
  `\label{lem:prw}` (Partition-Relative-Weighting Reduction).

  Companion to: Li 2026, "Asymmetric Eliminativism: A Diagnostic
  Framework for Reverse-Defined Concepts …" (SSRN 6723220 /
  Zenodo 10.5281/zenodo.20041562).

  *Statement (paper-level).*  Let `C` be a reverse-defined concept
  whose folk extension `E` admits a mutually unranked partition
  `{E_1, …, E_n}` with `n ≥ 2`.  Let `{Op_1, …, Op_n}` be
  operationalisations of `C` within discourse `D`, where `Op_i` is
  faithful to `E_i`.  Assume the *discourse-internality hypothesis*
  (H): every admissible arbitration warrant within `D` for
  adjudicating operationalisations of `C` derives from `\E`.
  Then no member of `{Op_i}` can simultaneously satisfy P2 and P3
  on novel target classes that fit some `E_j` but not others.

  *Proof skeleton (paper-level).*
    Let `x` be a target-class member exhibiting `E_j`-features
    but not `E_i`-features (`i ≠ j`).  By P1, `Op_i(x)` is
    determined by `x`'s exhibition of `E_i`-features and is
    therefore negative; `Op_j(x)` is positive.  Hence `Op_i` and
    `Op_j` disagree on `x`.

    For `Op_i` to satisfy P2, there must exist an arbitration
    procedure `A` adjudicating `Op_i` against `Op_j` on grounds
    independent of `{E_1, …, E_n}`.  Two cases:

    Case (i) — `A`'s warrant is internal to `E`.  By Lemma
      `\label{lem:prw}`, any warrant constructible from `E` alone
      reduces to a partition-relative weighting, which is exactly
      what P2 forbids.  Hence (i) is closed.

    Case (i.b) / (ii)-external — `A`'s warrant is external to `E`.
      By (H) (the discourse-internality hypothesis), no external
      warrant is admissible in the discourse-state under
      consideration.  Hence (i.b) / (ii)-external is closed.

    No admissible arbitration procedure exists.  P2 fails.

  *Lean-encoding choice (v0.6.0 R2 honest revert).*  The v0.5.0 R1
  decomposition of `lem_prw_reduction` into five paper-novel atomic
  stipulations + four case-tag `def`s was cosmetic: the case-tag
  predicates `isUniformWarrant`, `usesTypeAFeature`,
  `usesTypeBFeature`, `usesTypeCStructuralProperty` were
  axiomatised as `Prop := True`, so the case-exhaustion atom
  (`warrantInternalToE → ⋁ <case-tags>`) reduced to a triviality and
  the four case-specific atoms collectively asserted exactly the
  original `lem_prw_reduction` content.  The R1 decomposition was
  therefore stronger-than-paper in form (it asserted `∀ A,
  A.partitionRelative` once a single carrier-Prop was inhabited) and
  added zero substantive paper-content versus the single-axiom
  encoding.

  Honest assessment: the paper's `\label{lem:prw}` proof body
  case-analyses the warrant by LINGUISTIC structural sub-form
  (uniform vs. contextual; type-(a)/(b)/(c) on the warrant's
  *justification*-prose), not by a typed predicate on the
  `ArbitrationProcedure` carrier itself.  Making the case-tags
  substantive would require a typed `Warrant` sub-structure
  paper-extension — refining `ArbitrationProcedure` to carry an
  explicit warrant-form classifier on which the case-tag
  predicates can be non-trivial.  That work is not yet present in
  the paper; pretending otherwise via `Prop := True` case-tags
  is anti-pattern #13 (conclusion-as-axiom in cosmetic-decomposition
  form).

  Round 2 fix: revert to a single Cat 3 `workingAssumption` axiom
  carrying the lemma's downstream consequence, with close-target
  recorded as the typed-Warrant refinement.  Downstream theorems
  (`thm_impossibility`, `no_partition_independent_admissible_warrant`,
  `ensemble_methods_fail_P2`, `impossibility_uniform_family`,
  `thm_impossibility_paper_form`) remain valid: their proofs use
  `lem_prw_reduction` as before.  The acknowledgment is that the
  decomposition cannot be made substantive without paper-extension
  typed-Warrant work; see Ledger `gap_lem_prw_reduction`
  `attackHistory` for the round-1→round-2 trail.
-/

import AsymmetricEliminativism.Basic

namespace AsymmetricEliminativism

/-! ## Lemma `\label{lem:prw}` — single working-assumption axiom.

  The lemma carries the paper's *published proof*.  In the current
  Lean encoding the lemma's downstream consequence is axiomatized
  as a single Cat 3 `workingAssumption`; the close-target is the
  typed-Warrant refinement of `ArbitrationProcedure` that would
  permit decomposing the lemma into per-case structural stipulations
  on the refined carrier.  See `AsymmetricEliminativism.Ledger`
  entry `gap_lem_prw_reduction` for the per-round attack history.
-/

/--
  Lemma `\label{lem:prw}` — *Partition-Relative-Weighting
  Reduction* (single Cat 3 `workingAssumption` axiom).

  Citation: Li 2026, `\label{lem:prw}` (paper-level Lemma 1 of
  the impossibility-theorem proof).

  *Statement.*  For any arbitration procedure `A` whose
  adjudication-warrant derives from `\E` alone (i.e.,
  `A.warrantInternalToE`), `A` reduces to a partition-relative
  weighting (`A.partitionRelative`).

  *Sub-type.*  `workingAssumption` per v6 §3.4.4: paper-stated
  lemma whose published proof case-analyses E-internal warrants
  into linguistic structural sub-forms (uniform vs. contextual;
  type-(a)/(b)/(c) on the warrant's justification-prose).  The
  lemma's downstream consequence is currently atomized as a single
  axiom pending typed-Warrant refinement of `ArbitrationProcedure`
  (close-target).  Per `feedback_truth_over_publication` and
  `feedback_gap_ledger_in_lean4` §3.4.4, this is the honest
  encoding of "atomic-decomposition pending typed refinement":
  the lemma is provable in the paper, but a substantive Lean
  decomposition requires paper-extension work not currently
  available.

  *Close target.*  Introduce a `Warrant` sub-structure on
  `ArbitrationProcedure` carrying the paper's warrant-form
  taxonomy (uniform / type-(a) / type-(b) / type-(c) structural-
  property); make the case-tag predicates typed predicates on
  the warrant; decompose this axiom into per-case atomic
  stipulations on the typed structure plus a case-exhaustion
  theorem about warrant-form coverage.

  *Why this is not Cat 1 or Cat 2.*  No Mathlib predicate for
  "warrant derived from `\E` alone reduces to partition-relative
  weighting" on the paper-novel `ArbitrationProcedure` carrier
  (Cat 1: CLEAR-NO).  No external textbook theorem covers the
  reduction on these typed carriers (Cat 2: CLEAR-NO, surveyed
  Arrow 1951, Sen 1970, Saari, Topkis, Brandom).
-/
axiom lem_prw_reduction
    {FolkObj Tcls : Type}
    (Part : MutuallyUnrankedPartition FolkObj)
    (A : ArbitrationProcedure FolkObj Tcls Part) :
    A.warrantInternalToE → A.partitionRelative

/-! ## Hypothesis (H) — discourse-internality.

  Hypothesis (H) of the impossibility theorem: *every admissible
  arbitration procedure within `D` for adjudicating
  operationalisations of `C` derives its adjudication-warrant from
  `\E`*.  In the discourse-state where `C` remains reverse-defined
  and no external warrant has yet emerged, (H) holds.

  *Lean encoding.*  We expose (H) as a hypothesis on arbitration
  procedures: a procedure is *admissible under (H)* iff its
  warrant is internal to `\E`.  Equivalently: any procedure with
  `¬ A.warrantInternalToE` is inadmissible under (H).
-/

/--
  *Discourse-internality hypothesis* (H).  In the discourse-state
  under consideration, every admissible arbitration procedure has
  warrant internal to `\E`.  This is a hypothesis on the
  *discourse-state*, not a logical truth — for forward-defined
  concepts (electron, gene) or for heat post-reform, (H) fails by
  construction.

  We carry (H) as a predicate over arbitration procedures: a
  procedure `A` is *admissible under (H)* exactly when
  `A.warrantInternalToE` holds.
-/
def DiscourseInternalityHypothesis
    {FolkObj Tcls : Type}
    {_Part : MutuallyUnrankedPartition FolkObj}
    (A : ArbitrationProcedure FolkObj Tcls _Part) : Prop :=
  A.warrantInternalToE

/-! ## Theorem `\label{thm:impossibility}`.  -/

/--
  **Theorem `\label{thm:impossibility}`: impossibility for
  unranked-extension concepts.**

  Let `Part : MutuallyUnrankedPartition FolkObj` with `n ≥ 2`.  Let
  `Op_i` be an operationalisation faithful to some part `E_i`.
  Assume hypothesis (H): every admissible arbitration procedure
  has warrant internal to `\E` (`A.warrantInternalToE`).  Then
  `Op_i` cannot satisfy P2 — i.e., no admissible arbitration
  procedure can adjudicate `Op_i` against rivals on grounds
  *independent* of the partition.

  *Why P3 is omitted from the conclusion.*  Given the Boolean-
  verdict encoding of `Operationalisation.verdict`, P3 holds
  trivially (every `x : Tcls` has a determinate Boolean verdict;
  see `satisfiesP3_of_boolean`).  The paper-level form of the
  theorem says "no `Op_i` can simultaneously satisfy P2 and P3";
  under the strict Boolean encoding, the binding constraint
  reduces to `¬ P2`.  The paper-level `¬ (P2 ∧ P3)` form is
  available as the derived `thm_impossibility_paper_form` (below
  this theorem in the file), which packages the reduction
  explicitly.  The paper's "load-bearing clause and its Lean
  encoding" paragraph (after the proof of
  `\label{thm:impossibility}`) discusses this Boolean-reduction
  bridge.

  *Hypotheses.*

  * `Part : MutuallyUnrankedPartition FolkObj` — the folk extension's
     unranked partition.
  * `Op_i : Operationalisation FolkObj Tcls Part` — the
     operationalisation under attack.
  * The (H) hypothesis is bound into the conclusion via the
     `warrantInternalToE` predicate on arbitration procedures.

  *Conclusion.*  Under (H), `Op_i` cannot satisfy P2 — formally:
     the negation of `SatisfiesP2`.

  *Proof.*  Suppose `Op_i` satisfied P2.  Then there exists an
  arbitration procedure `A` with `¬ A.partitionRelative` and
  `A.warrantInternalToE`.  By Lemma `\label{lem:prw}`
  (`lem_prw_reduction`), `A.warrantInternalToE` implies
  `A.partitionRelative`.  Contradiction.  Hence `Op_i` cannot
  satisfy P2 under (H).

  *Note on the (H) hypothesis.*  (H) appears implicitly in the
  Lean statement via the requirement that `A.warrantInternalToE`
  holds for the witness `A`.  An arbitration procedure with
  external warrant (`¬ A.warrantInternalToE`) is admissible only
  if (H) fails — i.e., if the discourse-state has moved past the
  reverse-defined-without-external-arbiter regime (heat post-
  reform).  Within (H), only `warrantInternalToE`-procedures are
  admissible, and the existence-witness for P2 must satisfy this.
-/
theorem thm_impossibility
    {FolkObj Tcls : Type}
    (Part : MutuallyUnrankedPartition FolkObj)
    (Op : Operationalisation FolkObj Tcls Part) :
    ¬ SatisfiesP2 FolkObj Tcls Part Op := by
  -- Suppose P2 holds: extract the arbitration witness.
  rintro ⟨A, hNotPR, hWarrant⟩
  -- By the (H)-bound lem_prw_reduction, A's warrant being
  -- internal to E implies A is partition-relative.
  have hPR : A.partitionRelative := lem_prw_reduction Part A hWarrant
  -- This contradicts hNotPR.
  exact hNotPR hPR

/-! ## Downstream consequences (`\label{thm:impossibility}` corollaries). -/

/--
  *Corollary (impossibility ⟹ no admissible arbitration).*  Under
  the impossibility theorem's hypotheses, *every* arbitration
  procedure with admissible warrant (i.e., `warrantInternalToE`)
  reduces to a partition-relative weighting.  This is the
  contrapositive form of `lem_prw_reduction` packaged as a
  derived statement.
-/
theorem no_partition_independent_admissible_warrant
    {FolkObj Tcls : Type}
    (Part : MutuallyUnrankedPartition FolkObj)
    (A : ArbitrationProcedure FolkObj Tcls Part) :
    A.warrantInternalToE → A.partitionRelative :=
  lem_prw_reduction Part A

/--
  *Corollary (ensemble methods fail).*  An ensemble method
  aggregating verdicts across `{Op_1, …, Op_n}` is itself an
  arbitration procedure; if its warrant is internal to `\E`, it
  too reduces to partition-relative weighting.  Hence
  ensemble-based adjudication does not escape P2.

  *Note.*  The Lean statement specialises `lem_prw_reduction` to an
  *ensemble-flavoured* arbitration procedure; the substantive
  reduction is identical because the underlying theorem is
  arbitration-procedure-agnostic.
-/
theorem ensemble_methods_fail_P2
    {FolkObj Tcls : Type}
    (Part : MutuallyUnrankedPartition FolkObj)
    (ensembleArbiter : ArbitrationProcedure FolkObj Tcls Part)
    (hWarrant : ensembleArbiter.warrantInternalToE) :
    ensembleArbiter.partitionRelative :=
  lem_prw_reduction Part ensembleArbiter hWarrant

/--
  *Corollary (impossibility transfers across operationalisations).*
  The impossibility theorem applies *uniformly* to every
  operationalisation in the family `{Op_1, …, Op_n}` faithful to
  the partition members.  Under (H), none satisfies P2.
-/
theorem impossibility_uniform_family
    {FolkObj Tcls : Type}
    (Part : MutuallyUnrankedPartition FolkObj)
    (Op : Fin Part.n → Operationalisation FolkObj Tcls Part) :
    ∀ k : Fin Part.n, ¬ SatisfiesP2 FolkObj Tcls Part (Op k) := by
  intro k
  exact thm_impossibility Part (Op k)

/--
  *Paper-form impossibility theorem.*  The paper states
  `\label{thm:impossibility}` as: "no member of `{Op_i}` can
  simultaneously satisfy P2 and P3", i.e., `¬ (P2 ∧ P3)`.  The Lean
  statement `thm_impossibility` is the load-bearing `¬ P2` clause.

  Under the strict Boolean-determinate encoding of an
  `Operationalisation` (verdict-map `Tcls → Bool`), P3 holds
  trivially (`satisfiesP3_of_boolean`): every `x : Tcls` has a
  determinate Boolean verdict by typing.  Hence `¬ (P2 ∧ P3)`
  follows from `¬ P2` directly: the conjunction's P3-conjunct is
  always true under the Boolean encoding, so the conjunction
  reduces to P2.

  *Citation.*  Li 2026, `\label{thm:impossibility}` (paper-level
  conclusion); the reduction to the Boolean-encoding form is
  explicit in the paper's paragraph "The load-bearing clause and
  its Lean encoding" following the proof.

  *Why this is `theorem` rather than `axiom`.*  This is a derived
  consequence of `thm_impossibility` + `satisfiesP3_of_boolean`;
  no new axiom is required.  The reduction `¬ (P2 ∧ P3) ⟸ ¬ P2`
  uses the trivial-P3 fact and standard `And` elimination.
-/
theorem thm_impossibility_paper_form
    {FolkObj Tcls : Type}
    (Part : MutuallyUnrankedPartition FolkObj)
    (Op : Operationalisation FolkObj Tcls Part) :
    ¬ (SatisfiesP2 FolkObj Tcls Part Op ∧ SatisfiesP3 FolkObj Tcls Part Op) := by
  rintro ⟨hP2, _hP3⟩
  exact thm_impossibility Part Op hP2

end AsymmetricEliminativism
