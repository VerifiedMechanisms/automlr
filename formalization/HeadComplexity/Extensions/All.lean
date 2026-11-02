import HeadComplexity.Extensions.SymmetricMaximal

set_option linter.style.header false

/-!
# formalize.now fork extensions: entry points

A machine-checked table of contents for the fork-extension identifiers
(`EXT-xxx`) recorded in `formalize-now/RPI.json`. Each alias names the headline
Lean statement for one identifier. This file sits outside the upstream root
module `HeadComplexity.lean`; `artifacts/scripts/validate.sh` builds and
axiom-audits it because it audits every tracked `.lean` file under
`formalization/`.
-/

namespace HeadComplexity.Ext

/-- **EXT-001.** `signChanges n F ≤ n`. -/
alias ext001_signChanges_le := signChanges_le

/-- **EXT-001 (head form).** `HStar n (symmetricFn F) ≤ n`. -/
alias ext001_HStar_symmetricFn_le := HStar_symmetricFn_le

/-- **EXT-002.** `signChanges n (fun k => !F k) = signChanges n F`. -/
alias ext002_signChanges_not := signChanges_not

/-- **EXT-002 (head form).** Complementing a symmetric function preserves `HStar`. -/
alias ext002_HStar_not_symmetricFn := HStar_not_symmetricFn

/-- **EXT-003.** `signChanges n F = n ↔ ∀ k < n, F (k + 1) = !F k`. -/
alias ext003_signChanges_eq_self_iff := signChanges_eq_self_iff

/-- **EXT-004 (profile form).** Maximal count iff the profile is parity or its
complement on `0, …, n`. -/
alias ext004_signChanges_eq_self_iff_parity := signChanges_eq_self_iff_parity

/-- **EXT-004 (main result).** `HStar n (symmetricFn F) = n` iff the function is
`PARITY n` or its complement. -/
alias ext004_HStar_symmetricFn_eq_self_iff := HStar_symmetricFn_eq_self_iff

end HeadComplexity.Ext
