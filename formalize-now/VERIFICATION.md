# Verification

All checks below were run in this fork on 2026-11-02. "Upstream-reported" means a claim made by the upstream repository; "reproduced" means it was run here with the output recorded below.

## Environment

| Item | Value |
|---|---|
| Machine | Linux cloud container, 2 vCPU, 7 GB RAM |
| Lean | `4.31.0` via elan (`Lake 5.0.0-src+68218e8`), from `formalization/lean-toolchain` |
| Mathlib | `v4.31.0`, prebuilt cache via `lake exe cache get` (8542 files downloaded and decompressed; no Mathlib source build) |
| Upstream commit | `33daec7fd0092d9215b9692c8241676a3c05a82e` |
| Fork branch | `formalize-now/symmetric-maximal` |

## Upstream-reported verification

Upstream states that the main results must be axiom-clean with `[propext, Classical.choice, Quot.sound]` (`Results/All.lean`) and documents `artifacts/scripts/validate.sh` as the reproducible check (`formalization/BUILDING.md`).

## Reproduction 1: upstream baseline

Command, from the repository root at the pinned commit with a clean worktree:

```bash
bash artifacts/scripts/validate.sh
```

The validator builds every `.lean` file tracked by Git under `formalization/`, rejects any `sorry` or `admit`, and runs `artifacts/scripts/AxiomCheck.lean` on every theorem declaration, which fails on any project-declared axiom or any axiom outside the allowed three.

| Check | Result |
|---|---|
| Build | `Build completed successfully (2413 jobs)`, `BUILD_RC=0`, 41 tracked sources |
| Placeholder scan | `PLACEHOLDER_RC=0` |
| Axiom audit | `Audited 764 theorem declarations across 41 modules.` `Every theorem depends only on allowed axioms #[propext, Classical.choice, Quot.sound].` `AXIOM_RC=0` |
| Overall | `Validation completed successfully.` exit 0 |

**Conclusion:** the upstream verification claim is reproduced at the pinned commit.

## Inclusion of new modules in validation

`validate.sh` collects modules with `git ls-files -z --cached -- '*.lean'` inside `formalization/`. Any new `.lean` file there is built, scanned, and audited as soon as it is staged or committed, with no change to upstream scripts. The extension modules sit outside the upstream root module `HeadComplexity.lean`, so plain `lake build` (default target) leaves them out; `validate.sh` includes them. This was confirmed by the run below.

## Reproduction 2: with fork extensions

Same command, with `Extensions/SymmetricMaximal.lean` and `Extensions/All.lean` staged.

| Check | Result |
|---|---|
| Build | `Build completed successfully (2415 jobs)`, `BUILD_RC=0`, 43 tracked sources, including `Built HeadComplexity.Extensions.SymmetricMaximal` and `Built HeadComplexity.Extensions.All` |
| Placeholder scan | `PLACEHOLDER_RC=0` |
| Axiom audit | `HeadComplexity.Extensions.SymmetricMaximal: audited 17 theorem declarations`, `HeadComplexity.Extensions.All: audited 7 theorem declarations`, `Audited 788 theorem declarations across 43 modules.` (764 upstream plus 24 fork), `AXIOM_RC=0` |
| Overall | `Validation completed successfully.` exit 0 |

Upstream files are byte-identical to the pinned commit; the diff adds files only.

## Axiom output for crosswalked declarations

Command, from `formalization/`:

```bash
lake env lean ../formalize-now/PrintAxioms.lean
```

Every declaration below printed `depends on axioms: [propext, Classical.choice, Quot.sound]`.

| RPI | Declarations |
|---|---|
| ARCH-001 | `HStar_eq_Lfrac`, `SharedHStar_eq_Lfrac`, `computableWithSharedHeadsN_iff_fracComputable` |
| ARCH-002 | `HStar_eq_zero_iff`, `HStar_eq_one_iff` |
| ARCH-003 | `degree_le_of_computableWithHeadsN` |
| ARCH-004 | `thresholdDeg_f10`, `HStar_f10_ge_three`, `f10_strict_separation` |
| ARCH-005 | `HStar_le_weighted_sum`, `HStar_le_universal_boolean` |
| ARCH-006 | `HStar_symmetricFn` |
| ARCH-007 | `HStar_parity` (also `thresholdDeg_parity`) |
| ARCH-009 | `signChanges_parity` |
| EXT-001 | `Ext.signChanges_le`, `Ext.HStar_symmetricFn_le` |
| EXT-002 | `Ext.signChanges_not`, `Ext.HStar_not_symmetricFn`, `Ext.HStar_not_parity` |
| EXT-003 | `Ext.signChanges_eq_self_iff` |
| EXT-004 | `Ext.alternating_eq`, `Ext.signChanges_eq_self_iff_parity`, `Ext.HStar_symmetricFn_eq_self_iff`, `Ext.signChanges_zero`, `Ext.HStar_symmetricFn_zero_cases` |

Exact elaborated statements of the fork extensions, from `#check` in the same script:

```lean
Ext.signChanges_le : ∀ (n : ℕ) (F : ℕ → Bool), signChanges n F ≤ n
Ext.HStar_symmetricFn_le : ∀ (n : ℕ) (F : ℕ → Bool), HStar n (symmetricFn F) ≤ n
Ext.signChanges_not : ∀ (n : ℕ) (F : ℕ → Bool), (signChanges n fun k => !F k) = signChanges n F
Ext.HStar_not_symmetricFn : ∀ (n : ℕ) (F : ℕ → Bool),
  (HStar n fun bits => !symmetricFn F bits) = HStar n (symmetricFn F)
Ext.HStar_not_parity : ∀ (n : ℕ), (HStar n fun bits => !PARITY n bits) = n
Ext.signChanges_eq_self_iff : ∀ (n : ℕ) (F : ℕ → Bool), signChanges n F = n ↔ ∀ k < n, F (k + 1) = !F k
Ext.signChanges_eq_self_iff_parity : ∀ (n : ℕ) (F : ℕ → Bool),
  signChanges n F = n ↔ (∀ k ≤ n, F k = decide (Odd k)) ∨ ∀ k ≤ n, F k = !decide (Odd k)
Ext.HStar_symmetricFn_eq_self_iff : ∀ (n : ℕ) (F : ℕ → Bool),
  HStar n (symmetricFn F) = n ↔ symmetricFn F = PARITY n ∨ symmetricFn F = fun bits => !PARITY n bits
Ext.HStar_symmetricFn_zero_cases : ∀ (F : ℕ → Bool),
  HStar 0 (symmetricFn F) = 0 ∧ (symmetricFn F = PARITY 0 ∨ symmetricFn F = fun bits => !PARITY 0 bits)
```

## Edge case $n = 0$

Every EXT declaration quantifies over all `n : ℕ` with no lower bound, so $n = 0$ is covered by the general statements. `Ext.HStar_symmetricFn_zero_cases` records it explicitly: on the zero-bit cube every symmetric function has $H^{\ast} = 0$ and equals `PARITY 0` (constant false) or its complement (constant true).

## Novelty search for EXT-001 to EXT-004

Run before describing the extensions as fork contributions:

1. Lean library (`formalization/HeadComplexity`, `system-design/formalization`): regex search for sign-change bounds of the form `signChanges … ≤ n`, iff statements with `= n` on `signChanges` or `HStar`, statements involving `PARITY` in an iff, and complemented profiles or `!PARITY`. Only hit: the internal step `Finset.card_filter_le` inside `hammingWeight_le`, which is about Hamming weight.
2. Upstream prose (`theorems.md`, `theorems/`, `writeup/`, Markdown under `formalization/`): search for "unique", "maximal", "complement", "negation", combined with symmetric, parity, or sign. Only relevant hit: `theorems.md` line 159, "every symmetric Boolean function satisfies $H^{\ast}(f) \leq n$" (EXT-001 head form, prose only).
3. Bundled paper text (`pdftotext`): search for "maxim", "unique", "complement", "negat", "parity". The only related statement is EXT-001's head form, as a remark after Theorem 4.

Result: EXT-001 formalizes a paper remark as a named declaration; EXT-002 to EXT-004 are absent from the library, the upstream prose, and the bundled paper.

## Checks that could not be completed

| Item | State |
|---|---|
| Comparator | Not run. The repository has no Comparator setup; the paper's writeup lists Lean `comparator` as future work. Listed as ROADMAP item R-003. |
| Markdown math lint | `AGENTS.md`, `artifacts/hooks/pre-commit`, and `artifacts/scripts/test_check_md_math.py` reference `artifacts/scripts/check_md_math.py`, and that script is absent at the pinned commit. The documents here follow the AGENTS.md rules by hand; the automated lint and KaTeX validation were not run. |
| arXiv PDF | The arXiv copy was rate-limited when fetched on 2026-11-02. Theorem numbers and appendix letters were checked against the bundled `formally-verified-autoresearch-mha.pdf` only. |
| Statement fidelity review | The Lean kernel checks proofs. Whether each upstream formal statement faithfully captures the paper's claim is a human review step; the crosswalk records form differences (ARCH-002, ARCH-003, ARCH-006) and a Lean-expert review of those remains open. |
