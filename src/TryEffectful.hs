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

module TryEffectful where

import Effectful (Eff, Effect, IOE, MonadIO (liftIO), runEff, type (:>))
import Effectful.Dispatch.Dynamic (interpret)
import Effectful.TH (makeEffect)

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
