@default
Ability: build mindmap on subdirs
  Calling featuremap will result in a new freemind mindmap. The mindmap will
  show every subdir from the feature dir as a separate node by default and attach
  all features from the subdir as children nodes.
  See the "use tags/build mindmap on tags" ability if tags should be used instead of subdirs.

  # rule: turn subdirs into mindmap nodes
  # - show subdirs as mindmap nodes
  # - add a folder icon to mark them as subdirs


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
          |subdirs            |nr_of_features|
          |sub1/sub1_1        |1             |
          |sub2               |2             |
          |sub3/sub3_1/sub3_2 |2             |
          |sub1/sub1_2        |0             |
     When the mapper is called
     Then a mindmap file without any validation error is created
      And the mindmap shows nodes with a folder icon for every subdir
      And the node of every subdir contains the corresponding number of feature nodes


  # rule: don't show subdirs used for code and configuration

  Scenario: ignore step_definitions and support folders
    Given a feature dir "subdirs_code_config"
      And the feature dir contains subdirs with a different amount of features
          |subdirs            |nr_of_features|
          |sub1/sub1_1        |1             |
          |sub2               |2             |
          |step_definitions   |0             |
          |support            |0             |
     When the mapper is called
     Then a mindmap file without any validation error is created
      And the mindmap does not contain a folder node "step_definitions"
      And the mindmap does not contain a folder node "support"
