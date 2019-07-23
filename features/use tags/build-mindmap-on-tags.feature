Ability: build mindmap on tags
  Calling featuremap will result in a new freemind mindmap. If specified by the
  --use-tags option, the mindmap will show every tag aligned to features as
  a separate node and attach all features marked by the tag as children nodes.
  See the "build mindmap on subdirs" ability if subdirs should be used instead of tags.

  Background:
    Given the name opf the mindmap file is set to "featuremap.mm"

  # rule: turn tags into mindmap nodes
  # - show tags aligned to features as mindmap nodes
  # - add a @ icon to mark them as tags

  Scenario: feature without tags
    Given a feature dir "tags_none"
      And it contains a feature without tags
     When the user runs featuremap with the "--use_tags" option
     Then a mindmap file without any validation error is created
      And the mindmap contains a node with the feature name
      And the feature nodes is attached to the root node

  Scenario: feature with tag
    Given a feature dir "one_tag"
      And it contains a feature "dummy just for test" with the tag "@example"
     When the user runs featuremap with the "--use_tags" option
     Then a mindmap file without any validation error is created
      And the root node has a tag child node "@example"
      And the tag child node is marked by an paper clip icon
      And the tag child contains a feature node named "dummy just for test"


  # rule: if a feature has more than one tag, it appears under each tag
  @debug
  Scenario: feature with multiple tags
    Given a feature dir "multiple tags"
      And the feature dir contains features with mutliple tags
          |feature            |tags          |
          |dummy_1            |@tag_1,@tag_3 |
          |dummy_2            |@tag_2        |
          |dummy_3            |@tag_3        |
     When the user runs featuremap with the "--use_tags" option
     Then a mindmap file without any validation error is created
      And the mindmap shows tag nodes with feature nodes
          |tag_node           |features         |
          |@tag_1             |dummy_1          |
          |@tag_2             |dummy_2          |
          |@tag_3             |dummy_1,dummy_3  |


  # rule: subdirs are ignored - feature from subdirs appear on the same level in the mindmap

  Scenario: features with tags and subdirs
    Given a feature dir "one_tag"
      And it contains a feature "dummy_1" with the tag "@example"
      And it contains a subdir "subdir"
      And the subdir contains a feature "dummy_2" with the tag "@example"
     When the user runs featuremap with the "use_tags" option
     Then a mindmap file without any validation error is created
      And the root node has a tag child node "example"
      And the tag child contains the feature nodes "dummy_1" and "dummy_2"
