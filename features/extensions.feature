Feature: Extensions
  In order to have an open source ecosystem for stylesheets
  As a compass user
  I can install extensions that others have created
  And I can create and publish my own extensions

  @listframeworks
  Scenario: Extensions directory for stand_alone projects
    Given I am using the existing project in test/fixtures/stylesheets/compass
    And the "extensions" directory exists
    And and I have a fake extension at extensions/testing
    When I run: compass frameworks
    Then the list of frameworks includes "testing"

  @listframeworks
  Scenario: Extensions directory for rails projects
    Given ruby supports fork
    And I'm in a newly created rails project: my_rails_project
    And the "my_rails_project/vendor/plugins/compass/extensions" directory exists
    And and I have a fake extension at my_rails_project/vendor/plugins/compass/extensions/testing
    When I run: compass frameworks
    Then the list of frameworks includes "testing"

  @listframeworks
  Scenario: Shared extensions directory
    Given I am using the existing project in test/fixtures/stylesheets/compass
    And the "~/.compass/extensions" directory exists
    And and I have a fake extension at ~/.compass/extensions/testing
    When I run: compass frameworks
    Then the list of frameworks includes "testing"
