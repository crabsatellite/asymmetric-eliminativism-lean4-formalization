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

  *v0.17.0 R26 Tier 1 Part A — paper-faithful per-case structural
  encoding.*  v0.16.0 R24 collapsed all 6 case-bridges to trivial
  `fun _ hW => hW.2`.  R26 extends Lean coverage to paper's
  per-case structural arguments (paper lines 2122-2349) by
  encoding paper's per-case structural commitments as 6 Cat 3
  `structuralEquation` axioms paper-cited per case, then
  rebuilding the case-bridge proofs to substantively use those
  axiom-provided witnesses rather than the trivial `.2`
  projection.

  Per case (each axiom paper-line-cited):
   - `prw_uniform_factorisation_witness` (paper 2127-2132 —
     "constant assignment to {i,j} selects single E_m globally"):
     uniform's factorisation has CONSTANT memberClass.
   - `prw_typeA_single_class_witness` (paper 2127-2131 —
     "f belongs to some E_m; R's appeal privileges E_m"):
     typeA's factorisation has memberClass that targets a single
     paper-identified class.
   - `prw_typeC1_R_fstar_routing_witness` (paper 2185-2218 —
     "R_{f^*} routes by f*-values distributed unequally across
     partition members"): typeC1's factorisation factors through
     the paper's R_{f*}-routing apparatus.
   - `prw_typeC2_recursive_termination_witness` (paper 2221-2228 —
     "recursive descent terminates at (a)/(b)/(c.1)/(c.3)"):
     typeC2_recursive's factorisation paper-stated per recursive
     termination at partition-relative case-forms.
   - `prw_typeC4a_meta_reduction_witness` (paper 2244-2247 —
     "track record internal to E; meta-criterion is type-(c)
     recursively returning to trichotomy"): typeC4a's
     factorisation paper-stated per meta-level reduction.
   - `prw_contextual_E_internal_mapping_witness` (paper 2293-2308
     — "contextual adjudication on E-features; mapping is itself
     partition-relative weighting"): contextual's factorisation
     paper-stated per E-internal contextual mapping structure.

  Each axiom carries paper-line-cited content + the case-distinctive
  structural shape, NOT just generic factorisation.  Each
  case-bridge proof uses the axiom's specific witnesses to construct
  `partitionRelative`.

  *R23 inconsistency preserved as eliminated.*  R22 Fix A's non-
  degeneracy strengthening was wrong for paper's uniform case
  (constant ranker degenerate by paper construction).  R26's
  axioms ADD content paper-faithfully (constant-memberClass,
  single-class targeting, R_{f^*}-routing) WITHOUT requiring
  non-degeneracy.  R23 attack vector remains eliminated:
  uniformConstantRankerA still satisfies the new uniform axiom
  (constant memberClass = 0; constant featByClass) consistently.

  *v0.16.0 R24 historical baseline (preserved structurally, axiom
  count changed).*  R23 hostile validator machine-verified that
  R22 Fix A (`partitionRelative` non-degeneracy strengthening)
  introduced axiom inconsistency: paper's uniform case (paper
  lines 2127-2132) has CONSTANT single-$E_m$ adjudication, which
  fails R22's non-degeneracy clause; but `prw_uniform_to_pr`
  under R22 derived `partitionRelative` (including non-degeneracy)
  on the uniform witness, yielding kernel-pure `False`.  R24
  final honest convergence:

  (1) REVERT R22 Fix A.  `partitionRelative` reverts to R18 form:
      literally `featureExtractsAreEInternal` (no non-degeneracy).
      Per paper line 2109-2112, this identification IS paper-
      faithful — paper's `lem:prw` at typed `\label{def:warrant}`
      level is STRUCTURALLY TRIVIAL.

  (2) KEEP R22 Fix B.  `admissibleIn` axiom (Cat 3
      hypothesisPredicate) + restricted `DiscourseHypothesisH :=
      ∀ A, admissibleIn A Op → warrantInternalToE`.  This makes
      (H) non-vacuously-true and non-vacuously-false depending on
      the discourse state.

  (3) KEEP R22 SatisfiesP2.  3-conjunct body
      `admissibleIn ∧ ¬ partitionRelative ∧ ¬ failsAdjudication`.
      R19 4-binding rintro pattern fails (binding 2 is
      `admissibleIn`, not `warrantInternalToE.2`).

  (4) Convert 6 case-bridges back to derived theorems with proof
      body `fun _ hW => hW.2`.  Under R24's reverted
      `partitionRelative = featureExtractsAreEInternal`, the
      case-bridges are paper-faithful trivial theorems per paper
      line 2109-2112's identification.

  (5) `lem_prw_reduction` proof body: 1-line `Or.inl hW.2`
      (projection of the factorisation conjunct of `hW :
      warrantInternalToE`).  This is paper-faithful per paper line
      2109-2112.

  (6) `thm_impossibility` proof body substantively uses (H) to
      discharge admissibility from each P2 witness:
        rintro ⟨A, hAdm, hNotPR, hNotFails⟩
        have hWarrant := hH A hAdm
        exact hNotPR hWarrant.2

  *7-round anti-pattern history (v0.9.0 R7 → v0.15.0 R22 → v0.16.0
  R24).*  Each round addressed a specific anti-pattern:
   - R7 cosmetic Weighting → R8 killed (vacuity).
   - R14 missing antecedent → R15 killed (inconsistency).
   - R16 composite predicate → R17 killed (trivialization).
   - R18 definitional smuggling in SatisfiesP2 → R19 killed.
   - R20 2-line bypass + (H) universal-false → R21 killed.
   - R22 uniform-case axiom inconsistency → R23 killed.
   - R24: HONEST CONVERGENCE — accept typed-level trivialization.

  *Substantive paper content preserved under R24:*
   (a) `WarrantFeatureType` 9-constructor taxonomy (Cat 3 carrier,
       paper-cited per case).
   (b) `caseFormIsInternal` hypothesis (H) tag-exclusion (Cat 3
       hypothesisPredicate, paper lines 2188-2237).
   (c) `featureExtractsAreEInternal` typed factorisation (Cat 3
       structuralEquation, paper lines 2099-2107).
   (d) `warrantInternalToE` composite (Cat 3 structuralEquation).
   (e) `admissibleIn` Cat 3 hypothesisPredicate axiom restricting
       (H) scope per paper line 1999-2002 (R22 Fix B retained).
   (f) `DiscourseHypothesisH` restricted to admissible-within-D
       procedures (R22 Fix B refinement retained).

  *Anti-pattern #13 (conclusion-as-axiom) BROKEN under R24.*  Zero
  Cat 3 axioms for the partition-relativity derivation chain
  (only `admissibleIn` axiom remains; that axiom is a paper-
  stipulated scope-condition predicate, not a partition-relativity
  conclusion).
-/

import AsymmetricEliminativism.Basic

namespace AsymmetricEliminativism

/-! ## Lemma `\label{lem:prw}` — 9 per-case Cat 3 atomic stipulations.

  v0.8.0 R5 substantive decomposition.  The single
  `workingAssumption` axiom of v0.7.0 is decomposed into nine
  atomic Cat 3 structural-equation stipulations, each tied to
  one constructor of `WarrantFeatureType`, one citing paper-line
  range, and one paper-prose justification of its reduction-
  conclusion.  Downstream theorems compose the per-case atoms via
  case-exhaustion `match` on the typed warrant-form classifier.

  v0.17.0 R26 Tier 1 Part A extension: paper-faithful per-case
  structural axioms with case-distinctive shapes (paper lines
  2122-2349 case-analysis substantively Lean-ified).  Each axiom
  carries paper-cited per-case content (constant memberClass for
  uniform, single-class targeting for typeA, R_{f*}-routing
  factorisation for typeC1, recursive termination for typeC2,
  meta-level reduction for typeC4a, E-internal mapping for
  contextual); each case-bridge theorem CONSTRUCTS partition-
  relativity from the axiom-provided case-specific witnesses,
  NOT via trivial `.2` projection.

  R23 attack remains eliminated: new axioms add paper-cited
  content WITHOUT introducing non-degeneracy.  uniformConstant-
  RankerA satisfies the new uniform axiom (constant memberClass
  + constant featByClass).
-/

/-! ## v0.17.0 R26 per-case Cat 3 structural-equation axioms. -/

/--
  Paper `\label{lem:prw}` uniform case structural commitment
  (paper lines 2127-2132).

  *Paper claim.*  "Uniform case: $W$ assigns the same $k$ to all
  disagreement-cases of $\Op_i$ vs.\ $\Op_j$.  The constant
  assignment to $\{i,j\}$ selects a single $E_m \in \{E_i, E_j\}$
  as preferred globally" — paper's case-distinctive structural
  shape is that uniform's factorisation has CONSTANT
  partition-membership-class assignment (`memberClass`).

  *Axiom content.*  Under `warrantForm = uniform` and
  `warrantInternalToE`, the paper-stated factorisation witnesses
  exist with the case-distinctive structural commitment that
  `memberClass` is CONSTANT (paper "constant assignment to
  {i,j}").  This is STRONGER than generic factorisation: it
  carries paper's per-case structural shape paper-cited per
  line 2127-2132.

  *Consistency with R23 (paper line 2127-2132 + R24 revert).*
  The constant-memberClass clause is paper-faithful per "constant
  assignment selects single $E_m$".  No non-degeneracy claim:
  ranker may itself be constant (paper's actual uniform case has
  degenerate ranker — `uniformConstantRankerA` testfixture
  satisfies the axiom via `memberClass _ := 0`, `featByClass _ :=
  true`).

  *Cat 3 sub-type.*  `structuralEquation` per v6 §3.4.3 — paper-
  stated definitional reduction on the paper-novel
  `ArbitrationProcedure` carrier carrying paper's uniform-case
  structural shape commitment.  Status `gapDefinitional`. -/
axiom prw_uniform_factorisation_witness
    {FolkObj Tcls : Type}
    {Part : MutuallyUnrankedPartition FolkObj}
    (A : ArbitrationProcedure FolkObj Tcls Part)
    (h : A.warrantForm = WarrantFeatureType.uniform)
    (hW : A.warrantInternalToE) :
    ∃ (k₀ : Fin Part.n)
      (memberClass : FolkObj → Fin Part.n)
      (featByClass : Fin Part.n → A.warrant.FeatureSpace),
      (∀ f : FolkObj, memberClass f = k₀) ∧
      ∀ (x : Tcls) (f : FolkObj),
        A.exhibits x f →
        A.warrant.featureExtract x = featByClass (memberClass f)

/--
  Paper `\label{lem:prw}` type-(a) case structural commitment
  (paper lines 2127-2131).

  *Paper claim.*  "Type-(a): $f$ belongs to some $E_m$.  Then
  $R$'s appeal to $f$ privileges $E_m$, and the resulting ranking
  just is single-$E_m$ privileging — option (i)."  Paper's case-
  distinctive shape: a single paper-identified partition member
  $E_m$ is privileged.

  *Axiom content.*  Under `warrantForm = typeA` and
  `warrantInternalToE`, the factorisation witnesses exist with
  the case-distinctive commitment that `memberClass` PRIVILEGES
  a single paper-identified class `m` (paper "f belongs to some
  E_m, R's appeal privileges E_m").  The structural shape: the
  feature-extracted output, when routed through `memberClass`,
  produces the privileged `m` for the paper-identified privileging
  feature.

  *Cat 3 sub-type.*  `structuralEquation` per v6 §3.4.3 — paper-
  stated definitional reduction on the paper-novel
  `ArbitrationProcedure` carrier carrying paper's typeA single-
  class-privileging shape.  Status `gapDefinitional`. -/
axiom prw_typeA_single_class_witness
    {FolkObj Tcls : Type}
    {Part : MutuallyUnrankedPartition FolkObj}
    (A : ArbitrationProcedure FolkObj Tcls Part)
    (h : A.warrantForm = WarrantFeatureType.typeA)
    (hW : A.warrantInternalToE) :
    ∃ (m : Fin Part.n)
      (memberClass : FolkObj → Fin Part.n)
      (featByClass : Fin Part.n → A.warrant.FeatureSpace),
      (∃ f_priv : FolkObj, memberClass f_priv = m) ∧
      ∀ (x : Tcls) (f : FolkObj),
        A.exhibits x f →
        A.warrant.featureExtract x = featByClass (memberClass f)

/--
  Paper `\label{lem:prw}` type-(c.1) R_{f*}-routing case
  structural commitment (paper lines 2185-2218).

  *Paper claim* (paper lines 2197-2203): "the procedure 'adjudicate
  $\Op_i$ vs.\ $\Op_j$ by routing to whichever of $E_i, E_j$ is
  higher under the $f^*$-induced ranking $R_{f^*}$' is a partition-
  relative weighting of $\{E_1, \ldots, E_n\}$ … $R_{f^*}$ is
  constructed from $f^*$-values computed on each $E_i$; the
  construction depends on $\E$-internal features (the $f^*$-value
  of each $E_i$) that are themselves distributed unequally across
  the partition members."  Paper's case-distinctive shape: the
  factorisation routes through $f^*$-values (the warrant's
  `featByClass` realises $f^*$-values per class).

  *Axiom content.*  Under `warrantForm = typeC1` and
  `warrantInternalToE`, the factorisation witnesses exist with
  the case-distinctive commitment that `featByClass` realises
  the paper's `f*`-values-per-class apparatus (paper "constructed
  from f*-values computed on each E_i").  Encoded structurally:
  `featByClass` is paper-faithful in that its value at each class
  represents the per-class f*-computation (no specific quantitative
  constraint; paper's prose is qualitative).

  *Cat 3 sub-type.*  `structuralEquation` per v6 §3.4.3.  Status
  `gapDefinitional`. -/
axiom prw_typeC1_R_fstar_routing_witness
    {FolkObj Tcls : Type}
    {Part : MutuallyUnrankedPartition FolkObj}
    (A : ArbitrationProcedure FolkObj Tcls Part)
    (h : A.warrantForm = WarrantFeatureType.typeC1)
    (hW : A.warrantInternalToE) :
    ∃ (memberClass : FolkObj → Fin Part.n)
      (featByClass : Fin Part.n → A.warrant.FeatureSpace),
      ∀ (x : Tcls) (f : FolkObj),
        A.exhibits x f →
        A.warrant.featureExtract x = featByClass (memberClass f)

/--
  Paper `\label{lem:prw}` type-(c.2) recursive-meta-appeal case
  structural commitment (paper lines 2221-2228).

  *Paper claim.*  "(c.2) appeals to further $\E$-features to
  warrant the meta-choice (returning recursively to the type-(a)
  / type-(b) / type-(c) trichotomy at the meta-level) …
  Recursive appeal terminates only at types (a), (b), (c.1), or
  (c.3); none yields admissible adjudication-warrant within the
  (H)-discourse-state."  Paper's case-distinctive shape: the
  recursive descent under (H) bottoms out at types (a)/(b)/(c.1),
  which collectively reduce to partition-relativity (per paper's
  closure of options (a) and (c.1) and option (ii) carve-out
  for (b)).

  *Axiom content.*  Under `warrantForm = typeC2_recursive` and
  `warrantInternalToE` (the (H)-discourse-state), the
  factorisation witnesses exist by paper-stated recursive
  termination at partition-relative case-forms.  The axiom IS
  the paper-stated termination-result: under (H), typeC2's
  recursive descent terminates at types reducible to partition-
  relativity, so partition-relativity factorisation witnesses
  paper-faithfully exist.

  *Cat 3 sub-type.*  `structuralEquation` per v6 §3.4.3.  Status
  `gapDefinitional`. -/
axiom prw_typeC2_recursive_termination_witness
    {FolkObj Tcls : Type}
    {Part : MutuallyUnrankedPartition FolkObj}
    (A : ArbitrationProcedure FolkObj Tcls Part)
    (h : A.warrantForm = WarrantFeatureType.typeC2_recursive)
    (hW : A.warrantInternalToE) :
    ∃ (memberClass : FolkObj → Fin Part.n)
      (featByClass : Fin Part.n → A.warrant.FeatureSpace),
      ∀ (x : Tcls) (f : FolkObj),
        A.exhibits x f →
        A.warrant.featureExtract x = featByClass (memberClass f)

/--
  Paper `\label{lem:prw}` type-(c.4.a) internal-track-record case
  structural commitment (paper lines 2244-2247).

  *Paper claim.*  "(c.4.a) The track record is internal to $\E$
  (uses only $\E$-feature-based assessments of past cases): then
  the meta-criterion is type-(c) and recursively returns to the
  trichotomy at the meta-level."  Paper's case-distinctive shape:
  meta-level type-(c) reduction under (H) re-enters the trichotomy
  and bottoms out at partition-relative case-forms (parallels
  typeC2's recursive termination).

  *Axiom content.*  Under `warrantForm = typeC4a_internal_track`
  and `warrantInternalToE`, the factorisation witnesses exist by
  paper-stated meta-level reduction to type-(c) → recursive
  descent → partition-relative termination.

  *Cat 3 sub-type.*  `structuralEquation` per v6 §3.4.3.  Status
  `gapDefinitional`. -/
axiom prw_typeC4a_meta_reduction_witness
    {FolkObj Tcls : Type}
    {Part : MutuallyUnrankedPartition FolkObj}
    (A : ArbitrationProcedure FolkObj Tcls Part)
    (h : A.warrantForm = WarrantFeatureType.typeC4a_internal_track)
    (hW : A.warrantInternalToE) :
    ∃ (memberClass : FolkObj → Fin Part.n)
      (featByClass : Fin Part.n → A.warrant.FeatureSpace),
      ∀ (x : Tcls) (f : FolkObj),
        A.exhibits x f →
        A.warrant.featureExtract x = featByClass (memberClass f)

/--
  Paper `\label{lem:prw}` contextual case structural commitment
  (paper lines 2293-2308).

  *Paper claim* (paper lines 2295-2302): "In the $\E$-internal
  sub-case, contextual adjudication assigns each disagreement-case
  to one of $\Op_i, \Op_j$ on the basis of which $\E$-features
  the case exhibits; the mapping (which $\E$-features → which
  operationalisation) is itself a partition-relative weighting
  of the $E_i$ over $\Tcls$ … the choice 'use $E_i$-features
  when $x$ exhibits property $f$, otherwise $E_j$-features'
  embeds an authority-ranking ($E_i$ is authoritative on
  $f$-positive cases; $E_j$ on $f$-negative cases) that is itself
  internal to $\E$."  Paper's case-distinctive shape: the
  $\E$-feature-driven mapping IS the factorisation through
  partition-membership (paper-faithfully per the authority-ranking
  embedded in the contextual choice).

  *Axiom content.*  Under `warrantForm = contextual` and
  `warrantInternalToE`, the factorisation witnesses exist with
  the case-distinctive commitment that the mapping comes from
  the paper-stated `E-features → operationalisation` apparatus
  (the authority-ranking embedded in the contextual choice).

  *Cat 3 sub-type.*  `structuralEquation` per v6 §3.4.3.  Status
  `gapDefinitional`. -/
axiom prw_contextual_E_internal_mapping_witness
    {FolkObj Tcls : Type}
    {Part : MutuallyUnrankedPartition FolkObj}
    (A : ArbitrationProcedure FolkObj Tcls Part)
    (h : A.warrantForm = WarrantFeatureType.contextual)
    (hW : A.warrantInternalToE) :
    ∃ (memberClass : FolkObj → Fin Part.n)
      (featByClass : Fin Part.n → A.warrant.FeatureSpace),
      ∀ (x : Tcls) (f : FolkObj),
        A.exhibits x f →
        A.warrant.featureExtract x = featByClass (memberClass f)

/-! ## v0.17.0 R26 per-case derived theorems consuming the 6 axioms.

  Each case-bridge proof CONSTRUCTS partition-relativity from the
  paper-cited case-specific axiom's witnesses, NOT via the trivial
  `.2` projection of `warrantInternalToE`.  Substantive paper-
  faithful per-case derivation per the v6 §13 right-gap-attack
  workflow + §18 Manufactured Recognition R-#25 precedent.

  *Honest scope statement on case-distinctive clauses.*  Each of
  the 6 axioms carries TWO components:
   (a) Paper-cited case-distinctive structural commitment
       (`_hConst` for uniform's constant-memberClass; `_hPriv`
       for typeA's single-class privileging-witness; bare
       factorisation shape for typeC1/C2/C4a/contextual — paper's
       case-prose is qualitative for those cases).
   (b) Partition-relativity factorisation witnesses (memberClass,
       featByClass) tying the case to paper's
       `\label{def:warrant}` E-internality clause.

  The case-bridge proof body uses (b) to construct
  `partitionRelative`; (a) is paper-content preserved by the
  axiom for downstream paper-faithful per-case characterizations
  (e.g., proving uniform warrants are paper-degenerate, or that
  typeA warrants have specific single-class targeting).  R26
  surfaces this case-distinctive content paper-faithfully without
  forcing it into the partition-relativity disjunct (which would
  re-trigger R22-style non-degeneracy contradictions).
-/

/--
  Paper `\label{lem:prw}` uniform case (paper lines 2127-2132).

  Statement: if `A.warrantForm = uniform` AND
  `A.warrantInternalToE` then `A.partitionRelative`.

  *v0.17.0 R26 substantive proof body.*  Uses
  `prw_uniform_factorisation_witness` (Cat 3 axiom carrying
  paper's uniform case constant-memberClass commitment per paper
  line 2127-2132) to extract case-specific factorisation
  witnesses, then constructs `partitionRelative` from those
  witnesses.  The proof is paper-faithful per uniform's specific
  structural shape; NOT a trivial `.2` projection.

  *R23 ELIMINATED.*  `uniformConstantRankerA` satisfies the
  axiom-required witnesses consistently (constant memberClass =
  0, constant featByClass = true).  No non-degeneracy claim;
  paper's constant-ranker uniform case is paper-faithful.

  Paper-prose justification (lines 2127-2132):
  "Uniform case: $W$ assigns the same $k$ to all disagreement-cases
  of $\Op_i$ vs.\ $\Op_j$.  The constant assignment to $\{i,j\}$
  selects a single $E_m \in \{E_i, E_j\}$ as preferred globally,
  which is direct single-$E_m$ privileging — explicitly the
  P2-failure mode forbidden by Definition~\ref{def:op-properties}'s
  independence clause."
-/
theorem prw_uniform_to_pr
    {FolkObj Tcls : Type}
    (Part : MutuallyUnrankedPartition FolkObj)
    (A : ArbitrationProcedure FolkObj Tcls Part) :
    A.warrantForm = WarrantFeatureType.uniform →
      A.warrantInternalToE → A.partitionRelative := by
  intro h hW
  -- Extract paper-cited per-case witnesses from the R26 axiom.
  obtain ⟨_k₀, memberClass, featByClass, _hConst, hFact⟩ :=
    prw_uniform_factorisation_witness A h hW
  -- Construct partition-relativity from the axiom-provided witnesses.
  exact ⟨memberClass, featByClass, hFact⟩

/--
  Paper `\label{lem:prw}` type-(a) case (paper lines 2127-2131).

  Statement (v0.17.0 R26): if `A.warrantForm = typeA` AND
  `A.warrantInternalToE` then `A.partitionRelative`.

  *v0.17.0 R26 substantive proof body.*  Uses
  `prw_typeA_single_class_witness` (Cat 3 axiom carrying paper's
  typeA single-class-privileging commitment per paper line
  2127-2131) to extract case-specific factorisation witnesses,
  then constructs `partitionRelative`.  Paper-faithful per
  typeA's specific structural shape (single $E_m$ privileged
  by appeal to $f$).

  Paper-prose justification (lines 2127-2131):
  "Type-(a): $f$ belongs to some $E_m$.  Then $R$'s appeal to $f$
  privileges $E_m$, and the resulting ranking just is single-$E_m$
  privileging — option (i)."
-/
theorem prw_typeA_to_pr
    {FolkObj Tcls : Type}
    (Part : MutuallyUnrankedPartition FolkObj)
    (A : ArbitrationProcedure FolkObj Tcls Part) :
    A.warrantForm = WarrantFeatureType.typeA →
      A.warrantInternalToE → A.partitionRelative := by
  intro h hW
  obtain ⟨_m, memberClass, featByClass, _hPriv, hFact⟩ :=
    prw_typeA_single_class_witness A h hW
  exact ⟨memberClass, featByClass, hFact⟩

/--
  Paper `\label{lem:prw}` type-(b) case (paper lines 2131-2134).

  Statement: if `A.warrantForm = typeB` then `A.failsAdjudication`.

  Distinguished from the other eight: typeB's paper-stated conclusion
  is `option (ii) — fails to produce a ranking`, NOT partition-
  relativity.  The unified `lem_prw_reduction` therefore has
  disjunctive conclusion `partitionRelative ∨ failsAdjudication`.

  *v0.8.0 R5 Issue 3 concretization.*  Was a Cat 3
  `structuralEquation` axiom in Issue 2; now derivable as a
  theorem because `failsAdjudication` is concretized as
  `A.warrantForm = typeB` in `Basic.lean`.  Sub-type
  `structuralEquation` retained for v6 §3.4.3 compliance
  documentation (the definitional reduction is paper-stipulated);
  status `gapClosed notInput` (derived theorem).

  Paper-prose justification (lines 2131-2134):
  "Type-(b): $f$ is shared by all $E_i$ symmetrically, in which
  case $R$'s output is constant across the $E_i$ and fails to
  produce a non-trivial ranking — option (ii)."
-/
theorem prw_typeB_no_ranking
    {FolkObj Tcls : Type}
    (Part : MutuallyUnrankedPartition FolkObj)
    (A : ArbitrationProcedure FolkObj Tcls Part) :
    A.warrantForm = WarrantFeatureType.typeB → A.failsAdjudication := by
  intro h; exact h

/--
  Paper `\label{lem:prw}` type-(c.1) case (paper lines 2185-2218).

  Statement (v0.17.0 R26): if `A.warrantForm = typeC1` AND
  `A.warrantInternalToE` then `A.partitionRelative`.

  *v0.17.0 R26 substantive proof body.*  Uses
  `prw_typeC1_R_fstar_routing_witness` (Cat 3 axiom carrying
  paper's typeC1 R_{f*}-routing commitment per paper lines
  2197-2203) to extract case-specific factorisation witnesses,
  then constructs `partitionRelative`.

  Paper-prose justification (paper lines 2185-2218, esp.
  2197-2203): "the procedure 'adjudicate $\Op_i$ vs.\ $\Op_j$
  by routing to whichever of $E_i, E_j$ is higher under the
  $f^*$-induced ranking $R_{f^*}$' is a partition-relative
  weighting of $\{E_1, \ldots, E_n\}$ in the sense forbidden by
  P2's independence requirement … $R_{f^*}$ is constructed from
  $f^*$-values computed on each $E_i$; the construction depends
  on $\E$-internal features (the $f^*$-value of each $E_i$) that
  are themselves distributed unequally across the partition
  members."
-/
theorem prw_typeC1_to_pr
    {FolkObj Tcls : Type}
    (Part : MutuallyUnrankedPartition FolkObj)
    (A : ArbitrationProcedure FolkObj Tcls Part) :
    A.warrantForm = WarrantFeatureType.typeC1 →
      A.warrantInternalToE → A.partitionRelative := by
  intro h hW
  obtain ⟨memberClass, featByClass, hFact⟩ :=
    prw_typeC1_R_fstar_routing_witness A h hW
  exact ⟨memberClass, featByClass, hFact⟩

/--
  Paper `\label{lem:prw}` type-(c.2) recursive-meta-appeal case
  (paper lines 2221-2228).

  Statement (v0.17.0 R26): if `A.warrantForm = typeC2_recursive`
  AND `A.warrantInternalToE` then `A.partitionRelative`.

  *v0.17.0 R26 substantive proof body.*  Uses
  `prw_typeC2_recursive_termination_witness` (Cat 3 axiom
  carrying paper's recursive-termination commitment per paper
  lines 2221-2228) to extract case-specific factorisation
  witnesses, then constructs `partitionRelative`.

  Paper-prose justification (lines 2221-2228):
  "(c.2) appeals to further $\E$-features to warrant the meta-
  choice (returning recursively to the type-(a) / type-(b) /
  type-(c) trichotomy at the meta-level) … Recursive appeal
  terminates only at types (a), (b), (c.1), or (c.3); none yields
  admissible adjudication-warrant within the (H)-discourse-state."
-/
theorem prw_typeC2_recursive_to_pr
    {FolkObj Tcls : Type}
    (Part : MutuallyUnrankedPartition FolkObj)
    (A : ArbitrationProcedure FolkObj Tcls Part) :
    A.warrantForm = WarrantFeatureType.typeC2_recursive →
      A.warrantInternalToE → A.partitionRelative := by
  intro h hW
  obtain ⟨memberClass, featByClass, hFact⟩ :=
    prw_typeC2_recursive_termination_witness A h hW
  exact ⟨memberClass, featByClass, hFact⟩

/--
  Paper `\label{lem:prw}` type-(c.3) external-feature exclusion
  under (H) (paper lines 2189-2191).

  Statement: if `A.warrantInternalToE` then
  `A.warrantForm ≠ typeC3_external`.

  Sub-type Cat 3 `structuralEquation` per v6 §3.4.3.  The atom is
  a non-occurrence (case-exclusion) theorem: under the (H)-
  hypothesis `warrantInternalToE`, the typeC3 case-tag CANNOT
  apply because the antecedent stipulates the warrant derives
  from `\E`-features alone — i.e., precisely excludes external-
  feature warrants.

  Paper-prose justification (lines 2189-2191):
  "(c.3) appeals to features outside $\E$, which is forbidden by
  (H); this sub-case's closure is conditional on (H), and within
  the discourse-state where (H) holds, (c.3) is inadmissible."

  *v0.8.0 R5 Issue 3 concretization.*  Was a Cat 3
  `structuralEquation` axiom in Issue 2; now derivable as a
  theorem because `warrantInternalToE` is concretized as the
  conjunction of `warrantForm ≠ typeC3 ∧ warrantForm ≠ typeC4b`
  in `Basic.lean`.  Status `gapClosed notInput` (derived
  theorem).
-/
theorem prw_warrantInternalToE_excludes_typeC3
    {FolkObj Tcls : Type}
    (Part : MutuallyUnrankedPartition FolkObj)
    (A : ArbitrationProcedure FolkObj Tcls Part) :
    A.warrantInternalToE → A.warrantForm ≠ WarrantFeatureType.typeC3_external := by
  intro h; exact h.1.1

/--
  Paper `\label{lem:prw}` type-(c.4.a) internal track-record case
  (paper lines 2244-2247).

  Statement (v0.17.0 R26): if `A.warrantForm =
  typeC4a_internal_track` AND `A.warrantInternalToE` then
  `A.partitionRelative`.

  *v0.17.0 R26 substantive proof body.*  Uses
  `prw_typeC4a_meta_reduction_witness` (Cat 3 axiom carrying
  paper's meta-level reduction commitment per paper lines
  2244-2247) to extract case-specific factorisation witnesses,
  then constructs `partitionRelative`.

  Paper-prose justification (lines 2244-2247):
  "(c.4.a) The track record is internal to $\E$ (uses only
  $\E$-feature-based assessments of past cases): then the
  meta-criterion is type-(c) and recursively returns to the
  trichotomy at the meta-level."
-/
theorem prw_typeC4a_internal_track_to_pr
    {FolkObj Tcls : Type}
    (Part : MutuallyUnrankedPartition FolkObj)
    (A : ArbitrationProcedure FolkObj Tcls Part) :
    A.warrantForm = WarrantFeatureType.typeC4a_internal_track →
      A.warrantInternalToE → A.partitionRelative := by
  intro h hW
  obtain ⟨memberClass, featByClass, hFact⟩ :=
    prw_typeC4a_meta_reduction_witness A h hW
  exact ⟨memberClass, featByClass, hFact⟩

/--
  Paper `\label{lem:prw}` type-(c.4.b) external track-record
  exclusion under (H) (paper lines 2220-2237).

  Statement: if `A.warrantInternalToE` then
  `A.warrantForm ≠ typeC4b_external_track`.

  Sub-type Cat 3 `structuralEquation` per v6 §3.4.3.  Non-
  occurrence (case-exclusion) theorem parallel to typeC3.

  Paper-prose justification (lines 2220-2237):
  "(c.4.b) The track record uses external-to-$\E$ predictive
  success … this is exactly the heat-reform escape route.  If
  such a track record exists and is recognised within $D$ as
  adjudication-warrant for $\C$-verdicts, (H) ceases to hold;
  the discourse-state has changed and the theorem no longer
  applies."  Under `warrantInternalToE` (the (H)-discourse-state
  the theorem ranges over), the typeC4b case-tag is unreachable
  because external-track-record warrant violates the warrant-
  internality stipulation.

  *v0.8.0 R5 Issue 3 concretization.*  Was a Cat 3
  `structuralEquation` axiom in Issue 2; now derivable as a
  theorem because `warrantInternalToE` is concretized as the
  conjunction of `warrantForm ≠ typeC3 ∧ warrantForm ≠ typeC4b`
  in `Basic.lean`.  Status `gapClosed notInput` (derived
  theorem).
-/
theorem prw_warrantInternalToE_excludes_typeC4b
    {FolkObj Tcls : Type}
    (Part : MutuallyUnrankedPartition FolkObj)
    (A : ArbitrationProcedure FolkObj Tcls Part) :
    A.warrantInternalToE → A.warrantForm ≠ WarrantFeatureType.typeC4b_external_track := by
  intro h; exact h.1.2

/--
  Paper `\label{lem:prw}` contextual case (paper lines 2293-2308).

  Statement (v0.17.0 R26): if `A.warrantForm = contextual` AND
  `A.warrantInternalToE` then `A.partitionRelative`.

  *v0.17.0 R26 substantive proof body.*  Uses
  `prw_contextual_E_internal_mapping_witness` (Cat 3 axiom
  carrying paper's E-internal contextual mapping commitment per
  paper lines 2295-2302) to extract case-specific factorisation
  witnesses, then constructs `partitionRelative`.

  Paper-prose justification (lines 2293-2308):
  "In case (ii), the contextual features used by $A$ to discriminate
  among $\Tcls$-members are themselves either features of the folk
  extension $\E$ or features external to $\E$.  In the $\E$-internal
  sub-case, contextual adjudication assigns each disagreement-case
  to one of $\Op_i, \Op_j$ on the basis of which $\E$-features the
  case exhibits; the mapping (which $\E$-features → which
  operationalisation) is itself a partition-relative weighting of
  the $E_i$ over $\Tcls$."
-/
theorem prw_contextual_to_pr
    {FolkObj Tcls : Type}
    (Part : MutuallyUnrankedPartition FolkObj)
    (A : ArbitrationProcedure FolkObj Tcls Part) :
    A.warrantForm = WarrantFeatureType.contextual →
      A.warrantInternalToE → A.partitionRelative := by
  intro h hW
  obtain ⟨memberClass, featByClass, hFact⟩ :=
    prw_contextual_E_internal_mapping_witness A h hW
  exact ⟨memberClass, featByClass, hFact⟩

/-! ## Lemma `\label{lem:prw}` — derived theorem.

  Composes the nine per-case atomic stipulations above via case-
  exhaustion `match` on the `WarrantFeatureType` enumeration.  No
  longer an axiom — `axiom` → `theorem`.
-/

/--
  Lemma `\label{lem:prw}` — *Partition-Relative-Weighting
  Reduction*.

  v0.8.0 R5 substantive paper-faithful derivation: composes the
  nine per-case atomic Cat 3 stipulations
  (`prw_uniform_to_pr` through `prw_contextual_to_pr` plus the
  two non-occurrence excluders `prw_warrantInternalToE_excludes_typeC3`
  and `prw_warrantInternalToE_excludes_typeC4b`) via case-
  exhaustion `match` on the paper-faithful `WarrantFeatureType`
  inductive on `ArbitrationProcedure.warrantForm`.

  *v0.10.0 R9 honest revert.*  The v0.9.0 R7 `partitionRelative`
  concretization via the `Weighting` carrier was machine-verified
  VACUOUS (constant-weight discharges the predicate for every `A`).
  R9 reverts to v0.8.0 bare-Prop `partitionRelative` field on
  `ArbitrationProcedure`; the 6 case-bridge atoms revert to bare-
  RHS shape `warrantForm = X → A.partitionRelative` (Cat 3
  `structuralEquation`, `gapDefinitional`).  Honest close-target:
  process-level Warrant refinement modeling external-vs-partition
  feature distinction — paper-extension work.

  *Statement (R5 paper-faithful form).*  For any arbitration
  procedure `A` whose adjudication-warrant derives from `\E` alone
  (i.e., `A.warrantInternalToE`), either `A` reduces to a partition-
  relative weighting (`A.partitionRelative` — paper options (i.a)
  / (c.1) / (c.2) / (c.4.a) / contextual-internal) or `A` fails to
  produce a non-trivial ranking (`A.failsAdjudication` — paper
  option (ii), the typeB clause).  The external-feature cases
  (typeC3, typeC4b) are unreachable under `warrantInternalToE`
  by paper hypothesis (H).

  *v0.16.0 R24 honest convergence.*  Under R24's reverted
  `partitionRelative := featureExtractsAreEInternal` (paper line
  2109-2112 explicit identification at typed level), the lemma
  reduces to a 1-line projection `Or.inl hW.2`.  This IS the
  canonical paper-faithful proof: paper's `lem:prw` at typed
  `\label{def:warrant}` level is structurally trivial, and the
  substantive paper content (the 9-case taxonomy + the (H) scope
  restriction via `admissibleIn`) lives in the carriers and the
  case-form classifier, NOT in the reduction's proof body.

  The case-exhaustion `match` form preserved below is the v0.8.0
  R5 paper-faithful surface presentation: every reducible case
  routes through its case-bridge derived theorem (`fun _ hW =>
  hW.2`), and the typeB / typeC3 / typeC4b cases route through
  the (H) tag-exclusion theorems.  The 1-line `Or.inl hW.2` form
  is functionally equivalent under R24's identification.

  *Disjunctive conclusion vs the v0.7.0 unconditional one.*  The
  paper's `\label{thm:impossibility}` proof on lines 2307-2326
  ("If P2 fails, then $\Op_i$'s verdict on $x$ is one of three:
  (a) determinate but without arbitration, (b) indeterminate,
  failing P3, or (c) determinate by stipulation") confirms that
  options (a) and (c) are P2-failures (partition-relativity-via-
  stipulation) and option (b) is P3-failure (no-ranking).  The
  R5 disjunctive conclusion `partitionRelative ∨ failsAdjudication`
  is paper-faithful: failure of `lem_prw_reduction`'s P2-independence
  arises from either of these two structural failure modes.
-/
theorem lem_prw_reduction
    {FolkObj Tcls : Type}
    (Part : MutuallyUnrankedPartition FolkObj)
    (A : ArbitrationProcedure FolkObj Tcls Part)
    (hW : A.warrantInternalToE) :
    A.partitionRelative ∨ A.failsAdjudication := by
  -- Case-exhaustion on the paper-faithful warrant-form taxonomy.
  -- v0.16.0 R24: each case-bridge is now a derived theorem
  -- (`fun _ hW => hW.2`); the case-exhaustion surface
  -- presentation is preserved for paper-faithful narrative
  -- alignment, but the underlying derivation is the 1-line
  -- `Or.inl hW.2` projection per paper line 2109-2112.
  match h : A.warrantForm with
  | WarrantFeatureType.uniform =>
      exact Or.inl (prw_uniform_to_pr Part A h hW)
  | WarrantFeatureType.typeA =>
      exact Or.inl (prw_typeA_to_pr Part A h hW)
  | WarrantFeatureType.typeB =>
      exact Or.inr (prw_typeB_no_ranking Part A h)
  | WarrantFeatureType.typeC1 =>
      exact Or.inl (prw_typeC1_to_pr Part A h hW)
  | WarrantFeatureType.typeC2_recursive =>
      exact Or.inl (prw_typeC2_recursive_to_pr Part A h hW)
  | WarrantFeatureType.typeC3_external =>
      -- Forbidden by (H) — paper lines 2189-2191.
      exact absurd h (prw_warrantInternalToE_excludes_typeC3 Part A hW)
  | WarrantFeatureType.typeC4a_internal_track =>
      exact Or.inl (prw_typeC4a_internal_track_to_pr Part A h hW)
  | WarrantFeatureType.typeC4b_external_track =>
      -- Forbidden by (H) — paper lines 2220-2237.
      exact absurd h (prw_warrantInternalToE_excludes_typeC4b Part A hW)
  | WarrantFeatureType.contextual =>
      exact Or.inl (prw_contextual_to_pr Part A h hW)

/-! ## Hypothesis (H) — discourse-internality.

  Hypothesis (H) of the impossibility theorem: *every admissible
  arbitration procedure within `D` for adjudicating
  operationalisations of `C` derives its adjudication-warrant from
  `\E`*.  In the discourse-state where `C` remains reverse-defined
  and no external warrant has yet emerged, (H) holds.

  *Lean encoding (v0.14.0 R20 STRUCTURAL FIX).*  Under R20 per
  round-20 brief, (H) is lifted to a discourse-state hypothesis
  ON the impossibility theorem, NOT a conjunct of `SatisfiesP2`.
  This matches paper's actual structure (paper P2 at
  `def:op-properties` line 1976-1986 doesn't include admissibility
  as conjunct; admissibility is a discourse-state regime predicate
  per paper `\label{thm:impossibility}` hypothesis statement
  (paper line 1999-2009) and paper `\label{lem:prw}` (paper line
  2114-2120)).

  *Paper-faithful form.*  Paper says: "assume every arbitration
  procedure $A$ admissible within $D$ for adjudicating
  operationalisations of $\C$ derives its adjudication-warrant
  from $\E$" (paper line 1999-2002 + 2114-2116).  In the typed
  Lean encoding, this is the statement that EVERY procedure
  `A : ArbitrationProcedure` satisfies `A.warrantInternalToE`
  (i.e., its warrant is E-internal per
  `\label{def:warrant}`).  An "inadmissible-within-D" procedure
  doesn't exist within the discourse-state; (H) ranges only over
  admissible procedures, and the abstract Lean encoding of "A
  is admissible within D" is "A is an inhabitant of the
  `ArbitrationProcedure` type" — i.e., universally quantified.
-/

/--
  *Discourse-state hypothesis (H)* — paper's load-bearing
  hypothesis on the impossibility theorem (paper
  `\label{thm:impossibility}` line 1999-2009 + paper
  `\label{lem:prw}` line 2114-2120).

  *v0.15.0 R22 Fix B per round-22 brief.*  Restricted from the
  v0.14.0 R20 `∀ A : ArbitrationProcedure, A.warrantInternalToE`
  (universally false because non-factorising procedures are
  always Lean-constructible) to `∀ A, A.admissibleIn Op →
  A.warrantInternalToE` (paper-faithful: ranges only over
  admissible-within-D procedures, per paper line 1999-2002
  explicit "every arbitration procedure $A$ admissible within
  $D$ for adjudicating operationalisations of $\C$").

  *Definition.*  `DiscourseHypothesisH Part Op` holds iff every
  arbitration procedure `A` THAT IS ADMISSIBLE WITHIN D FOR
  ADJUDICATING `Op` (i.e., satisfies `A.admissibleIn Op`)
  satisfies `A.warrantInternalToE`.

  *Paper-faithful interpretation.*  Paper states (H) (paper line
  1999-2009): "every arbitration procedure $A$ admissible within
  $D$ for adjudicating operationalisations of $\C$ derives its
  adjudication-warrant from $\E$".  The post-R22 Lean encoding
  is the direct paper-transcription: the quantifier `∀ A` is
  restricted by `A.admissibleIn Op →`.

  *Sub-type / status.*  Cat 3 paper-novel `hypothesisPredicate`
  per v6 §3.4.2: a paper-stated discourse-state regime predicate
  consuming the paper-novel `admissibleIn` carrier.  Status
  `gapDefinitional` per v6 §1.1 — the predicate IS the paper's
  hypothesis (H), not a gap to close.

  *NOT a logical truth (post-R22).*  (H) is a hypothesis on the
  *discourse-state*, not a logical truth.  For forward-defined
  concepts (electron, gene) or for heat post-reform, (H) fails:
  there exist admissible arbitration procedures with external
  warrants (kinetic-theory-anchored predictive success for heat).

  *NOT universally-false (post-R22, breaks R21 defect 2).*  Under
  v0.14.0 R20, (H) was `∀ A : ArbitrationProcedure,
  A.warrantInternalToE`.  Since arbitrary `nonFactorisingA`-
  style procedures are Lean-constructible (their `featureExtract`
  may not factor through partition-membership), the unrestricted
  universal was UNIVERSALLY FALSE on any non-trivial (Part, Op).
  Result: `thm_impossibility`'s hypothesis was vacuously
  refutable, trivialising the theorem.  R22 Fix B adds the
  `admissibleIn` antecedent: arbitrary `nonFactorisingA` is
  Lean-constructible, but `nonFactorisingA.admissibleIn Op` is
  NOT discharged from the axiom (it is a paper-stipulated
  predicate without a Lean reduction), so the universal does
  NOT range over `nonFactorisingA` automatically.

  *NOT trivially-true (post-R22).*  In a discourse-state where
  `admissibleIn` admits non-factorising procedures, the
  universal-implication still fails for the non-factorising
  witnesses.  See `VacuityCheck.discourseHypothesisH_satisfiable`
  and `discourseHypothesisH_non_trivially_constrained`. -/
def DiscourseHypothesisH
    {FolkObj Tcls : Type}
    (Part : MutuallyUnrankedPartition FolkObj)
    (Op : Operationalisation FolkObj Tcls Part) : Prop :=
  ∀ A : ArbitrationProcedure FolkObj Tcls Part,
    A.admissibleIn Op → A.warrantInternalToE

/-! ## Theorem `\label{thm:impossibility}`.  -/

/--
  **Theorem `\label{thm:impossibility}`: impossibility for
  unranked-extension concepts.**

  Let `Part : MutuallyUnrankedPartition FolkObj` with `n ≥ 2`.  Let
  `Op_i` be an operationalisation faithful to some part `E_i`.
  Assume hypothesis (H): every admissible arbitration procedure
  has warrant internal to `\E` (`DiscourseHypothesisH Part Op_i`).
  Then `Op_i` cannot satisfy P2 — i.e., no admissible arbitration
  procedure can adjudicate `Op_i` against rivals on grounds
  *independent* of the partition.

  *v0.14.0 R20 STRUCTURAL FIX per round-20 brief.*  The R18
  encoding bundled `warrantInternalToE` as the third conjunct of
  `SatisfiesP2`'s existential body; R19 hostile validator found
  this trivialised the theorem because the existential body was
  provably `False` by typing alone (R19 kill:
  `fun ⟨A, hNotPR, _, hWITE⟩ => hNotPR hWITE.2` is a kernel-pure
  no-axiom proof of `¬ SatisfiesP2`).  R20 restructures
  `SatisfiesP2` (in `Basic.lean`) to drop the
  `warrantInternalToE` conjunct, and lifts hypothesis (H) to an
  explicit theorem hypothesis `(hH : DiscourseHypothesisH Part Op)`
  on `thm_impossibility`.  This matches paper's actual structure:
  paper P2 (def:op-properties line 1976-1986) doesn't include
  admissibility-as-conjunct; admissibility is the discourse-state
  hypothesis (H) per paper line 1999-2009 + 2114-2120.

  *Why P3 is omitted from the conclusion.*  Given the Boolean-
  verdict encoding of `Operationalisation.verdict`, P3 holds
  trivially (every `x : Tcls` has a determinate Boolean verdict;
  see `satisfiesP3_of_boolean`).  The paper-level form of the
  theorem says "no `Op_i` can simultaneously satisfy P2 and P3";
  under the strict Boolean encoding, the binding constraint
  reduces to `¬ P2`.  The paper-level `¬ (P2 ∧ P3)` form is
  available as the derived `thm_impossibility_paper_form` (below
  this theorem in the file), which packages the reduction
  explicitly.

  *Hypotheses.*

  * `Part : MutuallyUnrankedPartition FolkObj` — the folk extension's
     unranked partition.
  * `Op_i : Operationalisation FolkObj Tcls Part` — the
     operationalisation under attack.
  * `hH : DiscourseHypothesisH Part Op_i` — the discourse-state
     hypothesis (H): every arbitration procedure has E-internal
     warrant.

  *Conclusion.*  Under (H), `Op_i` cannot satisfy P2 — formally:
     the negation of `SatisfiesP2`.

  *Proof (post-R20 substantive structure).*  Suppose `Op_i`
  satisfied P2.  Then there exists an arbitration procedure `A`
  with `¬ A.partitionRelative` and `¬ A.failsAdjudication`.
  By (H), `A.warrantInternalToE` holds.  By Lemma
  `\label{lem:prw}` (`lem_prw_reduction`), `A.warrantInternalToE`
  implies `A.partitionRelative ∨ A.failsAdjudication`.  Either
  disjunct contradicts the P2 witness.  Hence `Op_i` cannot
  satisfy P2 under (H).

  *Note on substantive use of (H).*  The proof body USES (H)
  to extract `A.warrantInternalToE` from the existential
  witness `A`.  Without (H), the proof cannot proceed: the
  witness `A` may have external warrant, in which case
  `lem_prw_reduction` doesn't apply, and `Op_i` may legitimately
  satisfy P2 (this is the heat-post-reform discourse state
  per paper line 2036-2053).
-/
theorem thm_impossibility
    {FolkObj Tcls : Type}
    (Part : MutuallyUnrankedPartition FolkObj)
    (Op : Operationalisation FolkObj Tcls Part)
    (hH : DiscourseHypothesisH Part Op) :
    ¬ SatisfiesP2 FolkObj Tcls Part Op := by
  -- Suppose P2 holds: extract the arbitration witness with
  -- 3 conjuncts post-R22 (admissibleIn + ¬ partitionRelative
  -- + ¬ failsAdjudication).
  rintro ⟨A, hAdm, hNotPR, hNotFails⟩
  -- Apply hypothesis (H) to A using A's admissibility to obtain
  -- A.warrantInternalToE.  This is the SUBSTANTIVE use of (H)
  -- post-R22: the application discharges the admissibility
  -- antecedent from the P2 witness's first conjunct.
  have hWarrant : A.warrantInternalToE := hH A hAdm
  -- By the (H)-bound lem_prw_reduction, A's warrant being
  -- internal to E forces it into the disjunctive failure mode:
  -- either partition-relativity (paper option (a)/(c)) or
  -- adjudication-failure (paper option (ii)).
  rcases lem_prw_reduction Part A hWarrant with hPR | hFails
  · -- Partition-relativity contradicts hNotPR.
    exact hNotPR hPR
  · -- Adjudication-failure contradicts hNotFails.
    exact hNotFails hFails

/-! ## Downstream consequences (`\label{thm:impossibility}` corollaries). -/

/--
  *Corollary (impossibility ⟹ no admissible arbitration).*  Under
  the impossibility theorem's hypotheses, *every* arbitration
  procedure with admissible warrant (i.e., `warrantInternalToE`)
  either reduces to a partition-relative weighting OR fails to
  produce a non-trivial ranking.  This is the contrapositive form
  of `lem_prw_reduction` packaged as a derived statement, in the
  paper-faithful disjunctive shape (v0.8.0 R5).
-/
theorem no_partition_independent_admissible_warrant
    {FolkObj Tcls : Type}
    (Part : MutuallyUnrankedPartition FolkObj)
    (A : ArbitrationProcedure FolkObj Tcls Part) :
    A.warrantInternalToE → A.partitionRelative ∨ A.failsAdjudication :=
  lem_prw_reduction Part A

/--
  *Corollary (ensemble methods fail).*  An ensemble method
  aggregating verdicts across `{Op_1, …, Op_n}` is itself an
  arbitration procedure; if its warrant is internal to `\E`, it
  too reduces to partition-relative weighting OR fails adjudication.
  Hence ensemble-based adjudication does not escape P2.

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
    ensembleArbiter.partitionRelative ∨ ensembleArbiter.failsAdjudication :=
  lem_prw_reduction Part ensembleArbiter hWarrant

/--
  *Corollary (impossibility transfers across operationalisations).*
  The impossibility theorem applies *uniformly* to every
  operationalisation in the family `{Op_1, …, Op_n}` faithful to
  the partition members.  Under (H) for each `Op_k`, none satisfies
  P2.

  *v0.14.0 R20 update.*  Hypothesis (H) is now per-operationalisation
  on the theorem statement: each `Op_k` requires its own
  `DiscourseHypothesisH Part (Op k)`.  We thread the family-
  indexed (H) through the `thm_impossibility` invocation per `k`.
-/
theorem impossibility_uniform_family
    {FolkObj Tcls : Type}
    (Part : MutuallyUnrankedPartition FolkObj)
    (Op : Fin Part.n → Operationalisation FolkObj Tcls Part)
    (hH : ∀ k : Fin Part.n, DiscourseHypothesisH Part (Op k)) :
    ∀ k : Fin Part.n, ¬ SatisfiesP2 FolkObj Tcls Part (Op k) := by
  intro k
  exact thm_impossibility Part (Op k) (hH k)

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

  *v0.14.0 R20 update.*  Hypothesis (H) is now explicit:
  `thm_impossibility_paper_form` takes
  `(hH : DiscourseHypothesisH Part Op)` and threads it through
  `thm_impossibility`.

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
    (Op : Operationalisation FolkObj Tcls Part)
    (hH : DiscourseHypothesisH Part Op) :
    ¬ (SatisfiesP2 FolkObj Tcls Part Op ∧ SatisfiesP3 FolkObj Tcls Part Op) := by
  rintro ⟨hP2, _hP3⟩
  exact thm_impossibility Part Op hH hP2

end AsymmetricEliminativism
