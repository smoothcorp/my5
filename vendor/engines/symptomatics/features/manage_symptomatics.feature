@symptomatics
Feature: Symptomatics
  In order to have symptomatics on my website
  As an administrator
  I want to manage symptomatics

  Background:
    Given I am a logged in refinery user
    And I have no symptomatics

  @symptomatics-list @list
  Scenario: Symptomatics List
   Given I have symptomatics titled UniqueTitleOne, UniqueTitleTwo
   When I go to the list of symptomatics
   Then I should see "UniqueTitleOne"
   And I should see "UniqueTitleTwo"

  @symptomatics-valid @valid
  Scenario: Create Valid Symptomatic
    When I go to the list of symptomatics
    And I follow "Add New Symptomatic"
    And I fill in "Condition" with "This is a test of the first string field"
    And I press "Save"
    Then I should see "'This is a test of the first string field' was successfully added."
    And I should have 1 symptomatic

  @symptomatics-invalid @invalid
  Scenario: Create Invalid Symptomatic (without condition)
    When I go to the list of symptomatics
    And I follow "Add New Symptomatic"
    And I press "Save"
    Then I should see "Condition can't be blank"
    And I should have 0 symptomatics

  @symptomatics-edit @edit
  Scenario: Edit Existing Symptomatic
    Given I have symptomatics titled "A condition"
    When I go to the list of symptomatics
    And I follow "Edit this symptomatic" within ".actions"
    Then I fill in "Condition" with "A different condition"
    And I press "Save"
    Then I should see "'A different condition' was successfully updated."
    And I should be on the list of symptomatics
    And I should not see "A condition"

  @symptomatics-duplicate @duplicate
  Scenario: Create Duplicate Symptomatic
    Given I only have symptomatics titled UniqueTitleOne, UniqueTitleTwo
    When I go to the list of symptomatics
    And I follow "Add New Symptomatic"
    And I fill in "Condition" with "UniqueTitleTwo"
    And I press "Save"
    Then I should see "There were problems"
    And I should have 2 symptomatics

  @symptomatics-delete @delete
  Scenario: Delete Symptomatic
    Given I only have symptomatics titled UniqueTitleOne
    When I go to the list of symptomatics
    And I follow "Remove this symptomatic forever"
    Then I should see "'UniqueTitleOne' was successfully removed."
    And I should have 0 symptomatics
 