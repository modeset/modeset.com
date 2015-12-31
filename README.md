Mode Set
========

Rails app powering [modeset.com](http://www.modeset.com/)

Run `bundle` and `rackup` to run the site.

Pushing
========

* Set up Heroku:
  * `heroku login`
  * `heroku keys:add`
* Push version2 branch to staging with: `git push -f staging version2:master`
* Pushing master to production:
  * git remote add modeset git@heroku.com:modeset.git
  * git push modeset master

TODO
========

* Add awards in Work?
  * http://www.thefwa.com/profile/mode-set
  * http://www.awwwards.com/best-websites/build-your-own-boxtroll/
  * http://www.awwwards.com/web-design-awards/roll-it
* Press/photos:
  * http://jamiekripke.com/building-ello/
* Add a newsletter signup on find-us page
* Fix this: http://modeset.com/what-we-know/2013/01/30/a-simple-capybara-spider
* Blog migration
  * modeset.com/what-we-know/feed - Should we keep the blog RSS feed intact?
* add team photos from lefavor
* Add role/aria attrs from v1?
* Move newsletter images into their own sub-directory
* Add New Relic stuff from V1?
* Add a shitty/old browser message
* Re-implement .footerbars on team page with flexbox to make it look right
* Make sure site is navigable with a keyboard - build nice active states for tabbing around
* Do something fancy with scrollables from frighteist site
* Fancy/cool 404 page
* Unique page metatags?
