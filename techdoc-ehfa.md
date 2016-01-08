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
\

\
\

\
\

\
\

**Extending DFAs into Extended Hybrid Finite Automata**

\

\

\

<div id="Table of Contents1" dir="ltr">

<div id="Table of Contents1_Head" dir="ltr">

**Table of Contents**

</div>

[Tracking pattern group position 3](#__RefHeading__4530_1004215836)

[Extending DFAs with variable matching
5](#__RefHeading__4532_1004215836)

[Extending NFAs with variable matching
5](#__RefHeading__4534_1004215836)

[Extending DFAs to support variable matching
6](#__RefHeading__4536_1004215836)

[Implemention 24](#__RefHeading__4538_1004215836)

[Appendix A – Thompson's construction
24](#__RefHeading__4540_1004215836)

[Appendix B – The subset construction
24](#__RefHeading__4542_1004215836)

[Appendix C – Anchored and Unanchored regular expressions
25](#__RefHeading__4544_1004215836)

[References 26](#__RefHeading__4546_1004215836)

</div>

\

\

Introduction {.western style="page-break-before: always"}
============

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

So beyond variable match we need

counting constraints

variables

-   -   

back references

filtering (marks start location, etc much like backrefs and counting
constraints)

subdfas

anchored vs. unanchored matches and recording the start position
(similar to backrefs)

-   

longest left/shortest left matches

Extended FAs

Extending finite automata

use syntax similar to back references for variables \\@1

transitions that don't match are not shown and transition to the 0 trap
state.

\

\

Splitting \\@ into something like (\\.@+1( \\.@+2 (\\.@+3|)|)|)+ to
trade off state explosion/reduced working memory

\

Tracking pattern group position {.western}
===============================

\

To be able to track the start position for an expression we need to
augment the DFA with some memory. When the a transition is made from NFA
state 1 (the start state) to NFA state 2 (the first match state of the
expression) the input position is saved to memory. This simplistic
scheme is sufficient for many simple expressions like the expression in
Illustration 18 but fails for the expression in Illustration 1.

\

<span id="Frame18" dir="ltr"
style="float: left; width: 7.66in; height: 2.51in; border: none; padding: 0in; background: #ffffff">
</span>

![](data:image/png;base64,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)\
*Illustration 1: NFA (left) and DFA (right) for the unanchored
expression (ab)*

\

\

To understand why it fails and how to fix it, consider the expression
from Illustration 1 matching against the input 'aab'. Following through
the NFA the first 'a' causes a transition from state 1 to state 2, so we
save off position 1 as the start position, but the second character is
also an 'a', for which State 2 does not have a transition, so the match
needs to backtrack and take the alternate transition of state 1 to state
1 for the first 'a' discarding the saved start position value. We can
now match the remainder of the input 'ab' to get a match.

\

Now let us consider the same input of 'aab' against the DFA. The first
'a' causes a transition from state {1} to state {1,2}. This transition
contains the NFA state 1 to state 2 transition so the input position is
saved. State {1,2} then transitions to itself which causes also contains
the NFA state 1 to state 2 transition causing the saved input position
to be reset to position 2. The match then continues for the remainder of
the input.

\

This simple reset of the start position is not however enough to handle
the example in ???? for input aaab. This occurs because the first 2
characters of the input match the first two characters of the pattern,

and we don't know until the 3rd character whether the first character is
a match. In a DFA this means that multiple potential start positions
must be tracked simultaneously.

\

Pattern aab with input aaab

\

pattern a.\*b with input ????

\

hrmmm ababa

oh when groups start and how to track them

\

Foo

\

conversion to dfa

start spin state

tail spin state if consuming all input

-   

\

-   -   

Shortest left and longest left matches in a DFA (appendix ?)

\

-right anchored by definition is always a longest match (though not
necessarily longest left)

\

\

\

\

Extending DFAs to match variables

To extend DFAs with variables we need to understand what extension are
needed to dfa states and transitions as well as how these affect DFA
construction. To do this we will extend NFAs to do variable matching and
then extend the rules of the subset construction.

\

Nfas can have multiple transitions for a single character – try each
transition

Nfas can have lambda transitions

\

Need to cleanup to indicate the difference between anchored and
unanchored expressions.

-   -   

\

cleanup NFA transition vs. DFA transition.

\

NOTE: add info about notation

a (b, c) – shows set with states reached via lamda transition listed in
( ), this is not needed but is done as a guide to help show where parts
of the set are coming from. This is also the only part of the set that
will ever pick up the |= qualifier as it can only be inherited from λ|=

\

Extending DFAs with variable matching {.western}
=====================================

\

Deterministic Finite Atomata (DFA) are a finite atomata (FA) that at any
point have a single transition for any input symbol and do not have null
transitions

\

**Extending NFAs with variable matching**

We start by extending the NFA with a new state type that performs
variable matching (Illustration 2). It is modeled after Kleen closure on
a state that matches arbitrary input characters (appendix ???), except
the variable state transitions are conditional on the input characters
matching the values in the variable. The condition on the transition is
indicated by using a | symbol followed by the condition for the match,
eg. .\*|@ means match any character given it matches the current
position in the variable. We shorten the .\*| to the slightly shorter
\*| in the following discussion as it remains non-ambiguous, and less
cluttered in the more complex illustrations.

\

\

<span id="Frame1" dir="ltr"
style="float: left; width: 3.5in; height: 1.04in; border: none; padding: 0in; background: #ffffff">
</span>

![](data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAL4AAAA4CAYAAABDnUJYAAAACXBIWXMAAA6+AAAOpwFxQhjYAAAFIUlEQVR4nO2cPUwUQRTHPcAoDRTQYEIoDOQwSANEOjgOsbARGwMJqCRGCwwk8hEDRAleiAKJhisgJHxooqFBGgpEPOgkaCMGCYbCmGCjhTZCCJ48dc2xt8vOHrv75uP9mjuO2b2Z9//f25nZ2UmJRqNHCEI1UrArQBAYkPEJJSHjE0qCbvyGhobRnp6eruzs7M97ZHd1dfWMjo42JCUl/dojSSu3sbFxsqOjIzQ3N3d2e3v7WElJyfLdPcrKyhYx668iMmiGbnwIYEtLSz+8h9eBgYFb+jLr6+t5EKzm5uaHezSnp6d/n52dPVdfX/94ZGTkWlVV1Qvva64uMmiGbvxYfD6f4RRTW1vbg/b29vupqak//X7/Wk1NzbPh4eHrkUgk0Nra2ocdRJURVTN048Nlsr+/v2VycvJSX19fK1wax8bGrsaWgWCNj49fyc3N/Tg/Px/c3d1NhiCWlpa+Xltb82PVXVVk0Azd+NA3hFetb6gPIBCNRn1bW1vHtb+Tk5N34XVqauoiBNKruhJ/kUEzdOOzAH3FiYmJy93d3XcqKipe1dbWPs3IyPg2PT19AT7Hrh8RD++aCWH83t7e2xDIpqamRysrK6chgPn5+R8goFlZWV+w60fEw7tmQhi/oKDg/eLiYhkMlqBPmZmZ+TUcDjfC59h1I4zhXTMhjA9AwGZmZs5j14Ngh2fNuDV+7I0QQgxE0oxb4xOEm5DxCSXh2vhmdwVhjtjruhDWiKQXl8bXAmgWMKv/E94DmoikF3fGPyiAGtr/WcoS7mOlA496cWd8Ql7A9LyYnyvj2w0KT4FUFVHjz43xRQ2gyiSiGS/Jigvj8xAIwh6ia8aF8QnCa1CMbzTfm+iUFy+XTtkx0yyRuPOgGVcZn8xLeAWK8bVfPMZ3E4lhpJnIiYqbjC9yEAnx4Mb4hFiInqg8Nb7ZgMZqjQdLWcId7AxCaZGaCVYBiOtDRiKBg8po5+NhlkBWrBLVPj0M9Iork4BmaWlpP2ATK3h+1279zUDr6ugb/ue9SeD2HRdTJpEpUNbt74h49ANcrzSDh9WLi4vfNDY2hrVtSoDDaIbex/8fCIYA6tGOsTNDxLL9HWFOrPm90iwnJ+cT7MywsLBQHgwG5+1+pxHoxk8keEbn8AUCEbvH0ZSqfVizvBV2NNvc3DwBu6/BnjzCG9+pAGr8CSRDn5Fl+zu4hBodq3pXCEuzoaGhG5WVlS/B+IODgzeNytjVDG3JgpMBtAPL9neqG9wILM12dnaOwu7KsEdPdXX18+Xl5RLYblxfzq5m6F0dJ2HNIFZQxvcOK83gylxYWPguLy9vHYwPWd/I+NxnfLczhxPmJ4PvB1Mz6Np0dnbeg/dg/Lq6uiehUKhDX07pjE/Ix9LS0hntfVFR0dvV1dVTTpyXjE8oiSPGN7ozZ1bOiwFSIt0ds0sla9tEQ1bNWNvleMaXaemqHhV+BIAsbTuoXSlu38TBvEnk5ndj/ghIs8OfO8UJ0awqG7se57DfZQe324aVGUkzc1jb5drgVpbLpRGytk2ldjlufKut5DwZLJWXLzh9SllNAaiomSPG580UTq7N561tTsFbu5zSjPUcNI9PKAkZn1ASz43vdp8R1njzdhkXHRk1w9lX599DCFhLkwn7yKYZTlfHhRE8QNneRSTTDP9hc4cyCJnefWTSDHVw60Qgtec2yfTeIItm6LM6h3lqn7I8DjJohm58wGhdiOnmRDFP5vMQQFVh1Uy/kwIvmv0GLR9VjlVDOCgAAAAASUVORK5CYII=)\
*Illustration 2: The variable matching state. Left - a state that does
not match null variables. Right - a state that can match null
variables.*

\

\

Two versions of the matching state are provided in Illustration 2, the
left hand version can not match variables that are empty, while the
right hand version can. The meaning of \*|@ is slightly different in
each version, in the left hand version it will consume all input
matching the variable except the one matching the last character which
is matched by \*|=. Where in the right hand version \*|@ matches all
characters within the variable and then there is a lambda transition out
of the variable state when the variable is fully matched. The left hand
version can result in smaller DFAs, while the right hand version is more
flexible. For the purposes of the following discussion we will use the
λ|= variant. After the basics of the extended DFA construction are
established we will explore this and other constraints and trade offs
that can be made.

\

The use of the variable match state in an NFA requires that the match be
augmented with a positional value. ???? Need to know where in the
variable match we are, blah, blah, blah like in the DFA below

????. How much do we need to explain before transitioning to the DFA

**Extending DFAs to support variable matching**

\

Now that we have the basis for supporting variable matching in NFAs we
would like to extend the support to DFAs. To do this we extend the
subset construction so that it can convert an extended NFA that supports
variable matching into a DFA that supports variable matching.

\

The subset construction (Appendix B – The subset construction) creates a
DFA that is the equivalent of doing a breadth first NFA match, that is
it works on sets of NFA states. Variable matching extends both NFA
states and transitions with conditional information that will need to be
carried into a variable matching DFA. To develop the rules needed for
this we will work through a set of examples constructing NFAs matching a
pattern, stepping through the NFA and then building its associated DFA.

\

**Example 1:** A pattern matching a single variable (\\@)

We start by building a DFA that matches a single variable exactly
(Illustration 4), and compare it to the DFA constructed for the
expression .\* (Illustration 3) which we have modeled the variable
pattern match on.

<span id="Frame2" dir="ltr"
style="float: left; width: 3.5in; height: 1.04in; border: none; padding: 0in; background: #ffffff">
</span>

![](data:image/png;base64,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)\
*Illustration 3: NFA (left) and its associated DFA (right) for matching
.\**

\

\

The NFA for the .\* expression converts into a DFA with a single state
that consumes all input, and is always the final accept state.

\

<span id="Frame7" dir="ltr"
style="float: left; width: 3.5in; height: 1.04in; border: none; padding: 0in; background: #ffffff">
</span>

![](data:image/png;base64,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)*Illustration
4: NFA (left) and its associated DFA (right) for matching \\@ where the
variable string length &gt;= 0*\

\

\

The variable match pattern is similar except the transition for input is
conditional. When considering the next input symbol it is compared to
the value at the current variable position, if there is a match the
transition back to the variable state is taken and the match position
within the variable is incremented. If the input symbol does not match,
the DFA state does not have a matching transition defined so the DFA
transitions to the non-matching trap state, which is not shown.

\

If the input is longer than the variable match the matching engine can
either terminate the match in the accept state (non-anchored tail
match), or fail - transitioning to the trap state as there are no
matching transitions defined for the input (anchored tail match).

\

The accept condition for the variable match is different than that of
the .\* expression. In the .\* expression a match can be accepted for
any character, this is not the case for the variable match its accept is
conditional on the variable match completing (|= condition). This is
indicated by using a dotted line for the inner circle of the accept
state in the diagram.

\

We can build an augmented transition table for the subset construction.
Each State of the DFA is represent as a list of NFA states, with states
reached via the λ transition shown in parenthesis (). For each input we
have three possible values (columns): the input 'a' used by states that
aren't a variable match state, or by a variable match state when a
variable does not match; 'a|@' for when the input matches the variable,
and 'a|=' for when a transition is conditional upon a variable having
been matched.

\

The DFA states, listed in column 1, contain the set of NFA states that
compose them; with the NFA states that where reached conditionally on a
variable match marked with |=, and parenthesis () being used to group
sets of states that are reached together. A similar notation is used for
the transition columns.

  -------------------------------------------------
  DFA State   a   a|@      a|=   b   b|@      b|=
  ----------- --- -------- ----- --- -------- -----
  1 (2|=)     \   1(2|=)   \     \   1(2|=)   \
                                              
  -------------------------------------------------

*Table 1: Transition table for subset construction of \\@*

Thus for Illustration 4 we have one state 1 (2|=), composed of NFA
states 1 and 2, with 2 being reached by a conditional λ transition.
There are no transitions for input 'a' as neither NFA state 1 nor 2 have
a plain (unconditional) transition. There is a transition back to DFA
state 1 (2|=) on input 'a' given it matches the variable at its current
position (a|@) from NFA state 1. And there is no transition on 'a|='
because no NFA state has a transition that is conditional on the state
being reached after a variable was matched (we will see this in later
examples, note this does not include the initial transition (|=) when
the variable is matched). The transitions for input 'b' mirror those for
input 'a'.

\

**Example 2:** A pattern matching a variable followed by a letter (\\@a)

We now examine what happens when the pattern to match is extended by a
single trailing character.

\

<span id="Frame4" dir="ltr"
style="float: left; width: 5.54in; height: 1.58in; border: none; padding: 0in; background: #ffffff">
</span>

![](data:image/png;base64,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)\
*Illustration 5: NFA (left) and its associated DFA (right) for matching
.\*a*

\

\

The DFA for the .\*a (Illustration 5) reduces to two states, the {1,2}
state which consumes most characters and the {1,2,3} state which
consumes the letter a.

\

<span id="Frame8" dir="ltr"
style="float: left; width: 5.51in; height: 1.07in; border: none; padding: 0in; background: #ffffff">
</span>

![](data:image/png;base64,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)\
*Illustration 6: NFA (left) and DFA (right) for matching \\@a*

\

\

The variable match DFA (Illustration 6) is again similar to the DFA
created by the .\*a expression. The λ transition pushes its condition
(|=) on to the states and subsequent transitions reached by the
conditional transition. To be more precise, if state is by reached
λ-closure that traverses a λ|= condition then the transition also must
inherit that condition.

\

Stepping through the subset construction we can see where some of the
differences occur. Table 2 shows the transitions generated by the subset
construction.

\

  --------------- ------- --------- --------- ------- --------- ---------
  **DFA State**   **a**   **a|@**   **a|=**   **b**   **b|@**   **b|=**

  1 (2|=)         \       1 (2|=)   3         \       1 (2|=)   \
                                                                

  3               \       \         \         \       \         \
                                                                
  --------------- ------- --------- --------- ------- --------- ---------

Table 2: Transitions for the subset construction on \\@a

\

The subset construction as shown in Table 2 has been modified to handle
the NFA |@ and |= transition conditions. States reached via a condition
are marked with the condition, which will then be used later to
determine if the condition is applied to a transition. The |@ transition
is implicit (not shown) in the transition table NFA state set as it can
always be determined because of the variable state transitioning to
itself.

\

Walking through the subset construction, we start in NFA state 1, and
then do λ-closure(1) to get to the DFA start state of {1,2|=}. The 2 in
the set picks up the |= condition because it is reached by the λ|=
transition in the nfa.

\

Building the subsets for the transitions from the DFA start state
{1,2|=}, from NFA state 1 there are no unconditional transitions inputs
symbols for 'a' and 'b'. The a|@ and b|@ transitions loop back into NFA
state 1, and there are no other potential transitions, λ-closure({1}) is
then applied resulting in {1,2|=}. For the 2|= entry, in start state
set, the only defined transition is a to NFA state 3, however since 2 is
marked with |=, the transition is a|= instead of 'a'. λ-closure({3}) is
then performed, but there are no λ transitions from 3 so the final state
is {3}. Note the |= mark that was on 2 does not carry to state 3 as it
is not reached via a conditional λ-transition. For DFA state {3} there
are no possible transitions, so there are no entries in the table.

\

The mutually exclusive handling of the |@ and |= transition results in a
dfa that doesn't loop on it self like the dfa for '.\*a' does. This
makes sense as the '.\*a' expression can't know in advance when the
'.\*' portion of the expression matches so any 'a' is treated as a
potential final 'a'. With the variable match it is known when the
variable is matched so only if that match is followed by an 'a' will the
match succeed.

\

**Example 3:** A pattern matching a variable followed by any text
(\\@.\*)

We now extend example 2 to examine what happens when a variable match is
followed by an arbitrary match.

\

<span id="Frame6" dir="ltr"
style="float: left; width: 4.54in; height: 1.04in; border: none; padding: 0in; background: #ffffff">
</span>

![](data:image/png;base64,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)\
*Illustration 7: NFA (left) and DFA (right) for matching .\*.\**

\

\

Two consecutive arbitrary matches (.\*.\*) merge into a single match
pattern as shown in Illustration 7. The variable match shown in
Illustration 8 is much closer to the results from Illustration 5. This
is because the variable match keeps the states from collapsing together
because of the behavior of the conditional transitions.

\

<span id="Frame5" dir="ltr"
style="float: left; width: 5.51in; height: 1.04in; border: none; padding: 0in; background: #ffffff">
</span>

![](data:image/png;base64,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)\
*Illustration 8: NFA (left) and DFA convertion (right) for matching
\\@.\**

\

\

We start with NFA state 1 and then do λ-closure(1) to get to the DFA
start state of {1,2|=,3|=}. We again see the formation of a conditional
accept state, this is because NFA state 3 is reached through a
conditional λ-closure as shown in Table 3. The state 3 is also marked
with |= because it is reached via state 2 during λ-closure which can
only be reach via a conditional lambda transition (λ|=).

\

Once the DFA start state is formed we follow the transitions for it
constituent NFA states. NFA state 1 has conditional transitions to 1 on
a|@ and 2 on a|=, which then have a λ-closure(2|=) to 3|=. 2|= has a
transition to 2, but since 2|= was reached via a |= transition we the
a|= and b|= columns instead of the a and b columns for its transitions.
Note how in the table the transition for a|= and b|= do not mark the set
of states it is transitioning to as conditional. That is because taking
the transition guarantees that condition (|=) has been met so the
conditional no longer needs to be carried. The a|= column could be
tracked in the 'a' column but is not because it makes following where a
given transition originates from easier. The |= mark is used by the
subset construction to find the transitions that inherit the |=
condition during λ removal, and also to determine when an accept state
has been entered conditionally.

\

The transitions for the start state {1 (2|=,3|=)} reach a new DFA state
{2,3}, so we enter that state in the table and follow its transitions.
Neither state 2 or 3 have a conditional match, nor were they reached
conditionally so only the unconditional columns 'a' and 'b' are used for
the input match. 2 transitions to itself and then λ-closure is used to
reach state 3. Since state 3 is reach via an unconditional λ transition
the DFA state {2, 3} is an unconditional accept state.

\

The DFA generated loops to state {1 (2|=,3|=) } while the input matches
the variable. If the last input character matches the last value of the
variable, then state {1 (2|=,3|=)} accepts the match. If there are any
more input characters beyond the variable match a transition to state
{2,3} is made and the rest of the input is unconditionally matched.

\

  --------------- ------- ------------- --------- ------- ------------- ---------
  **DFA State**   **a**   **a|@**       **a|=**   **b**   **b|@**       **b|=**

  1 (2|=,3|=)     \       1 (2|=,3|=)   2,3       \       1 (2|=,3|=)   2,3
                                                                        

  2,3             2,3     \             \         2,3     \             \
                                                                        
  --------------- ------- ------------- --------- ------- ------------- ---------

Table 3: Subset construction for \\@.\*

\

The next two examples will revisit examples 2 and 3 to explore what
should be done when the variable match is optional.

\

**Example 4:** an optional variable followed by a letter (\\@?a)

In this case we must match an 'a' optionally proceeded by by a variable
match. This means that the generated DFA will have to be able to deal
with the first character if it is an 'a' potentially being the final
character or the first character of the variable.

\

<span id="Frame3" dir="ltr"
style="float: left; width: 6.75in; height: 1.54in; border: none; padding: 0in; background: #ffffff">
</span>

![](data:image/png;base64,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)\
*Illustration 9: NFA (left) and DFA (right) for matching (.\*)?a*

\

\

Comparing Illustration 9 and Illustration 10 we once again see that
while the NFAs for the variable match and the pattern match it is
modeled on are almost identical the resultant DFAs are different. This
will continue to be the case, as the conditional transitions, not only
provide more potential transitions to encode for but also more
combinations of state sets to transition to. As such this is the last
plain pattern match NFA and DFA to be presented for comparison to the
variable match NFA and DFA.

\

<span id="Frame10" dir="ltr"
style="float: left; width: 6.74in; height: 2.51in; border: none; padding: 0in; background: #ffffff">
</span>

![](data:image/png;base64,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)\
*Illustration 10: NFA (left) and DFA (right) for matching \\@?a*

\

\

FIX ME: 1,2,3 – b → 2,3 is wrong in dfa it should be b|@, might as we
make 1,2,3 – a → 4 a,a|= just to show its both of those like the a,a|@.
Update discussion below for change

\

There are two important point to focus on in Illustration 10, and its
transitions in Table 4. The first is the start state {1,2,3} does not
have a conditional |= marker despite state 3 being reached via a
conditional |= transition from state 2. This is because both 3 and 3|=
transitions are always to the same set of states, as |= after lamba
removal just marks a state thats transition should be conditional on the
|= match. The second point is the transition from {1,2,3} to
{2,(3|=),4}. It is labeled with both 'a' and a|@ transitions, and there
is a separate transition for just 'a' that goes to {4}. Looking at Table
4 we can see the transitions for {1,2,3}. The transition for 'a' is
listed as {4}, while the transition for a|@ is listed as {2 (3|=)}, and
yet in the DFA we have 'a' transitioning to {4} and 'a' and a|@ going to
{2,(3|=),4}.

\

This happens because the conditional forces the split. For the input
character 'a' there are two choices, if the a|@ condition is false it
can transition directly to {4}. However if a|@ is true the NFA
transitions to both {4} and {2 (3|=)}. This is no different than an
ordinary NFA having two transitions listed for an input character, where
the destination state sets are combined by the subset construction to
find the final state. The difference being that the |@ condition is true
only sometimes giving us two different states to transition to.

\

  ---------------------------------------------------
  DFA State   a   a|@       a|=   b   b|@       b|=
  ----------- --- --------- ----- --- --------- -----
  1 (2,3)     4   2 (3|=)   \     \   2 (3|=)   \
                                                

  2 (3|=) 4   \   2 (3|=)   4     \   2 (3|=)   \
                                                

  2 (3|=)     \   2 (3|=)   4     \   2 (3=)    \
                                                

  4           \   \         \     \   \         \
                                                
  ---------------------------------------------------

*Table 4: Subset construction for \\@?a*

While the syntax of a,a|@ was used in this example DFA to emphasize that
this transition is using the targets for both 'a' and a|@, it is
incorrect and confusing (a DFA can only have a single transition for an
input character, and the state label encodes which NFA states have been
combined). The meaning of |@ in the NFA and table is different than that
in the DFA, in the DFA |@ transitions to everything from a|@ and 'a' in
the NFA. All other DFAs in this paper will use only a|@ or 'a' to label
transitions, dependent on whether the transition is conditional.

\

**Example 5:** an optional variable followed by any text (\\@?.\*)

We now revisit example 3, this time with the variable match being
conditional.

\

<span id="Frame9" dir="ltr"
style="float: left; width: 6.48in; height: 2.54in; border: none; padding: 0in; background: #ffffff">
</span>

![](data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAWYAAACKCAYAAACZ1+BbAAAACXBIWXMAAA7GAAAOtwHc8YUlAAAVXklEQVR4nO3dD1QV150HcAUB2SQYgmmLWdacRgh21Wyinpq4EQFrTv4dULqN0KNVsq4xoGAEtEFWXIIGhWAKWg0H0LigdI2BVptDFRCb7sY1xkSqJQR7TM2aPaex2ZLNUfIqLj/jPXsdZ9678978ufPm+zmHM4/3ZubdO/Pmy+XOvDujrl27NgIAAOQxyu4CAADAzRDMAACSQTADAEgGwQwArpKdnd1QVlZWEhcXd2FYXElJSVlDQ0N2SEjI0LAQNt+5c+fuKy4uLj98+PD3BgcHI6ZPn36idFhSUlK32WVEMAOAq1AoFxQUVNJjmlZVVa1WztPX15dAAZyfn791WP6YMWP+3N7e/tiiRYter6urWzp37txfmVlGBDMAuNbIkSNVL0srKiravGbNmorIyMjLiYmJvZmZmXt37ty5rKurK7mwsHALghkAwEDUdVFZWVnQ0tLyzJYtWwqpu6KxsXEJPw8F8K5duxbHx8d/1NHRkXr16tVQCuYZM2a809vbm2h2GRHMAOAq1J9MU9afrAxlcu3atZFXrlwZzX4PDQ29StMDBw7Mp3A2u4wIZgAABepf3r179482bNiwPiUlpTMrK6s5JibmUmtrazo9b/b7I5gBABQ2bdr0YwrnvLy8V3t6eiZTKE+cOPF3FNKxsbGfmv3+CGYAAIVJkyb9tru7O4lOAFI/9NixYz+rra3NpeeteH8EMwCACgrhQ4cOPWnHeyOYAQBG/P/JQBkgmAEAJINgBgCQDIIZAGCE9rcA6Zpmq8uCYAYA16NQ1gpgFthWBjSCGQBczVsoE/aar/mMhGAGABBAoWxVOCOYAcC1rGwF64FgBgBX8ieUrWo1I5gBwHVkbSkzCGYAAMkgmAEg6Kldo+xvq9mK7gwEMwCAZBDMABD0WCtX+Zxd5fEFwQwAIBkEMwC4jsytZYJgBoCgpeckHQYxAgCwgFqo8s/xYXyqq3qV2jr4ediyZl+ZgWA2WXZ2dkNZWVlJXFzchWFxJSUlZXT79JCQkCH+jgnnzp27r7i4uPzw4cPfGxwcjJg+ffqJ0mF0Q0g7y69Gq052lwvAG+UJQHqsFcY8fh6rRppDMJuMAqygoKCSHtO0qqpqtXKevr6+BArg/Pz8rcPyx4wZ8+f29vbHFi1a9HpdXd3SuXPn/sr6kmsTqROAjPhwFgllJbaMVreHURDMFtLamUVFRZvpbryRkZGXExMTezMzM/fu3LlzWVdXV3JhYeEW2YKZZ/YHFMBIoq1kX2gdDyavqjaiTGoQzCajf/MrKysLWlpanqHboFN3RWNj4xJ+HgrgXbt2LY6Pj/+oo6Mj9erVq6EUzDNmzHint7c30a6yaxGpE4BsWCivGg7Uai/hvOpG4Hqbh9C6zOpnRjCbjPW9sv5ktQCjHXvlypXR7PfQ0NCrND1w4MB8CmeryipKpE4AMuFbylqBqwxk0YA2A4JZAtS/vHv37h9t2LBhfUpKSmdWVlZzTEzMpdbW1nR63u7yAQQzrQAWCWizWs0IZgls2rTpxxTOeXl5r/b09EymUJ44ceLvKKRjY2M/tbt8AE7mrV/ZV7cG4QPaqnBGMEtg0qRJv+3u7k6iE4DUZzt27NjPamtrc+l5u8sGEKxEQtkuCGZJUAgfOnToSbvLARDM3jj4Hw9vq//lE6MjwjwxGvP8W9tvZm5vfOvxv4qMGHxheVpb6qwpp+n5asWJw6b93UlV29vS3ut85QWjy4lgtgn/5RIAMIeyG+Pc+f/+VtueFzfmPP3ixk/uvP1/1ZY5f+GPd/+iad1LH/b/1z2FpbsWs2Dm/c/Al7e91fHeQ2aVG8EMAK5RlDvvTZreMfwzMf6vP1GbpzA3vZWmoaEhQ3dF3/EF/xprNd+dNvM3z6T//dvrK/Zm0vNG9zMjmG2g9qUM2Ue7AggWFKx/M+/RXy9b/Fi71jwPpbzwSkR4mGdr+bP1yte+HP75+FT/hDUr5x9gwWw0BLPFtP6qyn5zSBEyjc4FoKV/+OcHj/ztmTujbvtSax7qNz75wbn7KHgPNq97iX8tdNr9H0a8++H9oSEhQ2aVEcFsIW/ha9Vt0c3irexWDfwC4Aud+Fu6JnPvzwp3PPewxhUZu/Z1pmRlzDr2lecvowYHPWHK14+f7EugKbWq2dToE4AIZouIhK5Tw9lXmdlrTqwbWMOqURjrm47MYY8pUN9p31wUHjbqL8pwTUkvKYuJvuOLdat/8DM2L3s9afgzzK7MMCOUCYJZMk4NZxHBXDcIjFmjMLLPHLsygw9R6mumUFYus3hBSif9iJSbrY8GNMIXTBxGbxg5KcCcUk5wDjtGYfTV6mWvW/WlFASzyYI5uPypm5P+6IB17BiFUfmFEZkgmE0UzAEUzHUD65k5CqOyO0NJJJy9DWRkdDcGQTBLCi1LgJsFMgojG9heGc7eRpBbxQ2Eb3WrGsFsILW+sWAJVyPrhj864I9ARmH8u9n5W4ejVvOOI8qA5p9Tw1rZZrSWCYIZ/IZgBStpjcI4efLkHtF1qLWaeaItYzNDmSCYDaS8Cy97zq7yAASbQEZh5K+nD+S+f+xef2Ye2whm8Av+4IAVREZhVGsQqc2jNr/egDazlcxDMJsomMJL5MMPICO145BvPbPn1EJaeSdsq45py4JZ78keJ43ApqduThroR6tevsbEEJ3fTsG6z6wkwzbkx2HxpxuRnyfQzHHksJ++CqzcKBe/uJbsbR5/N0BUVNQAff2Tzuz6s7waX+F1U7m7um6p1y3z3FhWz9ULVtWLJ7LPlPM5sW5d18T3mZvo2YaXftml2mXgzzYUWcbfq4XY+gNZ3ghSdGXQhtA6qHn8PP6OWEaX2UybNu3d3NzcWnaBupGUf7mv72SNML5pOW4ef+qmVS/lIDCB4j+8IvuMBLrfzN5nSlRGrTDm8fNgBL2b0fbQCmMeP4+3bSgaxsFyGaatwcw2tugBzmPL6D0gxo8f/zFd83j06NHZqampHXrfVwQfziKhfMvyN5bR06drRb34Mvmzz/jlZK6bSCgrsWWCJRj8xbahSCgrsWX4baj3+A6WbW9bMOtpcXnDH+giO+XixYvj6Hv19G0hsw5y0VayL7SOkcnJXSLzWlGv6+9jwD5j6xl3x0hp6ibaSvaF1uHWcBZtJftC65DtPxDRYUn9XY9yPluC2ahQ9seOHTuemzNnzhE6yGtqalYYvX6jQpm5Hs4CB7pIvUI07rgg8sEyY5/R+oyqWyCMCmXGjeHMQjnmieRqPpzHPplyfTD5zw51Xh+djV6nKZtn91sHH974ev0ToyMiPOVLc1qfmvnoafY6m1cGIsOSGrkey4PZrFAWOcg9Hk8YjdtK3x6aN2/emydOnJhOA20bVQajQ1mUaL387Wu28w+pFfuMhfLwvyddWgFNr7HHRoZ4MOBbysoWMwUyhbMykNnv/5SWcew/6/ZsfOdsz7dXVm9ewIJZZkZdNuptPVKc/LMKDSk4ZcqU0wkJCX10kFMLzMiD3Cy+Ws2i9QqkxWwWX39QrdxnaoHLApl/TSSk3dhqVqMMZIYP6Nfa3ph15l/3r58yIf4T5TyybEORYUlFji+R9RBLg9nslpevg5z+DV637usbK9JBvnDhwj3l5eXFRry32a1lb+EsWi9/AtiK1rK3/Wb2PvPVQlZ7XS2kteaTJVjM4q1fmXVrsO4MNXxAf7SvbZ3a6zJsQ5FhSUWOL5H1EFe1mI8fP/5d9njq1Kknz549+x07y2OUYK0XsaNu3ro0lES6QdxI2dfszdodNfNpeldUlOZdq53AyP9IpQ7m5OSUr1sjXZ1B9YF/7eDBp9bV1z8bGRExWJ2Ts23+o4/+2u4yGaGt7edpDQ312XTrn+XLn9+elDTrmN1lMtr+rfu/v/2F7c93DnWm2F2WYFD+ev0TD0yI/0TtxKHTeAtgvVdvWPqVbL3/ElMgs3C2g+glO3q7Mc6cP39v3549C9/u6ZmcvXlzkZnBrPZh0FMvPfvswoU/xDU1NWf19/dPKC0t3WBHMOupm1afslbLd+DSQFRHc0eq2mu0jNtazVrdGHzAsm4MmrIrM/jH1S1N1+9avaJ68wKaDno8oyLCwm65QarbBBzMsn0tVfQSLD2MruOrubm1NJ2akND3UHz8R6LLiV46J8roeuXeqBd9Oy86+s7P9Sxr9H4z43PZUNKQnZ6T3lqxpGKN6DJO7Gc2ctuxABZ9Xa3VLEs/cyD0dmcY2mJWXv7h5A2pxcgL3zc2Nf2w6caJLbsZVS/6Dyc8PPyrjRvLXzSmZIETrZu3Fu/5M+fvPdV16sGVNSt/ohXMwdhq1ntMi3RH+AprJzHriqZRRl2Tp8bMddv93oGuf2VNzYqnH3nk32Oiogasfm8z103dT++//8EDFRUVa/fubc60+v3NWve2VdtystZmNYeEqp/gkYXsn3tfgqGv2QijjGj5ae0sX0PqmcnMeinXr7dudOKPujDmTpv2rj/lMmqoRF/r1luvvXv3ZWZkZOz3eDzhg4OD4f6Uzc66eWvxnjxycir9sNZySkhKp4wnAO3+3CNYjWH4yT8juy/YiT+a2n1lhpH1oi4MmtKJP5pebm9/LCIszGPU+vUwurspPT29LTo6+k8FBQVVRq7XH0bWjQ9hrVAOtm4MEsg2bDjUNnPTnsbHb4uMHCz7x+VtT8+cpfmtvh2t+5PW1W1Po/dDqBsUzKIDUus9y+9PGNPAOEYdkHpGtNJzZcZQp38tLRrQyIi66a2X6D7LzFywl378KZNR+01v3ZRBKtJPrKelTOty2rkWvdtQ7WQdtZqXpWV0n6xveqnn9/33ZG8sXawVzH8aGLjtjaMdD2m9D63LadswUFJfxwzgFMHYWg7UxmW5rTQdFRo6NPbO6C+05tu0p+HxZ59KfzvnlZez9LSWRUdqE6HslrH7ajMEM4BCMF5dYTXWaqaAGx0e7mn65/J6tfl6Pz7/rbdPn5rw8vKVByiY9byHUSO+ycjSYPanO8Mp9HZn6GVUN4ZeVuwzI7uf9NDqzmBEwtnbWBlO7MbQS6s7g3+95V8qXltRXZH5XkPzLZeGFtdtS++78IdvfuOp1Cq1k4mi3RiBXlygvPMQ/3wg6/WX5S1mNkC6GQe6XQc4wwa2t2PoTzOZuc/sptU65sfA4H/nn1M+71ZaV2Ksz172i2VpGcfGpc3dolyGH2uZD0T+W4G+iI7U5kSWB3Ps7SOOWv2elpk9+6gZq7WrtcyYuc/s/mM6e4T3faYMaP45NSzk3dBaZu56fPbW4YnqoPb3Z6aXfXvcPX8sW/p8Gx/Gai1sFsos5H21lkVHavOXnfvPlj5mM/49tvsAZ4zu0rA7lBk37DNvgatntDk3hTKj1qWx8vsLOumH/a4cP0OJtZTtunuJVneGHWw7+WfUgc7uGyfTgWBEOLN7/clYr2DeZ4F0TbBWtUz1spKv/mbGW1cFC2S2DY0cAkEPu/ehrVdl8H+h9B7sMh7cPL5uegNallaymkD2GZGllayGr5vegHZjK1kNvw31flFEretCGdD8c8HM9svl1Da81gHP31XZCTtH9UOlEtLKO2HLXjd/9xm/rKzU6ubtllPK5UB9G2oND6q2nLd1KterXCbQUehk2Y+2BzMjMkaD6EaTbYhAX3XTU1aZ6mbkPmPrcErdnFovK5m1DdXWy7fUlc/pyQ1f9bCKNMHMU254vRvGjA0ZFRU1QBe05+XlvRrIegItm6wHuN6DQGsdRpbJKMG6z6xk1jZUa50zIp9HX/8ZKeexal9KGcw8Iw54I/T09EyeNm3auzQYPA0Eb2dZZCPLmWwAJW/ZIXqyl5/HqpOR0gezLMaPH/9xbGzsp0ePHp2dmpraYXd5ZOG2kzLgPMow9fcEL7+M2Y1FRwTzTVc42HTwX7x4cVxvb29ia2trOoIZrWSQi55+ZCO+rWn2LcMcEczE7usad+zY8dycOXOOUDDX1NSssPK9ZSLTCRIAPYwKZcbMcHZMMDN2BLTH4wmrq6tb2t3dnTRv3rw3T5w4MX3YCbPfV0YyfTsKQBQfysnJyV1dGt8tSOYuXdWaxwqOC2bGyoCmQVKmTJlyOiEhoY+CmVrNbgtmb2GM1jI4iVrgskDmXxMJabNazY4NZsaKgKaui3U37mZNwbxw4cI95eXlxUa/j0yUQay2XdFyBifwOrSrSiAzaiGtOp8J4ez4YGa0rmc0YmMdP378u+zx1KlTT549e/Y7ga5TNv5sN7SUwcm8dWko0Xx8C9psQRPMjNpXNH3N40Zm/AEDcJq2n7alNZY0Lom8PfLy8qrlP52VMeuY1rw5aTnbkkOGw3zI/L7noAtmJZF/wYM9lPDHCdxKqxuDtZZr82tzm841/bD//f4Jpf9QWqoVzAOXBqI6mjtSzS/x14I+mNWItKpFl7WLE8sMIJvcrbm1NA0dFXo1+hvRn2vN11DSkJ2ek9768pKX16q9bnQ/syuDWUnvYCpmlkUUwhbAP8q+5ZSQlM7w0eFflf9c/YT++TPn7z3VderBlTUrf1KxpGKNnr5pfyGYdUIgAgSXzqHOlA+6P3iAQrf598233Kl726ptOVlrs5pDQkOGrCoTghkAXIVdYUHTfZv3LcjIy3jDM+gJG7w8GKE2/8kjJ6fSDwX39Se6zS8jghkAXC397vTW6G9Gf776tdVV7Dnq3qCWND1mU4KrMgAAAsSGEFBemcG3mhcULdgnvMIk9aeNvrUYghkAQIFvJdsBwQwArsS3mkXmt+JqDAbBDABBTas7gxEJXG9fxzbjDukIZgBwLRbI/o4uZxYEMwAEPV+tZmVA88+pYa1sM1rLBMEMAHCDntHmzCwHghkAXMFXq1kPaimzdQZeslshmAHAVVio+hPQbFni+rtkAwAYReumGqrDg468+WoMrWWNhmAGAFfy96YabD6z7pBNEMwA4Bqsn1ktUAMNWYzHDABgA6vuFo9gBgCQDIIZAECAlXcvQjADAPjJrBOACGYAAB+svtcnghkAXMXblRnelmGPzbxMjkEwAwBIBsEMACDIitYyQTADAAiwKpQJghkAXEdvP7OVoUwQzAAAkkEwA4ArsVYze6w2j6/XzYJgBgDX8jWMp9WBzCCYAcD17ApgLQhmAHCV7OzshrKyspK4uLgLw+JKSkrKGhoasu0uFw/BDACuQqFcUFBQSY9pWlVVtdruMikhmAHAtaweA0MUghkAXIW6LiorKwtaWlqe2bJlS2FxcXF5Y2PjErvLxUMwA4CrsP7koaGhEJrKFsoEwQwAIBkEMwCAZBDMAACSQTADAEgGwQwAIBkEMwCAZBDMAACS+T9r4As7h/V8wwAAAABJRU5ErkJggg==)\
*Illustration 11: NFA (left) and DFA (right) for matching \\@?.\**

\

\

\

??? can we actually remove though??? We don't follow |@ but can we
follow a|= as a? What if we are in a case of |!=. That is our var does
NOT match.

\

Following through the subset construction shown in Table 5, we see the
start state is {1,2,3,4} and following through the NFA, we see for
λ-closure (1) there are two paths that can be taken 1(2, 3|=, 4|=) and
1(3, 4). Looking at the transitions in Table 5 we can see that when
unconditional and condition transitions overlap, like in 3|=, 3 and 4|=,
4 in 2(3|=,3,4|=,4) they make the exact same transitions. This will
always be the case as |= transition is a marker on the state used by the
subset construction it does not indicate a separate state. So when
merging the conditional and unconditional states in the subset that are
the same other wise (3|=, 3) we can remove the |= conditional.

\

Removing the |= from states in this example reduces 1(2,3|=,3,4|=,4) to
1(2,3,4) and 2(3|=,3,4|=,4) to 2(3,4), as shown in Illustration 11. The
start state is unconditional accepting, which is correct as the NFA can
accept null input. Further examples will use the above |= conditional
removal simplification, as part of the subset construction.

\

  -------------------------------------------------------------------------
  DFA State          a      a|@           a|=    b      b|@          b|=
  ------------------ ------ ------------- ------ ------ ------------ ------
  1 (2,3|=,3,4|=4)   3(4)   2(3|=, 4|=)   3(4)   3(4)   2(3|=,4|=)   3(4)

  2(3|=,3,4|=,4)     3(4)   2(3|=, 4|=)   3(4)   3(4)   2(3|=,4|=)   3(4)

  3(4)               3(4)   \             \      3(4)   \            \
                                                                     
  -------------------------------------------------------------------------

*Table 5: Subset construction for \\@?.\**

The other points to focus on in this example are the transitions for
{2,3,4} (ie. 2(3|=,3,4|=4) in the transition table. Its \*|@ transition,
contains the a|@ and b|@ transitions, and both of these are examples of
the a|@ transition from the previous example, with the transitions sets
of a and a|@ being combined to find the final target set.

\

The transition from {2,3,4} to {3,4} is double labeled with \*<span
style="font-weight: normal">|= and '\*'. Unlike in the previous example
this is actually the case as 'a' and 'b' transition to {3,4} when no
conditionals are met (not a|@ and not a|=), and a|=, b|= transition to
{3,4} as well. Notice that in this case the subset construction
transition listed in Table 5 for a|= is the same a</span><span
style="font-weight: normal">s</span><span style="font-weight: normal">
the final target state, because 'a' transition in the table is the same,
so the merging of the two sets does create a new target state.</span>

\

With both \*|= and '\*' transitioning to the same state, one could
question why there isn't conditional simplification being done like was
done with |= condition removal in the state labeling. For this case such
simplification could be done but whether it is useful will depend on
implementational details, so we choose to leave the full transition
information in the examples.

\

There is one more point in this example that is worth taking note of.
The accept state is reached both conditionally and unconditionally via λ
transitions, and all the resultant DFA states have unconditional accept
states. With proper DFA minimization this example could be reduced to a
single accept state, with no conditional transitions. We will revisit
this in the section on minimizing DFAs.

\

**Example 6:** the letter 'a' followed by a variable (a\\@)

We now reverse some of the previous examples and see what happens when
the variable match is at the tail of the expression.

\

<span id="Frame11" dir="ltr"
style="float: left; width: 5.49in; height: 1.04in; border: none; padding: 0in; background: #ffffff">
</span>

![](data:image/png;base64,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)\
*Illustration 12: NFA (left) and DFA (right) for matching a\\@*

\

\

There is nothing surprising or to build on from this example, the subset
construction works as we expect it should, both 'a' and then the
variable must be matched before the conditional accept state will accept
the input.

\

  ---------------------------------------------------------
  DFA State   a         a|@       a|=   b   b|@       b|=
  ----------- --------- --------- ----- --- --------- -----
  1           2 (3|=)   \         \     \   \         \
                                                      

  2 (3|=)     \         2 (3|=)   \     \   2 (3|=)   \
                                                      
  ---------------------------------------------------------

*Table 6: Subset construction for a\\@*

\

**Example 7**: an arbitrary number of 'a's followed by a variable
(a\*\\@)

We now look at an example that forces us to extend both the subset
construction and how the variable matching is performed.

\

<span id="Frame13" dir="ltr"
style="float: left; width: 6.74in; height: 2.58in; border: none; padding: 0in; background: #ffffff">
</span>

![](data:image/png;base64,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)\
*Illustration 13: NFA (left) and incorrect DFA from current subset
construction rules (right) for matching a\*\\@. Note: <span
style="font-weight: normal">λ\^@ is a new notation explained
below</span>*

\

\

At first glance the DFA generated in Illustration 13 would seem correct
and it will work for some input and variable combinations. It correctly
matches the null string if the variable is empty. It also correctly
handles a transition to state {3,4}, which only does variable matching,
when a 'b' is matched in the variable. However it handles the
interaction of a\* and \\@ matching incorrectly.

\

  ----------------------------------------------------------------
  DFA State       a            a|@       a|=   b   b|@       b|=
  --------------- ------------ --------- ----- --- --------- -----
  1 (2, 3, 4|=)   2 (3, 4|=)   3 (4|=)   \     \   3 (4|=)   \
                                                             

  2 (3, 4|=)      2 (3, 4|=)   3 (4|=)   \     \   3 (4|=)   \
                                                             

  3 (4|=)         \            3 (4|=)   \     \   3 (4|=)   \
                                                             
  ----------------------------------------------------------------

*Table 7: incorrect subset construction for a\*\\@*

To determine what is wrong we examine a couple input and variable
values, using the example pattern in a fully anchored situation (ie.
\^a\*\\@\$)

\

  Remaining input   State transition      Variable position
  ----------------- --------------------- -------------------
  aa                {1,2,3,4} → {2,3,4}   0 → 1
  a                 {2,3,4} → {2,3,4}     1 → ?

*Table 8: Transition for @ = "a" with input aa for pattern \^a\*\\@\$*

Examining the transitions in Table 8 we see a problem even for a very
simple set of input and variable values. Clearly the input should match,
as the variable matches last the 'a', and a\* consumes the first 'a'.
The problem with the match is with the character match position in the
variable. A variable match starts on the transition from state {1,2,3,4}
to state {2,3,4} as the 'a' input matches both a\* and the start of the
variable, causing the position to increment.

\

If we were not to consume any more input we would have a valid match.
The a\* expression consumes nothing and 'a' is matched by the variable.
If the next input symbol was 'b' the match would stop here and for an
unanchored match, this would have been correct. However this does not
work for longest left match, nor tail anchored matches.

\

So we need to modify our variable match and position increment rules, in
this case we could get away with resetting the match position to 0 and
rerunning the match against the remainder of the input. This however
would not work for the input “aaa” with a variable value of “aa”, as
shown in Table 9.

\

  Remaining input   State transition      Variable position
  ----------------- --------------------- -------------------
  aaa               {1,2,3,4} → {2,3,4}   0 → 1
  aa                {2,3,4} → {2,3,4}     1 → 2
  a                 {2,3,4} → {2,3,4}     0 → 1

*Table 9: Transitions for @ = "aa" with input aaa for pattern
\^a\*\\@\$*

In this case the variable matches with the next input character, and
then resets to 0 but there is not enough input to fully match the
variable again. A successful match needs to begin when the first
variable match is at position 1. The DFA either needs to know that the
first match being performed will not lead to a successful match or it
needs to be able to track another set of positions simultaneously.

\

The DFA can not know that the first match being performed will not lead
to a successful match unless it can look ahead by completing the match.
This can be done by using a depth first search and backtracking. However
this may require rerunning match comparisons several times for each
input character and does not work for online matches where the input is
not available to revisit.

\

Instead of using backtracking the variable will be allowed to track
multiple positions (breadth first). A variable match starts when the
match variable is transitioned to, but not every transition into a
variable consuming state starts a match. The previous examples worked
because there was only a single transition into the variable match state
(state 2 to state 3 in Illustration 13), and transitions with the
variable match state looping back on it self did not result in the need
for a new match to begin.

\

We augment the NFA and DFA with a new flag indicating whether a
transition instantiates a new match for the variable. For the subset
construction when a transition contains a transition flagged to
instantiate a match, the DFA transition also picks up the match. That is
to say if the NFA transition 1 → 2 is flagged as the start of a match
then any DFA transition {X} → {Y} where {X} contains 1 and {Y} contains
2, also is flagged as instantiating a match. We indicate this as shown
in Illustration 14 with a dotted transition line and \^@ to indicate the
instantiation of a variable match.

\

&lt;&lt; diagram of dummy start state &gt;&gt;

\

Match instantiation as described won't work if the variable consuming
state is also the start state. To handle this situation a dummy start
state with a null transition to the variable consuming state is added to
the NFA. This will generate a DFA with the needed transition but also
results in an extra state in the produced DFA as well.

\

The dummy transition solution will not work for acceptance of a null
input stream, when a variable is allowed to have a null value. There are
two solutions to this problem, the start state when it also a variable
consuming state can be flagged and it can instantiate its variables at
the start of the match. Alternately conditional consuming states can
always return a match for null valued variables.

\

The addition of potentially multiple match positions for a variable
requires further modifications to variable matching and subset
construction. It is possible that any of the positions may not match on
a given transition. If this occurs the instance is discarded as it will
not lead to a successful match.

\

If there are more than one variable instance and one of them resolves to
a match, the others may still be in a valid matching state. That is to
say there are both |= and |@ transitions happening simultaneously. We
deal with this just as we have for 'a' and a|@ happening simultaneously,
that is we create a transition to a new state created the set of 'a',
'a|@', and 'a|=' transitions. Instead of labeling the transition with |@
and |= (which are still valid conditions and could exist independently),
we represent the new transition condition by '|\*'. This means for a
state that matches against a variable we now have 4 potential
transitions per character 'a', 'a|@', 'a|=', and 'a|\*'.

\

When a '|=' or '|\*' transition occurs the variable instance that caused
the match is removed from the set of variable positions (ie. Its
consumed). Conditional accept states do not remove variable instances
but if the match continues to run those instances will be removed, as
they no longer match anything.

\

If a matching engine is doing a tail anchored match, then it should be
run, ignoring accept states, until all input is consumed. If the engine
is doing a match that is unanchored on the tail then, if it is doing a
shortest left match it should stop at the first accept state, and if it
is doing a longest left match it should remember the last encountered
accept state until input is exhausted or the match engine enters the
trap state indicating that no match is possible.

\

<span id="Frame12" dir="ltr"
style="float: left; width: 6.74in; height: 2.58in; border: none; padding: 0in; background: #ffffff">
</span>

![](data:image/png;base64,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)\
*Illustration 14: NFA (left) and (DFA) right with variable instantiation
transitions for a\*\\@*

\

\

Examining Illustration 14 and its subset construction in Table 10 we can
see the mark for the variable instantiating transition but not a '|\*'
transition. That is because it is not needed for this particular pattern
as the DFA doesn't contain any a|= transitions.

\

  ----------------------------------------------------------------
  DFA State       a            a|@       a|=   b   b|@       b|=
  --------------- ------------ --------- ----- --- --------- -----
  1 (2, 3, 4|=)   2 (3, 4|=)   3 (4|=)   \     \   3 (4|=)   \
                                                             

  2 (3, 4|=)      2 (3, 4|=)   3 (4|=)   \     \   3 (4|=)   \
                                                             

  3 (4|=)         \            3 (4|=)   \     \   3 (4|=)   \
                                                             
  ----------------------------------------------------------------

*Table 10: Subset construction using the revised rules for a\*\\@*

Table 11 shows the transitions of the previous example reworked for the
new rules. The first input character causes the first variable to
instantiate and move to position 1. The next input char consumed moves
the first instance to position 2, and starts a new instance which is at
position 1. At this point if an unanchored match was being used the
state {2,3,4} could be tested for the accept condition and find it to be
true. Assuming an anchored match is being done, the state is not checked
for acceptance and the next input character is consumed. This causes the
matching instance to be removed, the next instance to be moved from 1 →
2, and a new instance to be added.

\

  Remaining input   State transition      Variable position
  ----------------- --------------------- -------------------------
  aaa               {1,2,3,4} → {2,3,4}   0 → 1
  aa                {2,3,4} → {2,3,4}     ~~1 → 2~~, 1 → 2, 0 → 1
  a                 {2,3,4} → {2,3,4}     0 → 1

*Table 11: Reworked transitions for @ = "aa" with input aaa for pattern
\^a\*\\@\$*

**Example 8**: (a\*\\@a)

We now examine an example that uses the new '|\*' transition condition.
There is nothing new in this example that requires further extension but
it makes full use of the revised subset construction.

\

<span id="Frame16" dir="ltr"
style="float: left; width: 7.49in; height: 2.48in; border: none; padding: 0in; background: #ffffff">
</span>

![](data:image/png;base64,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)\
*Illustration 15: NFA (left) and DFA (right) for a\*\\@a*\

\

Looking at Illustration 15 we see the existence of a transition types,
some times sharing a transition with another and sometimes being
completely separate. The |\* transition from 2(3|=) is particular
interest because it forces a new state 2(3|=)4 to exist, that can not be
reached by any transition, not even the a|= and a|@ transitions that it
is derived from.

\

  --------------------------------------------------------
  DFA State   a          a|@      a|=   b   b|@      b|=
  ----------- ---------- -------- ----- --- -------- -----
  1 (2,3|=)   1(2,3|=)   2(3|=)   4     \   2(3|=)   \
                                                     

  1(2,3|=)4   1(2,3|=)   2(3|=)   4     \   2(3|=)   \
                                                     

  2(3|=)      \          2(3|=)   4     \   2(3|=)   \
                                                     

  2(3|=)4     \          2(3|=)   4     \   2(3|=)   \
                                                     

  4           \          \        \     \   \        \
                                                     
  --------------------------------------------------------

*Table 12: Subset construction for a\*\\@a*

\

**Example 9**: (a\*\\@a\*)

This example clarifies a part of the subset construction that we have so
far glossed over. The DFA State column in the subset construction tables
has shown the |= mark, but the DFA diagrams have dropped it. This is not
entirely accurate as we will see.

\

<span id="Frame15" dir="ltr"
style="float: left; width: 7.51in; height: 2.76in; border: none; padding: 0in; background: #ffffff">
</span>

![](data:image/png;base64,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)\
*Illustration 16: NFA (left) and DFA (right) for a\*\\@a\**

\
\

Looking at Illustration 16 and Table 13 we can see the existence of two
pairs of states with the same set of NFA states 1(2,3|=,4|=), 1(2),3(4)
and 2(3|=,4|=), 2,3(4). Each of these pairs differ in two ways. For each
pair one is conditionally accepting and one is not, and one has a
transition on |= and the other does not. We need to examine what is
happening to determine why this warrants a new state and when it
doesn't.

\

The start state 1,(2,3|=,4|=) and its twin 1(2),3(4) cover the case
where input and variable consist only of 'a's. The start state covers
the cases where the input terminates on a variable match. Its twin
covers input conditions where at least one potential variable match has
been encountered, meaning the requirement that the variable exists has
been met and a match is guaranteed as long as the remaining input
consists of 'a's.

\

If these two states where combined into a single state we need to
determine whether the resultant state would conditionally accept. If it
was not conditionally accepting then any set of input that just
consisted of 'a's would be accepted as long as the variable contained
just 'a's as well. However this would lead to incorrect matches when the
variables length is longer than the input.

\

The alternate case of making the combined state conditionally accepting
is more interesting, as it actually will work for a single valued
variable. To explain why the state split is done we need to look at the
'b|@' transition out of 1(2),3(4). The transition of 'b|@' out of
1(2),3(4) may seem strange in that we known 1(2),3(4) can only be
reached if the variable transitioned on only contains 'a's. However the
subset construction doesn't have a memory so it doesn't take the
previous condition into account, nor is there anything in the rules that
prevents a variable that is partially matched from containing a 'b'.

\

The extended subset construction supports multivalued variables, the
only requirements are that when a variable match is instantiated, all
its potential match values are instantiated and that the acceptance
check tests multiple values for acceptance. The state will then match
and consume all potential values discarding those that can not match at
the given position.

\

The other peculiarity for to examine from {1,2,3,4} is that it doesn't
have a |\* transition despite being a variable consuming state with |@
transitions. To understand why this occurs, we need to look at how we
have extended the NFA and subset construction.

We begin by examining what happens when transitioning into a variable
consuming state. On entry the variable state tests for a match before
any |@ transitions can occur, this is shown by λ-closure on the entry
transition. The subset construction has two sets of states it needs to
simulate for this transition, the variable state, and the set of state
conditionally reachable via λ-closure. The modified λ-closure ensures
that this case is covered and that states reached via the conditional
transition are marked so. Accept states that are marked as |= have their
acceptance become conditional as well as, they are only valid as long as
the condition is met. Since |@ and hence |\* transition possibilities
can't occur yet all cases have been covered.

\

Looking at the transitions once we have entered the variable consuming
state, there two options the |@ transition and the λ-closure set of
states. The |@ transition always transitions back to the NFA variable
consuming state, so any DFA state reach via |@ will contain it and its
λ-closure set of states. The |= transition comes from states from the
λ-closure set. If a state in that λ-closure set does not have any
transitions of its own then there are no |= transitions for it to
contribute, at most it will contribute a conditional accept. If it does
have a transition the we have a |= transition and hence also a |\*
transition.

\

Looking at Illustration 16 we see that NFA state 3 has a transition on
'a' and the λ-closure for a|@ in Table 13 reflects this as well. The |=
and |\* transitions are present for {1(2,3|=,4|=)} and are missing for
{1(2),3(4)}. The reason lies in the conditionals marked on the states,
that makes these two state different. State {1(2,3|=,4|=)} represents
being in 4 different NFA states, 3 and 4 conditionally so, where state
{1(2),3(4)} represents being in the same set of NFA states but with no
condition. From these states we then do a breadth first walk to the next
set of states. {1} → {1,2,3,4)}, {2} → {2,3,4}, and {3} → {3,4}. So the
final set of states that we can be in is {1,2,3,4}, however for some of
these states we have paths that are both conditional and unconditional.
We can reach 3 and 4 conditionally but we can also reach them
unconditionally, meaning we will always reach them whether the condition
is true or not, effectively making the condition meaningless. The
conditional transitions that overlap with no conditional transition can
be removed. The remaining set including conditions represent a unique
combination to reach the set of states. In the case of case of
{1(2),3(4)} all conditions have been removed, but it is unique from its
sibling {1(2,3|=,4|=)} because it can only be reach under different
conditions, and that must be reflected. Hence {1(2,3|=,4|=)} and
{1(2),3(4)} become distinct states in the DFA.

\

What happens if we do |= and |\* transitions that are removed. Ie show
what happens when we treat {1(2),3(4)} as
{1(2,3|=,4|=),2(3|=,4|=),3(4)}. But the example doesn't really argue the
generic case.

  ---------------- -------------- ------------ ------ --- ------------ -----
  DFA State        a              a|@          a|=    b   b|@          b|=

  1,(2,3|=,4|=),   1(2,3|=,4|=)   2(3|=,4|=)   3(4)   \   2(3|=,4|=)   \
                                                                       
  2(3|=,4|=),      \              2(3|=,4|=)   3(4)       2(3|=,4|=)   
                                                                       
  3(4)             3(4)                                                

  \                \              \            \      \   \            \
                                                                       

  \                \              \            \      \   \            \
                                                                       

  \                \              \            \      \   \            \
                                                                       
  ---------------- -------------- ------------ ------ --- ------------ -----

\

  -------------- ---------- --------------- --------------- ---------------------- ------- --------------- --------------- ----------------------
  \              a - a      a|@ - a | a|@   a|= - a + a|=   a|\* - a + a|@ + a|=   b - b   b|@ - b + b|@   b|= - b + b|=   b|\* - b + b|@ + b|=
                                                                                                                           

  1,2,3|=,4|=,   1,2,3|=,   1,2,3=,         1,2,3|=,        1,2,3|=,               \       2(3|=,4|=)      \               \
                                                                                                                           
  3,4            4|=,3,4    4|=,3,4         4|=,3,4         4|=,3,4                                                        
                                                                                                                           
  \                                                                                                                        
                                                                                                                           

  1(2),3(4)      \          \               \               \                      \       \               \               \
                                                                                                                           

  \              \          \               \               \                      \       \               \               \
                                                                                                                           

  \              \          \               \               \                      \       \               \               \
                                                                                                                           
  -------------- ---------- --------------- --------------- ---------------------- ------- --------------- --------------- ----------------------

\

|@ move pointer state |= removes them from stack

\

&lt;&lt; this whole argument sequence is weak and needs to be
reworked/expanded &gt;&gt;

&lt;&lt; this doesn't really explain why the a|@ conditional transition
remains. The answer is |= and |\* are tighed to the accept state, while
|@ isn't. This comes out of the design decision to all null valued vars
and λ|= transitions instead of taking the |= transition from the
character of the variable. This is also the reason conditional accept
states exist. &gt;&gt;

\

  ------------------------------------------------------------------------
  DFA State      a              a|@          a|=    b   b|@          b|=
  -------------- -------------- ------------ ------ --- ------------ -----
  1(2,3|=,4|=)   1(2,3|=,4|=)   2(3|=,4|=)   3(4)   \   2(3|=,4|=)   \
                                                                     

  1(2),3(4)      1(2,3|=,4|=)   2(3|=,4|=)   \      \   2(3|=,4|=)   \
                                                                     
                 3(4)                                                

  2(3|=,4|=)     \              2(3|=,4|=)   3(4)   \   2(3|=,4|=)   \
                                                                     

  2,3(4)         3(4)           2(3|=,4|=)   \      \   2(3|=,4|=)   \
                                                                     

  3(4)           3(4)           \            \      \   \            \
                                                                     
  ------------------------------------------------------------------------

*Table 13: Subset construction for a\*\\@a\**

Examining the pair of 2(3|=,4|=) and 2,3(4) we see a very similar
situation, except that the two states handle 'b' as input as well has
'a's. If the two were merged ???

\

What, why is there conditional accept and |= off the same state.

\

\

\

is the split only based on accept states that are conditional

-   -   

\

\

Example 9: a variable followed by a variable (\\@\\@)

\

Example 10: a variable or a variable (\\@|\\@)

\

Example 11: a variable or a variable offset so that match does not begin
the same (\\@|a\\@)

\

\

\

looking for the longest match that is not anchored at the tail (all
input consumed),

\

\

\

Two var example where same var has 1 variable is in accept and another
isn't on the dfa state so that accept condition and consumption set are
different.

\

Example?: A pattern matching a variable followed by the same variable
(\\@\\@)

\

\

Example 4: A pattern matching the letter 'a' followed by a variable
(a\\@)

\

Example 5: A pattern matching any text followed by a variable (.\*\\@)

\

Example 5.1: A pattern matching an arbitrary number of “a”s followed by
a variable (a\*\\@)

\

Example 6: A pattern matching

\

pattern with 2 variables

extend syntax to allow for multiple variables.

\

\

Section on Implementing extended DFAs with variable matching

\

\

Extending the Aho Cohsec DFA construction algorithm from the Dragon Book

followpos computes an NFA without eps transitions

-   -   -   

compute DFA from followpos

-   -   -   

??? Section on Implementation details

\

\

Backreferences and multivalued variables.

\

??? how to work this in

Beyond providing the special case ability to have efficient pattern
matching with late bound variables this provides the back half of an
implementation needed to deal with back references, which are a widely
used feature in advanced pattern matching.

\

Modeling as an NFA

??? First Example – showing how to model it and put it together with
other NFA components ???

![](data:image/png;base64,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)\

Second example overlapping leading chars that could cause alternate
evals

\

Third trailing chars causing expansion

\

\

fourth example, two alternating paths with the same variable slightly
offset (multiple activations)

\

Fith example multiple variables

\

Converting to a DFA

-   

\

modifying ahos algorithm

\

When conditional and unconditional transitions overlap

a dfa allows only a single transition per character

\

\

Encoding conditional transitions

-   -   -   

Using a pattern to Limit state expansion

So far the variable has been matched using a customized state that
matches the pattern used to match .\* expressions. This however results
in the same exponential state expansion that kleen closure expressions
can have when constructing a DFA.

\

If the variable in question, has a limited set of values the .\* pattern
can be replaced with a more limiting pattern. This will result in dfa
construction that is bounded by the characteristics of the selected
subpattern which in most cases will be better than the bounds afforded
by .\* expressions.

\

Using variable variable sets to control state expansion

There is alternate way to control state expansion with variables.
Instead of expanding the number of states used to track the current
position and variables. The state can be partially carried in the set of
variables being matchd against.

\

\

Extending to backreferences – multivalued variables + pattern group
tracking

\

\

???? Rework earlier example ???

\

DFA

state explosion

what causes it

-   -   -   

use stored state instead of exponential states

explosion of stored state

-   

NFA

HFA

-   

\

Integrating in variables

basic simple example, no multi entry etc

-   -   

multi-entry example

-   -   

2 var example to show combining

-   

Encoding into next check/tables

-   -   

\

Multivars

-   -   -   

Dealing with overlapping vars and more than 1 permission set

Dealing with vars and minimization. Overlapping vars + more than 1 perm
set + minimization

\

Dealing with variables and back references in a dfa

\

\

dealing with a variable in an nfa

-   -   -   -   

converting the nfa to a dfa

empty var – lambda pushes conditional into previous state

multi-var/overlapping var example

efficient handling on the consume action

representation and compressing

reducing the state expansion

-   -   

extending aho algorithm to create dfas from expr trees

variable relation to back reference

-   -   -   -   

\

\

Hybrid Atomata

\

NFA implementations can be split into two broad categories, depth first
traversal where potential matches are tried one at a time and
backtracking approach is used to find the first or “best” match, and
breadth first traversal where each potential set of transitions is
tested simultaneously.

\

Each implementation has advantages and disadvantages …

\

depth first – least memory, variable time if doing first match,
potentially slowest if doing best match

breadth first – larger memory foot print, constant time to match

\

DFA equiv to breadth first search, fast but has large memory over head
(trade off time for space)

\

HFA – An NFA with sections that are dfas, try to have best properties of
both. Fixed memory overhead known in advance

\

\

Implemention {.western}
============

\

Now that we have established how to construct a variable matching DFA we
will consider an implementation.

\

\

\

Since we are using a single state to match against a string, the \*|@
transition will need to operate on some memory to remember the matches
current position. This can be done with either a pointer or index value
into the variables string, which is incremented with each transition.
The memory is set up by the transition into the state, but not by the
\*|@ transition that loops back into the state, and can be discarded
when the state is left using either the \*|= or λ|= transitions.

\

Appendix A – Thompson's construction {.western}
====================================

\

need to cover base of Thomposon's construction

Appendix B – The subset construction {.western}
====================================

\

The subset construction works on sets of states of an NFA. Each DFA
state is created from a set (one or more states) from the NFA.

\

Subset construction

let S, T be sets of NFA states

work\_queue := λ-closure({start state})

while (work\_queue is not empty)

S := pop(work\_queue)

foreach input symbol c do

T := λ-closure(move(S, c))

if T is not in States

insert T into States

push T onto work\_queue

S.transition\[c\] := T

\

Move finds the set of NFA states that can be transitioned to from the
DFA state S (which is a set of NFA states) for the input character c

move(S, c)

let T be a set of NFA states

let x be an NFA state

foreach x in S do

foreach NFA state t that c can transition to from x

push(T, t)

return T

Lambda closure computes the set of NFA states that can be transitioned
to from the set of NFA states S using only lambda (null transitions)

λ-closure(S)

let work\_queue be a set of NFA states

let t be an NFA state

work\_queue := S

while work\_queue is not empty

s := pop(work\_queue)

foreach e

\

Appendix C – Anchored and Unanchored regular expressions {.western}
========================================================

\

Anchored and unanchored matches in a DFA (appendix ?)

\

When converting a regular expression into a DFA extra states are
required to handled unanchored expressions. An anchored expression has a
straight conversion to an NFA using Thompson's construction as shown in
Illustration 17.

\

<span id="Frame14" dir="ltr"
style="float: left; width: 5.51in; height: 0.51in; border: none; padding: 0in; background: #ffffff">
</span>

![](data:image/png;base64,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)\
*Illustration 17: NFA (left) and DFA (right) for the anchored regular
expression \^a\$*

\

\

An unanchored expression requires modified start and possibly accept
states, depending on implementation, as shown in Illustration 18. The
start state loops on itself to consume leading input that does not match
the expression, while the accept state can be made to loop on it self to
consume all remaining input.

\

<span id="Frame17" dir="ltr"
style="float: left; width: 5.97in; height: 2.51in; border: none; padding: 0in; background: #ffffff">
</span>

![](data:image/png;base64,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)\
*Illustration 18: NFA (left) and DFA (right) for the unanchored regular
expression (a)*

\

\

The modified accept state is not needed unless the DFA is to consume all
input, as long as the accept condition is checked after each input
character is consumed, matching can stop when the first accept state is
encountered (see longest and shortest matches for more).

\

The modified start state is needed for an efficient match as restarting
a match for every character of the input is inefficient and does not
work for on-line matches where the input is available only once. However
in setting up the modified start condition we lose the ability to
determined when the actual match we are interested in starts. To be able
to reliably determine where the start of a match input occurs the dfa
needs to be extended as discussed in ????Tracking pattern grouping
positions????.

\

????

\

\

Appendix D: Shortest and Longest match in a DFA {.western style="page-break-before: always"}
===============================================

\

how to perform shortest match/longest matching

\

right anchor is a longest matching

References {.western}
==========

\

foo
