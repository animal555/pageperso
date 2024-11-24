Projects
========

This page is written for my project students, be they 3rd
year or master, whatever curiculum you are currently enrolled in (so the
content is rather generic).

This is being written in early 2024, is not authoritative at all and possibly
outdated - you should probably be checking the
[canvas](https://canvas.swansea.ac.uk) webpage for the relevant modules for
general information (CSCM10 and CSP354 iirc) as well as the
[CS project manager](https://csprojectmanager.swansea.ac.uk).

Expectations
============

Hopefully, you already have a broad ideas of the expectations from the project
module: you should do something that showcases what you have learned about
computer science, write documents/give presentations that explain what you
are planning on doing and how based on background research you have conducted,
carry out the project and then at the end write a dissertation about your
results.


"I was not allocated a project, what is going on?"
==================================================

**Do not panic!** Your priority should be to meet with your supervisor (that should
be allocated, if not you should be concerned) and discuss what to do, which
is going to be about picking a project topic most probably!

Every year some students are in this situation, even when they filled
pre-allocation requests. This simply means they could not be allocated to their
desired preferred supervisor to balance our supervision workload.

Choosing a project topic
========================

As long as you fit the basic criteria of "related to computer science", that
you are not planning to engage in some unethical activites and that your work
contains some implementation aspect[^1], you are free to pick whatever project
you like. It can be an idea you come up with or something inspired from the
projects you see on the list on csprojectmanager (whoever the author of that
particular project might be).

On that note, you do not necessarily need to pick a project idea that I have
written up! These projects come from ideas related to my research interests for
a large part, which I know are not to everyone's taste or require a specific
background for some of them.

I think some advice to bear in mind would be the following:
* your priority should be to pick a topic you would are invested in
  and ready to work on over the course of a few months. 
* you should have some ideas about the deliverables your project will have and
  make sure that this is achievable over the course of the few months you will
  be working on it. My assumption is that it is better to pick something where
  having something minimalistic to show off is going to be reasonably easy, but
  where there is going to be room for improvement
* you can absolutely pick a topic that you do not know all that well, but do
  not underestimate the amount of learning you might have to do.


It is fine to pick a project that is completely outside of my area of
expertise, but it means the supervision/feedback I might be able to give you
will not be expert feedback, especially when it comes to technical matters.
I would also be even more challenged when it comes to knowing what learning
resources related to your project or what related work exist.
On the other hand, I will still be able to help you when it comes to things
like academic writing, presenting, using LaTeX, as well as discuss high-level
ideas to sanity check them.

[^1]: I *believe* sometimes it is possible to do a project without an
implementation aspect, but this might affect the classification of your degree
if you are in year 3 and do this. I am not sure of what is the status of this,
so you should clarify that with someone who knows (e.g., the lecturer
delivering your module about projects).

My research interests
=====================

Something worth bearing in mind: computer science (much like all academic
disciplines) contain a lot of subdisciplines.

I work in theoretical science and logic - as such, I spend most of my research
time thinking about theorems rather than programming, although the mathematical
questions I am looking at are very much related to programming at times!

I think you have been somewhat exposed to related topics during your lectures.
For Swansea modules, think of CS-205, CS-275 and CSC385. I am also somewhat
familiar with formal verification topics like the one you'd explore in CSCM13.

If you want the more technical overview, you can look at the things I am working
on on my [website](https://cs-web.swan.ac.uk/~cpradic), but maybe it is more
helpful to say I would be more qualified to help in areas related to:
* formal verification
* logic
* linear logic
* interactive theorem proving
* functional programming
* compilers and semantics of programming language

On the other hand, I know next to nothing about web development (the sort of
web development skills which I find serviceable and I use day-to-day are on
full display here), machine learning, smartphones (I do not even own one) or
HCI.


My 2024 project list
====================

This year, I was on leave so, if I understand correctly, the projects
I had posted were not published for this round of allocation. I was asked to
relay them, so I am putting them here just in case.
This is copied and pasted (sorry for any formatting issues) and is missing
metadata, you should rather look this up on csprojectmanager if it is available
there! (also do not take the referencing style there as a reference for your
own referencing in your documents you will use for assessment!! :))

A computer-aided game/activity for the student conference
---------------------------------------------------------

### Description

Each year, we bring all of the third year student to a residential event outside of the university so that they may hone their presentation skills, tell the department about their exciting projects, but so to have fun and socialize. Typically, the event welcomes a hundred student and a dozen staff at a time, three times in a single week.

One of the challenge in organizing the event is setting up compelling activities that could bring the whole cohort together while not being too daunting/distracting (committing more than a couple of hours to the activity would probably be impossible for any of the participants).
The goal of this project would be to design such an activity. For instance, if you designed a programming competition, you would need to write the submission interface, some problems, some plan/interface to display results and documentation to set up the server. The activity itself is up to you, but you should set up your project such that there is some programming/CS problems for you to consider to fulfill the requirements.

You should try to design around the constraint of the event, so I would recommend talking to me or another organizer to have a bit of an idea of what would sound reasonable or not :) But besides the aforementioned constraints, I would stress that documentation and ease of deployment by others would be a key factor.

Some inspiration for that kind of activities besides past activities in the department:
https://play.battlesnake.com/
https://prologin.org/

### Preparation

I suspect knowing a bit about web dev would be necessary (unless you figure something else that would allow for interaction)
Otherwise I would recommend having a discussion with me so that a more concrete idea that sounds achievable would be.

Can autograder be cheated?
--------------------------

### Description

A number of modules in the CS department use csautograder.swansea.ac.uk that allows to automate part of the grading of programming homework.
This system is a deployment of Autograder.io (https://eecs-autograder.github.io/autograder.io/) which allows lecturers to set up homework in a bespoke way. The lecturers typically write the homework and some code for testing the coursework submission themselves, and then the system run the code provided by the lecturer with an access to an individual student submission in a sandboxed environment (also provided by the lecturer, although those can be relatively standard).

While the sandboxing and the framework make it safe to assume that malicious submissions would be unlikely to harm the overall system, whether the tests and the sandbox environment are 1) correct and 2) secure from being manipulated is left to the lecturers. Having 1) and 2) compromised could mean that the automated grading does not award correct marks.
The goal of this project would be to investigate what vulnerabilities could exist in those individual setups that would allow to engineer submissions that get full automated marks without actually solving the coursework questions, and propose some countermeasures less time-consuming than investigating the submission history of a particular user. I would be happy to provide some sample grading setups that I wrote in the past to be put to test, and for an attack on those be documented.

### Preparation

Probably things related to cybersecurity would be helpful - knowing that injection attacks exist sure is helpful since you would be designing some attacks.
I do not have experience personally, but am familiar enough with the tests to help point out some things to try.
It is possible you might need/want to deploy a local instance of autograder on your computer, so doing that in advance might be nice.

Another advice, which is specific to the projects I have written: it is fine
to take some inspiration from the prompt but scale down/modify the
objectives/tools being used! I know that some of those might too ambitious for
most students as stated here.

Certified compilation of synchronous languages
----------------------------------------------

### Description

Synchronous languages (such as Lustre or Esterel) are specialized dataflow languages that are meant to process efficiently discrete signal in real-time. They are typically used in critical systems such as avionics and compiled to C, but can also be compiled to hardware description languages such as Verilog.

Rather recently, some effort has been made to develop formally proven compilers for Lustre into C[^1]. By formally proven, it is meant that the compiler is coded in a proof assistant and that, if the compilation succeeds, the compiled code is trusted to be equivalent to the source code (to make that assertion precise, one needs to model mathematically the meaning of a program in both the source and the target and relate the two).

The goal of this project would be to write other compilers for (fragments of) Lustre or Esterel that are formally verified (and also define the relevant semantics when needed). One interesting compilation target that has not been investigated thus far to the best of my knowledge would be a fragment of Verilog or something close enough as in[^2] (or any other hardware description languages). Although less practical, another fun target to look at wold be finite-state transducers as they would be introduced in an introduction to computability module.

[^1] https://dl.acm.org/doi/10.1145/3371112?cid=81341488413
[^2] https://people.csail.mit.edu/bthom/pldi20.pdf

### Preparation

Getting familiar with a synchronous programming language would be necessary at some point for the project, but probably the most challenging aspect would be the getting familiar with interactive theorem proving on a computer and the field of programming language semantics. "Software foundations" by Benjamin Pierce and "Certified Programming with Dependent Types" by Adam Chlipala are two solid introduction to using the Coq proof assistant with a strong focus on topics related to the semantics of programming languages, so starting there might be a good idea.

Computing shortest paths efficiently in practice in sparse graphs
-----------------------------------------------------------------

### Description

You probably have learned of some algorithms to compute shortest distances in directed graphs such as Floyd-Warshall's algorithm that works recursively/iteratively.

The goal of this project would be to implement an algorithm recently introduced by Master[1] that instead adopts a divide-and-conquer approach that works better on some sparse classes of graphs. Some implementation in Python already exists, and the goal here would ideally to provide another implementation that might attempt to deliver some improvements (only one would be nice already!):
- the algorithm is interesting in part because it relies on precomputing some "composition symbols" that depend only on the boundary size of graphs involved in the divide-and-conquer algorithm. Determining if some meta-programming might help would be good.
- divide-and-conquer approaches often work well with parallelization; so trying to come up with a (possibly massively) parallel implementation and benchmark it would be nice; one could think of using MPI for massively parallel computations
- one could try to find especially nice benchmarks/or particularly nice classes of graphs on which the algorithm behaves well
- one could try to explore some similar instances of the algebraic path problem, like for instance, to algorithm that computes regexp for large automata

[1] contains a bit of category theory, but nothing very scary and I am happy to spend some time explaining it to you without any categorical language. If that project would interest you, feel free to come to me to talk about it/what I can support.

[^1] https://arxiv.org/abs/2205.15306 this contains a bit of category theory,
but nothing extremely advanced and I am happy to spend some time explaining it
to you with less categorical language - but you would need to engage with a bit
of maths. If that project would interest you, feel free to come to me to talk
about it/what I can support.

### Preparation

I would advise you get familiar with the language/tools needed to implement, as
well as the paper I cite above.

I could help troubleshoot some things with the
following: C/C++/OCaml (OCaml is a functional programming language that also
supports imperative programming and has nice facilities for parallelization and
metaprogramming (BER)).

Proving circuit designs correct
-------------------------------

### Description

The soundness of hardware design is of paramount importance as all computations ultimately run there. So naturally, hardware verification has been a huge topic for a long time. But "verification" may mean many things in the world of hardware, both in terms of techniques and of properties being guaranteed.

In the world of software verification, interactive theorem provers (ITPs) have been used to mathematically prove the correctness of programs with an extreme degree of certainty; this is even arguably easy for functional programs (correctness of simple functional programs such as merge sort are often used as tutorials for learning to use ITPs).

In contrast, hardware is not often checked with ITPs. So a worthwhile project would be to carry out such a verification task for a small circuit inside a proof assistant. Before starting the task proper, we would need 1) a hardware description language 2) a semantics for this language formalized in the ITP 3) a (small) circuit described in that language and 4) a non-trivial formal specification to prove. For 1) and 2) one could try to re-use code from pre-existing work such as the artifacts developed for https://people.csail.mit.edu/bthom/pldi20.pdf For 3) there is a lot of flexibility, but I would recommend starting small (e.g., an adder) and working up from there.

A sort of expected outcome is the task is much harder than it might seem at first, due to both "proof-engineering" and "formalization" reasons. One could hope that this project could serve as an inspiration to develop a modular way of describing circuits and reasoning about them (I have been told that one big defect of existing semantics for Verilog formalized in proof assistants is that they tend to be non-modular and essentially redefined for each formalization project; another worthwhile but potentially much more challenging goal would be to try to address this state of affair).

### Preparation

Getting familiar with a proof assistant such as Coq would be a must; for this project I would recommend "Software Foundations" by Benjamin Pierce or "Certified Programming with Dependent Types" by Adam Chlipala as good resources, as they would also introduce relevant material from the POV of formalization.
Some familiarity with hardware description languages and basic circuits would also be necessary.


Constructing algebraic numbers via ruler and compass or origami
---------------------------------------------------------------

### Description

The algebraic numbers consist of a subset of the real numbers that are roots of of polynomials with rational coefficient. For instance, 5, 0.5, √10 and √√2 are algebraic, while π and e aren't. This is a rather natural extension of the rationals which enjoy a number of nice properties, the following being the starting point for this project prompt:
- one can do exact computations over algebraic numbers, while we can't do that with real numbers
- every set of numbers in ℝ² that one can build (starting from the set {(0,0),(0,1)}) as intersections of lines/circles drawn using a ruler and a compass is algebraic
- similarly if we look at points created using origami folds (while it might seem daunting, this class of numbers was axiomatized, see e.g. https://www.langorigami.com/article/huzita-justin-axioms/) http://mars.wne.edu/~thull/origamimath.html

One goal of a project along these lines would be to build a tool that, given an algebraic number, answer whether or not it is constructible using either a sequence of ruler and compass moves or origami, and if yes, produce a sequence of steps to do so. The intent is that it would be a used as an educational resource, so you have quite a bit of freedom on what the final product would look like. For instance we might want to have an interactive visualization of the constructions.
One can also think of straightforward extensions, like allowing to set goals which are not algebraic and looking to produce approximation within a certain error bound or trying to optimise/compare the number of required steps.

I am also open to discuss options on those themes which are slightly different in scope; for instance, developing a suitable library for field extensions (over generic computable fields) in the language of your choice.

### Preparation

One should be prepared to know the basics regarding the theory of field extensions, but only the basics should be really necessary; knowing enough to realize that ruler and compass numbers lie in fields whose dimension is a power of 2 and origami in fields of dimension 2^n3^m + some basics on how to compute with exact representations of algebraic numbers should be enough for this project.

The second task would be to narrow down the technologies used an the goals you want to focus on.

Visualization of algebraic datatypes
====================================

### Description

Algebraic datatypes (ADTs) are one of the "killer feature" of a wide variety of functional programming languages like Haskell and OCaml. They are typically useful to encode enumeration and intricate tree-like datatypes, which are pervasives in a wide range of application (for instance, manipulating ASTs in compilers). For instance, a Haskell ADT definition for binary trees is

```haskell
data BTree a = Leaf a | Node BTree BTree
```

For beginners, linking formal definitions like these with graphical representation of trees can be challenging, especially since the formal definitions of values can become unwieldly pretty fast. Having a handy way to convert values of type, say, BTree Int, to a graphical representation with a simple call of a helper function in ghci would be massively helpful.

So the goal for this project would be to write a library that allows to easily display values from a large array of user-defined datatypes in Haskell. This should be done using typeclasses and generics, so that this would work with custom datatypes typically used for tree-like structure.
Concretely, this would mean providing a typeclass GShow with method gshow :: GShow a => a -> IO() and enough boilerplate so that compiling a file containing the three lines

```haskell
import NameOfLibrary
data BTree a = Leaf a | Node BTree BTree deriving GShow
main = gshow (Node (Leaf 2) (Leaf 3))
```

would produce an executable that open a graphical window with the corresponding tree with three nodes displayed.

There are many challenges and extensions related both to the more vizualization and programming language-related aspects, as well as some room for non-trivial design decisions.

### Preparation

Having a good understanding of the Haskell part of the declarative programming module would be ideal. To have general framework that is convenient for the user, the project would ideally require to go beyond this material and get to grips with implementing typeclasses and using generics, so reading up on them beforehand would be helpful.

On the rendering side of things, you are free to use whatever third-party library to help display the tree-like structure at first or you might like to deploy your own solutions. My reflex would be to use graphviz for a first prototype and maybe look into popular Haskell packages for displays such as e.g. Diagrams.

Some related works exist that you should investigate, in particular the following, which are about visualizing the precise structure of these things in memory:
https://dennis.felsing.org/ghc-vis, https://armael.github.io/jsoo-memgraph-toplevel/index.html and https://github.com/Gbury/ocaml-memgraph (the latter two are for OCaml rather than Haskell, but the idea is the same).

Of course it is also possible to attempt to carry out this project with other languages/tools in mind!

Mechanized theorem proving
--------------------------

### Description

Interactive theorem provers (sometimes called proof assistants) are software that allow to write general-purpose mathematical proofs and have them checked by a computer. They usually come with their own language to write down proofs and with a variety of foundations. Among the most notorious are Coq (https://coq.inria.fr/), agda (https://agda.readthedocs.io/en/v2.6.2.1/index.html) and lean (https://leanprover-community.github.io/), and they also have in common the fact that they are based on dependent type theories, systems that can be seen as both as foundational mathematical theories and functional programming languages equipped with a very rich typed system.

Writing proofs or programs in these systems does take some effort (both learning to use the systems and use them).
I can supervise a project that aims to formalize a piece of mathematics or the correctness of some algorithm in it and am very happy to discuss options (please see also my other projects prompts if interested; a lot of them can involve proof assistant as a way of verifying things).

### Preparation

Get familiar with the proof assistant that'd you'd want to use and the mathematics/algorithmics related to what you'd like to formalize.

