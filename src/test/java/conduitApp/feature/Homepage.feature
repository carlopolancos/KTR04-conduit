@debug @homepage
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

    Scenario: Conditional Logic
        * configure retry = { count: 3, interval: 3000 }
        Given params { limit: 10, offset: 0 }
        Given path 'articles'
        And retry until responseStatus == 200
        When method get
        Then status 200
        * def firstFavoritesCount = response.articles[0].favoritesCount
        * def firstFavorited = response.articles[0].favorited
        * def firstArticle = response.articles[0]
        * print 'First article slug:', firstArticle.slug
        * print 'First article favoritesCount:', firstFavoritesCount
        * print 'First article favorited:', firstFavorited

        # * if (firstFavoritesCount == 0) { karate.call('classpath:helpers/AddLikes.feature', firstArticle)}

        * def result = firstFavorited == false ? karate.call('classpath:helpers/AddLikes.feature', { slug: firstArticle.slug, token: authToken }).newLikesCount : firstFavoritesCount

        Given params { limit: 10, offset: 0 }
        Given path 'articles'
        When method get
        Then status 200
        And match response.articles[0].favoritesCount == result

    Scenario: Retry call
        * configure retry = { count: 10, interval: 5000 }

        Given params { limit: 10, offset: 0 }
        And path 'articles'
        And retry until response.articles[0].favoritesCount > 1
        When method get
        Then status 200

    Scenario: Sleep  call
        * def sleep = function(ms){ java.lang.Thread.sleep(ms); }

        Given params { limit: 10, offset: 0 }
        And path 'articles'
        And retry until response.articles[0].favoritesCount > 1
        When method get
        * eval sleep(10000)
        Then status 200

    Scenario: Number to string
        # * match 10 == '10'
        * def foo = 10
        * def json = {"bar": #(foo)} //does not work
        * def json = {"bar": #(foo+'')}
        * match json.bar == '10'

    Scenario: String to number
        # * match '10' == 10
        * def foo = '10'
        * def json = {"bar": #(Number(foo))}
        * def json2 = {"bar": #(foo*1)}
        * def json3 = {"bar": #(parseInt(foo))}
        * def json4 = {"bar": #(~~parseInt(foo))}
        * match json.bar == 10
        * match json2.bar == 10
        * match json3.bar == 10
        * match json4.bar == 10