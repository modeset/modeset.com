---
title: Views Over Components - An Ember Refactoring Story
author: Mike Pack
email: mike.pack@modeset.com
image: fpo/test-thumb.png
---

We've recently been using [Ember.js](http://www.emberjs.com) to build rich client-side apps, and have enjoyed it tremendously. As when grokking any new technology, we've hit a number of interesting challenges, one of which is how to structure the visual layer of the application. With the release of 1.0.0.rc6, Ember introduced components, a clean way to encapsulate data and behavior in an Ember object.

Our app is built using visual cards. Think Pinterest cards or baseball cards. Each card has an individualized purpose, which means it doesn't need to know about any surrounding cards. Practically, each card can function in isolation. Upon considering Ember components, we thought our card-based design would fit nicely into this structure so we proceeded with components. As it turns out, we didn't fully understand how this isolation would impact the app and refactored out components in favor of views.

With an abundance of articles addressing why you might use components, I thought it would be interesting to highlight a few tradeoffs from a different perspective.


## View Composition

One beautiful feature of Ember is its ability to manage view hierarchy for the developer. This is an obvious pain while using other frameworks, often necessitating an additional tool so the developer isn't burdened with manually managing view hierarchy. Part of managing the view hierarchy is determining which context to execute a particular template. 

Take the following Ember example, using a GitHub user as our model:

```html
<h1>{{username}}</h1>
{{#view Github.ProfileCardView}}
  <p>{{fullname}}</p>
  <p>{{email}}</p>
{{/view}}
```

Imagine that `Github.ProfileCardView` encapsulates profile data about a Github user. Additional cards could be embedded: `Github.CommitsCardView`, `Github.RecentStarsCardView`, etc. These would be independent cards that display isolated information about a Github user.

In the above example, the context for the entire snippet is the controller managing the view. In other words, Ember will resolve the expressions `{{username}}` and `{{email}}` to the same object, the controller which represents a Github user.

With components, you lose the implicit binding between views and their sub-views. If you'd like to access the outer context, you need to explicitly pass it to the component:

```html
<h1>{{username}}</h1>
{{profile-card user=model}}
```

Where `model` is an accessor for the current controller's model (our Github user).

The template for the `card-body` component is now a separate file and requires scoping each property to the `user` argument:

```html
<p>{{user.fullname}}</p>
<p>{{user.email}}</p>
```

Explicitly passing the model to the component is the primary pain point I'm trying to demonstrate. As it turns out, this doesn't scale well. Passing the context into components is redundant and verbose, but due to the isolated nature of components, it's the only way to keep references intact.

We could accomplish the same level of expressivity and allow view composition by using a helper:

```html
<h1>{{username}}</h1>
{{#profile-card}}
  <p>{{fullname}}</p>
  <p>{{email}}</p>
{{/profile-card}}
```

The `profile-card` helper could set up the appropriate contexts and call out to the [render helper](http://emberjs.com/guides/templates/rendering-with-helpers/#toc_the-code-render-code-helper). Here, helpers reduce noise, provide comparable expressivity, and allow us to compose views in a sane manner.


## Testability

We found that testability actually decreased when replacing components with views. Due to the isolated nature of components, they've very easy to test independently. We created a [setupComponent test helper](https://gist.github.com/mikepack/9274300) that renders the component into the test harness's DOM. This allows us to set up the component on the page, make assertions about the component, and tear it down afterwards.

If we used the component described above:

```html
<h1>{{username}}</h1>
{{profile-card user=model}}
```

We could test it using our helper:

```coffeescript
AppTest.setupComponent 'profile-card',
  Ember.Object.create(fullname: 'Mike Pack', email: 'mike.pack@modeset.com')
  user: 'model'
```

The first argument to `#setupComponent` is the name of the component we'd like to render. The second argument is the model/content of the surrounding controller. The third argument is a hash of options to be passed to the component in the view.

What results from running `#setupComponent` is our component rendered into the page for testing purposes. Assuming our component has `.profile-card` in it's `classNames` property, we can use normal assertions to test the component:

```coffeescript
expect(Ember.$('.profile-card').text()).to.match(/Mike Pack/)
expect(Ember.$('.profile-card').text()).to.match(/mike.pack@modeset.com/)
```

This approach gives us a clean way to render components and make assertions about their behavior. We lost this ability when refactoring components to views. After the conversion, we had two options: use [Ember's integration testing framework](http://emberjs.com/guides/testing/integration/), or use a tool like [Capybara](https://github.com/jnicklas/capybara) since we're running on a Rails stack.

With Ember's integration testing framework, you're forced to render the entire Ember stack. In order to test the component, you'd need to visit a URL that contains the component. Ember will route the "request" through the router, fetch models, setup controllers, render views and finally render the component. While this isn't a poor approach to testing components, it's clunky. Moreover, there are better tools for this style of testing; we chose Capybara.


## Actions and Dependency Injection

Actions were a point of contention for us as well. In our case, we wanted a click event on the component to propagate an action up to our router. Say we wanted our Github profile component to allow the user to in-line update the email attribute. We'd want to trigger a `edit` action on the router so we can transition to a new URL that represents the state of the page:

```html
<p>{{user.fullname}}</p>
{{#if modifying}}
  {{input user.email type='email'}}
{{else}}
  <p>{{user.email}}</p>
  <button {{action 'edit'}}>Edit</button>
{{/if}}
```

In the above example, I'm assuming the router sets the `modifying` property on the component, using mechanisms outside the scope of the article. Because the `edit` action is embedded within a component, it will not be propagated up to the router, which means we need some additional code to accomplish this.

In our component, we need to manually propagate the action:

```coffeescript
App.ProfileCardComponent = Ember.Component.extend
  actions:
    edit: -> @sendAction('editEmail')
```

Clicking the button will trigger the `edit` action on the component, which will propagate the `editEmail` action up to the router. The last step in hooking this up is to pass the action to the component:

```html
<h1>{{username}}</h1>
{{profile-card user=model edit='editEmail'}}
```

Again, the isolated nature of components forced us to add superfluous code to support the type of behavior we were seeking. This doesn't scale. If the component needs to propagate 20 actions, every single action name needs to be passed to the component. Worse, `edit` and `editEmail` have to be named differently. This would force us to have 40 named actions instead of 20.

This issue affects other aspects of components as well. As discussed in the Testability section above, dependencies need to be injected into the component. If a component depends on three objects, all three of them need to be injected alongside any actions. This tends to get pretty noisy.

If we had a stats aggregator card that compares a user's comments over time against a series of baseline metrics, embedding this card component becomes quite unwieldy:

```html
{{stats-card commits=commits mean=meanCommits median=medianCommits mode=modeCommits max=maxCommits min=minCommits export='exportStats' changeMonth='changeCurrentMonth'}}
```


## Conclusion

If you've made it to this point, you're probably thinking, "you're doing it wrong." You're right, we were. We lead ourselves to this point because of our inexperience with Ember and especially our inexperience with components. Though we ultimately needed to move away from components, we learned a ton along the way.

It's clear now: components should only be used for pieces you wish to widget-ize. Things like Facebook Like buttons and Twitter tweet embeds. I don't see a practical use case for components as inter-application sharable views. Specifically, if you've reach a point where you're passing Ember objects into components, you may have gone too far.

I hope this article is a helpful perspective for someone considering the pros and cons of components and views. Before proceeding with components, make sure you clarify that you need the isolation, and your ultimate goal isn't to simply and cleanly compose your views.
