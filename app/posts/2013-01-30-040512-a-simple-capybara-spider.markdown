---
title: A Simple Capybara Spider
author: Jay Zeschin
email: jay.zeschin@modeset.com
image: fpo/test-thumb.png
---

We're big fans of continuous integration and continuous deployment around here. Nothing beats the rapid feedback loop created when you're able to go from checked-in code to running application in a very short period of time, especially when you have the confidence of knowing your code is well-covered and guarded by a solid test suite.

When we were [reworking this site recently](http://modeset.com/what-we-know/2013/01/28/mode-set-1-1), we wanted to take that same approach. Among other things, continuous deployment would make a branching/code review process for authoring blog posts very easy. author in a branch, solicit feedback in a pull request, merge when ready, and the content shows up within a few minutes. However, there are a few things about this application that make testing it a different sort of challenge. How do you put a good safety net in place for something that doesn't fit the typical interactive web app mold?

This site is largely static content checked into version control, using the Rails asset pipeline to give us access to nicer templating and some good organizational defaults. While technically possible since the site's structure doesn't change very frequently, writing traditional [Capybara specs](https://github.com/jnicklas/capybara#using-capybara-with-rspec) around static content just seems kind of silly. We wouldn't be able to actually write tests of value that way. Jasmine unit tests (with [Teabag](https://github.com/modeset/teabag)) are useful for the JS interactions to be sure, but don't do much for us at the integration level. 

The solution we settled on was to build a simple spider that could crawl over the pages on the site and smoke test them to make sure that they render without errors. It's a nice way to give us that level of confidence that our code is free from any smallish typo-and-syntax-type issues that could creep in and crater page renders, without being overly duplicative or brittle. Best of all, Capybara's API makes it ridiculously easy to build.


## Check it out:

Put this in `spec/support/spider.rb`:

```ruby
module Spider
  def spider_from(path)
    visit path
    all('a').each do |page_link|
      href = page_link[:href]
      next if href == '#'
      next if href.blank?
      next if ['delete','post','put'].include? page_link[:method] 
      next if href =~ /^(http|mailto|tel)/
      if href =~ /^\//m
        visit href
      else
        visit "/#{href}"
      end
      expect(status_code).to be(200)
    end
  end
end
```

Then in `spec_helper.rb`, add this inside the `RSpec.configure` block:
```ruby
config.include Spider
```

Finally, create a new feature spec that looks something like this:
```ruby
require 'spec_helper'

describe 'Spidering the site' do
  it 'successfully completes when run from the home page' do
    spider_from '/'
  end
end
```

_Voila_, instant web spider.

There are obviously limitations - for one, it doesn't tell us anything about the content or presentation of the pages, just that they're free of basic rendering issues. It's also pretty simplistic and doesn't do anything like link reference tracking, recursive crawling, etc. However, for our little site we think it's a nice way to get a bit more confidence to power our continuous deployment engine.

**What do you think?**  We'd love your feedback. Hit up me ([@jayzes](http://twitter.com/jayzes)) or us ([@modeset_](http://twitter.com/modeset_)).
