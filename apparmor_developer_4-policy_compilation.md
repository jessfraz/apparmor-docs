Hrmmm, split out apparmor specific stuff, except where used as an example. Another document {.western}
===========================================================================================

The AppArmor Extended Hybrid Finite Automata {.western}
============================================

\

AppArmor uses a byte based extended hybrid finite automata (eHFA or just
HFA) for pattern matching. ??? TODO ???

\

This document describes the details of eHFA, and is split into two
sections. Section 1 covers the construction of the HFA, detailing the
various stages, algorithms, and options. Section 2 covers the compressed
form of the HFA that is generally used for storage and run time pattern
matching.

\

What is an eHFA? {.western}
----------------

The term eHFA may not be standardized, with in this document is used to
refer to a finite automata that provides both DFA and NFA
characteristics with extensions providing features (variables, and
backreferences) that are not possible to support in a pure DFA, or NFA
based on regular languages.

\

Why an eHFA? {.western}
------------

AppArmor uses and eHFA because it is the best choice to provide advanced
pattern matching. A pure DFA provides fast linear matching, with tight
known memory bounds but can grow exponentially large. While an NFA
provides for a small pattern matching engine that may not provide a
linear match and may not have a bounded memory.

\

The AppArmor HFA combines DFAs and NFAs in such a way as to use DFAs for
pattern matching with NFA nodes that act as choke points controlling the
expansion of the DFA size. The end result is a FA that has known bounds,
and performance like a DFA, and smaller sizes closer to that of an NFA.

\

The AppArmor HFA is biased towards a DFA and can and does produce pure
dfas for matching. It will never produce a pure NFA.

\

The extended part of the HFA augments the ability for NFAs and DFAs by
providing a scratch memory that provides counting constraints,
variables, and back references.

\

Counting constraints can be provided by DFAs, and NFAs however they are
handled very inefficiently and are one of the causes of DFA size
explosion.

\

Variables and back references provide an extension of what regular
languages can express. Variables and back references share an
implementation, where variables are just a special case of back
references.

\

What is the eHFAs performace? {.western}
-----------------------------

The exact performance characteristics of the eHFA are hard to quantify,
but in general it tends to be close to that of a DFA for any given
pattern. The amount of deviation will depend on how many simultaneous
NFA alternations need to be traversed for a match and how many of the
extended features are used.

\

It is even possible that the eHFA will be faster than the equivalent DFA
because it is smaller and thus interacts with a cpus cache better.

\

Compiler options (move to a different document)

Overview of how various stages and features affect dfa creation {.western}
---------------------------------------------------------------

Duplicate include elimination: allows detecting which files have been
included already and stopping them from being reincluded.

-   -   -   

Duplicate rule elimination & permission merge:

-   -   -   -   

Rule sets:

-   -   -   -   

expr tree normalization

-   

expr tree simplification:

-   -   -   -   

dfa minimization

creation time: adds an extra O(n log n) phase to creation. If it removes
states it can speed up dfa creation by reducing the number of states
comb compression (O n\^2) has to evaluate.

hfa size: reduces the size of the dfa by removing redundant states.

match time: none

Transition hashing

-   -   -   

permission hashing

-   -   -   

DFA merge – combine multiple dfas into a single dfa with shared start
state (set operations)

-   -   -   

DFA combining – This form of combining merges two dfas together into one
but keeps the start states separate.

-   -   

Multiple start states

-   -   -   

unreachable state removal

-   -   -   

DFA compression

equivalence class:

-   -   -   

default entry:

-   -   -   

Inverted default entry:

-   -   -   

state relative default entry (early dfa compression):

-   -   -   

Transitions bitmask (not implemented)

-   -   

State relative next/check tables (not currently implemented)

-   -   -   

comb compression

-   -   -   

Packing compression (NOT implemented ever) – alternative to com
compression, that packs all transitions together in a tight list of some
form. In general it can get slightly better compression than comb
compression for a significant impact on match performance

-   -   -   

nfa states affect:

-   -   -   

variable and backreference matching

-   -   -   

counting constraints

-   -   -   

alphabet reduction – uber equivalence classes

-   -   -   -   

stride doubling

-   -   -   

\
\

\
\

Constructing the DFA

rule set

parsing regular expressions into an expr tree

Permission Tables

-   -   

Rule sets

-   -   

expr tree optimization

-   -   -   

dfa construction

-   -   -   

Calculating Rule Dominance (after minimization) – external permission
and dominance handling????

-   -   

minimizing the dfa

-   

set operations, combining dfas

-   

unreachable state removal

Compression

Relative State compression

-   -   

Comb compression

Finding holes efficiently

bit search

Searching the entire

Sub region searching (don't search entire set of dfa)

n partitions

divide and conquer

selection criteria

-   -   -   

Default field

-   

<!-- -->

-   

<!-- -->

-   

<!-- -->

-   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   

\

\

\

Compressed DFA {.western}
==============

Flags – conditional accept perm (table selector, or meaning of accept
perms is completely external to the hfa)? Export flags?

\

Header

-   -   -   

\

Runtime

-   -   
