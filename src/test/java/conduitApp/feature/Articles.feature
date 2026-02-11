@debug @articles
Feature: Articles tests

    Background: Define base URL
        Given url apiUrl
        * def articleRequestBody = read('classpath:conduitApp/json/newArticleRequest.json')
        * def dataGenerator = Java.type('helpers.DataGenerator')
        * def randomTitle = dataGenerator.getRandomArticleValues().title
        * def randomDescription = dataGenerator.getRandomArticleValues().description
        * def randomBody = dataGenerator.getRandomArticleValues().body
        * set articleRequestBody.article.title = randomTitle
        * set articleRequestBody.article.description = randomDescription
        * set articleRequestBody.article.body = randomBody

    @ignore
    Scenario: Create a new article
        Given path 'articles'
        And request articleRequestBody
        When method post
        Then status 201
        And match response.article.title == randomTitle

    Scenario: Create and delete an article

        Given path 'articles'
        And request articleRequestBody
        When method post
        Then status 201
        And match response.article.title == randomTitle
        * def slug = response.article.slug

        Given path 'articles/' + slug
        When method delete
        Then status 204
