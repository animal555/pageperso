[Back to index](index.html)


A short introduction to haskell's type system
=============================================
```haskell

import Prelude hiding (id)
import Data.List (delete)

```

Introduction
------------

In haskell, every expression e has some type(s) T, which we often write like
this:

e :: T

Here, an expression can be a value or a function (once again, as a functional
programming language, haskell blurs the frontier between what is a function
or a value - functions are regarded as values of a particular type)

Here are some examples that we have already seen

```haskell
True :: Bool
5 :: Int
5 + 5 * 12 :: Int
[1, 2] :: [Int]
["a", "b", "aa"] :: [String]
[["a", "c"], ["aaaa"]] :: [[String]]
length :: [Int] -> Int
```

Much like other programming types can be regarded as sets of programs with some
expected behaviour, which can often be summarized as "does not lead to some
crash or very weird behaviour when put together with things of a compatible
type".

In haskell, all types are determined _statically_, which means at compile-time,
much like Java. It means that, unlike in Python which has dynamical typing:
* type representations do not pollute the runtime
* there can be no type errors while a compiled program runs

Some basic type constructors
----------------------------

* `Bool`: boolean values, contain True and False
* `[Bla]`: lists of values of type Bla. The fundamental constructors for this type
are the empty list `[]` and the (:) operator which allows to build a list by
defining the element x :: Bla in front (colloquially called the _head_) and the 
rest of the list xs :: [Bla] (colloquially called the tail)

```haskell

-- >>> True : False : []
-- [True,False]

```

/!\ the square brackets have a different meaning in code and in type annotations.
In type annotation, it means "I want to talk about a type of lists". In code
this means "I am defining/analyzing a list via...".
It is simply a peculiarity of haskell that some notations like square brackets
are used both in code and in types for similar things; some other programming
languages like OCaml make those two things more distinctive (by calling the
type of lists of Bla something like `List Bla` essentially).

In general the moral of this story is **types and code/values live in separate
worlds**. **Never mix types and values in this language**.

* `Char`: characters
```haskell

-- >>> :t 'c'
-- 'c' :: Char

```

* `Int`: fixed-width integers
* `Integer`: arbitrary sized integers ("bigints")
* `String`: string types; in haskell, String = [Char], although there is a
special notation for literals
```haskell
-- >>> 'h' : 'i' : []
-- "hi"

```
Here might be a good place to mention that one may define constants as well as
function in haskell file, using the same kind of notation. This can be useful
sometimes with strings if you have e.g. a piece of text/special characters you
are going to be using a lot.
```haskell

upRightCorner :: String
upRightCorner = "┏"

leftRight :: String
leftRight = "━" 

somePath :: String
somePath = upRightCorner ++ concat (replicate 3 leftRight)

hWMsg :: String
hWMsg = "Hello world!"

```
* `(Foo, Bar)`: pairs of elements of type Foo and Bar

```haskell

-- >>> :t (True, "aaa")
-- (True, "aaa") :: (Bool, String)

-- >>> :t ("aa", "aa")
-- ("aa", "aa") :: (String, String)

```
This can be generalized to tuples of arbitrary length
```haskell

-- >>> :t ()
-- () :: ()

-- >>> :t ("aa", "aa", True)
-- ("aa", "aa", True) :: (String, String, Bool)

```
Function types
--------------

Given types I and O, one can form the function type I -> O using the ->
notation, meant to evoque an arrow as in mathematical notation. We have seen
how to define function values using definitions in files and how to apply them,
so let us not rehash that here; we are going to see fancier ways of defining
functions later on when discussing higher-order functions such as these kind of
monsters:
```haskell

functionDefinedInAPointFreeManner =
  (> 56) . (\z -> z `div` 59 + 67 `mod` z)

```

We have also seen functions which have multiple arguments that can have types
I1 -> ... -> In -> O. Under the hood, there is something that we will notice
again later: this is actually a nesting of the basic binary operator ->, with
the rightmost parentheses. That means that implicitly, we have that

```haskell
Int -> Int -> Int
```

actually is syntactic sugar for

```haskell
Int -> (Int -> Int)
```

and the `->` operator is viewed as any other elementary type constructor like
tupling as far as the type system is concerned.

The type

```haskell
(Int, Int) -> Int
```

is also a type of functions with two arguments, but coded with tuples and is
**not** the same type, although it is morally the same. Going between the two
types is called curryfication and uncurryfication, the arrowful type being
the curryfied form. In functional style, we tend to like better function
written in a currified form, for reasons that we will explain later.

Since -> is a basic type constructor, types such as [(Bool -> Bool, Bool)] are
perfectly legal, and may even correspond to real things
```haskell

>>> :t [(not, True)]
[(not, True)] :: [(Bool -> Bool, Bool)]

```
We will have further occasions to appreciate this in the future, with some
actual consequences for programming in a functional style. But it is worth
mentioning that part of the style of functional programming come from the
fact that function types can be freely mixed with the other type constructors
in a principled way, and a lot of the conventions such as the one for functions
with multiple arguments being encoded with multiple arrows instead of tuple
types also stem from this.


Parametric polymorphism
-----------------------

What makes haskell type system powerful is that expressions may actually have
several types, including user-defined expressions.

```haskell
take :: Int -> [Int] -> [Int]
length :: [[Int]] -> Int
length :: [Bool] -> Int
5 :: Float
[] :: [Int]
[] :: [Bool]
```

This relies not on some ad-hock compiler definitions, a type hierarchy or some
kind of template programming, but rather on _parametric polymorphism_ based on
the _Hindley-Milner_ type system. The idea behind this is that we can have
function types that quantify over types using _type variables_.

Consider for instance the identity function (which returns its input).
```haskell

id x = x

```
The identity can operate on any kind of data, be it numbers, lists, etc.
```haskell

-- >>> id 5
-- 5

-- >>> id True
-- True

-- >>> id [["abc"], ["hh","jj"]]
-- [["abc"],["hh","jj"]]

```
We can check its type via the :t or :type directive in ghci/hugs:
```haskell

-- >>> :t id
-- id :: p -> p

```
In a type, a lowercase identifier is called a _type variable_. They are
supposed to denote any types. Here `p -> p` should be read as
"for every element with given type p, this is a function which returns something
of type p".

Here are other examples:
```haskell

-- >>> :t take
-- take :: Int -> [a] -> [a]

-- >>> :t fst
-- fst :: (a, b) -> a

-- >>> :t snd
-- snd :: (a, b) -> b

```
Below is an example of a custom polymorphic function definition, along with its
type signature.
```haskell

delta :: b -> (b, b)
delta x = (x, x)

```
The type should be read as "for every b, this function takes a b and returns
a pair of bs". We can check it works out of the box with all datatypes.
```haskell
-- >>> delta 3
-- (3,3)

-- >>> delta "Hello"
-- ("Hello","Hello")

```
In all scenarios, the exact same piece of code is ran.

Note that there is almost a *most general type* associated to a function, and
unless you are doing some rather unorthodox things with typeclasses, haskell
interpreters/compilers will be able to guess them. You can try it out for
yourself by typing definitions without the accompanying type signature and
see what haskell tells you.
```haskell

guessMyPolymorphicType x y = (x,x,y)

-- >>> :t guessMyPolymorphicType
-- guessMyPolymorphicType :: b -> c -> (b, b, c)

```

It is also possible to give a type annotation to a polymorphic function
which is not the most general possible. If you do so, the typechecker won't
complain as long as you are consistent with the most general type, and will
restrict your function to the types you specified.
```haskell

fstVectorInt :: (Int, Int) -> Int
fstVectorInt x = fst x


-- >>> fstVectorInt (2,2)
-- 2

-- >>> fstVectorInt (True, False)
-- Couldn't match expected type `Int' with actual type `Bool'
-- In the expression: False
-- In the first argument of `fstVectorInt', namely `(True, False)'
-- In the expression: fstVectorInt (True, False)
-- Couldn't match expected type `Int' with actual type `Bool'
-- In the expression: True
-- In the first argument of `fstVectorInt', namely `(True, False)'
-- In the expression: fstVectorInt (True, False)

```
Type classes
------------

Sometimes, it is useful to have a common syntax for operations that have a
similar meaning but operate on different datatypes.
For instance, one may want to be able to use the same symbol for addition of
integer numbers (be they fixed-width or bigints) and floating point numbers.

```haskell
>>> :t  (5 :: Int) + 6
(5 :: Int) + 6 :: Int

>>> :t (5.2 :: Double) + 2
(5.2 :: Double) + 2 :: Double
```

On the other hand, we cannot add lists of numbers together

```haskell
>>> ([8] + [])
No instance for (Num [Integer]) arising from a use of `it_a2BVU'
In the first argument of `evalPrint', namely `it_a2BVU'
In a stmt of an interactive GHCi command: evalPrint it_a2BVU
```

Another example is the (==) operator, that can be used on a variety of
datatypes, but certainly not all.

```haskell
>>> 1 == 2
False

>>> [[1,1]] == [[1],[1]]
False

>>> take == drop
No instance for (Eq
                   (Int -> [a0_a2C4S[tau:1]] -> [a0_a2C4S[tau:1]]))
  arising from a use of `=='
  (maybe you haven't applied a function to enough arguments?)
In the expression: take == drop
In an equation for `it_a2C3T': it_a2C3T = take == drop
```

These are instances of what is called _ad-hoc polymorphism_ and is similar in
flavour with the way operator overloading is done with languages like java or
python, but with a more flexible mechanism than messing with a rigid
object-oriented hierarchy. The way haskell does it is that it allows to define
so called **type classes** which are essentially a signature for a bunch of
operation parameterized by a bunch of type variables.

Let us walk through the example of the type class that provides the ability to
use equality. It is called Eq and is defined as follows in haskell (this is
commented not to shadow the official definition, and actually the actual
definition is a bit fancier, but we can pretend it is the definition for now):

```haskell
class Eq a where
  (==) :: a -> a -> Bool
```

These two lines say: a type `Bla` belongs to the typeclass `Eq` if *someone*
provides an operation `(==) :: Bla -> Bla -> Bool` and explicitly says this is
tied to the typeclass Eq. Note that this does not create any function or any
type; it simply declares that the typeclass exists and allows to then provide
implementation. The way to do so for, say, `a = Bool` is to write

```haskell
instance Eq Bool where
  (==) b c = b && c || not b && not c
```


This is called a **typeclass instance**. After this declaration, if the haskell
compiler sees a statement like `True == False`, it would use the above function
for the implementation of `(==)`. For this to make sense, haskell also ensures
each type can have at most one typeclass instance per typeclass.

Here is another example: the Show typeclass that is about types that can be
converted to strings (note in passing that the difference between operators
and functions is only one of notation; for haskell these are the same kind
of object, and one can convert between the two viewpoints using either
parentheses or backticks):

```haskell
class Show a where
  show :: a -> String

instance Show Bool where
  show b = if b then
              "True"
           else
              "False"
```

There are fancier ways of defining typeclasses and instances tha make the
system very powerful and used throughout all haskell libraries; you should not
have to explore how to define custom classes and instances for this module, but
since haskell provides a lot of default typeclasses and instances, you should
know how to use the provided instances and to type functions that use them.

Let us consider an example: the function delete from the Data.List module
shipped with your haskell installation. It takes two inputs, which may be for
instance an integer and a list of integers, and returns a list of integers
where the first occurence of the integer is deleted.

```haskell
>>> delete 3 [2,3,4,3]
[2,4,3]
```

Without going into details, it should be fairly clear that
* the implementation of this can be generalized to types other than integers,
such as Char. Which is nice for string operations for instance

```haskell
>>> delete 'e' "Hello"
"Hllo"
```

* however, one cannot do this for all datatypes; we need the ability to compare
the first argument for equality with the elements within the second argument.
Hence, the type of these arguments should have a typeclass for Eq. We can
check we may get into issues if they don't, like in the following example
(OK the example is a bit contrived; a lot of types in haskell have an instance
for `Eq` :))

```haskell
>>> head (delete take [drop]) 1 []
No instance for (Eq (Int -> [()] -> [()]))
  arising from a use of `it_a2CaO'
  (maybe you haven't applied a function to enough arguments?)
In the first argument of `evalPrint', namely `it_a2CaO'
In a stmt of an interactive GHCi command: evalPrint it_a2CaO
```

So to capture these two things, the fact that the input type could be anything,
but that the type of delete requires an instance of Eq, it is written this
way:

```haskell
>>> :t delete
delete :: Eq a => a -> [a] -> [a]
```


_Before_ the part of the polymorphic type `a -> [a] -> [a]` that says what
the function does, we add a **typeclass constraint** `Eq a =>` that says that
there should be an instance of Eq for a. So the informal way to read such a
type would be to say: this is a function such that
* for every a (quantify over the type variables)
* that have an instance for Eq (relativize wrt the typeclass constraints)
* this takes an argument of type a, an argument of type [a] and returns an
value of type [a]

In particular, => **is not the same thing as** ->!! Count only the -> arrows if
you want to figure out the number of arguments to a function.

Let us look at how it is done in a custom example which takes three arguments
```haskell

inOrder :: Ord a => a -> a -> a -> Bool
inOrder x y z = x < y && y < z

```
Here the Ord typeclass shows up to allow the use of the (<) operator.

In some scenarios, one may need several typeclass constraints; let us give
some example of the syntax needed in type annotations:
```haskell

exampleWithNumAndOrd :: (Ord a, Num a) => a -> Bool
exampleWithNumAndOrd x = x * x > x

exampleWithALotOfTypeclassConstraints :: (Show a, Ord a, Num a, Read a) => a -> (String, Bool)
exampleWithALotOfTypeclassConstraints x = (show x, read "3" * x > x)

```
Regarding the typeclasses that are provided with haskell, you should probably
get familiar with the following during the term:

* Num is the typeclass that provides basic numerical operations like (+), (-)
(*), as well as conversion functions from numerals. That is the reason why
numerals in ghci have type Num a => a: they are of any type a that can be
converted to a Num (much like the empty list is a list of any type [a])

* Eq is the typeclass that provide operators (==) and (/=) that stand for
equality and inequality

* Ord is the typeclass that provides comparison operators (>), (>=), ...

* Show provides a conversion function from the parameter type to strings. In
particular it is used in the interactive prompt to display values! That is
why you may have errors mentioning Show if you try to ask ghci about values
that have no obvious representations as strings (such as function types): it is
not that the value does not exist or is illegal, but simply that ghci does not
know how to print it because there is no instance of Show for the type.

* Read provides the converse functionality to Show, i.e. the ability to parse
a string representation into your favorite value.

* Enum provides facilities to enumerate all values of a type. This is what
work under the hood of the .. notation for lists.

Here is one of the main function, which gives the "next element" in a list

```haskell
>>> :t succ
succ :: Enum a => a -> a
```
```haskell

enumFromTo :: Enum a => a -> a -> [a]
enumFromTo x y = [x .. y]

```

Type annotations
----------------

In some rare cases, the typechecker will be unable to infer a type for a
haskell expression due to either very tricky code with typeclasses, or because
of some language extensions (not applicable to the module). In those case,
it is possible to help the typechecker by asking that a given subexpression
have a particular type using the :: notation within a definition.
Here is a (bogus) example:
```haskell

aConstant = (4 :: Int) + 6

```

```haskell
>>> :t aConstant
aConstant :: Int
```

Without the type annotation in the function, this would have turned into a
`Num a => a`.

Practice: in ghci/VSCode/Hoogle
--------------------------

The type system helps writting haskell programs in the sense that it filters
out programs that carry dreadful runtime errors in other languages while also
offering enough expressiveness to not crush users under bureaucracy (hopefully).

Now *understanding* the type system helps you:
* understand the errors the compilers/interpreters print out. All errors that
are not runtime or syntax errors are type errors, and typically the haskell
tool do there best to assume your programs can typecheck, and try to provide
an explanation when they can't figure out a valid type for all expressions.
Sometimes these explanations are a bit complex and will mention type variables
and typeclasses, because the tools try really hard! Do try to look first at the
line number and location of the error, and then the reasoning offered by the
tools to try to understand what might be wrong

* you can then ask what is the type of an expression expr by typing :t expr
in ghci, or hovering over it in VSCode if you have the haskell plugin and HLS
installed and and gain useful information from the type

* on [Hoogle](https://hoogle.haskell.org), you can search for haskell functions
and their documentations by providing either their name or their types. This is
very useful e.g. if you think the base install should provide some basic
function that you don't know the name but can guess the interface of!

```haskell
```
[Back to index](index.html)
