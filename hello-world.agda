{-# OPTIONS --guardedness #-}

module hello-world where

open import Agda.Builtin.IO using (IO)
open import Agda.Builtin.Unit using (⊤)
open import Agda.Builtin.String using (String)

postulate putStrLn : String → IO ⊤
{-# FOREIGN GHC import qualified Data.Text as T #-}
{-# COMPILE GHC putStrLn = putStrLn . T.unpack #-}
import Relation.Binary.PropositionalEquality as Eq
open Eq using (_≡_; refl)
open Eq.≡-Reasoning using (begin_; _≡⟨⟩_; _∎)
import Data.Nat using (ℕ; zero; suc; _+_; _*_; _^_; _∸_)

data ℕ : Set where
  zero : ℕ
  suc  : ℕ → ℕ

prev : ℕ  → ℕ
prev zero = zero
prev (suc k) = k

main : IO ⊤
main = putStrLn "Hello world!"
