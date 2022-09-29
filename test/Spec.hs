{-# LANGUAGE BlockArguments #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE TypeOperators #-}

module Main (
  main,
) where

import Effectful (Eff, runPureEff)
import Effectful.Dispatch.Dynamic (reinterpret)
import Effectful.Writer.Dynamic qualified as Writer
import Test.Hspec (describe, hspec, it, shouldBe)
import TryEffectful (Greeting (..), program)

runGreeting :: String -> Eff (Greeting : es) a -> Eff es (a, String)
runGreeting name = reinterpret Writer.runWriterLocal $ const \case
  GetName -> pure name
  Greet n -> Writer.tell $ "greet: " <> n

runProgram :: String -> Eff '[Greeting] a -> (a, String)
runProgram name = runPureEff . runGreeting name

main :: IO ()
main = hspec $ do
  describe "program" do
    it "greets us" do
      let (result, greeting) = runProgram "Drew" program

      result `shouldBe` ()
      greeting `shouldBe` "greet: Drew"
