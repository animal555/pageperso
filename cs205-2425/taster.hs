{-
# Our first foray into Haskell
-}

exampleFunction :: Int -> Int

{- 
   the line above is a _type declaration_
   essentially it says: "somehwere in the module, I will provide a function 
   named 'exampleFunction' which is going to have type "Int -> Int"
   The name of functions always starts with a lowercase letter

   in most scenarios, the type declaration is optional as Haskell is very
   good at guessing and assigning types! But it is good practice to have them,
   as it helps debugging; the compiler typically gives more informative error
   messages then.
-}

exampleFunction x = x + x
{- 
   this line is an equation defining the function
   all haskell functions are defined using more or less sophisticated variant
   of these!

   on the left-hand side, we give the name of the function, as well as a name
   to its argument(s) (here it is x, but it could be arbitrary). We don't put
   type information, it's already taken care of in the type declaration or 
   guessed by Haskell; just because this is the first argument and the type of
   the function is Int -> ..., x will be assumed to be an Int.
  
   the right-hand side is the value returned by the function, which can depend
   on its arguments.

   most of the functions in this file you could "translate to java" fairly
   easily generalizing the following example

```java
   public static void exampleFunction(int x)
   {
     return x + x;
   }
```

   The body will almost always be of the shape `return <rhs of decl>`, and the
   first line determined by *both* the type declaration *and* the argument names
   on the right-hand side.

   If you have HLS installed and a decent text editor setup (the easiest is
   probably to get vscode with the haskell plugin), you can
   evaluate values as in GHCI with the following syntax
-}

-- >>> exampleFunction 4
-- 8

{-
   Note that function application in Haskell does not require to put
   parentheses around function arguments.
   Although you can add parentheses if you like, but parenthesesing from the
   point of view of haskell is more akin to parenthesizing arithmetical
   expressions than anything else (the idea is that function application is a
   bit like a special ghost binary operator which has a given priority over
   the other operators and is implicitly left-associative)
-}

-- >>> (exampleFunction ((8)))

{- Now here is a similar function  with two arguments -}
exampleFunction2 :: Int -> Float -> Float
exampleFunction2 x y = fromIntegral x + y

{-
   Several things of note:

   * now that we have multiple arguments, we have to provide names on the LHS
     for each one. x is the Int, y is the Float, and that is determined from the
     type signature.

   * fromIntegral is a function that is able to turn an Int into a Float. Its
     actual type is a bit spooky, but we can check it is the case with the
     following kind of query, which would just raise an error if this was wrong
-}

-- >>> :t (fromIntegral :: Int -> Float)
-- (fromIntegral :: Int -> Float) :: Int -> Float

{-
  (example of such a query failing)
-}

-- >>> :t (fromIntegral :: Float -> Int)
-- No instance for (Integral Float)
--   arising from a use of `fromIntegral'
-- In the expression: fromIntegral :: Float -> Int
-- In the expression: fromIntegral :: Float -> Int

{-
   To apply a function to multiple arguments, one should have the
   arguments separated by a space.
-}

-- >>> exampleFunction2 5 6
-- 11.0

{-
   Do not comma-separate arguments.
-}

-- >>> exampleFunction2 5 , 6
-- parse error on input `,'

-- >>> exampleFunction2(5, 6)
-- Couldn't match expected type `Int'
--             with actual type `(a0_acbs[tau:1], b0_acbt[tau:1])'
-- In the first argument of `exampleFunction2', namely `(5, 6)'
-- In the expression: exampleFunction2 (5, 6)
-- In an equation for `it_acap': it_acap = exampleFunction2 (5, 6)

{-
   parenthesizing can and should be used if you want to pass complex arguments
   that use auxiliary operators/functions
-}

-- >>> exampleFunction2 ((8 + 9) * 5) (exampleFunction2 2 4)
-- 91.0

-- For types, for now it is enough to know the following:
-- * Int is the type of fixed-width integers (java int)
-- * Integer is the type of arbitrary-size integers
-- * Float is the type of floating type numbers (java float)
-- * [Int] is the type of the lists of Int
-- * more generally, if T is a type, [T] is the type of lists of Ts

-- To build elements of the list types, we have two basic constructors:
--
-- * the empty list [] that we have just seen
-- * `(:)` that adds an element to the front

-- >>> :t (:)
-- (:) :: a -> [a] -> [a]

-- >>> :t ((:) :: Int -> [Int] -> [Int])
-- ((:) :: Int -> [Int] -> [Int]) :: Int -> [Int] -> [Int]

-- >>> (:) 1 ((:) 6 [])
-- [1,6]

{-
   The parentheses around `:` means that we can write this function as an
   infix operator (by convention it is right-associative)
-}

-- >>> 1 : 6 : []
-- [1,6]

{-
   Lists are well typed, hence we cannot mix things of different types in lists.
-}

-- >>> :type [[False, True], 87]
-- No instance for (Num [Bool]) arising from the literal `87'
-- In the expression: 87
-- In the expression: [[False, True], 87]


-- Example of a list function
exampleFunction3 :: [Int] -> [Int]
exampleFunction3 xs = 0 : 9 : xs

-- >>> exampleFunction3 [7,8,9]
-- [0,9,7,8,9]

exampleFunction4 :: Int -> [Int] -> [Int]
exampleFunction4 n xs = reverse xs ++ [n , n] ++ xs

-- >>> exampleFunction4 2 [1,0]
-- [0,1,2,2,1,0]

exampleFunction5 :: [[Int]] -> [Int]
exampleFunction5 xss = head xss ++ head (tail xss)

-- >>> exampleFunction5 [[0..5],[4..0],[], [1],[11]]
-- [0,1,2,3,4,5]

{-
  head and tail may raise errors (much like when you attempt division by 0)
-}

-- >>> head []
-- Prelude.head: empty list

-- >>> tail []
-- Prelude.tail: empty list

{-
   Finally, if you want to do the challenge task in the lab, you may want to
   know about how to define intermediate values in computation. This can be
   achieved in with two constructs in Haskell: the let ... in and the where
   clauses. Here is an example computing the area of a circle with a given
   diameter with the two constructs
-}

areaCircle :: Float -> Float
areaCircle diameter = pi * radius^2
  where radius = diameter / 2

{-
   translated to (something that looks like) java, this would be

```java
   public static float areaCircle(float diameter)
   {
     final float radius = diameter / 2;
     return pi * radius^2;
   }
```

   radius is an intermediate value in the function, not in the scope of the
   file
-}

-- >>> radius
-- Variable not in scope: radius

-- >>> areaCircle 2
-- 3.1415927

{-
   /!\\ the where clause requires indentation; further, you can define multiple
   intermediate values with where clauses, but they must be indented at the
   same level, like so
-}

exampleFunction6 x = y + z
  where y = x - 1
        z = x + 1

{-
   OK now the example of the area with a let in to round out the file
-}

areaCircleLet :: Float -> Float
areaCircleLet diameter = let radius = diameter/2 in
                             pi * radius^2

-- >>> areaCircleLet 2
-- 3.1415927

{-
   We will talk about types in more details in the next lecture. But to parse
   error messages, it might be helpful to mention the following.
   The type system supports _polymorphism_. It means certain expressions can
   take a type that can be instantiated in several ways.
-}

-- >>> :t []
-- [] :: [a]

{-
   the type of [] contains a _type variable_ a. This means that [] could have
   any type obtained by substituting a for anything. I.e., we have for instance
-}

-- >>> :t ([] :: [Bool])
-- ([] :: [Bool]) :: [Bool]

-- >>> :t ([] :: [Int])
-- ([] :: [Int]) :: [Int]
