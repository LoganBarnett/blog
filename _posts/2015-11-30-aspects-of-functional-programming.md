---
layout: post
title:  "Aspects of Functional Programming"
date:   2015-11-30 17:20:00
categories: programming
published: true
---

For all of the flak Javascript gets, there is one thing it has above all of the
"better" mainstream languages out there. I'm talking Java, C#, Python, Ruby
(yeah you two are mainstream to me). Javascript has functions as first class
objects. As a result, Javascript has been my gateway drug to functional
programming.

Functional programming has a lot of interesting promises to it, but it's been
damn frustrating at times to learn. Everything is so damn generic that it's hard
to understand when it's time to pull out certain patterns/functions/operations,
at least as an outsider looking in. I've really stuck with it, and it feels like
it's gotten better over time. There's still much for me to learn, but I feel
like I've climbed over some humps.

> Higher order functions help make FP code super generic

Quick intro to higher order functions: They are functions that accept functions
as one or more
parameters.
[`map` is a higher order function](http://ramdajs.com/0.18.0/docs/#map). When I
first looked at FP code (Haskell and Javascript-functional-style is my most
exposure at this point), I was always bothered by the variables such as `x`,
`y`, and `f`. What the hell does `x` represent? Well it turns out there's good
reason for it, and it turns out Mark Seemann
has
[documented this already](http://blog.ploeh.dk/2015/08/17/when-x-y-and-z-are-great-variable-names/).
My experience matches his so far. When you take a function (call it `f` because
it really could run an entire application), and pass it into your function, you
just call it when the time is right. The function really could do anything.
Calling it anything else just means you're going to write duplicate functions
later but with different names. Let's call
this
[wet](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself#DRY_vs_WET_solutions) code.
Since this could really be anything, that makes for a really interesting
property in relation to API calls.

> API calls don't happen in the depths of your application

I'm very much used to code that kind of does this:

```
Super generic high level app
    Framework layer
        Controller-like-thing
                Model-like-thing
                    Super-specific API calls
```

Your structures may vary, but the theme is quite similar: you make calls to your
API at the very end typically, and the entire application focuses down to this
concentrated point where the tires hit the pavement.

In FP I have not found this to be true. It tends to be inverted. Take the
awesome examples we see of FP all of the time that do nothing:

``` javascript
var list = [1, 2, 3];
var squareFn = function(x) { return x * x; };
var squaredList = map(squareFn, list);
console.log(squaredList); //[1, 4, 9]
```

Ok smart academic peeps, how do I talk to the database this way? How do I
accomplish normal job-type stuff I have to do at my job all day? Well instead of
`squareFn`, consider functions such as `writeToDatabase`,
`interrogateTheRebels`, `fireTheNukes`, and
`makeMyBossThinkImDoingRealWorkInsteadOfReadingThisBlog`. All of the sudden your
code is authored in a way where you are manipulating data and converging on this
final point where you call `f`. You don't care what `f` is. It just needs to
conform to a certain kind of signature.

But what if you don't have the `bigRedButton` needed to `fireTheNukes`, or the
DB connection required for `writeToDatabase`? This is where partial application
or currying come in.

> Partial application changes the interface of a function to make it easier to
> use

Ever noticed that most function signatures always end with a list in its
parameters? This is because it makes it **super** easy to do partial
application. What is partial application? Let's do a manual version:

``` javascript
var add = function(x, y) {
    return x + y;
}

var add5 = function(y) {
    return add(5, y);
}
```

So let's start by confessing you'd never really write this code for anything we
could deem useful. That being said, notice that `add` and `add5` have different
signatures. `add` takes two parameters, whereas `add5` only takes one. Why is
this useful? Let's take a look at `map`. `map` takes a function (let's call it
`f`) that takes one type of thing (we'll all that type `a`) and returns another
type of a thing (`b`). It also takes a list of the first type `a`. The final
return value for `map` will be `b`. Haskell has a clever notation here for this:

```
(a -> b) -> [a] -> [b]
```

The way I remember this is the last thing is always the return value. Here we
have the function that takes an `a` and returns a `b`. This is expressed as `(a
-> b)`. Anything in parens is a function. The next param is a list of `a`,
expressed as `[a]`. Anything with square brackets is a list. Finally the return
value is a list of `b`, expressed as `[b]`.

What the hell does this have to do with `add5`? Let's take a look at the
signature for `add`:

```
a -> a -> a
```

Two things in, one new thing out. These things should be the same type of thing.
Pretty simple, right? How about `add5`?

```
a -> a
```

This is interesting. `add5` only takes a single parameter, and then returns
another thing, but they are still of a uniform type. Tying this back to `map`,
let's look at the function it wants side by side with `add5`:

```
a -> b  // map's function
a -> a  // add5
```

Well there's nothing in `map` that says `a` and `b` can't be the same thing. It
just states that `a` could be different than `b`. If we took `map` and
substituted `Integer` for `a` and `Integer` for `b`, this is what we'd have:

```
(Integer -> Integer) -> [Integer] -> [Integer]
```

Then we can compare our signatures again:

```
Integer -> Integer  // map's function
Integer -> Integer  // add5
```

They match! We can do some powerful things with this. A realy cool thing is we
can take the partially applied `add5` and pass it straight into `map`. Let's do
that using our first example:

``` javascript
var add = function(x, y) {
    return x + y;
}

var add5 = function(y) {
    return add(5, y);
}

var input = [1, 2, 3];
var output = map(add5, input);
console.log(output); // [6, 7, 8]
```

In this example, we took `add5` and passed it straight into `map`. We didn't
need to write an inline function. We separated the act of mapping over a list
with the actual transformation itself. What is easier to unit test? Which one is
easier to think about?

``` javascript
var add5 = function(y) {
    return 5 + y;
};

// or

var input = [1, 2, 3];
var output = map(function(x) {
    return x + 5;
}, input);
```

Testing `add5` by itself is way easier. We just supply it one argument which is
a number, and make sure the result is a number that's 5 more than what we
supplied. Testing the other form requires us to supply a list. When we're
talking about non-trivial production code, this savings in your head adds up
quickly. This is also means that any other time you need to do a normal `add`,
it's already done. You can partially apply other values if you need to.

In Javascript land, libraries such as [Ramda](http://ramdajs.com) make it super
easy to [partially apply](http://ramdajs.com/0.18.0/docs/#partial). We could
express `add5` like this:

``` javascript
var add = function(x, y) {
    return x + y;
}

var add5 = R.partial(add, 5);
```

In pure functional languages, this is a first class language feature, so it gets
even easier than above.

Remember how I mentioned we'd never actually write `add5`? Well let's imagine a
more complex function:

``` javascript
var executeSql(connection, sql, params) { ... };
```

`executeSql` needs a connection to a database, the SQL to execute, and a list of
parameters to provide. A common usage might look like this:

``` javascript
var results = executeSql(connection, 'select * from users where firstname = ? and lastname = ?', ['Logan', 'Barnett']);
```

Well we're going to use the same connection a lot, so we can partially apply
that:

``` javascript
var executeSqlOnMainDb = R.partial(executeSql, connection);
```

It would be reasonable to also partially apply the SQL itself:

``` javascript
var findByFirstAndLastName = R.partial(executeSqlOnMainDb, 'select * from users where firstname = ? and lastname = ?');
```

At this point, we're down to one parameter, a list of names (first and last).
The cool thing is this is all
composable.
[`map` is another thing we can borrow from Ramda](http://ramdajs.com/0.18.0/docs/#map),
so I'll sneak that in to flesh this example out.

``` javascript
var namesToFind =
  [ [ 'George', 'Jetson' ]
  , [ 'Jane', 'Jetson' ]
  , [ 'Cosmo', 'Spacely' ]
];

var executeSql(connection, sql, params) { ... };

var executeSqlOnMainDb = R.partial(executeSql, connection);

var findByFirstAndLastName = R.partial(executeSqlOnMainDb, 'select * from users where firstname = ? and lastname = ?');

var displayUser = function(userRecord) {
    return "Here's " + userRecord.firstname + ' ' + userRecord.lastname + '!';
}

var userRecords = R.map(findByFirstAndLastName, namesToFind);
var printableUsers = R.map(displayUser, userRecords);

// vanilla JS forEach
printableUsers.forEach(console.log);
// Here's George Jetson!
// Here's Jane Jetson!
// Here's Cosmo Spacely!
```

I know that's not how the Jetsons' theme goes, but you get the idea. Being able
to transform a function's signature allows us to compose them to do other
things. We can find a lot of reuse this way.

There's so many patterns and concepts of Functional Programming and much of it I
have yet to learn. That doesn't even include Set and Category Theory - studies
that predate much of computer science yet are very applicable today. There's a
lot of smart people out there talking about this.
Practically
[any talk from Rich Hicky](https://changelog.com/rich-hickeys-greatest-hits/) is
philosophically mind blowing. Scott
Walschin's
[talk on functional programming design patterns](https://vimeo.com/113588389)
has been a great way to make me understand functional programming in a practical
sense I could apply to the real world. I hope to document more of these tidbits
along the way. Hopefully people will experience fewer rewrites and brain pains
that I did to find this stuff out.
