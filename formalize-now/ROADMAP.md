# Roadmap

Small extensions, each independently verifiable with `artifacts/scripts/validate.sh` and kept in `formalization/HeadComplexity/Extensions/`. Ordered by size.

## Completed

- **EXT-001 to EXT-004.** Parity and its complement are exactly the symmetric Boolean functions with $H^{\ast}(f) = n$. Status: fork-extension-verified (VERIFICATION.md).

## R-001. Threshold degree of symmetric functions (closes ARCH-006)

**Target.** `thresholdDeg (symmetricFn F) = signChanges n F` (paper Theorem 5, middle equality $\deg _{\pm}(f) = C(F)$), then `thresholdDeg (symmetricFn F) = HStar n (symmetricFn F)`.

**Plan.** Both directions exist upstream as ingredients:

1. Upper bound: `symmetricFn_computable F n` gives a $C(F)$-head computation; `signReprDegLe_of_computableWithHeadsN` turns it into `ThresholdDegLE (symmetricFn F) (signChanges n F)`; then `Nat.find_min'` on `thresholdDeg`.
2. Lower bound: `Nat.find_spec` on `thresholdDeg` and `signChanges_le_of_ThresholdDegLE`.

Expected size: about 15 lines. Upgrades ARCH-006 from partial to fully formalized, and yields `thresholdDeg_parity` as a corollary of the symmetric case.

## R-002. Paper-form statements for ARCH-002 and ARCH-003

**Targets.** `HStar n f ≤ 1 ↔ isLTF f` (paper Corollary 1 form) and `thresholdDeg f ≤ HStar n f` (paper Theorem 2 form; needs a head computation to exist for every $f$, which the upstream Theorem 9 construction supplies). These restate upstream results in the paper's exact shape, removing the two form differences noted in the crosswalk.

## R-003. Comparator run

Set up Lean `comparator` with the human-reviewed statements of the ARCH and EXT declarations as the trusted specification, and check the upstream and fork proofs against them. Separate from Lean work; depends on the sandbox requirements of the tool.

## R-004. Counting symmetric functions by head complexity

**Target.** For $0 \leq h \leq n$, the number of profiles on $\lbrace 0, \dots, n\rbrace$ with $C(F) = h$ is $2 \binom{n}{h}$, so exactly $2 \binom{n}{h}$ symmetric functions on $n$ bits have $H^{\ast}(f) = h$. EXT-004 is the case $h = n$. Requires a bijection between profiles and (starting value, change set), a moderate Finset exercise.
