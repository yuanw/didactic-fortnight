{-# LANGUAGE DeriveFunctor #-}
{-# LANGUAGE DerivingStrategies #-}

module Expressions where

import Control.Monad (MonadPlus)
import Free
import GHC.Base ((<|>))

-- data Expr
--   = Num Double
--   | Add Expr Expr
--   | Mul Expr Expr
--   | Div Expr Expr
--   | Sqrt Expr

--https://kowainik.github.io/posts/deriving
data ExprF k
  = NumF Double
  | AddF k k
  | MulF k k
  | DivF k k
  | SqrtF k
  deriving stock (Functor)

-- eval :: (MonadPlus m, MonadFail m) => Expr -> m Double
-- eval (Num x) = return x
-- eval (Add px py) = do
--   x <- eval px
--   y <- eval py
--   return (x + y)
-- eval (Mul px py) = do
--   x <- eval px
--   y <- eval py
--   return (x * y)
-- eval (Div px py) = do
--   x <- eval px
--   y <- eval py wd
--   case y of
--     0 -> fail "Divide by Zero"
--     _ -> return (x / y)
-- eval (Sqrt px) = do
--   x <- eval px
--   return (sqrt x) <|> return (-(sqrt x))

-- --https://gitlab.haskell.org/ghc/ghc/-/issues/12160
-- instance MonadFail (Either String) where
--   fail = Left

-- evalMaybe :: Expr -> Maybe Double
-- evalMaybe = eval
