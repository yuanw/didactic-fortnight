{-# OPTIONS --guardedness #-}
module hello-world where

open import Agda.Builtin.IO using (IO)
open import Agda.Builtin.Unit using (⊤)
open import Agda.Builtin.String using (String)

postulate putStrLn : String → IO ⊤
{-# FOREIGN GHC import qualified Data.Text as T #-}
{-# COMPILE GHC putStrLn = putStrLn . T.unpack #-}


data ℕ : Set where
  zero : ℕ
  suc  : ℕ → ℕ

{-# BUILTIN NATURAL ℕ #-}

import Relation.Binary.PropositionalEquality as Eq
open Eq using (_≡_; refl)
open Eq.≡-Reasoning using (begin_; _≡⟨⟩_; _∎)

-- prev : ℕ  → ℕ
-- prev zero = zero
-- prev (suc k) = k

-- _+_ : ℕ → ℕ → ℕ
-- zero + n = n
-- (suc m) + n = suc (m + n)

-- _ : 2 + 3 ≡ 5
-- _ = refl

-- seven : ℕ
-- seven = suc ( suc ( suc (suc ( suc (suc (suc (zero)))))))

-- main : IO ⊤
-- main = putStrLn "Hello world!"
