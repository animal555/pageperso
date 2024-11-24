import Prelude hiding (not, head, tail)

{-
Conditional expressions
=======================

So far, we have not seen ways of building functions outside of composing
already defined operator. In this note, we introduce the constructs of haskell
that allow for branching.
There will be the standard if/then/else construct, and an idiomatic way of
handling boolean conditions with what are called _guards_. But an arguably
more important notion will be _pattern matching_, which allows to define to
define a function by "inspecting the shape of the argument".


Conditional expressions
-----------------------

In Haskell, we can use an if then else construct which generally has the
following shape.

```
if boolean then
  expr₁
else
  expr₂
```

where `boolean` is an expression of type `Bool` and `expr₁` and `expr₂` have
the same type, say A. This results in an overall expression of type A.
Let us give a couple simple examples
-}

integersFromToZero :: Int -> [Int]
integersFromToZero n = if n >= 0 then
                        [0 .. n-1]
                       else
                        [n+1 .. 0]

fizzBuzz :: (Integral a, Show a) => a -> String
fizzBuzz x = let divisibleBy n m = mod n m == 0 in
              if 3 `divisibleBy` x then
               if 5 `divisibleBy` x then
                 "fizzbuzz"
               else
                 "fizz"
              else if 5 `divisibleBy` x then
                     "buzz"
                   else
                     show x

-- the following is not an example of good style, but might be instructive as
-- an example of a valid definition.

greetings :: Bool -> Bool -> String
greetings a b = (if a then "Hi " else "Hello") ++
                " " ++
                if b then "friend" else "stranger"

{-

The following is not valid as both branches do not have the same type:

someIncorrectCode x = if x == 0 then
                       "78"
                      else 78

Note also that something that is not allowed is having an if/then, but no else
branches, as in

someIncorrectCode2 x = if x /= 0 then
                         x

If you  do this, you will have a syntax error, possibly pointing to the next
non-empty line of your program.


Guards
------

If you have an if/then/else at the toplevel of your expression, there is
another idiomatic piece of syntax you might want to employ called _guards_.
The syntax for a definition using a guard is the following

```
fnName args | condition₁ = body₁
            | condition₂ = body₂
            ...
```

that should be read as "in case conditioni is true, then fnName args is defined
to be bodyi". We can reformulate the first two examples using guards as follows:
-}

integersFromToZeroG :: Int -> [Int]
integersFromToZeroG n | n >= 0 = [0 .. n-1]
                      | otherwise = [n+1 .. 0]

divisibleBy :: Integral a => a -> a -> Bool
n `divisibleBy` m = mod n m == 0

fizzBuzzG :: Int -> String
fizzBuzzG x | 3 `divisibleBy` x = if 5 `divisibleBy` x then
                                    "fizzbuzz"
                                  else
                                    "fizz"
            | 5 `divisibleBy` x = "buzz"
            | otherwise         = show x

{-
Note that the `otherwise` constant is simply an alias for `True`.
>>> otherwise
True

Another thing to note is that the first available line is taken as the
definition, as is probably obvious from how the "otherwise" cases are laid out.

Unlike with if/then/else, there is no obligation of coverage of all cases
with guards. Here is an example
-}

takeVariant :: [Int] -> [Int]
takeVariant xs | head xs >= 0 = take (head xs) (tail xs)
               | null xs      = []

{-

>>> takeVariant [2 .. 10]
[3,4]


Pattern-matching
----------------

Finally, there is another, more primitive idiom to define functions by cases.
The idea is that, in a function declaration

```
fnName arg₁ arg₂ ... | condition = body
```

each of arg₁ can be replaced by a _pattern_ that describes the shape of an
argument. We will later see how and why this is the most primitive way of
doing a conditional in Haskell, but we need to see how to do so in a few
particular cases:

* when the pattern is simply a concrete constant
* when the pattern is for a list argument
* when the pattern is for a tuple argument
* when the pattern is a nesting thereof (this is not _necessary_ but nice to be
aware of)

For our first example, we can give a couple of examples where the pattern is
a constant.
-}

not :: Bool -> Bool
not True = False
not False = True


incrIfNZero :: Int -> Int 
incrIfNZero 0 = 0
incrIfNZero n = n + 1

{-

Note that the order of the cases matters, much like with guards. The following
two examples illustrate that

>>> incrIfNZero 0
0

>>> incrIfNZero 1
2

Note that in some cases, the branching allowed by the pattern-matching means
you do not need to record some function arguments to know what is the output.
In that case, one may replace a variable by an underscore to indicate "there is
an argument, but I don't even care to give it a name". Here is an example of
the logical function corresponding to implication.
-}


impl :: Bool -> Bool -> Bool
impl False _ = True
impl _     b = b

{-
Now, pattern-matching is especially powerful with structured type constructors
like tupling and lists. Let us start with tupling. Besides constants, one can
go a step further with tupling: we can start describing the shape of the tuple
and give variable names to the components. Here is an example.
-}

sumTriple :: Num a => (a, a, a) -> a
sumTriple (x, y, z) = x + y + z

{-
Here we gave the names x y and z to the components of a single argument.
This is true for triples of arbitrary size. It is also possible to nest
patterns and actually analyze nested tuples easily.
-}

assoc :: ((a, b), c) -> (a, (b, c))
assoc ((x, y), z) = (x, (y, z))

{-

In patterns, one can only use each variables once; if you want to check equality
of parts of arguments like in the following example, you have to use conditionals
or guards:

-}

addDistincts :: (Eq a, Num a) => (a, a) -> a
addDistincts (x, y) | x == y    = x
                    | otherwise = x + y

{-

The reason we can do such pattern-matching is because, from the point of view
of the haskell runtime, every fully evaluated thing of a tuple type *must* have
shape (-, -) and (- , -) is a special basic construcor of the tuple types.

There is something similar going on with lists. In that case, there are two
primitive list constructors that can be pattern-matched against: the empty
list `[]` and the cons operator `(:)`

>>> :t []
[] :: [a]

>>> :t (:)
(:) :: a -> [a] -> [a]

Here is an example
-}

takeVariant2 :: [Int] -> [Int]
takeVariant2 [] = [21]
takeVariant2 (x : xs) = take x xs

{-

Note that the parentheses around the list patterns are necessary (otherwise the
compiler would try to parse x as an argument and would run into a syntax error
when seeing the infix operator `:` in the middle fo the left-hand side)

In fact the basic function head and tail are defined using pattern-matching in
the prelude (note that definitions with pattern-matching need not to cover all
arguments and still be legal).
-}

head :: [a] -> a
head (x : _) = x

tail :: [a] -> [a]
tail (_ : xs) = xs

{-
Much like with tuples, list patterns can be nested. Furthermore (and this is a
special syntax for lists), one may use a syntax with brackets to match against
list of fixed length.
-}

addListOfSizeFiveOnly :: Num a => [a] -> a
addListOfSizeFiveOnly [x,y,z,t,u] = x + y + z + t + u
addListOfSizeFiveOnly _           = 0

firstTwoEqual :: Eq a => [a] -> Bool
firstTwoEqual (x : y : _)  = x == y
firstTwoEqual _            = False

someFunction :: [([a], [a])] -> [([a],[a])]
someFunction (([x,y], z) : xs)   = ([x], y : z) : xs
someFunction (([], t : ys) : xs) = ([t], ys) : xs
someFunction _                   = []

{-
One can also do pattern-matching, as well as guards, in definitions in where
clauses and let-ins
-}

someOtherFunction :: (Num a, Ord a) => [a] -> a
someOtherFunction xs = let f (x : _) | x > 0 = x
                           f []      = 0 in
                        g (f xs)
                       where g 0 = 2
                             g x = 2 - x

{-
Finally, there is also a way to do a patter matching in the middle of a
function using a construct called case. You can look up the syntax online, but
be careful if you use it as it is sensitive to indentation, much like where
clauses, so it's easy to make mistakes that lead to mysterious syntax errors.
-}

someDefinition :: [Int] -> [Char]
someDefinition xs = "abc" ++ case takeVariant xs of
                               [] -> "cba"
                               x : xs -> show x 

someOtherDefinition :: [Int] -> Int
someOtherDefinition xs = case takeVariant2 (xs ++ [2 .. 5]) of
                           y : z : ys | y > z     -> y
                                      | otherwise -> z
                           []                     -> 2
