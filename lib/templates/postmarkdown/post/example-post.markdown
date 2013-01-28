---
title: <%= slug.gsub('-',' ').capitalize %>
<%- if author = (Postmarkdown::Util.git_config('user.name') || ENV['GIT_AUTHOR_NAME']) -%>
author: <%= author %>
<%- end -%>
<%- if email = (Postmarkdown::Util.git_config('user.email') || ENV['GIT_AUTHOR_EMAIL']) -%>
email: <%= email %>
<%- end -%>
image: fpo/test-thumb.png
---

Pig drumstick nostrud pork loin sed. Irure turkey tongue, prosciutto cupidatat tempor eiusmod in laborum shankle turducken dolor pastrami anim. Sed irure ea rump meatloaf. Frankfurter cupidatat aute, boudin ad sed bacon ground round laboris.
