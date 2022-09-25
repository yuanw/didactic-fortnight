{-# LANGUAGE BlockArguments #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE TypeOperators #-}

module Main where

import Effectful (Eff, Effect, IOE, MonadIO (liftIO), runEff, type (:>))
import Effectful.Dispatch.Dynamic (interpret)
import Effectful.TH (makeEffect)

-- import Main.Utf8 qualified as Utf8

{- |
 Main entry point.

 The `bin/run` script will invoke this function.
-}
data Greeting :: Effect where
  GetName :: Greeting m String
  Greet :: String -> Greeting m ()

makeEffect ''Greeting

program :: (Greeting :> es) => Eff es ()
program = do
  name <- getName

  greet name

runGreeting :: (IOE :> es) => Eff (Greeting : es) a -> Eff es a
runGreeting = interpret $ const \case
  GetName -> liftIO getLine
  Greet name -> liftIO $ putStrLn $ "Hello, " <> name <> "!"

runProgram :: Eff '[Greeting, IOE] a -> IO a
runProgram = runEff . runGreeting

main :: IO ()
main = runProgram program

-- main :: IO ()
-- main = do
--   -- For withUtf8, see https://serokell.io/blog/haskell-with-utf8
--   Utf8.withUtf8 $ do
--     putTextLn "Hello 🌎"
