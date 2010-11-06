Feature: Command Line
  In order to manage my stylesheets
  As a user on the command line
  I want to create a new project

  Scenario: Install a project without a framework
    When I create a project using: compass create my_project
    Then a directory my_project/ is created
    And a configuration file my_project/config.rb is created
    And a sass file my_project/src/screen.scss is created
    And a sass file my_project/src/print.scss is created
    And a sass file my_project/src/ie.scss is created
    And a sass file my_project/src/screen.scss is compiled
    And a sass file my_project/src/print.scss is compiled
    And a sass file my_project/src/ie.scss is compiled
    And a css file my_project/stylesheets/screen.css is created
    And a css file my_project/stylesheets/print.css is created
    And a css file my_project/stylesheets/ie.css is created
    And I am told how to link to /stylesheets/screen.css for media "screen, projection"
    And I am told how to link to /stylesheets/print.css for media "print"
    And I am told how to conditionally link "IE" to /stylesheets/ie.css for media "screen, projection"

  Scenario: Install a project with blueprint
    When I create a project using: compass create bp_project --using blueprint
    Then a directory bp_project/ is created
    And a configuration file bp_project/config.rb is created
    And a sass file bp_project/src/screen.scss is created
    And a sass file bp_project/src/print.scss is created
    And a sass file bp_project/src/ie.scss is created
    And a sass file bp_project/src/screen.scss is compiled
    And a sass file bp_project/src/print.scss is compiled
    And a sass file bp_project/src/ie.scss is compiled
    And a css file bp_project/stylesheets/screen.css is created
    And a css file bp_project/stylesheets/print.css is created
    And a css file bp_project/stylesheets/ie.css is created
    And an image file bp_project/images/grid.png is created
    And I am told how to link to /stylesheets/screen.css for media "screen, projection"
    And I am told how to link to /stylesheets/print.css for media "print"
    And I am told how to conditionally link "lt IE 8" to /stylesheets/ie.css for media "screen, projection"

  Scenario: Install a project with specific directories
    When I create a project using: compass create custom_project --using blueprint --sass-dir sass --css-dir css --images-dir assets/imgs
    Then a directory custom_project/ is created
    And a directory custom_project/sass/ is created
    And a directory custom_project/css/ is created
    And a directory custom_project/assets/imgs/ is created
    And a sass file custom_project/sass/screen.scss is created
    And a css file custom_project/css/screen.css is created
    And an image file custom_project/assets/imgs/grid.png is created

  Scenario: Perform a dry run of creating a project
    When I create a project using: compass create my_project --dry-run
    Then a directory my_project/ is not created
    But a configuration file my_project/config.rb is reported created
    And a sass file my_project/src/screen.scss is reported created
    And a sass file my_project/src/print.scss is reported created
    And a sass file my_project/src/ie.scss is reported created
    And I am told how to link to /stylesheets/screen.css for media "screen, projection"
    And I am told how to link to /stylesheets/print.css for media "print"
    And I am told how to conditionally link "IE" to /stylesheets/ie.css for media "screen, projection"

  Scenario: Creating a bare project
    When I create a project using: compass create bare_project --bare
    Then a directory bare_project/ is created
    And a configuration file bare_project/config.rb is created
    And a directory bare_project/src/ is created
    And a directory bare_project/stylesheets/ is not created
    And I am congratulated
    And I am told that I can place stylesheets in the src subdirectory
    And I am told how to compile my sass stylesheets

  Scenario: Creating a bare project with a framework
    When I create a project using: compass create bare_project --using blueprint --bare
    Then an error message is printed out: A bare project cannot be created when a framework is specified.
    And the command exits with a non-zero error code

  Scenario: Initializing a rails project
    Given I'm in a newly created rails project: my_rails_project
    When I initialize a project using: compass init rails --sass-dir app/stylesheets --css-dir public/stylesheets/compiled
    Then a config file config/compass.rb is reported created
    Then a config file config/compass.rb is created
    And a sass file app/stylesheets/screen.scss is created
    And a sass file app/stylesheets/print.scss is created
    And a sass file app/stylesheets/ie.scss is created

  Scenario: Compiling an existing project.
    Given I am using the existing project in test/fixtures/stylesheets/compass
    When I run: compass compile
    Then a directory tmp/ is created
    And a sass file sass/layout.sass is reported compiled
    And a sass file sass/print.sass is reported compiled
    And a sass file sass/reset.sass is reported compiled
    And a sass file sass/utilities.scss is reported compiled
    And a css file tmp/layout.css is created
    And a css file tmp/print.css is created
    And a css file tmp/reset.css is created
    And a css file tmp/utilities.css is created

  Scenario: Compiling an existing project with a specified project
    Given I am using the existing project in test/fixtures/stylesheets/compass
    And I am in the parent directory
    When I run: compass compile tmp_compass
    Then a directory tmp_compass/tmp/ is created
    And a sass file tmp_compass/sass/layout.sass is reported compiled
    And a sass file tmp_compass/sass/print.sass is reported compiled
    And a sass file tmp_compass/sass/reset.sass is reported compiled
    And a sass file tmp_compass/sass/utilities.scss is reported compiled
    And a css file tmp_compass/tmp/layout.css is created
    And a css file tmp_compass/tmp/print.css is created
    And a css file tmp_compass/tmp/reset.css is created
    And a css file tmp_compass/tmp/utilities.css is created

  Scenario: Dry Run of Compiling an existing project.
    Given I am using the existing project in test/fixtures/stylesheets/compass
    When I run: compass compile --dry-run
    Then a directory tmp/ is not created
    And a sass file sass/layout.sass is reported compiled
    And a sass file sass/print.sass is reported compiled
    And a sass file sass/reset.sass is reported compiled
    And a sass file sass/utilities.scss is reported compiled
    And a css file tmp/layout.css is not created
    And a css file tmp/print.css is not created
    And a css file tmp/reset.css is not created
    And a css file tmp/utilities.css is not created
    And a css file tmp/layout.css is reported created
    And a css file tmp/print.css is reported created
    And a css file tmp/reset.css is reported created
    And a css file tmp/utilities.css is reported created

  Scenario: Recompiling a project with no changes
    Given I am using the existing project in test/fixtures/stylesheets/compass
    When I run: compass compile
    And I run: compass compile
    Then a sass file sass/layout.sass is reported unchanged
    And a sass file sass/print.sass is reported unchanged
    And a sass file sass/reset.sass is reported unchanged
    And a sass file sass/utilities.scss is reported unchanged

  Scenario: compiling a specific file in a project
    Given I am using the existing project in test/fixtures/stylesheets/compass
    And I run: compass compile sass/utilities.scss
    Then a sass file sass/layout.sass is not mentioned
    And a sass file sass/print.sass is not mentioned
    And a sass file sass/reset.sass is not mentioned
    And a sass file sass/utilities.scss is reported compiled
    And a css file tmp/utilities.css is reported created
    And a css file tmp/utilities.css is created

  Scenario: Re-compiling a specific file in a project with no changes
    Given I am using the existing project in test/fixtures/stylesheets/compass
    When I run: compass compile
    And I run: compass compile sass/utilities.scss
    Then a sass file sass/layout.sass is not mentioned
    And a sass file sass/print.sass is not mentioned
    And a sass file sass/reset.sass is not mentioned
    And a sass file sass/utilities.scss is reported compiled
    And a css file tmp/utilities.css is reported identical

  Scenario: Installing a pattern into a project
    Given I am using the existing project in test/fixtures/stylesheets/compass
    When I run: compass install blueprint/buttons
    Then a sass file sass/buttons.scss is created
    And an image file images/buttons/cross.png is created
    And an image file images/buttons/key.png is created
    And an image file images/buttons/tick.png is created
    And a css file tmp/buttons.css is created

  Scenario: Basic help
    When I run: compass help
    Then I should see the following "primary" commands:
      | compile |
      | create  |
      | init    |
      | watch   |
    And I should see the following "other" commands:
      | config      |
      | frameworks  |
      | grid-img    |
      | help        |
      | imports     |
      | install     |
      | interactive |
      | stats       |
      | unpack      |
      | validate    |
      | version     |

  Scenario: Recompiling a project with no material changes
    Given I am using the existing project in test/fixtures/stylesheets/compass
    When I run: compass compile
    And I wait 1 second
    And I touch sass/layout.sass
    And I run: compass compile
    Then a sass file sass/layout.sass is reported compiled
    Then a css file tmp/layout.css is reported identical
    And a sass file sass/print.sass is reported unchanged
    And a sass file sass/reset.sass is reported unchanged
    And a sass file sass/utilities.scss is reported unchanged

  Scenario: Recompiling a project with changes
    Given I am using the existing project in test/fixtures/stylesheets/compass
    When I run: compass compile
    And I wait 1 second
    And I add some sass to sass/layout.sass
    And I run: compass compile
    Then a sass file sass/layout.sass is reported compiled
    And a css file tmp/layout.css is reported overwritten
    And a sass file sass/print.sass is reported unchanged
    And a sass file sass/reset.sass is reported unchanged
    And a sass file sass/utilities.scss is reported unchanged

  Scenario: Watching a project for changes
    Given I am using the existing project in test/fixtures/stylesheets/compass
    When I run: compass compile
    And I run in a separate process: compass watch 
    And I wait 1 second
    And I touch sass/layout.sass
    And I wait 2 seconds
    And I shutdown the other process
    Then a css file tmp/layout.css is reported identical

  Scenario: Generating a grid image so that I can debug my grid alignments
    Given I am using the existing project in test/fixtures/stylesheets/compass
    When I run: compass grid-img 30+10x24
    Then a png file images/grid.png is created
    And the image images/grid.png has a size of 40x24

  Scenario: Generating a grid image to a specified path with custom dimensions
    Given I am using the existing project in test/fixtures/stylesheets/compass
    When I run: compass grid-img 50+10x24 assets/wide_grid.png
    Then a directory assets is created
    Then a png file assets/wide_grid.png is created
    And the image assets/wide_grid.png has a size of 60x24

  Scenario: Generating a grid image with invalid dimensions
    Given I am using the existing project in test/fixtures/stylesheets/compass
    When I run: compass grid-img 50x24 assets/wide_grid.png
    Then a directory assets is not created
    And a png file assets/wide_grid.png is not created

  Scenario: Generate a compass configuration file
    Given I should clean up the directory: config
    When I run: compass config config/compass.rb --sass-dir sass --css-dir assets/css
    Then a configuration file config/compass.rb is created
    And the following configuration properties are set in config/compass.rb:
      | property | value      |
      | sass_dir | sass       |
      | css_dir  | assets/css |

  @now
  Scenario Outline: Print out a configuration value
    Given I am using the existing project in test/fixtures/stylesheets/compass
    When I run: compass config -p <property>
    Then I should see the following output: <value>
    And the command exits <exit>
  
    Examples:
      | property        | value                    | exit     |
      | extensions_dir  | extensions               | normally |
      | extensions_path | $PROJECT_PATH/extensions | normally |
      | css_dir         | tmp                      | normally |
      | css_path        | $PROJECT_PATH/tmp        | normally |
      | sass_dir        | sass                     | normally |
      | sass_path       | $PROJECT_PATH/sass       | normally |
      | foobar          | ERROR: configuration property 'foobar' does not exist | with a non-zero error code | 

  @validator @ignore
  Scenario: Validate the generated CSS
    Given I am using the existing project in test/fixtures/stylesheets/compass
    When I run: compass validate
    Then my css is validated
    And I am informed that my css is valid.

  @stats
  Scenario: Get stats for my project
    Given I am using the existing project in test/fixtures/stylesheets/compass
    When I run: compass stats
    Then I am told statistics for each file:
      | Filename                  | Rules | Properties |    Mixins Defs | Mixins Used | CSS Rules | CSS Properties |
      | sass/border_radius.scss   |     3 |          0 |              0 |           3 |         3 |             18 |
      | sass/box.sass             |    15 |          0 |              0 |          19 |        15 |             59 |
      | sass/fonts.sass           |     0 |          0 |              0 |           1 |         1 |              2 |
      | sass/gradients.sass       |    19 |          0 |              0 |          19 |        19 |             19 |
      | sass/image_size.sass      |     4 |          8 |              0 |           0 |         4 |              8 |
      | sass/images.scss          |     3 |          3 |              0 |           0 |         3 |              3 |
      | sass/layout.sass          |     0 |          0 |              0 |           1 |         5 |             10 |
      | sass/legacy_clearfix.scss |     2 |          0 |              0 |           2 |         5 |             11 |
      | sass/lists.scss           |    10 |          0 |              0 |          10 |        39 |            123 |
      | sass/print.sass           |     0 |          0 |              0 |           2 |        61 |             61 |
      | sass/reset.sass           |     4 |          1 |              0 |           2 |       190 |            664 |
      | sass/utilities.scss       |     2 |          0 |              0 |           2 |         3 |              9 |
      | ------------------------- | ----- | ---------- | -------------- | ----------- | --------- | -------------- |
      | Total.*                   |    62 |         12 |              0 |          61 |       348 |            987 |

  @listframeworks
  Scenario: List frameworks registered with compass
    When I run: compass frameworks
    Then I should see the following lines of output:
      | blueprint  |
      | compass    |

