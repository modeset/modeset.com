# Mode Set
Rails app powering [modeset.com](http://www.modeset.com/)

## Getting the project running
```
brew install icu4c
bundle config build.charlock_holmes --with-icu-dir=/usr/local/opt/icu4c
bundle install
powder link
```

## Creating a new post
```
rails g postmarkdown:post <slug>
```
