Feature: Command Line
  In order to manage my stylesheets
  As a user on the command line
  I want to create a new project

  Scenario: Install a project without a framework
    When I run: compass create my_project
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
    And I am told how to conditionally link "IE" to /stylesheets/ie.css for media "screen, projection"

  Scenario: Install a project with blueprint
    When I run: compass create bp_project --using blueprint
    Then a directory bp_project/ is created
    And a configuration file bp_project/config.rb is created
    And a sass file bp_project/src/screen.sass is created
    And a sass file bp_project/src/print.sass is created
    And a sass file bp_project/src/ie.sass is created
    And a sass file bp_project/src/screen.sass is compiled
    And a sass file bp_project/src/print.sass is compiled
    And a sass file bp_project/src/ie.sass is compiled
    And a css file bp_project/stylesheets/screen.css is created
    And a css file bp_project/stylesheets/print.css is created
    And a css file bp_project/stylesheets/ie.css is created
    And an image file bp_project/images/grid.png is created
    And I am told how to link to /stylesheets/screen.css for media "screen, projection"
    And I am told how to link to /stylesheets/print.css for media "print"
    And I am told how to conditionally link "lt IE 8" to /stylesheets/ie.css for media "screen, projection"

  Scenario: Install a project with specific directories
    When I run: compass create custom_project --using blueprint --sass-dir sass --css-dir css --images-dir assets/imgs
    Then a directory custom_project/ is created
    And a directory custom_project/sass/ is created
    And a directory custom_project/css/ is created
    And a directory custom_project/assets/imgs/ is created
    And a sass file custom_project/sass/screen.sass is created
    And a css file custom_project/css/screen.css is created
    And an image file custom_project/assets/imgs/grid.png is created

  Scenario: Perform a dry run of creating a project
    When I run: compass create my_project --dry-run
    Then a directory my_project/ is not created
    But a configuration file my_project/config.rb is reported created
    And a sass file my_project/src/screen.sass is reported created
    And a sass file my_project/src/print.sass is reported created
    And a sass file my_project/src/ie.sass is reported created
    And I am told how to link to /stylesheets/screen.css for media "screen, projection"
    And I am told how to link to /stylesheets/print.css for media "print"
    And I am told how to conditionally link "IE" to /stylesheets/ie.css for media "screen, projection"

