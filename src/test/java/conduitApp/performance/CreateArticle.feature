@debug @articles @queque
Feature: Articles tests

    Background: Define base URL
        Given url apiUrl
        * def articleRequestBody = read('classpath:conduitApp/json/newArticleRequest.json')
        * def dataGenerator = Java.type('helpers.DataGenerator')
        * def randomTitle = dataGenerator.getRandomArticleValues().title
        * def randomDescription = dataGenerator.getRandomArticleValues().description
        * def randomBody = dataGenerator.getRandomArticleValues().body
        * set articleRequestBody.article.title = __gatling.Title
        * set articleRequestBody.article.description = __gatling.Description
        * set articleRequestBody.article.body = randomBody

        * def sleep = function(ms) { java.lang.Thread.sleep(ms); }
        * def pause = karate.get('__gatling.pause', sleep)
        * def authToken = 'Token ' + __gatling.token
        * configure headers = { Authorization: '#(authToken)' }


    Scenario: Create and delete an article
        Given path 'articles'
        And request articleRequestBody
        And header karate-name = 'Create Article - ' + __gatling.Title
        When method post
        Then status 201
        # And match response.article.title == __gatling.Title
        * def slug = response.article.slug

        # * pause(5000)

        # Given path 'articles/' + slug
        # When method delete
        # Then status 204