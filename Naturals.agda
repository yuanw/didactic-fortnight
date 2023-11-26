module Naturals where
-- https://github.com/plfa/plfa.github.io/blob/dev/src/plfa/part1/Naturals.lagda.md
data ℕ : Set where
  zero : ℕ
  suc  : ℕ → ℕ

seven : ℕ
seven = suc (zero)


{-# BUILTIN NATURAL ℕ #-}

import Relation.Binary.PropositionalEquality as Eq
open Eq using (_≡_; refl)
open Eq.≡-Reasoning using (begin_; _≡⟨⟩_; _∎)

_+_ : ℕ → ℕ → ℕ
zero + n = n
(suc m) + n = suc (m + n)

_ : 2 + 3 ≡ 5
_ =
  begin
    2 + 3
  ≡⟨⟩    -- is shorthand for
    (suc (suc zero)) + (suc (suc (suc zero)))
  ≡⟨⟩    -- inductive case
    suc ((suc zero) + (suc (suc (suc zero))))
  ≡⟨⟩    -- inductive case
    suc (suc (zero + (suc (suc (suc zero)))))
  ≡⟨⟩    -- base case
    suc (suc (suc (suc (suc zero))))
  ≡⟨⟩    -- is longhand for
    5
  ∎

-- _ : 2 + 3 ≡ 5
-- _ = refl


_ : 3 + 4 ≡ 7
_ =
  begin
    3 + 4
  ≡⟨⟩    -- is shorthand for
    (suc (suc (suc zero))) + (suc (suc (suc (suc zero))))
  ≡⟨⟩    -- inductive case
    suc ((suc (suc zero)) +  (suc (suc (suc (suc zero)))))
  ≡⟨⟩    -- inductive case
    suc ((suc zero) + (suc (suc (suc (suc (suc zero))))))
  ≡⟨⟩    -- inductive case
    suc (suc (zero +  (suc (suc (suc (suc (suc zero)))))))
 ≡⟨⟩    -- inductive case
    suc (suc  (suc (suc (suc (suc (suc zero ))) )))
  ≡⟨⟩    -- is longhand for
    7
  ∎

_*_ : ℕ → ℕ → ℕ
zero    * n  =  zero
(suc m) * n  =  n + (m * n)

_ =
  begin
    2 * 3
  ≡⟨⟩    -- inductive case
    3 + (1 * 3)
  ≡⟨⟩    -- inductive case
    3 + (3 + (0 * 3))
  ≡⟨⟩    -- base case
    3 + (3 + 0)
  ≡⟨⟩    -- simplify
    6
  ∎

_ =
  begin
    3 * 4
  ≡⟨⟩    -- inductive case
    4 + (2 * 4)
  ≡⟨⟩    -- inductive case
    4 + (4 + (1 * 4))
  ≡⟨⟩    -- base case
    4 + (4 + (4 + (0 * 4)))
  ≡⟨⟩    -- simplify
    4 + (4 + ( 4  + 0))
  ≡⟨⟩    -- simplify
    12
  ∎


_^_ : ℕ → ℕ → ℕ
m ^ zero        =  1
m ^ (suc  n)  =  m * (m ^ n)

_ =
  begin
    3 ^ 4
  ≡⟨⟩    -- inductive case
    3 * (3 ^ 3)
  ≡⟨⟩    -- inductive case
    3 * (3 * ( 3 ^ 2))
   ≡⟨⟩    -- inductive case
    3 * (3 * ( 3 * (3 ^ 1)))
   ≡⟨⟩    -- inductive case
    3 * (3 * ( 3 * (3 * ( 3 ^ 0 ))))
   ≡⟨⟩    -- inductive case
    3 * (3 * ( 3 * (3 * ( 1 ))))
  ≡⟨⟩    -- simplify
    81
  ∎
