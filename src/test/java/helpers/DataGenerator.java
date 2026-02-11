package helpers;

import com.github.javafaker.Faker;

import net.minidev.json.JSONObject;

public class DataGenerator {

    static Faker faker = new Faker();
    String firstName = faker.name().firstName();
    int number = faker.number().numberBetween(1, 1000);
    String lastName = faker.name().lastName();


    //methods have to be static to be called easier, fails many test due to static
    // public static String getRandomEmail() {
    //     return "test" + firstName.toLowerCase() + number + "@test.com";
    // }
    
    // public static String getRandomUsername() {
    //     return firstName.toLowerCase() + "." + lastName.toLowerCase();
    // }
    
    public String getRandomEmail2() {
        return "test" + firstName.toLowerCase() + number + "@test.com";
    }
    
    public String getRandomUsername2() {
        return firstName.toLowerCase() + "TesT" + lastName.toLowerCase();
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
