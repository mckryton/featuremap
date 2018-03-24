Ability: create freemind file
  Calling the mapper will result in a new freemind mindmap file by default. This
  file will serve as a container for all features and scenarios.

  Scenario: feature dir with feature
    Given the feature dir contains a feature file
    When the mapper is called
    Then a mindmap file is created
     And the mindmap contains a node with the feature name

  Scenario: feature dir contains subdirs
    Given the feature dir contains at least one subdir
     And the subdir contains a feature file
    When the mapper is called
    Then a mindmap file is created
     And the mindmap contains a node with the subdir
     And the subdir node contains a node with the feature
     And the subdir node is marked by a folder icon

#  Scenario: feature dir is empty
#    Given the feature dir does not contain any folder or feature file
#    When the mapper is called
#    Then only a warning message is shown

# new feature ? set out name automatically
