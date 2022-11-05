module Free where

--https://serokell.io/blog/introduction-to-free-monads
-- sig is sigautare of node,
data Free sig a
  = Var a
  | Op (sig (Free sig a))

instance Functor sig => Functor (Free sig) where
  fmap f (Var a) = Var (f a)
  fmap f (Op g) = Op (fmap f <$> g)

instance Functor sig => Applicative (Free sig) where
  pure = Var
  (Var f) <*> g = fmap f g
  (Op f) <*> g = Op ((<*> g) <$> f)

instance Functor sig => Monad (Free sig) where
  (Var x) >>= f = f x
  Op g >>= f = Op ((>>= f) <$> g)

handle :: Functor sig => (sig b -> b) -> (a -> b) -> Free sig a -> b
handle alg gen (Var x) = gen x
handle alg gen (Op g) = undefined (fmap gen g)
