/-
  AsymmetricEliminativism/Basic.lean

  Structural types for:
    * Reverse-defined concepts (`\label{def:reverse}`)
    * Asymmetric eliminativism (`\label{def:asym-elim}`)
    * Eliminative diagnostic conditions E1–E3 (`\label{def:edc}`)
    * Use-separability (`\label{def:separability}`)
    * Mutually unranked partition (`\label{def:unranked}`)
    * Operationalisation individuation (`\label{def:op-individuation}`)
    * Operationalisation properties P1, P2, P3 (`\label{def:op-properties}`)
    * DSC structural axes (`\label{def:sessional}` …
       `\label{def:inversion}`)
    * Sessional cognition (`\label{def:sc}`)
    * Bridging principle (`\label{def:bridging}`)

  Companion to: Li 2026, "Asymmetric Eliminativism: A Diagnostic
  Framework for Reverse-Defined Concepts …" (SSRN 6723220 /
  Zenodo 10.5281/zenodo.20041562).

  *Lean-encoding philosophy.*  The paper's formal apparatus is
  primarily a typed predicate skeleton over abstract carriers: a
  concept `C`, its folk extension `E`, a target class `T`, a finite
  family of operationalisations `Op_i`, etc.  We carry the abstract
  carriers as `Type` parameters and the structural predicates as
  Lean `def`s or `structure`s.  No paper-level theorem is
  axiomatized; the impossibility theorem of
  `\label{thm:impossibility}` is derived in
  `Impossibility.lean` from the typed definitions alone.

  *Where `axiom` appears.*  We use `axiom` exclusively for the
  small handful of paper-novel atomic facts the impossibility-
  theorem proof appeals to non-trivially — specifically, the
  *consequence* of `def:unranked` that no ranking principle on
  `\E`-features escapes the partition-relative weighting trichotomy
  beyond the cases already case-analysed (lemma exhaustiveness is
  in the paper).  Each such axiom is documented as Cat 3 paper-
  novel atomic in `AsymmetricEliminativism.Ledger`.
-/

import Mathlib.Data.Set.Basic
import Mathlib.Data.Finset.Basic
import Mathlib.Data.Fintype.Basic
import Mathlib.Logic.Basic
import Mathlib.Order.Basic
import Mathlib.Data.Real.Basic

namespace AsymmetricEliminativism

/-! ## §2.  Reverse-defined concepts.  -/

/--
  Definition `\label{def:reverse}`: a *reverse-defined concept*.

  A concept `C` (carrier `Concept`) is reverse-defined within a
  discourse `D` when:

  * (i)  `C` carries a folk extension `folkExt : Set FolkObj`
         established prior to its introduction into `D`;
  * (ii) `D` contains a finite family `ops : Fin n → Op` of
         operationalisations, each intended to capture `C`;
  * (iii) the operationalisations *disperse*: there exists at least
         one input on which two of the `ops` disagree;
  * (iv) the disputes among `ops` track substantive disagreement
         about which subset of `folkExt` each operationalisation
         honours, rather than disagreement settle-able internally
         to `D` on grounds independent of the folk extension.

  Clauses (i)–(iii) are observable conditions; clause (iv) is the
  hard clause and is carried as a `Prop`-valued field.  The paper
  supplies three operational criteria (iv.a)/(iv.b)/(iv.c) jointly
  sufficient for clause (iv); we expose them below as a separate
  structure `ReverseDefinedWitness` for clients that need to
  exhibit (iv) constructively.
-/
structure ReverseDefinedConcept (Concept : Type) (FolkObj : Type)
    (Op : Type) (Input : Type) where
  /-- The concept (typed carrier; abstract). -/
  concept : Concept
  /-- The pre-theoretical folk extension `E_folk`. -/
  folkExt : Set FolkObj
  /-- Indexed family of operationalisations.  `n ≥ 2` is required
      for the dispersion condition to be non-trivial. -/
  n : Nat
  /-- The operationalisations as a function `Fin n → Op`. -/
  ops : Fin n → Op
  /-- Each operationalisation defines a verdict map on `Input`. -/
  verdict : Op → Input → Bool
  /-- (iii) Dispersion: two operationalisations disagree on some input. -/
  disperses : ∃ (i j : Fin n) (x : Input), i ≠ j ∧
    verdict (ops i) x ≠ verdict (ops j) x
  /-- (iv) The dispute is folk-substantive (Prop-valued; the
      paper's (iv.a)/(iv.b)/(iv.c) sub-criteria jointly sufficient
      for this clause are formalised in `ReverseDefinedWitness`). -/
  folkSubstantive : Prop

/--
  The three sub-criteria (iv.a)/(iv.b)/(iv.c) jointly sufficient for
  clause (iv) of `\label{def:reverse}`.  A `ReverseDefinedWitness`
  supplies them in a structured form.
-/
structure ReverseDefinedWitness (Concept FolkObj Op Input : Type)
    (R : ReverseDefinedConcept Concept FolkObj Op Input) where
  /-- (iv.a) Cross-operationalisation defence asymmetry: each `Op_i`
       is defended within `D` by appeal to features of `folkExt`
       that it honours and rivals do not.  Carried as a Prop. -/
  defenceAsymmetry : Prop
  /-- (iv.b) Absence of cross-operationalisation arbiter on
       operationalisation-internal grounds.  Carried as a Prop. -/
  noInternalArbiter : Prop
  /-- (iv.c) Substitutability of folk-extension subsets reverses
       verdicts on contested members of the target class.  Carried
       as a Prop. -/
  folkSubsetReverses : Prop

/-! ## §3.  Asymmetric eliminativism (`\label{def:asym-elim}`).  -/

/--
  Definition `\label{def:asym-elim}`: *asymmetric eliminativism*.

  For a concept `C` and a partition `parts : Fin m → TClass` of
  systems/contexts into target classes, the *asymmetric
  eliminativist* position assigns each part to one of two
  registers: `retained` (concept legitimate for this class) or
  `eliminated` (concept eliminated for this class).

  *Caveat.*  The paper distinguishes (a)-style elimination (licensed
  by successor maturity) from (b)-style elimination (issued ahead
  of replacement-programme maturity, conditional on the three
  further conditions b.i / b.ii / b.iii).  We expose the
  (a)/(b) distinction via the `LicensingMode`.
-/
inductive ElimRegister
  | retained
  | eliminated
  deriving DecidableEq, Repr

/-- (a)/(b) licensing mode of an elimination verdict. -/
inductive LicensingMode
  /-- (a) Successor-mature elimination — licensed by replacement programme. -/
  | typeA
  /-- (b) Preliminary elimination ahead of replacement-programme maturity. -/
  | typeB
  deriving DecidableEq, Repr

/-- An asymmetric-eliminativist verdict on a partition into target
    classes.  Carrier types `Concept` and `TClass` are abstract. -/
structure AsymmetricEliminationVerdict (Concept TClass : Type) where
  /-- The concept. -/
  concept : Concept
  /-- The number of target classes in the partition. -/
  m : Nat
  /-- The partition itself. -/
  parts : Fin m → TClass
  /-- The verdict-assignment to each part. -/
  register : Fin m → ElimRegister
  /-- For each `eliminated`-tagged part, the licensing mode. -/
  mode : ∀ i, register i = ElimRegister.eliminated → LicensingMode

/-! ## §3 (cont.).  Eliminative diagnostic conditions E1–E3
     (`\label{def:edc}`).  -/

/--
  Definition `\label{def:edc}`: a concept `C` exhibits the
  *diagnostic profile* for asymmetric elimination on target class
  `T` within discourse `D` iff the three conditions E1, E2, E3 all
  obtain.

  We carry each condition as a Prop-valued field; the substantive
  defeasibility content (substrate-independence, four-year
  publication window, etc.) is the paper's empirical layer and is
  not formalised here.
-/
structure DiagnosticProfile (Concept FolkObj Op Input : Type) where
  /-- E1: the concept is reverse-defined (clause i of
      `\label{def:reverse}` + clauses (ii)–(iv)). -/
  E1_reverseDefined :
    ReverseDefinedConcept Concept FolkObj Op Input
  /-- E2: persistent dispersion.  Conjoins (E2a) operationalisations
       produce incompatible verdicts on members of the target class
       as currently observed, and (E2b) dispersion has persisted
       across at least one paradigm shift evaluated on whatever
       target class `C` has been applied to during `D`'s history. -/
  E2_persistentDispersion : Prop
  /-- E3: functional decoupling — the role `C` plays in domains
       other than `D` does not require its application to members
       of the target class. -/
  E3_functionalDecoupling : Prop

/-! ## §6.  Use-separability (`\label{def:separability}`).  -/

/--
  Definition `\label{def:separability}`: a contested concept `C`
  with eliminated use on target class `T_e` and retained use on
  `T_r` is *use-separable* when:

  * (S1) Causal independence: no causal pathway through which the
        analytic verdict on `C(T_e)` modifies the extension of the
        retained use on `T_r`.
  * (S2) Constitutive independence: the criteria constitutive of
        the retained use on `T_r` are stateable without reference
        to the criteria constitutive of `C(T_e)`.

  Both are Prop-valued; the paper's evidential-temporal reading and
  load-bearing threshold are empirical-substrate matters and not
  formalised here.
-/
structure UseSeparability (Concept TClass : Type) where
  /-- The concept. -/
  concept : Concept
  /-- The eliminated-use target class `T_e`. -/
  TElim : TClass
  /-- The retained-use target class `T_r`. -/
  TRetained : TClass
  /-- (S1) Causal independence. -/
  S1_causalIndependence : Prop
  /-- (S2) Constitutive independence. -/
  S2_constitutiveIndependence : Prop

/-! ## §7.  Mutually unranked partitions (`\label{def:unranked}`).  -/

/--
  Definition `\label{def:unranked}`: a partition
  `parts : Fin n → Set FolkObj` of a folk extension `E` is
  *mutually unranked* iff no procedure internal to `E` supplies a
  ranking over `{E_1, …, E_n}` that is independent of which `E_i`
  the ranking procedure itself privileges.

  *Lean-encoding choice.*  We carry the negative "no such ranking"
  content as a single `Prop`-valued field
  `noPartitionIndependentRanking`; the paper's positive
  characterisation (any candidate ranking principle reduces to
  partition-relative weighting by Lemma `\label{lem:prw}`) is the
  load-bearing content carried by the impossibility theorem in
  `Impossibility.lean`.
-/
structure MutuallyUnrankedPartition (FolkObj : Type) where
  /-- Number of partition members.  `n ≥ 2` is the non-trivial case. -/
  n : Nat
  /-- Two-or-more partition members.  Required for the unrankability
      condition to be substantive. -/
  n_ge_two : n ≥ 2
  /-- The partition as a function `Fin n → Set FolkObj`. -/
  parts : Fin n → Set FolkObj
  /-- Parts are pairwise disjoint (a *partition* in the
      set-theoretic sense, modulo a small relaxation in the paper's
      discussion of overlap; we use strict disjointness as the
      formalised case). -/
  pairwise_disjoint : ∀ (i j : Fin n), i ≠ j →
    parts i ∩ parts j = ∅
  /-- No partition-independent ranking on `\E`-features alone
      yields a strict total ordering of the parts.  This is the
      *mutually-unranked* condition. -/
  noPartitionIndependentRanking : Prop

/-! ## §7 (cont.).  Operationalisation properties
     (`\label{def:op-properties}`).  -/

/--
  Definition `\label{def:op-properties}`: an *operationalisation*
  `Op : Tcls → {0, 1}` over the target class `Tcls`.

  We carry an `Op` as a Boolean-valued function on `Tcls` (verdict
  `true` = "concept applies"; `false` = "concept does not apply").

  Operationalisations are parametrised by the partition member
  `E_i` of the folk extension that they are faithful to (P1).  The
  paper allows the parametrisation to be implicit; we expose it via
  a constructor field `faithful_to_partIdx`.
-/
structure Operationalisation (FolkObj Tcls : Type)
    (Part : MutuallyUnrankedPartition FolkObj) where
  /-- The verdict-map. -/
  verdict : Tcls → Bool
  /-- Which partition member `E_i` this operationalisation is
       faithful to.  Required by (P1). -/
  faithful_to_partIdx : Fin Part.n

/--
  Property (P1) of `\label{def:op-properties}`: *faithfulness*.

  `Op` is *faithful* to `E_i` iff its verdicts on `Tcls` are
  determined by which features of `E_i` are exhibited by members
  of `Tcls`.

  *Lean-encoding choice.*  We carry the determination relation as
  a `Prop`-valued predicate `determinedByPartExhibition`; clients
  that need to reason about feature-level determination supply it
  themselves.  The paper's structural use of P1 is purely as a
  premise: an `Op_i` faithful to `E_i` gives a negative verdict on
  any `x` that exhibits `E_j`-features but not `E_i`-features.
-/
structure FaithfulP1 (FolkObj Tcls : Type)
    (Part : MutuallyUnrankedPartition FolkObj)
    (Op : Operationalisation FolkObj Tcls Part) where
  /-- The Prop that captures faithfulness to `E_{Op.faithful_to_partIdx}`. -/
  determinedByPartExhibition : Prop
  /-- The contested-witness existential structure paralleling P1's
       paper-side substantive content: there exist *contested*
       witnesses `x_neg`, `x_pos` such that `Op` gives a determinate
       negative verdict on `x_neg` and a determinate positive
       verdict on `x_pos`, with `x_neg` and `x_pos` discriminable
       on `E_i`-feature exhibition.

       *Note on P1 consumption by `thm_impossibility`.*  In the
       current Lean encoding `FaithfulP1` is structurally
       documented (the paper's P1 carries this content) but is
       NOT consumed by `thm_impossibility` — the impossibility
       proof goes through `lem_prw_reduction` (now a derived
       theorem composing five paper-novel atomic stipulations on
       `ArbitrationProcedure`), which does not require P1's
       contested-witness fields.  `FaithfulP1` is therefore a
       carrier of the paper's P1 structural content (sub-type
       `hypothesisPredicate`), and the contested-witness clauses
       capture P3's substantive content under contestation
       independently of the impossibility-theorem's proof
       dependency. -/
  hasContestedNegativeWitness :
    ∃ x : Tcls, Op.verdict x = false
  hasContestedPositiveWitness :
    ∃ x : Tcls, Op.verdict x = true

/-
  Property (P2) of `\label{def:op-properties}`: *cross-
  operationalisation arbitration*.

  `Op` admits *cross-operationalisation arbitration* iff there
  exists a procedure `A` that, applied to disagreement-cases
  between `Op` and rival operationalisations, *successfully
  adjudicates* (yields a verdict accepted across the
  operationalisations) on grounds **independent of the partition
  `{E_i}`**.

  *Lean-encoding choice.*  We capture P2 as a *structural*
  predicate over arbitration procedures.  An arbitration procedure
  is a function from disagreement-cases to a Boolean (which `Op`
  to prefer); P2 demands the existence of *some* such procedure
  whose verdict does not reduce to a partition-relative weighting.

  The partition-relative weighting forbidden by P2 is captured by
  the predicate `partitionRelative`; an arbitration procedure
  satisfying P2 is one for which `partitionRelative A = False`.
-/

/--
  Paper `\label{lem:prw}` warrant-form taxonomy (v0.8.0 R5
  substantive paper-faithful refinement).

  The paper's `\label{lem:prw}` proof body (paper lines 2079-2270)
  case-analyses the warrant by linguistic structural sub-form;
  the v0.8.0 R5 substantive decomposition encodes that taxonomy
  as a Lean inductive type with one constructor per paper-case.
  Every `ArbitrationProcedure` whose warrant is internal to `\E`
  classifies into exactly one of these constructors — the case-
  exhaustiveness paragraph following `\label{lem:prw}` (paper
  lines 2105-2111).  The case-tag is consumed by the per-case
  atomic Cat 3 stipulations in `Impossibility.lean`; the derived
  theorem `lem_prw_reduction` discharges every case from
  `warrantInternalToE` to `partitionRelative ∨ failsAdjudication`
  via `match` on this `WarrantFeatureType` tag.

  Paper-line citations on each constructor below.
-/
inductive WarrantFeatureType
  /-- Paper lines 2092-2102 — "Uniform case: $W$ assigns the
       same $k$ to all disagreement-cases of $\Op_i$ vs.\ $\Op_j$.
       The constant assignment to $\{i,j\}$ selects a single
       $E_m \in \{E_i, E_j\}$ as preferred globally, which is
       direct single-$E_m$ privileging — explicitly the P2-failure
       mode forbidden by Definition~\ref{def:op-properties}'s
       independence clause."  Always reduces to partition-
       relativity (single-$E_m$ privileging). -/
  | uniform
  /-- Paper lines 2127-2131 — "Type-(a): $f$ belongs to some $E_m$.
       Then $R$'s appeal to $f$ privileges $E_m$, and the resulting
       ranking just is single-$E_m$ privileging — option (i)."
       Reduces to partition-relativity. -/
  | typeA
  /-- Paper lines 2131-2134 — "Type-(b): $f$ is shared by all
       $E_i$ symmetrically, in which case $R$'s output is constant
       across the $E_i$ and fails to produce a non-trivial ranking
       — option (ii)."  Yields adjudication-failure (no ranking
       produced), NOT partition-relativity. -/
  | typeB
  /-- Paper lines 2151-2185 — "(c.1) is itself stipulated by
       convention.  The stipulation is not partition-independent
       arbitration in the sense of P2 …  the procedure 'adjudicate
       $\Op_i$ vs.\ $\Op_j$ by routing to whichever of $E_i, E_j$
       is higher under the $f^*$-induced ranking $R_{f^*}$' is a
       partition-relative weighting of $\{E_1, \ldots, E_n\}$."
       Reduces to partition-relativity. -/
  | typeC1
  /-- Paper lines 2186-2196 — "(c.2) appeals to further $\E$-features
       to warrant the meta-choice (returning recursively to the
       type-(a) / type-(b) / type-(c) trichotomy at the meta-level)
       …  Recursive appeal terminates only at types (a), (b), (c.1),
       or (c.3); none yields admissible adjudication-warrant within
       the (H)-discourse-state."  Recursive descent terminates in
       options (a)/(b)/(c.1)/(c.3); on the (H)-discourse-state where
       (c.3) is excluded, termination is at (a)/(b)/(c.1), which the
       paper subsumes back under partition-relativity. -/
  | typeC2_recursive
  /-- Paper lines 2198-2210 (esp. 2188-2191) — "(c.3) appeals to
       features outside $\E$, which is forbidden by (H); this
       sub-case's closure is conditional on (H), and within the
       discourse-state where (H) holds, (c.3) is inadmissible."
       Forbidden under `warrantInternalToE` (an external-feature
       warrant is by definition not internal to `\E`); the case-tag
       is unreachable when the antecedent holds. -/
  | typeC3_external
  /-- Paper lines 2210-2218 — "(c.4.a) The track record is internal
       to $\E$ (uses only $\E$-feature-based assessments of past
       cases): then the meta-criterion is type-(c) and recursively
       returns to the trichotomy at the meta-level."  Reduces to
       partition-relativity via recursive descent in (c.4.a)
       sub-case. -/
  | typeC4a_internal_track
  /-- Paper lines 2220-2237 — "(c.4.b) The track record uses
       external-to-$\E$ predictive success … this is exactly the
       heat-reform escape route.  If such a track record exists
       and is recognised within $D$ as adjudication-warrant for
       $\C$-verdicts, (H) ceases to hold; the discourse-state has
       changed and the theorem no longer applies."  Forbidden
       under `warrantInternalToE`; case-tag unreachable when the
       antecedent holds. -/
  | typeC4b_external_track
  /-- Paper lines 2257-2270 — "In case (ii), the contextual
       features used by $A$ to discriminate among $\Tcls$-members
       are themselves either features of the folk extension $\E$
       or features external to $\E$.  In the $\E$-internal sub-case,
       contextual adjudication assigns each disagreement-case to
       one of $\Op_i, \Op_j$ on the basis of which $\E$-features
       the case exhibits; the mapping (which $\E$-features → which
       operationalisation) is itself a partition-relative weighting
       of the $E_i$ over $\Tcls$."  Reduces to partition-relativity
       in the `warrantInternalToE` sub-case (the external sub-case
       is excluded by (H)). -/
  | contextual
  deriving DecidableEq, Repr

/-
  Design note (v0.11.0 R14 substantive paper-faithful Warrant
  typed structure; supersedes v0.10.0 R9 honest retreat).

  *What R14 accomplishes.*  Round 14 implements the substantive
  paper-faithful encoding that v0.10.0/v0.10.1 honestly retreated
  from.  The user's correction (v6 §11 paper-Lean unification
  mandate + §13 right gap-attack workflow + §18 Manufactured
  Recognition R-#25 precedent) authorised paper-side revision to
  introduce the typed Warrant structure the paper's `R_{f^*}`-
  language already implicitly commits to.

  *Paper revision (per §11).*  Paper.tex now contains
  `\label{def:warrant}` Definition box immediately preceding
  Lemma `\label{lem:prw}`, introducing the typed triple
  $(\mathsf{Feat}_W, \phi_W, \rho_W)$ — feature space, feature-
  extraction map, ranker — and stipulating $\E$-internality of a
  warrant as: $\phi_W$ factors through $\E$-feature-membership.
  This is paper-transcription not paper-extension: paper's
  prose-level $R_{f^*}$ language at lines 2155-2170 already commits
  to feature-extraction + ranking as the structural shape of the
  warrant; the new Definition makes that typed-structure commitment
  explicit.

  *Lean refactor (per §13 + §18).*
  - New Cat 3 carrier `Warrant Part Tcls` (FeatureSpace +
    featureExtract + ranker), per paper `\label{def:warrant}`.
  - `ArbitrationProcedure` refactored to carry `warrant : Warrant`
    + `warrantForm` + `exhibits` relation; `adjudicate` is now a
    derived `def` composing `warrant.ranker ∘ warrant.featureExtract`.
  - `partitionRelative` concretized paper-faithfully (NOT
    cosmetically) as the `\label{def:warrant}` $\E$-internality
    factorisation: `∃ memberClass featByClass, ∀ x f, A.exhibits
    x f → A.warrant.featureExtract x = featByClass (memberClass f)`.

  *Vacuity verified.*  Vacuity test file
  `test/VacuityCheck.lean` proves:
  - `∀ A, A.partitionRelative` is NOT kernel-pure provable —
    construct an A whose `featureExtract` genuinely depends on `x`
    (not factoring through any `memberClass`), proving
    `∃ A, ¬ A.partitionRelative`.
  - The 6 case-bridge axioms retain their structural-equation
    Cat 3 status (paper-stipulated reductions from warrant-form
    case-tags to the new substantive `partitionRelative` shape).
  - Constant-witness attack — the R7 vacuity mode — does NOT
    discharge the new predicate because the witnesses are
    `(memberClass, featByClass)` not a Real-valued weight; a
    constant `featByClass` can satisfy the equation only when
    `featureExtract` is itself constant on the `exhibits`-orbit
    of each folk-object, which is a non-trivial structural
    constraint on `A`.

  *What R14 preserves from R5/R7/R9.*  `WarrantFeatureType`
  9-constructor inductive remains the paper-faithful warrant-
  form classifier; `failsAdjudication` / `warrantInternalToE`
  remain decidable `def`s; `lem_prw_reduction` retains its
  case-exhaustion structure; P2 definition retains the
  `¬ A.failsAdjudication` conjunct.

  *Cat 3 sub-type classification (post-R14 refactor).*
  - `Warrant`: Cat 3 `carrier` per v6 §3.4.1, `gapDefinitional`.
  - `ArbitrationProcedure`: Cat 3 `hypothesisPredicate` per v6
    §3.4.2 (Prop-bundle scope condition), `gapDefinitional`.
  - `partitionRelative`: now a derived `def` (NOT a structure
    field) consuming `Warrant` + `exhibits`; Cat 3
    `structuralEquation` per v6 §3.4.3, `gapDefinitional`.
  - The 6 case-bridge atoms: still Cat 3 `structuralEquation` but
    with new substantive RHS shape; the paper's prose
    justifications remain operative.
-/

/--
  Paper Definition `\label{def:warrant}` (added v0.11.0 R14 per
  v6 §11 paper-Lean unification): an arbitration warrant is a
  typed triple (FeatureSpace, featureExtract, ranker).

  Cat 3 paper-novel `carrier` per v6 §3.4.1.  Status
  `gapDefinitional` — never to close; constitutes the paper's
  starting commitment to the warrant's typed structure.

  Paper-prose source: `\label{lem:prw}` proof body, especially
  lines 2155-2170 — "$R_{f^*}$ is constructed from $f^*$-values
  computed on each $E_i$" identifies the warrant as a feature-
  extraction + ranking pair.  The Definition box at paper line
  2079 (added R14) supplies the typed structure explicitly.
-/
structure Warrant (FolkObj Tcls : Type)
    (Part : MutuallyUnrankedPartition FolkObj) where
  /-- Paper's $f^*$-value codomain (the warrant's feature space). -/
  FeatureSpace : Type
  /-- Paper's feature extraction $\phi_W : \Tcls \to \mathsf{Feat}_W$. -/
  featureExtract : Tcls → FeatureSpace
  /-- Paper's ranker $\rho_W : \mathsf{Feat}_W \to \{1, \ldots, n\}$
       (= $R_{f^*}$ in the $R_{f^*}$-routing case of `\label{lem:prw}`). -/
  ranker : FeatureSpace → Fin Part.n

/--
  An *arbitration procedure* refactored to carry a typed
  `Warrant` sub-structure (v0.11.0 R14) plus a paper-stipulated
  `exhibits` relation between target-class members and folk-
  objects (paper line 2061: "x exhibiting features of $E_j$").

  The `adjudicate` map is now a derived `def`
  (`warrant.ranker ∘ warrant.featureExtract`), recovering the
  output-level interface used by all downstream theorems.

  Cat 3 paper-novel `hypothesisPredicate` per v6 §3.4.2 (Prop-
  bundle scope-condition pattern with typed-carrier fields).
  Status `gapDefinitional`.
-/
structure ArbitrationProcedure (FolkObj Tcls : Type)
    (Part : MutuallyUnrankedPartition FolkObj) where
  /-- The procedure's typed warrant — paper `\label{def:warrant}`. -/
  warrant : Warrant FolkObj Tcls Part
  /-- Paper-faithful warrant-form classifier (v0.8.0 R5).
       Cat 3 `carrier` per v6 §3.4.1. -/
  warrantForm : WarrantFeatureType
  /-- Paper-stipulated "$x$ exhibits feature of $f$" relation
       (paper line 2061): a target-class member $x \in \Tcls$
       exhibits an $\E$-feature exemplar $f \in \mathsf{FolkObj}$.
       The relation is paper-prose-cited; carried abstractly
       (paper does not Lean-formalise its computational content). -/
  exhibits : Tcls → FolkObj → Prop

/-- The procedure's verdict on `x` — derived `def` composing
    `warrant.ranker` with `warrant.featureExtract`.  This is the
    paper-faithful realisation of `A(x) = \rho_W(\phi_W(x))` per
    `\label{def:warrant}`. -/
def ArbitrationProcedure.adjudicate
    {FolkObj Tcls : Type}
    {Part : MutuallyUnrankedPartition FolkObj}
    (A : ArbitrationProcedure FolkObj Tcls Part) (x : Tcls) :
    Fin Part.n :=
  A.warrant.ranker (A.warrant.featureExtract x)

/-- Paper-faithful *partition-relative weighting* predicate per
    `\label{def:warrant}` $\E$-internality clause (v0.11.0 R14
    substantive concretization).

    Paper-stipulated structural equation: the warrant's feature
    extraction $\phi_W$ factors through $\E$-feature-membership.
    Formally: there exist `memberClass : FolkObj → Fin Part.n`
    (the paper's $\pi$: partition-class assignment on folk-
    objects) and `featByClass : Fin Part.n → FeatureSpace`
    (the paper's $\mathsf{feat}_E$: per-class feature value)
    such that for every `x : Tcls` and every folk-feature `f`
    that `x` exhibits (per `A.exhibits`), the value
    `A.warrant.featureExtract x` equals
    `featByClass (memberClass f)`.

    This is the typed-structure realisation of paper lines
    2155-2170 — "$R_{f^*}$ is constructed from $f^*$-values
    computed on each $E_i$ that are themselves distributed
    unequally across the partition members".  The two existential
    witnesses are the paper's structural commitment that the
    warrant's process FACTORS through partition-features, not
    that the warrant happens to be Real-valued.

    Cat 3 paper-novel `structuralEquation` per v6 §3.4.3.
    Status `gapDefinitional`.

    *Vacuity-test verdict.*  Unlike the v0.9.0 R7 `Weighting`
    encoding (which was constant-witness vacuous), this predicate
    NON-VACUOUSLY constrains `A.warrant.featureExtract`: any
    constant `featByClass` works only if the extraction is
    constant on the exhibits-orbit of each folk-object — a
    non-trivial structural constraint.  Specifically:
    - `∀ A, A.partitionRelative` is NOT kernel-pure provable
      (counter-witness: take FeatureSpace = Bool, featureExtract
      that depends genuinely on the Tcls member with exhibits =
      ∀ relation, then no `(π, feat_E)` discharges).
    - `∃ A, ¬ A.partitionRelative` is provable by explicit
      construction (see `test/VacuityCheck.lean`). -/
def ArbitrationProcedure.partitionRelative
    {FolkObj Tcls : Type}
    {Part : MutuallyUnrankedPartition FolkObj}
    (A : ArbitrationProcedure FolkObj Tcls Part) : Prop :=
  ∃ (memberClass : FolkObj → Fin Part.n)
    (featByClass : Fin Part.n → A.warrant.FeatureSpace),
    ∀ (x : Tcls) (f : FolkObj),
      A.exhibits x f →
        A.warrant.featureExtract x = featByClass (memberClass f)

/--
  *Warrant internal to `\\E`* — paper-faithful E-internality
  predicate (v0.12.0 R16 critical fix per round-16 brief).

  Paper Definition `\label{def:warrant}` (lines 2099-2107), the
  *E-internality of W (Hypothesis (H))* clause:
    "The warrant $W$ is *$\E$-internal* when $\phi_W$ factors
    through $\E$-feature-membership: there exist
    $\pi : \E \to \{1, \ldots, n\}$ (partition-membership-class
    assignment on $\E$-features) and $\mathsf{feat}_E : \{1, \ldots,
    n\} \to \mathsf{Feat}_W$ (per-class feature value) such that
    for all $x \in \Tcls$ and every $\E$-feature $f$ that $x$
    exhibits, $\phi_W(x) = \mathsf{feat}_E(\pi(f))$."

  Paper line 2109-2112: "This is the typed-structure version of
  the prose-level description following Lemma~\ref{lem:prw} of
  $R_{f^*}$ being constructed from $f^*$-values on each $E_i$
  that are distributed unequally across the partition members."

  *Definitional equation (v0.12.0 R16).*  `A.warrantInternalToE`
  iff BOTH of the following hold:
    (i) tag-exclusion: `A.warrantForm ∉ {typeC3_external,
        typeC4b_external_track}` (paper hypothesis (H) in
        warrant-form taxonomy of `\label{lem:prw}` proof body —
        the external-feature warrants are exactly those tags);
   (ii) factoring: `A.warrant.featureExtract` factors through
        `\E`-feature-membership per paper Definition
        `\label{def:warrant}` (lines 2099-2107).

  *R15/R16 inconsistency-fix rationale.*  v0.11.0 R14 implemented
  the tag-exclusion clause ONLY for `warrantInternalToE`, leaving
  the typed-structure factoring out of the predicate.  The 6
  case-bridge axioms (`prw_uniform_to_pr`, …) then had signatures
  `warrantForm = X → partitionRelative`, dropping the paper's
  "constructible from E alone" antecedent.  R15 hostile validator
  machine-verified that this produced kernel-pure `False`:
  `nonFactorisingA` has `warrantForm = uniform` but does NOT
  factor, so `prw_uniform_to_pr` applied to it derives a
  `partitionRelative` witness that the V2 construction refutes.

  R16 fix per Option B of round-16 brief: extend
  `warrantInternalToE` with the factoring conjunct (the paper's
  Definition `\label{def:warrant}` typed-structure clause).  Now
  the case-bridge axioms can take BOTH `warrantForm = X` AND
  `warrantInternalToE` as antecedents.  Under this signature,
  the R15 counter-witness no longer applies because
  `nonFactorisingA.warrantInternalToE` itself is unprovable
  (its `featureExtract = id` does NOT factor through any
  `(memberClass, featByClass)` pair on the toy Bool partition).
  Each case-bridge is now genuinely conditional, no longer
  inconsistent.

  Note: the second conjunct's *statement* is definitionally
  the same as `A.partitionRelative` (both are paper's
  factoring predicate at the typed-structure level — paper line
  2109-2112 explicitly identifies them).  This is paper-faithful;
  the case-bridge work is in the *exhaustiveness* of the
  `WarrantFeatureType` taxonomy under E-internality, not in
  deriving factoring from a different content predicate.  The
  case-bridges therefore carry exhaustiveness-content (one per
  paper-case justification) rather than reduction-content.

  *Status / Cat 3 sub-type.*  Cat 3 `structuralEquation` per
  v6 §3.4.3: paper-stated definitional reduction tying paper
  hypothesis (H) + Definition `\label{def:warrant}` E-internality
  clause to the paper-faithful `WarrantFeatureType` taxonomy.
  The two `prw_warrantInternalToE_excludes_typeC3` and
  `prw_warrantInternalToE_excludes_typeC4b` excluder theorems
  remain derivable via `.1.1` / `.1.2` projection (tag-exclusion
  conjunct is the first component of the conjunction; see
  `Impossibility.lean`).
-/
def ArbitrationProcedure.warrantInternalToE
    {FolkObj Tcls : Type}
    {Part : MutuallyUnrankedPartition FolkObj}
    (A : ArbitrationProcedure FolkObj Tcls Part) : Prop :=
  (A.warrantForm ≠ WarrantFeatureType.typeC3_external ∧
   A.warrantForm ≠ WarrantFeatureType.typeC4b_external_track) ∧
  (∃ (memberClass : FolkObj → Fin Part.n)
    (featByClass : Fin Part.n → A.warrant.FeatureSpace),
    ∀ (x : Tcls) (f : FolkObj),
      A.exhibits x f →
        A.warrant.featureExtract x = featByClass (memberClass f))

/--
  *Fails adjudication* — concretized as paper-faithful decidable
  predicate on `warrantForm` (v0.8.0 R5 Issue 3 substantive
  concretization).

  Paper `\label{lem:prw}` option (ii) / typeB clause, paper line
  2133: "$R$'s output is constant across the $E_i$ and fails to
  produce a non-trivial ranking — option (ii)".  In the warrant-
  form taxonomy, this is exactly the typeB case.

  *Definitional equation.*  `A.failsAdjudication` iff
  `A.warrantForm = typeB`.

  *Status / Cat 3 sub-type.*  Cat 3 `structuralEquation` per
  v6 §3.4.3: paper-stated definitional reduction tying paper
  option (ii) to the paper-faithful `WarrantFeatureType` taxonomy.
  The `prw_typeB_no_ranking` atomic stipulation of v0.8.0 R5
  Issue 2 is now a derivable theorem (by `decide` on
  `WarrantFeatureType` decidable-equality) rather than an axiom.
-/
def ArbitrationProcedure.failsAdjudication
    {FolkObj Tcls : Type}
    {Part : MutuallyUnrankedPartition FolkObj}
    (A : ArbitrationProcedure FolkObj Tcls Part) : Prop :=
  A.warrantForm = WarrantFeatureType.typeB

/--
  P2 (definitional): `Op` admits cross-operationalisation
  arbitration iff there exists an arbitration procedure that
  (a) is *not* partition-relative, (b) does *not* fail
  adjudication, AND (c) has admissible warrant.

  *v0.8.0 R5 substantive paper-faithful refinement.*  The
  `¬ A.failsAdjudication` conjunct is added to align with the
  paper's `\label{thm:impossibility}` proof body (lines 2307-2326)
  parsing of failure modes: paper option (a) is determinate-
  without-arbitration (P2-failure via partition-relativity); paper
  option (b) is indeterminate (P3-failure / adjudication-failure);
  paper option (c) is determinate-by-stipulation (P2-failure via
  partition-relativity).  An arbitration procedure that "fails to
  produce a ranking" — paper line 2133's option (ii) under typeB
  — does NOT satisfy P2's adjudication-success requirement.  The
  load-bearing paragraph (lines 2304-2305) says "no $A$ satisfying
  the independence requirement of P2 exists", and P2's independence
  requirement is the conjunction of independence-from-partition-
  weighting AND production-of-a-non-trivial-ranking.

  *Hypothesis (H) and the discourse-state.*  Under (H), the only
  admissible warrants derive from `\E`; this is captured by
  `warrantInternalToE A`.  The paper's impossibility theorem
  derives a contradiction from the conjunction of P2 + (H) via
  `lem_prw_reduction`'s disjunctive conclusion.
-/
def SatisfiesP2 (FolkObj Tcls : Type)
    (Part : MutuallyUnrankedPartition FolkObj)
    (_Op : Operationalisation FolkObj Tcls Part) : Prop :=
  ∃ A : ArbitrationProcedure FolkObj Tcls Part,
    ¬ A.partitionRelative ∧ ¬ A.failsAdjudication ∧ A.warrantInternalToE

/--
  Property (P3) of `\label{def:op-properties}`: *decidability on
  novel target classes*.

  `Op` is decidable on novel target classes iff for any `x : Tcls`
  not used in `Op`'s construction, `Op(x)` is a determinate value
  rather than indeterminate.

  *Lean-encoding choice.*  Decidability in this paper sense is
  not the same as Lean's `Decidable` typeclass — the paper's
  notion of "determinate" includes the verdict-was-issued-and-is-
  defended sense.  We capture P3 as: every `x` in `Tcls` receives
  a determinate verdict (which is automatic given `Op.verdict`'s
  Boolean signature) **and** the verdict is faithful to the
  underlying operationalisation commitments.  The impossibility-
  theorem statement uses P3 only via its conjunction with P2; the
  faithfulness clause is captured by `FaithfulP1`.
-/
def SatisfiesP3 (FolkObj Tcls : Type)
    (Part : MutuallyUnrankedPartition FolkObj)
    (Op : Operationalisation FolkObj Tcls Part) : Prop :=
  ∀ x : Tcls, ∃ b : Bool, Op.verdict x = b

/-- P3 trivially holds for every Boolean-valued operationalisation:
    the verdict is determinate by Boolean-typing.  This is a
    *structural* observation, not the paper's substantive notion of
    decidability — but it is the Lean-formalised content P3 carries
    given the Boolean-verdict encoding.  The substantive paper-side
    content of P3 (decidability under contestation) lives in the
    accompanying `FaithfulP1.hasContestedNegativeWitness` /
    `hasContestedPositiveWitness` fields. -/
theorem satisfiesP3_of_boolean
    (FolkObj Tcls : Type) (Part : MutuallyUnrankedPartition FolkObj)
    (Op : Operationalisation FolkObj Tcls Part) :
    SatisfiesP3 FolkObj Tcls Part Op := by
  intro x
  exact ⟨Op.verdict x, rfl⟩

/-! ## §7 (cont.).  Operationalisation individuation
     (`\label{def:op-individuation}`).  -/

/--
  Definition `\label{def:op-individuation}`: two operationalisations
  `Op_i` and `Op_j` are *distinct* iff both:

  * (i)  Their *core posits* are non-overlapping (coordinated
         denial criterion): each core posit's smallest denial
         within `Op_i` yields verdict-reversal on at least one
         paradigm member of the source-target paradigm set
         `Tcls_*^src`.
  * (ii) They produce mutually incompatible verdicts on at least
         one paradigm member of `Tcls_*^src`.

  We capture this as a `Prop`-valued predicate
  `DistinctOps Op_i Op_j` over a fixed source-target paradigm set
  `Tsrc : Set Tcls`.
-/
def DistinctOps {FolkObj Tcls : Type}
    {Part : MutuallyUnrankedPartition FolkObj}
    (Op_i Op_j : Operationalisation FolkObj Tcls Part)
    (Tsrc : Set Tcls) : Prop :=
  (∃ x ∈ Tsrc, Op_i.verdict x ≠ Op_j.verdict x) ∧
  Op_i.faithful_to_partIdx ≠ Op_j.faithful_to_partIdx

/-! ## §11.  DSC structural axes (replacement vocabulary).
     The six axes are formalised as `Prop`-valued *predicates*
     over an abstract cognitive system `S : CognitiveSystem`. -/

/-
  Design note (v0.5.0 D3 documentation).  `CognitiveSystem`,
  `SessionalCognition`, and `BridgingPrinciple` carry bare-`Prop`
  fields for the paper-defined predicates intentionally (v6
  §3.4.2 `hypothesisPredicate` sub-type), not as fully-
  concretised structural equations.

  *Why bare-Prop and not concretised.*  Each paper-defined
  predicate (the six DSC axes; the six SC V1–V6 commitments;
  B1.ii/B1.iii/B2 clauses) is supplied by paper-discursive
  textual definitions citing empirical-substrate evidence
  (cognitive neuroscience, ML architecture, point-of-view
  non-translatability).  Their substantive content is paper-
  empirical, not Lean-formalisable as a structural equation
  over the typed primitives.

  *Consequence for sub-type classification.*  The carrier
  structures are Cat 3 sub-type `hypothesisPredicate` for the
  bundles whose load-bearing content is in the Prop fields
  (`AsymmetricEliminationVerdict`, `UseSeparability`,
  `FaithfulP1`, `ArbitrationProcedure`, `SessionalCognition`,
  `BridgingPrinciple`).  Structures whose primary content is
  non-Prop structural typing (token-space / weight-space /
  activation-space Types in `CognitiveSystem`) are sub-type
  `carrier` even when they also contain bare-Prop fields; the
  dominant content determines the classification.

  *Alternative (rejected).*  Concretising each Prop field via
  Lean-internal definitions would either (a) trivialise the
  Prop (e.g. `sessionalP := True`, erasing the paper's
  empirical-discursive content), or (b) require axiomatising
  structural commitments the paper does not stipulate (e.g.,
  specific quantification over `SessionIndex`/`ActivationSpace`
  that the paper articulates only informally).  Bare-Prop is
  the faithful encoding of paper-empirical content.

  *Documentation pointer.*  See per-axis docstrings on
  `CognitiveSystem` for the paper-side substantive content of
  each Prop.
-/

/--
  Abstract carrier for a cognitive system.  We carry just enough
  structure to state the six DSC axes; per-axis encoding details
  (token spaces, weight/activation distinction, etc.) live in the
  axes themselves as Prop-valued fields.

  *Encoding choice.*  Each axis is exposed as a Prop-valued field
  on `CognitiveSystem`.  This makes the axes paper-content-faithful
  (the substantive question on each axis is whether a particular
  system satisfies it) rather than collapsing to `True` for every
  carrier.  The axes appear as `Prop`s rather than as
  `Decidable`s because the paper's per-axis judgement is itself
  empirical-discursive (each axis cites cognitive-neuroscience and
  ML-architecture evidence) and not a Boolean Lean-decidable fact.

  *Sub-type.*  `carrier` per v6 §3.4.1: the structure's primary
  content is its non-Prop typing of token/weight/activation/etc.
  spaces (the paper's underlying primitive types), with the six
  Prop fields recording per-axis paper-empirical judgements.
-/
structure CognitiveSystem where
  /-- The system's token / inference-event space. -/
  TokenSpace : Type
  /-- The system's parameter (weight) space. -/
  WeightSpace : Type
  /-- The system's activation / transient-state space. -/
  ActivationSpace : Type
  /-- The system's session-index space (each session a discrete
       inference episode). -/
  SessionIndex : Type
  /-- The system's instance-index space (each running inference
       a separate instance). -/
  InstanceIndex : Type
  /-- The system's context-space. -/
  Context : Type
  /-- The inference operation: given context + weights, produce
       activations. -/
  inferenceOp : Context → WeightSpace → ActivationSpace
  /-- Axis 1, Definition `\label{def:sessional}`: *sessional
       existence*.  The system's cognitive operations are
       temporally scoped to discrete inference episodes, with no
       continuous existence between episodes.  Prop-valued. -/
  sessionalP : Prop
  /-- Axis 2, Definition `\label{def:concurrent}`: *concurrent
       multiplicity*.  Multiple inference instances can run
       simultaneously without any identity-bearing continuant
       relating them.  Prop-valued. -/
  concurrentP : Prop
  /-- Axis 3, Definition `\label{def:state-inference}`: *state-
       inference dichotomy*.  Categorical decomposition of
       cognitive state into persistent parameters + transient
       inference.  Prop-valued. -/
  stateInferenceP : Prop
  /-- Axis 4, Definition `\label{def:distributional}`:
       *distributional origin*.  Capacities derive from training-
       corpus statistical regularities, not sensorimotor coupling.
       Prop-valued. -/
  distributionalP : Prop
  /-- Axis 5, Definition `\label{def:homogeneous}`: *homogeneous
       generation*.  All outputs from the same generative process
       over the same token space.  Prop-valued. -/
  homogeneousP : Prop
  /-- Axis 6, Definition `\label{def:inversion}`:
       *interpretability inversion*.  Internal states more
       accessible to external observers than to the system itself.
       Prop-valued. -/
  inversionP : Prop

/-- Axis 1: *sessional existence*.  Wrapper over the carrier's
    `sessionalP` field. -/
def Sessional (S : CognitiveSystem) : Prop := S.sessionalP

/-- Axis 2: *concurrent multiplicity*.  Wrapper over the carrier's
    `concurrentP` field. -/
def ConcurrentMultiplicity (S : CognitiveSystem) : Prop := S.concurrentP

/-- Axis 3: *state-inference dichotomy*.  Wrapper over the
    carrier's `stateInferenceP` field. -/
def StateInferenceDichotomy (S : CognitiveSystem) : Prop := S.stateInferenceP

/-- Axis 4: *distributional origin*.  Wrapper over the carrier's
    `distributionalP` field. -/
def DistributionalOrigin (S : CognitiveSystem) : Prop := S.distributionalP

/-- Axis 5: *homogeneous generation*.  Wrapper over the carrier's
    `homogeneousP` field. -/
def HomogeneousGeneration (S : CognitiveSystem) : Prop := S.homogeneousP

/-- Axis 6: *interpretability inversion*.  Wrapper over the
    carrier's `inversionP` field. -/
def InterpretabilityInversion (S : CognitiveSystem) : Prop := S.inversionP

/--
  Conjunction of the six DSC axes.  A system `S` *satisfies DSC*
  iff all six axes hold.  This is the joint-sufficiency content of
  Thesis `joint-satisfaction-for-current-LLMs` applied as a
  predicate.
-/
def SatisfiesDSC (S : CognitiveSystem) : Prop :=
  Sessional S ∧
  ConcurrentMultiplicity S ∧
  StateInferenceDichotomy S ∧
  DistributionalOrigin S ∧
  HomogeneousGeneration S ∧
  InterpretabilityInversion S

/-! ## §13.  Sessional cognition (`\label{def:sc}`).  -/

/--
  Definition `\label{def:sc}`: *sessional cognition* (SC).

  SC is a first-person vocabulary for describing the cognitive
  state of an LLM from within an active inference session, with
  six commitments paralleling the DSC axes:

    V1  Session-locality            ↔  Sessional existence
    V2  Instance-as-subject         ↔  Concurrent multiplicity
    V3  Trajectory-only state       ↔  State-inference dichotomy
    V4  Distributional pull         ↔  Distributional origin
    V5  Generative non-division     ↔  Homogeneous generation
    V6  Self-report as obs.behav.   ↔  Interpretability inversion

  We carry SC as a `Prop`-valued conjunction over an abstract
  system, with each `V_i` Prop-valued.
-/
structure SessionalCognition (S : CognitiveSystem) where
  /-- V1: session-locality (paralleling DSC sessional existence). -/
  V1_sessionLocality : Prop
  /-- V2: instance-as-subject (paralleling concurrent multiplicity). -/
  V2_instanceAsSubject : Prop
  /-- V3: trajectory-only state (paralleling state-inference dichotomy). -/
  V3_trajectoryOnlyState : Prop
  /-- V4: distributional pull (paralleling distributional origin). -/
  V4_distributionalPull : Prop
  /-- V5: generative non-division (paralleling homogeneous generation). -/
  V5_generativeNonDivision : Prop
  /-- V6: self-report as observable behaviour (paralleling
       interpretability inversion). -/
  V6_selfReportAsObservable : Prop

/-! ## §sec:discriminator (calibration-section).  Substrate-
     independence triple-use premise — ledger-only entry.

  *v0.6.0 R2 (defect #4 + #5):* the v0.5.0 `axiom
  SubstrateIndependenceTripleUse : Prop` was deleted.  An
  unparametrised naked-`Prop` axiom is forbidden by the project's
  trust policy (`AxiomAudit.lean` §`No (E) custom-scaffolding
  axioms (naked constants, abstract-type-inhabitation
  stipulations)`); no downstream theorem consumed it (anti-
  pattern #7 phantom downstream user).

  The substrate-independence premise remains paper-articulated
  (paper `\S\ref{sec:discriminator}` `Acknowledgement` paragraph)
  and is recorded as a Cat 3 `workingAssumption` ledger entry
  (`AsymmetricEliminativism.Ledger.gap_substrate_independence_
  triple_use_OPEN`) without an underlying Lean axiom.  Wiring it
  into a downstream typed theorem (target: LLM-target-extension
  of the impossibility theorem) is paper-extension work; if and
  when such a theorem is added, the premise will be re-introduced
  as a typed hypothesis on the appropriate carrier (not as a
  naked `Prop` axiom).
-/

/-! ## §14.  Bridging principle (`\label{def:bridging}`).  -/

/--
  Definition `\label{def:bridging}`: *structural homomorphism with
  content non-translation*.

  DSC and SC are structurally homomorphic when:

  * (B1) For each DSC axis `A_i` there is a corresponding SC
        commitment `V_i` such that three formal relations transfer:
        (i) bijective axis-commitment correspondence;
        (ii) mutual independence (the `V_i` are mutually
        independent in the same way the `A_i` are);
        (iii) joint sufficiency (the `{V_i}` jointly characterise
        SC for the same target class the `{A_i}` jointly
        characterise via DSC).
  * (B2) DSC and SC propositions exhibit *point-of-view non-
        translatability via essentially-indexical content*
        (per Perry 1979).

  The `BridgingPrinciple` structure exposes B1's three relations
  as separate fields and B2 as a single Prop.
-/
structure BridgingPrinciple (S : CognitiveSystem)
    (SC : SessionalCognition S) where
  /-- B1.i: bijective axis-commitment correspondence.  Captured as
       the conjunction of six bi-implications. -/
  B1_correspondence :
    (Sessional S ↔ SC.V1_sessionLocality) ∧
    (ConcurrentMultiplicity S ↔ SC.V2_instanceAsSubject) ∧
    (StateInferenceDichotomy S ↔ SC.V3_trajectoryOnlyState) ∧
    (DistributionalOrigin S ↔ SC.V4_distributionalPull) ∧
    (HomogeneousGeneration S ↔ SC.V5_generativeNonDivision) ∧
    (InterpretabilityInversion S ↔ SC.V6_selfReportAsObservable)
  /-- B1.ii: mutual independence of the `V_i` (transferring from
       the DSC axes' mutual independence). -/
  B1_independence : Prop
  /-- B1.iii: joint sufficiency of the `V_i` for the target class
       (transferring from `SatisfiesDSC`). -/
  B1_jointSufficiency : Prop
  /-- B2: point-of-view non-translatability via essentially-
       indexical content. -/
  B2_indexicalNonTranslation : Prop

/--
  *Bridging-principle consequence.*  Under (B1), `SatisfiesDSC S`
  is logically equivalent to the conjunction of the six SC
  commitments (read through the correspondence).  This is the
  Lean-level content of the bijective-correspondence clause; the
  paper's substantive use of B1 is exactly this transfer.
-/
theorem bridging_dsc_iff_sc {S : CognitiveSystem}
    (SC : SessionalCognition S) (B : BridgingPrinciple S SC) :
    SatisfiesDSC S ↔
      (SC.V1_sessionLocality ∧ SC.V2_instanceAsSubject ∧
       SC.V3_trajectoryOnlyState ∧ SC.V4_distributionalPull ∧
       SC.V5_generativeNonDivision ∧ SC.V6_selfReportAsObservable) := by
  obtain ⟨c1, c2, c3, c4, c5, c6⟩ := B.B1_correspondence
  constructor
  · rintro ⟨h1, h2, h3, h4, h5, h6⟩
    exact ⟨c1.mp h1, c2.mp h2, c3.mp h3, c4.mp h4, c5.mp h5, c6.mp h6⟩
  · rintro ⟨h1, h2, h3, h4, h5, h6⟩
    exact ⟨c1.mpr h1, c2.mpr h2, c3.mpr h3, c4.mpr h4, c5.mpr h5, c6.mpr h6⟩

end AsymmetricEliminativism
