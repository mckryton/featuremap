Ability: create freemind file
  Calling the mapper will result in a new freemind mindmap file by default. This
  file will serve as a container for all features and scenarios.

  # rule: how to handle subdirs
  # - present subdirs as mindmap nodes
  # - add folder icon to subdir nodes

  Scenario: feature dir without subdirs
    Given a feature dir "subdirs_none"
      And it contains a feature file
     When the mapper is called
     Then a mindmap file without any validation error is created
      And the mindmap contains a node with the feature name

  Scenario: feature dir with one level of subdirs
    Given a feature dir "subdirs_one_level"
      And it contains at least one subdir
      And the subdir contains a feature file
     When the mapper is called
     Then a mindmap file without any validation error is created
      And the mindmap contains a node with the subdir
      And the subdir node contains a node with the feature
      And the subdir node is marked by a folder icon

  Scenario: feature dir with multiple levels of subdirs
    Given a feature dir "subdirs_multiple_levels"
      And the feature dir contains subdirs with a different amount of features
          |subdirs|nr_of_features|
          |sub1/sub1_1|1|
          |sub2|2|
          |sub3/sub3_1/sub3_2|2|
          |sub1/sub1_2|0|
     When the mapper is called
     Then a mindmap file without any validation error is created
      And the mindmap shows nodes for every subdir
      And the node of every subdir contains the corresponding number of feature nodes

#  Scenario: feature dir is empty
#    Given the feature dir does not contain any folder or feature file
#    When the mapper is called
#    Then only a warning message is shown

# new feature ? set out name automatically
