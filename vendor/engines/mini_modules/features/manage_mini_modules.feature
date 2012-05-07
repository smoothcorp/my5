@mini_modules
Feature: Mini Modules
  In order to have mini_modules on my website
  As an administrator
  I want to manage mini_modules

  Background:
    Given I am a logged in refinery user
    And I have no mini_modules

  @mini_modules-list @list
  Scenario: Mini Modules List
   Given I have mini_modules titled UniqueTitleOne, UniqueTitleTwo
   When I go to the list of mini_modules
   Then I should see "UniqueTitleOne"
   And I should see "UniqueTitleTwo"

  @mini_modules-valid @valid
  Scenario: Create Valid Mini Module
    When I go to the list of mini_modules
    And I follow "Add New Mini Module"
    And I fill in "Title" with "This is a test of the first string field"
    And I press "Save"
    Then I should see "'This is a test of the first string field' was successfully added."
    And I should have 1 mini_module

  @mini_modules-invalid @invalid
  Scenario: Create Invalid Mini Module (without title)
    When I go to the list of mini_modules
    And I follow "Add New Mini Module"
    And I press "Save"
    Then I should see "Title can't be blank"
    And I should have 0 mini_modules

  @mini_modules-edit @edit
  Scenario: Edit Existing Mini Module
    Given I have mini_modules titled "A title"
    When I go to the list of mini_modules
    And I follow "Edit this mini_module" within ".actions"
    Then I fill in "Title" with "A different title"
    And I press "Save"
    Then I should see "'A different title' was successfully updated."
    And I should be on the list of mini_modules
    And I should not see "A title"

  @mini_modules-duplicate @duplicate
  Scenario: Create Duplicate Mini Module
    Given I only have mini_modules titled UniqueTitleOne, UniqueTitleTwo
    When I go to the list of mini_modules
    And I follow "Add New Mini Module"
    And I fill in "Title" with "UniqueTitleTwo"
    And I press "Save"
    Then I should see "There were problems"
    And I should have 2 mini_modules

  @mini_modules-delete @delete
  Scenario: Delete Mini Module
    Given I only have mini_modules titled UniqueTitleOne
    When I go to the list of mini_modules
    And I follow "Remove this mini module forever"
    Then I should see "'UniqueTitleOne' was successfully removed."
    And I should have 0 mini_modules
 