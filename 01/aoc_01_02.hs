{-# LANGUAGE OverloadedStrings #-}

module Main where

import System.IO (readFile)
import Data.Text (splitOn, pack, unpack)
import Data.List (sort)

main = do
    contents <- readFile "input"
    print $ top3 $ map (sum . readInventory . unpack) (splitOn "\n\n" (pack contents))

type Inventory = [Int]

readInventory :: String -> Inventory
readInventory s = map read $ words s

top3 :: Inventory -> Int
top3 i = sum $ take 3 $ reverse $ sort i
