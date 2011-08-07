---
title: "How to use Compass/Sass with Django."
description: "All the documentation is for Ruby/Rails development, so how does it work for the rest of us?"
author: eric
---

It's easy! Follow these two simple steps:

1. Use Compass/Sass.
2. Use Django. 

That's it. Compass works great as a stand-alone tool. Run "compass --watch" on the command line or use [compass.app](http://compass.handlino.com/) to compile your stylesheets, and then commit the CSS to your Django project, just like you always have. Done.

## What about integration?

Compass and Sass are built in Ruby. When the rest of your project is also built in Ruby, it makes sense to squeeze every last ounce of convenient automatic integration, like having your project automatically compile Sass to CSS for you at runtime. But that integration is not actually necessary, and when the rest of your project is not Ruby, you pay a lot more for that little bit of convenience.

A Rails/Ruby project already has a full Ruby stack and deployment infrastructure to make sure all the right Ruby gems are available on the server. Adding a few Compass gems makes very little difference in the complexity of your production deployment.

For a Django project, integrating run-time Compass compilation (via something like [django-css](https://github.com/dziegler/django-css)) means requiring a full Ruby stack on your production servers, plus new deployment infrastructure for getting all the right gem versions in place. This is a significant chunk of additional moving parts on your production servers.

Keeping your production servers simpler is A Very Good Thing. (And, as a bonus, it allows you to deploy your project to pure-Python managed hosting environments).

## In development.

The disadvantage to our approach is that you are committing generated code to the repo. That's generally frowned upon. But we haven't seen any actual problems as a result of this. Nobody on the team is tempted to edit the generated CSS directly; we all know that we use Compass for that. There are no mysterious display inconsistencies between one developer and another, or between development and production, because of minor differences in something like a Compass plugin gem version. Everyone sees the same CSS. Differences between developers' Compass environments are caught quickly, because they show up right away as unexpected changes in the pre-commit diff of the generated CSS.

And I, as the designer/front-end developer, keep full control of the css-generation process without needing to touch the server. If I want to update the gems and make some changes, I can do that. I make the change, I commit the change, and it just works. For everyone. That's important to me. It removes all the pretense of dark magic that can come with Sass/Compass. I'm writing CSS. I'm committing CSS. Compass, Sass and all their plugins are just tools towards that end.

Of course, you'll want to commit the Sass as well, especially if you have multiple front-end developers on the team. That way the source is available for anyone who needs to update it, even though it's not needed by the server. You might also want a way of documenting the latest gems that should be used to compile it. That's easy enough to add in a comment or doc of it's own. 

## Just Tools.

I want to say that again because I think it is the most important and most often forgotten rule of using a css pre-processor. **Compass and Sass are simply tools for writing CSS. They are not a new styling language. They are not magic. They make writing css easier - and that is all. The css output is the only thing that matters.**