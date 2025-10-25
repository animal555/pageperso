import Prelude hiding (sum, gcd)
import Data.List ( delete )

{-
   Some examples of recursion, otogether with pattern-matching.
-}


factorial :: Integer -> Integer
factorial 0 = 1
factorial n = n * factorial (n - 1)

-- >>> factorial 15
-- 1307674368000

gcd n 0 = n
gcd n m | n < m = gcd m n
        | otherwise = gcd m (n `mod` m)

-- >>> gcd 16 12
-- 4

sum :: Num a => [a] -> a
sum [] = 0
sum (x : xs) = x + sum xs

-- >>> sum [1..10]
-- 55

removeDuplicates :: Eq a => [a] -> [a]
removeDuplicates xs = removeDuplicatesAndSeen [] xs
  where removeDuplicatesAndSeen :: Eq a => [a] -> [a] -> [a]
        removeDuplicatesAndSeen _ [] = []
        removeDuplicatesAndSeen seen (x : xs) | x `elem` seen = removeDuplicatesAndSeen seen xs
                                              | otherwise = x : removeDuplicatesAndSeen (x : seen) xs
-- >>> removeDuplicates "Hello how are you today?"
-- "Helo hwaryutd?"


swapEvenAndOdd :: [a] -> [a]
swapEvenAndOdd (x : y : xs) = y : x : swapEvenAndOdd xs
swapEvenAndOdd xs = xs

-- >>> swapEvenAndOdd "Hello how are you today?"
-- "eHll ooh wra eoy uotad?y"

removeSuccessiveDuplicates :: Eq a => [a] -> [a]
removeSuccessiveDuplicates (x : y : xs) | x == y = removeSuccessiveDuplicates (x : xs)
removeSuccessiveDuplicates (x : xs) = x : removeSuccessiveDuplicates xs
removeSuccessiveDuplicates [] = []

-- >>> removeSuccessiveDuplicates "Helloooo how are you today????"
-- "Helo how are you today?"


removeHalfOfAs :: String -> String
removeHalfOfAs = keepNextA
    where keepNextA [] = []
          keepNextA ('a' : xs) = 'a' : rmNextA xs
          keepNextA (x : xs) = x : keepNextA xs
          rmNextA [] = []
          rmNextA ('a' : xs) = keepNextA xs
          rmNextA (x : xs) = x : rmNextA xs

-- >>> removeHalfOfAs "Helloooo how are you today????"
-- "Helloooo how are you tody????"


removeHalfOfOcc :: String -> String
removeHalfOfOcc = removeHalfOfOccWith []
  where removeHalfOfOccWith _ [] = []
        removeHalfOfOccWith lastSeen (x : xs)
            | x `elem` lastSeen = removeHalfOfOccWith (delete x lastSeen) xs
            | otherwise         = x : removeHalfOfOccWith (x : lastSeen) xs

-- >>> removeHalfOfOcc "Helloooo how are you today????"
-- "Heloo howar yutod??"
