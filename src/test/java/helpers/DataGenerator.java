package helpers;

import com.github.javafaker.Faker;

import net.minidev.json.JSONObject;

public class DataGenerator {

    static Faker faker = new Faker();
    static String firstName = faker.name().firstName();
    static String lastName = faker.name().lastName();


    //methods have to be static to be called easier
    public static String getRandomEmail() {
        return "test" + firstName.toLowerCase() + faker.random().nextInt(0,100) + "@test.com";
    }
    
    public static String getRandomUsername() {
        return "test" + firstName.toLowerCase() + "." + lastName.toLowerCase();
    }
    
    public String getRandomUsername2() {
        return "test" + firstName.toLowerCase() + "." + lastName.toLowerCase();
    }

    public static JSONObject getRandomArticleValues() {
        String title = faker.gameOfThrones().dragon();
        String description = faker.gameOfThrones().city();
        String body = faker.gameOfThrones().quote();
        JSONObject json = new JSONObject();
        json.put("title", title);
        json.put("description", description);
        json.put("body", body);
        return json;
    }
}
