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

Extending AppArmor to the Userspace

\
\

AppArmor Documentation {.western style="page-break-before: always"}
======================

AppArmor Core Policy Reference Manual

Understanding AppArmor Policy

AppArmor Developer Documentation

-   -   -   -   -   -   

Tech Docs

-   

 {.western}

<div id="Table of Contents1" dir="ltr">

<div id="Table of Contents1_Head" dir="ltr">

**Table of Contents**

</div>

[AppArmor Documentation 2](#__RefHeading__7261_244776796)

[Preface 4](#__RefHeading__7255_244776796)

[Introduction 4](#__RefHeading__7257_244776796)

[What a trusted helper needs to understand about AppArmor
4](#__RefHeading__7259_244776796)

[Trusted Backends (2 Layer model) 5](#__RefHeading__4011_510320029)

[Trusted Intermediaries (3 Layer model)
6](#__RefHeading__4013_510320029)

[3 Layer Trusted Helper - Trusted intermediary only
7](#__RefHeading__4015_510320029)

[Trusted intermediary without extending policy
8](#__RefHeading__7077_510320029)

[Trusted intermediaries with extended policy
8](#__RefHeading__7079_510320029)

[3 Layer Trusted Model - Trusted Intermediary and Trusted Backend
9](#__RefHeading__4017_510320029)

[Extending Policy to support Trusted Helpers
11](#__RefHeading__4019_510320029)

</div>

\
\

Preface {.western style="page-break-before: always"}
=======

This document is intended for developers who wish to leverage apparmor
to improve the security of their application or services using the
additional semantic information available in the userspace. This
document covers the general concepts while the AppArmor APIs and
Interfaces document covers the APIs that the developer will need.

Introduction {.western}
============

The AppArmor kernel module can only mediate application interaction at
the kernel object level. The kernel object level is good at controlling
low level (file, network) accesses but it is problematic for mediating
many higher level (address book, system settings) permission requests
because the full semantics are lost when the access request is mapped
into kernel syscalls; eg. a request to update a single address book
entry is seen by the kernel as a set of requests to send messages to a
service or update a file.

\

If an application has direct access to a resource (eg. file) then
mediating at the kernel object level is the best that can be done.
However if the resource is accessed via a service that is run as a
separate process, that process can mediate access to the resource and it
can be extended to query and enforce apparmor policy. In AppArmor a
service that has been extended to support apparmor policy mediation in
userspace is known as a trusted helper.

\

For a trusted helper to be useful and secure it must, reside in a
separate process from the applications it provides resource mediation
for, use a secure form of communication, provide data to querying
applications in individual units of mediation, policy must be able to be
extended to support new the new type of mediation being done by the
helper, and communicate with the apparmor kernel module so that it can
enforce current policy.

\

The service is required to be in a separate process so that its memory
and communications can be secured and mediated by apparmor at the kernel
level. Mediation within an application can not be trusted (guarenteed to
be secure), even if the application code is known to behave correctly
and respect the mediation returned. This is because the application
process must have access to the data at some level and if the
application has a flaw that allows for an exploit, new code could be
injected that can access the data without proper mediation.

\

The communication of the trusted helper must be secured so that none
authorized applications can not access the service, and the service can
trust the applications requesting permissions from it are who they claim
to be. This provides the trusted helper the ability to enforce mediation
based on the security context of those communicating with it.

\

The resource access must be in individual mediation units otherwise
there is no point in providing more detailed mediation than the kernel
can provide; if the access is for a single key in a file and the service
returns access to the file with all the keys the mediation can not be
enforced, as the trusted helper is trusting the application that
requested the data to only access the requested key. Similarily the
apparmor policy should usually be extended to support the new data unit
that the trusted helper is enforcing other wise the policy will not be
able to express access rights at a granularity finer that what is
already enforced by the kernel; the exception is when the decision does
not come from policy but from the user, in which case the trusted helper
can use the security context and the users response to enforce mediation
without extending the policy language.

\

What a trusted helper needs to understand about AppArmor {.western}
========================================================

To effectively leverage apparmor in a trusted helper there are several
things that need to be understood about apparmor. There are several
additional documents (Understanding AppArmor Policy, AppArmor API, …)
that cover these topics in more detail but a quick overview is provided
here.

\

Each trusted helper is unique and has its own set of requirements. The
author of the trusted helper should way the requirements and different
options when deciding on what to do. This document is only a guide to
what is possible and can not cover all possibilities.

\

AppArmor is a MAC based security system that uses a centrally managed
policy that is enforced on processes (applications), on a per process
bases. This means individual user applications can have different
security applied to them and resources that would be available in
standard unix DAC may not be available to an application.

\

AppArmor applies a security context to every process in the system, and
may or may not label system objects. If AppArmor does not explicitly
label a system object then an implicit labeling is available within the
policy rules. Authors of trusted helpers will need to choose how best to
extend the apparmor security information to the trusted helper, whether
that is just leveraging the existing information apparmor tracks or
extending this information tracking to objects that the trusted helper
is responsible for.

\

AppArmor rules and policy can be very fine grained so it is usually best
when querying apparmor to use the subject or object as part of the query
instead of just the security context. This is because some apparmor
rules may be conditional up certain subject/object properties. And this
information is not available from a generic security context.

\

AppArmor is extensible so that if a trusted helper needs to extend
apparmor policy to provide finer grained mediation rules, it is possible
to do this within policy, with the trusted helper being responsible for
enforcing those rules. Policy extensions will should go through the
standard policy compiler and must conform to the syntax supported by the
compiler. The trusted helper we be responsible for understand how to
form queries against the compiled form.

\

It is best if AppArmor policy can be managed centrally so there is only
one place to look to discover restrictions that apparmor is enforcing.
There are exceptions to this rule but a trusted helper author is
encouraged to follow this guideline if at all possible.

\

The manipulation and loading of AppArmor policy is a privileged
operation that may not even be available to all administrators/root
processes. Trusted helpers that wish to change and reload policy
dynamically will need to have sufficient privileges to do so.

\

AppArmor only considers a trusted helper privileged within its domain,
and as such AppArmor may be enforcing policy restrictions on the trusted
helper even as it relies on the trusted helper to extend its mediation
to new types. For example the dbus daemon can be a trusted helper and it
is trusted with respect to mediation of messages on the dbus message
bus, but the daemon it self may still be restricted from accessing
certain files, network communications or even from communicating with
certain applications.

\

For discussion purposes we will break trusted helpers into two broad
categories trusted backend (or services) and trusted intermediaries.
While both catagories have much in common trusted intermediaries
introduce an extra layer and often have a different purpose than trusted
backends so their design requirements are different.

\

Understanding apparmor policy

Label on tasks

Labeling of sockets communication.

Objects – helper has to label or track its own objects

\

peers

appamor api to query perms

extending policy

storing decisions

- local acl

- updated policy

\

policy load is privileged

\

-try to keep policy in one place instead of scattering it in different
locations (polkit, secmark, bad bad bad)

\

- label on task

- pid race/life time

- label on socket

- querying policy

- extending policy

- storing decisions

- local vs extending and reloading profile

\

\

\

Each trusted helper is unique in its requirements and how it extends
apparmor, but there are a few

\

Communicating with the

???? Getting the security context

???? Using just the security context and not using apparmor policy to
make the decision

???? storing in application data vs in apparmor policy/or centralized db

- apparmor policy is searchable

- centralizing all policy decisions

- known where to search (even in a per user, per app type situation)\
 - easy to cleanout if profile is removed (don't leave bread crumbs)

- extensions can be stored in dir or other place that is not part of
main profile

- extension to kernel mediated features need to go into policy (add file
access to sandbox)

vs. in backend

- in backend app/db/location, could be more convient easier to implement

- have more context when selecting what to remove privilige from

- may need encrypt that is not possible in policy

- need away to clean out when client app is removed so it doesn't leave
bread crumbs

vs. in app

- hard to find search

- app can't have direct access to information

- app can clean out the information easily if stored in place only
belonging to application

- data needs to be encrypted by backend private key, and then sent to
application for storage, application then send back encryped data, and
backend decrypts

- this works only for a limited set of data like geoip

- doesn't work for online accounts?

\

Delegation vs. extending the profile vs. extending the task

### Trusted Backends (2 Layer model) {.western}

In the trusted backend model the “Backend” is a process that provides a
service to the Application. The service could be anything from mounting
new disks, to looking up a contact in an address book. The important
point is the Application does not have direct access to the underlying
function or data that the service provides.

\

<span id="Frame3" dir="ltr"
style="float: left; width: 7.2in; height: 5.95in; border: none; padding: 0in; background: #ffffff">
</span>

![](data:image/png;base64,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)\
*Figure 1: Application and Backend communicating via a kernel mediated
channel*

\

\

\

\

Shows how the relationships in a simple (direct) trusted helper model.
In this model the application communicates directly with the trusted
helper, which in this case is known as a trusted backend. The kernel
uses the apparmor policy to provide a security context for both the
application and the backend. The trusted backend can then query the
apparmor policy to determine the permissions for the applications
request, and then it can reply back to the application.

\

- can only extend rule set as direct communication is already being
mediated

- apparmor is controlling the messages between the applications

\

- get security context of Application.

- kernel provides security context

- trust the security context

- make decisions based off of it (query via api)

\

- save acls locally

- extend policy

\

An example of this type of Trusted helper would be ????.

\

bar

\

\

\

\

### Trusted Intermediaries (3 Layer model) {.western}

While most services fit into the trusted backend where the application
directly connects and talks to the service, there are several cases
where an extra application/service, the intermediary, is involved. The
intermediary acts as a third party in an exchange, message relay, bus
sending the message on to the target, after having done its work,
whether its just looking up the targets address or reformating the
message. An example of a trusted intermediary is the D-Bus message bus
when it lives in userspace. An application sends messages (via the
kernel) to the dbus daemon which then relays the message on to the
correct backend. Similary any replies from the backend are sent to the
D-Bus daemon before being relayed on to the Application.

\

The apparmor kernel module mediates communication between the
application and the intermediary, and between the intermediary and the
backend service. However it can not mediate the contents of the message
nor which applications or backends the intermediary chooses to relay
messages on to. As shown in Figure 2, once the intermediary receives a
message from application A it could choose to send it on to application
B, or C or D, as unextended apparmor policy can only control the direct
communication between processes and the intermediary is allowed to
communicate with each of the processes A, B, C, and D.

\

<span id="Frame1" dir="ltr"
style="float: left; width: 5.26in; height: 2.75in; border: none; padding: 0in; background: #ffffff">
</span>

![](data:image/png;base64,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)\
*Figure 2: Process communicating via Trusted Intermediary*

\

\

When an intermediary is involved a few conditions must be met for it to
be considered a 3 layer model. The intermediary must be “trusted”,
otherwise there is no value in extending apparmor support to it as no
additional enforcement can be done and the intermediary just becomes a
variation on the two layer model. The application also must be in a
different profile (domain) from the intermediary and the backend,
otherwise apparmor can not be guarenteed to enforce restricting
communications between the processes.

##### 3 Layer Trusted Helper - Trusted intermediary only {.western}

To improve mediation when communication goes through a userspace
intermediary, the intermediary can become a trusted helper, extending
apparmor policy and enforcing the extended rule set. The intermediary
becomes responsible for determining the type and extent of enforcement
being done. AppArmor “trusts” it only within the domain its enforcing,
that is apparmor still enforces the mediation that is done between the
processes as if the intermediary isn't trusted. Depending on how the
intermediary is extended to support apparmor, it can expand the types
and granularity of mediation being done or it can just enforce policy as
if the application is directly communicating with the backend service.

##### Trusted intermediary without extending policy {.western}

The simplest trusted intermediary enforces mediation as if the
application and backend are directly communicating with each other. The
intermediary performs the permission cross check between the application
and backend security contexts just as the kernel would for direct
communication.

\

AppArmor policy is still required to allow this communication between
the various processes. Instead of using an extension the policy is
written so that each profile involved can communicate with the the other
processes involved as shown in Figure 3.

\

The specifics of whether generic ipc rules would be sufficient are up to
the Intermediary extension that enforces the apparmor policy
restrictions. If for example both the Application and the Backend are
communication with the intermediary over unix domain sockets. The
Intermediary might make the permission query as if the Application is
talking to the Backend directly over a unix domain socket. But if the
Application and the Backend are using different types of communication
channels then it might be better if the intermediary used a more generic
permission query.

\

<span id="Frame2" dir="ltr"
style="float: left; width: 5.27in; height: 1.26in; border: none; padding: 0in; background: #ffffff">
</span>

![](data:image/png;base64,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)\
*Figure 3: Intermediary enforcing communication restrictions without
extending policy*

\

##### Trusted intermediaries with extended policy {.western}

For a finer grained control of the services the Intermediary provides it
is possible to extend policy in a manner similar to that used for
trusted Backends.

\

dbus

policy kit

\

- Backend fine grain not part of the Intermediary

- dbus example

\

Extending the apparmor policy for Intermediaries is similar to extending

\

- can be done by intermediary storing acls instead of updating policy,
just as in 2 layer

\

Simply extending the intermediary to enforce existing apparmor policy
often does not provide as fine grained mediation as could be possible as
the existing apparmor policy can not express the full semantics of what
the intermediary is doing. In these cases apparmor policy can be
extended (see ???) to add a new class and the intermediary then enforces
this policy extension.

\

- doesn't require app communicating with backend over socket rule

- extended type

- abstracting new class to include the class and the socket
communication

\

<span id="Frame14" dir="ltr"
style="float: left; width: 7.3in; height: 6.8in; border: none; padding: 0in; background: #ffffff">
</span>

![](data:image/png;base64,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)\
*Illustration 1: 3 Layer model: Trusted Intermediary*

\

bar

\

##### 3 Layer Trusted Model - Trusted Intermediary and Trusted Backend {.western}

\

fooo

<span id="Frame13" dir="ltr"
style="float: left; width: 7.3in; height: 6.8in; border: none; padding: 0in; background: #ffffff">
</span>

![](data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAY0AAAFyCAYAAAAJY4YdAAAACXBIWXMAAA7BAAAOwgGTvDguAAA5kUlEQVR4nO3dB5wTZfoH8GfZpXk0pRywdJYuqIB4CqgIiEhdpXMCnhQREKWIgrC7oKjH4SH8VRYsNBsdAQUrRRRZARWkCEtvSlFYTtrC/ueZYbKTySSZJDOZkt/3Q0gymbx5s5PMb96Zd94k5OTkEAAABJeWlubaFWZKSkqcnvkSzK4IAICbdBgw0uoqGG5Z+iTd8yI0AABAN4QGAMS8uLg4z26nnJwcXbtpYhVCAwBAQRkgDCHiLUH9BwIAgFzKdWRqaqqFNbEHsaWBJAWAWBZs41leR7q595Re2D0FAKABG9PaEBoAAAoIi8AQGgAQ8xAU+iE0AABAN4QGAADohtAAAADdEBoAAKAbQgMAYh6GEdEPoQEAoIBhRAJDaJgIQ7QAOB+GEfGG0DAZtlIA7A/DiOiH0AAA0IANPm0IDQAABYRFYAgNAIh5CAr9EBoAAKAbQgMAAHRDaAAAgG4IDQAA0A2hAQAAuiE0AABAN4QGAADohtAAgJiHUW71Q2gAAChglNvAEBo68CBlKSkp+OA4SLjLDCMTgxpGufWG0NAhnJUPr7S2Hv8fAscikSyzZemTwno+OFegjQVlSwOj3CI0TMEfrA4DRoq3+RrBYX9YZiDD7qjAEBoGU658ZFgJ2RuWGSAo9ENoGEhr5SPDSsiesMwAQoPQMEiglY8MKyF7wTIDCB1CwwB6Vj4yrITsAcsMIDwIjQiFsvKRYSVkrXCWGQBIEBoRiGTlg+CwRrjLDMsLQILQCJMRW6tYEUVXpMsMywsAoREWI3dvYEUUHUYtMywviHUxHxoNNw8Qz/D8oUG6rpWAGfvDQ1kRhVpfN7J6mYUaHFhm4CYxHxoyPV9sMw+gBlsRyfWDXFYuMywviFUIDRXll125MopGjxv1iggrHn2sWmZawYFlBm5ni9Cw6xdNrle7FWUpWl00+XX0/D3M/ptFuivFqmUa7WWmd3kxqz/n2D0GRrBFaDCrPtD+vshe9WkQvb79PMLqDynpQbdczfx7GbVyM6uOdlpmepeXT/2izOrAgvDVL1uIthw7b3U1PGwTGnYQ6EvNuyDMXglpDcmtrBO++L6sXGbBlhfDMgO24evPaUjPZJoyewHd3bJ1wHnVIWGnwGAxHxqhbP2ZuRLS8xsO2L0gscMy0/ubG1hmwOa/m07NH+xAC2bNCBoadhfzoREqM1ZC+NEfcxm9zLC8IBTHDh+kE0eP0PufbaDuLe+io4cOUGKFSuJjmbt30IQRg2nnth/pyuXLnudwa4NxK0NueRzM3EP9O7Wm5Rt/oXz589Olixep/Z03U9qUdHpn2mT65cfNVK5iZRo3+XWqc2sD094PQiMMRq6EsAKKDqOWGZYXhGrB7JnU7+lRFB8fT/2HPSvef2rsi+JjqU8PpAcf6kozF62ivPnyidP8HcOoWLUa1bmtIS15fxZ1fXSAeH1z/dvprSn/po49etPr7y+lTRvWCiE0iD78YqNp7wehEaZIV0K88pHLMbJe4J8RywzLC0Jx+dIlWvbhXJr9xhTPtKI33kRPPDNObC1wSyO556OewAimzxNP03MD+1CHbo/QnDen0MvT59DAru1oy9ANNG5of3GePHnymPFWPBAaEZBXQnw7lBURVj7WwTKDaFq9bKG4q2javMWeaUP++ZA4vV2XnpRUsw4tee9d6tSrryc4ChQsSKd+/41KlPq7T3n1Gt5Bpcom0lO9u1DpxPJUr0Ejqln3Fkru0YdatE0Wn2s2hEaE5BWJ3i1YrHysh2UG0fLRu+k0cOTzXtO6/etxmv6fF8XQ4OMP44cPov+OH03Z2dnibqnOvftTx8a30F//O6+5m4pbG08/2pX+O2u+eH/C1Jn08uhh9O/nR9D5rHPiNDN7XCE0DKJn1wdWPvaCZQZmm/fpOp9pje+7X7wwbmnMWbnG6/Gnx70oXmTqALinVRuvaWXLV6SpcxcZWOvAEBoGCrQSwsrHnrDMAEKD0DCY1koIKx97wzID0A+hYQLlSggrH2fAMgPQB6FhEnklFM7KBz/yY41wlxmWFxhNPlfDbuNOMYSGicJdkWAFZJ1w/vZYXhCMfIZ3Qt68VKFyEj2dMpEaN2sZ9Hl2CwyG0DBJXFyceC5ATk4OVigOgWUGZuIAuHr1Kn3z5WoaP2wgrd661+oqhQWhAQAQRTyciOzXHdvFYT8yd++kpJq1KeXVN6hqjdqex5W7p9TjVM36+EtKGz6IFq7J4A0ecZ4Od9Wj1+YspEpJ1U2rP0IDACAKOAB491T5SlVp7H9eF6eNH/4Ete3cgzp270VLP5hDacOe8DlvQ6Y1TlVlIRy+XLlUPBt86/ffimFhZmAwhIYJ5N0c8m3s7rA/LDMwm9bxiX2/7hSHAMlfoIAYHFNfHOf3+VrjVD05ZjyNHvQvMTRWLvqAHnn8SVPqroTQAACwSJXqtWj5gveobaceYkujao1afufVGqeqQpUkcWyrL1YsocP791HDu+42vc4IDQAAi4yd9H80YeRgejX1WTFAxk1+w++8WuNUscdHjKZO9zaiYakTo1JnhAYAgMn8dZ2tcXM9zfGp5PmVz9Map4oVu6kE3XF3M2rVobMxlQ0CoWEw5b5x5TTsI7cvLDNwKj64XqDgDTRp5jxKSIjO6hyhYTDligYrHmfAMgOnsuLkP4QGAADohtAAAADdEBoAAKAbQgMAAHRDaAAAgG4IDQAA0A2hAQAAulkSGg03D/A5mUqe9kODdPSRt4B6mYS6PLBM7SfSZQqgBS0NAADQzZLQ4C0drS1TbAFZR2uZhLI8sEztJ9JlCqAFLQ0AANDNstDwt2UKzoVlCuB+tmlpoNlsPeVK34jlgWVqPaOXKYCloYEtU/fBMgVwN9u0NAAAwP4sDw00me0Fu6XcB8sDjKQZGlq/ZOYmbvyRnbS0NFcvs5SUFCwzB3Hj8gKJ35bG3qrRrEb0JGVaXQPzpKSkWl0FU6SlpVpdBdMsb3vM6ioYrt2KslZXAUxk+e4pAABwDoQGAADoZmloVNtHtKeKc8qF8OTJQ3Ttmu9tMNaW22dS/Yx+PreNKhOAhRUavFJmwvefygkljChO1PpvBtYKdMmTJ881QZ7A89hrJW2nutjFuW8P096hq6jqq62oaNMKhpQZ7opeHRIIDFALu6XBW/Lc9eO7C0RDf0NoAITr5IIdVOy+ynRy4Q7DQgPALIbsnioW732fWyLc345bIeNLEjUpKITMZaLRJ4l2XCISbnrtPvpWCJ7hvxMNu4moUQGiMcJ824T5yuclmig8v17+3HKfupHo7bNEBYQXeL4E0YNCWO0QChwpPP/IFaJHihrxjpwnLS2N4oXlMHkyUUHh7z1lClG3btJjea63RXgrf+9eov79iTIyiKoIy+Ctt4huv12aZ8gQounTiS5dku5PmCCVly8f0dSpwt95B9G0adJ9vr71Vu2ytm4l6t2baP9+osGDveup3lUVJyzHSpWk123Z0rsea9YQ9e1L1Llzbs/UatWq7VmxYkXbGjVq7Db5TxoVl49l0eUT56nWvIdoR89FdPloFuVLLCw+xlv9f+99C52c/wvlK1uYKqc1o4I1ivudrqRsMVzM/IMOvriO/tp1inKuXPPahcVfVC6j4nNNac/gT3Knk9TKUJZzYc8ZsRwur0DVG6nS2HvEa56n7OMN6bd5P1Nc/niq0qxNVP52YI2wQ0PeRSWs1+n/Sns/JrdCMi4SjRMCYFV5omeF6/aFiN5LFD6kinmXnSd64w8hCMoQ1RYe6HFMWEkUIXpHmHfjBSlAlpfLnb+osGL8riLRJqHs536XQuN5YZ4ewnMeFr5rC7LCfUfOd6MQqMePE61dS/TYY9LKWb17iqfzZdUqoq++IuonrA9+/FF6rGFDYcVwIXfeYsWIjgnLY906onbtpAA5elS6z2VwUGiVNWAA0cCBRH36CMv1bf/15XrlCB+U9euJHn9cCiVlPbjuNWsS7dy5U5z+zTffNKlZs+YutwQGO7loJ5XpW58oPo7K9msg3N9BiU/e4Xk8X+lCdMvnvejUsl10cOJ6qjm7Y8DpWg5MWEs3PZBE1dPbUVze3L2ZYhgIf//zW4/ToZe+8QkJtYMvrKPibapR8fY16PTHu8Vya86SXje+cD6qt+qflLXlOK0eszrivwvYV0S7p5i88r7veqv6/XPCFuefwsorm0j4R3Ij5FehNdC1iHdgMH7um6WlwGC/CFu5GcK0Z36X7qt32PcsIrVimgpb079dvV4XoexOQmDkFx7oLFyPPxXuu3K2J56QttxbtZJW9lq2bJFW0rxCZ3kUf+AePbzvy+Xdfz/RFaEVN2hQ7n0Ojz//1C7rl1+IHn1UaA0WkELlySd968EtiUmTiA4fFj4nwgclXtFaVdbj5ZeJmjXbIN6eO3fuI8OHD58c6t/FrrKFN84r/d/m/OSZFl80v7jVHpdP+oOUaFdD3Hov0aEmHZn6vWc+f9O1XNh7hkom1/IKjFNCWJ2Y+5PYyqGrOWJoBXMh84z4evy6HBxHp23yPFaycx3xi1nkznK0NyuGt9xigCG7p84ptmQnnSGaUoqoUUHpeMeAE9L0GkIofCQESvei3sGRXkbatTS+hLAyEloNtfMTdSkiHSMpoPE51vpoVxMKXCx8Th8SAmNRDH9e4zT+OLyr6oSwDEpfbw3edpu8y0d6TCletZtRXZ76vr+y6gjrj9mzpV1Us2Zp1/XZZ4k++IDonnukVkr79tr1qFaNqGzZsrRw4cJOe/fuTbr33nvXaJfoPNu3b6e/1SlFSa894JnGB8TPfJZJxdtWF++fXvmrsHVfnU4t300Fq97kmc/fdC0Fk26ik0t2UsmHa3uC48i076nKxOZUqH4Zyso4RpnDpNYBB0L26QuUULygbznC68ivyy0N3jXlgfO/Y0ZEu6f4c1JGKCG1RO70vkIoPC2EQEHhwe5FcqfzsQk+pvHyaakFIrdUuMXwrhAc/Y9LrZNJQuCknZJaC+evh1Gw7rMvlJSC5yWh7F4xekzDH24tVBfWP+fPS7uD5syRjjPw1v+5c9I84fZo8ldWeroUGMOHS8cntIwYIbUobrhB2jUViBAUQitn0OuTJ08eHl5N7SkjI4NKjarnNa1U1zp0bMZmT2hcOpZFP7WYIx7n4GMXMn/TtfCxB96VdGTKRrFVwbufSj9yC+0f8xXlKZBAJR6ulfv6Qoth+0Mf0bW/rvjspqo4uqm4K+zwq9+JAVLx+bsj/ROAA4UVGoFW4oNulC6ywddvVxdaAwsTtcupJTy2vmLu9JmqYyT+Xle+z7u2ViqOe4wIvOHlGsrutikpKcL/qYrHpGveBcQXGR90XrFCq6zw7muVxS2Qn3/Ovf/SS77Pe/556SIbO1b7ddgNQrK0aNHii27dun3o+6hz9evXj5bf5b0fschd5cWLLHFwI/GipjXdX1dZbhHIxx5kpR+7TbzIxOMqXO7QO8SLVjl8sF3r2Ik6XKTPorMox9tz49h0RsIZ4WBrfGwjb96XaOnSpfMSEhKyra4PuJ96wFaEiDeEBtgatzzS0kZT69atP7W6LtHmrxeT3U+4S01N5YtrRvBVhgi/t1iH0AAAQ/GK1WlDowf6OQhlS8PNw9nrZYvQiGSsKIwzZY1Ihiex29AmsSKScaRiaQwq7I4KzBahAQBgJQSFfhGFhtbQILsuS2dx82PcY+qlktJ5FP6GAJHPLJevvyivPYxIyimifxSUzt/49H/S2eLvn/N+LlocwfGJd3zmNp/kd/mytMXPPZ14Gj92883SWdx8rgW3CMaP9x6apEuX3BPv5Otff9UeToS7+953H1GnTkQLFhB9/bV0Up/yuWhxBKc1DIjeIT3KD7+LbmxZxTM0iHxdZ3FXqcwdJyl/YhGx++wNdUrSoZe/oSK3J1Kx5pXpjy/2UdYPx8QTAZXPjZUWB2iLKDS0hgbhEEkuLJ2hvTCL6LmTuV1ttYYA4RW9cheTv2FExgoh0+840ZmrQrAIoTGzDFFaCeyeCtW//kXUs6c0rlO+6wuNT9Dr1Ut67J13pLO4N26UHlMPTcKhoR6ehE/Q0xpOhMeratOG6HdhWS9bRrRyJdEbb2D3VKi0hgHRO6THQWE6h4Z6iJBf+y8Xz+6+cdqDlJVxVAyQWu8/TBVGNqY9Qz+lK2cu0J9rD1C111pThWebxNTuKQgsotDQGhqEWxhdrg/pwcEx6XTuY1pDgKj5G0aEK9q/mLByE1Zg8xOxXy1c27dLK/V8ioXGLQwODh72g4ODz9aWRTI0SYKwkEaNImrRgmjDBuk+hE5rGBC9Q3pcOfmXZpncajmwdQ0dSF0jTchzfe9MfByV7n0r7XliJdV4u72u4UUgtkT0NdYaGkQe0iP5ekujmmLl5O/jx7urTgohUjLe/zAiF3KIXvtD2BIWWhiTT0vX+eK8nwvB1a0rtNJmSmdhy8EhD/vBrQ1uafB9mdbQJEw5PIm/4UT++otP9JJaIGPGEH36qbAxkd93aBMITGsYkHCG9FAOEXJDjRJUoqPQ0mhRRZwuu3Yxm46l/0BJ01rT0TcyqNrU1uI4WIGGF4HYElFoaA0NwkN68KizE09LgcHzBMMtkJaHiP4nBMPXFbSHEZkg3B8ifC8aC5/ZaznSPC+W9H4udlMFx8cbeAXPw3jwQIG8m2jGDOmYxLBhUmDwPMEohyfZt097OBG+z6HBLY2rV6UhRfi11EObQGBaw4CEM6SHcoiQm5d1o0P/3kCHJm2ga/+7Ij7O5R6e9C2V7d+ACjdKFL9ofL/CmKYBhxeB2BJRaGgNDcJDeixO9J3X3xAg7Nni0kWmNYyIMnzuuUG6aD0XAuMD3fLxChn/LsamTb7zBhpKRD08idZwIsrwad1aumg9FwLTGgZE75AeyvvqIUKSpjxAahXH5oaPckgT9XMhdmEvMwAA6IbQAAAA3RAaAACgG0IDAAB08xsaSZnRrAYYIS0t1eoqQIjarShrdRUgRMvSY7sXh2ZoYBwW53HaqKKAZeZEWGY22D3VcPMAcajhHxqkx/zCsAMjlgeWqb1geTiPPFS7HTfgLQ8NAABwDktDQ94CAvfAMgVwN9u0NHhlg+aztZQrfCOWB5ap9YxepmA+5a8I8m277aKyLDSwReo+WKYA7meblgYAANifJaHhb4sUzWfraC2TUJYHlqn9RLpMIfqUu6aU0+y0i8qS0FB/aPFBtp7y7x/O8sAytZ9IlylEnzIc7BYWMuyeAgAA3RAaAACgG0IDAAB00wwNrYMxZmrwQ/+ov2a0OPF9GbE8nLxMnVrvQJy8PGKZnZaZfHzFFgMW8kE6Ox7wiZRdD2QFY8TycOoydeoyC8apyyOW2fWziN1TAACgG0IDAAB0Q2gAAIBuCA0AANANoQEAALohNAAAQDeEBgAA6IbQAAAA3RAaAACgG0IDAAB0Q2gAAIBuCA0AANANoQEAALohNAAAQDeEBgAA6IbQAAAA3SwJDf5BGH/TfmiQbrsfHYkF6mUS6vLAMrWfSJcpgBa0NAAAQDdLQoO3dLS2TLEFZB2tZRLK8sAytZ9IlymAFrQ0AABAN8tCw9+WKTgXlimA+9mmpYFms/WUK30jlgeWqfWMXqYAloYGtkzdB8sUwN1s09IAAAD7szw00GS2F+yWch8sDzCSZmjExcXlCPx+0Phx86oUuUB1d6u0tLSclJQUv++bH49mfUIVqO5u5eRlFovLiwVaZmYsLyPLNGqZaYaGv5WuHBZ7qxrx0uaR6xlL4RHsg5ySkhrV+oQqLY2u1zN2VkbBltnytseiW6FQKFZmsb7M5OXVYcBIQ1/L6PLSDFpmunZPOSUsZHI9YzE8ZE4JC5lcz1gMD5kjwuI6rzoGaTG5GS8zo1fuZlHWM1grN5CgocErXqeEhZoyPGIpOKQPRKrV1QiLMjxiaUXEy8wJYaFFrHcMBoeTAkON6x1ucAQMDScHhhK/h1gJDicHhhK/h1gJDicHhixWg8PJwg0Oy3tPAQA4jZNbGZHyGxpuaWXIYqG14ZZWhiwWWhtuaGXI0NpwnnBaG2hpAACEIJZbGczveRpuamXI3NzacFsrQ+bm1oabWhkytDacJ9TWBloaAAA6xXorgyE0AABAN4QGAADohtAAAADdEBoAAKAbQgMAAHRDaAAAgG4IDQAA0M01oVFtH9GeKlbXAvTKk4fo2jWrawFgT/XLFqItx857ru0kotDgFbVapCturPzNwytqtUhX3Fj5AwTHK3+WkDcvVaicRE+nTKTGzVoGfZ7dAoNFFBryyh0remeQV+5Y0QNEHwfA1atX6ZsvV9P4YQNp9da9VlcpLKbsnuIQ6VWU6IOzRDuq+IaKfP/NP4lmCZcz13yfz3ieg1eIxpwk2naJqHxeooklierlF8q9TDTyd6IjwuOPFDXjXcQODpEhQ4imTye6dMk3VOT7EycSTZlCdOqU7/MZz7NX+B7070+UkUFURVh+b71FdPvtRFu3EvXuTbR/P9HgwVF7awC2Ex8f77n9647tNGHEIMrcvZOSatamlFffoKo1anseV+6eyty9Q5h3MO3c9iNduXyZZn38JaUNH0QL12TwmHriPB3uqkevzVlIlZKqm1Z/045p1BVW7GOCtD5m/EE0ugRRe6Hllv/6UFnqgHlOCIzORYjeEebZeEEKkOXliJ4XrnsI0x8uTLQgy6x3ETsaNiS6cCHwPK+8QvTqq0Q9exIVKCBNUwfMY49Jl1WriL76iqhfP6IffyQaMIBo4ECiPn2I3n7brHcBYF8cALx7qnylqjT2P6+L08YPf4Ladu5BHbv3oqUfzKG0YU/QnJVrNJ+f+vRAevChrjRz0SrKmy+fOK2yEA5frlxKLdom09bvvxXDwszAYKaFRjthJa+xC51yFLfHC62GOUJr5OXTwlao0Fp48kbf+X8RtnwzhBbFM79L9+Uy9wgtjU6FpbDpLFyPP+X7XNCvRw/tYx45igXGLZFp04QW3kiioUN5BFrf+bdsIVq/XgoHJpf5yy9Ejz4qhQ2HypNPGv4WAGxN6/jEvl93UnKPPpRf+GJwcEx9cZzf53NLI7nno57AYE+OGU+jB/1LDI2Viz6gRx43/4tlWmjEK27/XbizXtiKbVTAu1XAwcKX7UIw9DgmhUYBIQROXiUqeb2A2kKLpYvQomj9N+kxWTXh77ZYKOshITAWoaURMUWLmcqWJVq9muiee7xbBd27S5fNm6XHODQKFiQ6cYKodGlpnttuI+rbVwjyztJjsjp1iGbPlnZRzZoVlbcUc7bcPpPqZ/TzuW1UmWC8KtVr0fIF71HbTj3ElkbVGrX8zptUsw4tee9d6tSrryc4KlRJojq3NqAvViyhw/v3UcO77ja9zlHpcsu7oEYJLYWLwlZrv2K50+VjFzcJW6NPXG9l9BQCouUhov/lSLupJpUiSjsltSTOX98NwtNfKCkd03jptHT8BIzDu6C4VcC7q0YqRoGWWw0lhOU5Zox0+4kniKoLreHz56XdVHPmSMcsuCVx7pw0D09PT5cCY/hw6fgJ5Dr37WHaO3QVVX21FRVtWsGQMsNd0atDAoFhrrGT/o8mjBxMr6Y+KwbIuMlv+J133OTXafzwQfTf8aMpOzvb03J5fMRo6nRvIxqWOjEqdTYkNNQ9p9T3H/ybdJENLKY9H3u2uHSRlRNqOLO073y1haBdWS73/oibQqqyo/APR/G1UT8epe45pb7fpYt0kY0erT0fmzRJusgqVSJascJ3Pm6B/Pxz7v2XXgqpyn4Z/bexwskFO6jYfZXp5MIdhoUG2Iu/rrM1bq5H8z5d53d+5fO4paF1vKPYTSXojrubUasOnY2prAbl98w1J/fFAjesII0i/y2c7vKxLLp84jzVmvcQ7ei5iC4fzaJ8iYXFx3ir/++9b6GT83+hfGULU+W0ZlSwRnG/05WULYaLmX/QwRfX0V+7TlHOlWteu7BI+CRxGRWfa0p7Bn+SO52kVoaynAt7zojlcHkFqt5IlcbeI17zPGUfb0i/zfuZ4vLHU5VmbaLytwPp4HqBgjfQpJnzKCHB2NW5v+8YQsOBlAszlgLELUGhdHLRTirTtz5RfByV7ddAuL+DEp+8w/N4vtKF6JbPe9GpZbvo4MT1VHN2x4DTtRyYsJZueiCJqqe3o7i8ub0dxDAQ/qLntx6nQy994xMSagdfWEfF21Sj4u1r0OmPd4vl1pwlvW584XxUb9U/KWvLcVo9ZnXEfxfQx4yT/4J9zxL0zAThM/tvK5efmppq5stYit+bcAn4d3TiZ5j3S/NK/7c5P3mmxRfNL261x+WTeiaUaFdD3Hov0aEmHZn6vWc+f9O1XNh7hkom1/IKjFNCWJ2Y+5PYyqGrOWJoBXMh84z4evy6HBxHp23yPFaycx2x1VLkznK0Nws9U5xGz3eM8fcsQWtLNVpfQLPOJLfLGepGtQL8LQ9l+fzbxUa8lhmU53KEczY6f6DlH73X87dwiu3bt9Pf6pSipNce8EzjA+JnPsuk4m2lvvanV/4qbN1Xp1PLd1PBqrkH7vxN11Iw6SY6uWQnlXy4tic4jkz7nqpMbE6F6pehrIxjlDlMah1wIGSfvkAJxQv6liO8jvy63NLgXVMejvvrO5+R41Pp+Y6xsI9pyL2e+OPHB6pHFJe6xIL5lCvHPHnyXBNonQ5DufPYa8iQSOuifP9ObF0oZWRkUKlR9bymlepah47N2OwJjUvHsuinFnPE4xx87ELmb7oWPvbAu5KOTNkotip491PpR26h/WO+ojwFEqjEw7ndPEsJLYbtD31E1/664rObquLopuKusMOvficGSMXnze/e6STLPpxLH7z1Oh3an0kl/16G+j41itp16Wna65k1LpV6A0z9PQv7mAZvyXNJ310gGvobQsNMTtyKjgan/1369etHy+865jWtyF3lxYsscXAj8aKmNd1fV1luEcjHHmSlH7tNvMjE4ypc7tA7xItWOXywXevYiTpcUrTO+nS5RfPeoQWzZtDoV6ZSjTr16ORvx+mtKa+YGhrRov6eGXIgvFi8931uifCrcCuEz/puUlA6g3v0SaIdl4iEm167j74Vgmf470TDbpJOANQaa0ou9ymhRfz2WelEv+dLSF15MQ6VuHtKPEFv8mTppDoeI6pbN+kxPWNDaY0/NWGCVB6fRzR1qvB33iGdEc73+frWW0MfZ0q9q4qHzOFuuvy6LVt612PNGvlEwdwNnWrVqu1ZsWJF2xo1auw2+U8KoNsHb71J46fOoNr1pCAuV7Eypf53unjb3/hSvFvpiVHjaO70qZQ3bz565oVJtO/XXfThO9OF+3lp1IuT6Zn+j9Cjg4cJ09IpsUIlGv/aDKpZ9xaxXK3dUoeFVs6EkUPolx83i3Xgczv45D+et9tjA2nhnLdo08E/InqvYYeGvItKWK/T/6nOo5BbIRkXicYJAbBK2HB69qQ0xtR7icJKRzHvMuE9vyG8h7fLSOde8JnhWmNNyYoKK8bvKhJtEsp+7ncpNDAOleRGIVCPHydau1YaqoNXznrHhmLq8aeKFSM6JiyPdeuI2rWTAuToUek+l8FBEck4U1wvHqaEhx15/HEplJT14LrXrEm0c+dOcfo333zTpGbNmrtiJTD89WLCCXf2c+zwQapSrabmY4HGlypcpCh9tnUvbdm4gYb27kTDUl6i1Vv2iPfThg8U5ymdWJ6+3HZAeO5seuGZIZrndci47I49etPr7y+lTRvWimH14Rcbxcdq31KfNu4/HfF7jWj3FJNX3vddPyfp/XPCFuefwsorm0j45xlO5FehNdC1iHdgMH7um6WlwGD+xpqS8Rnj3IppKmxN/3b1el0wDpWIz87mLfdWraSVvRZ/Y0Mx9fhTcnn33090RWjFDRqUe5/D488/wx9nilsSfFLg4cPci8h7GBNlPV5+mahZsw3i7blz5z4yfPjwyaH+XQDMVrZ8Rdq3Z5enpaEUaHypLn36iyPU3nlvc8oWvmRdHx3guf/7celL3L7rI9ef21t47tiA9eARcLcM3UDjhvYX7+dRfKFbJ3fxuh8uQ3ZPnVNsyU46QzSlFFGjgtLxjgEnpOk1hFD4SAiU7kW9gyO9jLRraXwJYWX0N/9jTcm0dmJjHCpJnMYfR+/YUCxetZtRXZ76fiTjTD37rNCk/0Aaw4pbKe3ba9ejWjUeC6ssLVy4sNPevXuT7r333jXaJQJYp3vfgeJvZIz59zTxmMbvJ47R26/9m1JefTPg+FJxqi+V+j7j57br3JOWz58nlhUI77rigOIBDAuovuDx6i94mCLaPcVvr4xQQmqJ3Ol9hVB4WgiBgsKD3YvkTudjE3xMg0e05RaI3FLhFsO7QnD0Py61TvyNNRUIxqHyT+/YUOGIZJypESOkFsUNN0i7pgIRgkJo5Qx6ffLkycPDqymAuR7+57+ElXICvTByCB0+kEklS5elfk+NEh8LZXwpLccPH6RmdSqIxyj4mEYgE6bOpJdHD6N/Pz+CzmdJX0qje1mFFRqBVuKDbpQussHXb1cXWgMLE7XLqSU8tr5i7nStsaa0Xle+H0vjUCkpu9tKPVZSFY9J13rHhgo2HpW/+6GOMyU/7/nnpYts7Fjt12E3CMnSokWLL7p16/ah76MA9sC7nviiFmx8qUD3+QD2kNHjxYu/5yufx7vJps5dFPS1IoFhRMDWeBds3rwv0dKlS+clJCRkW10fgFiH0ABb45ZHWtpoat269adW1wUg2sw6gS8SCA0AANANoQEAALohNAAAQDeEBgAA6IbQAAAA3RAaAACgG0IDAAB0Q2gAgGHarSjr+QU4cIZl6ZNCWmaaocE/usG/1rS3qnEVs4OkTOf/cI8/vNDT0ignJSXV6qoYKi0t1bUrIfF9paXlLG/rZ0hisB3pe5aW02HASKurYhm0NADAEGhlOE+orQzmNzTc1tpwcytD5rbWhptbGTK0Npwn1lsbaGkAQMTQynCecFoZLGBouKW1EQutDJlbWhux0MqQobXhPLHc2gja0pCDg287LTw4LFisBIZMDg7pdqrFtQkNhwWLlcCQycHBt50WHrHaynBycITbymC6dk/JK105PJidAyRWw0JJ/kA4JTxiNSyUPO/dIeHBYcFifZmlXV9ezO4BwmHBIllmIR3TUK6ElQESSHp6Og0YMCDUekUkUFhwvWMpTNThYYTU1FTxYqRAH2L+UsbSikkdHnblb5nE7PIi6b1bWZdgjFhmYR8I17vinTFjhq1W0naqSzQZ+SUWAiOqK4VYWgEpOfV9O7XeRnDqe4/45L5oarh5gJjMPzRId+QfG8Du8B0DI1keGgAA4ByWhoa8BQQAAM5gm5YGBwiazwDGUm6Y4TsGRrAsNNDKAABwHtu0NAAAwP4sCQ1/rQw0nwGMo/U9w3cMImVJaKg/tPggAxhP+Z3CdwyMgt1TAACgG0IDAAB0Mz00+vfvjyYxAIBLoKUBAAC6ITQAAEA3hAbooh4KX3k/VkcOBohFCA0AANANoQG6KH/2Vz3divpAaHCOBhgFoQEAALohNCBsaGUAxB6EBujmbxcVAMQOW4QG9rc6D1oZALHJ9NCYMWNGDs4KBwBwB1u0NMA50MIAiG0IjRiXlpaWk5KSElIQhPMcAHAHhEaMCycwBgwfnYbgAIhNCA3QTQ4Mvo3gAIhNCA3QRRkYMgSHc+CX+8AoCA2ICIIDILYgNCAorVaGEoIDIHYgNCCgYIEhQ3AAxAZbhAb2t9qT3sCQITgA3M8WoQH2E2pgAEBsMD00MISI80QSGGhtALgbWhrgxYgWBoIDwL0QGuBh5C4pBAeAOyE0wDQIDgD3QWi4FPdIk2/r6Zlm1oFvvcERan0BwBoIjRigXCEz9UrZ7J5SWsGhrhNAuPizFe5z09PT6cSJE577wmdUq3yKi4ujunXrUnJyst+yJkyYQGPHjtX1ulym8rXeffddOnLkiO7nm0HvHgHbhIa8EtG7lRnqSsfKcu1SV63ntVtRlqLRtZZfQ299Q3lfbvy8hFqunjLd3nrrMGCkz7T6ZQtRUs06NP+r78XbrGmLB8Tr1+YsFK955a30TcaPlHXuLE2fv8IzjedZ8f0v1K3lXZ7XSW56Gy1Zv5XGDulHnyz+kDYfzRLnW/X1enrzw49pZN+ennL4tUsnlqNPMnaJz+1y3x1edebHW3XoREs37jDyTxKSZemTdM9ri9AI5wNt1pfAjHKtqGuglY7X8xpE55yM9MkTU35ISdfV0nDLMrBjubHmwN7dntubDv1JjZNK+cyz5dh5T6is/3IVZV+54jNPm0a1qdfAoeLtng80oUP79oq3v1i5hJZu+Mkz34MPddUs58TRI57b+/fs8ip7ZcZOevju+iG/N6vYIjTAXMFWQNwsNTM4ODDUTV91nbC7CsxQKamG53ZCQgI1anJvwPnvub8Nfb58sc903j31Y8ZG8faZUyf5FyzF2y3aJFPHxreILQ229IPZ1K5LT7/lyHXK3J3bqiiTWJ6ys7PpfNY5KlS4SEjvzwoIDZcKdUvVrODQCgwt2LIGM/CuKcatCTZtnveKXJ4uX7NX0udoziP79Ifc1suEaTPFC8s4fJbi4+M9ZcjlqJ+/4OtNPvVs0TaZmtetRN8fOKPznVnH9NCYMWNGDs4Kj016AwPADOqVtdnkwAjHxNffIeKLA6ClAR5GtjYQGGBXfPxCPo6hJ1h6tGpMu7f/LO6SCuV5boXQAC9GBAcCA+xI7vGkNLRXJ/E6c/dOOn3yN/F2iVKlafnG7Z55dm37idSUvaNk8sH0/AUKaJbjFggN8BFJcCAwwI6UPZ6UNq77Srxu06k7HTmwX2xNVKhS1Wc+ZQ8r5q+XVYduvejooQN+y3EDhAZoMrtHFUA0KXs8Kcm9qe4QrsuUqyDerlCpStDy/PWO+sfdzejQgX26y3EihAb4FWpwoJUBdqXs8aTVYyoQ9fzydbBeVm6F0ICA9AYHAgMgNiA0IKhgwYHAACcJtfdUJPMZ0dMq1PqaDaEBEUFggFOE23tKphzLSjnmlHoe5ThT8rTmD3bwGotKxj2tSpVJpGXXhyJR98qSx6ny9z7ksrj8ixf+omnvLQntjxIGhAbootXaQGCAU0Tae0omj2WlHnNKSTnOFA8/wmd5N6le2qu3FY+D1ahCMbp08SId3p/pma7ulaUep0rrfYycMIn+m/YcfXT97HezITRAN2VwIDDAbDyaBF8bMaKEUb2n5LGs1GNO+dOoaTP6R+Xi1LxNR6/eVjwOlhZ1ryz1OFVa7+PIwf3UsXtvqqwYZ8tMCA0ICQcFf5nLlCnj+VIHI3/pg/0Yk97y1OWCuyk/F+EucyN6TzF5LCvlmFNa88l4mHSZeiwqrfmVY1Yx5ThVWvPztLuqlqI5K7/W9V6MYHpo4IvtPuEu02AtE7M+K2aFkRnlOqmuVpRrZOsjVHY4CK3l28zfo/p6aGmA65m1gjGjXCfV1exyAwVSqGGl7HnkrxdSpL2Twnm+nnpFQ2pqKl90/U0RGhAyjFwMVlN+/vT+3Cv3RJqvOFis7Omk1UupW8s76ddftokrcvUv8bF+T40SD1y/v3qD5znKXlVa41MxufeT8jXVr6/sFSWXoayP8rYRODQc93OvAAD+GLGRovwVP5nc00ndS4kl9+hDG9d+Kd5W92riHkv/GfcMjXpxstdzlL2qtManUvZ+Ur6m1utzD6sm1f7uKUNZH+XtaENoAIAtGd2arRSgd5G6lxJ7ZcxwqnNrA/G2uldT207dafp/XqTWyV28nqPsVaU1PpWy95PyNbVen3tYKctQ1kd5O9oQGgDgesrdOFq9l7R+TU/9a37q3k9rdx7RnF/uVaXuCcWUvbiUr6l+feX4Vlq/AGjlQXmEBgAA6IbQAAAA3RAaAACgG0IDAAB0Mz000KcfAMA90NIAANdT/yaFXX6bwokQGgDgev5+shVCh9AAAADdEBoQMhyjArvjHziq26ARvb3kM6ur4joIDQBwHR636bmBfXDswgQIDQBwpbWfraSVGTutrobrIDQAwHXOnztL2dnZVCaxvNVVcR2EBgA43rL0SV73X3jhBapVq5bPdIgcQgMAHE3rx4OEaVZUJSYgNAAAQDeEBgAA6GZ6aKBPPwCAe6ClAQAAuiE0IGQYuRggdiE0AABAN4QGADhaWlpajtV1cAOtrstaEBoA4HgdBoy0ugqOFspJkAgNAADQDaEBAAC6ITQAIGb1aNWYdm//mXJypMMiWsOo//OBpjRv1Xpd5fFQ7P7KUc4Tyk/OPpZ8P23bvEkc7t0OEBoA4Eq8Uk6qWYfmf/W9Z2XetMUD4vVrcxaK17u2/eT1nJF9e1LWubM0ff4K8f62LRm04+et4nXd+rdrlivfVhs7pB99svhD2nw0S7yf3PQ2WrJ+q6cMNrRXJ6/68PTSieXok4xdnvutOnSyTWAw00MDffoBIBy87uDrSNYfB/bu9tzmFW/jpFI+88hb/Wz9l6so+8oVz2NrVi2nwkWLiddyaKjLVd5W+mLlElq6QQqlng80oUP79oq34+Li6PsDZ6hRxRtp47qvfJ534ugRz23+PZCH766v671GC1oaAGBrcniwUAOkUlINz+2EhARq1OTegPPfc38b+nz5Ys/9r1etoKyzf4rXQ0aP1yxXeVupRZtk6tj4FrGlcebUSc8usEZNm9E/KheXbgepD/8eCP8uyPmsc1SocJGA80YLQgMAHCPU1oe820g+djBt3mKvx+XpymMLr6TP8dxevG5LwHLVt5XlTJg2U7ywT3/IbY28+eHHfuurdYyjRdtkal63ktg6sQOEBoRFufUXjN4veChlurVcJ9XVynL1vK5Zvw2uLDcavz8+8fV3iPhiEwgNCJlZx6hQrrPqana5gYJB+bqhnhEeau8lvfM1qlBM1wFrZXmPdmhBefLkEXddvbP086DPtQOEBgDYnhHhpOy9JJN7L2Xu3kmnT/4m3i5RqjQt37jda74u993htRtKLkvZQ4qPPQzs1l7c/aTshaXsEcXlKPUZNIye7tOFpsxeEOnbixqEBgDYkpGtGGXvJSW591KbTt3pyIH94hZ/hSpVfeZT9pBSlqXsIcUefKireK3uhSX3iNq/Z5dXuTnXrnldOwFCAwBcT9l7SUnuvXSHcF2mXAXxdoVKVXzmU/aQUpal7CHFln4wm9p16enTC0tZTubuHZ77s9+cQnfe25xmvfFfuqdVG3Ga3t1hVkFoAIDrKXsvafWYCkQ9n7IsZQ+pjMNnKT4+XrzNPbDkXljK5y/4epNXWe8u+yLo69kNQgMAwAByYLgdQgMAYsLqZQvFs7Hvb/9wyD2n/M2vnq6nXK157L5LSgmhAQCu1+/h1rT5O2nQQQ4NGa+s8xcoQKXKJNKy6we0/Y0npR6XSt0TSlmm/Hz1+FPq+dTjTDV/sINXryuZuo5WMj00MO4UAFhNDowGdzb1eezSxYt0eH+m1zSt8aTUPaLUPaG0nq/uXaUm96qSx6NqUr2012vweR98/odWHY2UmprKF13nu6ClAQCu9/L02WKPJx4xVg+t8aTUPaLUPaG0nq/uXeWPPB5V8zYdvV6Dx8vSot5tFunuLQ4N/NwrAMB1yl1SLFgPKvWYVfK1clwqdU8oeT5egcvPV/auCvTayvGo1L2utOqofiyax0MQGgAACpGugJ1yQDtcCA0AANANoQEAALohNAAAQDeEBgDYkhE/9yozurdRLENoAICtRfJzrzIrexu5DUIDABzDyNYHhMf00HDbz0w6uVwn1dVp5Tqprk4sN9Tn81nUdRs0oreXfBbJy4CGqLQ08LOYzirXSXV1WrlOqqvV5Ubyc688/MZzA/vg2IUJsHsKAGwvnPBa+9lKWpmx04zqxDSEBgDYUiStnPPnzoq/2V0msbyRVQJCaACACzWvV5latE22uhquhNAAANfhYcbBHAgNAADQDaEBAAC6ITQAwPGWpU+yugoxA6EBAI6m9xfnwBgIDQAA0M300MAYMQAA7oGWBgAA6IbQAAAA3RAaAACgG0IDAAB0Q2gAAIBuCA0AANANoQEAALohNADA0bR+uQ9Cp/fMeoQGADhehwEjra6Co4UydpfpocG/84uzwgEA3AEtDQCIWT1aNabd23+mnBxpD9eWY+d95qlftpDPdK1pwcjPUT43lHIeS76ftm3eRJsO/RnS6xoNoQEArsQr5KSadWj+V9+Lt1nTFg+I16/NWShe79r2k9dzRvbtSVnnztL0+Ss0yyudWI4+ydjlud/8wQ5e88uvw/IXKEClyiTSsg25r9Hlvjs065rc9DZasn6r5/k1bq5H5SpUposX/qJp7y0Rp7fq0MnywGAIDQBwrQN7d3tu8wq3cVIpn3nkrX+2/stVlH3lit/yThw9Il7HxcWJPynbpHppn/n5dRpVKEaXLl6kw/szvR7bv2eXT5k9H2hCh/bt9Xr+orlv0+SUUfSREHhsZcZOevju+sHeblQgNADAtSol1fDcTkhIoEZN7g04/z33t6HPly8OWm6jps3oH5WLU/M2HX3m59cJVJ/M3Tu8pp05ddKze0x+/iEhbDp2702Vr9e/TGJ5ys7OpvNZ56hQ4SJB62cmhAYAuNb861vq8nGDafO8V/DydOVxhVfS5wSd580PP9acX2te9WOBpsn3l7w3i+as/NrrsRZtk6l53UpiC8dKCA0AcKVQD1TbybeZv/tMm/j6O0R8sRhCAwBiilYvJj3zB/PPB5rSvFXrDXn9UOsYTQgNAIgJcg8lpaG9OonXmbt30umTv4m3S5QqTcs3bvd5vrI31tgh/eiTxR/S5qNZ4mPbtmTQjp+3itd169/uNa/6uUrqcpR1VPbEkuvJvb7UvbiiDaEBAK6n7qEk27juK/G6TafudOTAfvGAdIUqVf2WI/fG+mLlElqq6Eq7ZtVyKly0mHjNoaGcV/1cJWU5yjrKvbMaVbzRq54yuReXFRAaAOB66h5KMrk31R3CdZlyFcTbFSpV8VuO3BurRZtk6tj4Fk8L4etVKyjr7J/i9ZDR473mVT9XSVmOso5y7yx1Pe0AoQEArvfpD7lb+YF6OGlRzifvXpowbaZ4kS1et8XneepdUeqeXPK1XI6yjsreWUzZ68vqYxymhwbGnQKAcPC4dfJtO6xHQllZ++tK6wZoaQCA7SkDhEUSImb1nuL54uPjqXVyFxo/dabf+fhscT3Dgdix5xSLyii3ocyv98OAckMv10l1dVq5TqqrE8s14vlm9p6SffzdNurW8i6f11POz2d2D+zWngoVKuwzbpXcK8rfGFV24NjdUyjXvHKdVFenleukulpdbqBgUD5fz48wmd17StamUW3qNXCoz+up53/woa704qgnfcatkntFaY1RZabU1FS+6Api7J4CANuLNLzM7j0l466yP2Zs9Hk99fxLP5gdcJwrrTGqzMShgV/uAwBHM7KVY3bvqWDlKefPOHxWPPbBtMatYgu+3qSrblZAaAAA6GDUQWk5MJwKoQEAALohNAAAQDeEBgAA6IbQAADXU57Qx+x40pxTIDQAwPVC7TEF/iE0AABAN4QGALgOj+9Ut0EjenvJZ1ZXxXUQGgDgOjwg4HMD+9h20D8nQ2gAgCut/WwlrczYaXU1XAehAQCuc/7cWXE02TKJ5a2uiusgNADAdZrXq0wt2iZbXQ1XQmgAgOt8f+CM1VVwLYQGAADohtAAAADd/h9wv3ikgm8DpAAAAABJRU5ErkJggg==)\
*Illustration 2: 3 Layer Model: with Trusted Intermediary and Backend*

\

bar

\

policy kit example – extend implicit perms or choose when to prompt

have helper, policy daemon, service and app in different profiles.
Helper uses apps security context, passes that to policy daemon, daemon
uses that to check perms instead of uid auth. Service checks apps sec
context passes it to auth daemon to verify permissions ...

### Extending Policy to support Trusted Helpers {.western}

\

- how to update policy blah, blah, blah

\

- syntax

- underneath

- type, ordering of query

\

\

- policy enforced by trusted app does not have to be done by apparmor

- however then some communication enforcement can not be enforced

- policy is split between different systems

- better to keep policy in unified place

- also this allows policy to leverage apparmor security labeling, so not
just can X access Y, X can access Y if in state Z

\

\

- trust app needs to track and deal with handle update/mediation.

- provide api similar to what kernel uses to build labels and check them

- api can cache perms or send the request directly to the kernel

- don't have to necessarily directly pull the matching engine from the
kernel, could just cache decisions, dependent on needs.

\

Need

- label\_insert(X) – look up or insert new label

- label\_insert\_merge(X, Y) – lookup/insert new label that is merge of
two

\

oh, ouch ordering problem for lookup – what to do when replace renames
the profile?

- regular replacement, removal and even revocation are not a problematic

- for renaming replacement, have to build a new sorted label

\

Eg Multiple settings stored in a single db file

\

Mechanism, not policy

\

- backend

- intermediary

- intermediary + backend

This loss of information means that mediation of thes

\

trusted helpers and namespaces

- trusted helpers don't see or know they are in a different namespace

- they treat all their requests as if every request is in the same
namespace/profile. eg. Even if the helper and app are in the same
username space with different profiles, and their system namespace
profiles are different, the helper only makes it decision based on the
usernamespace profile (it can't see the system)

- if the trusted helper is in a system namespace it can see the request
is coming from something from from a usernamespace and take that
information into account

instead of

ipc socket,

dbus foo,

allow backend X

we just have

allow backend X

allow gsetting foo write,

- dbus interface=gsettings method=set field=foo,

- @{dbus\_session} rw,

\

or

\

- gsettings field=foo w,

- dbus interface=gsettings method=set field=foo,

- @{dbus\_session} rw,

\

- is there a case where we system namespace wants to ignore the
usernamespace labeling?

- almost certainly, infact probably most of the time.

- in fact unless other wise specified all subnamespaces should probably
be assumed to be allowed, that is for most rules, its only the labeling
within the namespace that counts

\

\

\

- trusted apps and trusted intermediaries

- policy extensions that are at the intermediary level not the system
object level

- intermediary rules can imply other rules, the set of rules that are
implied can be abstracted

- this means policy isn't hard coding the how (separate policy and
mechanism)

- this makes for smaller policy

- policy needs to be able to be flexibly extended

\

Hrmm, stack needs to be a different permission than change\_profile
other wise, when setting up a confined parent.

\

Hrmm should domain transitions only affect the bottom layer of the
stack?

Or perhaps those in the same namespace.

\

From a system, user profile pov. You want each applying their profiles.

Unless you are only going to treat the user in a broad stroke. Ie stick
the user in a specific profile and not change it based on what the user
runs.

-   

\

From a container/chroot pov the transition does not change what is being
done.

this can be done with a custom profile that traps domain transitions
(ix)

-   

\

\

Network Iptables as an example of a trusted helper

\

