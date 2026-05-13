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
  (`asymmetric_eliminativism_full.tex` proof case analysis,
   pp. corresponding to the impossibility-theorem section).

  *Scope.*  This axiom asserts that any arbitration procedure
  whose adjudication-warrant derives from `\E` alone (i.e.,
  `A.warrantInternalToE`) reduces to a partition-relative
  weighting (`A.partitionRelative`) under the unranked-partition
  hypothesis.  Equivalently, contrapositively: no `E`-internal
  warrant is partition-independent.

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
    (Π : MutuallyUnrankedPartition FolkObj)
    (A : ArbitrationProcedure FolkObj Tcls Π) :
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
    {_Π : MutuallyUnrankedPartition FolkObj}
    (A : ArbitrationProcedure FolkObj Tcls _Π) : Prop :=
  A.warrantInternalToE

/-! ## Theorem `\label{thm:impossibility}`.  -/

/--
  **Theorem `\label{thm:impossibility}`: impossibility for
  unranked-extension concepts.**

  Let `Π : MutuallyUnrankedPartition FolkObj` with `n ≥ 2`.  Let
  `Op_i` be an operationalisation faithful to some part `E_i`.
  Assume hypothesis (H): every admissible arbitration procedure
  has warrant internal to `\E` (`A.warrantInternalToE`).  Then
  `Op_i` cannot satisfy P2 — i.e., no admissible arbitration
  procedure can adjudicate `Op_i` against rivals on grounds
  *independent* of the partition.

  *Why P3 is omitted from the conclusion.*  Given the Boolean-
  verdict encoding of `Operationalisation.verdict`, P3 holds
  trivially (every `x : Tcls` has a determinate Boolean verdict).
  The paper-level form of the theorem says "no `Op_i` can
  simultaneously satisfy P2 and P3"; under the Lean Boolean
  encoding, the binding constraint reduces to "P2 fails".  The
  paper's substantive content is `¬ P2`; we state this as the
  theorem.  See `Basic.lean` `satisfiesP3_of_boolean` for the
  trivial-P3 observation.

  *Hypotheses.*

  * `Π : MutuallyUnrankedPartition FolkObj` — the folk extension's
     unranked partition.
  * `Op_i : Operationalisation FolkObj Tcls Π` — the
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
    (Π : MutuallyUnrankedPartition FolkObj)
    (Op : Operationalisation FolkObj Tcls Π) :
    ¬ SatisfiesP2 FolkObj Tcls Π Op := by
  -- Suppose P2 holds: extract the arbitration witness.
  rintro ⟨A, hNotPR, hWarrant⟩
  -- By the (H)-bound lem_prw_reduction, A's warrant being
  -- internal to E implies A is partition-relative.
  have hPR : A.partitionRelative := lem_prw_reduction Π A hWarrant
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
    (Π : MutuallyUnrankedPartition FolkObj)
    (A : ArbitrationProcedure FolkObj Tcls Π) :
    A.warrantInternalToE → A.partitionRelative :=
  lem_prw_reduction Π A

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
    (Π : MutuallyUnrankedPartition FolkObj)
    (ensembleArbiter : ArbitrationProcedure FolkObj Tcls Π)
    (hWarrant : ensembleArbiter.warrantInternalToE) :
    ensembleArbiter.partitionRelative :=
  lem_prw_reduction Π ensembleArbiter hWarrant

/--
  *Corollary (impossibility transfers across operationalisations).*
  The impossibility theorem applies *uniformly* to every
  operationalisation in the family `{Op_1, …, Op_n}` faithful to
  the partition members.  Under (H), none satisfies P2.
-/
theorem impossibility_uniform_family
    {FolkObj Tcls : Type}
    (Π : MutuallyUnrankedPartition FolkObj)
    (Op : Fin Π.n → Operationalisation FolkObj Tcls Π) :
    ∀ k : Fin Π.n, ¬ SatisfiesP2 FolkObj Tcls Π (Op k) := by
  intro k
  exact thm_impossibility Π (Op k)

end AsymmetricEliminativism
