Ability: show scenarios
  Calling the mapper will result in a new freemind mindmap. The mindmap will
  show all feature files as separate nodes. Every feature node will contain
  sub-nodes for all scenarios.

  # rule: if a feature has scenario, scenario name will be shown as subnodes to
  @debug
  Scenario Outline: show plain scenarios
    Given a feature dir with a feature containing <nr_of_scenarios> scenarios
     When the mapper is called
     Then a mindmap file without any validation error is created
      And the mindmap contains a feature node
      And the feature node contains <nr_of_scenarios> scenario subnodes

      Examples:
      |nr_of_scenarios|
      |0              |
      |1              |
      |3              |


  # rule: outline scenarios are marked by an list icon
  @debug
  Scenario: show outline scenario
    Given a feature dir with a feature containing an outline scenario
     When the mapper is called
     Then a mindmap file without any validation error is created
      And the mindmap contains a feature node
      And the feature node contains a scenario subnode
      And the scenario subnode is marked with an list icon
