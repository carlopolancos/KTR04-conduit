@debug @signup
Feature: Sign Up new user

    Background: Define base URL
        Given url apiUrl
        * def dataGenerator = Java.type('helpers.DataGenerator')
        * def timeValidator = read('classpath:helpers/timeValidator.js')

        * def jsFunction =
            """
            function () {
            var DataGenerator = Java.type('helpers.DataGenerator');
            var generator = new DataGenerator();
            return generator.getRandomUsername2();
            }
            """
        * def randomUserName2 = jsFunction()

    Scenario: New user sign up
        * def randomEmail = dataGenerator.getRandomEmail()
        * def randomUserName = dataGenerator.getRandomUsername()
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
        * def randomEmail = dataGenerator.getRandomEmail()
        * def randomUserName = dataGenerator.getRandomUsername()
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
            | dataGenerator.getRandomEmail() | 'Karate123' | 'KarateUser123'                   | {"errors": {"username": ["has already been taken"]}}                 |
            | 'KarateUser1@test.com'         | 'Karate123' | dataGenerator.getRandomUsername() | {"errors": {"email": ["has already been taken"]}}                    |
            | 'KarateUser1'                  | 'Karate123' | dataGenerator.getRandomUsername() | {"errors": {"email": ["is invalid"]}}                                |
            | dataGenerator.getRandomEmail() | 'Karate123' | 'KarateUser123123123123'          | {"errors": {"username": ["is too long (maximum is 20 characters)"]}} |
            | dataGenerator.getRandomEmail() | 'Kar'       | dataGenerator.getRandomUsername() | {"errors": {"password": ["is too short (minimum is 8 characters)"]}} |
            | ''                             | 'Karate123' | dataGenerator.getRandomUsername() | {"errors": {"email": ["can't be blank"]}}                            |
            | dataGenerator.getRandomEmail() | ''          | dataGenerator.getRandomUsername() | {"errors": {"password": ["can't be blank"]}}                         |
            | dataGenerator.getRandomEmail() | 'Karate123' | ''                                | {"errors": {"username": ["can't be blank"]}}                         |