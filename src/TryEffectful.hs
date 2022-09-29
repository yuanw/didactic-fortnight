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

import Effectful
import Effectful.Dispatch.Dynamic

data Greeting :: Effect where
  GetName :: Greeting m String
  Greet :: String -> Greeting m ()

type instance DispatchOf Greeting = 'Dynamic

getName :: (HasCallStack, Greeting :> es) => Eff es String
getName = send GetName

greet :: (HasCallStack, Greeting :> es) => String -> Eff es ()
greet = send . Greet

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
