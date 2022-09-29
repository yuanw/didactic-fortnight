{-# LANGUAGE BlockArguments #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE TypeOperators #-}
{-# OPTIONS_GHC -F -pgmF hspec-discover #-}

module Spec (
  spec,
) where

import Effectful (Eff, runPureEff)
import Effectful.Dispatch.Dynamic (reinterpret)
import Effectful.Writer.Dynamic qualified as Writer
import Test.Hspec (Spec, describe, it, shouldBe)
import TryEffectful (Greeting (..), program)

runGreeting :: String -> Eff (Greeting : es) a -> Eff es (a, String)
runGreeting name = reinterpret Writer.runWriterLocal $ const \case
  GetName -> pure name
  Greet n -> Writer.tell $ "greet: " <> n

runProgram :: String -> Eff '[Greeting] a -> (a, String)
runProgram name = runPureEff . runGreeting name

spec :: Spec
spec = do
  describe "program" do
    it "greets us" do
      let (result, greeting) = runProgram "Drew" program

      result `shouldBe` ()
      greeting `shouldBe` "greet: Drew"
