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

-- import Main.Utf8 qualified as Utf8

import TryEffectful

main :: IO ()
main = runProgram program

-- main :: IO ()
-- main = do
--   -- For withUtf8, see https://serokell.io/blog/haskell-with-utf8
--   Utf8.withUtf8 $ do
--     putTextLn "Hello 🌎"
