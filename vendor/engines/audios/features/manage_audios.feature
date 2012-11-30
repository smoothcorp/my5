@audios
Feature: Audios
  In order to have audios on my website
  As an administrator
  I want to manage audios

  Background:
    Given I am a logged in refinery user
    And I have no audios

  @audios-list @list
  Scenario: Audios List
   Given I have audios titled UniqueTitleOne, UniqueTitleTwo
   When I go to the list of audios
   Then I should see "UniqueTitleOne"
   And I should see "UniqueTitleTwo"

  @audios-valid @valid
  Scenario: Create Valid Audio
    When I go to the list of audios
    And I follow "Add New Audio"
    And I fill in "Title" with "This is a test of the first string field"
    And I press "Save"
    Then I should see "'This is a test of the first string field' was successfully added."
    And I should have 1 audio

  @audios-invalid @invalid
  Scenario: Create Invalid Audio (without title)
    When I go to the list of audios
    And I follow "Add New Audio"
    And I press "Save"
    Then I should see "Title can't be blank"
    And I should have 0 audios

  @audios-edit @edit
  Scenario: Edit Existing Audio
    Given I have audios titled "A title"
    When I go to the list of audios
    And I follow "Edit this audio" within ".actions"
    Then I fill in "Title" with "A different title"
    And I press "Save"
    Then I should see "'A different title' was successfully updated."
    And I should be on the list of audios
    And I should not see "A title"

  @audios-duplicate @duplicate
  Scenario: Create Duplicate Audio
    Given I only have audios titled UniqueTitleOne, UniqueTitleTwo
    When I go to the list of audios
    And I follow "Add New Audio"
    And I fill in "Title" with "UniqueTitleTwo"
    And I press "Save"
    Then I should see "There were problems"
    And I should have 2 audios

  @audios-delete @delete
  Scenario: Delete Audio
    Given I only have audios titled UniqueTitleOne
    When I go to the list of audios
    And I follow "Remove this audio forever"
    Then I should see "'UniqueTitleOne' was successfully removed."
    And I should have 0 audios
 