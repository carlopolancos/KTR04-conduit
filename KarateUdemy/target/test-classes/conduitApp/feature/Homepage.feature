Feature: Tests for the home page

    Background: Define base URL
        Given url apiUrl

    Scenario: Get all tags
        Given path 'tags'
        When method get
        Then status 200
        And match response.tags contains ['Test', 'Blog', 'Git']
        And match response.tags !contains ['Test', 'Blo']
        And match response.tags contains any ['Test2', 'Blog3', 'Git']
        And match response.tags == '#array'
        And match each response.tags == '#string'

    Scenario: Get 10 articles from the page
        * def timeValidator = read('classpath:helpers/timeValidator.js')
        
        # Given param limit = 10
        # Given param offset = 0
        Given params { limit: 10, offset: 0 }
        Given path 'articles'
        When method get
        Then status 200
        # And match response.articles == '#[10]'
        # And match response.articlesCount == 10
        # And match response.articlesCount != 100
        And match response == {articles: '#[10]', articlesCount: 10}
        And match response.articles[0].createdAt contains '2024'
        And match response.articles[*].favoritesCount contains 75 // at least one article has 75 favorites
        # And match each response.articles[*].favoritesCount == '#number' // all articles have a number of favorites

        # And match response..bio contains null // at least one bio is null
        # And match each response..bio == '#null' // all bios are null
        # And match each response..following == false // all following are false
        # And match each response..following == "#boolean" // all following are boolean values
        # And match each response..favoritesCount == "#number" // all favoritesCount are numbers
        # And match each response..bio == "##string" // all titles are strings
        And match each response.articles == 
        """
        {
            "slug": "#string",
            "title": "#string",
            "description": "#string",
            "body": "#string",
            "tagList": "#[] #string",
            "createdAt": "#? timeValidator(_)",
            "updatedAt": "#? timeValidator(_)",
            "favorited": "#boolean",
            "favoritesCount": "#number",
            "author": {
                "username": "#string",
                "bio": "#null",
                "image": "#string",
                "following": "#boolean"
            }
        }
        """