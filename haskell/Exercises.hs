module Exercises
    ( change,
      firstThenApply,
      powers,
      meaningfulLineCount,
      Shape(Sphere, Box),
      volume,
      surfaceArea,
      BST(Empty),
      size,
      contains,
      insert,
      inorder
    ) where

import qualified Data.Map as Map
import Data.Text (pack, unpack, replace)
import Data.List(isPrefixOf, find)
import Data.Char(isSpace)

change :: Integer -> Either String (Map.Map Integer Integer)
change amount
    | amount < 0 = Left "amount cannot be negative"
    | otherwise = Right $ changeHelper [25, 10, 5, 1] amount Map.empty
        where
          changeHelper [] remaining counts = counts
          changeHelper (d:ds) remaining counts =
            changeHelper ds newRemaining newCounts
              where
                (count, newRemaining) = remaining `divMod` d
                newCounts = Map.insert d count counts

firstThenApply :: [a] -> (a -> Bool) -> (a -> b) -> Maybe b
firstThenApply elements predicate action = action <$> find predicate elements

powers :: Integral a => a -> [a]
powers base = iterate (* base) 1

meaningfulLineCount :: FilePath -> IO Int
meaningfulLineCount path = do
    content <- readFile path
    return $ length $ filter isMeaningful $ lines content
  where
    isMeaningful :: String -> Bool
    isMeaningful line = case dropWhile isSpace line of
      ""    -> False
      '#':_ -> False
      _     -> True

data Shape = Sphere Double
          | Box Double Double Double
          deriving (Show, Eq)

volume :: Shape -> Double
volume (Sphere radius) = (4.0 * pi * radius ^ 3) / 3.0
volume (Box length width height) = length * width * height

surfaceArea :: Shape -> Double
surfaceArea (Sphere radius) = 4.0 * pi * radius ^ 2
surfaceArea (Box length width height) = 2 * (length * width + length * height + width * height)

data BST a
    = Empty
    | Node a (BST a) (BST a)

size :: BST a -> Int
size Empty = 0
size (Node _ left right) = 1 + size left + size right

contains :: Ord a => a -> BST a -> Bool
contains _ Empty = False
contains value (Node nodeValue left right)
    | value == nodeValue = True
    | value < nodeValue  = contains value left
    | otherwise          = contains value right

inorder :: BST a -> [a]
inorder Empty = []
inorder (Node value left right) = inorder left ++ [value] ++ inorder right

insert :: Ord a => a -> BST a -> BST a
insert value Empty = Node value Empty Empty
insert value (Node nodeValue left right)
    | value < nodeValue = Node nodeValue (insert value left) right
    | value > nodeValue = Node nodeValue left (insert value right)
    | otherwise = Node nodeValue left right

instance (Show a) => Show (BST a) where
    show Empty = "()"
    show (Node value Empty Empty) = "(" ++ show value ++ ")"
    show (Node value left Empty) = "(" ++ show left ++ show value ++ ")"
    show (Node value Empty right) = "(" ++ show value ++ show right ++ ")"
    show (Node value left right) = "(" ++ show left ++ show value ++ show right ++ ")"