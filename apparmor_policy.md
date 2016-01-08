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

Understanding AppArmor Policy

\
\

<div id="Table of Contents1" dir="ltr">

<div id="Table of Contents1_Head" dir="ltr">

**Table of Contents**

</div>

[AppArmor Documentation 3](#__RefHeading__7157_510320029)

[Preface 3](#__RefHeading__2703_2002668406)

[Overview (TLDR version) 4](#__RefHeading__5632_1298471193)

[Introduction 5](#__RefHeading__2325_2002668406)

[Policy 5](#__RefHeading__2327_2002668406)

[Labels 5](#__RefHeading__2329_2002668406)

[Explicit label 6](#__RefHeading__2331_2002668406)

[Implicit label 6](#__RefHeading__2333_2002668406)

[Simple label 6](#__RefHeading__2335_2002668406)

[Compound label 6](#__RefHeading__2337_2002668406)

[Profiles 6](#__RefHeading__2339_2002668406)

[Profile names 6](#__RefHeading__5449_1830547727)

[Attachment specification 6](#__RefHeading__5451_1830547727)

[Profile Alternates (Conditional Profiles) Instantiation? Inheritance
6](#__RefHeading__5453_1830547727)

[Profile modes 7](#__RefHeading__5455_1830547727)

[Policy Namespaces 9](#__RefHeading__2341_2002668406)

[User policy namespaces 10](#__RefHeading__2343_2002668406)

[Namespace names 10](#__RefHeading__5457_1830547727)

[Namespaces and labels names 10](#__RefHeading__2345_2002668406)

[Policy namespaces interaction with system namespaces
10](#__RefHeading__5459_1830547727)

[Deriving labels from Domains (Inter Domain)
10](#__RefHeading__5461_1830547727)

[Regular expressions based rules and implicit labels
11](#__RefHeading__5463_1830547727)

[Bringing permissions into the analysis
13](#__RefHeading__5465_1830547727)

[Explicit Labeling 16](#__RefHeading__2351_2002668406)

[Stacking - dynamic composition of profiles
16](#__RefHeading__2353_2002668406)

[System Namespaces 17](#__RefHeading__5467_1830547727)

[Conditionals 17](#__RefHeading__2355_2002668406)

[Permission Check 17](#__RefHeading__2357_2002668406)

[Delegation 20](#__RefHeading__2359_2002668406)

[Implicit Delegation 20](#__RefHeading__2361_2002668406)

[Explicit Delegation 20](#__RefHeading__2363_2002668406)

[---------------------------- 22](#__RefHeading__4021_510320029)

[Glossary of Terms 25](#__RefHeading__2369_2002668406)

[Task 25](#__RefHeading__2371_2002668406)

[Confinement 26](#__RefHeading__2373_2002668406)

[Confined 26](#__RefHeading__2375_2002668406)

[Unconfined 26](#__RefHeading__2377_2002668406)

[Profile 26](#__RefHeading__2379_2002668406)

[Profile name 26](#__RefHeading__2381_2002668406)

[Attachment 26](#__RefHeading__2383_2002668406)

[Fully qualified profile name 26](#__RefHeading__2385_2002668406)

[Policy 26](#__RefHeading__2387_2002668406)

[Subprofile/Child profile 26](#__RefHeading__2389_2002668406)

[Sibling profile 26](#__RefHeading__2391_2002668406)

[Hat profile 26](#__RefHeading__2393_2002668406)

[change\_hat 26](#__RefHeading__2395_2002668406)

[Domain 26](#__RefHeading__2397_2002668406)

[Domain transition 26](#__RefHeading__2399_2002668406)

[change\_profile 27](#__RefHeading__2401_2002668406)

[Label 27](#__RefHeading__2403_2002668406)

[Explicit label 27](#__RefHeading__2405_2002668406)

[Implicit label 27](#__RefHeading__2407_2002668406)

[Simple label 27](#__RefHeading__2409_2002668406)

[Compound label (name) 27](#__RefHeading__2411_2002668406)

[Term 27](#__RefHeading__2413_2002668406)

[Access path 27](#__RefHeading__2415_2002668406)

[Handle 27](#__RefHeading__2417_2002668406)

[Disconnected paths 27](#__RefHeading__2419_2002668406)

[Revalidate/Revalidation 28](#__RefHeading__2421_2002668406)

[Revoke/Revocation 28](#__RefHeading__2423_2002668406)

[Taint/tainting 28](#__RefHeading__2425_2002668406)

[Taint loss 28](#__RefHeading__2427_2002668406)

[Namespace 28](#__RefHeading__2429_2002668406)

[Policy Namespaces 28](#__RefHeading__2431_2002668406)

[User policy namespaces 28](#__RefHeading__2433_2002668406)

[Profile stack 28](#__RefHeading__2435_2002668406)

[Stacking 28](#__RefHeading__2437_2002668406)

[Conditional 28](#__RefHeading__2439_2002668406)

[Variable 29](#__RefHeading__2441_2002668406)

[Static variable (compile time) 29](#__RefHeading__2443_2002668406)

[dynamic variable (usually a kernel variable)
29](#__RefHeading__2445_2002668406)

[Instance variable 29](#__RefHeading__4023_510320029)

[System kernel variable 29](#__RefHeading__2447_2002668406)

[Namespace kernel variable 29](#__RefHeading__2449_2002668406)

[Profile kernel variable 29](#__RefHeading__2451_2002668406)

[Instance kernel variable 29](#__RefHeading__2453_2002668406)

[Conditional variable 29](#__RefHeading__2455_2002668406)

[Matching variable 29](#__RefHeading__2457_2002668406)

[Policy Compilation 29](#__RefHeading__2459_2002668406)

[Policy Cache 29](#__RefHeading__2461_2002668406)

[Permission Check 29](#__RefHeading__2463_2002668406)

[Delegation 29](#__RefHeading__2465_2002668406)

[Implicit Delegation 30](#__RefHeading__2467_2002668406)

[Explicit Delegation 30](#__RefHeading__2469_2002668406)

[Explicit Object Delegation 30](#__RefHeading__2471_2002668406)

[Explicit Rule Delegation 30](#__RefHeading__2473_2002668406)

[Profile instance 30](#__RefHeading__2475_2002668406)

[Derived profile 30](#__RefHeading__2477_2002668406)

[Context 30](#__RefHeading__2479_2002668406)

[Security Identifier (secid) 30](#__RefHeading__2481_2002668406)

</div>

\
\

\
\
 {.western}
=

AppArmor Documentation {.western style="page-break-before: always"}
======================

AppArmor Core Policy Reference Manual

Understanding AppArmor Policy (this document)

AppArmor Developer Documentation

-   -   -   -   -   -   

Tech Docs

-   

Preface {.western}
=======

This document is intended for policy authors who want to have a better
understanding of AppArmor policy. It is a mid- level description of the
concepts in AppArmor policy as enforced on a system. While it uses
example rules from the AppArmor reference language[^1^](#sdfootnote1sym)
it does not describe the language in any detail and alternate languages
could be created to express policy. Similarily while it may mention some
of the implementation details of the enforcement engine in passing, such
mentions are intended as examples only and actual detail should be
obtained from developer documents[^2^](#sdfootnote2sym) and source code.

\

\
\
 {.western}
=

Overview (TLDR version) {.western style="page-break-before: always"}
=======================

AppArmor is a hybrid access control system that provides enforcement via
rules being enforced on a subject as it accesses objects

rules are based on access path, object properties, and requested
permissions.

apparmor is not based on type enforcement, though the label can be used
similar to a type

-   

Subject (a task/process or a proxy for a task/process)

-   -   

Proxy (a task/process or object acting on the behalf of another Subject
using that subjects security context.

Object (files, records, messages, …)

-   -   

A label is a unique name

an explicit label is a label directly stored on an object (eg. inode)

-   

an implicit label is the access label for an object derived from the set
of access rules being enforced

-   

<!-- -->

-   -   -   -   

All labels are profiles, however

the word profile is used to refer to labels that have had a set of
rules/modes explicitly defined

A label that has not been explicitly defined as a profile is treated as
being in the unconfined, noexec mode

Two profiles are defined by default for every namespace

-   -   

jdstrand&gt; what about the default profile?

labels can be simple or compound

simple == a single name

profile

label

-   -   -   -   

<!-- -->

-   

<!-- -->

-   -   

-   

<!-- -->

-   

Profiles and labels exist within a Policy namespace (jdstrand&gt; is the
namespace name part of the label?)

-   -   -   -   -   

jj&gt; this is too long we need to trim it. This is ideally a quick
summary and some one who needs more can look at the references

\

\

\

\

\

Where to put this

\

Security goals

- reduce attack surface area

- remove interfaces/syscalls that aren't in use

- identify unexpected behavior

- further granularity file name/permission level of interfaces that are
in use

- patterns of accesses (ie read then write not supported, write once –
maybe supported with vars)

- reduce shared mutable state\
 - allow finer grained security based labeling of resources (not
restricted to user id)\
- reduce use of identity for authority\
 - instead of asking for roots permission to do something (prompting for
password), ask if has authority to do X, and allow delegating that
authority.

\

- Not a static MAC system but a dynamic MAC system

- use same abstractions at all levels

- decompose, identity (security id) and authority (ability to do this).
Capability is the token carried to indicate whether has the authority.
Delegated tokens carry the information about what authority is granted.

\

Make apparmor less of an ambient authority system, shoot for Priciple of
Least Authority

\

sparse capabilities – long unguessable keys giving access to something.
Eg google random urls to access an file, blog post etc.

object capabilities – token to access object.

\

Persistent storage of delegation vs. temporal storage of delegation.

- store in authority rule in the profile (maybe special section) –
persistent

- store on file handle

- there is another level of temporal, between permanent and object only,
at the session level. Possible to store a set of rules at this level
that then get cleared.

\

\

\

\

\

Static ambient security – apparmor is not

selinux provides an easy way to analyse information flow from the global
perspective.

To do this analysis in apparmor you need to add in the potential dynamic
pieces of information

So it comes down to which is more important global information flow or
generic containment.

Note: that both can do the same thing its just a matter of ease /
management / analysis (ie where they focus their strength).

\

\

Hrmm labeling to handle authority, so how do we deal with identy vs
label questions vs delegated authority in apparmor

\

that is – simple authority check (is it labeled X), this can also be
taken as the “Identity” ie who is on the other end. How ever we could in
apparmor ask instead does X has the authority

\

authority is carried by the set of rules, + the delegation info

\

\

What apparmor isn't – static ambient authority system that makes it easy
to do static analyse on information flow. The implicit labeling allows
for a more dynamic system that requires mounts and other information to
be part of the analysis, but arguably helps in setting up a more dynamic
system. So its focus is not on controlling who can leak your info.

\

\

For extending apparmor to the userspace discussion

\

Authority vs. Identify

When extending apparmor with a trusted helper, a decision has to be made
about how the trusted helper will interact with the apparmor policy and
kernel module. At a broadest sense this is decision between authority
and identity.

\

The trusted helper can choose to just leverage the security labeling
(Identity) provide by apparmor when making its decisions, or it can
use/extended apparmor policy and query the policy when a decision is to
be made.

\

- Using identity directly, dealing with delegation

\

Using identity through policy

- label rule of a given type

- query based on that type

Extending a new type and permissions.

- can use existing type/permission set

- define a new set

- discuss type splitting

\

To often applications have been written using Identity as the
determinant for permission

- if (uid=root) does not allow distinguishing between different apps run
by root

- generic permission prompt for user vs application X wants to access

\

Use of the apparmor security label as identity

\

- Indentity asking if the other end is I

- vs Authority asking if the other end can do A

\

The security label can be used as either

\

If there is only 1 candidate for that can have the permission or the
distinction between who at the other end has that permission is not
important, then the security label can be used directly to handle the
permission.

- just query label, is it X grant permission.

- In the case that the cadidate is extended to more than 1 in the
future. Keep the label, have the different candidates set a label on the
socket resource, so that communication appears to come from X

\*\* this fails if there is no object/socket proxy (as might be the case
in dbus or some other systems, might be able to label the socket that
communicates with dbus so we might get away this)

\*\* does not work if we would like to identify peer different from
permission. Ie in a requester we would like to say firefox would like to
have access to X, not that label Y (which firefox has access to) would
like access to something.

\

In cases where a distinction between multiple peers is important use an
extended permission instead of a label.

\

\

Extended permission vs. label

\

One of the choices that needs to be made for a trusted helper is what is
how the permission accesses that the helper is going to check are
encoded in policy. ???

\

so permission needed if different subject need to access object with
label X at the same time and have different permissions.

\

there is no clear distinction of when a permission should exist vs using
a type/label

all permissions could be represented by type splitting and a single
binary permission (true/false)

\

eg. permission for Fred to read/write a file of type foo could be
represented by the tuple

\

Subject Object Permission

Fred foo rw

\

However type splitting could also be used to come up with 3 different
types to represent r, w, rw (foo.r, foo.w, foo.rw). The tuple then
becomes

\

Fred foo.rw true

\

However this requires more label splitting than is needed, nor does it
have the benefit of carrying common semantic information, unless the
label/type format is specified to carry it. That is read and write are
common across multiple types and their combination (rw) is also common
and specifying them as permissions allows for policy to be smaller.

\

Oh and splitting out the permission allows for different subjects to
have different access rights to a label.

\

\

Having trusted helper store “intent/permission” based using identity vs.
doing it in apparmor policy

\

Having trusted helper store “intent”

Advantages

- only requires being able to query security label

- possible to take advantage of extended instantiation

- localizes it per user (can be finer if it leverages instantiation)

- is doable without apparmor extension to policy

- does not require helper to be able to load policy - is doable without
apparmor extension around policy loading

\

Disadvantages

- splits policy so that what is allowed can not be introspected in one
place

- depending on how intent storage is done may require additional
tools/per trusted helper plugins be created to introspect policy

- can not preseed any perm as part of policy, could be done via
preseeding each helpers “db”

- can not take advantage of fine grained policy controls that are built
in, like per rule audit controls, prompt hints etc.

- can do course mode based stuff

- ties decision to a policy ID instead of a permission

- this is some what neutral in that the local storage can come up with
its own set of permissions for the ID, but the permission is not policy
based it is only known about in the helper code, again this will require
special tooling to introspect

- won't be able to integrate delegation, at least not in the same way as
the rest of policy.

\

Neutral

- speed (this could go either way)

could be faster to query and determine perms locally, but likely needs a
trip to the kernel to get the security id anyways

likely won't have precomuted matching engine to query permissions
against, so could be slower

\

\

Storing “Intent” in Policy with extended types and permissions.

- keeps policy in one place (introspection)

- single tool for revocation

- can leverage fine grained policy features

- can levage policy based delegation

\

Requires

- way to extend policy with new types/perms without updating the
compiler

- Helper to be able to load policy

- needs extensions to control what policy/bits of policy the helper can
load

- needs a way to do partial policy compiles and loads so that “helper”
policy modifications don't affect other policy.

- this means helper policy is “referenced” but loaded separately, it can
be, updated, compiled, shared, and replaced separately from the rest of
policy

- needs a location to store “intents” without modifying base policy
(could be a dir)

- needs a way to store “intents” per user or finer

- could be different conditional blocks or files/directories\
 for user based trusted helpers likely different directories\
 for policy based trusted helpers a dir for each policy, which could be
divided further by dirs for users, etc.

\

\

\

\

Instantiations

- are different versions of a profile

- eg same profile but different user, and the profile has rules
conditional on the user

- different instantiation will result in different permissions so they
can not be treated the same for short circuiting purposes

- replacements need to create replacement instantiations

- need to identify which run time variables a profile is dependent on,
and create instantiations if this any variable changes.

- owner where uid == ouid is special and doesn't need to cause an
instantiation but other uses of uid (not ouid) do need to cause an
instantiation.

- run time variables that are supposed to affect every task using the
variable do not affect instantiations, only per task/user variables need
instantiations\
\

\

Introduction {.western style="page-break-before: always"}
============

AppArmor is a flexible hybrid (jdstrand&gt; hybrid-enforcement or HE
(maybe?) maybe? security system that can be used to provide application
sandboxes, resource usage limits, MAC (mandatory access control) policy,
and even an MLS style policy. It consists of a number of userspace tools
and libraries and a kernel based enforcement engine.

\

Jdstrand&gt; maybe add background on TE and DTE. Eg: “Other existing
security systems exist, such as Type Enforcement (TE) which defines
types for each object and the applies a global policy to these defined
types and the more flexible Domain Type Enforcement (DTE) which defines
types for each object and different policy domains that apply to these
defined types.

\

jj&gt; Not here. Maybe add a reference to them, or a reference and an
appendix, I'd rather keep this focused as a mid level view for people
interested in authoring policy, than deep dive into differences.

\

Where TE and DTE can be thought of as taking an object-centric view,
AppArmor takes a subject-centric view and uses Hybrid Enforcement (HE)
to focus on the application. In the HE model, the concepts of domain
rules and typed objects are combined for each subject such that policy
can more flexibly describe interactions between subjects as well as
accesses to objects.” - reword

\

jj&gt; hrmmm not quite

TE and DTE (DTE is really just a variant of TE. Take a tuple view. Rules
are based on

subject object permissions

TE sets the rules up as a global set of rules and some TE systems
(selinux) don't distinguish between subject domain types and object
types. They are the same.

DTE explicitly splits them into a domain type that can exist on subjects
as it contains the rules and object types.

\

Apparmor takes the view that the “types” are the same (similar to TE),
but allows/has (the implicit mode can be seen as defining rules) rules
on all types, just that the rules are not enforced when the “type” is on
an object. I quote “type” because we are not exactly doing a type but a
label that could be a the equiv of a type if partitioned correctly (or
on a subject) but is often not a type because we don't force the rule
partioning on the object labels, and handle it lazily. This allows us to
dynamically change what type is possible with delegation.

\

We do need to explain this but it will need to be more gradual through
out the document and in the appendix

\

The level of security provided is dependent on the policy, which is the
set of rules that define what permissions are allowed. Policy is largely
written from the point of view of an application (subject), but
mechanisms are provided for specifying some policy from a global point
of view.

\

The AppArmor system is flexible in its enforcement requirements and
providesing the ability to define restriction based on both access paths
and labeling.

\

Policy {.western}
======

AppArmor policy is the full set of rules that are enforced on a system.
It is defined by specifying the behavior of several interacting
components (labels, profiles, namespaces, variables).

\

The AppArmor project provides a reference language^1^ to define system
policy and a compiler to build and load it into the kernel for
enforcement.

\

### Labels {.western}

Labels are the base unit of mediation in AppArmor even though they are
the direct use of a label is a special situation in reference policy
(jdstrand&gt; reword). They are the mediation identifier attached to an
object, which is used in determining what permissions a subject (task)
has when accessing the object. In AppArmor, labels are applied to all
objects but for most objects the label is implied and not permanently
stored and, they are lazily generated as needed at run time from the set
of rules being enforced. Labels that are lazily generated from rules are
known as implicit labels while labels that are stored on an object (eg,
in the inode) are known as explicit labels.

\

All labels share a few basic properties, a name which can be used to
specify interactions with the label, a modeed), and, if the label is a
profile, a set of rules. The label name is must conform to a defined
format and of what is allowed and is unique within a policy namespace.

\

The label name is unique only within its policy namespace. Labels from
different namespace with the same name are unique when the policy
namespace name is prepended, this is known as a fully qualified name (fq
name).

\

Name restrictions.

Namespace names

simple names compound labels/names

fqnames

\

\

A label can be anything from an individual unit (ie, an explicit label
or a profile), a representation of a set of units (ie an implicit label
or a profile stack, or a simple label (one that is just a name).

\

##### Profiles (jdstrand&gt; is heading 5 correct here? jj&gt;Maybe the intent was to be a sub of Labels as they are just labels with explicit rules, but maybe it would be better if it was its own section instead of a subsection) {.western}

Profiles are labels with rules, and are how task confinement is
specified in AppArmor. Each profile has a unique name, some control
flags, and a set of rules defining access rights, resources, and
privileged operations that an application (subject) will be restricted
to when the profile is applied. If an application (subject) is labeled
with a profile and the profile is not set to the unconfined mode it is
said to be confined by the profile. (jdstrand&gt; what about the mode?)

\

**Profile names**

In addition to being a label name, the profile name may also specify the
profile's attachment specification, and as such has fewer restrictions
placed on it than other types of label names. More specifically if the
profile name is rooted (begins with the / character) it will provide the
profile's attachment specification if the profile does not specify an
alternate attachment specification rule. The attachment specification of
a profile when combined with execute rules is used to determine when a
profile is attached to a task. (jdstrand&gt; should we mention
path-based attachment more clearly here? No below in the attachment
specification section)

\

Hierarchical ???

\

**Attachment specification**

Foo

**Profile Alternates (Conditional Profiles) Instantiation?**

Profile alternates provide a convenient way to specify multiple versions
of a profile which are used under different conditions. That is to say
the same profile can be specified multiple times each with a different
set of conditions, and the appropriate variant of the profile is chosen
at runtime for rule enforcement.

\

profile example uid=fred { }

profile example uid=george { }

\

Profile alternates are not actually separate profiles.Each alternate
shares the same unique label name and exists together with the other
alternates. They are in fact just an anotherlternate way of specifying a
single profile with different conditional rule blocks, except that the
rule blocks can be loaded and replaced independently from each other.

\

The ability to add, replace, and remove alternates independently of
replacing a single profile is provided for a few reasons. ?????

\

??? how to specify removal of an alternate

\

**Profile modes**

Profile modes are used to define how a profile behaves and can be viewed
as a way to modify all the rules in the profile. The different profile
modes are:

enforce (default mode, unspecified access is denied and logged)

kill (unspecified access is denied, logged and the application is
terminated)

audit (all accesses are logged, unspecified access is denied and logged)

complain (unspecified access is allowed, but logged)

unconfined (all access is allowed)

noexec (Execute and profile transition permissions are denied but all
other access are treated as unconfined.)

\

\

\

\

\

why label needs rule context – not unique to lookup perms, unless it is
a name only label

Label and modes

Simple labels default to the noexec mode.

\

\

Reporting of Modes

One interfaces that report the mode of a label/profile the mode may be
reported as either it name or the first letter of its name. Compound
labels always report a set of modes using the first letter of the modes
of the labels that the compound label is made up of. The order of the
modes reported are the same as those of the simple labels in the
compound label. For example A//&B (EU) means A is in the enforcing mode
and B is in the unconfined mode.

\

\

\

\

\

Attachment specification stuff ...

The profile name may be used to provide the attachment specification.
This is optional and used to determine when the profile attaches to
theagainst an executables name. The profile name and attachment
specification are often the same but there is no requirement that they
have any relation.

\

Profiles names have several limitations, hierarchical (jdstrand&gt; all
these could be more clear)

: - namespace

& - stacked

+ - delegation

\# - explicit label – property of object/handle not the label or profile

// - path separator

other leading symbols are reserved

\

/ not allowed as a trailing character

\

\

jdstreand&gt; we were talking about profiles, but now talking about
labels. This should probably move?

label/profile states - unconfined

\

domain transitions

exec - px

noexec - change\_hat

\

whether object or handle is labeled depends on the type of object and
its lifetime

\

not really the document to talk about syntax and sibling transitions,
stacking transitions, multiple targets etc.

\

\

for conditional label rules - must be able to communicate with every
entry (profile or label) in the label, not just a subset, if passes test
for every one then it updates the label with its label, label is updated
via rcu

use opportunistic locking

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

when to use labels, vs. implicit labeling, overlay to provide writable
location

\

need to work on run time aliases

\

\

Implicit labeling consistency in move/rename

- labeling needs to be checked/reevaluated every move, rename, link,
mount (move), unmount, profile manipulation. Basically check if any
profile is invalid if so don't use it/remove it

\

Delegation and no-newprivs. Delegation from outside allowed? Need to
track no newprivs to where it happened in stack.

\

\

\

Implementing implicit labeling (jdstreand&gt; not this document? Hrmm a
little bit)

 {.western}

global policy – single dfa: state provides label

- problematic in dynamic system, changes in namespaces etc (have to
recompile dfa etc)

\

- Solutions, multiple dfas and composition, options

- list of profiles, can't check which path

- list of profile states – could have multiple states for a give
profile, can reconstruct which state, may represent multiple profiles,
can not be shared across types (different states), work for object label
if you already have task profiles, for tasks need reverse mapping to
find profiles from labels so you can ask new questions

- list of accept states – per profile accept info

\

Storing on object vs Handle

Object

- need to update object with policy changes

- need to update object for all policy on each mv/rename etc.

\

Handle

- need to update as handle is passed around

- Fall back to revalidation

- can fail for disconnected paths

\

\

\

\

\

Introduction

\

Profile

- attachments

- domain transitions

\

Label

- task labeling

- object labeling

\

Label modes

\

\

\

\

### Policy Namespaces {.western}

A policy namespace contains the set of labels including the set of
profiles that are visible and available to attach to a given task. They
allow separating labels into separate functional groups that can be
managed independently, allowing for different policy to be applied to
different groups within the system.

\

The labels with in a namespace are independent from the labels in
another namespace. Thus while a label name must be unique within a
policy namespace, each namespace can have its own unique version of a
label that is tailored for the task it is confining. Just as importantly
a namespace does not need to define labels (or profiles) for the same
set of executables as other namespaces. The only label that a policy
namespace is guaranteed to have is the unconfined profile which is
unique for each namespace.

\

Policy namespaces are hierarchical, with a default root namespace
defined on system setup. New namespaces are created as children of the
root namespace, and those namespaces can define their own children.

\

Within the hierarchy the parent namespace has control over its children,
that is it can see, define and manipulate the policy of its children,
but its children cannot see[^3^](#sdfootnote3sym) or manipulate the
parent namespace. From the point of view of any child namespace it is
the root namespace of the system.

\

When a task manipulates policy it does so against the current namespace,
which is the namespace at the “top” of the label stack. If the current
namespace is changed then said task will not be able to manipulate the
original namespace, all manipulation will be applied to the new
namespace.

\

Tasks inherit the current namespace from their parent. They can switch
to a new policy namespace if a the namespace has been defined and the
tasks has sufficient permissions to perform the switch. After the switch
is made the new namespace is what will be inherited by its children as
their current namespace.

\

It is important to note that a switch to a new namespace can not be
forced on a task (that is only a task can switch its own namespace), and
that once the switch has been made the task can not switch back to the
original namespace; it can not even see the original namespace as the
new namespace will be a child of the original namespace. A change in
policy namespace also means a change in profile confinement which may be
a profile of the same name or could be a different profile entirely.

##### User policy namespaces {.western}

User policy namespaces are a special namespace that allow a user to
define policy for their own tasks. They allow for users to be able to
define and manipulate MAC policy for their own tasks independent of what
system policy defines.

\

User policy namespaces can have limits enforced on them by the system,
and they may not be available on a given system.

##### Namespace names {.western}

begin with colon

end with colon

// after is optional

\

hierarchical // separating children

##### Namespaces and labels names {.western}

Namespace names

When an object has multiple labels that are from different namespaces
the labels are stored in separate sets, one for each namespace.

\

When multiple labels are stored on an object a compound label is used to
represent that combination of labels.

\

Visibility????

\

##### Policy namespaces interaction with system namespaces {.western}

AppArmor policy namespaces are independent of the other linux system
namespace, and can be used in conjunction with or independently of the
other namespace types. It is important to note that the transition is
done using a different api, and at no time does the new namespace and
old namespace contain the same set of profiles, that is to say even if
they are exactly the same they are considered as different profiles for
the purposes of mediation (this is important for labeling and
revalidation).

**Explicit Labeling**

Foo, can be simple or compound, per NS, profiles must agree on each
label being set

\

**Stacking - dynamic composition of profiles**

AppArmor allows for a task to be confined by multiple profiles, known as
a stack, allowing for a limited dynamic composition. For mediation
purposes a profile stack is a compound label, the only differences are
that a task can explicitly request to modify its labeling and that the
stack is responsible for tracking the tasks current namespace. As with
compound labels there is a single set of profile for each namespace
involved in the confinement.

\

Mediation of permission requests is based off of the intersection of all
profiles, that is a permission request is only granted if it is allowed
by all profiles that are labeling the task.

\

For domain transitions if the transition is allowed, then each profile
determines its own transition independently and the results are combined
to achieve the new label (stack). If multiple profiles make a transition
to the same profile during the domain transition then size of the stack
will be reduced as the labeling is a set of profiles.

\

It is not possible for the stack to have a profile used multiple times
within the stack. If this occurs the entries within the stack will merge
as all subsequent domain transitions and mediation requests will be the
same. Profiles with the same name but in different namespaces are not
considered to be the same, so a task could well be confined by a stack
of two or more unconfined profiles as long as they where from different
namespaces.

\

Once a task has created a stack there is no way for it to request that
it be unstacked. Policy transitions may result in a stack being merged
down, but this is an unlikely situation and is controlled by the policy
author.

\

The current namespace will always be set to the last namespace added to
the stack. This is used to determine which policy the tasks confined by
the stack can manage. The current namespace can only be changed by new
stacking calls or transition from the current namespace. Transitions
from other namespaces in the stack do not change the current stack.

\

If there are other namespaces referenced within the stack, the tasks
within can not manipulate or manage them but other tasks on the system
with different confinement might be able to. That is not to say that
other tasks can direcly change a tasks stack but that they may be able
to load or unload policy to a namespace that the task can not because
that namespace is not considered its current namespace.

\

When a task requests access to an unlabeled object the stack label is
used as the basis for the initial implicit labeling. The exact labeling
will depend on the policy and how it is loaded, as it may provide
additional labeling information that can be extended beyond what the
stack provides.

\

### System Namespaces {.western}

??? Determining permissions, access paths, …

aliases if policy ns is shared,

should switch to separate policy ns, or use explicit labeling

**Conditionals**

AppArmor defines three types of conditionals that can be used from the
kernel: kernel object, policy, and match; that can be used to
dynamically determine permissions.

\

The kernel object conditional is based on values that are stored as part
of the mediated object and is used during permission evaluation. Object
uid and file system type are examples of object conditionals.

\

Policy conditionals are conditionals that can be toggled at run time to
change what permissions a match can select. They can be used to support
a wide variety of different policy model such as time based access
restrictions.

\

Match conditionals are variables that have been embedded into the path
matching engine and can be used to change which access paths result in a
valid match. Match conditionals are an extension of policy conditionals,
and rely on the matching engine supporting variables.

**Permission Check**

When a task wishes to access an object a permission check is done to
determine whether the task has sufficient permissions under its current
confinement. The permission check is done in multiple steps and can
succeed or fail at any point.

\

The permission check is done for each namespace in the tasks current
labeling.

\

First the labeling on the object is checked. If the object is labeled
with an implicit label that matches to the task's current labeling, or
the task's labeling is a subset of the objects labeling then access is
allowed because at some point a full permission check was already done.
Note that the equivalence and subset tests are carried out against the
labels within a namespace, not across namespace.

\

If the object has an explicit label it is checked against, the generic
label permissions, and if access is allowed the permission check for the
namespace is finished. This will only succeed if the label is granted
for all connected and disconnected path checks.

\

If permission was not granted in the previous step, a path lookup for
the object is done.

\

If the path is connected the path is matched against the match db for
each profile confining the task (the stack). If the match results in an
unconditional permission, it is used as the result. If however the match
results in a conditional permission, the object and conditional index
for the match are evaluated to determine if permission is granted. If
the object is labeled with an explicit permission it may be evaluated
here.

\

If the path is disconnected the disconnected path check is done. It may
use the partial path and any object permissions. ???? conditional proc –
get rid of nasty sysctl

<span id="Frame1" dir="ltr"
style="float: left; width: 6.7in; height: 10in; border: none; padding: 0in; background: #ffffff">
</span>

![](data:image/png;base64,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)\
*Drawing 1: Permission check*

\

### Delegation {.western}

foo

Implicit Delegation

Implicit delegation allows a profile to specify out of the set of
objects that that the profile allows access to, a subset of objects that
can be passed to another profile. Implicit allows for a basic form of
delegation and dynamic profiles without modifying an application.
However it will not work for applications that pass information via
access path.

\

Implicit delegation is done at the open object level so that a task must
have an opened object (eg. file) before it can be passed to another
task/profile. The receiving task then has access to that object but does
not have permission to open a new version of the object.

\

The passing of an object can be done at exec time through inheritance,
or passing the object over an ipc communication channel (eg. unix domain
socket).

\

Eg. If the file at /etc/example is passed a receiving task, that task
has the rights to use the file via the handle that was passed but it can
not open /etc/example, and it will lose access to the file if it closes
the handle it was passed.

\

It is important to not that implicit delegation is done at the profile
level with implicit labeling. When a access path is marked as being
delegated, the permission set for that path is marked as having an
implicit label of the profile + the target profile. If a particular path
can be delegated to more than one target then it will be marked as being
labeled with the full set of profiles. When an object is opened it is
labeled with the implicit label (either the opening profile, or the set
of profiles specified for that path). Subsequent accesses are done via
the label check.

\

This means that the recipient task can redelegate the file but only to
task that are allowed by the labeling. This means the initial task that
delegates its authority must list the full set of profiles for all tasks
that need to access the object.

\

The labeling implicit labeling that delegation places on an object is no
different than standard implicit labels and may be updated by
revalidation checks.

\

??? In some ways it would be nice to allow the inheritance tree, this
would be a loosening of perms so could come later if such is needed

\

??? It would be nice to be able to specify delegation at the exec level
instead of just profile because, the profile may depend on what is
attached (eg. px may not find the expected profile).

**Explicit Delegation**

Explicit Delegation allows a task to indicate an access path that can be
passed to another task. This requires the application to have delegation
logic.

\

Details pending.

good for power box, file dialogs etc.

doesn't need to be as broad as implicit

-   

<!-- -->

-   -   -   

\

delegation is done at the file descriptor level, and is controlled at
the execution and file descriptor passing boundaries.

\

Add note: on how delegation plays into revalidation check

\

\

Implicit labels – matching permission check vs label check

-   -   -   

\

\

Delegation and domain transitions

\

- does the delegated object go through verification like other object?
With the current simple labeling plan it does, as there is no way to
distinguish which profile was added via delegation.

\

\

\
\
 {.western}
=

 {.western style="page-break-before: always"}

**----------------------------**

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

Explanation of Profile attachment model – more indepth

\

\

\

Stack order does matter for the purposes of ipc

-   

foo

\

\

-   

\

\

Profiles, Labels and Stacking

\

A label is – base label, profile, set of profiles

\

A profile is a label with rules associated with it

\

A stack is a special label where ordering of the subcomponents matter
for policy administration

\

A secid is a unique number that maps to a label

\

A compound name a text representation of

\

Context

- set of labels and other necessary information for the object

\

\

\

\

Unconfined State/profile

\

no mediation except exec transitions, governed by /\*\* px,

\

\

\

\

over lapping label and implicit label rules, which gets applied

ie.

label=foo /\*\* w,

/\*\* rw,

\

well obviously r is applied as implicit, but should w result in label or
implicit labeling?

-   

\

\

Need a section on the interaction of linux namespaces with apparmor
policy

\

-   -   

\

- How do policy namespaces interact with other system namespaces

-   

\

\

used in conjunction with stacking, chroots, containers

\

Uses for policy namespaces

-   -   

\

uses for stacking

-   -   -   

\

A Note about implicit labeling

\

Implicit labeling is largely an implementation detail and theoretical
construct, that is used to provide a more functional implementation in
an architecture (LSM) largely designed around labeling, to explain
profile path based rule interaction with explicit labeling, and as a
theory to allow a more detailed comparison with labeling based security
systems. Despite its extensive use as a core part of AppArmor's policy
the average user/administrator does not need to know what implicit
labeling is.

\

\

labeling, namespaces and revalidation. What if a change in namespace is
encountered

\

labeling and stacking (how does this work in with namespaces)

\

implicit labeling and stacks. - how the stack label is expanded when a
path specifies a compound label

\

implicit labeling is handled at the instance level instead of the
permanent object level so, that a clean label is started with every
time. This is done becomes policy reloads may change the labeling and
currently policy loading can be done incrementally meaning that the full
label can not be computed in advance.

\

What of label comparison between a stacked and unstacked

If they have the same namespaces then the comparison is as normal

If one has more namespaces, a deeper stack

1.  2.  

What if they have the same depth but different namespaces

\

\

\

\

When is the label subset test used vs. when a label equivalence test
used.

\

Ie communicate with A != communcicate with A&B, but for revalidation
purposes A is a subset of A&B is valid

\

\

Labeling can be done on File object or inode

delegation needs to be done on the file object as it should not be
visible globally?

-   -   

Labeling or the inode could be done incrementally or all at once

if incrementally labeling rules have issues

if done all at once, its only done at the fs namespace level because the
name can only be looked up against that namespace.

-   -   -   

What of filesystem namespaces, do we force a new profile namespace when
a new namespace is created?

-   

\

If labeling is stored on an inode then, a rename needs to invalidate the
old implicit labeling.

\

\

\

\

How this works for fs namespaces

they are aliases

two possibilities

-   -   

\

\

How apparmor policy is static and dynamic.

-   -   -   

\

\

how to handle replaced profiles

-   -   -   -   -   -   

\

\

\

\

\

Policydb layout

\

\

\

Task Label – issues

using the dfa state to represent a label has several issues

-   -   -   

Advantages

-   -   

\

Idea for multiple profiles on the same dfa, allocate contiguously,
guarantees sorted into a group (if sorting by address)

\

\

\

discuss profile hierarchy

\

\

 {.western}

\

\

\

\

\

\

\

\
\
 {.western}
=

Do an over view of how it fits together with references to more detail
sections

\
\

understanding apparmor policy

profiles written from subject pov

access path based rules

- give access to files that are not explicitly labeled

- file is implicitly labeled

label rules

- access to files with matching label

- labels always cross check

label + access path based rules

label access is cross checked, profiles don't dominate (cross check)

\
\

persistent vs. temporal label

\
\

\
\

Cover basics, then revist with more detail, so unix/linux specifics
don't come in until more later

- file descriptor/handle caching to handle revocation

- rename???? and aliasing????

\
\

Understanding AppArmor Labeling {.western style="page-break-before: always"}
===============================

AppArmor policy is defined by the profile, which when attached to a
subject (task) is the set of rules used for access mediation when the
subject is permforming an action (executing), that is the profile(s)
is/defines the subjects domain. We use the term domain for a subjects
confinement because while a profile can be a subjects domain, the domain
may also be defined by a stack of profiles (compound label). Initially
we will discuss apparmor policy where the domain is always a single
profile and the expand upon that????reword/fix me???

\

Many of apparmor's rules are expressed in the form of access paths,
however a label can also be specified as a further refinement or
alternate form of control. The behavior of labels and label rules is
tightly coupled to profiles and profile names (profiles are labels);
understanding this coupling is important to be able to author and
understand apparmor policy.

\

### Implicit labeling – deriving labels from access paths {.western}

Internally apparmor treats all objects as labeled, however the label is
often lazily derived from the access path and the domains operating on
it. These dervived labels, known as implicit labels, won't often appear
directly in policy. The set of implicit labels is dynamic and may change
as the set of rules in the system change (profiles are added, removed,
or replaced).

\

In apparmor access path rules are a way of specifying a type/label
indirectly. Instead of saying an object has a type of X, and the domain
has access to type X. Access path rules allow a domain to say it has
access to the object at the access path, and thus can communicate via
the object at that access path with other domains that also have access
to the object at said access path.

\

If apparmor only supported access path rules, then no labeling of the
object would be necessary but since apparmor combines access path and
label rules it must have a way of derving a label from the access path
rules in the different profiles in policy.

##### Deriving the label - the intersection of profiles and access path rules {.western}

To understand how to derive label from apparmor's rules we start with a
simple example (Figure 1) with three profiles (A, B, C) that each
contain a set of path based access rules. Each profile has access to a
unique file and some files that are shared.

\

<span id="Frame2" dir="ltr"
style="float: left; width: 4.25in; height: 2in; border: none; padding: 0in; background: #ffffff">
</span>

![](data:image/png;base64,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)\
*Figure 1: List of files accessible from profiles A, B, and C*

\
\

\

The intersection of these profiles is nicely shown with a Venn Diagram.
Each section of the Venn Diagram shows which profiles and rules that
intersected to create the section. The set of profiles that creates the
section is the “derived” label, so for the example as shown in Figure 2
we have the set of derived labels A, B, C, AB, AC, BC, and ABC.

\

<span id="Frame3" dir="ltr"
style="float: left; width: 3.75in; height: 3.51in; border: none; padding: 0in; background: #ffffff">
</span>

![](data:image/png;base64,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)\
*Figure 2: Labels derived from profiles A, B, and C*\

\

\

These derived labels are the basis of AppArmor's implicit labels. The
derived (and implicit) label literally represents the set of profiles
that can access an object at a given access path. So the derived label
for the access path /ac is AC (or A & C), which is means that profile A
and profile C have access to the object at access path /ac.

\

AppArmor's implicit label is based on the derived label, but is more
dynamic. It may start out as a subset of the profiles in the derived
label and can grow to be the derived label, or when label based rules
are used it may deviate from the derived label to become a super set of
what is allowed by the derived label.

\

The object type and how it is accessed will determine how close to the
derived label the implicit label is. When ????.

\

As long as label rules have not been used in the construction of an
implicit label on an object, it is not considered when an access path
rule is checked to determine access to the object. The access path rule
will be checked and then if the access is allowed the profile will be
added to the implicit label. However dependant on how expensive an
access check is the implicit label maybe checked as a cache of previous
access decisions, because if an implicit label contains the profile in
question then access to the object for that profile was already granted.

\

##### Using label rules with implicit labels {.western}

While the implicit label is not used directly by access path rules it
can be used by label rules to reason about access to an object.

\

Label rule is checked against each profile in the implicit label

\

\

\

\

When label based rules are used they can modify the implicit label in
such a way that further access

\

That is as long as access path rules don't intersect with label based
rules in the policy then access to an object is determed solely via
acces path rules.

\

n't considered when a profile's access path rule is checked to determine
access to an object. When a new

but it can be used by label based rules to mediate access to objects.

\

??? when does an implicit label grow, vs. be used in its entirety ???

??? Move this else where

the difference being that the implicit label is dynamic and may start
out as a single base profile, and tighten as the intersections are
discovered.

\

More on this dynamism???

\

### Explicit labeling ??? {.western}

Access path rules and their dervied labels provide a default security
view of the system. However this default labeling is insufficient to
maintain isolation between security domain when there are overlapping
read and write permissions between. While some times the overlap is
appropriate, there are other times when this overlap allows for sharing
that should not be allowed.

\

For example /tmp is often used by multiple applications and most policy
requires both read and write privileges to /tmp. But if a user runs
applications in different security domains it is likely that they should
not be able to access each others /tmp files. To achieve this explicit
labeling is used to set a label on an object that is different from the
default implicit labeling.

\

The explicit label is stored on the object and it is used instead of the
implicit label for access checks. Further more it prevents plain access
path rules from accessing the object as plain access path rules are
conditional on the object being implicitly labeled.

\

\

The explicit label behaves in a similar maner to an implicit label that
has been extended by a label rule. That is the explicit label forces a
check????

\

as there are times when object needs to have a different labeling than
what

\

the derived label can expresses the view only via access path

sometimes we want to be able to express an object is outside the pattern
provided by implicit labeling, in this case the object can be explicitly
labeled.

\

Explicit label says regular label derivation does not apply.

\

Need label rules to access object

\

label rules can combine both label and access path

\

### Combining label rules and implicit labels??? {.western}

\

label rule can be used to access an object that is implicitly label

\

If access is granted it expands the objects implicit label

label access rules can be applied to each profile in a compound label
(implicit label)

\

New accesses to the object by path or label, are checked against the
profile(s) that where added via label based rule. As that profile is not
allowing access to anyone on path X, but only access to domains A, B, C.

\

\

????

When a label is on an object its rules are not applied unless the object
is acting as a proxy for another subject so that the cross check is
applied.

\

??? shoul cross check be applied to files??? It is possible!

- if applied eagerly only sane way to block unallowed communications

- Hrmm could have a global type table like DTE too (yuk, no).

\

- Global rules that get applied to all profiles?

\

need to bring compound labeling in after basic labeling discussion,
maybe even after basics of all

need cap, resource limits sections

need domain transition section

need namespace discussion, and how it applies to each type

\

socket/fd passing

delegation

\

peristent storage implicit labels treat different than transient
communication channel

- storage full derived label, for label rule(s) to pass

- comm channel, partial implicit label

- check against current, adds to label and can block new additions
because of cross check\
 - new path entries could just be added but current labeling may not\
 - should have flag to indicate when label isn't pure implicit? It would
speed up check but could not be removed\
\

### Communication between Subjects {.western}

The direct communication between Subjects is a little different than the
use of a file. As shown in Figure 3 communication while it has the
appearance of being direct, passes through some channel in the kernel,
where subject context and apparmor policy are applied before the
communication is completed.

\

In apparmor policy the profile for neither subject is dominant and the
policy is applied at both the sending and receiving end of the
communication. This means that if Subject A is going to send a message
to Subject B, the profile on Subject A must allow sending to Subject B
on the chosen type of communication channel, and Subject B's profile
must allow receiving a message from Subject A on the chosen type of
communication channel. This check is known as the cross check and it is
done for all types of inter subject communication.

\

<span id="Frame15" dir="ltr"
style="float: left; width: 4.05in; height: 3in; border: none; padding: 0in; background: #ffffff">
</span>

![](data:image/png;base64,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)\
*Figure 3: communication between two subjects confined by AppArmor*

\

\

For some forms of communication (signals, ptrace) this simplistic model
is enough but for some other forms of communication this basic model is
insufficient. This is because many forms of communication do not go
directly to the task but go through an object or objects that can be
shared between different subjects, examples of this would be unix pipes,
fifos and sockets.

\

Unix pipes and fifos are examples of communication that share a single
intermediary object with a handle in each subject to access the object.
In Figure 4 we see that when process A creates a pipe and its two
handles (file descriptors fd~r~, fd~w~), the pipe and handles are
labeled with the same label as process A.

\

Figure 5 show what happens when process A pass one of the file
descriptors (fd~r~) to process B. Access to the file descriptor and
object (pipe) are checked for process B. If process B can communicate
over pipes and communicate with the labeling of process A, then process
B is allowed to receive the file descriptor. If the labeling is not
explicitly set then the labeling of the shared object is updated to
reflect that it is shared by both A and B.

\

??? do we label the handle

??? do we update both the handle and label

??? does pipe labeling step back down in labeling when a handle is
closed by a process? Neat but probably not

- would work for files too, files can be assumed to always be the full
set due to persistence. Ie tracking lost over time.

This affects how the label is applied for temporary objects the label
represents the current can access set. This affects how label rules can
interact with a file or ipc object. In the file case the full access set
must be in the can comm set.

- how do we handle dir renames? Need to invalidate in some way

- handles allow for access after a file is not accessible.

??? we could delay inode labeling to when a label rule forces it. Or we
could do it eagerly as files are accessed. Both require invalidation for
renames unmounts, bind mounts. Eager could cat hard link issues

- files we don't store labeling on inode and use path to derive label,
we do this to avoid the dir rename problem, that is a dir move causes a
relabeling but we don't propogate the info to the children

- the full label on the file should be the derived label

- we have the dir name problem with fifos

- comm channels need labeling for cross check, but why not files?

\

<span id="Frame17" dir="ltr"
style="float: left; width: 5.3in; height: 3in; border: none; padding: 0in; background: #ffffff">
</span>

![](data:image/png;base64,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)\
*Figure 4: Process A creates a pipe*

\

\

If the pipe is further shared as in Figure 6 the cross check is done
again and the new participant (process C) must be able to communicate
via pipes with both process A and process B, and process A and B must be
able to communicate with process C via a pipe.

\

<span id="Frame18" dir="ltr"
style="float: left; width: 5.3in; height: 3in; border: none; padding: 0in; background: #ffffff">
</span>

![](data:image/png;base64,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)\
*Figure 5: Process A shares pipe handle with B, causing the labeling to
be updated*

\

\

??? pipe – 2 diagrams, A sets up pipe and handles. 2^Nd^ A pass handle
to B

\

<span id="Frame19" dir="ltr"
style="float: left; width: 6.8in; height: 3.01in; border: none; padding: 0in; background: #ffffff">
</span>

![](data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAXkAAACkCAYAAABy1F54AAAACXBIWXMAAA7DAAAOzgFywdYpAAAnd0lEQVR4nO2dCTiV2RvArUnTqpIhIu0bKaUmFZIxRKYiabEXKVnbtJLKWhQh0j7tKfKfylImUkZ7U2OUlEabFq22+/cypz63e7mXu3t/z/M993z7+x33+32vc889V4pGo4lpO5+kiSEIgiBCydXYqeLM1kl922i0Hm/CQRAEQTiFtnNuRmPrpRpbiSAIggg3KHkEQRARBiWPIAgiwqDkEQRBRBiUPIIgiAiDkkcQBBFhUPIIgiAiDEoeQRpBQkIpvaamRJ/fcSBIc0HJI3yBRqOJ9+kzdh+UCwtzbNjZt6Xihf3htUeP7q+Dgvxi5syZfpbb50QQfoGSR/hCdnbe4J9+0r4Nss/Ovjpk7Fjt28y2pRcsJ2QLx7hy5dpAU9O5gaxIHgWPCCsoeYQvHD9+RtfJySYFJH/8eKoukfydO/dVnZx8vPPzb/WtqKiQJtuT7BtkC2U5uS7v7t27OK9bN7m3L1+WdRowYPzugoI/5ty9W9DL1nbJsvLy97I7d4aEmJoa5jCLQUJCooaU09KytGxtPZZBOTExfJOBgW5+w22/PWjoY+zfX/3x3bsXbMXFxWnV1dUSgwZNTIyO3hiurz/uGmdrDUHYByWP8IVaUaqFhq6JhvLGjZGzyHJ7e09fG5tfz2dmHvVo06ZNJSxj1FQyfbrJxaioRPPVqz33bN++a+qMGaYXunTpXO7mttI9IsI/UkFBvmzmTJdVzCQPx+zeveub4OBVO2De3X21W0zM5lAoL1myxu3WrXR7ZrHTxwjzZ86kjTYxmXR59+4jRp07d3yPgkcEBZQ8wnNqM+B+Z89eGEmyc+Datdt9hw8fUnD79j01yPCJ4JmxeLHDcX39GaHu7o7HoqP3mGVkHPWE5ffvFyqbmdluqKmpEYfMmtn+9A+NwsJHSoaG4/+E/yxqy4qNnZs+xoULbU+uWxc2b/LkCXnr14fN3bJl/XZW6gFBeAFKHuE50FRz5Ejs2mnTTC7C/LFjKeNhGUh+6NCBD+Li9pssWDDnNJGorGzbL6Wlz+UgOyfHGDSoX9GwYQMfmJvbBWhoDCocOLDvI1g+YECfYn9/nwRjY/0r1OaYplBX71WSlvaHFjwcevdWedrYtvQxjhgx7O9Xr153XLFik+MPP7T7PHXqz380r2YQhPOg5BGeA0K3s7NKJfOamoP/Wb062M7f3zcB2tEdHb1rWe9SVVUlCRm3q6ttUr9+4/a+f/9BlpqBQxY/Zcq8wOTkPcvJspiYzWEODl4+IP9aYUuw+oFpePi6KGh2gXJCQlhQY9syitHR0foMnHfXrvDN7NcIgnAPlDzCc+BDSuq8urrq0zt3Mu2gPGTIgIeXLycvpK6HdnPSdg4QcUMbOL3EtbU17928mebQ2PkZid/QcHze48d5lsy2pe5DHyM8TCCTHzy4fxG01Td2bgThNSh5BGkhMjKqZ+Hhcv78IS8pKalqfseDIFRQ8gjSQioriyfxOwYEYQZKHkEQRIRBySMIgogwKHkEQRARBiWPIAgiwqDkEQRBRBiUPIIgiAiDkkcQBBFhvkpe2zk3g5+BIAiCIJynTvJXY6eK8zsQBEEQhPMIRHMNGRIWhnnldywIIsrgvcYZhKkeBULyCIIgCHdAySMIgogwKHkEQRARhu+Sp/5EG5SFoY0LQYQRvNc4g7DVI98lTypIGCoLQYQZvNc4g7DVI98ljyAIgnAPlDyCIIgIg5JHEAQRYVDyCIIgIgxKHkEQRIRBySMIgogwdZLXdj5Ja2pDXiAocQCtcdA2qH92r3vejADa7iN+fK+rlrx3WuPfWpgRJE8ISiyNvYe/ZvKnwqbq8SYcJoQJRF3VYeZ5slUOu8yu7OANnuU9TmBET97DOyJCLYM3rLb7/OmTTMm7Gn2yXqmjRDp1Hmitf2thJ8uhM399BTgIxltHN/5No4Fgcw3SLEDwdVK9k5kRI0CiB2IiQy2z8u/PVVTq+YLfsSAIv0HJI2zzVfAUBEn0L18874yCR5B6UPIIWzASPEEQRA9NMuQVmmZST5/Q9XZz9J78i1k2K/sL0zjhogz+HTgHSh5hmcYET+C36EHs1Lb3jWuXO0bE7g2E8uH9u42Y7UcddAoRHKh/FxR+80DJIyzBiuAJ3BQ9uzf940dFCuP1Df9ktm1enIWYeJzYd4IXdekL4/WRmEc6neB3KEIFSh5pEnYETwDR68iK03I/cyuqhqJiduMr91It/SMzTYvZMWA/0quotWSNwjB6Iv1DiBqvoHRbFBZQ8gjXyMzMEJsf8ocYJzN6ZiJmduMvX7txp5ujzUpW2uQFXXytCfxbcA6UPNIozcniqXC66YaVm5/aF954ikUWTFAOj961GV7Jh7P0feYRRBRBySNMaangCfz+MJYRj8oqDPkdA4LwghZJHrKqsRp99kE552ahDWdCQgQBTgmeIGiil5KSquZ3DAjvqKyqkloVFed05Fy6PpSX2s3Zu9Dy1+P8josXtEjyebnZg7V1froNsr96OXuIts7Y25wKjFUYfVWdm/u1BjgteIKgiB7/7q2P4N0HZt0pfKiWGbfNrWP79u+Ddu/naVLabox++secdLbfd83dj0qLJH/m1HFdG1unFJB86unjus2R/P2/7qj6LHLyvnU9v29FRYU03IBZmWlaHgtsl8H68B2Jm3QnGuSDlG2dXJMOH9httMTXb+9Cj6UHqV98gdeTZ7MWL6nd7315uWzItp0hhsamOcs9XJfoGf58BT54O3vm1NiMc/8btSd+hxl1P7zpv8EtwRMERfRI6+LA/85OPhYcuEJZocczmN+w0DmW1X3vPihSdd0Y4n39fkHfispKaZBuxtV8LWf/TXWOil21bJOetlY+lEHK86eZJ+0787vRstr/FrzmWB+EZWQdvKbFRCx2qt33/YdPslErvEN+GTcmxz14yxJDnVFXTHXHZidnZY89d/nKqLjjp8yo+zVX9i2SfK2g1dYEhkZDOTJ046zmHMPT1d73V0ub80fPZHq0adOmEpat9nV327w1JhTKa5YucUvPvWUPZT1D41zreY4pM80MQ0Dy9F98mfzT8Dj/oIhI+R4KZS52M1eB5P2DIyLtracGwINof2KcacLBk34bw6O2CFImD2J9ditJ7GneQbGa6gqxEY7f/ov8c+evDeapcHr0xEyxTFpwbGex+2KZLI+81FbsOtvncfFuL2bp6UA7HBbP0fhxsDGEGU9fvOymqvjjv83Zd8GGIF8ro0nnz0aFe7SRlq5zlHf4NrfIZV51jvLZss0tb3+CPdl+8pjRubZmJimmi71DQPIgZ2pGrjPXKS7Uc1FkDzm5srmr/FeB5GHe0tevzlO7kpJNDwcF+G31WbKFr5l8bebd70La2ZEkGwZu37jWd4jG8AIyT10HMJLqvbu31eC/ASJ44NHDQiXyBZbasiJZPulnk8vw+rrsVUdGMRUW3Fe2tTLbUFNTI0662kHbq7Ob52GrKZNCk85dWiRobbEQJ/TVrij6/VXu7X9c6MdcUdopll6bWX9Xb9wQ2kSxieIgenb2+Txak+3zLAj9Q+wehwXf3Ade3fskFrtdizqK3bu9LHr674/9VVWKmW3DLGOGZh57c5MUInjgQUmJksGoEXWOelDyVJG6vfFPOnWeevX2HUNP/V38WHm6z8paT9G+eUpSsnqxteXhXxZ5hWbERi6C+eZfbUOaLXloqonde2Stifm0izCfknRsPCyjSp6VTHng4KEPajNskzkOC04T0fdSUy+BL7CArFVUez9tbP+2srJfnj8rlYPsvU+/AcU+fv4J+pONr0hISNTA+k8fP7aNCN4w+7eksz6b16902Hc8damMjEwldb/m1kFLoI7NAZm8oAyq1RzRs0Od4L0Ep6kG6l8YvhyEtIxZP08+C9l31HKvUNImT99kwyxjHqLe+0FCUoqJk8WU00T0vZWUSqDJpqb2faOmqNioowBZGZkvpa/K5BS6ypX176VSvNrZPsFozKivnvr4+XPbzYn7ZidHBPus2RHvkBS+ealMG+lK6n7NvfYWSd5qtl0qmR88VPOf4IDVdr6r/BPYOQ60ncMAUutXertUVVVJwoNh3abwKGjGgfVhUQlBje0P7fTjhvfb++H9e9mUjFxXr4UOPnYzzQNqHxAScCx/P5/5fv5BMcOGj/i7srJSys970eLgyNhQ6n68brah/zYfNMnUItHcQbU4DbdEL2iCp4IDYok2PvNmHYDeNRMcF26vqq6WhN41rO4L7eaugSHeyyOiXWBfeBgELXGNWhAQVOeoHX6+jToKcJ5mnjTMcs7e9x8/yV6Mj3J1CQz2meHrV+cpON6KyJj5G9zmx2gN6Pc39P7xDI1YvL32gUTdj+dt8hfy7tpS51V7qz/NvHrHjt3jDBg05GFy+uWF1GXj9Q3z8u49tqQuo4qYWl4VELwDJjKfdvmmA3W/wLDtW0m5NsPPhYnRfryA2Xgh0OYOomd3UC1uwmnRC7LgqXAzqxekr+MLSiy8+lUuaSmpqk2LXaJhYnffwepqDy/Eb2/gKINRI/MKTh22pN+WKmJqeeOiBTtgIvNX98U38NQWH/evnjIaMzoXJkb7NQf8MhQPIfJoKmtsalAtbkEfF6dEL+iCJ002pMzNcwXHsveLRvoS9e3E8G+9gqpCqdMmp7gJ0ydcaFEQsYLx+bSPc+O/aIRwBpQ8j2ElU2xqUC1uQxVeS0Uv6IInUB/AgtZkk16Trg8xXUu/Nny91frVLZY8G8BDBs7Pq/0QzsMTyX/+/LkNtLFHJRwIgPmmui+y072RbOtqP8sP2u/btm1bwam4+QUrg2oxGyKXk1Blz67oidzveU3kSmytlY5dO75jdduiO0WqIU4h3gX5BX0rKyqlQbr5aflam2zr+3cvS1y2Scugvn83SNnc1Tzp992/G83xm7PXeqn1QfJfBHmNyIpYDPt+Kv8k673TO2SM6ZicLa5bloz6edSVsWZjs7NPZY+98r8ro07tqO/fTfYTJtl//lLRZv6GIN/d6/3qXNVUF0Z2ujiSbeetDvCLWekb1FamDU9cxRPJH9y902TMuAk3uHkOOD6cx26+m8AONt1YltjUoFr0UIfI5WR8pEwfJzsZvbBk74wQxN42RJZS0lJV646tW8PqfkH2Qb6TbCadD88M95BuU98rZJv7NjevmPr+3duWbHNLuPWtf/do49G5Jo4mKd6G3iEgeZAzNSN3Gu4UtyhiUaScglyZ/0z/VSB5mPebWt+/Ozku2TTgZIDfkqglW4Q1k991KsVEd7gGV10Fx4fzuMyw4ImreCL5E0cOGIRHJzKUFacYq6t33dPVzldQJd9ScegM7X3gxbNSOSjLK/z4qvukUM4F9x9NxceK6IVZ8ARBEz2R5Y2LNzSCHYJ9QK7U9cwy5oe3H6qZOJmkEMEDJYUlSiMM6/t3Py1s2L9bx6S+f/e7V4z7dz++/1h5pdnKDTRK/25JKclqS0/Lw16TvEIjL0UugnlOXDO/OHQ2zSBu1VKuumrCCM3rzgFBviIl+b/u3OoN7cyM1kFzyw/t239avSEkeradczJZDsMTnEs9PQa6WEJWe/XypSH0QxZQj9NTpVfp3ds31bl9Lfxi3ASDfPhiGNycaup9n9wXE1Nsei/O05joRUHwBEETPeH96/ft6Zcxy5h7D+39ICUuxWTKgimnieiV1JVKoMkGRK3Yu+n+3TKyMl/KSsvkIHtXGaBSbO9vnzDK+Fv/7s8fP7fdt2Hf7OCzwT7xK+MdNqduXiotI11J3a+l18xL7hQ+6N3rRwWGroLmlvbtZD9tXOQS7TDV9KurYIiCM3/kjIla7h1iPlE3K+fm7SH0wxZQj6OioFB6+59CnrmK7x+8QjMFfFPWznqqP1XyUywsM2Bat8LLFSS/0svNnX7IAn7GzQ6ckAWM31P7IKsbd0Otd5+S+9lippyJjn0YiV6UBC9oQKYO7yF5Zfnn7tu/dbVrCmg3D3EM8Y72jnaprqqWhIeBa7hrFDTjwHrfhKb7d0M7/Zx+c/Z+el8rrNwoV/hPws+8vn83HC/GJ2b+/KD5Mf1G9Pu7qrJKKmJRxGKvWK9Q6n7C2GzDCGhPh/FrLJeu8qdKfpqBXgZMyyKiXEHyHiFb3emHLeBn3DyRPPSFh26B6n37PaYujwgJtIndFjbjdVlZR5IZEEgXwifFRQowz2jIAipPih8pwLdnuXsl7MOpbNB8+swGQ0TEZ59c1dJjtgSq6EVV8IKQzbdEkGpD1B5uv9ywf/dIw5F5hx9/37+beh5qeUHwgh0wkfn4mw37d1MfOtCmDxOj/YSFwb3VHj76t1Shr4pyA1cFJe63iTh4ZEbZu3ffuYoMbwD7wTyjYQuoFJeWKgxW780zV/FE8hYzZqVdvnRBg17ykaEbbX5LOuddWVkhPc14Yjh1HelC2FOlvpmH0ZAFVHL+yNSYOt06nX65sCCMg2uB6AeEBtCaI/jm7sdrBEH0CO+wNDJIy7p2Q4Ne8sF79tukRIR4wyiUk109GrgKhjeAV9LMw2jYAioX829oWE7W55mreCL5WbZOydCF0qb2lbp8mtXsc7MsjIJmzJr3O/0+Scd+0ydt8jC/eWtMGP2QBdTts7MyNZsaAoHXsCoHXn3rjxs0V9TCIHik9WFvZpoMXSjtzU0buMr6Z8NzU9x9g2abGH3nqiPn0/VJmzzMRy71DKMftoC6/cX865rQhZK7V/INnkge+q6TPvIAEfSmLdHhMEE5IDgikn49Fc0R2vfohyygbks9viCA2Z/oICzZfMXnijbQ3u53oL6Pd1PdGNnp5ki2DZgV4Adt+W3a8qaPN6+BvuukjzxABB3h6xEOE5ShvZ1+PZWRgwbcox+2gLot9fi8gO8fvIoiwiAEhD2EQfQpO1NMNCZwt483HB/OY+HGm+5/SMtBySMIiwi66NMOpBksTeRuH29NPc3rQXZBvih54QElz2EEWQKIaPPg1oPeMIgZo3XQ3CLbXvaTS4hLtKnzt/ZmGKYg53TOGOhuqWuhm3X70u0h9EMXUI+j0EuhtPAm7/p4Iy0HJc9BUPCij6Bn88yA9vSCawV9V01d5U+VvJ6lXgZMUV5RriD5rW5b3emHLuBn3EjLQckjCJsIquihX3xpUamCcr+G3f/2B+63ORJ2ZMa7su/7eJMhDmA/mGc0dAGV0kelCvBNWu5eCcJJUPIcQhBveqR1YTDLIO3GhRsa30l+436bkHMh3jASpcfEhn28YYgDeCXNPIyGLqByI/OGhr417/p4Iy0HJc8BUPCtD0HM5k2dTJOhCyW8UpcbzjY852vkG2Q07/s+3um/peuTNnmY94zxDKMfuoC6/fXM65qsDIeACA4oeQRpJoImeui7TvrIA0TQHtEe4TBBGdrb6ddTGaA94B790AXUbanHR4QDlHwLEaSbHOE9giZ6BKEHJd8C8OZGEETQQckjSAvBbB4RZKRINynFODGhGwWRm7D6+6mMupkhrRNW3gt6eJ81oLm/UyyL9dgAqEdmSYYUrNB2Pkk7FTZVj9eBCSow7G9jI0Ni1oYwoqn3BdxnwbGd8T77Dx/nN43eZ8yAesxywHok6MY3Xo/YXIMgHAKbbRBBBCXPJngTI42BokcEDZQ8G+DNi7ACih4RJFDyLII3LYIgwghKHkG4AGbziKCAkmcBvFmR5oCiRwQBlHwT4E2KIIgwg5JHEC6C2TzCb1DyjYA3J8IJiOhHOuHPoiK8ByXPBBQ8wkmI6MVi8dv4CG9ByVNQ7CCe8bSchl+XRriGnrheRgYtA99jCM9Ayf8HCJ76ilk8wi1Q9AgvqZN8XpyFmFhY04PBEQEKM6xm6thcg3ASVkcrhQcAt2PhBdx8iNX5yqHxapLVEf56/HSZM3VYJ/nGPhCiiv3Wc5oHJ07KT6jX05jwUfAIJ/naJs8EIvdwWrjQ32MA9WHFaeEz8xVV7G8ThL8eqdfTEuEzba4hMhQFsVOhXg+5RqrsoQxDDfMjNkS0ATnVZaEURE3uBOr1kGvkVnZPZCgKYqdCvR5yjc2RPUPJg/xETe6MINfISPYIwg2I6ERV7owg18gN2YP8RE3ujCDX2BzZfyf51iJ4KlTZo+gRXtEaBE+FKnv84Ll5UGXPquixdw0FEDyIHr+0giCCT2vJ4hkBgmdV9A0k3xqzeCqvPolp8jsGRPSBTLa1ZfFU4NqhDjCZaj4Vd69rsrrtV8m3dsEToA6GyouHi8Xi73MjnKe1C55TtOYsngDXD/XQ1MMSm2sQBEFEGJQ8A6asycIvQyEIF4H/ZjzELfA/5hYC2Xwn+8br8es3XrGpBkG4C9xn2FTTcqAeW3tTDTtgJo8gCCLCCIzk98VuHb91w3IT95UbU2Y7u1/kdzwIIkp4SniGUeel20pXdlTs+G6QyaC7RmuNfm/Xpd1HfsUmTHypqpKKSM3QO3bl2vCHz192k5GWqtJSUyl2MRx/0WjYoLv8jo8RAiP5U4d2a/sFRR/dF7NlAkoeQThPWE2YJylXfamSKisqk8sMy5y4x2rP3AVnF+zgZ2zCQEVVtaRZcJRrXwX557td5+3uLd/t5ceKSumr/xSpxqRl6aLkG+H+nRuK7X5o/8Xcat7V/bUZPcz3H6zxlN9xIYioIiUjVSXfX/656SbT5PXK61fzOx5hYPvZzIndO3Qo32Y38zeyrJOsZPWkoQPuwcTP2BpDICSf9FviKCs710tQtrBxyIV5X//wk3wOC0FEFsjkXxe/7nIh/MIE1bGqRfyORxg4mpuvtWWu5WF+x8EufJd8VVWVRG5WWl/P1UGnYd5kms2f0/U0fDzXBJ+SkpKq4Xd8CCIq0LfLA517dn6zOHtxBD/iETYKn73s1vdH+ef8joNd+C75rHMpgyYamd2RkpauhvmOnTp/0ho97gEs1zM2v83v+BBEVKC2yVdXVku+/Odlt+SlyaapfqnG1onWB/kZG8I9+C75k4cSR2WkJg2J2xI4ibr806ePbVDyCMIdJKUlq3sM7PHMMs7y8KaBm5bxOx5hQL1Ht5cF/z6X11bv9YjfsbADXyX/+tXLH/IuZfbJKXy7/If2Hb6Q5R/el8tMHq6yBtZ36drtAz9jRBCRhiYmJiEpgc2iLDBt1PBrW1PT9fe52e3idyzswFfJpxzbP2L8ZNM7VMEDMA/LYT12p0QQzkNtrhlqMfQWv+MRBhYaTcw02bx94eLEQ1ZQVpfv/uJDRUWbvMIi1R3ns3SPLHGK43eMjOCr5KEXjdfakCRG68ytbK+ErvU2R8kjCGegfvAKzTWdlTu/0bTUvD551eSz/IxLWJCRkqpK9nWN2pqaoTdn+y67ohevusKykeqqRS6Txgusp/gq+SPp10KYrdMZb1DQ2HoEQViH+qEr0nzaSktXLjWbfBYmfsfCKnz/4BVBEAThHih5BEEQEQYljyAIIsKg5BEEQUSYr5Kv+11TBEG4ioe4B95nHKCTPdYjq3yVPP4y1DdWbP8j/PQ6XX6HgYgg+MtQ32jJAw9/GeobTT3wsLkGQRBEhEHJIwiCiDAoeQRBEBEGJY8gCCLCoOQRBEFEGJQ8giCICIOSRxAEEWFQ8giCICIMSh5BEESEQckjCIKIMCh5BEEQEQYljyAIIsKg5BEEQUQYlDyCIIgIwzPJD+shEXbzWQ3+mDCCcAlPCc8w/MFuztDZwTPsTbxo1KVQZvIteWDAvvAqISFBU1RWLVuyalPy5CnTb1C3odVU1b0qKSmVVFZWSvv5+QUsXrw4osWBI4gA05KHBI1GE9/QZ8NKKPsV+gUw2qa6sloyZXmKSf7BfC0otyRWQaclDwmoy+HL6uvy+mbGdQnHh1cJcXEavB49enR6LUcZbSuUkqcKvjnCh+2hInOz0vv4OFvNo5d8Qda+utecnJwxnTp1ehsYGLiCI4EjiABDFTy7wi/KLlJV+0ntoRitvqw6VrWIfpu0jWkG/97690f3HPetsp1kPy3vvHwjh0IXOKiCZ1f4uf8UqY7uq/aQRvuv3Of7uiTnAI/B8RcsWLCj2ZIHic5yXJR1ePeOsflPvvhcu3JJzW+RrfWHD+Vt14XtPDRhsukdsl27H9p/8V4bcmr6XOccWJZ25sTQNR6OVnpGZncaO4f+UMV1h9PyQx78/VcPx2kGrhF7kuKHjdB5NENf0zvtZsla+jiqKislQdQkKyevu09nRTKKrTE6d+n6gX7Zk5u/172qqKgUw+vmzZuXNnUcBGkuIFTdRbpZ2TuyxwZ/CfZ5eOmh2kHbg9afyz+3tdppdWiw6eA7ZDuZ9jJfzELMTo1xHlN3j906cWvoIcdDVoPNBn/3Xl+juGadd753yLO/nvWIMohydUhyiO+l0+tRiGaI99qStWvpzw3ZNYgdlpF18ArLmMVEuHn85rAxTmNyQDpQZiT5vL15Ix1PO+7sotLlNafrkADCm2+gm5WQmT32RWywz+WCh2ouCQet33/+3DbS1urQzxr1ccN27dvKfAmwNDtlO6G+Lk/n3xq6KPGQ1S+a39dlf8816y6u8Q65/++zHmbBUa4HFznEa6v3ejRubYj3vdD6uqSeu7K6WhIkTDJu8grLmMVEOJ1/c9i88bV1KUYTP/3nzWHMJE+la9eur5itYymTH6w58nGe/ydfKAcuc5u2PDDiRFd5hXe+zjPnEpGCdP+6dU3Jfd5UByL5rQHLTTdu37sfykmHdmszO/7AYVpPHhcVdjsQH6nrsHhZ2vbNq43XhsUdguWM4tD8USqUnJOayc/QH+7NKDZ6yENBSlq6OjzhWCL9+s/lL1ipFgThGMojlR8HfQqqu8eOuR2bZhFhcaKjQsd3e2bumUuECrItuVaiFD813oFIPnl5sqnNXpu6e+zq7qsN7rGeWj2fvCx82S0rMkvXYJlBWurqVGOrOKtDsJzRub2kvELJeegzeWYxEUrvlCqYh5onQRkydkbX+LbkbSc5NbmyltZVUwxXVX78LKa+Ln32H5sWNMvihHynju/sd+yZS4QKsr1RXKJkExnvQCS/7liyaaxjfV0euNSwLjV69Xzy8PnLbrHns3Q9fjFICzyZahxRK2gNlYZ1Sc4t51hfl0T01EyeWUyEv0pKFTZY1ddlWArjugTIgwMIDQ31YrYdS5L/5ddZ+dCGDeWiwvvdF80xc6ipqRGvpW593JbASXt2hE18+7qsHdkOKHlcJDdmguHfNBqNyZHrGaQx4vGVrPS+D+7fVQDp/p50WBOOV7u8QQVS42AEo9gYQR4Kf+ZcVF+9xMGK/mHQtkN3sQ9lTxjvjCBcQGuWVr64RH376ov7L7rHm8U70Gpo4mL/vY3PB56flBmWOfFj2cd2ZDugrKhMrp9hv7/FGNwVyiOUHxekF/QtvVuqYHvMNvH64euacIyeIxqKiXpuZjCKifAk/0nP+2fv9yeZPwAPI6XhSiXU7TopdXpb9rBMTn6A/HPWaqV5zNDRyidt1QWlL7rPjIh3qKn9D4OEHZpyftK23zMnvv7wsR3ZDih+WSanN7jf34x0pdlL+fHFewV97/1bqrB3oW3iiavXNeEYmqoN65J6bmYwiolw/dGTnul37venChweRhoqDesSIA8O+I1XDw+PcFNT02RG52NJ8pKSkjWkrNZnwHO3Zf6p4wyM/yLC3bl146S4I+eiKysrpOymTlxItlVSVi27nJXWt6njDxqq9WT5wjk2zh4rz9fKmTZttuPlrRtWmGzdfTKBWRyEtrKylS+fl3boJq9Qzii2pnj39nU7+mU9hxmJ3c+MFysuLlYhbfLYZINwEwlJia/vbZCgsb9x6kDjgX8R+Z7feH6SyzmX6KqKKqntE7d/vcfkVOXKCtIKGN5jkLHvn7PfZtLKSXX3lY6jzuWUFSkm9iftG9xX1HMTpGWlK8tLyzt0UOhQziwmAjTP2B6xTRw2bdjNuvljN4fBMnrJj5wzMu+E+wkLyzjLw9Amz34tsYakxLfr6fej/POVFsaphkMH/kXkG1Yr+ZNeLtEV1VVSJpu/1aVKN7myC3cZ1yVk8vN37rfxNqmvy3njdS6vO5ZicmBRw7qknpsg20a68tnb8g49OtXXJaOYCNA8s9vVNtF8RH1dJtXOwzJGkqfy+vXrLszWsf3B6+qQmCNrPBysFs81r8uYISs2nTE7b76V0QIzq3lXqdu6+21MXuZiM5vaJs/og1LI2CsqvkhNnWmXC/NTre2uQJPNILrmGkZY2bleMtXpt+Ljh/cyB/6Xu4U+Nkb7QAzwh1JQUn6zctP2Y/Rx9dWdXSd5HR2dy1VVVVLQu4bdekKQ5jIjZsaRQw6HrOLN6zNnaDYZOXtk3g6jHQu052k3uMdMN5om77PZN5vaJk+aWiBjr/pSJTXabnTdfTXKbtQVaLKhb65hxE+uP10K7Be44sv7LzJwLEYxkW1B6HBsMq+oqfgUzgMPBWqzj8FygzToXbNFZ8uSmqoaCU7UVVNsmTvjiNuuQ1bW/2XOkP1ajhmZ92vYjgXWPzWsyzXTTJMd4/bNprbJk6YWyNi/VFZJ2Yyrr0ubcaOubDiZagzybyoGR72fLo1YEbji/ecvMnAsRjGRbaE9fva4b3U5TFnxaeCJVGO/2ocCfbMPzIv/95DYvv3bw4qeJiVPL8ohw7WLj2XeDKYuWxUUfRQmKC8PjDhOlhv8YnELJij7R+w6yOwcPRR7voEPdcl81+49yvNLKryZxUEte60JPgUTmaePranrYYS4RH21PH36VLGpbRGkpdD3YlHRVin2uenT4H08PXr6UZig/GvEr1/vsaEWQ2/BBGXrXdYN7rHOPTu/gQ9yyXyHHh3KQypCGtxX1HNTy2bBZqdgaiwmwrK7yzZR57upd3u59M7SzfTbSUpLVsOHxjDBvIe4Rzij47UE+l4sWmoqxdnrG8YdPmf6UZigHDTrW11O0Rp6CyYoR9k3rEulLp3fwAe5ZF6+Y4fyl7EN65J6bmrZ39LsFEyNxUS4EtCwLtXku73MDfi+LqnHh+YaKyurQ4yOB/C8C6WgfiFKUONCEHYRpC9ECVIszUGQvhDV3FiEsp88giAIwhooeQRBEBEGJY8gCCLCoOQRBEFEGJQ8giCICIOSZ8Dpdbp1I8HxOw4EEVWg++RIpxP8DqNVUCd5qOyh8uLht57TPPgdEIKIKnCfeYhbhIfTwvE+QzgC9JFv6mGJmTyCIEIFSK2TvUX42wR8WLLCV8k/LafpKXYQz2jt2Tz8R4P/RiLcIoOWoacnrpfRmrN5aKqBevBxfpPB71haA5jJUwDBw8POzPMkvvkQRID5dDlDT1ZHL6M1Z/PQVAP1oBvf+MOygeQxm0cQ7tOas3mSxfM7DmGHCJ6Vbb/L5Fur6EkWz+84kNZBaxY9p2it2Tw7ggcYNtcQ0UO5NcgeBY/wg9Ymem5k8UT0UG4NsmdX8ADTNnkiPVHO6kHu8IqCR/hFaxA9GVKYW800RHqinNWD3OGVXcEDTX7wSs3qAVEQPsodESSI6Mm8qAif23Knh5rVA6Ig/JbInfB/rqPbK17N8v8AAAAASUVORK5CYII=)\
*Figure 6: labeling of pipe shared between 3 processes*

\

\

??? fifo – A sets up fifo and handle, B opens path to object. Instance
label to ref count without inserting in tree?

\

??? shared single object (inode), starts out a single labeling picks up,
other when passed.

\

Fifo?

\

<span id="Frame16" dir="ltr"
style="float: left; width: 5.3in; height: 3in; border: none; padding: 0in; background: #ffffff">
</span>

![](data:image/png;base64,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)\
*Figure 7: communication between unix file descriptors*

\

\

Figure 7 Show the basics of how communication across a file descriptor
is handled. The descriptor is labeled by default with the Subjects
label. The label on the fd is then used in determining access
restrictions. ??? What of fds that don't have a peer????

Get labeled then passed

\

??? diagrams 2 tasks with 2 comm ends

\

??? 3 tasks with a shared comm end

race to accept

\

???? comm type depends on whether it is path based or label based (or
both)

some forms of communication require label check, some can use path check
– path == allow comm with anyone at this address.

Label check forces a block on the implicit label as any profile doing a
label check must check all new labels being added to the implicit label

\

##### Communication over a bus {.western}

\

???? communication over a bus diagram and discussion

similar to shared comm end, except no race delievery to every entity

\

\

##### Communication across a network {.western}

\

???? communication over network discussion

??? labeling on message vs relabeling at the end point

\

\

That is labeling of each subject is used as an object label in one of
the checks.

\

- using subject and peer label label

- labeling of the socket

- cross check (checking at send and receive)

- using “access path”/”address”

- implicit labeling of the socket

- setting the label

\

\

Communication across on Network

\

comm figure with cloud, and network matching rules.

\

- like communication between subjects

- does cross check based off of label

- we don't have direct access to the peer subject, so where does the
label come from

- across the network (cipso, ipsec, …)

- packet labeling

- specifying the label

- implicit label from remote end rules

\

\

\

------

\

\
\
 {.western}
=

AppArmor policy in relation to other security models {.western style="page-break-before: always"}
====================================================

\

AppArmor is not a type enforcement system though it can enforce as one
depending on how the policy is constructed. To better understand
apparmor policy we can examine how to make apparmor policy behave like
Type Enforcement (TE) or Domain Type Enforcement (DTE) and analyse the
the differences.

\

The basics of TE are that it is an access control model where types are
placed on subjects, and objects. The rules governing access are writen
as a tuple of the subject type, object type, and permissions, which are
stored in a table. Enforcing policy involves looking up the permission
entry in the table using the subject and object type.

\

DTE is a variation of TE where the subject's type is known as the domain
and it contains the table of rules to enforce when a subject is under
that domain. For network communications mediation is performed at both
the send and receive time, so that the sending domain must be able to
write to the receiving domain and the receiving domain must be able to
read from the sending domain.

\

The original DTE prototype[^i^](#sdendnote1sym), stored file typing
information in an external structure instead of on the files. The type
of the file could be set based off of the location of the file in the
filesystem and to avoid directly storing the relationship of every file
and type pattern matching could be used, this was called implicit
typing. However the detail of how the file object type relationship is
stored is mostly irrelavent to the basic DTE model.

\

AppArmor is very similar to an extended DTE model. Its implicit labels
are similar to the implicit typing of the DTE prototype, and for network
(inter process) communication the security check at both send and
receive is also very similar.

\

Diffs

rules that create the implicit label are embedded in the domain, this is
not enough to create a type in the DTE sense.

Apparmor rules specifying labels could be used to create a typing

lazy construction on handles – expensive cross check if it gets large,
but much smaller cross check on expansion.

No revocation of existing handles by default

stacking

cross check – can be more than just at send/receive. (both at
send/receive)

label may be treated as a type but may have to follow other info, like
label at path

all labels have rules – rule is only applied for subject or proxy

handles – we deal with more than just the object we deal with handle
level

derived label – may represent an impossible combination but the implicit
label is dynamic and can reflex actual usage.

\

\

start with apparmor as purely labeled system, no implicit labels? - As
long as labels are set for the types it is a effectively a dte system.

\

AppArmor has several similarities, it places labels on both subjects and
objects, and like DTE types, labels can be implied through a set of
rules. AppArmor profiles are very much like DTEs domains and when on a
subject could even be considered a type. Unlike DTE there is no
difference between apparmors labels on a subject or an object, however
only the subjects rules are applied.

\

AppArmor's labels are not types because it is not required that they be
partitioned fine enough that they can be used independently from the
rules that imply the label. In fact apparmor's implicit labels are only
valid within the context of the rules in the profile.

\

??? implicit labels are dynamic and lazy

\

AppArmor's file rules that the label is also different than DTE rules
that imply type because the rules are in the profile instead of global
set of rules setting the type. This the type information can not be
derived from the rules with out taking all other profiles into account.

### Building types from AppArmor policy {.western}

Ref back to example about building implicit label

\
\

To understand how to derive types from apparmor's rules we will start
with a simple example (Figure 8) with three profiles (A, B, C) that each
contain a set of path based access rules. Each profile has access to a
unique file and some files that are shared.

\

<span id="Frame12" dir="ltr"
style="float: left; width: 4.25in; height: 2in; border: none; padding: 0in; background: #ffffff">
</span>

![](data:image/png;base64,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)\
*Figure 8: List of files accessible from profiles A, B, and C*

\
\

\

The intersection of these profiles is nicely shown with a Venn Diagram.
Each section of the Venn Diagram shows which profiles and their rules
that intersect to create partitions. The set of profiles that creates a
partition is the “derived” label, so for the example as shown in Figure
9 we have the set of derived labels A, B, C, AB, AC, BC, and ABC.

\

<span id="Frame13" dir="ltr"
style="float: left; width: 3.75in; height: 3.51in; border: none; padding: 0in; background: #ffffff">
</span>

![](data:image/png;base64,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)\
*Figure 9: Labels derived from profiles A, B, and C*\

\

\

These derived labels are the base of AppArmor's implicit labels, the
difference being that the implicit label is dynamic and may start out as
the base profile, and tighten as the intersections are discovered.

\

\

???

It is important to note that the derived (or implicit) label is not a
type (in the sense of type enforcement) as by itself it does not have
enough information to determine access permissions. The derived label
however could be further split to arrive at a “type”.

\

To find the “type”, in a system with a single profile it is sufficient
to partition the profile rules into different “types” based on the set
of permissions granted. For rules that overlap and have different
permissions the overlapping rules are split into new rules and assigned
to the appropriate partition. The new rule that represents the
intersection has permissions that are the union of the two rules.

\

A simple example of this partitioning to find the “type” can be seen in
Figure 10. The type name in this case is based off the profile name A,
and the permissions represented by the partition (A\_r, A\_w, A\_k,
A\_rk, A\_wk, A\_rwk). There is no unique partition based on the */abc
rk,* rule because this rule intersects with other rules and the
permissions of those intersections merge resulting in the A\_rwk
partition.

\

The sytem could then be labeled with the partion types using the rules
in the partition. Permission lookups then could be performed by directly
mapping the type to the allowed access permissions for an object without
using the file path and match rule.

\

<span id="Frame14" dir="ltr"
style="float: left; width: 5.75in; height: 3.51in; border: none; padding: 0in; background: #ffffff">
</span>

![](data:image/png;base64,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)\
*Figure 10: Partitioning of a profiles rules for type*\

\

\

This single profile direct mapping of type to access permissions is not
sufficient for systems with more than one profile. The partitioning
needs to be done for every profile, and then the intersection of the
partitions between all profiles. This will arrive at a unique type for
all possible intersections. As shown in Figure 11.

\

<span id="Frame20" dir="ltr"
style="float: left; width: 7.25in; height: 3.51in; border: none; padding: 0in; background: #ffffff">
</span>

![](data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAYsAAAC/CAYAAAAPfPCEAAAACXBIWXMAAA7HAAAOvAH0WY9LAAAstklEQVR4nO2dB1gURxuAT4oUqYq9xwIWooI0jZGmIKKogEZRsWEAowZFI0YlaH7wVyIJFhQ0lkgsiIoVlGYsKChqohEk2AU7VpCi/nz4L+5druzd7d7t7X3v89xzN7NtbsR575vZ2dH68OEDD0HUkQYNGtT++X9ooOxyKBr43rIcx9W6wvqghpayC4AgyoKL/9mpNHwlrz44MXFuNtYnlfrI+pClNvUhDygLBFFxyI2WrCKggqRzk8uhzIaSXA5ZRUAFSedmS33QBcoCQVQMwV+0TApCGsjlECwjk42l4LWYFIQ0kMuhyPpgCpQFgqgAiooe6EKwjHT/ylZU9EAXgmVUxagDZYEgLIZoVKQRxMZ1v3hH/RAWEPZDVMK04NnJzJWOOsKiDlkaSeJYJgSR/Euyd0JYQkBAVECC92xvRutNWNTBdmmgLBCEhcgiCYKk37e6RcXExWxc97MPW2RBhvhO0jSSTEqCIG1rmltIXEjMnp/3+DAtCzLEd2K7NFAWCMIi5JEEcPWvy530GxlUjPbzT9sU94s3pHtY9iqmcmxrI43MH6JWrYtfs8q3tOS+2b0X71xkKQNVqEhDEZIAii8Xd9Iz0Ktw83dLgwgD0p16dZJYb4/vPW4aaBO4Prk02ZvIi5wQuXDhbwsjifSo5qP2xufHTzdrbfZE3LnYLg2UBYKwAHklQbA7cYv7pIDgFPj81cSpRyAdsTxmLdXjjx896JBy/PTMVm3aPpKnHNIgTBqKkgRB6pZUd69gr7p685jqcQTSM2JmSKy3pm2aPjZqbPTy5pWbHTv27Hiz9GZpy4zfM1y+XvH1hiYtmzwtPF9obmxm/EKSKMiwVRooCwRRInRJAqipqdE8lZ1htWjZig2QHjXaL921X6+Ni39cuV5LS+sdlXNE/PfntYoUBRmog1aGDbLq6sSxttHMUowo3tW808zPyLeCBh7Srn6u6dN6TdsYuDJwvaaWpsR66zu47/kL6ResQRanU073h/LnHs21HTJlyNFzR8/Z2bjZ5MlSLrZJA2WBIEqATkkQZKQdth/sMfyMtrZ2DaSNTUxe2zp88Rfkuw31Ok3lHJ27WtyhqzzSAJKA9z3lWSFEnpOTU10e09I4e/isfb/h/c5oaWvV1ZuBicFryy8s/4L8/l79JdYbyGD/2v0jfL712QOycJ/snnr2yFl7kAVIY+KSidvkKR9bpIGyQBAFwoQkCHZt3+Kedjilf2x0pB85v6K8XJeqLAjRKAphkiDYc+RjHkiDSWFAlxM08omRiXz19rb8rS4VWfQa2Oty1MSosLJHZabQ7bRk15KlUy2nbip7WGZ6488bn8F2OspJloYyhIGyQBAFAf/JmZoj8ezpE+OcU9m9C++/8DQwNCwn8l+/eqVv073dLtjeuInZCyauLSsgCmGSEASkwZQwXjx5YXwp+1LvQy8Oeeob6tfXW/mrcv0x7cbsgu0w5iDuHDp6OpUwGL55yebJPfv1vGLazLSsLh2+eXJ3h+5/w3Y6ywzSUIYwUBYIwjBMRhMEe3clurq6e+aQRQFAGvJhO1tuoxUXTYiCEAZ8plMa6Ynprg6eDjlkUQCQhnzYTuU2Whi32Bi2cVpgdOB6SNsOsc3dMG/D1wHLAxLoKisZQhjwWVHSQFkgCIMwGU2QgbueFv8nOk7YttF+k1KXfR8axAZZUI0mhMFEtxR0QQVFBwmtN/dJ7qlxoXFBVGQB4xbx38VPtxtidw7S8B43Ny4IJEJHOYWh6G4plAWCMISiRAEcO30xQNS2AY4u+eK2E9x/+d6Z3lLxI48oyNDZLZVwMUFkvVi5WOWL206m0+edijPfZ9bXXzuLdnfIaSZRVLcUygJBGECRolAF6BIFAZPjGKqIIoSBskAQGlHE+ISswAxtUduYiipkGZ+gClPjGII4aziLrDdFRQ9UYHocA2WBIDTB9miC6W4mQeiOJoShiNtr2SQESTA5joGyQBAaYLsoFA0hisNrk7/8fUnC0HFLAw4PneH9B1PXw24pfpjolkJZIIicoCj4IUcU2YlpNgG/hOw5vHbPQCZlAaAw+KFbGCgLBJEDFAU/ZFHc+rO4lW4jvUrH8W55h9clfwnpDp93KqFyHt9Gzqsm/Tc45WBs0sBnJU+Md7/OmPv0/mOTBQMCQxJuJIcT+8VOjfSbtWlhIpE2/tv0lVO/WmGcQWEAdAoDZYEgCCNkb0+1dZ/+8TEjLv4e5yA9acWM/VSPP38kp8ePmatjzdo0ew7pJq2bPjcwNSq/c/Vmy3Y9OpY+ulXa+NSuDKsJ//n6oGmLJi+L8wvbGjUxfrMpY+8SjDA+QZcwUBYIIiMYVfBDjire1bzT+Cs7v8v42oYc0gPGuF4ItZs2b0Jk4AFNLc33VM43ecWMfYQoCHq59C38K+tCV5BF3qHTlrX/BryLabndnP2HnLuYdq5bL1ebAtgPu6T4oUMYKAsEkQEUBT+Cdz7lp57t3ndov6ta2h8fjd7IxKDCop/lDci38ex/hdI5zdv961HpIIO0+P1fDP3G50TuodM9nSa65+annf0oi2O53XzCJqbR960QMigLBJESFAU/wm6Rzfot1bb2l3/PvSsSXcn5leVvG1KVBSEaMj0G9CpeExDl9+JRmcGN/MK2c7Yt2TrHdur85w/LDG9fudESthP7YnTBj7zRBcoCQaQARcGPMFG8fPKi0dWTlzpve3AoTM9Qv/6JqxWvynUCzceEw3YjM+M3slyvoZ5OdXvLTiW7lm0eYm7f86ZxM9PXHWrTu3/c7N7Vrvtt2E7eH4XBjzzCQFkgCEIrJ3elW1sPcbhKFgUAaciH7fLcRtvLpW/B70s2ek6MCjwA6T6Dba/9tnDDcL9lAYeE7Y/C4EdWYaAsEIQiGFXwI2qGNtz1NDEyKEXYMU7j3XO3LYzzkkcWvV1tCrcvih/WZ7DdNUjD+9YFcV4w+C3qGBQGP7IIA2WBIBRAUfAj7lEeK3MSokUdZ+lkVSRuO0HSm8w5orZBNxR5e2vzdo/E7U+AwuBHWmGgLBBEAigKfhTxzCeEfaAsEARRODBDW9Q2KlGCrGB0wY800QXKAkHEgFEFP3RFFUwKAWEGlAWCIGoFRhf8UI0uUBYIIgKMKvjBsQr1BmWBIIjagdEFP1SiC5QFgggBowp+MKpAUBYIgqglGF3wIym6QFkgiAAYVfCDUQUCoCwQBFFbMLrgR1x0gbJAEBIYVfCjiKgCllv9yS980uq/tkcyeR1EPlAWNEHlPmXYR1HlYQq6Fn9HEILL6XkWvQfZFijr+hhd8CMqutBSl0YOYLKhE3Vuct1VnFX9P0by90FxIHRw8XiuxbBZvieINDwKRNdAr3JiVNCBQVM8c5RZNuQTWuL+wxMNw4cPJSrfyAGKbOiIa3FBEGTI3+fT3wc3pIFdUPwoogvq7Zu3DYvzC9v2HNiniMiDR4HcvFTUesWYxVMVJQuMLvgRFl2I7Ib6uKNiJPHLLxu9w8KiAqKiwhJmz56WzNR1yN9H3sXLxQHn5pokhEF8R65JA1EcV07kd+lsbXFXR1+3CtKwDOvB1UmOr5+91NfQ0OBEjwZXECoLRYoC2Lo1yS0uLirm5583+jApCzLw/ZgUhjpBlgbWJyINl47DeIXNNSK9LzrRdfGh6LiaqmqtcLeQGcosG8LPv2ShaFFcvny1k4GBfoW//+i0X37Z5A3pXr16FEs+Un6YEIa6RBXCgHpUVWFgFxQ/ippbcTk9zzz094gtRHrAV4PO/zh8fqCjn1se09cWBLui+BHsiuKThaJFAWzZsts9OHhS3RKMU6d+dQTSMTERaxV1fYww6OPtuWxHZZcBUS0Eb5edHhuyB17wecpPM/cqp1SIMOploQxR1NTUaGZknLJasWLRBkj7+Y1K79XLdePKlYvXa2lpvVNUOegShjpHFQTw/VG+CMI96mShDFEAhw9n2A8fPviMtrZ2DaRNTIxff/GF7V+Q7+XldlqRZcEIA0EQRDRKnZS3Zcsu95SUtP6RkbF+5Pzy8gpdRcsCoQ9Viy5wvIIfdX4WFI5b8EMet1CaLJ48eWacnZ3T+8WLQk9DQ4NyIv/Vq9f67drZ7ILtZmaNXyiyTPJEF9gFhSAIl9FSVhdUYuJeV09P1xyyKABIQz5sV9RttAiCIKqCs4ZzZub7TGdFX1dpkQXc9RQdvThO2LZJk0anhoYuC0JZSEbfwTmTnNbVaVjV0szsyZB+9me/n+a/1dTI8JWyyqYKYBcUP+rcBUVAd1dU8eXiTuE+4RHbi7aPF7UPCADeCQkUni80Xz9vfSDvA48XGB243ryveaE01ySfb8WUFfOnLJvy6+i2o3fvvrt79K+Lf50y/9f5K6iei+iKUposLl48FiBqm4vLgHxx2xF+ynM+/cqorKrWvl36oEXsjiTfCYuWLjkUu3KeMsuGSAYaaHUUlo++U4wsx6mazPLS8mxs3W1zJe1HiOLIpiMeRReLukQejFwI6fgF8dNBOB5TPY5QvSacixAGiCIuNC4IPsN70E9BQn+kSwKfOssxdBpqV3dt3/busuCAhC5eY3YpuzyIZLgoCioiSD0RI9N8KncJ52abTHJTc2195/gmEWloxPUM9CqCooPiPKd7HhLcX1AKs9fM/kVwn+WTli/IOZjjELoxNHrAyAEnifOOmjlq74H1B4Yfqzw2WFhZ5HkoLMqCY0Bkcffhw+ard+7xsbfscVXZ5UHUB7IgZBUBFSSdmywTZYvj7Zu3utCl1Me5z0UiD371Q+SweMTiZcJkQQWn0U5Z8Fo3d10wIQuga9+u11MrUt3J+0K3E4gpa1eWU+DKwPWbvt809bvN3/1X2muiLDiA4LgF0LpZ08fZCWu+UUZ5EPVAMHpgUhDSQC6HYBSiaHnkZ+ZbWdhYFOjq676FdGJkol/SqiTfl89eGmloaLyX9bzWg6wvwF2bD249aEHOdx3nmi54XmJ8gujmkkUUAMqCA5DHLKprarSK791vvWht/PQfNmyamrB4wXJllg3hFoqKHuhCsIyKjjpgvMLG3ab+OVeJUYl+0cejQ6urqrVDHENkGrMB8jPyreC9RYcWD8j5GpqyC0gSKAuOoa2lVWPRof3ttWGh0X2+8t+q7PIg3ICQhCoIQhzCog4mpQGyiEiOCCfSg8YPOj7fbf4KN3+3NHnOm7kz05kYs5C/lNT4/+M+WmUp6oKIYoAQVVOOMBdBAK5IQhjEd2JSGoK3y4bEhcTACz7PjJ25mryN6vwJUfuQ84k7oeikThZcWQmPDlRdnORuqOEDPw18If8G51jwQ55jwWVJCKIIaUiC7kl2TEzaw24oDkAe4IZuqDbNmz3ydnHMDpsy4TdllgtRPdRJEoIISgOfEfUJmJiHslBxyIPbCCIrEFXAuzpKQpB6aQwMmeHUoFYYH1AYAMoCQdQYQhL3srJCvIfINqOaq9jZ83g//xwT4lArDEiruzRQFgiihpAlIcvx+/f88fnm+MMOk6cPzRnh8+Wf9JZOPEMc5wST0w0bar9rYmb0xta+++3xk91yDQz1K+m8Xs7ZmLo6clDzKANlgSBqBohCVkkQpKfmWXwzx+fE/j0nPle0LICj2avWEZ+rq2o0Hz54Zrh3d3bvyIhtbpHRgQeYuCZIQ52FgbJAEDWCDlHc+KfETFdPp3qQu01BSm2EAenPOrd6QuVYiAqmz/A6vXf3iV5Pn7wwOJL107onj58bzPo6xuf3vRFbiP1W/ifRdd73fulE+qsRSyavSZi726yp8RvBc2o31HrXpl2z51O+9swZ77vUX5YyUPzqai0MlAWN6Nk7qfRttwi3oUMUwPHUXIthI/pfgc9uQ+2uQfrrb0aconr8uTNXO6xaO2tv02YmryFt1tTktaGhfuWtm6WNO3Rs+exB6TOjrPT8rlMDh51p3MSo/Hrh3WbGxo3eChMFAJHFo0dlBvuSTvTu3rPDA2H7SCqDNKirMLS6WjvySl+3xEbu/0B9yAqulPcJFCe7oEsU796917h0oagNNOSQdhpkfT14ysox04KGn9Gk+KiJr2eOPCXYSFvZmN+9eP56W5BFzqm/OjZowPuQd+5aezcPu2vnz11rZ21rcYe8v+C4BQDSiVk3a6+sZZAGQhjwWV2kgZEFgnAYeQeyBcnN+bu9ff8eN7W0NOvEYGCgV9nD8rNSyHf4oudNKudo265ZmWCetY3FnYP7T1mO9B14Oef0lY6DhtgW5J39KAt49/N3yyPvTx6zqKl5p1Fy/4nxrxsOOWzdeNRubtjYDFnKIC3qNvCNskAQjkJXNEEGupxyTl3puHN7ujU5v7KySouqLAjRkLHs3akkOjLR9XnZa72iwrtNF4b7pwVOXvFV2bNX+jdvlDaB7eLO165987LZoaOzp09cPlbWMsiKunRLoSwQhIMwIYoXL97o/nnpn9bJR6IS9PV1qon88vJK7YmjI/xhO4wtyHJuHR3tmo6dWz357dejtt17dHxgYmpQ8VnnVk+3b0616daj/QPYTuU8GpoaMi/uIw/qIAyUBYJwDCZEAWQdv9DVzqHHLbIoAEhDPmyX5zZaaxuLu5vjD9nD+Aekbey63d4Yd6Df5OmeOeKOI3dD9RtgeUPW68sL14WBskAQDsGUKADoggoI8jojbNsgd9uChLiUfvLJwvzOpvUHHUASkO5r1+1O/NqU/rX5dwX3JQ9wQ5cSDFYPcOr9z7iJg8/Len064LIwUBaI2gJPnIXGlStPnpVXFBFpMWvD3UJmwLuw7Ws3hu4WdWxv6y73xG0nIA9MC9KxU6un5O0wCC1sf3HnoIK8x0uCq8JAWSBqS0sDXrayy0AXdEQUPd/3/oeu8qg64d+FzIDnQsl6PNeEAQ9URFkgCEIbwuY/EDD9i55NZQC4JgyUBYKoOEyOU0iLIhtjNpeBgEvCQFkgiArDJlEg3EYuWVz96zJv+gQf3ulLRXSVB0EQiqAoVAOuRBdyyeJERhrPydWdrrIgCEIRFIVqwQVhyCWLrOOpvOnfzKn73NpIgzclcCbvt03rebeeil57hOp+CIIgXELVhSGzLMrfvOFdvnie98XAT0tA9+rTlxfxuELisVT3QxDk32BUobqosjBklsWpE5m83lY2PD19/fq8kaPH8TQ0NCQeS3U/BGGaDx8+NKjlg6pMzGNaFMlHs0K83ZxiRE3MUwfknWMhCVUTBsyxgP8nMssCxiscBcYrNDU1KR1LdT+EGfQdnDPLczKdJe+JsAmMKLiDqgkDkFkW2bWySNieLNfFYfzi/kvanhTMKf4sKu40bmF4xJWk7eMhPTUiKmxvZrZj2Yk0N6rnMB3oljbK2TF7U3hYFHMlRRBEHZBZFoK3y1Jt9FEO1Eg/l2cz2N42l0jvSc9yunN030hpznHzULJ3e49Re1EW4lGFrihFRhXq3BXFdBcUGVWILoguKPis1El5KA7RHMvJtZ011jcJPj8ue24CS1YaGzT61xrE0KVkoK9XETUzKG7qCM9D5G0mhgav4Tg4vqmpyXPytoBlyxccOZXjsC4sNNrLccBJcWWBawT7jtqbsO/A8Bcnjw2m4eshCCXg0R1smpGtzuAMbhbypuKtbn5Boblj3z4XIQ3RwYLJE34Tti+MPVwqLOoy+rvFywRlAXw7bswuOF5wjMLbxSkLXgti1wVLkgVg1a3r9bJvU3FSjRLg6ljFjX9KzH4M3+L2a+LCRGWXRVmoQnRBgLJgIdkX8q2su1kU6Ovq1q06lrd901T3GSExS6ZP3kzeb8WWRL/YHUm+z16+NNLQ0BAapiXsTfGC4wXzXWytL0B4ebv0QQsqZRoz2DVd1DUQRBYu5BW07WtrcUfZ5UCogbJgIelnYbzCpn6B+h6dOt58+uKlkeB+K7cl+h2OjQ6tqq7WHhwcEiPsXHAcHC+Yn5WXbwXv7Vu2eEClTNCdRf0bqB5sHbdQVlShiHGL87kF7Ub5DrxMpKHLSU9Pp3pa8PAzHsMcrhL5P0XtcDl75mqHkPljsphcCU+R4xVk2BpdkMcrAJQFCzl+Ls9mR1REODlPT0en8lFZmWkzU9MyIm+s+6Djw2bPXzF+qFsakUe+LfbhszJTIjoRJCk905kYs5CmbGy57RYaduIz+Q8aUQ3eVlRpFxXcbdbbqss9Ig/GJoqL7ptFfL/JgyyLL516/wOv+HUp/ZW5bKq6g7JgIcTtsmT8PAYfsxg5dsez7E/jBrHzQ2LgBZ9/mjNzteAx3UaN3THe45NICKRt7NkgB3FwVRxcHasALl0sat3Vou0jHd2GNZDeuT3deu/u7N6vXpbraGh8+vcE+vTtevdDbc7DB88MlVNa5mFrdEEGZaEikMUgDnLDThYLXaiSOABp5MHWrihlwWRX1IXcgnawxjaR3pWYbhX1U9CB6uoazfmz144g73vpQlEbeG/eovErustBoKwuKLYi2AUFoCwQpSHYsDN9DVWKOrgcVQAX8grbLl46KZVIOw/qe/370PXDXd1tCgT3PZF5sQsxZqHYUioWtkcXWuXWz3lnNLOVXQ7WAPXBBtRhBrc8jTdV0Uh7DYwu+GEquhC8XXbmHJ8T8ILPQbNG1d/KrYg5FhhV8CMsqgC07l2/xGuip4wisROoDzaAM7hlR5UiCGFwPapARMPm6AK7oVgKkzO4pZ2RzfYZ3HTLAaMLfrj8+A+MKvgRFVUAKAsWoogZ3NLOyGbbDG5Vjx4QRNVAWbAQRczglnZGtrrN4FZWdMHWLiguRhdsjSqU1RUlLqoAUBYsRBEzuKWdkc31Gdxc5+/i4lZfh4dPOrl9e6Syy6KqFBWVtFq4cMukpKSFalmHKAsWoogZ3PLAllncTMOlsYsTeXkWjra2/7otVRq4FF3IElWcO1dgYW9vIVcdshVJUQWAsmAhOIMboZus3FyL6b6+dbemtnV2XjV51KiT2w8c6Hfj2LF5yi6bqnA2p8Bi7NiBJ4h0P4c5q/T1dSq/mTn8wIgRDjlEnq/vgJP79p3p98fJlZyqW5SFisCWGdyC1+A6iowumBqvKH/7tuGfhYVt+/fpU79iWa+uXe/+kJo6X9pzcSG6kCWqqKioalhQcLetdd8u9XV4JmfVnOuF91t/992mqYQsAItube9mf7tC6rolo8hxCypRBYCyQBCOczo/v0svC4u7erq6VUTeCFfXfA0NDcZn0HOFCxeKunSrlYCubsO6Oty6Jd11x45sx5cvy/UFn2U1eLBVvmAeF2CVLJw1nHmZ7zOVXQwE4UPVxy7qxitsbK6R8zTluLNNlaMLWe+AOncWxiu61dfhtm3prr/EBsXVVNdoBQevnUHeV5VuBqEaVQByyaL4cjEv3Cect71ou8h9QAAAIYHC84W89fPW1/4P5PECowN55n3NJV5H8BwIomiYFgaTt8zWysI8PiJiC53nVEVhyHOr7NlzheZRUZO2EGk3977nv529PtBj6Ke7FumG6a4oaUQByCWLvLQ8nq27rcT9iEb+yKYjvKKLRbzIgx/vPItfEF8nHI+pHhKPJ4SBIMpCVSMMwdtl72ZmzqHjvKokDHnnVAjeLjt/vs8eeMHnOXNG7SXyYRxD9lIqDmlFAcgli9zUXJ7vHN/6NDToegZ6vKDoIJ7ndM9/7S8ohdlrZv9rn+WTlvNyDubwQjeG8gaMHECpHD6tfHjx+fG829du8+a6zOX9mPIjr7t9d15A7wBe0v0kKb8VgiBcgq2T75SFLKIAZJbF2zdv67qU+jj3qc+DCAAih8UjFguVBRWcRjvVvdbNXUdZFl2suvBKikt4+1bv441bMI63eclmXmhCaF0+gtCJqkYXTMH26AJFwY+sogBklkV+Zj7PwsaCp6uvW5dOjEzkJa1K4r189pKnoaEh62l51oOs4T8k78EtSktD12FubV5Xntt/3+ZFJEfwsndn15Wlq3VXmcuBIKJAYfDDdmEg9CCzLGC8wsbdpj6dGJXIiz4ezauuquaFOMou8vyM/Lr3Fh1aUD4GIojICZG88d+Ph3UOeB7TPHgbF27k/bj/R5nLgSDiQGHww0ZhYFTBjzxRBSCXLOBXPMGg8YN4893m89z8Ka/NI5TMnZn1YxZUgQiiurKa5z754xy0IZOH1HVFEd1QeEsuwgQoDH7YJAwUBT/yigKQWRaCt8uGxIXUvYCZsTP5tlFtrEXtI+lOqKZtmvKOVR6rT5s2N+Udrzou8XoIgnAPFAU/dIgCYHxSHh2/6OU9B0YVCFPQEV2w9bHksqDs6AJFwQ9dogBYNYMbQVQR7I7iR1nC4KIo5JmYR6coAJQFgtAAk8LYlJz85fKEhKELAgIOT/X2/kPe88FTZ8lp3YYNq5ubmb10trf/e46/f5qJoWG5vNdQtDCEiWLXrj++jIs7PDQoaOjhMWO+lLvehAFPmSWnG+poVzc1M3rZr1/3v6dNc0szNNKXuy5lgW5RACgLBKEJpoSRlJZmExkSsmfjnj0D6ZAFQJ7FXVldrXXvwYPG8UlJjsFLl078feXK9XRcQ1HCEBVRHD2SZzN/ns+eXbtODGRKFgB51nZVVY1Waemzxjt3ZDsuWrRt4i+xgbTUpTQwIQoAZYEgNEK3MGCFu0Z6epW+bm55EGFAununTiVUjoUIIjw4OKVWAgMfPHlifCcjY66w/XS0tWs6tW37KCwg4JDtmDFL6DovwLQwRIkCVrXT09OphGc37d79x5eQ7tKllcR6e/ToucmUyTEhhw5/Wnws4odEv/Af/BKJ9FCPJUu3bJ37U9Omxi8Ej2/YUKumfftmj4KDPQ95eS2VWJcQmcye7ZWyY8eJgY8fvzA+feYnkXVJBaZEAaAsEIRm6BTG7tRU24leXqfh81ceHucg/cOMGfupHn88J6fH/tWrY1s1a/Zc1D4QWZQ8fGiaUBu59O3R4xZd5yVgQhggCXgXNUZx5HCu7Sjv/nX1NmyY3TlIz/52xH5J523WzOS5kZF++Y3i0pafdWpZWlLyrPGxY/lWM74ZdtDMzOjltWt32xobN3ojTBQARBYPH5aZ7tx5YqClZYdbVL7LqVNXe2yInxXbvLnJcyr7CwMkAe9MiQJAWSAIAxDCgM+ySqPm3TsNWIvi+6+/Pgjpka6uFwZPmzZvUWDgAS1NTUqPwY6YMWOfsAZdcNwCaNm06fOUNWti5TmvKAhh1B0rpzQkDWS/e/deI+98URdo4CE92M36wsQJK+fBinZUHh9uZ2demJd3vSvI4uQff1k2aACr5F3r5lkrHXi3E1haVXDcAgDpxCfMolSX34aM3CevKJiUBAHKAkEYgvgPLGuUkXH2bPdB/fpd1dbSegdpYwODCltLyxuQ79a//xUq5+jUrt0jYfnkMYvqmhrNW/fvm0XGx3uu2LRpSMyCBTtkPa84QBjwLk+UQeWOp9On/+4+YECPq1pamnX1ZmioV/F5r89uQP6XX/aUWG92dhYFycmnvhjz1cATf/xxpedQT9vcM2c+yiKnVhZTpvAvVUwes6ipead5794Ts7VrD3lu2HB0yOLFYyXWJXRbSdpHFIoSBYCyQBCGkbVbKik11Tbt9OmeqxMTXcn5FW/fNqQqC0I0kvbp0r79wxWhobud/P0X0HVeUcjaLUX11ljocoJGHlazI+dXvq1qSEUWfaw6FS9dmuhXVvbaAJZS/fE//lvH+62Y/+zZK8N//iltCdtFHQuC6tCh+cOwsNG7x361nFJdElKTFkWKAvi/LJ5y6t5kOZG4zjWCSIu0wnj24kWjnEuXOl87dCjMQF+/ksh/XV6uYzdmTDhsb2xs/IbmMsJDQBWyypu0wqAqiufP3zTKz/+nc3pGVJi+vk59vZWXV+qM8IoIh+0mJo3E1puOjnZ15y6tShLijw6xtOx409TU4HXnzq1KNiakuve0bH8btksqR21VMlqXihYFoMXL5vEcef0uKfKirCZb2QVAuIo0wtiXnm7t4uBwlSwKANKQD9vpuo2W3A3lPmDAX3SckwpUhSHNZLu0tAvW/fv3uEoWBQBpyIftVG6jtbO1KIiLO+Q5c+bwA5B2cOh2bc2aA8PhLidxx5G7oQYOtGSkLpUhCgC7oRBEgVAd+Ia7nhYHBaUI2zba3T13WVyclzyyIA9wQ5cSDFZ7Ojpe+nbChGPijqMbcQPfku54EgZ0Qc2c6SW03oYOtc1dvTrFi5Is7M0L1649OMze4eO62yCL2NgUL1s780LBfckD3NClBIPVLi69L02eMpjWulTEHU/iQFkgiIIhD3yL2ictISFa1LYvrKyKxG0nELV8qrzLqtK1LCsBeeC7LqP3x3xZHt2xdVuoyHrpa9OlSNx2MtDtRB64bt+h2SNhS6bKu4wq1eOVFU2QQVkgiJIgS8N7iFMM0WiqPZeUXQB28K1jSP34qbJFAaAsEETJVJzNctKzd8oCYUCaqjSEzZUgkOfXP1PnFQXxvbOz+R+W5+j4sdvl52x6Hw4obF4EgbyRAh3XIyRB1Af8bdBdJllAWSCIktG1c8yGd6JxIBpJSdJgouFm8ryCiJIEgWB90CUNJoRAx/UEJQGAKNgQVQAoCwRhGYKNJMClLipJkhBEWH3QHW0oE2GSYCNKk4WGRuvM9+/vi18CD0HUGHLjoeriIAQByNooiqoPVRQHeTyC7ZIgkFsWly9f7eTjMz2iqOj0eHH7TZw4Kywp6ZBjRcUNyot06+l9lubr65m9bVtslLzlRBBVRlRDCbBRHmQ5AHQ3iOLqg43yIMsBUBVBkJFbFmlpJ2zc3Z1yJe23a9cBp0eP/hwpzblLSy96N2/eay/KAkE+IWogGFCmOOiIHmRBXH0oUxyqGD2IQ25ZpKZm2c6ZMz2JSEP3koFBo4ro6CVx06ePr5vt+PjxUxNNTc33xsZGfNPsJ036dsHBg8cdNm6Mjh45cshJwXObmBi/huPg+KZNmzyXVBa49syZU/auXv3rqJKSiz7XrhW1d3EZ/VNKyuZF9vbWf/fuPSjh/v18X3m/M4KwCXG/sgWRVSaCkYKkcigTaepDVpkIRgqSysEF5JLFmzfluufPXzZ3dv7iIpEH4xAXL17pMmLE5GWELJo3/3zvokXf/iZ4/OjRw7LgNXduRLAwWQChoYG74Hiq4xt9+/a67uHhfK64+HarWmmMXLDgm9+XLImenJCwMtrKyrJI1u+KIKqApAZKUuMp63nZCtYHfcgli8zMU1Y2Nr0L9PX13kI6MjLWb9WqeN9nz8qMyA/R+vPPjKlOTj4xS5fO20w+ftCgLy/AbWG3bt1rIeoacXFbveB4qmUaN25k+j//3GoFZfv776L2yckbw3fvPui4atUGX2vrz6/L8j0RhCuoYyMnDqwP6sgli4/jFY55RDoqarXf8eM7Q6uqqrUdHb3rw7SePS1uPn1aZiR4fEbGKSt479ChzQNR14Dj4HiqZYJuK4ggJkyYufD772dvh9mx06aNO7JwYdS0/fs3L6L+7RBEcRDPjIIJesouC8IO2DTHApBTFtk2yckJ9WvVjh/vfdzNbdwKf3/fNMF99fR0Kx89emLarJlZGZG3c2eKMzFmQeSRb6l9+PCxKRG1SIO1teX1ysoq7cmTx6RCuvb96JIlKydbWfWs74bCW3cRBEGoI5csBG+XjYtbHgMv+Bwb++Nq8raJE32Pdehgt6O8vNgd0lQa6o4d7XcIE48oiHO2adPqcWXlrcFEfvPmTcuqqm4PonoeRD7Y9osIQRD5UdikPLJIxEGWCCEWJhAmqwYNWsncyGE3AiIv+DeEELDxB5cW8Qf64UMJ/oEiCIIgQsFnQyG0wsZfRAiCyE+dLDC6kK8LikDduxFQFAjCXTCy4NEjCgShA3X/wYGw90dXvSwwuqAH8hrL6vQfnq1/4AiC0ANfZKGOwmAiqhBcY5nL0iBW8UJRIAi3+Vc3lDoJg+nuJ0FpAFwQB3mZR5QE/ah7V5S+g3NmeU6mWk6YZXOELnTMQh2EochxCvJ1yOJQVajU28e/H3b+0SPs48+i4k7jFoZHXEnaLnZdHER5iBzgJve9f0xzQxwgCXhXVkOmLg2ounxPplC36CL9XJ7NYHtbieviIMpD7N1QXPtFDEhqxPAXMYIonmM5ubazxvrWr4sTsGz5giOnchzWhYVGezkOELp8AddgcxcUQPnWWTZ/CTpRl++JsB91iS7eVLzVzS8oNHfs26d+XRxvF6cseC2IXResLrJgOzjPAkEQpZJ9Id/KuptFgb6ubv0Tpl1srevWurld+kDkWjdcgu1RBYCyQBAWow7RRfpZGK+wySPnZeXl1611075lC5Fr3SCKBWWBIIhSOX4uz2ZHVEQ4OS8pPdOZGLNQVrkUhSpEFQDKAkFYDtejC8HbZdV1jgXbQVkgCIIoCVWJKgCUBYKoAFyPLhD2g7JAEARRAqoUVQAoCwRRETC6QJQJygJBEETBqFpUAaAsEESFwOhC9VFFUQAoCwRRMVAYqouqigJAWSAIgigAVRYFgLJAEBUEowvVQtVFAaAsEERFQWEgigRlgSAqDAqD/XAhqgBQFgii4qAw2AtXRAGgLBAEQRiAS6IAUBYIwgEwumAXXBMFgLJAEI6AwmAHXBQFgLJAEA6BwlAuXBUFgLJAEI5BCAM+ozQUA0gC3rkqCgBlgSAchGi0MMpgHi5HE2RQFgjCYdjWLaXv4JxJTuvqNKxqaWb2ZEg/+7PfT/Pfampk+EpZZZMFdREFgLJAEI7DNmGQ19iurKrWvl36oEXsjiTfCYuWLjkUu3KeMssmDeokCgBlgSBqAFvHMXQaald3bd/27rLggIQuXmN2SdofIpP/zg5eB3IpefzE7M2ZDBdFlJOMOoxPCANlgSBqAhvHMSCyuPvwYfPVO/f42Fv2uErlmCOnchyy4lfPbNO82SOmyyeIukUTZFAWCKJmKLtbSnDcAmjdrOnj7IQ131A5fmXIjLUoCsWDskAQNUSZ3VLkMYvqmhqt4nv3Wy9aGz/9hw2bpiYsXrBc0vHm7dvdYbaE/Khrt5MgKAsEUVPI3VLwroxIQ1tLq8aiQ/vba8NCo/t85b+V6jFMlwtASfCDskAQNYcN0oAyaGpovFf0dYWBkhAOygJBkDqUIQ1yN9TwgQNOMn09caAkxIOyQBCED6alQR7ghi4lGKz2dnHMDpsy4Tc6r0MVlAQ1UBYIgghFUBqAvOIgD24r43gyKAnpQFkgCCIWcmNKpziUASEIACUhHSgLBEEoI0ocAB3yEDYHg0CWqIIsBwAFITsoCwRBZEKw4aUj6qCjmwmjB2ZAWSAIQgviog5BZJWJYKQgqRwIfaAsEAShHUkNtiSZyHpeLgJ1xYbv/T/v4v0kb1Oh/wAAAABJRU5ErkJggg==)\
*Figure 11: Types derived from the intersection of 2 profiles*

\

\

For the policy in Figure 11 the ??? no A\_r type in final set of types

\

The basics of splitting rules to achieve a type when regular expressions
are involved is covered in ????.

\

???The derived “type” comes from combining the profile name, rule
segmentation and permission sets. For a system with a single profile,
the “type” would be derived from the different permisions as shown in
???.

\

??? shows two profiles with file accesses and the their permissions for
each profile.

\

??? why we are not using type – HUGE, too brittle for apparmor purposes
(keeps changing), results in really long type names, doesn't mesh with
partial loads, and needs for cross checks.

\

\

After computing the set of derived labels we could then label each file
with a label that would indicate the set of profiles that have access to
it. The set of access permissions could either be found by looking up
the intersection of the set of rules in the profiles, or making a set of
global rules based on the derived type.

\

\

\

\

\

However apparmor does not specify labels on all objects, in many
policies having an explicit label is an exception.

\

\

global policy – single dfa: state provides label

- problematic in dynamic system, changes in namespaces etc (have to
recompile dfa etc)

\

- Solutions, multiple dfas and composition, options

\

- stacking

- interaction of tasks

\

- not type

\

- cross check (because profiles express independently who can
communicate)

communicating domains

\

- live replacement/no revocation

\

\

crypto graphic hash and cipso label

can only be trusted if you trust the network and the machines on the
network

-   

might need to be augmented to provide compound label lookup

on label name

-   

on policy

provides name lookup + check that machines policy is the same.

-   -   

Hrmm tainting for Delegation

- does it only go on the handle, or the inode as well? Should it get
stored

Only on handle

handle shares well, other processes can access the file (files can be
see as ipc)

Does it interfer with sharing of handle

Access rights are of the delegator

Delegator trusts Delegatee

Delegator could potentially pass the delegatee information other ways,
so could bypss a locked down tainting check

If delegatee label shares in cross check

-   -   -   -   -   

On inode

same as on handle but not per instance, could prevent other apps for
accessing the file while the delegatee is using it

no need unless the label participates in a cross check

could auto remove the taint on handle closing (would need independent
ref count)

shutdown

could store taint so it carries over until cleared

-   

this would keep tmp files etc from being shared without explicitly
labeling them

need to think about it more

\

\

\

\

###  {.western}

#### Deriving types from regular expressions in AppArmor's Policy {.western}

The addition of regular expressions to the set of domain rules
complicates the analysis of domain intersection, but does not make it
impossible. To determine the intersection of the domain rules we turn to
analysis using a minimized dfa. The accept states of the dfa will encode
where the domain's state belongs, and from that we can derive the
labeling.

\

We will revisit the above example using regular expressions to specify
the files that each domain can access. Each domain has a single rule
that will match all of the files specified in the previous example and
several more. The domains overlap again but in a more general way
because of the regular expressions.

\

<span id="Frame7" dir="ltr"
style="float: left; width: 4.25in; height: 1.25in; border: none; padding: 0in; background: #ffffff">
</span>

![](data:image/png;base64,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)\
*Illustration 1: regular expressions showing what files a domain can
access*

\

\

The minimized DFA for the regular expression for domain A is shown in
Illustration 2. The domain labeling **A** is encoded on the accept
state. The DFAs generated for the other domains are the same except that
the domain label encoded on the accept state and the character being
matched is substituted.

\

\

<span id="Frame4" dir="ltr"
style="float: left; width: 2.84in; height: 1.01in; border: none; padding: 0in; background: #ffffff">
</span>

![](data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAJsAAAA3CAYAAAAbvzgZAAAACXBIWXMAAA7NAAAOzAF6/dXbAAAFZklEQVR4nO2cQUgVQRjHffboYHbJU3aJ0C4ZEeihg6YPwhcYiHpKwfCBokQHUbQOaR60SDyIJAWmQnbKCAxSBNP3Dh58IOLr4hPz1C0vZQdBX44xNq67szO7M7uzM/ODaHfZmf3+zn++2Z3Zt+FMJpOl0XhB2O8ANOqgzabxDG02jWcoabbs7OwD8P/BwUE2PJZMJos7OztfHt7DhgYHBzuKi4uTtHVo8ChpNgBqkrGxsdjq6urNmZmZe2C/u7v7+dra2o1YLDaGKw8NpyFDWbOhGE01MjLyEN0HpsrNzf0NMl5zc/Mbb6OTB202AkAWA5mvurr6kzabc7TZbOjv738yNDTUvrOzc0EPm+7QZrNhYGDg8fz8/J29vb2z5eXli37HE2S02WxoaGh4V1lZOdfY2DjpdyxBR1mzgSGRZNpidHS0FfwD28PDw4/Q8jzjkxElzcZibkzPr9GjpNk0bIFZPi8v72dXV9eLjo6OQbPztNkQQqHQqVdgwIqCH7EECZjll5eXb1VVVX3WZrMBGM3MWFbHZcPY0Wg1b21tXWlpaXnd19f31OocbbYsvKHAcZkNB01m1Gd13IqampqPPT09z2pra6etzlHebCRGktVwdp0MnoPuW7G+vn4dZzSA8mYjRTbDkWpBTYc7f39//4xdXUqbjdY8QTac2cMPjRY77STzlsqaLaimYQmtfpzhSOYdlTSbNppz3GR3Jc3mhiAPpShu4nf6N1DCbG7vV2QAGoR1fTR/QyXMpjkJq05GazglzGbWq1XKajyhMZwSZtP8x89OpqTZdFZjC2l2C9Pe5AXpzQgabVY3zyJqc9NmtGuepJAYLmx3UWMj/PiVqcCdI1LjmMWCHkPjNtNlPAeW9Xv6I6hthh1GQUBWjYCCnsOr57jF+JAgkzYUkXWZmg1enCRoI7CM054PfoleV1f3IZ1OF9KWtQM1nFttrGNzi59tBrHL+KfMRtoz7AB1OAl+bm6uMhqNzrq9vhksteWfD31lERML/G4zUk6YjVXQECfBz87ORtvb24dYxQARQRuPzzigukAHwGmEHQR3Dk/DHZuNdWM4YXd39xz4mlAkEllgWa8I2gCsP+Ng1GWl0WgyEtPxgPs8G01PWVhYiJSUlKzk5OT84R0XC2i0+fEZBytT2ZmOV3Y7Mhvvnk8aPI/7NVG0sf6MA04XaebCDb9ODGc7z0ZakRcAs01PT9f6HQcPvP6Mgwi3DUaEMhuP6Q5RsPqMA2vMslQmkxWqr6+fAtvv30/dN5aBT9duDEq8XOVFL2B5H0A6+x00bbx0pVKpa0VFRanDOg+3vx1uXkuRlCPRRTMhLFRmc4Ksrw450WWVnRKJRBn4pTqoI5GIl5qZjSS7uV0X99xsvGff/Zzd53ltN3Vvb3+/3NbW+gpsT02dHkZJr+22I3tuNtbDKO4aXhuP5TCKq59G18ZG+urKSrKkoiJyvOKRTm8WFhYWpEnrYDVaBH4YhcgyfBqh0WU2FIJhs7e3t+f27bI42F9aipfF4/FSo9ncPiCQEIaLp7wvdDE3a5FHvbjGCLI2Vrri8URZNHr3C9wvKCjYHB8fb4rFmt7alWWty7PMxnJGWrQsxkobD12TkxON6P6lS/k/JibGH5CUZb2KIM0wqvmHkzkzL4ZQgDabpJAayMtXpY7MxvveBgjy8xVqGbXhdBkX2tFjuOMoPHQdZzYWSxaiIqs2O120BuPNsdl4PS36mdUgsmqj0UU6pEIDc315EsB6yPG7MVBk1cZSF0+jAU49ILAIHqZsERoDRVZtQdFl+jTq5ldIovR4K2TVFgRdllMfZutwdm+GouVEhlSbcVpAdG2it9lfw0jdhTb9btcAAAAASUVORK5CYII=)\
*Illustration 2: /\*\*a\*\* converted into a minimized DFA.*

\

\

To find the policies' implicit labeling, the DFAs for the domains are
merged together into a single DFA. When an accept state is merged with
another state it is given a new label that is the union of the accept
state and the state it is merged with (nonaccept states have a null
labeling). The new DFA is then minimized to ensure the minimum number of
states (a minimum number of states isn't strictly necessary but a
minimum number of accept states is). The result is a DFA as seen in
Illustration 3 with labels that match points of domain intersection
similar to the Venn diagram.

<span id="Frame5" dir="ltr"
style="float: left; width: 3.53in; height: 4.87in; border: none; padding: 0in; background: #ffffff">
</span>

![](data:image/png;base64,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)\
*Illustration 3: Merged DFA showing the implicit labels for the policy
created from domains A, B, and C*

\
\

Like in the Venn diagram example the unique accept state labels comprise
the base set of labels that are enforced by the current policy, and just
like the early example these labels are fragile in that they may change
if any rules in a domain is changed.

The situation however isn't quite this simple. The base set of labels is
really just the set of all possible combinations of domain names. What
is fragile is which of these labels are in use by policy and what a
given label represents. The representation of the label changes as it
represents a specific set of files that are shared by the policies
current domains, at any given time.

### Bringing permissions into the analysis {.western}

Inter domain labeling is not sufficient for analysis, it needs to be
combined with the per domain permissions to arrive at the final label
set. To do the analysis a domain needs a single set of permissions per
label but for any given inter domain label a domain can have may have
more than one rule, with potentially different permissions, that at
least partially maps to it. That is a domains permissions may cause an
inter domain label to be split.

To achieve this instead of labeling accept states with just the domain
or just the permissions each state gets encoded with permission domain
pairs. These pairs are then merged as the label sets just as was done
before. The resultant labeling contains is unique for the set of domains
and permissions.

\

<span id="Frame10" dir="ltr"
style="float: left; width: 4.25in; height: 1.25in; border: none; padding: 0in; background: #ffffff">
</span>

![](data:image/png;base64,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)\
*Illustration 4: Domains from Illustration 1 showing rules with
permissions*

\

\

Reworking the domain example with permissions we can see how ???

\

<span id="Frame11" dir="ltr"
style="float: left; width: 6.09in; height: 1.02in; border: none; padding: 0in; background: #ffffff">
</span>

![](data:image/png;base64,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)\
*Illustration 5: /\*\*a\*\* r, and /\*\*c\*\* mr, rules with accept
state labeled with permission domain pairs*

\

\

\

foo

\

![](data:image/png;base64,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)\

The label can be used directly for analysis or the permissions for each
domain can the be extracted, along with the set of intersecting domains,
and the domain label can be renamed to make it easier to deal with.

\

?????? revisit previous example with permissions, can we get a split
label with it

\
\

?????? NOTE: below needs reworked, moved or deleted ?????

###  {.western}

  -------------- -------
  Rule           Label
  /home/ r,      r
  /dev/null w,   w
  /tmp/ rw,      rw
  -------------- -------

*Table 1: Example domain requiring 3 unique labels*

\
\

####  {.western}

To understand how rule overlaps are calculated when regular expressions
are present in rules, a little formal language and automata theory is
needed. For every regular expressions there is a regular language and a
set of equivalent finite automata. Using automata theory it is possible
to do set operations to determine the intersections of the domain rules.
For the purpose of our analysis we will use a minimized deterministic
finite automata (DFA).

\

The regular expressions in the domain can be converted into a DFA using
the well known steps of first converting to an NFA and then using the
subset construction to generate the DFA. The DFA can then be minimized
and its accept states can be encoded with the permissions (labels) that
a match belongs to. This conversion can be seen in Illustration 6 where
the apparmor rule /\*\*a\*\* r, has been converted into a dfa with its
accept state labeled with the r permissions.

<span id="Frame6" dir="ltr"
style="float: left; width: 2.84in; height: 1.01in; border: none; padding: 0in; background: #ffffff">
</span>

![](data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAJsAAAA3CAYAAAAbvzgZAAAACXBIWXMAAA7OAAAOxwEfnX6+AAAFB0lEQVR4nO2cT0gUURzH3T90sK1Dnqpb0DFEWA/dbKF2DxbmSocQhBa0oDositYh0YMWLXsQwQr2EHVMCezgYmzePLQg4i1ButQl9FBZJLhbL3jyHGfm/fu9+ffeByRnmnnz+zrf93v/ZibZbDZbDAYvSPodgEEfjNkMnmHMZvAMLc0Wj8cb6N9GoxHH++r1enpkZOTpvz5srFQqDafT6TpvGQZ3tDQbgjRJpVIprK2tdSwuLl5F22NjY4/X19fbC4VCxe18bDgDG9qajcRqqtnZ2bvkNjJVKpX6iTLe4ODgC2+jiw7GbAygLIYyX09Pz1tjNnGM2ShMTU09LJfLxZ2dnVOm2ZTDmI3C9PT0g+Xl5ct7e3vHurq6VvyOJ8wYs1Ho7+9/nc1mqwMDAy/9jiXsaGs21CSyTFvMzc3dQT/o95mZmfvk+SrjiyJamg1ibszMr/GjpdkMsOAs39bWtj06OvpkeHi4ZHecMRtBLBY78ggMWlHwI5YwgbP86urqxe7u7nfGbBSQ0eyM5bQ/ipCVjVfz1tbWuaGhoeeTk5OPnI4xZmtxNxTaH2XDORkM72fV3dvbuzA+Pj6Rz+fnnY7R3mwsRoqq4WiVDB9DbjuxsbFxwc1oCO3NxkrYDWfNYKxaWE23v7+foJWltdl4zRN2w2GwcXi0kKazO4dl3lJbs0XBNLKI6McVzno+y7yjlmYzRpODluWc0NJsMoS1KSUzEt6GKpO1LC3MZjdZG0bDhB0tzGY4DGQl48luWpjN2oTgfX7F4yd+6tbCbAa1sGY3Lc0W9qzG298kszr0IIGHpEzgmKDePB5tdroQQdRGi8mq5euP5iXacbI6WbJbEiJwP2uLG3ax2C02I3huSJCnP1BcTlqskMfxLryL4NqMsgbuddAiWAcJUdKGwLGxGs0KPk+mEtEqoa3ZZAKXDRq9id7X1/dmc3PzPO+5NEjDyWqDjk0GnmxGA5WjKmsfMRtU4KJBV6vVbC6XW5K9vh2Q2s6ciH2AiEkWSKNhVBnukNmgAxcJemlpKVcsFstQMWCCoA36Mw5WTagCOGkkKwe0OUncmtIDs6moIbzs7u4eR18TymQyNchyg6ANofozDlaNTgZjMZ6K7KZ8no0n6Fqtluns7PzY2tr6S3VcEPBog/6Mg1sFwmZyMxLLsSKGow4QVNd81qBV9NeCos3rzzjwTH941f8M1AoCMtv8/Hze7zhU4NVnHNz6bU5gw8lWSuqkrkzh0KiY7ggKTp9xECEofVBekl4FDtnhZF2xCJs2lSsxZ0/Ga7du31t4VXl27fP2nyus57FoY53sDlRmEyGqjw6J6KI1he0d6U8T337n7P6PtSmVWRv33GyqZ9/9nN1XeW2Isq/fuPledCQMsVTnudmgm1G38r02HmQz6la2qK5EIiE85QJx30LfjEal2bQioktmVAkxGqWRxMsLqi90OtWyAlUWz4u1YdKmUteX742MSEyQ982zzBbU578gMNrYCH0zajiMSFPqRROKMGaLKKwG8vJRqf9mU923QYL8amaiqs1NF94n89QHPk7JUx9Q62NBJKraaLp4Dab6b3RgNshRB4mfWQ0TVW08unjft1Ch7VCfDbrJ8ftmkERVm4pugiptRwYIEMHjlB2Em0ESVW1QhlOtzXY0KvMWUlBqvBNR1Sb75pgX2hynPvCFWV7kJTufQb0ZJKzarNMCQdcmes/Ic1XyF0ccl2PAecl6AAAAAElFTkSuQmCC)\
*Illustration 6: AppArmor rule /\*\*a\*\* r, as a minimized dfa with the
accept state labeled with the permission granted*

\

\

When rules intersect we need to resolve what permissions will be
assigned to the portion of the rules that overlap. For AppArmor this
usually is done by accumulating permissions as shown in the Venn diagram
in Error: Reference source not found.

<span id="Frame8" dir="ltr"
style="float: left; width: 2.5in; height: 1.75in; border: none; padding: 0in; background: #ffffff">
</span>

![](data:image/png;base64,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)\
*Illustration 7: Permission for intersecting rules /\*\*a\*\* r, and
/\*\*b\*\* w,*

\

\

The overlapping of permissions is handle by the dfa construction where
accept states get labeled with a set of permissions. When two accept
states are merged due to minimization then the new states label is union
of sets of permissions of the merged states. The resultant minimized dfa
(shown in Error: Reference source not found) will contain M accept
states with M unique permission sets (some accept states may have the
same permission set).

\

<span id="Frame9" dir="ltr"
style="float: left; width: 3.87in; height: 2.08in; border: none; padding: 0in; background: #ffffff">
</span>

![](data:image/png;base64,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)\
*Illustration 8: Dfa for combination of AppArmor rules /\*\*a\*\*r, and
/\*\*b\*\* w,*

\
\

\

\

\

\

Resolving dominance for overlapping rules

\

Glossary of Terms {.western style="page-break-before: always"}
=================

**Subject**

An active entity (task/process) or a proxy for a task/process. The
labeling on a subject determines the set of rules being enfoced.

**Proxy**

A task or object that is acting on the behalf of a subject. It uses the
subjects label to determine the set of rules to enforce.

**Object**

A passive entity (a resource, file, record, message, ..) that a subject
interacts with.

**Task**

A kernel level process or thread of execution

**Confinement**

A generic term for the set of restrictions that AppArmor is placing on a
task.

**Confined**

A task is said to be confined if AppArmor is mediating its access to any
objects or resources.

**Unconfined**

A special task state where AppArmor is not mediating its behavior. It is
also a special profile that AppArmor uses to track which tasks are in
the unconfined state.

**Profile**

The profile is a label with rules and is the base unit of task
confinement in AppArmor. Each profile has a unique name, some control
flags, and a white list that defines the sets of rules and relations
that govern what permissions a task will have.

**Profile name**

A unique name that is used to distinguish between profiles. It may also
be used to determine how a profile attaches if an attachment is not
provided.

**Attachment**

Attachment is how a profile specifies which executables it applies to.

**Fully qualified profile name**

The name of a profile including its namespace and all path components
separated by //.

eg. :namespace://parent profile//child//grandchild

**Policy**

The total set of profiles that determines system confinement.

**Subprofile/Child profile**

A sub or child profile is a profile that is declared to exist within
another profile. It acts similar to a namespace for profiles in that
child transition x rules will do attachments against the child profile
set.

**Sibling profile**

A profile that exists at the same level (within the same list), as the
profile in question.

**Hat profile**

A hat profile is a special child profile that has been flagged as being
available to change\_hat operation.

**change\_hat**

A task directed profile change via an api call. It allows temporarily
changing a task's profile to a hat profile, and then return to the
original profile via a random token.

**Domain**

The confinement on a task. In apparmor this is the usually a profile,
but may be a compound label.

**Domain transition**

The process of transition a tasks domain from the current confinement to
a new confinement.

**change\_profile**

A task directed profile change via an api call. This is analogous to
selinux's setcon. In apparmor terms it is not considered as setting the
context as it may or may not operate on the full context (stack of
profiles).

**Label**

A label is the type/mediation information attached to an object, which
is used in determining what permissions a task has when accessing an
object. Each label has a unique name which can used to reference it. In
AppArmor. A label can be anything from an individual unit (explicit
label, profile), or a representation of a set of units like an implicit
label or profile stack.

**Explicit label**

Explicit labels are labels that are defined as part of policy and can be
permanently applied to a system object. As such they can be stored on
disk and remain defined across sessions and machine reboots.

**Implicit label**

Implicit labels are labels that are derived from profile rules for
access paths, and literally represent the set of profiles that have
access to a given object on a given path. The simplest implicit label is
a profile, with more complex implicit labels being the set of profiles
that can access the object.

\

The name of an implicit label is based off of the name of the profiles
it is derived from with the simplest being the profile name. More
complex labels are known as compound labels.

\

Implicit labels can converted into explicit labels by a rule specifying
that the labeling should be stored.

**Simple label**

A label that consists of just a name that is a single term in length.

**Compound label (name)**

Is a combined set of namespaces and labels. Usually just referred to as
a label.

**Term**

A subcomponent (grouping) of a compound label that is used to determine
domain transitions.

**Access path**

The access path is the “name” and information used to access/find an
object, and it used in computing the implicit label for an object. The
access path will vary depending on the type of object an example would
be a file path name.

**Handle**

A handle is an identifier used to reference an object without specifying
an “access path” (eg. file descriptor). Objects referenced by handles
will have a labeling associated with them, and may grant different
access permissions than are available via a lookup of the object done by
access path. This is due to permission changes to a live object are not
generally revoked, and delegation may grant permissions not granted via
access path rules.

**Disconnected paths**

Disconnected paths are paths that can not be resolved to an expected
root for the object type. These can occur in file names when a file
system is lazily unmounted our a mount has been removed from the
namespace, either via chroots, bind mounts, or pivot roots.

**Revalidate/Revalidation**

Revalidation is a permission check that is done against an object after
it has been opened. It is done when an object fails the labeling test,
which forces a path lookup and reevaluation of permissions and
conditionals.

\

If permission access is granted revalidation may update an objects
labeling. If it does, further accesses may be subject to revalidation as
well.

**Revoke/Revocation**

Revocation is the process of revoking access to objects that a task may
have already been granted access to. Revocation will cause further
access to revoked objects to fail with an error. In apparmor revocation
is handled at the profile level, when a profile is revoked all live
objects that have access granted by that profile will possible lose
access pending a revalidation check.

**Taint/tainting**

Tainting is the process of placing a special taint mark on and object.
In apparmor tainting occurs when an object label is extended through
delegation, or revalidation. That is tainting in apparmor is just the
dynamic extension of the label set on an object. Tainting when combined
with rules can be used to dynamically limit what profiles can interact
with the object.

**Taint loss**

Taint loss is the process of losing a taint. In apparmor this may occur
at domain transitions.

**Namespace**

A namespace is a logical separation of names so that a given name can be
used to represent different things in the separate spaces. Linux has
several namespaces (fs, net, pid, ..) and they may affect the mean of
access paths in profiles. In addition AppArmor defines its own policy
namespaces for separating out sets of profiles.

**Policy Namespaces**

A policy namespace contains the set of profiles that is visible and
available to attach to a given task. They allow separating profiles into
separate functional groups that can be managed independently, allowing
for different policy to be applied to different groups within the
system.

**User policy namespaces**

User policy namespaces are a special namespace that allow a user to
define policy for their own tasks. They allow for users to be able to
define and manipulate MAC policy for their own tasks independent of what
system policy defines.

**Profile stack**

A profile stack is the set of profiles (labeling) on a task. The
labeling is distinct from the labeling of an object in that the last
profile added to the stack is tracked as the top of the stack, and
determines the current namespace.

**Stacking**

The processing of adding a new profile and/or namespace to a tasks
current labeling (profile stack).

**Conditional**

A conditional is a rule modifier that modifies the kernel object,
policy, and match; that can be used to dynamically determine
permissions.

**Variable**

Any policy variable whether boolean, single or multi-valued, compile
time or kernel side.

**Static variable (compile time)**

A variable whose value is substituted at policy compile time, and can
not be changed unless policy is recompiled and reloaded.

**dynamic variable (usually a kernel variable)**

Any variable that can have its value altered dynamically after the
policy has been loaded into the kernel.

**Instance variable**

A variable whose values is determined by a particular instance or
instantiation, eg. UID

**System kernel variable**

An instance kernel variable whose value can not be set but is determined
by system values like PID, UID, etc.

**Namespace kernel variable**

A kernel variable that is scoped at the policy namespace level.

**Profile kernel variable**

A kernel variable that is scoped at the profile level.

**Instance kernel variable**

A kernel variable that is scoped at the task/cred level.

**Conditional variable**

A variable that can be used in a conditional expression.

**Matching variable**

A variable that can be used in a pattern match.

**Policy Compilation**

The process of converting text based profiles into the binary state
machines and permissions used to enforce policy.

**Policy Cache**

A cache of precompiled profiles that are used to speed up loading of
policy on boot or policy reloads as long as there are no changes to the
cached profiles. The policy cache is dependent on policy, compiler and
kernel versions.

**Permission Check**

When a task wishes to access an object a permission check is done to
determine whether the task has sufficient permissions under its current
confinement. The permission check is done in multiple steps and can
succeed or fail at any point.

**Delegation**

Delegation is the ability of a task to delegate some of its authority to
another task confined by another profile. This allows a task to
effectively expand the permissions of another task beyond what is
allowed within its statically defined profile.

**Implicit Delegation**

Implicit delegation allows for a basic form of delegation in which a set
of objects can be automatically marked for delegation when accessed
without modifying an application. However it will not work for
applications that pass information via access path.

**Explicit Delegation**

Explicit delegation allows a task to specify which objects it wants pass
to another task, out of the objects it has access to (within the
constraints of the confining policy). This requires a task be modified
to so that it can “identify” the objects that should be passed.

**Explicit Object Delegation**

Explicit object delegation allows a task to specify which open objects
can be passed to another task/inherited.

**Explicit Rule Delegation**

Explicit rule delegation allows a task to indicate an access rule that
can be passed to another task. This allows extending the target policy
so that it can access object that the delegator may not have been able
to access (ie allows passing a path instead of an object).

**Profile instance**

A specific version of a profile, as profile can be changed by profile
replacement, etc.

**Derived profile**

A profile that is derived from a base profile. This is usually used to
refer to profile instances modified by delegation of stacking, but could
also be applied to a modified profile loaded through profile
replacement.

**Context**

A context is the full set of information used to mediate a given object.
The context consists of a label and some other information depending on
the object in consideration, there are different contexts for different
types of objects (task context, file contexts, …). The context is a
kernel based view of mediation, and is only partially exposed in
userspace through the api.

**Security Identifier (secid)**

The secid is a unique number that maps to a label. For explict labels
the secid is a predefined value that is part of the label definition.
For implicit labels the secid is dynamically defined when the label is
encountered for the first time.

\

**Authority**

Authority is the right/privilege to perform a given action. Authority,
permission, and capabilities are often used interchangeably but can have
different meanings depending on the definition that is used. Authority
is often used as permission and capability have multiple definitions.

\

**Permissions**

1.  2.  

\

**Identity**

Who a subject or object is. For apparmor policy the Identity could be
the security label, or an extended Identity that takes into account the
user id as well as the security label.

\

**Capability**

1.  2.  

\

**Ambient Capability**

A capability that is accessible from properties of the global system, it
is not stored or carried on an object. Eg google document urls...

\

**Object Capability**

A capability/access right that is carried on/with an object.

\

\

Extending AppArmor with with Trusted processes

\

- X, Dbus

\

\

\

Extending Dbus to support AppArmor

\

Dbus is a userspace message bus that pretends to be object oriented, but
in reality is just a structured message bus, with the bindings providing
the object orientation.

\

Several fields as part of its addressing

policy in userspace vs kernel

messages go in and out of the kernel

apparmor reletionship diagrams

\

dbus provides the id of the task

- look up the task confinement

- if task goes a way get peer sock labeling (why use task first? Socket
could have tainting on it, maybe we should use only)

- do a permission check

- policy loaded into the kernel

- policy doesn't need to be in kernel but is there to provde a single
point for policy lookup, and support AF\_DBUS (kernel debus) if it
happens

- userspace could send the check to the kernel, or sync against kernel
policy and do check in userspace

- userspace check is more efficient, cache policy decisions in userspace

- matching message contents vs. address probably won't be done in kernel

- do the operation

\

- dbus rules combine path access and label rules

- don't need to test label at other end if only one task can bind to a
give address

- policy can be written as if the address is trusted, or untrusted by
inserting a conditional label rule

\

dbus needs to be setup as a “trusted” app with a profile

- apps are then given permission to talk to dbus in their profile, this
does not grant them privilege to talk over the dbus

- the system bus, and session dbus can use different profiles (names),
with the same basic contents, or the same profile (same profile is
easiest)

- app profiles need dbus rules to indicate who they can talk to, what
interfaces they can use, what interfaces they can bind to

- these rules govern who/what can be comunicated with over the dbus

- policy is not configured as part of the dbus config file, it is
included as part of the profile

- if a patched dbus is not used, dbus policy is ignored

\

- logging done to syslog

\

- delegation and dbus ?

\

\

    A dbus address consists of
    - socket/port that the task communicates with dbus over.   We ignore this in the
      dbus portion of the policy, but it is mediated by the file rules.
    - connection/bus name.  Basically each new connection get a unique name like
       :34-907
      but a connection can acquire (bind) to a well known name (you only do this if
      you are providing a service)
       com.acme.Foo
    - message/operation type.  method_call, signal, aquire, method_return, error
    - object/path.  Yet another name for the "object" being communicated with.  They
      look like file paths.
       /com/acme/foo
    - interface.  An object can support multiple interfaces, and message can specify
      which interface its intended for (this is only needed if two interface overlap).
      They look like connection/bus names
       com.acme.Foo
    - method.  The name of method being called.  They look like
      ListName
    - actual message pay load (we don't do anything with it currently)

    And of course there are multiple buses (system and session).

\

\

\

X mediation

- uses Xace hook infrastructure

- uses labeling of structures based on task confinement

- when a task sets up window structure, Xace grabs labeling of tasks

- when task labeling is unreliable, or unaviable use labeling on object

- use sock getpeersec when necessary

- policy is based on label and capability

- check label is correct

- check that capability (screen grab …) is in label capability

\

- logging done to syslog

- setting window colors via tag that the WM can interpret and assign
color/name info to

- X should have its own loose profile so who can communicate with X
separate from unconfined tasks can be controlled.

- X rules are then used to mediate what can be done in X, and who can be
communicated with over X ipc

\

- delegation and X objects

\

Notes/Outline

\

explicit label

- check label rule

- check path rule if more specific

implicit label

- check label rule

- check path rule if more specific, augment label if access granted

invalid label

- task: try to update, if can't use stale label. For each confined
profile

- subset test: use most recent version (name cmps and rcu off of
replacedby if needed)

invalid profile in label, not yet invalid itself

- trigger subset matching similar to invalid label

delegation in label

- not stored on task context but object context

-

- doesn't actually change label, delegating a static label doesn't
change it, neither should it for implicit

- patch order, don't store perm indexes, just for relookup, storing
indexes is a later patch

\

invalid label with name change

- set flag indicating invalid and needs reordering

revoked label

- set flag indicating some perms have been revoked

\

\

static explicit labels – are just profiles, when encountered they are
looked up and linked to a profile, if no profile is found an auto-remove
profile is created and put in the unconfined state.

- static labels without rules == unconfined

- no special namespace

- any profile name can be written as a static label

\

How does stacking interact with explicit labels?

- can't set unless all profiles in the stack (within a namespace) agree

- can be compound but only if all profiles agree to write a label

- if they don't it would change access perms

- profiles in and of themselves aren't static so how do we mark a label
as static and not a profile?

- can have a single/multiple entry label, pointing to a profile

- explicit labels take precedence

- are the only part of a label considered for label rules, if no static
full implicit is considered

- can still cache profile accesses and delegation

- double walk on explicit label

- check if label is subset, on explicit and the implicit

- if that doesn't pass check label rules

- label without path (so only disconnected) ??? Do we want these

- label at path

- any label, want these as often the rule would be

label=foo rw,

this also lets us short circuit and avoid a path lookup

- need flag to say its an explicit label

- should not be set on the “profile” label so it can be replaced, and
the labels referencing it can still behave

correctly

-

\

- how does explicit label affect attachment?

- specific label overrides

- this affects which labels are checked in task checks

\

- overlapping path perm bit to let label rules know there is a more
specific path rule that overrides, can drop for overlapping reads, but
could provide deny, audit, more specific write

\

\

separate out design consideratio exposition (different choices etc to
different section of document)

\

Multiple documents

Over view document discussion policy, labeling etc

technical documents discussing details

-   -   -   -   

\

Hrmm dealing with which profiles could apply to a file based on
namespacing could be an issue. It will require at least a partially
incremental build

\

\

Hrmm this needs to be presented at different level

- A global overview, profile, namespace, object, task, context, stack,
delegation, permission check

\

A more specific view of the profile and attachment, delegation etc

\

Introduction

unconfined/confined

Profile

- Simple example

globbing/re

attachment

- globbing in profiles

Default profile

labeling

Namespaces

\

\

Policy composition

- stacking

- delegation

- explicit delegation

- implicit

- object /rule

- Interaction of Stacking and Delegation

\

Under the hood – labeling

- explicit labeling

- implicit labeling

- lazy evaluation

- profile not enough, dfa state, permission

- object vs. handle labeling

- namespaces

- stacking

- delegation

- putting it all together

\

Aliasing and Namespaces

\

Misc Discussions, where to put them?

\

Alternative strategies to explicit labeling

\

update profiles with stacking like information, could be single global
list with conditional rules, save off and update at next load. Maybe
write it from an exploring options pov instead of alternative stategies

\

Explicit labeling has its disadvantages in that information must be
stored on disk, which might not always be possible because of the
filesystem or tools in use. There are two strategies that can be used to
avoid the use

of explicit labels.

\

Segregation: force apps to only write to an exclusive location or at
least a location that can be treated the same by implicit labeling.

\

Overlay: create a filesystem overlay that can store an application
writes to a separate location but that appears to the application to
have standard filesystem access. How does this work in with domain
transitions??? Generally you don't want to transition domains unless you
can also transition overlay.

\

\

\

On changing Implicit labels and orthogonality to explicit labeling

\

When an object (file, …) is moved/renamed, given an alias (hard link,
bind mount, ..) this may change the implicit label on the object. This
happens regardless of whether an object is just renamed within a file
system, or the rename is a copy across to different filesystems. The
labeling of a file will be consistent regardless of whether it has been
renamed or the contents have been read, and then written to a new
location.

\

This is in contrast to an explicit labeling system may keep the label on
a file the same for a rename, but if its contents are read and written
to the same location as what the rename would have been a different
label if chosen based of the domain of the task doing the copying.

\

These properties are orthogonal, for implicit labeling to keep the label
in the case of the rename, it needs to recognize a rename is happening,
and modify the policy rules that provide the resultant label. For an
explicit labeling system to ensure that the labeling at the target is
always consistent it needs to have rule to recognize the change and
adjust it.

\

In practice both properties have there uses dependent on the resource
being accessed, and the type of policy being enforced. To achieve this
AppArmor uses a hybrid system with both implicit and explicit labeling,
which is more efficient than updating the policy dynamically. The type
of policy will determine what type of labeling is dominant. While the
AppArmor profile language favors implicit labeling, it would be possible
to use an alternate language and compile it into an apparmor policy
usable by the enforcement engine.

\

\

\

\

Shared write locations when data labeling should be unique

\

Implicit labeling provides a default labeling for all the files in the
system. It works well when the set of files being mediated has known
properties and locations, however it is less effective when a files
labeling needs to be modified in response to an confined applications
actions.

\

For security purposes file labeling may need to be modified beyond the
default labeling when a confined application writes a file to a shared
location. If the location is not shared then no special labeling is
needed because a single profile encompasses all possible interactions,
and if a file is not written/updated by application it can not change
the file in a way that the labeling would need to be changed.

\

To handle the cases where there is a shared location (/tmp, users home)
where the data written by one application but should not be able to be
read/written by another application apparmor uses explicit labeling. An
explicit label is a named label written to disk as part of the file
object (using the security xattr field).

\

An explicit label on a file takes precedence over implicit labels, so
that even if another profile has rules stating it can access a file at
that location it can not unless it can access a file with that label.

\

\

Accessing labeled objects

setting labels

file move/rename – label changes done by kernel (keeping label, adding
label, dropping label, changing label)

\

\

How to provide global rules

- write them in an include.

- need to discuss default profile, with unconfined

- hrmm need a separate doc discussing how to best author policy

\

Docs needed

- policy author guide – guide to writing policy, things to do and watch
for

- core policy reference manual

- apparmor policy internals (this doc)

- techdoc – variables

- techdoc – policy layout

- techdoc – extending apparmor for trusted userspace daemons (dbus,
Xace) mediation

\

\

\

implicit (implied, derived) label – a label that is implicit in the set
of rules, and thus does not need to be written out. It is more dynamic
and changeable than an explicit label.

There are three ways to do implicit labels

- eager static: compute as profiles are loaded.

- Requires updating existing objects

- Requires mass relabel on dir move

- eager dynamic (compromise between eager and lazy): compute complete
label at access

- don't relabel objects on new profile loads

- don't do mass relabel on dir, … moves

- use revalidation

- lazy: compute label as profile accesses object.

- More dynamic can result in partial implicit labels

- use revalidation (relookup path, and find access).

\

This means all objects can be considered labeled, and label rules should
work with them.

- a missing label rule means use the implicit label

\

An implicit label is the intersection of profiles and permissions. We do
not need to store the permissions because they are implicit in the rule.
So only the set of profiles is needed. Permissions can be “cached” to
avoid having to relookup the access path (avoid disconnected paths), but
should not be written to disk.

\

Implicit labels start based on the task “labeling” the handle, and maybe
others from a set of labels the initial lookup is applied against.

\

\

There needs to be an explicit labeling that is equal to the implicit
label.

label=implied

\

There needs to be an explicit labeling that is equal to the task

label=task

label=inherit

label

\

There needs to be a generic label rule that covers implicit and explicit

label=\*\*

\

How do label rules play into matching implicit labels, since implicit
labels maybe stale or partial

\

How does handle labeling differ from object labeling?

- the handle label may be stale this is how we localize stale labels

- the handle provides access to objects that are no longer accessible
via natural lookup unless revocation is used

\

Explicit labels are only created if a special label permission is used.
What should that permission be?

- should be able to specify a label or take that tasks label, use a
variable, ..

\

Information flow and labels?

- write end of a socket “labels” the packet

- read end, uses supplied label, get\_peersec or applies rules to label
a packet

- socket label becomes proxy for task. How does this work for explicit
label?

- get implicit and explit label?

\

Do we ever store permission as part of explict label derived from task
type? No setting a label makes it no longer implicit.

\

The move/rename of a file does not result in loosing access to an object
(there is no revocation of existing handles) but it is sufficient to
stop new lookups. If revocation of object access is needed then profile
revocation needs to be done.

\

<div id="sdfootnote1">

[1](#sdfootnote1anc)See the AppArmor Core Policy Reference Manual

</div>

<div id="sdfootnote2">

[2](#sdfootnote2anc)See the AppArmor Developer Manuals

</div>

<div id="sdfootnote3">

[3](#sdfootnote3anc)The visibility of the parent namespace can leak into
the children via audit logs, etc. If they don't have system namespacing
applied

</div>

<div id="sdendnote1">

[i](#sdendnote1anc)???clean this reference up??? A Domain and Type
Enforcement

UNIX Prototype

Lee Badger

Daniel F. Sterne

David L. Sherman

Kenneth M. Walker

Sheila A. Haghighat

Trusted Information Systems, Inc.

3060 Washington Road

Glenwood, Maryland 21738

</div>
