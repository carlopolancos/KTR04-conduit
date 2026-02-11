@debug @homework
Feature: Homework

    Background: Define base URL
        Given url apiUrl
        * def timeValidator = read('classpath:helpers/timeValidator.js')
        * def favoriteArticleResponseBody = read('classpath:conduitApp/json/favoriteArticleReponse.json')
        * def getFavoriteArticlesResponseBody = read('classpath:conduitApp/json/getFavoriteArticlesResponse.json')
        * def getCommentsResponseBody = read('classpath:conduitApp/json/getCommentsResponse.json')
        * def newCommentResponseBody = read('classpath:conduitApp/json/newCommentResponse.json')

    Scenario: Favorite articles
        Given path 'articles'
        And params {limit: 10, offset: 0}
        When method get
        Then status 200

        * def firstFavoriteCount = response.articles[0].favoritesCount
        * def firstSlug = response.articles[0].slug

        Given path 'articles', firstSlug, 'favorite'
        And request {}
        When method post
        Then status 200
        And match response == favoriteArticleResponseBody
        And match response.article.favoritesCount == firstFavoriteCount + 1

        Given path 'articles'
        And params {favorited: emailsample, limit: 10, offset: 0}
        When method get
        Then status 200
        And match each response.articles == getFavoriteArticlesResponseBody
        And match response.articlesCount == "#number"
        And match response.articles[0].slug contains firstSlug

    Scenario: Comment Articles
        Given path 'articles'
        And params {limit: 10, offset: 0}
        When method get
        Then status 200
        * def firstArticleSlug = response.articles[0].slug

        Given path 'articles', firstArticleSlug, 'comments'
        When method get
        Then status 200
        And match each response.comments == getCommentsResponseBody
        * def initialCommentsCount = response.comments.length

        * def newCommentBody = 'Huling bagong komento'
        Given path 'articles', firstArticleSlug, 'comments'
        And request {"comment": {"body": "#(newCommentBody)"}}
        When method post
        Then status 200
        And match response == newCommentResponseBody
        And match response.comment.body == newCommentBody
        * def newCommentId = response.comment.id

        Given path 'articles', firstArticleSlug, 'comments'
        When method get
        Then status 200
        And match each response.comments == getCommentsResponseBody
        * def finalCommentsCount = response.comments.length
        And match finalCommentsCount == initialCommentsCount + 1

        Given path 'articles', firstArticleSlug, 'comments', newCommentId
        When method delete
        Then status 200
        * def commentCountAfterDeletion = finalCommentsCount - 1

        Given path 'articles', firstArticleSlug, 'comments'
        When method get
        Then status 200
        And match each response.comments == getCommentsResponseBody
        * def commentsCountAfterGet = response.comments.length
        And match commentsCountAfterGet == commentCountAfterDeletion








        