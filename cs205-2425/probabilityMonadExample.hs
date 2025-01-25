{-
# A monad for probabilistic programming
-}

import Data.List ( (\\) )

{-
   In this file we do an example of a user-defined monad, just for your
   edification. This will be something called the **probability monad**

   First we define the associated type constructor. It will map a type T to an
   encoding of (discrete) probability distribution with (finite support) over the
   type T. Here we are going to encode this by lists of pairs of a value of
   type T with a Double value that encode the probability of drawing the value.
-}
newtype Dist a = Dist [(a, Double)]
  deriving (Show, Eq)

{-
   Throughout the file, we will assume that all values of type Dist a that we
   manipulate represent genuine probability distributions, that is that for
   each value Dist xs:
  
   * for each pair (x, p) in xs, 0 <= p && p <= 1

   * that sum (map fst xs) == 1 (up to rounding errors...)

   Here is for instance a function that takes a list of values and builds
   the uniform distribution on it
-}

uniform :: [a] -> Dist a
uniform xs = Dist [(x, 1 / fromIntegral (length xs)) | x <- xs]

-- >>> uniform [0..7] 
-- Dist [(0,0.125),(1,0.125),(2,0.125),(3,0.125),(4,0.125),(5,0.125),(6,0.125),(7,0.125)]

-- >>> uniform [True, False]
-- Dist [(True,0.5),(False,0.5)]

{-
Another operator would be e.g. conditional probabilities
-}

condition :: (b -> Bool) -> Dist b -> Dist b
condition p (Dist xs) = Dist (normalize . filter (p . fst) $ xs)
  where normalize ys = [(x, p / mass ys) | (x, p) <- ys]
        mass = sum . map snd

-- >>> condition even (uniform [0..7])
-- Dist [(0,0.25),(2,0.25),(4,0.25),(6,0.25)]


{-
   While I claim in the slide that the monad typeclass is defined using only
   two operators, (>>=) and return, the concrete implementation in Haskell
   asks us to define more operations corresponding to the typeclasses Functor
   and Applicative (which take the same type constructor argument as Monad).
   In theory, instances from these typeclasses can be derived from instances
   for Monad, but in practice we may want optimized operations for the
   associated operations, so let us implement them
-}


{-
   The Functor typeclass has a single method fmap that is the perfect analogue
   for map for list.
-}
instance Functor Dist where
  fmap :: (a -> b) -> Dist a -> Dist b
  fmap f (Dist xs) = Dist (map (\(x,p) -> (f x, p)) xs)

{- 
   In most cases, we expect fmap to satisfy the following equality always:
```
     fmap f . fmap g = fmap (f . g)
```
   This is not enforced by the compiler, but by convention we tend to assume
   that fmap satisfy this. This is helpful when reasoning about complex
   programs/attempting to refactor code
-}


{- 
   The Applicative typeclass has two methods: pure, which is actually the same
   as return for monads, and (<*>) which allows to essentially apply a wrapped
   function to a wrapped input
   We also typically expect the following law to be satisfied for all Applicative
   instances:
```
     pure f <*> pure x = pure (f x)
```
-}
instance Applicative Dist where
  pure :: a -> Dist a
  pure x = Dist [(x, 1)]
  (<*>) :: Dist (a -> b) -> Dist a -> Dist b
  (Dist fs) <*> (Dist xs) = Dist [ (f x, p * q) | (f, p) <- fs, (x, q) <- xs ]

{-
  Finally we can implement out monad instance
-}
instance Monad Dist where
  (>>=) :: Dist a -> (a -> Dist b) -> Dist b
  (Dist xs) >>= f = Dist [ (x, p * q) | (y, p) <- xs,
                                        let Dist ys = f y,
                                        (x, q) <- ys ]
{-
   We do not write an explicit definition for return, the Monad typeclass
   simply takes into account that Applicative is a prerequisite to Monad and
   sets return = pure
   We also typically want the monad typeclass to satisfy a bunch of laws that
   essentially says that the chaining operator is associative and that return
   is neutral wrt chaining

```
  return x >>= f   =   f x
  x >>= return     =   x
  (x >>= f) >>= g  =   x >>= (\y -> f y >>= g)
```

   In this example with the distribution monad, we can compute the result of
   applying the result of applying discrete stochastic processes to distributions
   and get back distributions without making use of true random choice. This
   gives more flexibility than just implementing a function with side-effects
   that directly do a random draw; for instance, we can instrospect
   distributions and compute expectancy, variance, ...
    (there is in fact a whole field of probabilistic programming, in which
     functional ideas have a lot of influence)



   Here is a small example of approximating the solution to a probability
   exercise: assume I split a pile of card into two at random, and then
   I split the smaller pile that I obtain into two again, how many cards can
   I expect on average in the pile which contain the intermediate amount of
   cards?

   Let us first define a function that gives us the distribution of the size
   of the intermediate pile
-}

splitCards :: Int -> Dist Int
splitCards n = split n >>= \(st1, st2) ->
               split (min st1 st2) >>= \(sst1, sst2) ->
               return (max sst1 sst2)
     where split k = uniform [(x, k - x) | x <- [1..k-1]]

{-
   Then let us compute the expectancy of the proportion of cards in the
   intermediate pile:
-}
splitCardsExpProportion :: Int -> Double
splitCardsExpProportion n = 
  (/fromIntegral n) . expectancy . fmap fromIntegral . splitCards $ n

-- >>> splitCardsExpProportion 6
-- 0.13333333333333333

-- >>> splitCardsExpProportion 10
-- 0.16481481481481483

-- >>> splitCardsExpProportion 100
-- 0.18666257463798935

{-
   For another example, we model the Monty Hall problem, which goes as follows:
     We have a TV show where we have three doors. One of them leads to a cash
     prize of £1000, all the others lead to nothing valuable.
     The contestant picks a door where they think the prize might be. Then
     a non-winning door is opened at random (there can be one or two); the
     contestant is given the option of changing their choice before their door
     is opened and they know if they win or not.
  
   The question is: should they change their choice or not?
  
   Let us compute the expected money in function of each scenario:
-}

expectancy :: Dist Double -> Double
expectancy (Dist xs) = sum (map (uncurry (*)) xs)

stayOnTheSameDoor :: Dist Double
stayOnTheSameDoor = uniform allDoors >>= \winningDoor ->
                    -- the presentator picks a winning door 0, 1 or 2 at random
                    uniform allDoors >>= \contestantPick ->
                    -- the contestant picks a door at random
                    let otherDoors = allDoors \\ [contestantPick, winningDoor] in
                    uniform otherDoors >>= \openedDoor ->
                    -- the presentator opens another non-winning door at random
                    let finalContestantPick = contestantPick in
                    -- we don't change the choice of the contestant
                    -- then we return the monetary outcome
                    if finalContestantPick == winningDoor then
                        return 1000
                    else
                        return 0
      where    allDoors = [0, 1, 2]

-- >>> expectancy stayOnTheSameDoor
-- 333.3333333333333


changeDoor :: Dist Double
changeDoor = do winningDoor <- uniform allDoors;
                -- the presentator picks a winning door 0, 1 or 2 at random
                contestantPick <- uniform allDoors
                    -- the contestant picks a door at random
                let otherDoors = allDoors \\ [contestantPick, winningDoor]
                openedDoor <- uniform otherDoors
                -- the presentator opens another door at random
                let [finalContestantPick] = allDoors \\ [contestantPick, openedDoor];
                -- we change the choice of the contestant
                -- then we return the monetary outcome
                if finalContestantPick == winningDoor then
                   return 1000
                else
                   return 0
      where allDoors = [0, 1, 2]

-- >>> expectancy changeDoor
-- 666.6666666666666

{-
   So conclusion, better change your choice in that case!

   Hopefully that demonstrates a nice, but very simple, of using monadic
   style for probabilistic programming. There are of course more sophisticated
   things one can do with this (in particular, when it comes to optimizing the
   efficiency of code and introducing actual continuous probabilities).
-}


