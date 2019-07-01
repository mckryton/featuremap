
Ability: give feedback
  To run featuremap the user have to provide certain parameters (e.g. the location
    of the Gherkn feature files). If those parameters are missing or faulty,
    featuremap will provide helpful feedback.

  # rule: show an error message if the feature dir is not accessible

  Scenario: feature dir does not exist
    Given "invalid-path" as a non existing location for the feature dir
     When the user runs featuremap
     Then featuremap exits with 66
      And featuremap shows the message "can't find >>invalid-path<< as feature dir"

  Scenario: access rights are not sufficient to read the feature dir
    Given a feature dir "secret_features"
      And the user rights for the feature dir don't allow access
     When the user runs featuremap
     Then featuremap exits with 66
      And featuremap shows the message "can't access >>secret_features<< as feature dir"


  # rule: show an error message if the featuremap can't write the mindmap

  Scenario: mindmap name contains an non-existing path
    Given a feature dir "features"
      And "invalid-path/featuremap.mm" as a non existing location for the mindmap
     When the user runs featuremap
     Then featuremap exits with 74
      And featuremap shows the message "can't write to invalid-path/featuremap.mm"

  Scenario: access rights are not sufficient for the mindmap
    Given a feature dir "features"
      And "readonly-path/" as a read-only location for the mindmap
      And the user rights for the mindmaps don't have access for writing
     When the user runs featuremap
     Then featuremap exits with 74
      And featuremap shows the message "can't write to readonly-path/featuremap.mm"


  # rule: add a number to the mindmaps name if the file already exists

  Scenario: a file with the same name as the mindmap already exists
    Given a mindmap file "featuremap.mm" already exists
      And a feature dir "existing_name_features"
      And it contains a feature
      And "featuremap.mm" is used as an argument for the featuremap script
     When the user runs featuremap
     Then featuremap shows the message "given mindmap name is already in use, created featuremap-1.mm"
      And a new mindmap with name "featuremap-1.mm" was created

  Scenario: multiple files with the same name as the mindmap already exists
    Given 6 multiple mindmap file with the name "featuremap" distinguished only by number exist
      And a feature dir "existing_name_features"
      And it contains a feature
      And "featuremap.mm" is used as an argument for the featuremap script
     When the user runs featuremap
     Then featuremap shows the message "given mindmap name is already in use, created featuremap-6.mm"
      And a new mindmap with name "featuremap-6.mm" was created


  # rule: if the result is written on stdout messages should appear on stderr

  Scenario: user does omit the name for the feature file
    Given a feature dir "features"
      And it contains a feature
      And the argument for the mindmap file name is missing
     When the user runs featuremap
     Then the content of the mindmap file is redirected to stdout

  Scenario: user does omit the name for the feature file and the feature dir does not exists
    Given "invalid-path" as a non existing location for the feature dir
      And the argument for the mindmap file name is missing
     When the user runs featuremap
     Then featuremap shows the message "can't find >>invalid-path<< as feature dir" on stderr
