{-
# List comprehension through examples

First example
-}
fiveSquares :: [Integer]
fiveSquares = [x^2 | x <- [1..5]]

-- >>> fiveSquares
-- [1,4,9,16,25]

{-
  Second example with two generators
-}
somePairs :: [(Integer, Integer)]
somePairs = [(x,y) | x <- [1,2,3], y <- [4, 5]]

-- >>> somePairs
-- [(1,4),(1,5),(2,4),(2,5),(3,4),(3,5)]

{-
   Same example with generators swapped - note it influences the ordering of the
   result
-}
someOtherPairs :: [(Integer, Integer)]
someOtherPairs = [(x,y) | y <- [4,5], x <- [1,2,3]]

-- >>> someOtherPairs
-- [(1,4),(2,4),(3,4),(1,5),(2,5),(3,5)]

{-
   Third example - dependent generators
-}

yetAnotherListOfPairs :: [(Integer, Integer)]
yetAnotherListOfPairs = [ (x,y) | x <- [1..3], y <- [x..3] ]

-- >>> yetAnotherListOfPairs
-- [(1,1),(1,2),(1,3),(2,2),(2,3),(3,3)]

{-
   re-implementation of concat using dependent generators
-}
myConcat :: [[a]] -> [a]
myConcat xss = [ x | xs <- xss, x <- xs ]

-- >>> myConcat [[1..3],[0..10],[2..5]]
-- [1,2,3,0,1,2,3,4,5,6,7,8,9,10,2,3,4,5]

{-
   Examples of using guards
-}
someEvenNumbers :: [Integer]
someEvenNumbers = [ x | x <- [1..10], even x]

myFilter :: (a -> Bool) -> [a] -> [a]
myFilter p xs = [ x | x <- xs, p x ]

-- >>> someEvenNumbers
-- [2,4,6,8,10]

{-
   some of the more advanced examples
-}
prime :: Int -> Bool
prime n = factorsUpTo (iSqrt n) == [1]
  where factorsUpTo k = [x | x <- [1..k], n `mod` x == 0]
        iSqrt         = ceiling . sqrt . fromIntegral

sorted :: Ord a => [a] -> Bool
sorted xs = all (uncurry (<=)) pairs
  where pairs = zip xs $ safeTail xs
        safeTail [] = []
        safeTail (_ : xs) = xs

positions :: Eq a => a -> [a] -> [Int]
positions x xs = [i | (y, i) <- zip xs [0..n], x == y]
  where n = length xs


{-
## Bonus material: how to translate list comprehension to higher-order functions

   one can define two helpful combinators for that. The first one is defined
   in the base and is called (>>=) (prononced "bind"). This is in fact part of
   a rather scary typeclass
-}

-- >>> :t (>>=)
-- (>>=) :: Monad m => m a -> (a -> m b) -> m b

{-
 Over list, the type is as follows
-}

-- >>> :t (>>=) :: [a] -> (a -> [b]) -> [b]
-- (>>=) :: [a] -> (a -> [b]) -> [b] :: [a] -> (a -> [b]) -> [b]


{-
   Exercise: after experimenting, like with e.g.
-}
-- >>> [1..5] >>= \x -> replicate x (show x) 
-- ["1","2","2","3","3","3","4","4","4","4","5","5","5","5","5"]

{-
   find out how to write your own definition for (>>=) over lists

   Another useful function for the translation would be the following
-}

(?>) :: Bool -> [a] -> [a]
True ?> xs = xs
False ?> _ = []

{-
   With those, we can easily rewrite the examples above without list
   comprehension; here are a few examples
-}

fiveSquares2 :: [Integer]
fiveSquares2 = [1..5] >>= \x -> [x^2]

somePairs2 :: [(Integer, Integer)]
somePairs2 = [1,2,3] >>= \x -> [4,5] >>= \y -> [(x,y)]

myConcat2 :: [[a]] -> [a]
myConcat2 xss = xss >>= id

someEvenNumbers2 :: [Integer]
someEvenNumbers2 = [1..10] >>= \x -> even x ?> [x]

myFilter2 :: (b -> Bool) -> [b] -> [b]
myFilter2 p xs = xs >>= \x -> p x ?> [x]
