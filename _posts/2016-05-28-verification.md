---
layout: post
title:  "verification"
date:   2016-05-28 16:37:00
categories: programming
published: true
---

Unit tests, type checkers, SAT provers. These are all tools we use to verify our
code, and it's by no means an exhaustive list. People struggle with using them
though. Ruby and Python engineers typically find static type systems too
cumbersome. Instead they favor more unit tests (those that do unit testing).
C# and Java engineers generally like the benefits of static checks to make sure
interfaces are respected (except null - seriously wut r u doing?). On the more
extreme end you have tools like Haskell that are statically typed in a way C#
and Java engineers can't even wrap their heads around without major study.

Think of Java and C#'s type system to be very simplistic. For the most part, it
just makes sure that you are using interfaces as declared. Not really much else.
We'll ignore the problem with null breaking all of those interfaces at
runtime for now. Even with such a simplistic system, there's simply a series of
unit testing that needn't be done. You said a string gets passed in here, so
you'd better get a string (or null - I lied about ignoring the problem). That's
a hell of a lot different from Ruby. You could get _anything_. How does it
handle that? Do you care? Maybe you just test how you use your code from other
places in your code. Jumping back to static type systems - the functional
programming languages with type systems such as Elm, F#, and Haskell all provide
type systems that don't allow for null, and have varying levels of requirements
to make sure when your code must split on paths, all of those paths are covered.
Isn't that neat? It lets you lean hard on these checks. Many of these checks are
backed by mathematical proofs - think abstract math, not just pure numbers. Many
functional programmers using tools like Haskell believe the usefulness of unit
tests everywhere is diminished by a mean type system that punishes you for being
a lazy engineer who doesn't account for all the errors that could happen and
whatnot.

But we still struggle. We have the internet
[arguing](http://blog.cleancoder.com/uncle-bob/2016/05/01/TypeWars.html)
[with](http://qualitycoding.org/type-safety/)
[itself](http://typeinference.com/scala/2016/05/03/tdd-vs-static-typing.html)
over whether or
not 100% test coverage is feasible. Is it useful? But wait that doesn't speak to
the quality of the tests. Unit tests are anecdotal - you want to _prove_ your
program works just like how your geometry class made you prove that squares are
just rectangles but with some additional constraints. What a great time it is to
be a software engineer. It's a landscape full of people just trying to figure it
out. I suspect many of us who feel like we have solid answers simply have solid
answers that works for _ourselves_. But sometimes the best thing to do is no
thing. Artists use
[negative space](http://www.tutorial9.net/articles/design/enhancing-your-art-with-negative-space/)
to great effect. Even comic artists use
[extra panels](http://tvtropes.org/pmwiki/pmwiki.php/Main/BeatPanel) with _no
changes whatsoever_ but it communicates something powerful to the reader.
Comparing software engineering to art will give me pretentiousness points even
I'm not comfortable with, and it would just be plain wrong. I don't have
comments enabled on this blog so I'll be spared, right?

Sigh.

What if I submitted that _verification is sometimes overkill_, or perhaps even
_often_ overkill. Hopefully this isn't a sign of quality on my part, but I find
a great deal of my time as an engineer is spent putting up forms. I skin
databases. What are we proving with forms? Don't get me wrong. I have TDDed
several apps and will likely continued to do so. I have apps that are at 100%
coverage. However some things are hard to test. Sometimes it's just tedious to
test.

![roid miner editor](/blog/assets/roid-miner-object-instance-editor.png)

Does this need unit tests for putting in the name? What about toggling the
select box? Maybe! The select box does more than just change data, it updates
the cube above.

What if we just committed ourselves to doing an automated smoke test to
our silly forms that have little variation in their behavior? If we like, we can
add tests later. The compromise is we'll follow some patterns that make testing
easy. This usually means ditching objects and embracing the wonderment that is
functional purity.

> cue parting the heavens with rays of sunshine and doves

Maybe the hard part about testing is when we try to do it for everything we
realize it's not really helping us after a point. We can still have type
checking. We can still have unit tests and integration tests. Nobody ships their
tests or their types. So maybe testing all of those button presses in Redux is
not really worth all of that time. As things get complicated, fill your boots.
Write those tests and get strict with your types. Those are your big guns.
