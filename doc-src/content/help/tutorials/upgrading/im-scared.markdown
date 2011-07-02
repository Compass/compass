---
title: I'm Scared to Upgrade
layout: tutorial
crumb: Scared to Upgrade?
classnames:
  - tutorial
---
# I'm scared to upgrade.

Why? Don't ya trust me? I won't break your stylesheets. Cross my heart. All those
200+ github issues were feature requests. Honest. But you know, they might change
a little. Probably not in any meaningful way. Like a default that used to be
specified in the output might be omitted because it's the browser default anyway.

## Trust but verify.

But you should probably keep me on my toes. Follow these simple steps to see
what changed to your stylesheets:

*(Steps beginning with a $ are command line commands. Don't type the $.)*

1. $ cd my_compass_project
2. $ compass compile --force
3. $ cp -r stylesheets stylesheets.backup
4. $ gem install compass # you might need to type sudo first if you're on mac or linux.
5. $ compass compile --force
6. Take note of any deprecation warnings printed in red during the compile.
7. If you have textmate and installed the `mate` command line tool:<br>
   $ diff -r stylesheets.backup stylesheets | mate
8. If you have not installed the `mate` tool:<br>
   $ sudo ln -s /Applications/TextMate.app/Contents/Resources/mate /usr/local/bin/mate
   Then perform step 7.
9. If you do not have Textmate, run the diff command like so:
   $ diff -y -r stylesheets.backup stylesheets | less
10. Scroll or use your arrow keys to review the differences between the files.
11. If you're satisfied: $ git commit -a -m "Upgraded compass"
12. If you're scared again:
    1. Don't panic.
    2. Read the [CHANGELOG](http://compass-style.org/CHANGELOG/) and
       see if the changes are explained there.
    3. Send an email to the [mailing list](http://groups.google.com/group/compass-users)
       explaining the problem and providing enough context like snippets from your diff
       and the relevant snippets of your sass/scss files. In rare cases we might request
       that you construct a simple compass project that exhibits the issue and make an
       archive of it and send us an email with it attached.
    4. If it's pretty obviously a bug. Please file an issue
       on [github](http://github.com/chriseppstein/compass/issues). If you're experiencing
       a crash, please run the command with the --trace option and record the output for
       diagnostic purposes.
    5. $ sudo gem uninstall compass
       Select the newest version of compass. You have now downgraded to the old
       version of compass.
    6. $ compass compile --force
    7. Diff the folders as in steps 7 through 9.
13. Breathe a sigh of relief.
       
       

