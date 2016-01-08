\

\

\

\

\

\

\

\

\

\

\

\

\

\

\

\

\

**The AppArmor**

**Extended Hybrid Finite Automata**

\
\

\
\

\

\

<div id="Table of Contents1" dir="ltr">

<div id="Table of Contents1_Head" dir="ltr">

**Table of Contents**

</div>

[Introduction 3](#__RefHeading__4396_1004215836)

[What is an eHFA? 3](#__RefHeading__4398_1004215836)

[Why an eHFA? 3](#__RefHeading__4400_1004215836)

[What is the eHFAs performance? 3](#__RefHeading__4402_1004215836)

[Constructing the DFA 5](#__RefHeading__4404_1004215836)

[Accept State Qualifiers 5](#__RefHeading__4406_1004215836)

[Rule Sets 5](#__RefHeading__4408_1004215836)

[Expression (expr) Trees 5](#__RefHeading__4410_1004215836)

[Compressing the HFA 7](#__RefHeading__4412_1004215836)

[Using the uncompressed HFA 9](#__RefHeading__4414_1004215836)

[Using the compressed HFA 10](#__RefHeading__4416_1004215836)

[Header 10](#__RefHeading__4418_1004215836)

[Matching 10](#__RefHeading__4420_1004215836)

[Overview of how various features affect dfa creation
12](#__RefHeading__4422_1004215836)

[References 17](#__RefHeading__4424_1004215836)

</div>

\

\

Introduction {.western style="page-break-before: always"}
============

\

This documentation covers the implementation of the eHFA used in
AppArmor, for a detailed discussion of the underlying algorithms and
theory please refer to

\

AppArmor uses a byte based extended hybrid finite automata (eHFA or just
HFA) for pattern matching. The eHFA is generic and independent from the
rest of AppArmor so it can be used by other projects.

\

This document describes the details of eHFA, and is split into five
sections. Section 1 covers the construction of the HFA, detailing the
various stages, algorithms, and options. Section 2 covers the
compression of the HFA, Section 3 covers using the uncompressed HFA,
section 4 covers the using the compressed HFA and the final section
provides a quick summary of how the various features of the HFA affect
its creation, size and matching time.

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

The eHFA is used because it is the best choice to provide advanced
pattern matching. A pure DFA provides fast linear matching, with a fixed
runtime memory bounds but can grow exponentially large. While an NFA
provides for a small pattern matching engine that may not provide a
linear match and may not have fixed runtime memory bounds.

\

The AppArmor HFA combines DFAs and NFAs in such a way as to use DFAs for
pattern matching with NFA nodes that act as choke points controlling the
expansion of the DFA size. The end result is a FA that has known bounds,
and performance like a DFA, and smaller sizes closer to that of an NFA.

\

The AppArmor HFA is biased towards a DFA and can and does produce pure
dfas for matching. It will never produce a pure NFA.

\

The extended part of the name means the HFA has been augmented with
scratch memory and extra notations that provide abilities that are
either handled poorly or can not be handled by pure NFAs and DFAs (such
as variables, back references, counting constraints, and recognition of
limited Dyck languages).

\

What is the eHFAs performance? {.western}
------------------------------

The exact performance characteristics of the eHFA are hard to quantify,
but in general it tends to be close to that of a DFA for any given
pattern. The amount of deviation will depend on how many simultaneous
NFA alternations need to be traversed for a match and how many of the
extended features are used.

\

It is even possible that the eHFA will be faster than the equivalent DFA
because it is smaller and thus interacts with a cpus cache better.

\

Constructing the DFA {.western style="page-break-before: always"}
====================

Accept State Qualifiers {.western}
-----------------------

The AppArmor HFA allows for multiple distinct accept states. The HFA
engines handles accept states in a generic way, so that the meaning is
determined by external routines. The HFA does this by requiring the set
up of accept qualifiers that are the referenced referenced by the
expression tree, hfa creation and compression routines.

\

Accept qualifiers ecode the meaning accept states, and have the
information to resolve conflicts.

\

Setting up qualifiers

Functions to handle conflicts

-   -   

\

The meaning and encoding of the accept states is no

Rule Sets {.western}
---------

Rule sets are a convenience wrapper that provides groupings of rules
that will be combined into a single HFA. If rule sets are not convenient
for a particular use the should be skipped and the expr tree and dfa
routines should be used directly.

\

The rule set stores the common accept permission information and
multiple expr trees that are to be combined together into a single dfa.
This allow a given set of rules to be processed into one expression tree
and then another set of rules into another expression tree.

\

Each expression tree with in the rule set is then converted to an
intermediate dfa, minimized and then combined using set operations to
create the a single large dfa which then in turn is minimized and has
unreachable states removed.

\

????? what more do we want to say about these??? Do we actually store
each expr tree and dfa or just the last one and the current set, and
combine them together when a new set is opened.

\

Hrmm rulesets should be pulled out of the lib

\

Expression (expr) Trees {.western}
-----------------------

The AppArmor eHFA uses a modified Aho?/???\*ref\* algorithm to directly
convert from a parsed expression tree to an HFA, there are no
intermediate steps of creating an NFA and then doing the subset
construction on it.

\

Parsing

The AppArmor eHFA library provides front end parsers for pcre style
regular expressions and the apparmor globbing syntax. Both front end
parser build up an expression tree from the regular expression string.

\

The returned expression tree can then be further manipulated and turned
into

\

\

\

parsing regular expressions into an expr tree

Permission Tables

-   -   

Rule sets

-   -   

expr tree optimization

-   -   -   

\

\

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

\

\
\
 {.western}
=

Compressing the HFA {.western style="page-break-before: always"}
===================

Relative State compression

-   -   

Packing compression (NOT implemented ever) – alternative to com
compression, that packs all transitions together in a tight list of some
form. In general it can get slightly better compression than comb
compression for a significant impact on match performance

-   -   -   

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

\
\
 {.western}
=

Using the uncompressed HFA {.western style="page-break-before: always"}
==========================

It is possible to use the uncompressed HFA to do matching, and this is
recommended for cases where the a generated HFA needs to be available as
soon as possible or if it is not going to be used for very many matches,
as the process of compressing the dfa can take longer than creating the
dfa.

\
\

\
\

???? how to use HFA in this case.

\
\

\
\
 {.western}
=

Using the compressed HFA {.western style="page-break-before: always"}
========================

This section covers the formats of the exported compressed hfa and its
use.

\
\

The compressed hfa for historical reasons is based around the flex dfa
container. The container has a fixed sized header with the tables of the
compressed hfa stored separate from each other linearly with in the
file. The headers an the tables have alignment constraints making it
possible to use the containers data directly.

\
\

This format is flexible allowing the hfa to be expanded with new tables
or to replace old tables as required. If a variable number of tables are
expected a verification or unpack routine should be used to ensure that
the required data is present.

\
\

\
\

Flags – conditional accept perm (table selector, or meaning of accept
perms is completely external to the hfa)? Export flags?

\

Header {.western}
------

-   -   -   

\

table sizes – 16 and 32 bit dfas, etc.

\

any state can be used as a start state

matches can stop and start at any point

0 is the non-accepting state

1 is the default start state.

\

Mapping of other states to start states?

\

\

Matching {.western}
--------

The AppArmor eHFA comes with a reference matching engine that has been
tailored towards AppArmor's matching needs. It requires an unpack phase
to verify and convert the compressed dfa into a memory resident version,
with tables entries logically grouped so that they can be cache aligned.

\
\

This increases an initial start time for use and reduces the flexibility
of the dfa as the set of tables needed is fixed. However it provides for
a dfa that never has a bad reference and is as fast as can be for
multiple matches.

\
\

If a generated dfa was

-   

\

\

\
\
 {.western}
=

Overview of how various features affect dfa creation {.western style="page-break-before: always"}
====================================================

This is a quick summary of the affects of various features on the eHFA,
the details for each can be found below.

\
\

Rule sets:

-   -   -   -   

\
\

Expr tree normalization

-   -   -   -   

\
\

Expr tree simplification

-   -   -   -   

\
\

DFA minimization

-   -   -   

\
\

DFA minimization – transition hashing

-   -   -   

\
\

DFA minimization – permissions hashing

-   -   -   

\
\

DFA merge – combine multiple dfas into a single dfa with shared start
state (set operations)

-   -   -   

\
\

DFA combining – combine two dfas together into one but keeps the start
states separate.

-   -   -   

\
\

Multiple start states

-   -   -   

Unreachable state removal

-   -   -   

\
\

DFA compression

equivalence class:

-   -   -   

default entry:

-   -   -   

Inverted default entry:

-   -   -   

state relative default entry (early dfa compression – not implemented
yet):

-   -   -   

Transitions bitmask (not implemented – maybe never)

-   -   

State relative next/check tables (not currently implemented)

-   -   -   

comb compression

-   -   -   

\
\

NFA states (not implemented yet)

-   -   -   -   

\
\

Variables and backreferences (not implemented yet)

-   -   -   -   

\
\

Counting constraints (not implemented yet)

-   -   -   

\
\

Alphabet reduction – uber equivalence classes (not implemented yet)

-   -   -   -   

\
\

Stride doubling (not implemented yet)

-   -   -   

\
\

\
\
 {.western}
=

References {.western style="page-break-before: always"}
==========

Dragon book

blah blah blah

\
\

