Ability: show features
  Calling the mapper will result in a new freemind mindmap. The mindmap will
  show all feature files as separate nodes.

  # rule: every feature file is shown as a node in the mindmap^

  Scenario Outline: show features
    Given a feature dir is <feature_dir_type>
      And it contains <nr_of_features>
     When the mapper is called
     Then a mindmap file without any validation error is created
      And the mindmap contains a root node named "featuremap"
      And the mindmap contains <nr_of_features> nodes

      Examples:
      |nr_of_features|feature_dir_type|
      |0             |empty           |
      |1             |single          |
      |3             |multiple        |


  # rule: other files than .feature files are ignored
  
  Scenario: ignore other file types
    Given a feature dir "mixed_files"
      And it contains <nr_of_files> files of <file_type>
            |nr_of_files|file_type|
            |3          |feature  |
            |1          |txt      |
            |1          |csv      |
     When the mapper is called
     Then a mindmap file without any validation error is created
      And the mindmap contains only 3 feature nodes


  # rule: feature names are using a bold font

  Scenario: format feature names in bold
    Given a feature dir containing a feature file
     When the mapper is called
     Then a mindmap file without any validation error is created
      And the feature node in this mindmap is using a bold font
