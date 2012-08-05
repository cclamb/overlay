Feature: Starting an overlay network

  Typically, we expect that we can query a node in an overlay network and that query will propogate to all known nodes when that nework is correctly configured.  If content is found, that content is returned; if not, no content is returned.

  Scenario: Hierarchical Network with Non-Existant Content
    When I start a network
    And I submit a query
    But the content does not exist in the network
    Then every node will be queried
    And no content will be returned

  Scenario: Hierarchical Network with Content
    When I start a network
    And I submit a query
    But the content does exist in the network
    Then content will be returned