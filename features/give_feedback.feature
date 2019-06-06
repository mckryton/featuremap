
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


  # rule show an error message if the featuremap can't write the mindmap

  Scenario: mindmap name contains an non-existing path
    Given "invalid-path/featuremap.mm" as a non existing location for the mindmap
     When the user runs featuremap
     Then featuremap exits with 74
      And featuremap shows the message "can't write to invalid-path/featuremap.mm"

  Scenario: access rights are not sufficient for the mindmap
    Given "readonly-path/" as a read-only location for the mindmap
      And the user rights for the minmaps don't have access for writing
     When the user runs featuremap
     Then featuremap exits with 74
      And featuremap shows the message "can't write to readonly-path/featuremap.mm"