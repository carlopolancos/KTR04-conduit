Feature: Articles tests

    Background: Define base URL
        Given url apiUrl

    Scenario: Define base URL
        Given path 'users/login'
        And request {"user": {"email": "#(userEmail)","password": "#(userPassword)"}}
        When method post
        Then status 200
        * def token = response.user.token
        * print 'Generated token is: ', token