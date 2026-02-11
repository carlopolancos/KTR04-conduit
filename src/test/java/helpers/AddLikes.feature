Feature: Add likes

    Background: Define base URL
    Given url apiUrl

    Scenario: Add likes
        Given path 'articles', slug, 'favorite'
        And headers { Authorization: #('Token '+token) }
        And request {}
        When method post
        Then status 200
        * def newLikesCount = response.article.favoritesCount