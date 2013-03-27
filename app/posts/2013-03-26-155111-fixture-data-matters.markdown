---
title: Fixture data matters
author: Jed Schneider
email: jed.schneider@modeset.com
image: blog/code-closeup.png
---

I'm talking pretty loosely about fixture data here. In my current
definition, fixture data is the transactional data you use for filling
in your specs.

```ruby
post  = Post.new(title: "A whales tale")
```

We don't think much of this kind of filler data and often there is no
reason to be too concerned. But, sometimes we need to be a little more
cautious. An example class and spec:

```ruby
class Assignment
  def set_due_date(date_string)
    @due_date = Date.parse(date_string)
  end

  def due_date
    @due_date
  end
end

describe Assignment do
  it 'sets the date' do
    subject.set_due_date("01/02/2014")
    expect(subject.due_date).to eq(Date.parse("01/02/2014"))
  end
end
```

We have done two things here that lead to subtle errors in our code.

The first is that we use the same method `Date.parse` in both the spec and the production
code to determine equality. This is an easy habit to fall into, because
it seems reasonable to believe that we can rely on built in Ruby methods
to 'do the right thing'; and we know we can compare two date objects for
equality.

Doing so in this case only asserts that our internal instance variable is
being set and recalled. It does not assert that our date parsing is
working as expected.

The other error is using an ambiguous date. Depending on the way
the parser chooses to parse the date, we could be setting the date as
Feb 1 or Jan 2. Instead of trying to remember variability amongst
languages, or even language implementations, we should choose a date that will be
unambiguous to the parser and throw a parse error if invalid.
`"01/31/2014"` would be a better example.

>   As a side note, it turns out that Rails no longer supports the above
>   date format in the String#to_date method. So, as a side bonus, using the
>   unambiguous date in other places in our code could also alert us to changes
>   in an underlying API that may otherwise go undetected in our test
>   suite.

Let us rewrite that spec to be more robust:

```ruby
describe Assignment do
  it 'sets the date' do
    subject.set_due_date("01/31/2014")
    expect(subject.due_date).month.to eq(1)
  end
end
```

This fails with a Date parse error. We can rewrite our Date
parsing to be more specific about our expected date format.

```ruby
class Assignment
  def set_due_date(date_string)
    @due_date = Date.strptime(date_string, "%m/%d/%Y")
  end

  def due_date
    @due_date
  end
end
```
