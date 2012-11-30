@my_eqs
Feature: My Eqs
  In order to have my_eqs on my website
  As an administrator
  I want to manage my_eqs

  Background:
    Given I am a logged in refinery user
    And I have no my_eqs

  @my_eqs-list @list
  Scenario: My Eqs List
   Given I have my_eqs titled UniqueTitleOne, UniqueTitleTwo
   When I go to the list of my_eqs
   Then I should see "UniqueTitleOne"
   And I should see "UniqueTitleTwo"

  @my_eqs-valid @valid
  Scenario: Create Valid My Eq
    When I go to the list of my_eqs
    And I follow "Add New My Eq"
    And I fill in "Emotional Grouping" with "This is a test of the first string field"
    And I press "Save"
    Then I should see "'This is a test of the first string field' was successfully added."
    And I should have 1 my_eq

  @my_eqs-invalid @invalid
  Scenario: Create Invalid My Eq (without emotional_grouping)
    When I go to the list of my_eqs
    And I follow "Add New My Eq"
    And I press "Save"
    Then I should see "Emotional Grouping can't be blank"
    And I should have 0 my_eqs

  @my_eqs-edit @edit
  Scenario: Edit Existing My Eq
    Given I have my_eqs titled "A emotional_grouping"
    When I go to the list of my_eqs
    And I follow "Edit this my_eq" within ".actions"
    Then I fill in "Emotional Grouping" with "A different emotional_grouping"
    And I press "Save"
    Then I should see "'A different emotional_grouping' was successfully updated."
    And I should be on the list of my_eqs
    And I should not see "A emotional_grouping"

  @my_eqs-duplicate @duplicate
  Scenario: Create Duplicate My Eq
    Given I only have my_eqs titled UniqueTitleOne, UniqueTitleTwo
    When I go to the list of my_eqs
    And I follow "Add New My Eq"
    And I fill in "Emotional Grouping" with "UniqueTitleTwo"
    And I press "Save"
    Then I should see "There were problems"
    And I should have 2 my_eqs

  @my_eqs-delete @delete
  Scenario: Delete My Eq
    Given I only have my_eqs titled UniqueTitleOne
    When I go to the list of my_eqs
    And I follow "Remove this my eq forever"
    Then I should see "'UniqueTitleOne' was successfully removed."
    And I should have 0 my_eqs
 