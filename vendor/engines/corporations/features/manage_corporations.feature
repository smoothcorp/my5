@corporations
Feature: Corporations
  In order to have corporations on my website
  As an administrator
  I want to manage corporations

  Background:
    Given I am a logged in refinery user
    And I have no corporations

  @corporations-list @list
  Scenario: Corporations List
   Given I have corporations titled UniqueTitleOne, UniqueTitleTwo
   When I go to the list of corporations
   Then I should see "UniqueTitleOne"
   And I should see "UniqueTitleTwo"

  @corporations-valid @valid
  Scenario: Create Valid Corporation
    When I go to the list of corporations
    And I follow "Add New Corporation"
    And I fill in "Name" with "This is a test of the first string field"
    And I press "Save"
    Then I should see "'This is a test of the first string field' was successfully added."
    And I should have 1 corporation

  @corporations-invalid @invalid
  Scenario: Create Invalid Corporation (without name)
    When I go to the list of corporations
    And I follow "Add New Corporation"
    And I press "Save"
    Then I should see "Name can't be blank"
    And I should have 0 corporations

  @corporations-edit @edit
  Scenario: Edit Existing Corporation
    Given I have corporations titled "A name"
    When I go to the list of corporations
    And I follow "Edit this corporation" within ".actions"
    Then I fill in "Name" with "A different name"
    And I press "Save"
    Then I should see "'A different name' was successfully updated."
    And I should be on the list of corporations
    And I should not see "A name"

  @corporations-duplicate @duplicate
  Scenario: Create Duplicate Corporation
    Given I only have corporations titled UniqueTitleOne, UniqueTitleTwo
    When I go to the list of corporations
    And I follow "Add New Corporation"
    And I fill in "Name" with "UniqueTitleTwo"
    And I press "Save"
    Then I should see "There were problems"
    And I should have 2 corporations

  @corporations-delete @delete
  Scenario: Delete Corporation
    Given I only have corporations titled UniqueTitleOne
    When I go to the list of corporations
    And I follow "Remove this corporation forever"
    Then I should see "'UniqueTitleOne' was successfully removed."
    And I should have 0 corporations
 