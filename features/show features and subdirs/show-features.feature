Ability: show features
  Calling the mapper will result in a new freemind mindmap. The mindmap will
  show all feature files as separate nodes.

  # rule: turn features into mindmap nodes
  # - show features as mindmap nodes
  # - add a lightbulb icon to mark them as nr_of_features

  @debug
  Scenario Outline: show features
    Given a feature dir <feature_dir>
      And it contains <nr_of_features>
     When the mapper is called
     Then a mindmap file without any validation error is created
      And the mindmap contains a root node named "featuremap"
      And the mindmap contains <nr_of_features> nodes

      Examples:
      |nr_of_features|feature_dir|
      |0|feature_dir_empty|
      |1|feature_dir_single|
      |3|feature_dir_multiple|


  Scenario: ignore other file types
    Given a feature dir "mixed_files"
      And it contains <nr_of_files> files of <file_type>
            |nr_of_files|file_type|
            |3|feature|
            |1|txt|
            |1|csv|
     When the mapper is called
     Then a mindmap file without any validation error is created
      And the mindmap contains only 3 feature nodes
