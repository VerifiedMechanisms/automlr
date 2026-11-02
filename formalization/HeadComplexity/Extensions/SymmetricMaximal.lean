import HeadComplexity.Results.ExactFamilies

set_option linter.style.header false

/-!
# Fork extension: parity is the unique maximal symmetric function (EXT-001 to EXT-004).

formalize.now fork work layered on the upstream symmetric characterization
`HStar_symmetricFn : HStar n (symmetricFn F) = signChanges n F` (paper Theorem 5,
upstream Lean "Theorem 12"). Every result here is a corollary of that theorem
together with elementary facts about the sign-change count; nothing here concerns
transformers beyond the upstream one-layer attention-only model, and nothing here
concerns non-symmetric Boolean functions (whose head complexity can exceed `n`,
see upstream `HStar_le_universal_boolean`).

* **EXT-001** `signChanges_le`: a profile changes value at most `n` times along
  `0, …, n`; hence `HStar_symmetricFn_le : HStar n (symmetricFn F) ≤ n`.
* **EXT-002** `signChanges_not`: complementing the profile preserves the count;
  hence `HStar_not_symmetricFn`.
* **EXT-003** `signChanges_eq_self_iff`: the count is maximal exactly when every
  adjacent profile value flips.
* **EXT-004** `HStar_symmetricFn_eq_self_iff`: a symmetric Boolean function on
  `n` bits needs exactly `n` heads iff it is parity or the complement of parity.
  Profile-level form: `signChanges_eq_self_iff_parity`.

All statements hold for every `n : ℕ`, including `n = 0`, where both sides of
EXT-004 are true for every profile (`HStar 0 _ = 0`, and every function on the
zero-bit cube is constant, so it equals `PARITY 0` or its complement).

Everything lives in the sub-namespace `HeadComplexity.Ext` so that fork names can
never collide with future upstream declarations.
-/

namespace HeadComplexity.Ext

open Finset

variable {n : ℕ}

/-! ## EXT-001: the sign-change count is at most `n` -/

/-- **EXT-001.** A weight profile changes value at most `n` times along `0, …, n`. -/
theorem signChanges_le (n : ℕ) (F : ℕ → Bool) : signChanges n F ≤ n := by
  unfold signChanges
  exact (card_filter_le _ _).trans (card_range n).le

/-- **EXT-001 (head form).** Every symmetric Boolean function on `n` bits is
computable with at most `n` heads. -/
theorem HStar_symmetricFn_le (n : ℕ) (F : ℕ → Bool) :
    HStar n (symmetricFn F) ≤ n := by
  rw [HStar_symmetricFn]
  exact signChanges_le n F

/-! ## EXT-002: complement invariance -/

/-- **EXT-002.** Complementing a profile preserves its sign-change count. -/
theorem signChanges_not (n : ℕ) (F : ℕ → Bool) :
    signChanges n (fun k => !F k) = signChanges n F := by
  unfold signChanges
  congr 1
  refine filter_congr fun t _ => ?_
  dsimp only
  generalize F t = a
  generalize F (t + 1) = b
  cases a <;> cases b <;> simp

/-- The complement of a symmetric function is the symmetric function of the
complemented profile (definitional). -/
theorem not_symmetricFn (F : ℕ → Bool) :
    (fun bits : Fin n → Bool => !symmetricFn F bits) = symmetricFn (fun k => !F k) := rfl

/-- **EXT-002 (head form).** A symmetric Boolean function and its complement have
the same head complexity. -/
theorem HStar_not_symmetricFn (n : ℕ) (F : ℕ → Bool) :
    HStar n (fun bits => !symmetricFn F bits) = HStar n (symmetricFn F) := by
  rw [not_symmetricFn, HStar_symmetricFn, HStar_symmetricFn, signChanges_not]

/-- The complement of parity needs exactly `n` heads (EXT-002 applied to upstream
`signChanges_parity`). -/
theorem HStar_not_parity (n : ℕ) : HStar n (fun bits => !PARITY n bits) = n := by
  rw [PARITY_eq_symmetricFn, HStar_not_symmetricFn, HStar_symmetricFn, signChanges_parity]

/-! ## EXT-003: maximal count iff every adjacent value flips -/

/-- **EXT-003.** The sign-change count equals `n` exactly when every adjacent pair
of profile values along `0, …, n` differs. -/
theorem signChanges_eq_self_iff (n : ℕ) (F : ℕ → Bool) :
    signChanges n F = n ↔ ∀ k < n, F (k + 1) = !F k := by
  unfold signChanges
  constructor
  · intro h k hk
    have hfull : (range n).filter (fun t => F t ≠ F (t + 1)) = range n :=
      eq_of_subset_of_card_le (filter_subset _ _) (by rw [h, card_range])
    have hmem : k ∈ (range n).filter (fun t => F t ≠ F (t + 1)) := by
      rw [hfull]; exact mem_range.mpr hk
    have hne := (mem_filter.mp hmem).2
    revert hne
    generalize F k = a
    generalize F (k + 1) = b
    cases a <;> cases b <;> simp
  · intro h
    rw [filter_true_of_mem, card_range]
    intro t ht
    rw [h t (mem_range.mp ht)]
    generalize F t = a
    cases a <;> simp

/-! ## EXT-004: parity and its complement are the only maximal symmetric functions -/

/-- An alternating profile is determined on `0, …, n` by its value at `0`. -/
theorem alternating_eq (F : ℕ → Bool) (h : ∀ k < n, F (k + 1) = !F k) :
    ∀ k ≤ n, F k = (F 0 ^^ decide (Odd k)) := by
  intro k hk
  induction k with
  | zero => simp
  | succ k ih =>
    rw [h k (by omega), ih (by omega)]
    simp only [Nat.odd_add_one, decide_not]
    generalize F 0 = a
    generalize decide (Odd k) = b
    cases a <;> cases b <;> rfl

/-- **EXT-004 (profile form).** A profile has the maximal sign-change count `n`
iff on `0, …, n` it agrees with the parity profile or with its complement. -/
theorem signChanges_eq_self_iff_parity (n : ℕ) (F : ℕ → Bool) :
    signChanges n F = n ↔
      (∀ k ≤ n, F k = decide (Odd k)) ∨ (∀ k ≤ n, F k = !decide (Odd k)) := by
  rw [signChanges_eq_self_iff]
  constructor
  · intro h
    have halt := alternating_eq F h
    cases h0 : F 0
    · left; intro k hk; rw [halt k hk, h0]; simp
    · right; intro k hk; rw [halt k hk, h0]; simp
  · rintro (hpar | hpar) k hk
    · rw [hpar (k + 1) (by omega), hpar k hk.le]; simp [Nat.odd_add_one, -Nat.not_odd_iff_even]
    · rw [hpar (k + 1) (by omega), hpar k hk.le]; simp [Nat.odd_add_one, -Nat.not_odd_iff_even]

/-- **EXT-004 (main result).** A symmetric Boolean function on `n` bits has head
complexity exactly `n` (the maximum over symmetric functions, EXT-001) iff it is
parity or the complement of parity. Holds for every `n`, including `n = 0`. -/
theorem HStar_symmetricFn_eq_self_iff (n : ℕ) (F : ℕ → Bool) :
    HStar n (symmetricFn F) = n ↔
      symmetricFn F = PARITY n ∨ symmetricFn F = (fun bits => !PARITY n bits) := by
  constructor
  · intro h
    rw [HStar_symmetricFn, signChanges_eq_self_iff_parity] at h
    rcases h with hpar | hpar
    · left; funext bits
      exact hpar _ (hammingWeight_le n bits)
    · right; funext bits
      exact hpar _ (hammingWeight_le n bits)
  · rintro (h | h)
    · rw [h]; exact HStar_parity n
    · rw [h]; exact HStar_not_parity n

/-! ## Edge case `n = 0` (explicit) -/

/-- On zero bits every profile has zero sign changes. -/
theorem signChanges_zero (F : ℕ → Bool) : signChanges 0 F = 0 :=
  Nat.le_zero.mp (signChanges_le 0 F)

/-- **EXT-004 at `n = 0`.** Every symmetric function on the zero-bit cube is parity
or its complement, and both sides of EXT-004 hold. -/
theorem HStar_symmetricFn_zero_cases (F : ℕ → Bool) :
    HStar 0 (symmetricFn F) = 0 ∧
      (symmetricFn F = PARITY 0 ∨ symmetricFn F = (fun bits => !PARITY 0 bits)) := by
  have h : HStar 0 (symmetricFn F) = 0 := by
    rw [HStar_symmetricFn, signChanges_zero]
  exact ⟨h, (HStar_symmetricFn_eq_self_iff 0 F).mp h⟩

end HeadComplexity.Ext
