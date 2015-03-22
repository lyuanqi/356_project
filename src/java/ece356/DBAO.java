/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ece356;

import ece356Types.DoctorProfile;
import ece356Types.PatientSearchResult;
import java.sql.*;
import java.util.ArrayList;
import java.util.Calendar;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

/**
 *
 * @author liyuanqi
 */
public class DBAO {
    public static final String host = "localhost";
    public static final String url = "jdbc:mysql://" + host + ":3306/";
    public static final String nid = "356_db_project";
    public static final String user = "root";
    public static final String pwd = "root";
    
    public static Connection getTestConnection()
            throws ClassNotFoundException, SQLException {
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection(url, user, pwd);
        Statement stmt = null;
        try {
            con.createStatement();
            stmt = con.createStatement();
            //stmt.execute("USE hospital_" + nid);
            stmt.execute("USE "+ nid);
        } finally {
            if (stmt != null) {
                stmt.close();
            }
        }
        return con;
    }
    
    public static Connection getConnection() throws NamingException, SQLException{
        InitialContext cxt = new InitialContext(); 
        if (cxt == null) {
            throw new RuntimeException("Unable to create naming context!");
        }
        //Context dbContext = (Context) cxt.lookup("java:comp/env"); 
        DataSource ds = (DataSource) cxt.lookup("jdbc/myDatasource");
        if (ds == null) {
            throw new RuntimeException("Data source not found!");
        }
        Connection con = ds.getConnection();

        //con.close(); // this statement returns the connection back to the pool

        return con;
    }
    
    public static ArrayList<PatientSearchResult> patientSearch(String alias, String city, String province) throws SQLException, NamingException, ClassNotFoundException{
        int conditionCount=0;
        ArrayList<String> conditions=new ArrayList<String>();
        ArrayList<String> aliases=new ArrayList<String>();
        ArrayList<PatientSearchResult> results=new ArrayList<PatientSearchResult>();
        String statement1="SELECT * FROM 356_patients ";
        String statement2="SELECT "
                + "356_patients.Alias, "
                + "356_patients.Addr_City, "
                + "356_patients.Addr_Province, "
                + "count(356_review.Review_ID) AS Review_Count, "
                + "max(356_review.Date) AS MOST_RECENT_DATE "
                + "FROM 356_review JOIN 356_patients "
                + "ON 356_review.Patient_Alias = 356_patients.Alias "
                + "WHERE 356_patients.Alias = ?"
                ;
        System.out.println(alias);
        if (alias.length()>0){
            conditionCount++;
            statement1=statement1 + "WHERE 356_patients.Alias=? ";
            conditions.add(alias);
        }
        if (city.length()>0){
            conditionCount++;
            if (conditionCount==1){
                statement1=statement1 + "WHERE 356_patients.Addr_City=? ";    
            }
            else if (conditionCount==2){
                statement1=statement1 + "AND 356_patients.Addr_City=? ";
            }
            conditions.add(city);
        }
        if (province.length()>0){
            conditionCount++;
            if (conditionCount==1){
                statement1=statement1 + "WHERE 356_patients.Addr_Province=? ";    
            }
            else if (conditionCount>=2){
                statement1=statement1 + "AND 356_patients.Addr_Province=? ";
            }
            conditions.add(province);
        }

        //Connection con=getConnection();
        Connection con=getTestConnection();
        try {
            
            PreparedStatement stmt = con.prepareStatement(statement1);
            for (int i=1;i<=conditions.size();i++){
                stmt.setString(i,conditions.get(i-1));
            }
            ResultSet resultSet = stmt.executeQuery();
            System.out.println(stmt);
            while(resultSet.next())
            {
                aliases.add(resultSet.getString("Alias"));
            }
            for (int i=0;i<aliases.size();i++){
                stmt=con.prepareStatement(statement2);
                stmt.setString(1,aliases.get(i));
                resultSet = stmt.executeQuery();
                if (resultSet.next()){
                    PatientSearchResult result=new PatientSearchResult();
                    result.alias=resultSet.getString("356_patients.Alias");
                    result.home_address=resultSet.getString("356_patients.Addr_City")+", "+resultSet.getString("356_patients.Addr_Province");
                    result.review_count=resultSet.getInt("Review_Count");
                    result.last_review=resultSet.getDate("MOST_RECENT_DATE");
                    result.link="link";
                    results.add(result);
                }
            }
        }
        catch (Exception e) {  
            System.out.println(e);  
        }
        finally{
            con.close(); // this statement returns the connection back to the pool
        }
        return results;
    }

    public static DoctorProfile getDoctorProfile(String alias) throws ClassNotFoundException, SQLException {

        DoctorProfile profile = new DoctorProfile();
        String statement="SELECT * FROM Doctor_Details WHERE DOCTOR=?";

        //Connection con=getConnection();
        Connection con=getTestConnection();
        try {
            
            PreparedStatement stmt = con.prepareStatement(statement);
            stmt.setString(1,alias);
            ResultSet resultSet = stmt.executeQuery();
            
            while(resultSet.next())
            {
                profile.name=resultSet.getString("First_Name")+", "+resultSet.getString("Last_Name");
                
                String address=resultSet.getString("St_Number")+" "
                        +resultSet.getString("St_Name")+" "
                        +resultSet.getString("St_Type")+", "
                        +resultSet.getString("City")+", "
                        +resultSet.getString("Province")+", "
                        +resultSet.getString("Postal_Code_pre")+" "
                        +resultSet.getString("Postal_Code_suff");
                
                if (!profile.addresses.contains(address)){
                    profile.addresses.add(address);
                }
                String specialization = resultSet.getString("Specialization_Area");
                if (!profile.specializations.contains(specialization)){
                    profile.specializations.add(specialization);
                }
                int current_year = Calendar.getInstance().get(Calendar.YEAR);
                profile.years_licensed=current_year-resultSet.getInt("Medical_Licence_Year");
                profile.avg_rating=0;
                profile.review_count=0;
                profile.review_links.add("none");
                profile.write_link="nonn";
            }
        }
        catch (Exception e) {  
            System.out.println(e);  
        }
        finally{
            con.close(); // this statement returns the connection back to the pool
        }
        return profile;
    }
}
