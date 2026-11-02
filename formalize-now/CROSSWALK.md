# Crosswalk: paper statements to Lean declarations

## Two numbering systems

The ARCH identifiers follow the **arXiv paper's** numbering (Theorems 1 to 5, Corollaries 1 and 2). The Lean repository labels its results with its **own** numbering, Theorems 1 to 13, in docstrings and in the aliases of `formalization/HeadComplexity/Results/All.lean` (for example `theorem12_symmetric`). Both are kept below.

> **Collision to watch.** "Theorem 4" and "Theorem 5" mean different results in the two systems. Paper Theorem 4 is the weighted-sum upper bound (Lean "Theorem 9"), while Lean "Theorem 4" is the symmetric threshold result. Paper Theorem 5 is the symmetric characterization (Lean "Theorem 12"), while Lean "Theorem 5" is the exact-count result. Always cite with the system named.

Lean names below live in namespace `HeadComplexity` unless they start with `Ext.`. Files are relative to `formalization/HeadComplexity/`. Every listed declaration passed the local axiom audit with axioms `[propext, Classical.choice, Quot.sound]` (VERIFICATION.md).

## Paper claims (ARCH)

### ARCH-001. Paper Theorem 1, linear-fractional normal form

Paper: for every Boolean function $f$, $H^{\ast}(f) = L _{\mathrm{frac}}(f)$. Lean numbering: "Theorem 10".

| Declaration | File | Statement |
|---|---|---|
| `HStar_eq_Lfrac` | `Results/FractionalNormalForm.lean` | `HStar n f = Lfrac n f` |
| `SharedHStar_eq_Lfrac` | same | `SharedHStar n f = Lfrac n f` |
| `computableWithSharedHeadsN_iff_fracComputable` | same | `computableWithSharedHeadsN n H f ↔ fracComputable n H f` |

Status: upstream-formalized, locally reproduced. Lean also covers a literal shared-embedding variant of the model.

### ARCH-002. Paper Corollary 1, zero and one heads

Paper: $H^{\ast}(f) = 0$ iff $f$ is constant, and $H^{\ast}(f) \leq 1$ iff $f$ is a linear threshold function. Lean numbering: "Theorem 11".

| Declaration | File | Statement |
|---|---|---|
| `HStar_eq_zero_iff` | `Results/LowComplexity.lean` | `HStar n f = 0 ↔ ∀ x y, f x = f y` |
| `HStar_eq_one_iff` | same | `HStar n f = 1 ↔ (¬ (∀ x y, f x = f y) ∧ isLTF f)` |

Status: upstream-formalized, locally reproduced. **Form difference:** Lean characterizes $H^{\ast}(f) = 1$ for nonconstant $f$; the paper characterizes $H^{\ast}(f) \leq 1$. The two agree once constant functions count as linear threshold functions, and that bridging step has no named Lean declaration.

### ARCH-003. Paper Theorem 2, threshold-degree lower bound

Paper: $\deg _{\pm}(f) \leq H^{\ast}(f)$. Lean numbering: "Theorem 6".

| Declaration | File | Statement |
|---|---|---|
| `degree_le_of_computableWithHeadsN` (alias of `signReprDegLe_of_computableWithHeadsN`) | `Results/ThresholdDegree.lean`, `Polynomial/ModelToPolynomial.lean` | `computableWithHeadsN n H f → ThresholdDegLE f H` |

Status: upstream-formalized, locally reproduced. **Form difference:** Lean states the bound per head count $H$ (any $H$-head computation gives a sign-representing polynomial of degree at most $H$), rather than as the inequality `thresholdDeg f ≤ HStar n f` between the two minima.

### ARCH-004. Paper Theorem 3, ten-bit strict separation

Paper: $\deg _{\pm}(f _{10}) = 2 \lt 3 \leq H^{\ast}(f _{10})$. Lean numbering: "Theorem 13".

| Declaration | File | Statement |
|---|---|---|
| `thresholdDeg_f10` | `Results/StrictSeparation.lean` | `thresholdDeg f10 = 2` |
| `HStar_f10_ge_three` | same | `3 ≤ HStar 10 f10` |
| `f10_strict_separation` | same | `thresholdDeg f10 < HStar 10 f10` |

Status: upstream-formalized, locally reproduced. The first two declarations together give the full paper statement.

### ARCH-005. Paper Theorem 4, weighted-sum interpolation

Paper: for positive weights $\lambda$, if $f$ depends only on $t _{\lambda}(x)$, then $H^{\ast}(f) \leq |\mathrm{Im}(t _{\lambda})| - 1$; with $\lambda_i = 2^{i-1}$, every $f$ has $H^{\ast}(f) \leq 2^n - 1$. Lean numbering: "Theorem 9".

| Declaration | File | Statement |
|---|---|---|
| `HStar_le_weighted_sum` | `Results/WeightedUpperBound.lean` | `(∀ i, 0 < lam i) → (∀ bits, f bits = G (wT lam bits)) → HStar n f ≤ (univ.image (wT lam)).card - 1` |
| `HStar_le_universal_boolean` | same | `HStar n f ≤ 2 ^ n - 1` |

Status: upstream-formalized, locally reproduced.

### ARCH-006. Paper Theorem 5, exact symmetric characterization

Paper: for symmetric $f$ with profile $F$, $H^{\ast}(f) = \deg _{\pm}(f) = C(F)$. Lean numbering: "Theorem 12".

| Declaration | File | Statement |
|---|---|---|
| `HStar_symmetricFn` | `Results/SymmetricComplexity.lean` | `HStar n (symmetricFn F) = signChanges n F` |
| `signChanges` (definition) | `BooleanCube/SymmetricSignChanges.lean` | `((range n).filter fun t => F t ≠ F (t + 1)).card` |

Status: **partially formalized.** The equality $H^{\ast}(f) = C(F)$ is upstream-formalized and locally reproduced. The middle equality $\deg _{\pm}(f) = C(F)$ for symmetric $f$ has no named Lean declaration; its two directions exist as ingredients (`signChanges_le_of_ThresholdDegLE` and `signReprDegLe_of_computableWithHeadsN`). Closing this is ROADMAP item R-001. The Lean definition counts $t \in \lbrace 0, \dots, n-1\rbrace$ with $F(t) \neq F(t+1)$, matching the paper's $k \in [n]$ with $F(k-1) \neq F(k)$ after the shift $k = t + 1$.

### ARCH-007. Paper Corollary 2, parity

Paper: for every $n \geq 1$, $H^{\ast}(\mathrm{PARITY}(n)) = n$. Lean numbering: "Theorem 8".

| Declaration | File | Statement |
|---|---|---|
| `HStar_parity` | `Results/ExactFamilies.lean` | `HStar n (PARITY n) = n` for every `n : ℕ` |

Status: upstream-formalized, locally reproduced. **Lean is stronger than the paper:** the declaration has no hypothesis on $n$, so it also covers $n = 0$, where `PARITY 0` is the constant false function and both sides are $0$.

Related upstream result outside the ARCH table: `thresholdDeg_parity : thresholdDeg (PARITY n) = n` (Lean "Theorem 7", `Polynomial/ParityThresholdDegree.lean`).

### ARCH-008. Comparison with Hsu and Xu and other concurrent work

Research plan reference: Appendix C. **Bundled PDF:** the section "Relation to Concurrent Work by Hsu and Xu" is **Appendix D**; the letter in the arXiv version is unconfirmed (see SOURCES.md). This entry is prose comparison with no Lean target. Status: documentary.

### ARCH-009. Parity-profile change count (intake record)

Original research proposal: prove that the parity profile has exactly $n$ changes for every $n$, including $n = 0$. The source audit found this already proved upstream, so ARCH-009 is a historical intake record pointing to the existing proof. The fork work that replaced it is EXT-001 to EXT-004.

| Declaration | File | Statement |
|---|---|---|
| `signChanges_parity` | `BooleanCube/SymmetricSignChanges.lean` | `signChanges n (fun k => decide (Odd k)) = n` with `n` implicit and unconstrained |

Status: upstream-formalized, locally reproduced, reclassified as reproduction.

## Fork extensions (EXT)

All in `Extensions/SymmetricMaximal.lean`, namespace `HeadComplexity.Ext`, with aliases `ext00k_*` in `Extensions/All.lean`. Every result holds for all `n : ℕ`, including `n = 0`, and is a corollary of `HStar_symmetricFn`.

| RPI | Declaration | Statement |
|---|---|---|
| EXT-001 | `Ext.signChanges_le` | `signChanges n F ≤ n` |
| EXT-001 | `Ext.HStar_symmetricFn_le` | `HStar n (symmetricFn F) ≤ n` |
| EXT-002 | `Ext.signChanges_not` | `(signChanges n fun k => !F k) = signChanges n F` |
| EXT-002 | `Ext.HStar_not_symmetricFn` | `(HStar n fun bits => !symmetricFn F bits) = HStar n (symmetricFn F)` |
| EXT-002 | `Ext.HStar_not_parity` | `(HStar n fun bits => !PARITY n bits) = n` |
| EXT-003 | `Ext.signChanges_eq_self_iff` | `signChanges n F = n ↔ ∀ k < n, F (k + 1) = !F k` |
| EXT-004 | `Ext.signChanges_eq_self_iff_parity` | `signChanges n F = n ↔ (∀ k ≤ n, F k = decide (Odd k)) ∨ ∀ k ≤ n, F k = !decide (Odd k)` |
| EXT-004 | `Ext.HStar_symmetricFn_eq_self_iff` | `HStar n (symmetricFn F) = n ↔ symmetricFn F = PARITY n ∨ symmetricFn F = fun bits => !PARITY n bits` |
| EXT-004 | `Ext.HStar_symmetricFn_zero_cases` | `HStar 0 (symmetricFn F) = 0 ∧ (symmetricFn F = PARITY 0 ∨ symmetricFn F = fun bits => !PARITY 0 bits)` |

Helper: `Ext.alternating_eq` (an alternating profile equals $F(0) \oplus [k \text{ odd}]$ on $0, \dots, n$), `Ext.signChanges_zero`.

### Novelty check

- **EXT-001.** The head form $H^{\ast}(f) \leq n$ for symmetric $f$ is **stated in the paper** ("Taking $\lambda_i = 1$ in Theorem 4 gives $H^{\ast}(f) \leq n$") and in upstream `theorems.md`. No named upstream Lean declaration states it. The fork contributes the named Lean statement, proved through the sign-change count.
- **EXT-002, EXT-003.** No statement in the Lean library, `theorems.md`, `theorems/`, or the bundled paper text.
- **EXT-004.** No statement of the converse (maximal symmetric complexity forces parity or its complement) in the Lean library, `theorems.md`, `theorems/`, or the bundled paper text. Search method in VERIFICATION.md. It is new as a stated and machine-checked corollary; mathematically it follows quickly from paper Theorem 5.
