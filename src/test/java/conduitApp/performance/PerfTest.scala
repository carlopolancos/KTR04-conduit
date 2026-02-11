package performance

import com.intuit.karate.gatling.PreDef._
import io.gatling.core.Predef._
import scala.concurrent.duration._

import conduitApp.performance.createTokens.CreateTokens

class PerfTest extends Simulation {

    CreateTokens.createAccessTokens()

    val protocol = karateProtocol(
        "/api/articles/{articleId}" -> Nil
    )

      protocol.nameResolver = (req, ctx) => req.getHeader("karate-name")
    //   protocol.runner.karateEnv("perf")

    val csvFeeder = csv("conduitApp/performance/data/articles.csv").circular
    val tokenFeeder = Iterator.continually(Map("token" -> CreateTokens.getNextToken()))

    val createArticle = scenario("Create and delete an article")
    .feed(csvFeeder).feed(tokenFeeder).exec(karateFeature("classpath:conduitApp/performance/CreateArticle.feature"))

    setUp(
    createArticle.inject(
        atOnceUsers(1), // total 3 users
        nothingFor(4 seconds), // wait for 4 seconds before starting next injection
        constantUsersPerSec(1) during (3 seconds), // 2 users per second for 5 seconds
        constantUsersPerSec(2) during (10 seconds), // 2 users per second for 5 seconds
        rampUsersPerSec(2) to 10 during (20 seconds), // from 2 to 5 users per second over 15 seconds
        nothingFor(5 seconds), // wait for 4 seconds before starting next injection
        constantUsersPerSec(1) during (5 seconds) // 5 users per second for 10 seconds
        ).protocols(protocol),
    )
}