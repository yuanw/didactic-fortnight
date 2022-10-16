{-# OPTIONS_GHC -Wno-incomplete-patterns #-}

module Expressions where

data Expr = Num Double
          | Add Expr Expr
          | Mul Expr Expr
          | Div Expr Expr

eval :: Expr -> Maybe Double
eval (Num x) = Just x
eval (Add px py) = case eval px of
  Nothing -> Nothing
  Just x -> case eval py of
    Nothing -> Nothing
    Just y -> Just (x+y)
eval (Mul px py) = case eval px of
  Nothing -> Nothing
  Just x -> case eval py of
    Nothing -> Nothing
    Just y -> Just (x * y)
eval (Div px py) = case eval px of
  Nothing -> Nothing
  Just x -> case eval py of
    Nothing -> Nothing
    Just 0 -> Nothing --div by zero
    Just y -> Just (x/y)
