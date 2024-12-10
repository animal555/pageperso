{- Technical note you can ignore:
   By default, a library called Prelude is loaded before every haskell file;
   using the above import statement, I explicitly load Prelude, but I also use
   the hiding command to hide some type and function definitions so that I can
   redeclare them again without Haskell yelling at me because they are the same
   (they are not truly inaccessible, but their names need to be prefixed by the
   library)
-}

import Prelude hiding (String, Maybe, Nothing, Just)

{-

# Type aliasing
  
   Write "type TypeName = SomeType" to declare an alias for SomeType
   This does NOT generate a new type, just some fancy new name that is
   equivalent to SomeType. It can be useful sometimes, but it can also be
   confusing if you abuse it (especially since in error message, ghc will have
   to pick between TypeName and SomeType, and that can be cumbersome sometimes).

   This one is defined in Prelude
-}

type String = [Char]

type Pos = (Int, Int)

origin :: Pos
origin = (0,0)

{-
   Note that Pos and (Int, Int) are completely equivalent

```
   >>> :t (origin :: (Int, Int))
   (origin :: (Int, Int)) :: (Int, Int)

   >>> fst origin
   0
```

A type alias with a parameter
-}

type Pair a = (a,a)

mkPair :: a -> a -> Pair a
mkPair x y = (x,y)

{-
   Example of nesting type aliases
-}
type Triple a = (Pair a, a)

{-
# Defining new (algebraic) datatypes

   Now the truly interesting bit is how to declare brand new datatypes

   We will first see the most simple case: defining a finite datatype by giving
   a list of possible values for the type called _constructors_.
   Maybe the most important example, which is defined in Prelude, is the case
   of Booleans

```haskell
   data Bool = False | True
```

   Here the syntax is `data TypeName = Constructor1 | ... | Constructorn`
   It should informally be read as "I define a new datatype, called Bool, and
   an element of Bool is either `True` or `False`"

   Let us look at a similar example with three elements (and which is not declared
   in the standard library!)
-}

data Answer = Yes | No | Unknown

{-
   An element of Answer is either Yes, No or Unknown. We can for instance
   define a list containing all possible values for Answer

```
>>> :t Yes
Yes :: Answer
```
-}

allAnswers :: [Answer]
allAnswers = [Yes,No,Unknown]

{-
   Pattern-matching can be done against arbitrary algebraic datatypes. For the
   simple examples, this is straightforward: we can use the constructor as
   patterns.
-}

oppositeAnswer :: Answer -> Answer
oppositeAnswer Yes = No
oppositeAnswer No  = Yes
oppositeAnswer _   = Unknown

{-
   Now let us look at a more complicated example where we can attach parameters
   to constructors when declaring a new datatype.
   We can declare that a constructor should take some arguments by putting
   some list of types for the arguments. Here is an example.
-}
data Shape = Circle Double | Rect Double Double
{-
   This should be read informally as "An element of `Shape` is either of shape
   `Circle x` where `x` is a `Double` or a `Rect x y` where `x` and `y` are `Double`s"
  
   The constructors now are built-in functions that allow to build concrete
   values
-}

-- >>> :t (Circle, Rect)
-- (Circle, Rect) :: (Double -> Shape, Double -> Double -> Shape)

someCircle :: Shape
someCircle = Circle 2

square :: Double -> Shape
square n = Rect n n

{-
   Pattern-matching ca be extended to such ADTs. To pattern-match against a
   constructor with declaration Constr Type_1 ... Type_n, one can use a
   pattern Constr p_1 ... p_n (where p_1, ... p_n are patterns for Type_1, ...
   Type_n).
   Here is an example
-}

area :: Shape -> Double
area (Circle r) = pi * r^2
area (Rect x y) = x * y

{-
   Now, to add another layer of complexity, let us consider parameterized
   datatypes. Much like with type aliases, new ADT declarations can include
   type parameters, declared on the left-hand side using lower-case variables.
   Those type variables can then be used for the types given as argument to
   constructors

   Here is an example, which is already declared in Prelude (and is massively
   useful when dealing with partial functions)
-}

data Maybe a = Nothing | Just a

{-
   This should be read as "an element of Maybe a is either equal to Nothing, or
   to Just x for some x :: a"
-}

-- >>> :t (Nothing, Just)
-- (Nothing, Just) :: (Maybe a1, a2 -> Maybe a2)

someListOfMaybeInt :: [Maybe Int]
someListOfMaybeInt = [Nothing, Just 1, Just 0]

{-
   An example of a typical use of Maybe: defining a variant of head that never
   triggers a run-time error
-}

safeHead :: [a] -> Maybe a
safeHead []      = Nothing
safeHead (x : _) = Just x

{-
   Like before, pattern-matching can be used; here is a simple example
-}
maybeToList :: Maybe a -> [a]
maybeToList Nothing  = []
maybeToList (Just x) = [x]

{-
   Here is an example where I additionally demonstrate that you can nest
   patterns when pattern matching - this generalizes to any mix of ADTs
-}
maybeMult :: Maybe (Maybe a) -> Maybe a
maybeMult (Just (Just x)) = Just x
maybeMult (Just Nothing)  = Nothing
maybeMult Nothing         = Nothing

{-
   Now, let us see maybe the last feature that makes ADT extremely powerful.
   One can use the type being declared recursively in the constructors.
  
   One of the most classical examples from logic (which is not very useful in
   practice but is arguably the simplest one) is the unary encoding of natural
   numbers (nonnegative integers) using the following declaration
-}
data Nat = Zero | Succ Nat
{-
   This should be read as "A natural number is either 0, or n + 1 for some
   natural number n" (we typically call the map λ n → n + 1 "successor" in
   logic)

   We can then form values using the constructors as usual, but we need several
   nesting if we use Succ
-}

firstThreeNat :: [Nat]
firstThreeNat = [ Zero, Succ Zero, Succ (Succ Zero) ]

{-
   Once again, we can use pattern-matching freely to define functions
-}

isGreaterThanTwo :: Nat -> Bool
isGreaterThanTwo Zero = False
isGreaterThanTwo (Succ Zero) = False
isGreaterThanTwo _ = True

{-
   Typically, to write interesting functions over recursively defined ADTs, we
   will also need recursion. Here is a typical example, converting Nat to int
   values
-}

natToInt ::Nat -> Int
natToInt Zero = 0
natToInt (Succ n) = 1 + natToInt n

intToNat :: Int -> Nat
intToNat 0 = Zero
intToNat x = Succ (intToNat (x-1))

-- And here is the official definition of addition over unary number (as logicians
-- typically axiomatize it...)
addNat :: Nat -> Nat -> Nat
addNat x Zero = x
addNat x (Succ y) = Succ (addNat x y)

-- >>> natToInt (addNat (intToNat 4) (intToNat 1) )
-- 5

{-
   Okay, so something annoying: we can't have ghci display values for Nat
   because there is no Show Nat typeclass instance.
  
    >>> Zero
   No instance for (Show Nat) arising from a use of ‘evalPrint’
  
   We could provide one by hand (once I show you the syntax), but that's a
   relatively boring task that we can ask ghc to automate when we declare new
   types using the "deriving" command as follow
-}

data Nat2 = Zero2 | Succ2 Nat2 deriving Show

-- >>> Succ2 (Succ2 Zero2)
-- Succ2 (Succ2 Zero2)

-- >>> (reverse . show) (Succ2 Zero2)
-- "2oreZ 2ccuS"

{-
   This will work in a variety of situations, and also for a bunch of further
   typeclasses. For instance we can have
-}
data Nat3 = Zero3 | Succ3 Nat3 deriving (Show, Eq, Ord)
{-
   to additionally derive Eq Nat3 and Ord Nat3 in a generic way. Note that this
   is not always advisable for Ord especially, as ghc is forcing you to pick some
   order for (<=) you might not like. ghc will also not be able to always derive
   all typeclasses instance always, this is limited to a restricted set of typeclasses,
   and those typeclasses cannot be derived for all sort of ADT declarations

   Now, onto a further example: modelling ASTs using ADTs

   One can model arithmetic expressions using the following
-}

data Expr = Val Int | Plus Expr Expr | Mult Expr Expr
  deriving (Show, Eq, Ord)

{-
   For instance, 1 + 2 * 3 would be represented by
-}
exprEx :: Expr
exprEx = Plus (Val 1) (Mult (Val 2) (Val 3))

{-
   Here is an example of an evaluation function, defined by recursion
-}
eval :: Expr -> Int
eval (Val n) = n
eval (Plus e f) = eval e + eval f
eval (Mult e f) = eval e * eval f

-- >>> eval exprEx
-- 7

{-
  Last example (generalizing the one from the slide slightly to handle arbitrary
  ordered dataypes)
-}
data Tree a = Leaf a | Node (Tree a) a (Tree a)

occurs :: Eq a => a -> Tree a -> Bool
occurs m (Leaf n)     = m == n
occurs m (Node l n r) = occurs m l || m == n || occurs m r 

flatten :: Tree a -> [a]
flatten (Leaf n) = [n]
flatten (Node l n r) = flatten l ++ n : flatten r

rootVal :: Tree a -> a
rootVal (Leaf n) = n
rootVal (Node _ n _) = n

occursBST :: Ord a => a -> Tree a -> Bool
occursBST m (Node l n r) | m < n = occursBST m l
                         | m > n = occursBST m r
occursBST m t                    = m == rootVal t
