@audio_programs
Feature: Audio Programs
  In order to have audio_programs on my website
  As an administrator
  I want to manage audio_programs

  Background:
    Given I am a logged in refinery user
    And I have no audio_programs

  @audio_programs-list @list
  Scenario: Audio Programs List
   Given I have audio_programs titled UniqueTitleOne, UniqueTitleTwo
   When I go to the list of audio_programs
   Then I should see "UniqueTitleOne"
   And I should see "UniqueTitleTwo"

  @audio_programs-valid @valid
  Scenario: Create Valid Audio Program
    When I go to the list of audio_programs
    And I follow "Add New Audio Program"
    And I fill in "Title" with "This is a test of the first string field"
    And I press "Save"
    Then I should see "'This is a test of the first string field' was successfully added."
    And I should have 1 audio_program

  @audio_programs-invalid @invalid
  Scenario: Create Invalid Audio Program (without title)
    When I go to the list of audio_programs
    And I follow "Add New Audio Program"
    And I press "Save"
    Then I should see "Title can't be blank"
    And I should have 0 audio_programs

  @audio_programs-edit @edit
  Scenario: Edit Existing Audio Program
    Given I have audio_programs titled "A title"
    When I go to the list of audio_programs
    And I follow "Edit this audio_program" within ".actions"
    Then I fill in "Title" with "A different title"
    And I press "Save"
    Then I should see "'A different title' was successfully updated."
    And I should be on the list of audio_programs
    And I should not see "A title"

  @audio_programs-duplicate @duplicate
  Scenario: Create Duplicate Audio Program
    Given I only have audio_programs titled UniqueTitleOne, UniqueTitleTwo
    When I go to the list of audio_programs
    And I follow "Add New Audio Program"
    And I fill in "Title" with "UniqueTitleTwo"
    And I press "Save"
    Then I should see "There were problems"
    And I should have 2 audio_programs

  @audio_programs-delete @delete
  Scenario: Delete Audio Program
    Given I only have audio_programs titled UniqueTitleOne
    When I go to the list of audio_programs
    And I follow "Remove this audio program forever"
    Then I should see "'UniqueTitleOne' was successfully removed."
    And I should have 0 audio_programs
 