Feature: Starting an overlay network

  In typical usage we need to be able to start a given overlay network from a centralized location.  We should be able to do this without a centralized log, but we should always have a configured system log.

  Scenario: Network already running
  	When I start a network
  	But a network is already running
  	Then the running network will stop
  	And the new network will start

  Scenario: Bad network configuration
  	When I start a network
  	But the network configuration is malformed
  	Then the network will not start
  	And I will be notified

  Scenario: No centralized log destination specified
  	When I start a network
  	And the centralized log is not specified
  	Then the network will start without a centralized collector

  Scenario: Hierarchical network
  	When I start a network
  	And the network is hierarchical
  	Then a hierarchical network should start

  Scenario: Non-hierarchical network
  	When I start a network
  	And the network is non-hierarchical
  	Then a hierarchical network should start