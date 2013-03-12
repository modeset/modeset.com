---
title: Avoiding Keychain issues with Jenkins Xcode builds
author: Jay Zeschin
email: jay.zeschin@modeset.com
image: blog/jenkins.png
---

We have a client with a suite of iOS apps that are based on the same codebase but configured independently to build distinct apps with their own assets,content, and functionality. To ease to process of actually generating all of the working app binaries for each configuration, we use the awesome [Jenkins](http://jenkinsci.org/) build server running on a Mac Mini to fire up a parameterized matrix build that executes all of the automated testing, configuring, building, and distributing to [TestFlight](http://www.testflightapp.com/) necessary for a nice [continuous delivery flow](http://en.wikipedia.org/wiki/Continuous_delivery).

Generally speaking, this works great. However, as with any complex build process, it requires a bit of effort to make sure that things are consistent and repeatable. I'm not going to go into all of the details of our setup here - suffice it to say that you can do amazing things with environment variables, `xcodebuild`, and glue scripts in your Xcode build process - but one of the biggest pain points on that front has been configuring Xcode's code signing to work consistently in an automated way.

The first issue was getting around the dreaded ["User interaction is not allowed" error](https://www.google.com/search?q=user+interaction+is+not+allowed+xcodevbuild&oq=user+interaction+is+not+allowed+xcodevbuild) during the code signing step in the `xcodebuild` run. The root of that problem is that `codesign` requires [login context](http://developer.apple.com/library/mac/#technotes/tn2083/_index.html) to properly access the keychain. This was a relatively easy one to solve, and in fact, it's now the default behavior when you install Jenkins via Homebrew. The key is to make sure the `launchd` configuration plist is placed in/loaded from `/Library/LaunchAgents`, __not__ `~/Library/LaunchDaemons`. `LaunchAgents` are launched with login context, `LaunchDaemons` are not. The downside of this arrangement is that agents are not launched until a user logs in on the machine, but this is less of an issue for us since the box is running all the time and set up to automatically log in the appropriate user.

The second issue was a trickier one, and took us a while to track down.  We had noticed issues with concurrency and builds hanging intermittently, manifested in the form of seemingly random prompts for a keychain password, triggered by the background build process, which would eventually cause our builds to timeout and fail. The solution to this was twofold:

First, run builds using their own temporary keychains instead of the login keychain. This is probably a good idea anyway - makes builds more repeatable, and prevents anything that's running on the machine and monkeying with the login keychain from cratering your build randomly. You can accomplish this with something like the following:

```bash
  security -v create-keychain -p my-temporary-password /tmp/my-temporary-keychain.keychain
  security -v import /path/to/developer/cert -k /tmp/my-temporary-keychain.keychain -P developer-cert-password -T /usr/bin/codesign
  security -v list-keychain -s /tmp/my-temporary-keychain.keychain
  security -v unlock-keychain -p my-temporary-password /tmp/my-temporary-keychain.keychain
```

Then, when you script your `xcodebuild` command, pass the following
environment variable to force `codesign` to use your new temporary
keychain:

```
OTHER_CODE_SIGN_FLAGS='--keychain /tmp/my-temporary-keychain'
```

Second, extend the keychain timeout setting so that it doesn't re-prompt during the build. This was way harder to figure out (I for one didn't know keychains had a timeout setting, though I suppose it makes sense that they would), but relatively easy to change. Add something like the following to your build script to extend the keychain unlock timeout to 2 hours. That should be more than plenty for almost any iOS app build.

```bash
  security -v set-keychain-settings -lut 7200 /tmp/my-temporary-keychain.keychain
```


Have you tried using Jenkins to automate any complicated Xcode-based processes? What has your experience been?
