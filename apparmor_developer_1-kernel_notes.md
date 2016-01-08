\

\

\

\

\

\

\

\

\

AppArmor Developer Documentation

Kernel Notes

\

\

<div id="Table of Contents1" dir="ltr">

<div id="Table of Contents1_Head" dir="ltr">

**Table of Contents**

</div>

[AppArmor Documentation 3](#__RefHeading__6594_510320029)

[Introduction 3](#__RefHeading__4610_1712812544)

[Major versions of AppArmor 4](#__RefHeading__4612_1712812544)

[AppArmor 2.0.x – 2.0.1 (Linux kernels ???)
4](#__RefHeading__4614_1712812544)

[AppArmor 2.1 – 2.3 (Linux kernel 2.6.23+)
5](#__RefHeading__4616_1712812544)

[AppArmor 2.4 – 2.8 (Linux kernels 2.6.31+)
6](#__RefHeading__4618_1712812544)

[AppArmor 3.0 – (Linux kernels 3.??+) 6](#__RefHeading__4620_1712812544)

[Motivation/Use Cases for 3.0 6](#__RefHeading__3682_1933741242)

[Design Requirements 7](#__RefHeading__3684_1933741242)

[Overview of techniques 8](#__RefHeading__4622_1712812544)

[Ref counting 8](#__RefHeading__4624_1712812544)

[Locking 8](#__RefHeading__4626_1712812544)

[3. Policy struct 8](#__RefHeading__4628_1712812544)

[4. Namespaces 9](#__RefHeading__4630_1712812544)

[5. Profiles 9](#__RefHeading__4632_1712812544)

[Names 9](#__RefHeading__6596_510320029)

[struct 9](#__RefHeading__6598_510320029)

[unconfined state 10](#__RefHeading__6600_510320029)

[unconfined profile 10](#__RefHeading__6602_510320029)

[default profile 10](#__RefHeading__6604_510320029)

[Replacement/Loading 11](#__RefHeading__6606_510320029)

[Renaming Replacement 11](#__RefHeading__6608_510320029)

[Revocation (unimplemented) 11](#__RefHeading__6610_510320029)

[Set\_profile (unimplemented) 12](#__RefHeading__6612_510320029)

[6. Replacedby 12](#__RefHeading__4634_1712812544)

[7. Rules 13](#__RefHeading__4636_1712812544)

[8. DFA/HFA 13](#__RefHeading__4638_1712812544)

[9. Labels 13](#__RefHeading__4640_1712812544)

[Label instantiations (not implemented)
17](#__RefHeading__6614_510320029)

[Explicit Labeling (not implemented) 17](#__RefHeading__6616_510320029)

[Label preseeding (not currently implemented)
17](#__RefHeading__6618_510320029)

[10. Secids 18](#__RefHeading__4642_1712812544)

[Tasks 19](#__RefHeading__4644_1712812544)

[task context (stacking) 19](#__RefHeading__4646_1712812544)

[File/inode/socket Labeling 19](#__RefHeading__4648_1712812544)

[DFA – mostly needs to move to another doc
20](#__RefHeading__4650_1712812544)

[Owner conditional profiles and namespaces
20](#__RefHeading__4652_1712812544)

[Setuid/Setguid transitions 21](#__RefHeading__4654_1712812544)

[Interaction of the various components/structs and lifetimes
21](#__RefHeading__4656_1712812544)

[Policy Encoding 26](#__RefHeading__3686_1933741242)

[Encoding of Rule Paths 26](#__RefHeading__3688_1933741242)

[Encoding of Conditionals 26](#__RefHeading__3690_1933741242)

[Encoding of File Rule Paths 26](#__RefHeading__3692_1933741242)

[Encoding of Network Rule Paths 26](#__RefHeading__3694_1933741242)

[Encoding of Mount Rule Paths 26](#__RefHeading__3696_1933741242)

[Encoding of the mount flags 26](#__RefHeading__3698_1933741242)

[Encoding of DBus Rule Paths 26](#__RefHeading__3700_1933741242)

[Encoding of X Window Rule Paths 26](#__RefHeading__3702_1933741242)

[DFA/HFA 26](#__RefHeading__3704_1933741242)

[Format of the DFA/HFA 27](#__RefHeading__3706_1933741242)

[PolicyDB the encoding of policy rules into the HFA
27](#__RefHeading__3708_1933741242)

[Encoding permissions 27](#__RefHeading__3710_1933741242)

[Putting it altogether relationship of Policy and DFA/HFA
27](#__RefHeading__3712_1933741242)

[Steps in generating the DFA/HFA 27](#__RefHeading__3714_1933741242)

</div>

\

AppArmor Documentation {.western}
======================

AppArmor Core Policy Reference Manual

Understanding AppArmor Policy

AppArmor Developer Documentation

-   -   -   -   -   -   

Tech Docs

-   

Introduction {.western}
============

\

This is a collection of overviews notes, and explanations intended to
help developers understand what is happening in the code. Higher level
descriptions of AppArmor policy and use are available in other
documents.

\

\

Temp place for think on this - Okay Conditional types and how they
relate to permission queries

Compile time (none have dynamic effect at run time)

- access path

- profile

- namespace based

- global

\

Run time

- instance

- subject based (task pid, uid, fsuid, gid, …)

- object based (file uid, security label, …)

- policy defined instance (maybe env var that is locked in place)

- parameter based (parameters in access path, not necessarily stored in
subject or object)

- custom defined (external variable)

\

- profile scoped – policy defined var - like compile time variable but
can be replaced at runtime independent of profile – equiv to reloading
profile with different values for the variable. May not ever do, does
not affect permision query as can be resolved at profile level

\

- namespace scoped – like profile scoped, except at namespace level.
Updating would be equiv to replacing all profiles in namespace. Not now.
Does not affect permission query as can be resolved at the profile level

\

- global scoped – like profile scoped, except over total policy.
Updating would be equiv to replacing all profiles in all namespaces. Not
likely to do. Does not affect permission query as can be resolved at the
profile level

\

- access path variables – any of the above type encoded as part of the
access path. Eg. pid in /proc/&lt;pid&gt;/

Resolution depends on the type it is from above.

\

\

Permission Query string

Permission query encoding requires feeding in a string that would be
queried against the rules. When the kernel walks a query it may fill in
certain parameters implicitly based off of subject or object variable
values. Requests from userspace must provide these values instead.

\

How can userspace provide the necessary values, as part of the query.

\

Instantiation of profile?

The profile does not stand alone it is a set of rules and the full set
of permissions granted for an access request may not be known without
full context.

\

To instantiate profiles to provide this means we would need to
instantiate both subject and object profiles but this is not enough as
some permissions may be dependent on both subject and object variables
(note subjects may also be objects in some cases but the set of
variables does not change, a task is still a task even if its the object
of a request). To solve this with instantiation the cross subject,
object instantiations would have to be provided to a query.

\

What of partial instantiation (only instantiating the subject)?

This reduces the set that needs to be instantiated, but the
instantiation must be per thread because of the @{pid} variable. And we
must still provide the object for any query that could be conditional on
the object

\

\

Major versions of AppArmor {.western}
==========================

Architecturally there have been four major revisions since Novell
acquired and released AppArmor to the open source community. The early
versions of AppArmor where only released as part of the Immunix Linux
distro and not fully open sourced.

AppArmor 2.0.x – 2.0.1 (Linux kernels ???) {.western}
==========================================

The apparmor 2.0 release was a minor cleanup and opensourcing of the
Immunix version of AppArmor. It will not be discussed in detail, but a
quick overview follows.

\

While Wirex/Immunix helped to create the Linux Security Module (LSM)
infrastructure, it did not want its security module upstream for fear of
its IP being stolen, and as such the LSM did not contain the hooks
necessary for AppArmor's path based mediation. Instead Immunix used a
minimum set of LSM hooks and patched the kernel to export d\_path and
the locking necessary to do some nasty vfsmount discovery.

\

However the vfsmount was not available in several LSM hooks so, a search
of the namespace was done to find the vfsmount of the dentry. This
wasn't racy due to the ns locking but could not guarantee a single
correct vfsmount. It was a direct result of the above mentioned
decisions about upstreaming.

\

Profiles where loaded into the kernel through an earlier version of the
apparmorfs.

\

Profiles where attached to the task via the tasks security structure as
with other LSMs.

\

Files where not labeled, every access to a file resulted in a new
lookup, and permission check against the profiles access rules.

\

The rules of a profile where stored in a linked list. When a permission
lookup was done, all rules in the list where iterated over and if
conflicting permissions where found the match was aborted early and an
error reported. A successful lookup always had to iterate all rules in
the profile list.

\

There where three types of rules, exact match, tail glob, and pattern.
This was an “optimization” done to avoid invoking the matching engine
for each pathname to be matched. Exact match rules where matched using
strcmp, tail glob rules with strncmp so that only the head of the patch
had to match and pattern rules and to invoke the pattern matching
engine.

\

The pattern matching engine in this version of was based on the pcre
matching engine, though only a limited subset of it actual abilities
where used. The matching engine was invoked for each rule in the text
policy that had a pattern glob in it. There was no rule or permission
combining and it was very inefficient.

\

There was minimal compilation of profiles in this version of AppArmor.
Permissions where converted into an integer mask, rules where copied
directly, unless there was a pattern in which case the pcre engine was
used to compile it and the pcre blob was added to the rule.

AppArmor 2.1 – 2.3 (Linux kernel 2.6.23+) {.western}
=========================================

This revision of the AppArmor code saw two major changes, a full
integration with the LSM and a new matching engine and policy
compilation to go with it.

\

The vfs, and LSM where patched with a large series of patches to pass
the vfsmount through to the various LSM hooks, thus getting rid of the
need for the nasty vfsmount lookup in the 2.0 version. The patches where
rejected multiple times upstream and this approach was eventually
abandoned.

\

The policy matching and compiler saw the other large change. The pcre
engine was replaced by a custom dfa engine and compiler. This was a
simplified version of the current version so just an overview is
provided here.

\

Permissions where still converted into an integer bitmask, but all rules
where compiled into a single dfa. Permission collisions could be
detected at compilation time and matches where now linear to the
pathname (that is only one match needed to be done, and only against the
characters in the looked up path).

\

File caching of profile

\

Encoding of perms

\

AppArmor 2.4 – 2.8 (Linux kernels 2.6.31+) {.western}
==========================================

This version of AppArmor saw a major kernel rework to move the code base
from the vfs patches to supporting creds and the new path\_security
hooks in the LSM.

Path hooks, creds

\

free\_profile, kref\_put

\

DFA

kzalloc

\

Locking

\

access path conditional encoding

\

free\_profile, kref\_put – recursion bug

\

\

AppArmor 3.0 – (Linux kernels 3.??+) {.western}
====================================

AppArmor 3 is a major extension of AppArmor's capability. It is built on
top of the work done for AppArmor 2.4 – 2.8. Many of the basic design
elements are carried forward, just being extended/modified where
necessary.

### Motivation/Use Cases for 3.0 {.western}

1.  

-   -   -   

2.  3.  4.  5.  

-   -   -   -   

6.  

-   -   

7.  8.  

### Design Requirements {.western}

maintain as much backward compatibility as possible, recognizing that
new mediation results in some semantic changes

requires profile name compatibility

general interface compatibility

-   

isolate changes in one namespace from another as much as possible, so
that policy changes in one namespace do not affect other namespaces

-   

improve performance

improve dfa matching speed

reduce name lookups and allocations

cache previous decisions where possible

reduce revalidations/new profile (label) updates on tasks and objects

-   

minimize locking contention

-   

reduce policy size

-   -   -   

extend mediation ability, make it more flexible

-   -   -   

allow for atomic policy (set) replacement

support delegation of authority

support stacking of policy

support profile/policy operation

-   -   

support profile invalidation

support explicit object labeling

improve interface

extend policy to userspace helpers

fix replaced-by chaining resource pinning

fix null profile leak, allow auto cleanup of profiles and namespaces

unified model (paths and explicit labeling)

### Overview of techniques {.western}

-   -   -   -   -   -   

\

### Ref counting {.western}

In several places rcu and refcounting are combined, to provide lockless
lookup of an object but also allow an object to exist beyond the rcu
critical section. To get a refcount on object references that are rcu
based aa\_get\_X\_not0 needs to be used. This will return a null
reference if the object has been put into an rcu callback for cleanup
since the uncounted reference was obtained.

\

This should only be used when an rcu\_read\_lock is not sufficient.

\

### Locking {.western}

Different locking strategies are used for each different list/tree. In
general (except for secids) there is no global lock and locking for
lists and trees are handled at the policy namespace level. Other objects
may have additional locks beyond that.

\

The major locks are the namespace policy mutex locks for loading and
replacing policy (profiles), the namespace based label tree locks, and
the global sid table lock.

\

See the specific sections for more detail.

\

### 3. Policy struct {.western}

-   -   

### 4. Namespaces {.western}

are protected by NS mutex\_lock on each NS (used to be rwlock before
list access went RCU)

NS mutex\_lock protects RCU profile list

namespaces are ref counted

-   

NS names are similar to profile names

-   -   -   

NS name is never shown unless the NS is a child of the current NS

tasks always consider their NS to be the root and can not see NS's above
their NS

there is a true root NS that is setup during apparmor setup

NS has a depth \# that is used in ordering labels

Auto Removal of Namespaces

most namespaces are pinned by a list refcount

-   -   

namespace is as pinned by profile back pointer that is refcounted

\

### 5. Profiles {.western}

##### Names {.western}

// is the hierachy/dir path separator for profile names

profile names can not end in /

hname – hierarchical name. Profile name within a namespace including its
parent.

-   

name/base name – the profiles name without any of its parents

-   

fqname – fully qualified name == namespace name + hname.

-   -   

##### struct {.western}

profile is a ref counted struct, there are cases when being accessed
from an RCU list that a ref count need not be taken but those are
special cases

-   

profile is a label

-   -   -   

profiles are always stored as part of a NS

-   

each profile in the NS has a unique name

children profiles can have the same name as a parent profile, because
the parent is treated as a directory

if a profile exists in a sub-NS its name starts with the NS

-   -   -   

stored in RCU list protected by per NS lock

Each NS has its own list of profiles, and each profile has its own list
for its children

all profiles and children are protected by the same NS lock. This is not
as fined grained as could be but since locking is only used on updates
of the policy it does not need to be.

RCU is used so replacement doesn't block exec, which could cause kernel
dead lock

-   -   

most of the profile is static (RCU requires this), but there are a few
pointers that point to objects that are updated in a RCU fashion
(parent, …), this is required to be able to profile updates

\

\

##### unconfined state {.western}

flag carried on both profile and label

used to short circuit rule evaluation (the label/profile has no rules
and everything is allowed)

is only set on a lable

-   -   

##### unconfined profile {.western}

-   -   -   -   -   

##### default profile {.western}

created as part of namespace

Has name default

Is replaceable (on profile list)

-   

Setup in unconfined state, but replacement does not need to be

##### Replacement/Loading {.western}

profiles are always loaded by their fq name relative to the current
namespace for the task doing the loading

-   -   -   -   -   

profile replacement is two stage.

The new profile is loaded and added to the system

This is done in 3 phases after unpack to support atomic replacement of a
set of profiles (ie. They all successfully load/replace or non of them
do).

Unpack

Lock

check perm/set parent and base information

create files in fs etc (any allocations that could fail)

do actual replacement of profiles

-   

the old profile has its replaced-by updated, then tasks must update
their own confinement information (this is checked on hook entry when
getting the profile/confinement info)

this is necessary because creds make it so that a task is the only
entity that can update the task cred (this avoids the need for any
locking).

this means that old profiles may retain references to the old profile
for a long time

only some hooks actually try to update the cred, other hooks (all that
may be called from atomic context) merely find the replacement profile
and use that without updating the cred (this avoids using GFP\_ATOMIC
and potential failures)

-   

old profiles may also be referenced by file/object labels and so may
exist as long as a file handle is held open

profile replacement does NOT revoke access to objects that has already
been granted.

Profile replacement sets up a new “instance” of a profile

-   

##### Renaming Replacement {.western}

Replacement + a field set in the profile

Merges replaced profile into the renamed profile + replaces the renamed
profile if it exists

Children conflicts

-   

replaceby struct of the renamed profile points to the new profile but
the replacedby struct is not shared

\

##### Revocation (unimplemented) {.western}

profile revocation is handled basically the same as profile replacement

-   -   -   -   -   

\

##### Set\_profile (unimplemented) {.western}

Two possible implementations

via replacement

-   -   -   

Task field

-   -   -   

### 6. Replacedby {.western}

The replacedby struct is how profiles and labels find replacement
versions of themselvesitself.

It makes finding a replacement constant time

does not have the memory problems of replacement chaining

All versions of a profile/label with active references share the same
replacedby struct

replacedby is owned by the profile/label it points to

-   

replacedby holds a refcount to the profile/label that owns it, only when
it is refcounted itself

the owning profile/label never refcounts the replacedby struct but does
point to it

once the profile/label goes live is pointer to replacedby is never
changed

when replacedby is updated the profile/label will gain a ref count to
the replacedby that it no longer owns.

-   

The replacedby struct is used instead of directly linking to the
replacement profile to avoid profile chaining

profile chaining was used in v2 apparmor

with direct references an old version of a profile that still had a
valid reference could result in multiple profile versions being held in
memory (a chain from oldest to newest)

profile chains would get long enough to consume significant amounts of
memory (1000+ long was possible)

long profile chains slowed down finding the newest version

profile chains required special handling when freeing a profile, because
freeing a profile would result in the replacement profiles reference
being put, which could in turn cause that profile to be freed

-   -   

Profile lookup was NOT used when getting rid of direct replacement
profile referencing (and hence replacement chaining) because profile
lookup could not correctly handle renaming replacement, and removal
(which is usually a special case of rename)

renaming replacement would result in a profile of a different name being
inserted. This means the profile needed to know the new name to do a
lookup

multiple renaming replacements would remove the intermediate replacement
profile from the list so an old but valid reference could not find the
new replacement unless

each profile in the replacement chain would need to know the current
profile name. Either:

need a shared rename struct to get the newest name

each version of a profile still in memory would need a replacement name
that would get updated by replacement.

This means updating multiple profiles on renaming replacement

-   

tracking the set of previous profiles that need updating

currently there is a form of replacement chaining that is possible when
renaming-replacement is used.

If renaming is used to rename an a profile to the name of an existing
profile. This results in the two profiles being merged under the new
name.

This means there are two separate replacedby structs

-   -   

the renamed profile replacedby struct is pointed to the profile with the
new name

the existing profiles replacedby struct is updated to the new profile

If the new profile is replaced, then its a two step chain to update old
profiles that where renamed.

-   -   

If multiple renaming-replacements are done merging profiles into
existing profiles a form of chaining occurs that can hold multiple
profiles in memory

-   -   -   

\

\

\

### 7. Rules {.western}

The rules being split from the profile is not implemented at this time

\

### 8. DFA/HFA {.western}

???

### 9. Labels {.western}

Locking pattern

\

Lock Read path

seqcount\_begin {

.. do work

} if (seqcount\_retry()) {

read\_lock {

.. do work

} read\_unlock

}

\

Lock Write path

write\_lock {

write\_seqcount\_begin {

.. do work

} write\_seqcount\_end

} write\_unlock

\

Quick overview of rcu

lockless readers

readers must be able to handle “stale” data

no in place updates, must copy struct and update pointer to new copy

-   

pointer and data referenced is only good while in rcu\_reader “lock” as
the locks guarentee the quiescent period

writer always need proper exclusion lock

\

Quick overview of seqlocks, seqcounts,

seq locks are a lockless reader that prioritizes writes

writers can live lock readers (cause them to spin forever)

seqlocks are seqcounts with a spinlock embedded

writer always takes a real lock, which increments the count as well

-   

seqlocks can NOT normally be used with pointers, because of the lockless
nature, the pointer may change and the object it points to go away

-   

seqlocks and seqcounts read pattern is usually

do {

seqlock\_begin

…

} while (seqlock\_retry);

\

-   

\

Labels provide the base mediation struct referenced by all subjects, and
objects

labels are dynamic and derived from profiles

-   -   

labels need a text form compatible with profile format, so they can be
reported on tasks via getprocattr

-   -   

labels need a canonical form

so that they can be efficiently compared

so that label read from userspace can be easily converted to to internal
form

sort labels via profile's namespace level, namespace name, profile name

namespaces are always hierarchical,

-   

groups profiles in the same namespace

groups namespaces

Note while namespaces must be hierarchical, labels do not need to be as
objects can be shared across multiple namespaces. Eg parent shares file
instance with separate tasks each in different children namespaces

-   -   

the root ns name can be excluded from the text label

-   -   

eg. label
/root/profile//&:subns://profile2//hat//&:subns://profile3//&:subns2://profile4

labels are stored in per namespace trees. This prevents a child
namespace from blocking its parent or siblings

most objects hold valid ref counts to labels

labels where kept stable to minimize need for tree access, but
invalidation does mean any path may do lookup

label lookups are primarily done by inserting new labels in tree via

-   -   -   

merge is optimized to do a read path lookup before falling back to a
write path lookup and insertion

locking

label access from a valid refcount is comple lockless – no tree lookup
required (labels are not updated except to set invalid flag)

-   

the locking of labels is complicated because of how import fast read and
new label insertion (progress) are.

labels are refcounted because they must exist long term

refcount when obtained from refcounted pointer can use regular kref\_get
style refcount

refcount when obtained from lookup can not as, the tree does not
refcount its objects

this is so that labels will auto delete from the tree on their last put

(not currently implemented) labels may be preseeded to the tree without
a reference count, even from code or object. When this is done the
refcount is -1 and the special get routine increments by 2 and then
conditionally decs based on the original value == -1. This skips 0,
which is not allowed by the conditional inc of the special get.

the rcu based pointer reference is incremented only if the count is not
0

-   -   

labels are stored in an rb\_tree for fast lookup, using the canonical
ordering of the label

-   -   

label updates come in three forms

insert new labels because of policy

inserting new labels into the tree from merges (this can happen on fd,
inode etc access)

-   

Insert new labels because of invalidation/removal/renaming replaced-by

-   -   -   -   

the label rb\_tree is protected by a seqcount, rcu, and rwlocks to get
mostly lockless lookups

seqcounts used instead of seq\_locks as we already have an rwlock so we
don't need the spinlock in the seq\_lock

rb\_trees can not be lockless based on rcu due to the type of update
needed for rebalancing

rb\_trees can not be lockless based on seqlocks/seqcounts due to use of
pointers, as the object could disappear after dereferencing it.

rb\_trees can be lockless based on a combination of seqlocks/seqcounts
and rcu where rcu protects the read path object from disappearing and
seqlocks/seqcounts handle the lockless state for the rb\_tree update

A combination of seqcount + rwlock was choosen to prioritize readers but
also allow writers to progress consistently. Readers get batched into a
group and then a single writer gets to execute while the next reader
group is batched. Readers can not starve writers and writers can not
starve readers.

-   -   -   -   -   

A spinlock could be used in place of the rwlock, this would serialize
both readers and writers. This might be faster for a low number of cpus
as only a couple threads could queue spinning anyways. But when you get
two or three readers queuing up to wait, the rwlock overhead is not
really anymore costly than spinning and then multiple readers can
progress at once. Note: overall the extra cost of rwlock is amortized on
the read path as most reads should be using the lockless path.

raw\_seqcounts are used to avoid spinning on seqlock entry, if we are
going to spin anywhere it might as well be the spin/rwlock. Though it
doesn't really make much of a difference which is spin on.

\

##### Label instantiations (not implemented) {.western}

allows a label to act as another label/profile

allows the instantiated label to have a different name

allows the label/profile to have its own name

allows the instantiated label to have its own flags

-   

##### Explicit Labeling (not implemented) {.western}

stores a label on a persistent object

name is same as any valid label name

when an explicit label is encountered it is looked up in system loaded
policy

if not found it is created

-   -   -   

Else if found

-   

##### Label preseeding (not currently implemented) {.western}

profile renaming-replacement, invalidation, removal can preseed the
label tree with the labels needed by label lookups to update the
invalidated labels

-   

preseeded labels have a reference count of -1

-   

invalidated labels that are being freed (refcount is 0) are responsible
for checking tree for preseeds that are unused.

That is the free computes what the set of labels that it would be valid
replacements

looks them up in the tree

and if they have a preseed refcount of -1 “put” them so they can be
cleaned up

-   -   

\

### 10. Secids {.western}

Sids need to be a global value

sids are not and should not be exposed to userspace.

sids do not have proper lifetime management

sids use a tiered table much like a page table with upper bits being
indexes into the root table, and lower bits indexing subtables

sub sid tables are an array of label pointers index by the sid \#
(properly masked)

each new label gets a unique sid

when a label is allocated it is given a sid but the sid does NOT
backreference to the label

NULL is the default value for an allocated sid entry

the sid table only gains a reference to its label when it is actually
used (get\_sid?). This prevents sids from pinning labels if the sid is
not used.

If a sid is used it gets a refer count to the label, and the label is
pinned

there needs to be more work into recycling and using pinned sids/labels,
but lifetime management issues of sids make this difficult, and it will
never be perfect

removal, revocation etc could update the sid with a new value to unpin
the label

-   -   -   

if a sid is freed it, it is added to the list of sids that are free.

-   

sid table is protected by a simple spinlock,

read access is an “rcu” dereference

sid if outstanding should always map to a valid label, or NULL

free list sids should not be index by any sid → label routine as all
sids that where gotten are not freed (at this time anyway)

-   

\

\

### Tasks {.western}

-   -   -   -   

\

### task context (stacking) {.western}

The task context stores information needed for domain changes

task labels should be strictly namespace hierarchical

only the current label is used for mediation

-   -   

onexec label is used to store delayed change\_profile and stack requests

-   -   

previous and token used by change\_hat

setuid

-   

domain transitions cause the task context to be clear

\

### File/inode/socket Labeling {.western}

We label file object instead of inodes becomes profile replacement,
mounts, unmounts, dir moves can cause pass permission changes in our
model

-   -   

We label inodes for explicit labels because these don't have the
consistency problems of implicit label permissions, it also lets us
track the explicit label better

We label inodes for network operation because the sock uses the inode,
and network inodes don't have the mass relabel problem that files have

We need to update file labels for taint when a task has access added

-   -   -   

file label needs to carry permissions and delegation

delegation set when file open is tracked?, so it doesn't have to be
looked up again

what if profile is added after file is opened – argument for lookup

what if file doesn't have name to relookup – argument for when
opened/set and against lookup

set full delegation set, or only add as new domains encountered

learning is as new domains are encountered

-   -   -   

how to track delegation?

-   -   -   

hrmmm can a task that has been delegated to also delegate

that is A delegates to B, but B has permission for file and it self has
a delegation

probably shouldn't carry delegation for B

-   -   -   

incremental additions to label would cause new lookups

add all delegations to label means we don't have to track a separate
list

-   

\

### DFA – mostly needs to move to another doc {.western}

is stored in a different format that it is used in. It is remapped at
load time to get an optimal alignment for the processor in use.

Used to have permissions directly encoded via two 32 bit accept tables,
has been moved to a single 16 bit accept index table

the accept index table indexes into accept tables that are per type, not
per profile (though it might be stored per profile, with types in
different segments)

the dfa can be shared between profiles

-   

pre dfa - tree optimization

-   

dfa creation

-   -   

Improvements to comb compression?

\

\

### Owner conditional profiles and namespaces {.western}

?????

### Setuid/Setguid transitions {.western}

?????

need to store off old label (much like change\_hat)

need to remove conditional profiles from new label

\

Others todo ????

access path vs object conditional encoding

\

todo

Labeling

\

Oh! Revoke on rename???? Could revoke/remove labels from an object on
rename, unlink

\

### Interaction of the various components/structs and lifetimes {.western}

\

The interaction of the various components is fairly straight forward and
a course overview is shown in ???.

\

There are a few important things to note

Replacedby

-   -   

Profiles:

profile reference obtained from walking the profile list must use the
guarded (not0) version of aa\_get\_profile. This is because the writer
can remove the profile and put the last reference between obtaining the
profile reference and incrementing the count on the reference (see
general pattern of rcu lookups and refcounting).

profiles on the profile list may or may not have a list reference count.
If the list does not have a reference on the profile it will be removed
when the last reference is put (this is used to auto cleanup null
profiles). Again the guarded version of get reference prevent obtaining
a bad profile pointer in this case.

profiles share a replacedby struct, that handles forwarding to the most
recent replacement.

-   

profiles contain a back pointer to a single label that represents it.
This pointer is refcounted (pinning the label in memory) as long as the
profile is on the profile list. When the profile is removed from the
list this reference is put to break the label → profile, profile → label
cycle. This means the label will stay valid as long as the profile is on
the list.

-   

When the a label puts its last reference it will update the back
reference in the profile setting it to NULL.

-   -   -   

A profiles reference to its rules can be replaced-by rcu so the rules
must be used within an rcu critical section or get\_guarded must be used
to get a rules reference count

Labels

labels hold references to their list of profiles and those references
are not updated for the life of the label. When this reference is put it
will NULL out the back reference in to the label in the profile.

Labels don't have a reference from their tree so that they can be auto
removed when no longer referenced, this means get\_guarded must be used
on the reference obtain from a lockless lookup (see labels section for
more)

labels when created allocate a sid \#, this sid is valid for the life of
the label

when a label is destroyed it frees its sid

-   

Sids

-   -   

\

<span id="Frame1" dir="ltr"
style="float: left; width: 7.5in; height: 8.61in; border: none; padding: 0in; background: #ffffff">
</span>

![](data:image/png;base64,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)\
*Drawing 1: Interaction of major structs/components*

\

\

\

Replacement

\

<span id="Frame2" dir="ltr"
style="float: left; width: 6.7in; height: 8in; border: none; padding: 0in; background: #ffffff">
</span>

![](data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAW0AAAGzCAYAAADkNUZ9AAAACXBIWXMAAA7HAAAOwAF307mxAAA47ElEQVR4nO3dCVxUhdoG8BdEc8E9zExzNxfM1Oyalpq5RAKKIuKSkgubK+CKgeCCpmgKmbJYauk1zJXSzKtRaZkLqKmlN0yyxTJRr/pZiM4377EzHcYZmIFZzvL872/unDlz1ol55vU958y4EZGOHEin07k4cn0AAGrixv+ny8z0ccTKXHx8Mh2xHgAAtXJz9gYAAIDlENoAAAqC0AYAUBCENgCAgiC0AQAUBKENAKAgCG0AAAVBaAMAKAhCGwBAQRDaAAAKgtAGAFAQhDYAgIIgtAEAFAShDQCgIAhtAAAFQWgDACgIQhsAQEEQ2gAACoLQBgBQEIQ2AICCILQBABQEoQ0AoCAIbQAABUFoAwAoCEIbAEBBENoAAAri8NB22eai43udn87F0esGAFA6h4e2GNYc3ghuAADrOK09woGNqhsAwDpO7Wmj6gYAsI4sDkSKVTeCGwCgeLIIbYZ2CQBAyWQT2gztEgCA4skqtEWougEATJNlaDNU3QAAD5JtaItQdQMA/EP2oc1QdQMA3KeI0JZCcAOAlikqtKUVt/QxAIBWKCq0RWiXAIBWKTK0RThICQBao+jQZqi6AUBLFB/aInx/CQBogWpCm6FdAgBqp6rQZmiXAICaqS60Rai6AUCNVBvaDFU3AKiNqkNbhKobANRCE6HNUHUDgBpoJrRFODUQAJRMc6HN0C4BAKXSZGgztEsAQIk0G9oiVN0AoCSaD22Gr3wFAKVAaEugZQIAcofQNgPBDQByhNA2ARU3AMgVQrsYOEgJAHKD0C4Bqm4AkBOEtoVQdQOAHCC0rYBTAwHA2RDapSCtugEAHAmhXUpolwCAMyC0ywAHKQHA0RDaNoCqGwAcBaFtIzhICQCOgNC2MbRMAMCerA7tD48c6RS1Zs2Y3EuX6hZu3z7A1dd3572dO33tsXFKhl/IAQB7sDq0xyYnT9wdFxf3dETEG/fu3XPVu2ePDVMDBDcA2JrVoV21UqXbl65erenq4qLbfexYx9YNGly0x4apBQ5SAoAtWR3aa6dMWT5h9erQ8m5uhTEbNgxfM2lSkj02TE1wkBIAbMXq0O7aqtW3OStWTLbHxqgdDlICQFlZHdrGBx5xINJ6aJkAQGlZHdoV3NwKCwoL3cR7t3Ll7tpjw9QO318CAKVhdWh3aNo0d/Xu3V7j+vbdk7ZnT19+bI8N0wJU3ABgLatDO23ixOTRK1ZMnrVu3ai2jRpdSNc/tseGaQX63ABgDatDu83jj//49dKlUfbYGC1D1Q0AlsBl7DKCUwMBoCRWh3bqxx+/tCAjI+Dn/PxafEUkj8PZI7aFlgkAmGN1aE99551XP1u4cFbHKVOWZyUkRH/w5Zdd7LFhgMvgAeBBVof2zdu3K7Vv0uR8rapVb1QoX/7Oun37XkwKDk61x8YBghsAirI6tMVWSGT//jt6x8TMG9GjR5bNtwqKwEFKABCV+kBkdEBABt9suTFgHg5SAgCzOrS3ffXVs9Hr14+88PvvdRrVqfN7wsiR6/2effYre2wcPAgHKQG0rVTfp/1uZOSyXk89dXz/iRPthi9dGoXQdjy0TAC0yerQ9nnmmcN872L0GBwPVTeA9lgd2uv37+/JN+NxfI/ztZ0HwQ2gDaU+ewTkAwcpAbSj1GeP5N+4UXX/yZNPvtiu3Yma7u43bblRUDpolwCoX6l+BOHujh39+82dG1vO1fVeUmamz+eLFs20x8ZB6eAgJYB6WR3aD1er9r/3srJ68PDnCxfOchswYLutNwrKDlU3gDpZHdpT9JU2/7Dv6vHjV7rqK217bBTYDqpuAHWxOrSNr4TEgUn5E4MbVTeA8uH7tDUC7RIAdbA6tD88cqRT1Jo1Y3IvXapbuH37APwau7KgXQKgbKW6jH13XFzc0xERb/CPIKCvrTyougGUy+rQrlqp0u1LV6/WdHVx0e0+dqxj6wYNLtpjw8D+UHUDKI/Vob12ypTlfPZIeTe3wpgNG4avmTQpyR4bBo6BqhtAWawO7a6tWn2bs2LFZHtsDDgPfiEHQBlw9ggYoF0CIH9Wh/bSbdv8Fm/dOvDy9evVxXE4e0Q90C4BkDerQzt+06bALxYtmtmuceMf7LFBIA+ougHkyerQ9u/S5cuf/vjjYYS2+qHqBpAfq0O7fdOmuQMWLJh99949V3Ec2iPqhqobQD6sDu2Za9cGHX3jjQhU2tqC7y8BkAerQzuoV6//oD2iTWiXADif1aG9ateul/kmHYf2iLagXQLgPPiNSCgVVN0AzmF1aKd+/PFLCzIyAn7Oz6917++DkQhy7ULVDeBYVof21HfeefWzhQtndZwyZXlWQkL0B19+2cUeGwbKgV+DB3Acq0P75u3bldo3aXK+VtWqNyqUL39n3b59LyYFB6faY+NAWaRVNwDYR6l72pH9++/oHRMzb0SPHlk23ypQLLRLAOyr1F8YZfxbkQAiHKQEsB98yx/YDapuANuzOLT5tyDNPYezR8AcHKQEsC2LQ1sazNdu3aoyb9OmwD05Oe3nBAZuss+mgZqgZQJgG1a1R+4UFrq9+dFH/fhc7Qne3h8eX7Fislu5cnfttXGgPviFHICysTi0Nx848Nz8jIyAAZ07HzqybFmke6VKt+25YaBeCG6A0rM4tIcsXjyd77+5cKERt0akz6GnDdbCQUqA0ilVTxvAFtDnBrAeTvkDp0PVDWA5hDbIAk4NBLAMQhtkBS0TgOIhtEG2ENwAD0Jogyyh4gYwDaENsoaDlABFIbRB9nCQEuAfCG1QDLRMABDaoEBomYCWIbRBkfDTZqBVCG1QLFTcoEUIbVA0HKQErUFogyrgICVoBUIbVAUtE1A71Ya2i4t6DlLpdKUPH7W8Dta8Bqi6Qc1UG9qs49FgZ2+CxY49nWpye3l8WSnldbDHa4DgBrVRdWiDtqHiBjVCaBcju1MadTgyzubTKo3SXwf0uUFNNBfaDg0VfUyc8tskDHpuDyxhYsfS2uuAUwNBLTQX2o506+Rv5N6uLh9Fo1snfqMq7R5x9iY5hZxeB7RMQOkQ2n/jytO1cnmqP/lf9PDAVobxF+Ky6PoXP1LD17pRjRcaCaHD4+7+3x1hXPXnHze7zKv7f6CHB7QUwurqpz8oIrS18jqgZQJKhdD+G7cKbp+9Qt9H7SkSVrV6NxVuF9/4SgirHxcfpAbTulD52pXpfPS+YsPqz/NXyT2iszB8ae1xe++CTWjpdcD3l4ASIbT1Lr2dQ79t/IbuXv+LyLVo0VX1X48JPdmCX28Kj//Mu0bfR+4huqfjk6DNLvP/vvuD/nfoJ6FyFXEYVnqitn12wga0+Dqg4galQWjT/eqv+cp+pLtzl86FfFjkuRuHfxbuKzzqLtxXbFSD6oU+TdW7NHgg2KSufXqBmrzei2r0bHz/8f4fhDaBXMLKFK2+DjhICUqiydCWVn3cDqjl1Zz+O3EX1e7X4oFp8z/JNfRyWcNZz9OFeZ9RbtQnQpVp7gwMDqfaPv8sr1KL2vTL6qNUL+xpG+9N6eF1KAoHKUEJNBfapsLl8VnPCTfGfdripq3cxoNab/IvcbmtNw8u8vih+tWodUbRcc6E18E8tExAzjQX2gCWQNUNcoXQBiiGWHUjuEEuENoWKukKQjlevm0PWnwd0C4BOVF1aNsrQGyxXPEgoCMCDq9D2aFdAnKh6tC2F1sEDC9DevaGEmnxdUDVDc6mmdDmYPAY3JqufHiO6o5oR79lnKI2HwSQW42KVHjtTzrtn0GeW4dQuWoPGaY3dTm3+ByHDZ+DnDf/c6rRraEzdqlU8DqUHapucCbNhDar1qUBPdy/JZ0b/xHVfLEJXd58hh4d14EuZ5wWHotBxcxdzi3188rD1HjuC8Iwh6DIXOUolxYAXgfbQNUNzqCp0K7+3P3vx+DLtOsMaUPnwj6iOkM96fKWb6nFam/DdMVdzi1V8MsNw+XdUnIPJbwOtoOqGxxNU6EtVbFJTarUrJZwRV+l5rWoYuMahueKu5xbqkK9qobLu6WUVGHidbANnBoIjqLZ0GZcXeZG7KFmy18qMr64y7mlHhv/DP0Q8+kDvVxLQkkMNDmcIieX10Hp0C4BR1B1aEtDw9QwtwksvZzb1Pz8FaV8Yw3ndC/1ttmbUl4HW/yIsbOhXQL2purQBnAWVN1gLwhtADtB1Q32gNAGsDNU3WBLCG0ABxCDG1U3lJWqQ1tpB7bstb1Keh2UtK3WQrsEbEG1oa3TKfdN4eKif1PbaPtLWo4t1wWWQbsEykK1oQ0gZ6i6obQQ2gBOhKobrIXQBnAyVN1gDYQ2gEzg+0vAEghtABlBuwRKgtAGkBm0S6A4CG0AmULVDaYgtAFkTFp1Sx+DdiG0ARQALRMQIbQBFAbBrW0IbQAFQcUNCG0ABcJBSu1CaAMoFKpubUJoAygcqm5tQWgDqABODdQOhDaAikirblAnhLZM8I8RmHqMHygAa6Fdom4IbQAVwkFK9UJoywRX1MbVNqpsKCtU3eqD0AZQORykVBeENoBGoGWiDghtGZG2SNAaAXvBL+QoG0IbQIMQ3MqF0AbQKBykVCaEtsygLQKOhIOUyiOEtouPT6azN8TWjE+fUxuEO9gSDlIqh5ua3/w5v95y9ibYRftHqzh7E0Cl0DKRP7RHAKAIVN3yhtAGALMQ3PKD0C6lvZlbaVF0FF29cpmyf7lpGN+hnnuRxwBKhYOU8qT50OaQZbU96tDkmAXk7T/UovmSFsTSyo3bqWXbdqUOap1OR77PthWGMw+dsnp+AEdAu0ReNB/ajAP3VM5RmvSKv8Whfenni0Jgi/OXxokjh+ipTs+STv8/Hm7XqXOplgPgCDhIKQ8I7b+5uroahrlyDhwTRh+sT6fDeVfp8BefUuyUEOG5uctTKHSIj2E6kangPn74K5qjn+/WzZsUu3QldevtVeT5/bt2kt+IIC65aZ9+GKENcoeq2/kQ2nQ/fGvW9qCI2AWGca3bdaBDP1wRhhfHTKfXFicLw0tiZwgBLW2JSMNbatHsSJo+P5FqezxCM8NGPRDauefOUGTcQmH47aREm+8XgL3gMnjnQWiT6SrZyy/AUH3/lHeeOnfrKfSgedhSebn/pSmjBtO9e/f4Yp8iz3178jh9lbWvSOB/980JQ8sFQO4Q3M6B0DajXLlyhuH6DZvQ1weySKcP38ceb2zxMho1a0Hh02Opa88+RdovbP+uHbQk7T16sd8A4fG+j7YL4xDaoCToczseQtsCU+Nfp7jIUGE4btlqi+fjlkp8ZDhFBAUI1ba0oud+tm/gK4bHLdo8SW8tnk/hM2Jtt+EADoBTAx1L86FtqjViPK5z95708bFzZqcxN9zmqY6Usf9rk+vd8vmxIo8bNGpCWz47avmGA8gMDlI6huZDGwBsCy0T+0Jol1FJF9bgCknQIlTd9qPJ0LZXkNpiueLZJAh6UAsEt21pMrTtFYi2WK54DjiAGuAgpe1pMrSNL4wJCAqmzIwN9EroJHr/nRTa9kU21aj1MF3L/4P8nu9AOw6eoGo1ahqmr1zFnSLmJNCgEaNNLnf/7p00N2o8de/zssP3DUCO0C6xHU2GtjE+j9pvWBCFBfpQr34DKGNtGgVHztIHeCr19vYzBDbjUOaLYCJHD3kgtEXJCXNofnK6MMwfBiJzFTRaIaAVOEhZdghtved7vSTcX8u/QkPHhlGwfz8aNjacNq9Lp7QtuwzTrUlaQu+lJNP1q/kPXCwj9cvFPMMVlFIIZwBU3WWF0DbSpEUrat7ak6YEDaEWbTypcfOWhuf4+0FWvZ9JhXcKaOzAl8wuo16DhsIVlMZQaQP8A1V36SC0TeAqe/JIf0p6d0uR8f0GBdL4of3JJ2B4sfNPjI6n2eNHP9DTtiScxWDHqYKgBWJwo+q2nCZDu6SrGbldYiowo19fIdwYf3ufufl7evkKNxa/PKXU2wagBWiXWEeToQ0A8oN2iWUQ2gAgG6i6S4bQBgDZQdVtHkIbAGQJVbdpqg7t9o9Wcdi6UlJSKCQkxGHrA9AK/EJOUaoNbZ3O8v/ALi76PwgrpjclNTW1zMsAANPQLvmHakPb0YKDg104uPne2dsCoEZol9yH0LYhBDeA/Wm96kZo25gY3OKws7cHQI20XHUjtO1AGtwAYD9arLoR2naCVgmAY2it6kZo21FZWyWurq739Mx/BywAGGjl1ECEthU4RPnekiAVp/Xw8Pi9b9++dfShbe/NA9A8LbRLENpW4LAWw9jS6Y8dO9axT58+n6BVAuAYam+XILTtjC+4qVKlyi19YNeeMWOGbuvWrd/fuHGjanp6+lhvb+8PeRr+IBg5cuT6zMxMHx7v5+e3zXg5PI27u/vNxMTEqfplpfK406dPtxk3blxadnZ2h4KCggr8IXHw4MGuQUFBa43XAaA1aq26Edp2xEHbtGnT3F27dgm/hvDJJ58c9/Lyeqp69eoUFRW1VBqoAQEBGXzj8aZCmwM5Jyen/YABA7aLoT169Oi3hw8fviErK6tHhQoVCnjchAkT3kxKSppUt27dS4GBgZsQ2qBlavw1eIS2HXH1O23atCVnzpxp7enpeers2bNPnDp1qlAfwG4uLi5NpdP27t17L1flFy5caGS8nISEhOhly5ZF5ufn15K2Z/TL8uRKWwxsxuvw9fXdySHPl+fbdQcBFEJadSsdQtuO3NzcChcuXDirS5cuX/bt23dPy5Ytv5s3b16MvtrenZ6eflc67b59+17k+0aNGl0wXg4vY+/evb35Q6BHjx5Z4vi2bdt+k5aWNi40NHS1GNzSdVjTfwdQO7W0SxDaVhBDUHoqXkmn5VWsWPHP8PDwt2JiYualpKSEjBkzZk3//v136OfhPx7xk1+3adOmQLGnbbyMESNGvMehP2rUqHXS8TytXvrUqVMTCwsL3Xg7jNbhilMGAf6hhoOUCG0rmApAc6EoHc/BKg6fPHnySel04nnca9euDTK3jFWrVoXxjYe5Xy0+zy2XQ4cOdZbO06lTpyPG6wCAopRcdSO0nYxPAwwNDVVFrw1ASZR6kBKhLQP6ihqXvAM4idJaJghtmXDktwMan1UiPsaPOICWKeUyeIS2jODbAQGcSwnBjdCWGem3A9qr8uaK2rjaRpUNcJ/cD1IitGUIFTeAc5nqc8slyBHaMmQc2DhICeAccrySEqEtM46qsKUtErRGAMwzDm5n97wR2jIjVtSotgHkwVSl7czgRmjLlLnwBgDHKa414qzgRmjLnPSgJKptAMeShrJcetsIbQWwV9WNXjaA5Yyrag5xZ1TbCG0bcdR3V4eEhDj8016t4a6W7xu39r+PVveb2WPfXcixrydC24Zyfr3l7E2wufaPVnH2JthVx6PK+MHlY0+nmtxWHl8aStlvZmrfS7vfTOn7jtAGAFAQhLYC7M3cSouio+jqlcuU/ctNw/gO9dyLPAbHy+6URh2OjLP5tHKn1f1mzt53hLYDcciy2h51aHLMAvL2H2rRfEkLYmnlxu3Usm27Uge1Tqcj32fbCsOZh05ZPb+WODJkeF0CVxeq8Kg71Z/4L6rxYmOHrNvUtmhxv8XtUcq+I7QdjAP3VM5RmvSKv8Whfenni0Jgi/OXxokjh+ipTs+STv8/Hm7XqXPJM4FDCGGhI7px5Gc6H73PqeHlSFrdb1aWfUdoO4Gr6z+/UMaVc+CYMPpgfTodzrtKh7/4lGKnhAjPzV2eQqFDfAzTiUwF9/HDX9Ec/Xy3bt6k2KUrqVtvryLP79+1k/xGBHHJTfv0wwht63GF5Fq5PNWf/C96eGArw/gLcVl0/YsfqeFr3ajGC43o1onfhHF3/++OMK76849bvA636hXtsellotX9ZnLcd4S2g3H41qztQRGxCwzjWrfrQId+uCIML46ZTq8tThaGl8TOEAJa2hKRhrfUotmRNH1+ItX2eIRmho16ILRzz52hyLiFwvDbSYk23y8t4Oro9tkr9H3UniJv4Fq9mwq3i298JbyBf1x8kBpM60Lla1cWqqiS3sDiP5dd3FypyeLedt2H0tDqfjM57jtC28FMVclefgGG6vunvPPUuVtPoQfNw5bKy/0vTRk1mH+6jM9FLfLctyeP01dZ+4oE/nffnDC0XKBkl97Ood82fkN3r/8l9CKlqv7rMeGfugW/3v9v+2feNfo+cg/RPR2fGFzissVe6s3sXylv3udWVWn2ptX9ZnLdd4S2DJQrV84wXL9hE/r6QBbp9OH72OOW97kaNWtB4dNjqWvPPkXaL2z/rh20JO09erHfAOHxvo+2C+MQ2pa7tPY4NV/Zj3R37tK5kA+LPHfj8M/CPR9UYhUb1aB6oU9T9S4NHnizl6Twxl+22WAb0ep+M7nuO0JbZqbGv05xkaHCcNyy1RbPxy2V+MhwiggKEKptaUXP/WzfwFcMj1u0eZLeWjyfwmfE2m7DVcZwhJ/uV0W1vJrTfyfuotr9Wjwwbf4nuYb+Jms463m6MO8zyo36RKi8SjorQViX/n1e4RF3enx6V9vuiJW0ut+G7fmbnPcdoe1AplojxuM6d+9JHx87Z3Yac8NtnupIGfu/NrneLZ8fK/K4QaMmtOWzo5ZvuMaYesM9Pus54ca4d1nctJXbeFDrTf4WLVdO5y9rdb+ZkvYdoQ0AoCAIbQAABUFoK0hJV0PisnbnKumqOrVdzi3S6n4zZ+w7QtvO7BWktliueAqgloPeXoFii+WKB8bkun32Wq4991tcvhz3/c/cq5Q77RNhuOmSPlSxaU2T0yG07cxegWiL5YoX7oDt2SIUeBnSMxqUQKv7zcq67z+/dYTqBj1lGG66tI/J6RDadmZ8NWNAUDBlZmygV0In0fvvpNC2L7KpRq2H6Vr+H+T3fAfacfAEVatR0zB95SruFDEngQaNGG1yuft376S5UeOpe5+XHb5vasNB4TG4NV358BzVHdGOfss4RW0+CCC3GhWp8NqfdNo/gzy3DqFy1R4yTG/qEmfxOX4TX/v0AuXN/5xqdGvojF2yiFb3m8lp32998xs1mtNdGP75zcNmp0NoOxhf/OI3LIjCAn2oV78BlLE2jYIjZ+kDPJV6e/sZAptxKPOVi5GjhzwQ2qLkhDk0PzldGOYPA5G5ClrLrRBLVOvSgB7u35LOjf+Iar7YhC5vPkOPjutAlzNOC4/FNy8zd4mz1M8rD1PjuS8IwxwMInOVpLN6v1rdbyaXfb97o4DKuVcQrrTkYXMQ2g72fK+XhPtr+Vdo6NgwCvbvR8PGhtPmdemUtmWXYbo1SUvovZRkun41/4ErHKV+uZhnuOxdCuFcOtWfu385MV+6XGdIGzoX9hHVGepJl7d8Sy1WexumK+4SZ6mCX24YLnmWktuBOa3uN5PLvnNg3715P6zLVa1gdjqEthM1adGKmrf2pClBQ6hFG09q3Lyl4Tn+UqdV72dS4Z0CGjvwJbPLqNegoXDZuzFU2mVXsUlNqtSslnCVW6Xmtahi4xqG54q7xFmqQr2qhkuepeRYcYq0ut/Mmfte5clH6FrWhfvDbR8xu3yEtpNxlT15pD8lvbulyPh+gwJp/ND+5BMwvNj5J0bH0+zxox/oaVsSzmKw41RB87jiyo3YQ82WF/3gLO4SZ6nHxj9DP8R8+kB/05KQEt/kzjgoJ5f9dkaYO2vf64U9Teen7RWGmywx/81/CG07K+kSdG6XmArM6NdXCDfGX7lqbv6eXr7CjcUvTyn1tmmV9I1kapj/6WzpJc6m5uev7eQba/j3QabSbFtZfsi2pGXLeb/tQa77zhV+m21DSpwOoQ0AoCAIbQAABUFoAwAoCEIbAEBBENo21P7RKs7eBLCSrQ/w2ZMtt1VJ+82w7/9AaNuITqez7jeGiH9KzkVXmvnANpT62pf178aaedX2N6qGfUFoAwBYiT/M+N4ZHwIIbQVKTU0tcoFscHCw4qsHALAMQluBjEPaVIjzOIQ5gPogtFXAVDiLwV3SdABgHbE1Ig47ukWC0FYxSypyx24RgPKJIe2sg7QIbQ1BiAMoH0Jbw0oKcVPTAIBzIbTBwFRAoxoHkBeENhQL1TiAvCC0wSqWVOPmpgOAskNoa5A+ZINfe+21+ZUqVbr9xhtvRAwcOHBrcdO7urre43sPD4/L8+fPf23cuHFFfkrF2W0VPoLfrFmz73k4Nze3aWmWIe4j3zdq1OjCokWLZvr7+39gy+0EsAWEtgadPn26zblz51ocOHDgudGjR79dUmize/fuuR47dqxjnz59PjEObVMceabKl19+2aVr164HObx5WO/L0iyH95GXsX///p5Dhgx5H6ENcoTQ1qAVK1ZM5vuOHTse69ChQ7al83GgValS5RYPHzx4sGtQUNDaGzduVE1PTx/r7e0t/NIpV6rh4eFvrVu3bhRX8zNmzHidx3NI83Pu7u43ExMTpxqH+F9//TUpJyen/QcffOA/Z86c+KioqKXFrUdq69atA/mDhLePh02Fdrt27U4MHz58w9ChQ//doEGDiyXta+3ata9Y+roAOBJCW8MSEhKiN2zYUPwvB/+NA7dp06a5u3btEn5BeMKECW8mJSVNqlu37qXAwMBN0jD18vLaPXbs2PTevXvvFUObcSXLwTxgwIDteXl5QohnZmb61K9f/6evv/76eOfOnYlveon6UE/koC9uPSL+l8PSpUujeHjhwoWzTG3/ypUrx/O+8gdVq1atvuUAHzx48OaaNWtele4j35cvX/7Oli1bBln2KgI4FkJboyZNmpTk4+OTaWlFWVBQUGHatGlLzpw509rT0/PU2bNnn/D19d3JQSy9rJf169fvI76/cuVKbXEcf0AsW7YsMj8/v5YYjtJp27dvr+Nl8TA/z8NcjYeFhdHFixd36W/cr75rvF3Z2dkdPvnkkz7SZfIHg16OOI6X9dxzzx3gG28DV/GhoaGr+Z4reHE+cf2ff/55tzFjxqwx9QEB4GyaDW3joJE+tuelqc5arxS3Lbgtwv1pS+dxc3Mr5CqWWw99+/bd07Jly+/mzZsXw1W1NDDN4Xn37t3bm8O/R48eWZaskytt3k5xPfpRd43bKj/++OOCzZs3Dx40aNAWfswVMrdIOLTFEGbcv9+4ceMwfv6JJ544u2rVqjCutM2t++rVqzUt2UZHMfd3o4bvhwbraDa0tYyrXr7ng5B8f/v27UoPPfTQX2KFa26+ihUr/sn96piYmHkpKSkhXI32799/B89T3HxsxIgR73HYjxo1ap0122q0Hp3xejjE9RU93xvG6UP7DAe9dDrebm6JHD169GlzPW3efw5Dfp7bKdZsJ4CjaDa0uUIxrl7E8Wpcr5S5gLVkPPeqxeGTJ08+Wdy00mGubPnGw9yjLm5a6XCnTp2OmFqPyMxZKDppRc7TFLcM43XKkam/G1TZ2qTZ0Ab1whdjgZohtCWcVbmgYrIvhDioiaZD21yrQq3rhftMhbjxj0bIMcilfzf4oNcuTYc2ABMDWhrU1nyfijitHIMe1Aeh/Te0RkCqNN+ngvAGR0BoA1jIkq+pFccjuMFeNB/aqLChtEz9eLLIXlU3/m5AtaEdHx+v6gN9c+bMwZu3jGxxMDglJaXY58XwDgkJKeuqrIJwVy/VhjbrHzLN2ZtgFztSljh7E1Qj59dbjlmP7wiHrIe1f7SKw9YFjqfq0AYAUBuENoAd7M3cSouio+jqlcuU/ctNw/gO9dyLPAawFkIboBgcsqy2Rx2aHLOAvP2HWjRf0oJYWrlxO7Vs267UQS2u29XVleo1aEiTZs+lXt5+Vi8H1AWhDVACDtxTOUdp0iv+Fof2pZ8vCoEtzl+Wdet0OjpyIItmhI5CaANCG8ASXO2KuAIOHBNGH6xPp8N5V+nwF59S7JT7Z4fMXZ5CoUN8DNOJTAX38cNf0Rz9fLdu3qTYpSupW2+vYrehes1attgVUDiENkAJOHxr1vagiNgFhnGt23WgQz/c/9GfxTHT6bXFycLwktgZQkBLWyLS8JZaNDuSps9PpNoej9DMsFEmQ1uc1618eUpM32jT/QJlQmgDlMBUlezlF2Covn/KO0+du/UU2hg8bKm83P/SlFGD+bu8+ZzxYtedfegAxUeGl1iNg/ohtC1gryP+xtUYzipQjnLlyhmG6zdsQl8fyCKdPnwfe7yxxcto1KwFhU+Ppa49+xRpv5jzv+vXSrOpoDKqD23xn5f8z9vxM2Jp4IhXnbxFoDZT41+nuMhQYThu2WqL5+OWClfPEUEBQrVt6kOb/365Cq9brz7NTFhms20G5VJ9aDN+M5w5mUPhgb4IbQ2w5XdOmwpS43Gdu/ekj4+dMzuNueE2T3WkjP1fW7VuAE2EtkCno0qVKxsemjpyz1WN9+Bh9Pne3cK4nl6+JhfF01Wu4k4RcxJo0IjRlHv2DM2bOoG+/eY43SkoEN5s5s4M2L97J82NGk/d+7z8wHJjJwcL654693V6OymRtnx2TKiy7t69S4O6d6ToRcvpmed62OXlUSNn/NI9gL1pIrQ5ZBs0akLJ7201jDN35L6P7yDhtix+ltnQ5lD+7psTFDl6iBDacRFh9PLAIZS25WMqX6FCsctPTphD85Pv/zZuZsaGIsuVrvvJjs/QgX176PleLwnTVa1WHYFdBvjFF1ALTYT24R+v0fJ5s+n8ue+oWcs2wjhzR+7FswB+uZhncllrkpbQeynJdP1qvuHgEVfafsNfNQR2ccvn5YrrMCZd9/w311Dq0gR6tvuLlLZsob76XmyYLi4ujm+q/hZDe3H0z7yVdIAZB6DBWpoIbTc3N5o4K56CfHtSlx69yF1ftZo7cs9nATC+bNgUblusej+TCu8U0NiBLwnj+INg24Z3yH/kWENwm1s+L1dchzHpuls/2Z6u6T8YkhfGUcXKVegFLx/DdBza+GpW84oLZmmlbW46R5wtVJZlMAS9dmkitNlDFStSwKhgemvxPKFtYe7I/Z7tmw09bVP6DQqk8UP7k0/AcMM4npb71G/MjabCwkJhWeaWPzE6nmaPH22yp228br9hQfplhFH88uK/sxnMK007xF6BaIvlihfugHapPrSlbxS/4UGGYXNH7ueuSC12GdGvrxBujMOfcaW9/qOsIvOYWz73ycVeuTSMjd/QHPTcgmn6RGvyGjjE3O6BCWXtWxufPx8QFCwcV3gldBK9/04Kbfsim2rUepiu5f9Bfs93oB0HT1C1GjUN00sPUptabnEHowFKovrQVqp/NawpBP/qjA+F9g44D7e4+F89YYE+1KvfAMpYm0bBkbP0AZ5Kvb39DIHNjA9Sm2LuYLS5ChqtEJBCGkjI6c1x5OJ1Z28C/I3P4GHX8q/Q0LFhFOzfj4aNDafN69Ipbcsuw3SmDlKbYu5gtJz+/kC+ENoAVmjSohU1b+1JU4KGUIs2ntS4eUvDc6YOUpti7mA0Km2wBEIbwEpcZU8e6U9J724pMt7UQWpTzB2MtiScxWDHqYLahdAGMFLSJejcLjEVmKYOUpua39zBaGu3DbQJoQ0AoCAIbQAABUFoAwAoCEIbAEBBVB3aO1KWOHsTQObaP1rFIetJSUmhkJAQh6wL1E21oY0vVIKSlOZyd/6SqTJcJq8LDg7G3yWUiWpDGwBAjRDaAA7CVXZqaqpOHHb29oAyIbQBHEgMaw5vBDeUBkIbwAnEqhvBDdZCaAM4EYIbrIXQBnAStEqgNBDaAE6GVglYA6ENoAKurq739Mz/8gKoBkIbwMZWrVoVFhMTM8/d3f3m0qVLowYNGrSluOk5cPV3umnTpun69+9P69evR8UNZiG0AWzs7NmzT+Tm5jY9fvz4U4MHD95cUmgzrpKPHTvWsU+fPp+gVQLFQWgD2Njy5cun8L2bm1thnTp1frd0Pr48vkqVKrf0gV17xowZuq1bt35/48aNqunp6WO9vb0/5Gm4Kh85cuT6zMxMHx7v5+e3zXg5PA1X+YmJiVP1y0rlcadPn24zbty4tOzs7A4FBQUV+EPi4MGDXYOCgtYarwPkDaENYAccnBUrVvxz586dvpZO37Rp09xdu3YJv0H273//mwYMGNDs1Vdf7RAYGLhJGqgBAQEZfIuKilpqKrQ5kHNyctrr598uhvbo0aPfHj58+IasrKweFSpUKOBxEyZMeDMpKWlS3bp1LxmvA+QLoQ1gBxycn332WXd96L5z/vz5JiVNz9XvtGnTlpw5c6a1p6fnqT/++OP2qlWryq9cuTLbxcXlrnTa3r177+Wq/MKFC42Ml5OQkBC9bNmyyPz8/Fp/98oFp06d8uRKWwxsxm0cX1/fnbyt/EVYZdxlcBCENoCNLV68ePrkyZNX/PXXXw/dvn27kiXzcCtl4cKFs7p06fJl375997Rs2fK7efPmxXh5ee1OT08vEtr79u17ke8bNWp0wXg5vIy9e/f25g+BHj16ZInj27Zt+01aWtq40NDQ1WJwS9chDXiQN4Q2gB14eHhcfuSRR35LTU0NFseVdFoet1PCw8Pf4jNPUlJSQsaMGbOmf//+O/Tz8NOGg5ObNm0KFHvaxssYMWLEexz6o0aNWicdz9PqpU+dOjWxsLDQjbfDaB2uOGVQGRDaADY2ffr0xXwzHm8uFKXjOVjF4ZMnTz4pne7vbwjUrV27NsjcMvh0Q77xMPerxee55XLo0KHO0nk6dep0xHgdIH8IbQCF4Eo7NDTU7r1n4/62+LgMP/4ANoTQBlAQfUVd5JJ3nNOtPQhtAAUSf0xBHLZlcHNFbVxto8qWD4Q2gMJIfwEHtAehDaAwpgIbbRLtQGgDKIijKmxpiwStEXlBaAMoiPQApPFzqLa1AaENoEDFhTeoG0IbQMGklTUHuC2rbbRF5AmhDeAAjvxCppCQEIdW3wh3x0JoAzhIzq+3nL0JNtf+0SrO3gTNQWgDACgIQhsAQEEQ2gAKtzdzKy2KjqKrVy5T9i83DeM71HMv8hjUAaENIBMcsqy2Rx2aHLOAvP2HWjRf0oJYWrlxO7Vs267UQS2u29XVleo1aEiTZs+lXt5+Vi8H7A+hDSAjHLinco7SpFf8LQ7tSz9fFAJbnL8s69bpdHTkQBbNCB2F0JYphDaAzHC1K+IKOHBMGH2wPp0O512lw198SrFTQoTn5i5PodAhPobpRKaC+/jhr2iOfr5bN29S7NKV1K23V7HbUL1mLVvsCtgBQhtARjh8a9b2oIjYBYZxrdt1oEM/XBGGF8dMp9cWJwvDS2JnCAEtbYlIw1tq0exImj4/kWp7PEIzw0aZDG1xXrfy5SkxfaNN9wtsB6ENICOmqmQvvwBD9f1T3nnq3K2n0MbgYUvl5f6XpowazD+iwBf6FLvu7EMHKD4yvMRqHJwDoQ0gc+XKlTMM12/YhL4+kEU6ffg+9nhji5fRqFkLCp8eS1179inSfjHnf9evlWZTwQEQ2gAKMjX+dYqLDBWG45attng+bqlw9RwRFCBU26Yqem6PcBVet159mpmwzGbbDLaF0AaQCVNBajyuc/ee9PGxc2anMTfc5qmOlLH/a6vWDfKE0AYAUBCENoBKlHRhDa6QVAeENoAT2StIbbFc8RRABL28ILQBnMhegWiL5YrngIO8ILQBnMj4wpiAoGDKzNhAr4ROovffSaFtX2RTjVoP07X8P8jv+Q604+AJqlajpmH6ylXcKWJOAg0aMdrkcvfv3klzo8ZT9z4vO3zfwD4Q2gAywudR+w0LorBAH+rVbwBlrE2j4MhZ+gBPpd7efobAZhzK331zgiJHD3kgtEXJCXNofnK6MMwfBiJzFTRaIfKH0AaQked7vSTcX8u/QkPHhlGwfz8aNjacNq9Lp7QtuwzTrUlaQu+lJNP1q/nFXizzy8U8wxWUUghn5UJoA8hUkxatqHlrT5oSNIRatPGkxs1bGp57OymRVr2fSYV3CmjswJfMLoO/ZpWvoDSGSlu5ENoAMsZV9uSR/pT07pYi4/sNCqTxQ/uTT8DwYuefGB1Ps8ePfqCnbUk4i8GOUwXlBaEN4EQlXc3I7RJTgRn9+grhxvjb+8zN39PLV7ix+OUppd42kA+ENgCAgiC0AQAUBKENAKAgCG0AAAVBaAMAKAhCG8BB2j9axSHrSUn55yyRkJAQh6wTHAehDeAAOp3O9A8zlsDFxUVX2nnFVYsDwcHBZVkOyARCG0DFpEGdmpqKAFcBhDaARhgHOD8WgxwhrhwIbQANEkNavEcVrhwIbQBAG0VBENoAUISpAEd4ywdCGwDMQvtEfhDaAFAiR7RPXF1d7+mZ/0UHECC0AcCs5cuXT4mMjFwmDVNTAR4aGsp3Og8Pj8vz589/bdy4cWmO31ptQGgDgElXrlypvXHjxmHFTSMGuD60761evdolLy+vTkRERCpC234Q2gBgUkxMzLzx48evfPXVV9+xZHoO8KNHjz797rvvbuUKPDc3l7Zu3fr977//3mzDhg0+3t7eH/J03AYZOXLk+szMTJ/09PSxfn5+24yXxdO4u7vfTExMnKpfbiqPO336dBv+MMjOzu5QUFBQgav/gwcPdg0KClp748aNqrwscR1qhtAGgAdwQH766acvJCcnT7Q0tDlomzZtmrtr166XPT09T7Vv3z4nKSkpum7dupe8vLyy586dK06qCwgIyOBbVFTUUlOhzYGck5PTfsCAAdvF0B49evTbw4cP35CVldWjQoUKBTxuwoQJb+rXMYnXERgYuAmhDQCaFBER8cbMmTMXlStX7q6l83D1O23atCVnzpxpzaF99uzZJ3x9fXdyALu4uNzVh6+QN6Ghobq8vLyP+BfiL1y48KfxchISEqKXLVsWmZ+fX4s/CMTxp06d8uRKWwxsZrQOnfGy1AihDQAP+M9//tOLb2KVbcmZHW5uboULFy6c1aVLly/79u27p2XLlt/NmzcvRl9l75aGr56ucePGwi8N16hRY7fkbBThnpexd+/e3vwh0KNHjyxxprZt236TlpY2Th/6q8XgLmYdqoXQBoAHSANaGtglhXfFihX/DA8Pf4v74SkpKSFjxoxZ079//x08j3S+TZs2Bf7d0x4otke4AucAHzFixGoO/VGjRq2TLpt71nrpU6dOTSwsLHTj5RW3DrVCaANAsaRBaC4UpeM5WMXhkydPPmlq+rVr1waZWIbhQp727dvz4ERxHOOWy6FDhzpL5+nUqdMRc+tQK4Q2QAmMe6Xi4zJ+z7VF67L3+uRIzt+D4si/BXMQ2gDgUNa0MOQc4M6C0AYoAVdRxhWWvSorU+uy5/qURA4B7si/BXMQ2gCgOOYC3Pg5NUJoA8iMuWobTDMOabW3URDaABaQBqmj/zmM1oh1LG2jiD+5Zu3ynfm3wBDaAKBaxbVRpOOUVJEjtAFkCC0S2ysuwEtbdTsDQhsAgJQT3AhtAAuhl60Optokxs+VFN7O/G+D0AbNio+PV237Yc6cOaoMfEe1jEJCQhz+t2HpBwFCGzStf8g0Z2+Cze1IWeLsTbCrnF9vOXsTbK79o1UsnhahDQCgIAhtAAC9vZlbaVF0FF29cpmyf7lpGN+hnnuRx86G0AYAVeGQZbU96tDkmAXk7T/UovmSFsTSyo3bqWXbdqUOanHdrq6uVK9BQ5o0ey718vazejnFQWgDgOpw4J7KOUqTXvG3OLQv/XxRCGxx/rKsm39K7ciBLJoROgqhDQBgCa52RVwBB44Jow/Wp9PhvKt0+ItPKXZKiPDc3OUpFDrExzCdyFRwHz/8Fc3Rz3fr5k2KXbqSuvX2KnYbqtesZYtdKQKhDQCqw+Fbs7YHRcQuMIxr3a4DHfrhijC8OGY6vbY4WRheEjtDCGhpS0Qa3lKLZkfS9PmJVNvjEZoZNspkaIvzupUvT4npG226X8Jybb5EAAAnM1Ule/kFGKrvn/LOU+duPYU2Bg9bKi/3vzRl1GD+IQc+Z7zYdWcfOkDxkeElVuPWQmgDlJG9zi4wrvzkdAaDEpUrV84wXL9hE/r6QBbp9OH72OONLV5Go2YtKHx6LHXt2adI+8Wc/12/VppNLRZCGzRN/Kcs/1N6/IxYGjjiVSdvETjC1PjXKS4yVBiOW7ba4vm4pcLVc0RQgFBtm/og5b8prsLr1qtPMxOW2WybRQht0Dx+4505mUPhgb4IbSeRXp5e1u/1MBWkxuM6d+9JHx87Z3Yac8NtnupIGfu/tmrdtobQBmA6HVWqXNnw0NRZAlxBeQ8eRp/v3S2M6+nla3JRPF3lKu4UMSeBBo0YTblnz9C8qRPo22+O052CAuGNbe4shP27d9LcqPHUvc/LDyw3dnKwsO6pc1+nt5MSactnx4SK7u7duzSoe0eKXrScnnmuh11eHkdy9m8wyh1CGzSPQ7ZBoyaU/N5WwzhzZwn08R0k3JbFzzIb2hzK331zgiJHDxFCOy4ijF4eOITStnxM5StUKHb5yQlzaH5yujCcmbGhyHKl636y4zN0YN8eer7XS8J0VatVNwR2XFwc31TzZVj4XvGiENqgeYd/vEbL582m8+e+o2Yt2wjjzJ0lIJ5x8MvFPJPLWpO0hN5LSabrV/MNB6q40vYb/qohsItbPi9XXIcx6brnv7mGUpcm0LPdX6S0ZQv11fdiw3Qc2kr7lr+Sglmsth0R4CUd9HX2QWGENmiem5sbTZwVT0G+PalLj17krq9azZ0lwGccML5E2RRuW6x6P5MK7xTQ2IEvCeP4g2DbhnfIf+RYQ3CbWz4vV1yHMem6Wz/Znq7pPxiSF8ZRxcpV6AUvnzK+CvJjTVvEEWfwlAZ/YEeOvn9F5rK3/01Nn2hd5m1CaAPoPVSxIgWMCqa3Fs8T2hbmzhLYs32zoadtSr9BgTR+aH/yCRhuGMfTcp/6jbnRVFhYKCzL3PInRsfT7PGjTfa0jdftNyxIv4wwil+eYuuXw6lK08O2V+Vb1uW+qf9QfXVC1P3hRfH0xjvvl3mbENqgadI3pd/wIMOwubME5q5ILXYZ0a+vEG6Mw59xpb3+o6wi85hbPvfJxV65NIyNw4ODnlswXLl5DRxibvcUo6wHG43PaQ8IChZ6/a+ETqL330mhbV9kU41aD9O1/D/I7/kOtOPgCapWo6ZheumBY1PLLe4AcXFOHjti+O/IxytsAaENoED/alhTCP7VGR8K7R0oittO/C+RsEAf6tVvAGWsTaPgyFn6AE+l3t5+hsBmxgeOTTF3gNjc5e7iB8iN/10T2m18LIKHbQH/tQEsJKcrEo9cvO7sTZA1PquGXcu/QkPHhlGwfz8aNjacNq9Lp7QtuwzTmTpwbIq5A8Ql/U24V61ON/93/79V1Wo1Srk3RSG0AUDVmrRoRc1be9KUoCHUoo0nNW7e0vCcqQPHppg7QFxSpd3u6Wdo/+5MYfjJjp3KsBf/QGgDgOpxlT15pD8lvbulyHhTB45NMXeAuKRKO3xGLE0dM0wYTlxjm2/8Q2gDgOKVdAk6t0tMBaypA8em5jd3gLgkzVt50o4vT1o8vSUQ2gAACoLQBgBQEIQ2AICCILQBABTk/wHjZljfLDIJVwAAAABJRU5ErkJggg==)*Drawing
2: Interaction of Profiles, Labels and replacement*\

\

\

\

\

Labeling

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

Policy Encoding {.western style="page-break-before: always"}
===============

AppArmor policy is encoded in a architecturally independent binary
format that is unpacked and verified at load time.

\

### Encoding of Rule Paths {.western}

foo

##### Encoding of Conditionals {.western}

foo

### Encoding of File Rule Paths {.western}

foo

\

### Encoding of Network Rule Paths {.western}

foo

\

### Encoding of Mount Rule Paths {.western}

foo

\

### Encoding of the mount flags {.western}

foo

\

### Encoding of DBus Rule Paths {.western}

foo

\

### Encoding of X Window Rule Paths {.western}

foo

\

\

DFA/HFA {.western}
=======

The DFA/HFA was first introduced in AppArmor 2.1 and has seen gradual
improvements and extensions.

\

### Format of the DFA/HFA {.western}

foo

\

### PolicyDB the encoding of policy rules into the HFA {.western}

foo

\

### Encoding permissions {.western}

foo

\

### Putting it altogether relationship of Policy and DFA/HFA {.western}

foo

\

### Steps in generating the DFA/HFA {.western}

foo

\

\

