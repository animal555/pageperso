{-

-}

import Prelude hiding (map, filter, (.), ($))

{-
Higher-order functions
======================

_Higher-order function_ are simply functions that take other functions as
argument. Here is an  example of such a higher-order function, which takes
as input a function, an integer, and outputs an integer.

-}

divides :: Int -> Int -> Bool
divides x y = y `mod` x == 0

applyToSucc :: (Int -> a) -> Int -> a
applyToSucc f x = f (x + 1)

{-

```
>>> let g x = x * 2 in applyToSucc g 2
6

>>> applyToSucc ((+) 1) 2
4

>>> applyToSucc show 2
"3"

>>> applyToSucc (divides 2) 3
True
```

There are a lot of higher-order functions in the standard library,
and combining the ability of defining higher-order function with polymorphism
allow to write very powerful generic code. In this file, we will explore some
examples and also introduce useful syntax to define functions in a very succint
way.


Basics and examples
-------------------

A higher-order function is just one that take another function as input -
nothing more, nothing less. They can also be recursive or polymorphic like
any other function.

Here is for instance another example of a higher-order function that iters its
input function a number of times.
-}

iter :: Eq a => (a -> a) -> Int -> a -> a
iter f 0 x = x
iter f n x = iter f (n - 1) (f x)

{-

```
>>> iter ((+) 1) 2 3
5

>>> iter tail 3 [1 .. 10]
[4,5,6,7,8,9,10]
```

Here note that the function is
* higher-order, because the first argument has type a -> a
* polymorphic, because its type contains a type variable
* recursive, because it calls itself in its second line

In contrast, the first function applyToSucc is higher-order, but not
polymorphic and not recursive.

Here is another example, which is recursive, higher-order, but not polymorphic:
it tries to compute the least integer satisfying a predicate (here by "a
predicate over (a type) T" I only mean a function T -> Bool):
-}

leastIntSuchThat :: (Int -> Bool) -> Int
leastIntSuchThat p | p 0       = 0
                   | otherwise = 1 + leastIntSuchThat (applyToSucc p)

{-

```
>>> leastIntSuchThat ((<) 5)
6
```

Note that here to use higher-order function, I use the fact that haskell
encodes function of multiple arguments as functions that return other
functions and partial application.
Here for instance, (<) is a function that takes 2 arguments and returns a
boolean, which can be given the following type:

```haskell
Int -> Int -> Bool
```

which is implicitly the same as
```haskell
Int -> (Int -> Bool)
```

so `(<) 5` has type `Int -> Bool`.

This use of partial application with higher-order functions is actually the
reason why we prefer to encode functions with multiple arguments in this way
in Haskell rather than use tupling most of the time. (terminological remark:
a higher-order function is a function which has a function as *argument*, not
a function that returns another function; so (+) and (<) are not higher-order
because they output a function when partially applied).

Incidentally, some other standard example of higher-order functions is also
given by this operation that converts between these two representation
of functions in multiple arguments.
-}

curry :: ((a, b) -> c) -> (a -> b -> c)
curry f x y = f (x, y)

uncurry :: (a -> b -> c) -> ((a, b) -> c)
uncurry f (x, y) = f x y

{-

λ-expressions and sections
--------------------------

Once we have access to higher-order function, one issue you might run across is
how to use them in a non-awkward way. Up to now, only a couple of ways were
explicitly available to you: using already existing function, defined by
yourself or the standard library, or by partially applying such a definition.
You can also make those definitions locally using a `where` clause or a `let in`
expression, but that is not much more flexible. One issue that can come
up fairly quickly for instance is: I want to use a function of two arguments
partially applied, like `divides` above, but I want to partially apply the
second argument. Below is an example of how awkward this can be:

-}

awkwardWhere :: Int -> Int -> Int
awkwardWhere a b = leastIntSuchThat g - 1
   where f x = a `divides` x && b `divides` x
         g y = f (y + 1)
{-

>>> awkwardWhere 4 6
10

One useful construct to do this without having to do a where clause is
λ-expressions. Those are a way of defining functions without having to give
them names. The syntax

```\ arg1 arg2 ... -> (body of the function)```

denotes a functions, which names its arguments arg1, arg2, ... (those should be
lowercase variables as usual) and maps them to whatever is descibed in the body.
We can check that this works on a few examples:

```
>>> (\x -> x) 10
10

>>> (\x -> (x + 6, x + 5)) 2
(8,7)

>>> (\x y -> (x - y)^2) 2 3
1

>>>  leastIntSuchThat (\z -> divides 5 (z+1))
4

>>> (\xs z -> head (tail (tail xs)) + z) [1..10] 2
5
```

And now we can make our example into a one-liner (also please never re-implement
LCM in this way, it's just an example to show off syntax).
-}

exampleLambda :: Int -> Int -> Int
exampleLambda a b = leastIntSuchThat (\x -> a `divides` (x + 1) && b `divides` (x + 1)) - 1

{-
Lambdas can be very flexible and useful when small alteration are needed, but
be careful as they can get unreadable fairly quickly!
The reason why they are called lambdas is due to the connection of functional
programming with a mathematical formalism called the λ-calculus, which is
essentially an algebraic theory of mathematical functions which also happens
to be a fundamental object in theoretical computer science. The \ character is
essentially meant to be an ASCII representation of the λ notation historically
used. 


Another nice syntactic construct that is handy for using higher-order functions
quickly is given by _sections_ which is a handy way of partially applying
binary operator to arguments. The idea is that, if one has any infix operator,
such as +, *, or ``functionNameSurroundedByBackquotes``, the following
expressions are desugared in this way:

* `(⊗ x)` is the same as `\ z -> z ⊗ x`

* `(x ⊗)` is the same as `\ z -> x ⊗ z`

Here are some examples

```
>>> (+ 1) 2
3

>>> (< 3) 1
True

>>> (3 <) 1
False
```
-}

append :: a -> [a] -> [a]
append x = (++ [x])

{-

```
>>> (`divides` 2) 3
False
```

Useful examples
---------------

For better or worse, there are plenty of examples of useful higher-order
function in the standard library, and there is not enough time to cover all
of them in excruciating details in the lecture. So below are maybe some of
the more useful examples that you may come across.

* A couple fundamental examples are composition of function and application
that are already defined in the prelude; you probably won't use them too much
at first, but if you end up writing complicated programs, they tend to become
useful combinators. Application ($) sounds fairly useless at first, but it
is actually useful once you get comfortable with how haskell expressions are
parenthesized by default by the compiler because it allows to write complex
code with fewer parentheses.

-}

($) :: (a -> b) -> a -> b
f $ x = f x

(.) :: (b -> c) -> (a -> b) -> a -> c
(.) f g x = f (g x)

{-

* Over lists, and more generally over datatypes that can hold data of generic
types, there are quite a few very useful utility functions. A fundamental one
is the map function that allows you to relabel element of a list.

-}

map :: (a -> b) -> [a] -> [b]
map f [] = []
map f (x : xs) = f x : map f xs

{-

```
>>> map (+1) [1..5]
[2,3,4,5,6]

>>> map (\z -> [z, z] ++ [1]) [2..3]
[[2,2,1],[3,3,1]]
```

Another useful thing one can do with lists is filtering the elements
according to a predicate.
-}

filter :: (a -> Bool) -> [a] -> [a]
filter p [] = []
filter p (x : xs) | p x = x : filter p xs
                  | otherwise = filter p xs

a = 5

{-

```
>>> filter (3 `divides`) [1..10]
[3,6,9]

>>> filter ((2 `divides`) . length ) [[1..10], [1..3], [1..5], [2 .. 9]]
[[1,2,3,4,5,6,7,8,9,10],[2,3,4,5,6,7,8,9]]
```

There are a lot of other examples in the standard library, such as for instance

```
>>> :t zipWith
zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]

>>> :t (concatMap :: (a -> [b]) -> [a] -> [b])
(concatMap :: (a -> [b]) -> [a] -> [b]) :: (a -> [b]) -> [a] -> [b]

>>> :t (all :: (a -> Bool) -> [a] -> Bool)
(all :: (a -> Bool) -> [a] -> Bool) :: (a -> Bool) -> [a] -> Bool

>>> :t (any :: (a -> Bool) -> [a] -> Bool)
(any :: (a -> Bool) -> [a] -> Bool) :: (a -> Bool) -> [a] -> Bool
```

You should not try to learn all of those by heart! You can easily find them
in the documentation through [https://hoogle.haskell.org](hoogle) if you
search them by type. If you feel that there is a generic function over lists
that you would like to use, it is rather likely that it is already defined in
the base that comes with haskell, either directly in the prelude module
that is already loaded or in Data.List.


(optional) terminological details
---------------------------------

A function that is not higher-order is sometimes called _first-order_ in
contrast. In fact there is an inductive way to "count" the order of an Haskell
definition (you don't need to remember that) according to its type:

* a constant type like Bool has order 0

* a type `A -> B` has order either (1 + order of A) or (order of B), whichever
  is greater

So in particular, most functions we have seen so far such as (+), head or
tail have order 1, an the examples above have order 2. It is fairly rare to
see *explicit* examples of functions of higher order in every day programming,
although they might implicitly hide behind some of the more convenient
abstraction we are going to see later.

Just for fun, here is an example of a very very higher-order function, that is
actually used in actual real-world piece of code, essentially as an extremely
powerful exception handling mechanism; the first line "type C a r" actually
defines a type alias (otherwise the types get unreadable too quickly).
-}

type C a r = (a -> r) -> r

bindCont :: C a r -> (a -> C b r) -> C b r
bindCont x f k = x (\y -> f y k)

callCC :: ((C a r -> C b r) -> C a r) -> C a r
callCC c k = c (\g _ -> g k) k

{-
Unravelling the definitions, we can see that bindCont is an order-4 function,
while callCC is of order 5.

(If you are wondering what they are useful for, you can try to look up
"continuation-passing style transformations" (CPS) and/or ask me. CPS is
a relatively advanced topic relevant to advanced functional programming and
compilers, but essentially this is about program translation that allow to
encode primitives that do exception handling and much more in a nice way)
-}
