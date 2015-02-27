---
title: Elm first impressions
author: Jed Schneider
email: jed.schneider@gmail.com
image: fpo/test-thumb.png
---

I've recently had an opportunity to work with [Elm][1] to review its
potential to become my choice for creating Single Page Applications for
web based products. In our consultancy, this would place Elm in direct
competition with JavaScript frameworks such as Ember.js and Backbone.js.
In a broader sense, however, Elm is a direct competitor with the holy
trinity of web development; HTML, CSS, and JavaScript. In effect, with
Elm, these languages and markup languages become an implementation
detail; an artifact of your code. Nothing more.

For me, this idea is vastly compelling. HTML, CSS and JavaScript have
largely
gone unchanged for 20 years, and yet the web as we know it is vastly
different. For the past 5 years, I've been happy using alternatives that
exists as supersets on top of these languages, but semantically
identical; CoffeeScript for JavaScript, haml for HTML, sass for CSS. In
fact I've strongly argued in the past for languages like CoffeeScript
over the cross-compiled alternatives like TypeScript and ClojureScript
largely because it preserved the semantics of the native JavaScript. And
I feel like the abstractions we've created have moved us incrementally
to that next level. But, the plain truth is that what we are building in
the browser today is more akin to native user interfaces in operating
systems, than web sites. 

## Elm enters stage right. <--

I like to think entering stage right is a symbol of the rising sun,
because it implies 'to the East' on stage.

Elm is a language built for creating browser-based interactive applications using a
strictly typed functional language; akin to [Haskell][2]. Importantly, to me,
it is both functional, and compiled, and as I will speak to in the next
paragraphs, the type system is wildly delightful to work with.

You just want to see what an Elm program looks like? Ok. [Hello
World][3]

This is a first look, so we won't get to the Reactive part of Elm, or
really focus too much on the Functional part. First, I want to talk
about types.

## JavaScript Exists stage left. <--

The sun sets in the west.

I once lost a day and a half in Ember because of the alphabet. JavaScript
is order dependent, you can't call a function that has not been declared
before you use it. In Rails, we use the asset pipeline to construct the
dependency graph and make sure all the files you need are inserted in
the correct order. You do this by creating a manifest of requirements at
the top of the file, for example, the following line makes sure that the 
`room` class will get loaded before anything in the file is run.

```coffescript
#= require ./room
```

 I was working in an Ember model called 'Residence' and was
using the Ember API for establishing associations, which has a similar
API to Rails:

```coffescript
Residence = DS.Model.extend
  satisfactionScores: hasMany(SatisfactionScore)
```

By default, the asset pipeline loads files alphabetically, and with that
bit of information the story ends. The function `hasMany` was passing
`undefined` instead of the `SatisfactionScrore` because I had not
included the following code at the top of the file.

```coffescript
#= require ./satisfaction_score
```

Ember is smart. Really Smart, but it lacks something for me that is increasingly important; a
pre-compiler. Instead of the application telling me that that
`SatisfactionScore` was `undefined`, the first line of the stacktrace was nearly 3000 lines deep
in Ember internals. The real code was a bit different than I am showing
here, but suffice to say, we had a couple layers of customization on the
Ember source code and I had just made an upgrade to a new version of
Ember, so my instincts told me that there was something going on
*inside* Ember I needed to debug. If Ember had a compiler and if
JavaScript was strictly typed, I would know immediately that I was
passing undefined to a function that required a Constructor function.
For me, this was the moment of clarity that sent me looking for
something better, because for as much as Ember tries to save you from
the language itself, you can only do so much.

## Elm is compiled, and it Enforces Types

We should take a look at some simple Elm code.

```elm
type Shape
  = Circle Float
  | Rectangle Float Float
```

This creates a type called `Shape` that has two subtypes that are member
of that group, a circle and a rectangle. The two shapes take a different
number of parameters but they are both shapes. `Float` is a top level
type and is therefore available. We can then construct a function that
calculates the area of a given shape.

```elm
area : Shape -> Float
area shape =
  case shape of
    Circle d -> (a * 0.5) * 3.14
    Rectangle l w -> l * w
```

And then you can use the function like this:

```elm
r = Rectangle 3 4
area r
```

which returns the result `12: Float`.

In Elm, the function declaration has two parts. The type annotation, and
the definition itself. The type annotation is optional (because the
compiler is that awesome) but considered good practice. We declare the
function to take a `Shape` type, and return a `Float` type. If the
compiler finds a use of this function in your code that does not match
those two criteria, it is a compiler error. The following line `area
shape =` is the function declaration, which is that there is a function
named area that has a single parameter with the localized name of `shape`.
The case statement switches the function execution based on what kind of
shape it is.

When I first started working with the language, one of the first things
that really stumped me is that if I had a function that took a type
like `Shape` and returned a `Float`, how did I get the float out of an
existing shape? The answer, like most things I am discovering in Elm is
pattern matching. A value, like `r` in the above snippet, you can think
of as its type, followed by its arguments, so when you see something
like `Rectangle l w` in the case statement, what that is really doing is
destructuring `r` into its type and its two bits of data passed in, `3`
and `4`. Those bits of data have a type of float, and the process of
multiplying those types together results in a Float, so the function
passes its type test. Celebrations ensue. 

Before concluding, I'd like to share one more bit of fun I found in this
review. In Elm, all functions are curried. In Elm, all functions are
only single argument functions. If a function takes more than one
argument the function remains partially applied until its argument arity
and type declarations are fulfilled. If we provide the `Rectangle`
constructor with one argument, Elm is OK with that.

```elm
r = Rectangle 3
```

This would return a type of Function. It will wait for us to apply a
second argument before 'becoming' a `Rectangle`.

```elm
r 4
```

OK, now the arity is fulfilled and the r symbol is a `Rectangle`.
Because the arguments are applied from the right, this provides natural
composition.

```elm
r = Rectangle 3
area (r 4)
```

## Concessions

Yep, there are a lot of concessions here. To write Elm, I must give up
the vast majority of what I currently know. The promise, however, to me
is largely compelling. I think about the fact that when I was 18, and
JavaScript came out, I couldn't imagine being 40, and now I'm almost 40
and it seems like everything in my life has changed, except for the
rudimentary blocks I build the internet with, and I feel like some
evolution is in order.

[1]: http://elm-lang.org
[2]: https://www.haskell.org
[3]: http://elm-lang.org/edit/examples/Elements/HelloWorld.elm
