Feature: Merge Articles
  As an administrator
  I may find there are articles having same topics and saying similar things
  In order to combine similar articles from differnet authors into one
  I want to merge articles

  Background:
    Given the blog is set up
    And there is publisher with id, "author1"
    And "author1" writes article "Test Article 1" with "Test content for Test Article 1"
    And there is publisher with id, "author2"
    And "author2" writes article "Test Article 2" with "Test content for Test Article 2"

  Scenario: A non-admin cannot merge articles
    Given I am logged into the admin panel as "author1"
    When I go to the admin content page
    And I follow "Test Article 1"
    Then I should not see "merge_with" field
    And I should not see "Merge" button
    And I should see "Publish" button

  Scenario: An admin can merge articles
    Given I am logged into the admin panel as "admin"
    When I go to the admin content page
    And I follow "Test Article 1"
    Then I should see "merge_with" field
    And I should see "Merge" button
    And I should see "Publish" button

  Scenario: When articles are merged, the merged article should contain the text of both previous articles
    Given I am logged into the admin panel
    When I go to the admin content page
    And I follow "Test Article 1"
    And I fill in "merge_with" with article ID of "Test Article 2"
    And I press "Merge"
    Then I should not see "Test Article 2"
    And I should see "Test Article 1"
    When I follow "Test Article 1"
    Then I should see editor having "Test content for Test Article 1"
    And I should see editor having "Test content for Test Article 2"

  Scenario: When articles are merged, the merged article should have one author
    Given I am logged into the admin panel
    When I go to the admin content page
    And I follow "Test Article 1"
    And I fill in "merge_with" with article ID of "Test Article 2"
    And I press "Merge"
    Then I should not see "Test Article 2"
    And I should see "Test Article 1"
    And I should see Author of "Test Article 1" is "author1"

  Scenario: The title of the new article should be the title from either one of the merged articles
    Given I am logged into the admin panel
    When I go to the admin content page
    And I follow "Test Article 1"
    And I fill in "merge_with" with article ID of "Test Article 2"
    And I press "Merge"
    Then I should not see "Test Article 2"
    And I should see "Test Article 1"
    When I follow "Test Article 1"
    And I should see title field having "Test Article 1"
    
  Scenario: Comments on each of the two original articles need to all carry over and point to the new, merged article
    Given "Test Article 1" has comment "Comment to Article 1"
    And "Test Article 2" has comment "Comment to Article 2"
    And I am logged into the admin panel
    When I go to the admin content page
    And I follow "Test Article 1"
    And I fill in "merge_with" with article ID of "Test Article 2"
    And I press "Merge"
    Then I should not see "Test Article 2"
    And I should see "Test Article 1"
    When I follow "Dashboard"
    And I follow "Test Article 1"
    Then I should see "Comment to Article 1"
    And I should see "Comment to Article 2"


