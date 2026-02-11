// package helpers;

// import java.sql.Connection;
// import java.sql.DriverManager;
// import java.sql.ResultSet; // MISSING: Needed for the query results
// import java.sql.SQLException; // RECOMMENDED: Better than catching 'Exception'
// import net.minidev.json.JSONObject; // MISSING: Assuming you're using the same lib as your previous examples

// public class DbHandler {
    
//     private static String connectionUrl = "jdbc:sqlserver://localhost:1433;databaseName=YourDatabase;user=YourUsername;password=YourPassword;";
    
//     public static void addNewJobWithName(String jobName) {
//         try(Connection connect = DriverManager.getConnection(connectionUrl)) {
//             connect.createStatement().execute("INSERT INTO [Pubs].[dbo].[jobs] (job_desc, min_lvl, max_lvl) VALUES ('" + jobName + "', 50, 100)");
//         }
//              catch (Exception e) {
//             e.printStackTrace();
//         } 
//     }

//     public static JSONObject getMinAndMaxLevelsForJob(String  jobName) {
//         JSONObject json = new JSONObject();
        
//         try(Connection connect = DriverManager.getConnection(connectionUrl)) {
//             ResultSet rs = connect.createStatement().executeQuery("SELECT* FROM [Pubs].[dbo].[jobs] WHERE job_desc = '" + jobName + "'");
//             while(rs.next()) {
//                 json.put("minLvl", rs.getInt("min_lvl"));
//                 json.put("maxLvl", rs.getInt("max_lvl"));
//             }
//         }
//              catch (SQLException e) {
//             e.printStackTrace();
//         } 
//         return json;
//     }
// }
