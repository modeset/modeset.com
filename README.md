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

* Add classes on main page init
  * Add .no-touch to .js and css :hover states
  * .ready for css animations
* Add Embetter for videos
* Add sweet canvas mode set logo for desktop on left side of header
* Add a nice homepage-style link at the bottom of each section to keep the visitor reading
* unique page metatags
* 404 handling
* Add role/aria attrs from v1
* Add New Relic & Google Analytics stuff from V1
* Add metatags from v1 and from Cacheflowe.com
* Add a shitty/old browser message
* Redirect old URLs
* Blog migration
  * modeset.com/what-we-know/feed - Should we keep the blog RSS feed intact?
