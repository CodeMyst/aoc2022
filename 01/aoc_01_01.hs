{-# LANGUAGE OverloadedStrings #-}

module Main where

import System.IO (readFile)
import Data.Text (splitOn, pack, unpack)

main = do
    contents <- readFile "input"
    print $ maximum $ map (sum . readInventory . unpack) (splitOn "\n\n" (pack contents))

type Inventory = [Int]

readInventory :: String -> Inventory
readInventory s = map read $ words s
