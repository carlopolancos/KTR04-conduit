@debug @hooks
Feature: Hooks

    Background: Define base URL
        # * def result = callonce read('classpath:helpers/Dummy.feature')
        # * def username = result.randomUserName()
        # * def email = result.randomEmail()

        #after hooks
        * configure afterScenario = function() { karate.call('classpath:helpers/Dummy.feature') }
        * configure afterFeature = 
        """
        function() {
            karate.log('After feature text');
        }
        """

    Scenario: First scenario
        # * print username
        # * print email
        * print 'This is the first scenario'

    Scenario: Second scenario
        # * print username
        # * print email
        * print 'This is the second scenario'