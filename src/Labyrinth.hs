-- | https://en.wikibooks.org/wiki/Haskell/Zippers#Theseus_and_the_Zipper
module Labyrinth where

data Node a
  = DeadEnd a
  | Passage a (Node a)
  | Fork a (Node a) (Node a)

get :: Node a -> a
get (DeadEnd x) = x
get (Passage x _) = x
get (Fork x _ _) = x

put :: a -> Node a -> Node a
put v (DeadEnd _) = DeadEnd v
put v (Passage _ rest) = Passage v rest
put v (Fork _ left right) = Fork v left right

-- turnRight :: Node a -> Maybe (Node a)
-- turnRight (Fork _ l r) = Just r
-- turnRight _            = Nothing

data Branch
  = KeepStraightOn
  | TurnLeft
  | TurnRight
type Thread = [Branch]

turnRight :: Thread -> Thread
turnRight t = t ++ [TurnRight]

retrieve :: Thread -> Node a -> a
retrieve [] n = get n
retrieve (KeepStraightOn : bs) (Passage _ n) = retrieve bs n
retrieve (TurnLeft : bs) (Fork _ l r) = retrieve bs l
retrieve (TurnRight : bs) (Fork _ l r) = retrieve bs r
retrieve _ (DeadEnd _) = undefined

update :: (a -> a) -> Node a -> Node a
update f (DeadEnd x) = DeadEnd (f x)
update f (Passage x rest) = Passage (f x) rest
update f (Fork x left right) = Fork (f x) left right
