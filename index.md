%PROFESSIONAL webpage

Hi, I\'m Cécilia! I have been a lecturer at Swansea University since
fall 2021; this page is essentially a list of papers/drafts I have been
involved with, most of those should be freely available on
[arxiv](https://arxiv.org) or [HAL](https://hal.archives-ouvertes.fr/)
if you need them. I also have some of the [slides I\'ve been using in
talks](talks). If you are a student looking for teaching-related material I
might have mentioned, probably you want to scroll down at the end of the page.

I am generally interested in topics around logic,
realizability, automata theory and type theory. Before that, I was a
doctoral student at ENS Lyon and at the University of Warsaw, under the
supervision of Colin Riba and Henryk Michalewski, and went on to be a
postdoc for two years at the university of Oxford, working with Michael
Benedikt. My [thesis](thesis.pdf) focused on some of the constructive
aspects of Monadic Second Order logic.

# Publications

  *Implicit automata in λ-calculi III: affine planar string-to-string functions*,
     with Ian Price,
     MFPS 2024,
     [arxiv](https://arxiv.org/abs/2404.03985)
\
  *Synthesizing nested relational queries from implicit specifications: via model theory and via proof theory*,
     with Michael Benedikt and Christoph Wernhard,
     LMCS 2024,
     [arxiv](https://arxiv.org/abs/2212.03085)
\
  *On the Weihrauch degree of the additive Ramsey theorem*,
     with Arno Pauly and Giovanni Soldà,
     Computability 2024,
     [arxiv](https://arxiv.org/abs/2301.02833)
\
  *Synthesizing Nested Relational Queries from Implicit Specifications*,
     with Michael Benedikt and Christoph Wernhard,
     PODS 2023,
     [arxiv](https://arxiv.org/abs/2209.08299)
\
  *On the Weihrauch degree of the additive Ramsey theorem over the rationals*,
     with Giovanni Soldà,
     CiE 2022,
     [pdf](ramQwei.pdf)
\
  *Comparison-free polyregular functions*,
     with Lê Thành Dũng Nguyễn and Camille Noûs,
     ICALP 2021,
     [pdf](https://hal.science/hal-02986228v3/document)
\
  *Generating collection queries from proofs*,
     with Michael Benedikt,
     POPL 2021,
     [arxiv](https://arxiv.org/abs/2005.06503)
\
  *Implicit automata in typed λ-calculi I: aperiodicity in a non-commutative logic*,
     with Lê Thành Dũng Nguyễn,
     ICALP 2020,
     [pdf](https://hal.science/hal-02476219/document)
\
  *From normal functors to logarithmic space queries*,
     with Lê Thành Dũng Nguyễn,
     ICALP 2019,
     [pdf](https://hal.archives-ouvertes.fr/hal-02024152v3/document)
\
  *Kleene Algebra with Hypotheses*,
     with Amina Doumane, Denis Kuperberg and Damien Pous,
     FOSSACS 2019,
     [pdf](https://hal.archives-ouvertes.fr/hal-02021315/document)
\
  *A Dialectica-Like Interpretation of a Linear MSO on Infinite Words*,
     with Colin Riba,
     FOSSACS 2019,
     [pdf](https://hal.archives-ouvertes.fr/hal-01925701/document)
\
  *LMSO: A Curry-Howard Approach to Church's Synthesis via Linear Logic*,
     with Colin Riba,
     LICS 2018,
     [pdf](https://hal.archives-ouvertes.fr/hal-01698648v2/document)
\
  *A Curry-Howard Approach to Church\'s Synthesis*,
     with Colin Riba,
     FSCD 2017/LMCS 2019,
     [arxiv](https://arxiv.org/abs/1803.08958)
\
  *The Logical Strength of Büchi's Decidability Theorem*,
     with Leszek Aleksander Kołodziejczyk, Henryk Michalewski and Michał Skrzypczak,
     CSL 2016/LMCS 2019,
     [arxiv](https://arxiv.org/abs/1608.07514)
\
  *Integrating Linear and Dependent Types*,
     with Nick Benton and Neel Krishnaswami,
     POPL 2015,
     [pdf](dlnl-paper.pdf) [source code](dlnl-code.tar.gz)

# Preprints

  *Weihrauch problems as containers*,
     with Ian Price,
     [arxiv](https://arxiv.org/abs/2501.17250)
\
  *The equational theory of the Weihrauch lattice with (iterated) composition*,
     [arxiv](https://arxiv.org/abs/2408.14999)
\
  *The equational theory of the Weihrauch lattice with multiplication*,
     with Eike Neumann and Arno Pauly,
     [arxiv](https://arxiv.org/abs/2403.13975)
\
  *Two-way automata and transducers with planar behaviours are aperiodic*,
     with Lê Thành Dũng Nguyễn and Camille Noûs,
     [arxiv](https://arxiv.org/abs/2307.11057)
\
  *Refutations of pebble minimization via output languages*,
     with Sandra Kiefer and Lê Thành Dũng Nguyễn,
     [arxiv](https://arxiv.org/abs/2301.09234)
\
  *Implicit automata in typed λ-calculi II: streaming transducers vs categorical semantics*,
     with Lê Thành Dũng Nguyễn and Camille Noûs,
     [pdf](freeadditives.pdf)
\
  *Cantor-Bernstein implies Excluded Middle*,
     with Chad E. Brown,
     [arxiv](https://arxiv.org/abs/1904.09193) [formalization in Coq](cb-coq.tar.gz)

# PhD/MRes students

[Ian Price](https://www.countingishard.org) (PhD, current)
\
Olivia Weston (MRes defended in 2024)

# Slides from talks

Dumped [here](talks).

# Code

I don\'t do much of that these days, but I did spend some time with
computers and proof assistants in my life.

## A thing about countable total orders

I was motivated by a nice IRC discussion to write [a Haskell thingymagic
of questionable usefuleness that actually
runs](https://github.com/animal555/DFAsAndCountableOrders). It prints
out symbols like { ω + -ω, { η · ω, -ω }η }η generated by some DFAs and
that is enough to make me smile.

## Some things I formalized in Coq

-   Ramsey's theorem via H-well-foundedness
    [link](hclosure-coq.tar.gz)\
    A formalization of Stefano Berardi and Silvia Steila\'s paper [An
    intuitionistic version of Ramsey\'s Theorem and its use in Program
    Termination](http://www.sciencedirect.com/science/article/pii/S0168007215000731),
    exhibiting a theorem analogous to the infinite Ramsey theorem
    admitting a constructive proof. The paper introduces the notion of
    H-well-foundedness for relations, generalizing well-foundedness.
    Their main theorem state that this notion is stable under finite
    union, which leads them to a second constructive proof of Podelski
    and Rybalchenko\'s Termination Theorem.
-   An equational theory for Mealy machines [link](mealy-coq.tar.gz)\
    A little combinator language for letter-to-letter transducers
    together with a complete equational theory. This essentially come
    from the remark that all such transducers correspond to the class of
    functions between streams including lifting of maps between
    alphabets and closed by composition and parametric guarded
    fixpoints. This appeared in my PhD thesis and I thought it might be
    folklore. Dan Ghica, George Kaye and David Sprunger have a better
    version of the theorem over
    [there](https://arxiv.org/abs/2201.10456) where one does not require
    that uniqueness of fixpoints in a dedicated axiom.

# Teaching

## [some background info for my project students](projectsForStudents.html)

Below are some past or current teaching material. If you are currently
enrolled in a module in Swansea, all you need should already be hosted on
[canvas](https://canvas.swansea.ac.uk).

## [CS-205 2024/2025](cs205-2425)

## [CSCM12 2023/2024](cscm12-2324)

## [CS-205 2023/2024](cs205-2324)

## [CSCM12 2022/2023](cscm12-2223)

## [CSCM41J 2022](cscm41j-22)

## [TD FDI 2018/2019](fdi-1819)

# Contact

c.lastname@swansea.ac.uk or firstname.lastname@ens-lyon.org
