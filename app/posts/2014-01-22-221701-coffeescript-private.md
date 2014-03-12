---
title: CoffeeScript and the Concept of Private -- and TDD considerations
author: Jeremy Jackson
email: jeremy.jackson@modeset.com
image: fpo/test-thumb.png
---

## Really, private?  But it's.. it's Javascript...

People who've worked with me know I'm not a big fan of the concept of "private" in Javascript.  I prefer the "we're all grown ups here" tack, but I acknowledge that it can be useful in some architectures and patterns.  And it's Javascript, there isn't private really but you can sort of achieve it, so let's investigate the way we decided to implement it.

The first thing we did to accomplish a private method was by creating a local variable -- local to the scope of the class that is.  Doing so looks like the following.

```coffeescript
class Foo
  constructor: -> @foo = 'foo'
  bar: -> baz() # public method
  baz = -> 'baz' # private method

f = new Foo()
f.bar() # -> 'baz'
f.baz # -> undefined
```

## Your privates should have context

That works great, but let's say we want the `baz` method to be called with the context of the instance.  It breaks down a bit here because `baz` is actually defined within the scope of the class definition, not the instance (or prototype). Here's what happens when you try to access a member variable in the private method.

```coffeescript
class Foo
  constructor: -> @foo = 'foo'
  bar: -> baz() # public method
  baz = -> @foo # private method

f = new Foo()
f.bar() # -> undefined -- because baz doesn't have access to the @foo member variable
```

This is because the `baz` method isn't prototyped onto the current instance.  And to get around that, we can use the `.call` or `.apply` methods and pass the context.

```coffeescript
bar: -> baz.call(@)
```

Calling `bar` now calls the private `baz` method within the context of the instance.  That's cool.  We can call private methods from within the `Foo` class all willy-nilly now.

## TDD and your privates

But wait...there's no way to write a unit test for the `baz` method!  Yeah, maybe you shouldn't test private methods, and that's partly valid -- but Ruby has the concept of a `send` method, which is pretty cool and useful.  You can use it to call any method, including private or protected methods. I sort of like that, and anyone who's done TDD in Ruby has probably found it useful at least once.  So yeah, why can't we have something like that?

What we really want is a common API that allows us to call our private methods within the context of our instance, as well as expose them externally in such a way that we can get at them from our tests but discourages people from ever using them.

Ok, so let's do that.  Since we're using [SpineJS](http://spinejs.com/) we can hook into some already useful stuff there.  You can apply this concept manually, or fit it into your own framework pretty easily -- there's nothing super fancy about this, but it's the way we'll be approaching this ourselves when we think it's appropriate.

## Including your privates

Spine has a concept of Modules.  `Spine.Module` is something that your classes can inherit from, and has `include` and `extend` methods which behave similar to those that you find in Ruby.  The super tree isn't as nice, but they work and are pretty much what you would expect.  We'll only cover the `include` method here because it's the one we'll make our adjustments to.  Here's an example of using `include` to add instance methods to our `Foo` class.

```coffeescript
class Foo extends Spine.Module
  @include {
    baz: -> @foo
  }

  constructor: -> @foo = 'foo'

f = new Foo()
f.baz() # -> 'foo'
```

## Privately sending

The method of adding to the prototype / including modules isn't new or special to Javascript, but since Spine has it, it's something we can use, and so we will. We can just override the existing `include` method (shown) with our own enhanced version.
 
```coffeescript
moduleKeywords = ['included', 'extended']
@include: (obj) ->
  throw('include(obj) requires obj') unless obj
  for key, value of obj when key not in moduleKeywords
    @::[key] = value
  obj.included?.apply(@)
  this

moduleKeywords = ['included', 'extended', 'private']
Spine.Module.include = (obj, forPrivate = false) ->
  throw('include(obj) requires obj') unless obj
  __private__ = {}
  if forPrivate
    @::send = -> __private__[[].shift.call(arguments)].apply(@, arguments)
  for key, value of obj when key not in moduleKeywords
    if forPrivate then __private__[key] = value else @::[key] = value
  obj.included?.apply(@)
  this
```

We prototype a `send` method, and add a `__private__` variable that will collect our private methods -- so we can call them from within the `send` method.  Since that's a local variable it won't be exposed on the instance and so remains fully private.  You may have also noticed that we've added a 'private' to the moduleKeywords -- you'll see more about that below.  Anyway, now we can create our private methods using `include` (telling it that they should be private), and call them using `send`.

```coffeescript
class Foo extends Spine.Module
  @include {
    baz: -> [@foo, arguments]
  }, true

  constructor: -> @foo = 'foo'

f = new Foo()
f.send('baz', 1, 2) # -> ['foo', [1, 2]]
f.baz # -> undefined
```

## Cleaning up your privates

Using `send`, much like what Ruby provides, we're able to access the private methods internally and externally (from our specs), all while using a common API.  But we can clean this up even further by adding another method to `Spine.Module`, named `private` -- we added this to the moduleKeywords above.

```coffeescript
Spine.Module.private = (callback) ->
  @include callback(), true
```

Which if we use, gives us a much cleaner structure for our class.

```coffeescript
class Foo extends Spine.Module
  constructor: -> @foo = 'foo'

  @private ->
    baz: -> [@foo, arguments]
```

## We're mocking your privates

Ok, awesome.. We have a consistent API and a nice structure for using private methods in our classes.  But wait, there's still no way to mock our private `baz` method.  Having the ability to do so would definitely come in handy while test driving our code.  And even if you believe that private methods should only be tested indirectly, I would say if you're not mocking any of them ever, you're not doing proper unit tests.

So as a final step we can expose our private methods on the instance so we can do mocking on them.  We don't just want to expose them normally, and since we already have the local `__private__`, let's just put that on the instance instead. Making a quick adjustment to the `include` method we provided above, we can shift the local variable into an instance variable by using the CoffeeScript `@::` prototype syntax.  And our end result (note: we don't consider this pretty code, but it's what spine has)...

```coffeescript
moduleKeywords = ['included', 'extended', 'private']
Spine.Module.include = (obj, forPrivate = false) ->
  throw('include(obj) requires obj') unless obj
  @::__private__ = {}
  if forPrivate
    @::send = -> @__private__[[].shift.call(arguments)].apply(@, arguments)
  for key, value of obj when key not in moduleKeywords
    if forPrivate then @::__private__[key] = value else @::[key] = value
  obj.included?.apply(@)
  this
```

You can call your private methods using `send`, and you can access the reference to them via the `__private__` instance variable.  And anyone using these exposed private methods knows what they're doing and the potential pitfalls of doing so.

## End result and parting thoughts

We hope this inspires some thought about using private methods in CoffeeScript.  We had fun playing with these concepts and the discussions around it.  Here's the final result of our class and a Jasmine spec showing how you can interact with the private methods.

```coffeescript
class Foo extends Spine.Module
  constructor: -> @foo = 'foo'
  bar: -> @send('baz')

  @private ->
    baz: -> @foo

describe 'Foo', ->

  it 'has a private method that we can call using #send', ->
    f = new Foo()
    expect(f.send('baz')).toEqual('foo')

  it 'has a private method that we can mock', ->
    f = new Foo()
    spy = spyOn(f.__private__, 'baz').andCallFake(-> 'baz')
    expect(f.bar()).toEqual('baz')
    expect(spy.callCount).toEqual(1)
```

