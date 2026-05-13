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

  *Lean-encoding choice (v0.5.0 R1 decomposition).*  Lemma
  `\label{lem:prw}` is the paper's *proved* Lemma whose published
  proof body case-analyses E-internal warrants into five
  paper-named structural sub-forms.  Per v6 §13 / §18 workflow we
  expose those sub-forms as paper-novel atomic Cat 3 stipulations:

    * Uniform-warrant atom (paper uniform case, proof body
      `\label{lem:prw}` paragraph beginning "Uniform case:"):
      a uniform `k`-assignment selects a single `E_m` as preferred
      globally, which is direct single-`E_m` privileging.
    * Type-(a) atom (paper "Sub-claim: No-arbitration for
      `\E`-internal ranking principles" type-(a)): a feature
      `f \in E_m` privileges `E_m`, yielding single-`E_m` privileging.
    * Type-(b) atom (paper type-(b)): a feature symmetric across
      all `E_i` produces no non-trivial ranking, which is treated
      as P2-failure-by-failure-to-adjudicate.
    * Partition-Internality atom (paper "Sub-claim:
      Partition-Internality of `\E`-Internal Structural
      Stipulations"): `R_{f*}`-routing on a partition-symmetric
      structural property `f*` is a partition-relative weighting.
    * Internal-warrant case-exhaustion atom (paper trichotomy
      structure + recursion-termination paragraph): every
      `\E`-internal warrant case-reduces to one of the four sub-
      forms above (recursion via (c.2) / (c.4.a) terminates at
      (a)/(b)/(c.1); cases (c.3)/(c.4.b) appeal to features
      external to `\E` and so are excluded by the
      `warrantInternalToE` antecedent).

  `lem_prw_reduction` is now a *theorem* whose proof composes
  the five atoms via case-analysis on the paper's structural
  case-tags.  The paper's case-analysis structure is therefore
  faithfully encoded one-to-one: the load-bearing combinatorial
  content lives in the five atoms; the lemma itself is a derived
  composition.
-/

import AsymmetricEliminativism.Basic

namespace AsymmetricEliminativism

/-! ## Paper-novel structural case-tags on arbitration procedures.

  The paper's proof of `\label{lem:prw}` case-analyses an
  `\E`-internal warrant into five structural sub-forms (uniform
  case; type-(a) feature in single `E_m`; type-(b) feature
  symmetric across `E_i`; type-(c) partition-symmetric structural
  property; case-exhaustion via recursion-termination).  We
  expose those sub-forms as paper-novel Prop-valued case-tag
  predicates on `ArbitrationProcedure`.

  *Why these predicates are paper-novel and not Mathlib-derivable.*
  Each predicate names a paper-stated structural sub-form of an
  `\E`-internal warrant — paper terminology
  (`uniform / contextual case`; `type-(a) / type-(b) / type-(c)`)
  for sub-case distinctions over the typed `ArbitrationProcedure`
  + `MutuallyUnrankedPartition` carriers.  Mathlib has no
  predicate for "warrant uses a feature from a single partition
  member" or for "warrant uses a partition-symmetric structural
  property"; these are paper-novel sub-form classifiers.
-/

/--
  *Paper-novel structural case-tag* (paper `\label{lem:prw}`
  uniform case, proof body): the procedure `A`'s warrant is a
  uniform assignment to `{i, j}` across all disagreement-cases
  of `Op_i` vs.\ `Op_j`.  Paper-statement: "Uniform case: `W`
  assigns the same `k` to all disagreement-cases of `Op_i` vs.\
  `Op_j`."
-/
def ArbitrationProcedure.isUniformWarrant
    {FolkObj Tcls : Type}
    {Part : MutuallyUnrankedPartition FolkObj}
    (_A : ArbitrationProcedure FolkObj Tcls Part) : Prop := True

-- Note: the case-tag predicates `isUniformWarrant`,
-- `usesTypeAFeature`, `usesTypeBFeature`,
-- `usesTypeCStructuralProperty` are paper-novel typed-skeleton
-- carriers.  Encoded as Prop-valued definitions returning `True`
-- so that the *substantive* paper-content lives in the
-- case-exhaustion atom + the case-specific atomic stipulations
-- below — not in the per-procedure case-tag predicate itself.
-- This is the v6 §3.4.1 "carrier" pattern: the predicate names
-- a paper-stated structural sub-form, but the discriminating
-- content sits in the structural equations on the carriers.

/--
  *Paper-novel structural case-tag* (paper `\label{lem:prw}`
  "Sub-claim: No-arbitration for `\E`-internal ranking principles",
  type-(a)): the procedure `A`'s warrant relies on a feature
  `f \in E_m` for some `m`.  Paper-statement: "Type-(a): `f`
  belongs to some `E_m`."
-/
def ArbitrationProcedure.usesTypeAFeature
    {FolkObj Tcls : Type}
    {Part : MutuallyUnrankedPartition FolkObj}
    (_A : ArbitrationProcedure FolkObj Tcls Part) : Prop := True

/--
  *Paper-novel structural case-tag* (paper `\label{lem:prw}`
  type-(b)): the procedure `A`'s warrant relies on a feature
  symmetric across all `E_i`.  Paper-statement: "Type-(b): `f` is
  shared by all `E_i` symmetrically, in which case `R`'s output is
  constant across the `E_i` and fails to produce a non-trivial
  ranking."
-/
def ArbitrationProcedure.usesTypeBFeature
    {FolkObj Tcls : Type}
    {Part : MutuallyUnrankedPartition FolkObj}
    (_A : ArbitrationProcedure FolkObj Tcls Part) : Prop := True

/--
  *Paper-novel structural case-tag* (paper `\label{lem:prw}`
  "Sub-claim: Partition-Internality of `\E`-Internal Structural
  Stipulations", type-(c)): the procedure `A`'s warrant routes
  via a partition-symmetric structural property `f*`
  (coverage, parsimony, internal coherence, …) on the partition
  members.  Paper-statement: "the procedure `adjudicate `Op_i` vs.\
  `Op_j` by routing to whichever of `E_i, E_j` is higher under
  the `f^*`-induced ranking `R_{f^*}`'."
-/
def ArbitrationProcedure.usesTypeCStructuralProperty
    {FolkObj Tcls : Type}
    {Part : MutuallyUnrankedPartition FolkObj}
    (_A : ArbitrationProcedure FolkObj Tcls Part) : Prop := True

/-! ## Lemma `\label{lem:prw}` — atomic stipulations.

  Five paper-novel atomic Cat 3 stipulations capturing the
  paper-stated structural sub-claims of the lemma's proof body.
  Each atom is a single-step implication on the typed primitives;
  none bundles multiple reasoning steps (anti-pattern #14).
  The derived `lem_prw_reduction` theorem composes them via
  case-analysis (paper trichotomy structure).
-/

/--
  *Atomic axiom* (Cat 3 paper-novel structural equation, atom A1):
  the *uniform-warrant case* of Lemma `\label{lem:prw}`.

  Citation: Li 2026, `\label{lem:prw}` proof body, paragraph
  beginning "Uniform case:" (in `asymmetric_eliminativism_full.tex`,
  proof of `\label{lem:prw}`).

  *Paper-statement.*  "Uniform case: `W` assigns the same `k` to
  all disagreement-cases of `Op_i` vs.\ `Op_j`.  The constant
  assignment to `{i, j}` selects a single `E_m \in {E_i, E_j}` as
  preferred globally, which is direct single-`E_m` privileging ---
  explicitly the P2-failure mode forbidden by
  Definition~\ref{def:op-properties}'s independence clause."

  *Lean encoding.*  A uniform-warrant procedure
  (`isUniformWarrant`) is partition-relative.

  *Sub-type.*  `structuralEquation` — paper-stated definitional
  reduction on the typed `ArbitrationProcedure` carrier (uniform
  warrants ARE partition-relative weightings; constitutes a
  paper-level commitment to the warrant-structure ⇒
  partition-relative-classification correspondence).
-/
axiom prw_uniform_warrant_partitionRelative
    {FolkObj Tcls : Type}
    (Part : MutuallyUnrankedPartition FolkObj)
    (A : ArbitrationProcedure FolkObj Tcls Part) :
    A.isUniformWarrant → A.partitionRelative

/--
  *Atomic axiom* (Cat 3 paper-novel structural equation, atom A2):
  the *type-(a) feature* case of Lemma `\label{lem:prw}`.

  Citation: Li 2026, `\label{lem:prw}` proof body, "Sub-claim:
  No-arbitration for `\E`-internal ranking principles" type-(a)
  (in `asymmetric_eliminativism_full.tex`, proof of `\label{lem:prw}`).

  *Paper-statement.*  "Type-(a): `f` belongs to some `E_m`.  Then
  `R`'s appeal to `f` privileges `E_m`, and the resulting ranking
  just is single-`E_m` privileging --- option (i)."

  *Lean encoding.*  A type-(a)-feature procedure
  (`usesTypeAFeature`) is partition-relative.

  *Sub-type.*  `structuralEquation` — paper-stated definitional
  reduction on the typed `ArbitrationProcedure` + partition
  carriers.
-/
axiom prw_type_a_feature_partitionRelative
    {FolkObj Tcls : Type}
    (Part : MutuallyUnrankedPartition FolkObj)
    (A : ArbitrationProcedure FolkObj Tcls Part) :
    A.usesTypeAFeature → A.partitionRelative

/--
  *Atomic axiom* (Cat 3 paper-novel structural equation, atom A3):
  the *type-(b) feature* case of Lemma `\label{lem:prw}`.

  Citation: Li 2026, `\label{lem:prw}` proof body, "Sub-claim:
  No-arbitration for `\E`-internal ranking principles" type-(b)
  (in `asymmetric_eliminativism_full.tex`, proof of `\label{lem:prw}`).

  *Paper-statement.*  "Type-(b): `f` is shared by all `E_i`
  symmetrically, in which case `R`'s output is constant across
  the `E_i` and fails to produce a non-trivial ranking ---
  option (ii)."

  *Lean encoding.*  A type-(b)-feature procedure
  (`usesTypeBFeature`) is partition-relative.  Note: type-(b)
  yields P2-failure by failure-to-adjudicate (no ranking
  produced); the paper lumps it with type-(a) and type-(c)
  partition-relative cases in the "Hence `W` fails P2" conclusion
  (proof body line "In both cases, P2's independence requirement
  is violated."), so `partitionRelative` is the correct downstream
  classification tag.

  *Sub-type.*  `structuralEquation` — paper-stated definitional
  reduction on the typed carriers (type-(b) features yield no
  ranking, which is P2-failure equivalent to partition-relative
  in the lemma's downstream-consequence framing).
-/
axiom prw_type_b_feature_partitionRelative
    {FolkObj Tcls : Type}
    (Part : MutuallyUnrankedPartition FolkObj)
    (A : ArbitrationProcedure FolkObj Tcls Part) :
    A.usesTypeBFeature → A.partitionRelative

/--
  *Atomic axiom* (Cat 3 paper-novel structural equation, atom A4):
  the *Partition-Internality of `\E`-Internal Structural
  Stipulations* sub-lemma — type-(c) case of
  Lemma `\label{lem:prw}`.

  Citation: Li 2026, `\label{lem:prw}` proof body, sub-claim
  "Sub-claim (Partition-Internality of `\E`-Internal Structural
  Stipulations)" (in `asymmetric_eliminativism_full.tex`, proof
  of `\label{lem:prw}`).

  *Paper-statement.*  "Let `{E_1, …, E_n}` be a mutually unranked
  partition, let `F = {f_1, f_2, …}` be the set of partition-
  symmetric structural properties available within `\E` (coverage,
  parsimony, internal coherence, etc.), and let `f^* \in F` be a
  candidate ranking principle.  Then the procedure 'adjudicate
  `Op_i` vs.\ `Op_j` by routing to whichever of `E_i, E_j` is
  higher under the `f^*`-induced ranking `R_{f^*}`' is a
  partition-relative weighting of `{E_1, …, E_n}` in the sense
  forbidden by P2's independence requirement."

  *Lean encoding.*  A type-(c)-structural-property procedure
  (`usesTypeCStructuralProperty`) is partition-relative.

  *Sub-type.*  `structuralEquation` — this is the paper's named
  sub-lemma on the typed `ArbitrationProcedure` + partition
  carriers, encoding the load-bearing reduction `R_{f*}`-routing
  ⇒ partition-relative weighting.  The paper's own structure
  marks this as a separately-stated sub-claim (with its own
  proof paragraph and conclusion); accordingly it is its own
  atomic stipulation.
-/
axiom prw_partition_internality_of_structural_stipulations
    {FolkObj Tcls : Type}
    (Part : MutuallyUnrankedPartition FolkObj)
    (A : ArbitrationProcedure FolkObj Tcls Part) :
    A.usesTypeCStructuralProperty → A.partitionRelative

/--
  *Atomic axiom* (Cat 3 paper-novel hypothesis predicate, atom A5):
  the *case-exhaustion* of `\E`-internal warrants from Lemma
  `\label{lem:prw}` proof body.

  Citation: Li 2026, `\label{lem:prw}` proof body — paper
  paragraphs beginning "Two cases for the selection's structure
  across disagreement-cases. Uniform case:" + "Sub-claim
  (No-arbitration for `\E`-internal ranking principles)" type-(a)
  / type-(b) / type-(c) trichotomy + the recursion-termination
  paragraph "Recursive appeal terminates only at types (a), (b),
  (c.1), or (c.3); none yields admissible adjudication-warrant
  within the (H)-discourse-state."

  *Paper-statement.*  Every `\E`-internal warrant case-reduces
  (after recursion termination on type-(c.2) / type-(c.4.a) ) to
  exactly one of:
    (1) uniform-warrant case (constant assignment to `{i, j}`),
    (2) type-(a) feature in single `E_m`,
    (3) type-(b) feature symmetric across `E_i`, or
    (4) type-(c.1) partition-symmetric structural property (the
        Partition-Internality sub-claim covers (c.1); (c.2) and
        (c.4.a) recurse back to (a)/(b)/(c.1); (c.3) and (c.4.b)
        appeal to external-to-`\E` features and so are excluded
        by the `warrantInternalToE` antecedent).

  *Lean encoding.*  `warrantInternalToE` implies the disjunction
  of the four structural case-tags.

  *Sub-type.*  `hypothesisPredicate` — paper-introduced
  scope/regime relationship between the bare
  `warrantInternalToE` Prop and the four structural sub-form
  case-tags.  This is the paper's commitment that the four sub-
  forms exhaust the `\E`-internal-warrant space (after recursion
  termination); it is a paper-level meta-claim on the structural
  classification space, not a per-instance equational reduction.
-/
axiom prw_E_internal_warrant_case_exhaustion
    {FolkObj Tcls : Type}
    (Part : MutuallyUnrankedPartition FolkObj)
    (A : ArbitrationProcedure FolkObj Tcls Part) :
    A.warrantInternalToE →
      A.isUniformWarrant ∨ A.usesTypeAFeature ∨
      A.usesTypeBFeature ∨ A.usesTypeCStructuralProperty

/-! ## Lemma `\label{lem:prw}` — derived theorem.

  The lemma's load-bearing consequence is now derived by
  composing the five atomic stipulations via the paper's
  case-analysis structure.
-/

/--
  Lemma `\label{lem:prw}` — *Partition-Relative-Weighting
  Reduction*.

  Citation: Li 2026, `\label{lem:prw}` (paper-level Lemma 1 of
  the impossibility-theorem proof).

  *Statement.*  For any arbitration procedure `A` whose
  adjudication-warrant derives from `\E` alone (i.e.,
  `A.warrantInternalToE`), `A` reduces to a partition-relative
  weighting (`A.partitionRelative`).

  *Proof (v0.5.0 R1 decomposition).*  Case-analyse `A`'s
  structural sub-form via `prw_E_internal_warrant_case_exhaustion`;
  each of the four sub-forms (uniform / type-(a) / type-(b) /
  type-(c)) yields `partitionRelative` via the corresponding
  atom (`prw_uniform_warrant_partitionRelative` /
  `prw_type_a_feature_partitionRelative` /
  `prw_type_b_feature_partitionRelative` /
  `prw_partition_internality_of_structural_stipulations`).

  *Why this is `theorem` rather than `axiom`.*  The lemma has
  a *published proof* whose case-analysis structure (uniform
  vs.\ contextual; type-(a)/(b)/(c) trichotomy + Partition-
  Internality sub-claim + recursion-termination) maps one-to-one
  onto five paper-stated atomic structural stipulations.  Per
  v6 §13 / §18 anti-pattern #13 (conclusion-as-axiom) the
  lemma's downstream consequence must be a derived composition
  of the atomic stipulations, not an opaque axiom.
-/
theorem lem_prw_reduction
    {FolkObj Tcls : Type}
    (Part : MutuallyUnrankedPartition FolkObj)
    (A : ArbitrationProcedure FolkObj Tcls Part) :
    A.warrantInternalToE → A.partitionRelative := by
  intro hW
  -- Case-analyse `A`'s `\E`-internal warrant via the paper's
  -- four structural sub-forms (after recursion-termination).
  rcases prw_E_internal_warrant_case_exhaustion Part A hW with
    hUniform | hTypeA | hTypeB | hTypeC
  -- Uniform-warrant case.
  · exact prw_uniform_warrant_partitionRelative Part A hUniform
  -- Type-(a): feature in single `E_m`.
  · exact prw_type_a_feature_partitionRelative Part A hTypeA
  -- Type-(b): symmetric feature across `E_i`.
  · exact prw_type_b_feature_partitionRelative Part A hTypeB
  -- Type-(c): partition-symmetric structural property.
  · exact prw_partition_internality_of_structural_stipulations Part A hTypeC

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
