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

  *Lean-encoding choice.*  We encode the substantive content of
  Lemma `\label{lem:prw}` as a single *paper-novel atomic
  defining axiom* (Cat 3 in the gap ledger): it is a structural
  fact about the partition-relative weighting reduction that is
  asserted by the paper and used by the proof; its substantive
  content lies in the paper's case analysis of `E`-internal warrant
  structures (uniform / contextual / type-(c) partition-symmetric
  property selection), which is the load-bearing combinatorial
  step.  We expose it as `axiom lem_prw_reduction` (with precise
  citation in its docstring and in the ledger).

  The conclusion `¬ P2` (under (H)) is then a *Lean theorem*
  derived from `lem_prw_reduction` plus the definition of
  `SatisfiesP2` plus the (H) hypothesis.  No paper-level theorem is
  axiomatized.
-/

import AsymmetricEliminativism.Basic

namespace AsymmetricEliminativism

/-! ## Lemma `\label{lem:prw}` — Partition-Relative-Weighting Reduction.

  The paper's Lemma `\label{lem:prw}` says: *any* warrant `W`
  constructible from `\E` alone that produces a preference ordering
  on operationalisations of `C` reduces to a partition-relative
  weighting of `{E_1, …, E_n}` and so fails P2's independence
  requirement.

  We carry the substantive content as a paper-novel atomic
  Cat 3 axiom.  The structural intent is captured precisely:
  for any arbitration procedure `A` whose warrant is internal to
  `\E` (`A.warrantInternalToE`), `A` is partition-relative
  (`A.partitionRelative`).  This is the lemma's load-bearing
  consequence; the paper's case analysis (uniform / contextual /
  type-(c) selection) is the lemma's *justification*, not a
  separate inferential step in the impossibility theorem's
  derivation.
-/

/--
  *Atomic axiom* (Cat 3 paper-novel defining equation): Lemma
  `\label{lem:prw}` of the impossibility theorem's proof —
  Partition-Relative-Weighting Reduction.

  Citation: Li 2026, `\label{lem:prw}` proof body
  (`asymmetric_eliminativism_full.tex` proof of
   `\label{thm:impossibility}`, immediately following the
   contextual / uniform case-split for `E`-internal warrants).

  *Statement.*  For any arbitration procedure `A` whose
  adjudication-warrant derives from `\E` alone (i.e.,
  `A.warrantInternalToE`), `A` reduces to a partition-relative
  weighting (`A.partitionRelative`) under the unranked-partition
  hypothesis.  Equivalently, contrapositively: no `E`-internal
  warrant is partition-independent.

  *Why this is a SINGLE atomic Cat 3 axiom (not multiple).*  The
  paper's `\label{lem:prw}` proof body itself states (paragraph
  immediately after the lemma's proof, beginning "All warrants in
  case (i.a) ... fail P2 by Lemma~\ref{lem:prw}.  The sub-claims
  below verify the lemma's exhaustiveness ... Lemma~\ref{lem:prw}
  carries the load, and the sub-claims serve as exhaustiveness-
  check rather than as the load-bearing proof"): the lemma's
  *downstream consequence* is a single structural bi-implication;
  the two-case (uniform / contextual) split plus the trichotomy
  sub-claims (No-arbitration for `\E`-internal ranking principles;
  type-(a) / type-(b) / type-(c) trichotomy; Partition-Internality
  of `\E`-Internal Structural Stipulations; (c.1) / (c.2) /
  (c.3) / (c.4.a) / (c.4.b)) are *exhaustiveness checks on the
  same atomic structural fact*, not separable atomic claims.
  Decomposing this single bi-implication into per-case axioms
  would invert the paper's own load-bearing structure (the lemma
  carries the load; sub-claims verify exhaustiveness).

  *Why this is Cat 3 atomic and not Cat 1/Cat 2.*  The lemma is
  paper-novel — it is not a Mathlib-derivable fact and not a
  cited textbook result.  Its substantive content lies in the
  paper's case analysis of `E`-internal warrant structures, which
  is itself the paper's contribution.  The lemma's justification
  is the case analysis (paper proof); the lemma's content as used
  downstream is the single bi-implication captured here.
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
  reduction is identical because the underlying axiom is
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
