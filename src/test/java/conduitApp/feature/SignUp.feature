@debug @signup
Feature: Sign Up new user

    Background: Define base URL
        Given url apiUrl
        * def timeValidator = read('classpath:helpers/timeValidator.js')
        * def dataGenerator = Java.type('helpers.DataGenerator')
        # * def randomEmail = dataGenerator.getRandomEmail()
        # * def randomUserName = dataGenerator.getRandomUsername()

        * def getEmail = 
            """
            function() { 
                var Generator = Java.type('helpers.DataGenerator');
                var instance = new Generator();
                return instance.getRandomEmail2();
            }
            """
        * def getUsername = 
            """
            function() { 
                var Generator = Java.type('helpers.DataGenerator');
                var instance = new Generator();
                return instance.getRandomUsername2();
            }
            """

    Scenario: New user sign up
        * def randomEmail = getEmail()
        * def randomUserName = getUsername()
        Given path 'users'
        And request
            """
            {
                "user": {
                    "email": "#(randomEmail)",
                    "password": "mastercarlo0987123!?",
                    "username": "#(randomUserName)"
                }
            }
            """
        When method post
        Then status 201
        * def randomToken = response.user.token
        * print 'Random token: ' + randomToken
        And match response ==
            """
            {
                "user": {
                    "id": "#number",
                    "email": "#(randomEmail)",
                    "username": "#(randomUserName)",
                    "bio": "#null",
                    "image": "#string",
                    "token": "#string"
                }
            }
            """

    Scenario Outline: Validate Sign Up error messages
        Given path 'users'
        And request
            """
            {
                "user": {
                    "email": "#(<email>)",
                    "password": "#(<password>)",
                    "username": "#(<username>)"
                }
            }
            """
        When method post
        Then status 422
        And match response == <errorResponse>
        Examples:
            | email                          | password    | username                          | errorResponse                                                        |
            | getEmail()                     | 'Karate123' | 'KarateUser123'                   | {"errors": {"username": ["has already been taken"]}}                 |
            | 'KarateUser1@test.com'         | 'Karate123' | getUsername()                     | {"errors": {"email": ["has already been taken"]}}                    |
            | 'KarateUser1'                  | 'Karate123' | getUsername()                     | {"errors": {"email": ["is invalid"]}}                                |
            | getEmail()                     | 'Karate123' | 'KarateUser123123123123'          | {"errors": {"username": ["is too long (maximum is 20 characters)"]}} |
            | getEmail()                     | 'Kar'       | getUsername()                     | {"errors": {"password": ["is too short (minimum is 8 characters)"]}} |
            | ''                             | 'Karate123' | getUsername()                     | {"errors": {"email": ["can't be blank"]}}                            |
            | getEmail()                     | ''          | getUsername()                     | {"errors": {"password": ["can't be blank"]}}                         |
            | getEmail()                     | 'Karate123' | ''                                | {"errors": {"username": ["can't be blank"]}}                         |