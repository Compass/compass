---
title: Getting Started
layout: tutorial
crumb: Getting Started
classnames:
  - tutorial
---
# Getting Started

## Installing Ruby

[Windows](http://www.ruby-lang.org/en/downloads/)
[Mac, Linx, *inx](http://rvm.beginrescueend.com/rvm/install/)

## Installing Compass

Once Ruby is installed open your terminal and run the following: 

1. `gem update --system`
2. `gem install compass`

## Creating your first Compass project

### Stand Alone

[See the install page for more details](/install)

To create a new Compass stand alone project run `compass create <project_name>`
You should see the following output:

    directory my_project/
    directory my_project/sass/
    directory my_project/stylesheets/
       create my_project/config.rb 
       create my_project/sass/screen.scss 
       create my_project/sass/print.scss 
       create my_project/sass/ie.scss 
       create my_project/stylesheets/ie.css 
       create my_project/stylesheets/print.css 
       create my_project/stylesheets/screen.css

### Rails

1. Goto your rails root directory `cd <rails_dorectory>`
2. Run the compass initalizer command `compass init rails .`
       
## Starting the Compass watcher

To start the compass watcher run `compass watch` from your projects root directory


