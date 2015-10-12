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


TODO
========

* Add metatags from v1 and from Cacheflowe.com
* add team photos from lefavor
* unique page metatags
* Add role/aria attrs from v1
* Add New Relic & Google Analytics stuff from V1
* Add a shitty/old browser message
* Redirect old URLs

Post-launch:

* Do something fancy with scrollables from frighteist site
* Fancy/cool 404 page
* Blog migration
  * modeset.com/what-we-know/feed - Should we keep the blog RSS feed intact?
