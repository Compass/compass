Feature: Command Line
  In order to manage my stylesheets
  As a user on the command line
  I want to create a new project

  Scenario: Install a project without a framework
    When I enter the command: compass create my_project
    Then a directory my_project/ is created
    And a configuration file my_project/config.rb is created
    And a sass file my_project/src/screen.sass is created
    And a sass file my_project/src/print.sass is created
    And a sass file my_project/src/ie.sass is created
    And a sass file my_project/src/screen.sass is compiled
    And a sass file my_project/src/print.sass is compiled
    And a sass file my_project/src/ie.sass is compiled
    And a css file my_project/stylesheets/screen.css is created
    And a css file my_project/stylesheets/print.css is created
    And a css file my_project/stylesheets/ie.css is created
    And I am told how to link to /stylesheets/screen.css for media "screen, projection"
    And I am told how to link to /stylesheets/print.css for media "print"
    And I am told how to conditionally link IE to /stylesheets/ie.css for media "screen, projection"
