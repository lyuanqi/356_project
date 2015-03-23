/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ece356;

import ece356Types.Condition;
import ece356Types.DoctorProfile;
import ece356Types.DoctorSearchResult;
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
        String statement="SELECT * FROM Doctor_Details LEFT JOIN 356_review ON Doctor_Details.Doctor=356_review.Doctor_Alias WHERE DOCTOR=?";
        //Connection con=getConnection();
        Connection con=getTestConnection();
        try {
            
            profile.avg_rating= getDoctorAvgRating(alias);
            profile.review_count=getDoctorReviewCount(alias);
            
            PreparedStatement stmt = con.prepareStatement(statement);
            stmt.setString(1,alias);
            ResultSet resultSet = stmt.executeQuery();
            
            while(resultSet.next())
            {
                profile.name=resultSet.getString("First_Name")+", "+resultSet.getString("Last_Name");
                profile.gender=resultSet.getString("gender");
                
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
                profile.review_links.add("none");
                profile.write_link="nonn";
                profile.profile_link="GetDoctorProfileServlet?alias="+alias;
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

    public static double getDoctorAvgRating(String alias) throws ClassNotFoundException, SQLException {
        double rating=0;
        String statement="SELECT AVG(356_review.Rating) AS Average_Rating From 356_review WHERE 356_review.Doctor_Alias = ? GROUP BY 356_review.Doctor_Alias;";
        //Connection con=getConnection();
        Connection con=getTestConnection();
        try {
            
            PreparedStatement stmt = con.prepareStatement(statement);
            stmt.setString(1,alias);
            ResultSet resultSet = stmt.executeQuery();
            
            if(resultSet.next())
            {
                rating= resultSet.getFloat("Average_Rating");
            }

        }
        catch (Exception e) {  
            System.out.println(e);  
        }
        finally{
            con.close(); // this statement returns the connection back to the pool
        }
        return rating;
    }
    
    public static int getDoctorReviewCount(String alias) throws ClassNotFoundException, SQLException {
        int count=0;
        String statement="SELECT COUNT(356_review.Review_ID) AS Review_Count From 356_review WHERE 356_review.Doctor_Alias = ? GROUP BY 356_review.Doctor_Alias;";
        //Connection con=getConnection();
        Connection con=getTestConnection();
        try {
            
            PreparedStatement stmt = con.prepareStatement(statement);
            stmt.setString(1,alias);
            ResultSet resultSet = stmt.executeQuery();
            
            if(resultSet.next())
            {
                count= resultSet.getInt("Review_Count");
            }

        }
        catch (Exception e) {  
            System.out.println(e);  
        }
        finally{
            con.close(); // this statement returns the connection back to the pool
        }
        return count;
    }
    
    public static ArrayList<DoctorSearchResult> doctorSearch(String first, String last, String licensed_years, String gender, String speciliazation, String stnum, String stname,String sttype,String pre,String suff, String city, String province, String keyword) throws SQLException, NamingException, ClassNotFoundException{
        int conditionCount=0;
        ArrayList<Condition> conditions=new ArrayList<Condition>();
        String type;
        String value;
        ArrayList<String> aliases=new ArrayList<String>();
        ArrayList<DoctorSearchResult> results=new ArrayList<DoctorSearchResult>();
        String statement1="SELECT * FROM Doctor_Details LEFT JOIN 356_review ON Doctor_Details.Doctor=356_review.Doctor_Alias";
        
        if (first.length()>0){
            conditionCount++;
            statement1=appendWhereORAnd(statement1,conditionCount);
            statement1+= "First_Name LIKE ?";
            Condition temp=new Condition();
            temp.type="String";
            temp.value="%"+first+"%";
            conditions.add(temp);
        }
        if (last.length()>0){
            conditionCount++;
            statement1=appendWhereORAnd(statement1,conditionCount);
            statement1+= "Last_Name LIKE ?";
            Condition temp=new Condition();
            temp.type="String";
            temp.value="%"+last+"%";
            conditions.add(temp);
        }
        if (licensed_years.length()>0){
            conditionCount++;
            statement1=appendWhereORAnd(statement1,conditionCount);
            statement1+= "YEAR(NOW())-Medical_Licence_Year>?";
            Condition temp=new Condition();
            temp.type="int";
            temp.value=licensed_years;
            conditions.add(temp);
        }
        if (gender.length()>0){
            conditionCount++;
            statement1=appendWhereORAnd(statement1,conditionCount);
            statement1+= "Gender=?";
            Condition temp=new Condition();
            temp.type="String";
            temp.value=gender;
            conditions.add(temp);
        }
        if (speciliazation.length()>0){
            conditionCount++;
            statement1=appendWhereORAnd(statement1,conditionCount);
            statement1+= "Specialization_Area=?";
            Condition temp=new Condition();
            temp.type="String";
            temp.value=speciliazation;
            conditions.add(temp);
        }
        if (stnum.length()>0){
            conditionCount++;
            statement1=appendWhereORAnd(statement1,conditionCount);
            statement1+= "St_Number=?";
            Condition temp=new Condition();
            temp.type="int";
            temp.value=stnum;
            conditions.add(temp);
        }
        if (stname.length()>0){
            conditionCount++;
            statement1=appendWhereORAnd(statement1,conditionCount);
            statement1+= "St_Name=?";
            Condition temp=new Condition();
            temp.type="String";
            temp.value=stname;
            conditions.add(temp);
        }
        if (sttype.length()>0){
            conditionCount++;
            statement1=appendWhereORAnd(statement1,conditionCount);
            statement1+= "St_Type=?";
            Condition temp=new Condition();
            temp.type="String";
            temp.value=sttype;
            conditions.add(temp);
        }
        if (pre.length()>0){
            conditionCount++;
            statement1=appendWhereORAnd(statement1,conditionCount);
            statement1+= "Postal_Code_pre=?";
            Condition temp=new Condition();
            temp.type="String";
            temp.value=pre;
            conditions.add(temp);
        }
        if (suff.length()>0){
            conditionCount++;
            statement1=appendWhereORAnd(statement1,conditionCount);
            statement1+= "Postal_Code_suff=?";
            Condition temp=new Condition();
            temp.type="String";
            temp.value=suff;
            conditions.add(temp);
        }
        if (city.length()>0){
            conditionCount++;
            statement1=appendWhereORAnd(statement1,conditionCount);
            statement1+= "City=?";
            Condition temp=new Condition();
            temp.type="String";
            temp.value=city;
            conditions.add(temp);
        }
        if (province.length()>0){
            conditionCount++;
            statement1=appendWhereORAnd(statement1,conditionCount);
            statement1+= "Province=?";
            Condition temp=new Condition();
            temp.type="String";
            temp.value=province;
            conditions.add(temp);
        }
        if (keyword.length()>0){
            conditionCount++;
            statement1=appendWhereORAnd(statement1,conditionCount);
            statement1+= "Comment Like ?";
            Condition temp=new Condition();
            temp.type="String";
            temp.value="%"+keyword+"%";
            conditions.add(temp);
        }

        
        //Connection con=getConnection();
        Connection con=getTestConnection();
        try {
            
            PreparedStatement stmt = con.prepareStatement(statement1);
            for (int i=0;i<conditions.size();i++){
                type=conditions.get(i).type;
                switch (type) {
                case "int": 
                        stmt.setInt(i+1,Integer.parseInt(conditions.get(i).value));
                        break;
                case "String":
                        stmt.setString(i+1,conditions.get(i).value);
                        break;
                }
            }
            System.out.println(stmt);
            ResultSet resultSet = stmt.executeQuery();
            
            while(resultSet.next())
            {
                if (!aliases.contains(resultSet.getString("Doctor"))){
                    aliases.add(resultSet.getString("Doctor"));
                }
                
            }
            for (int i=0;i<aliases.size();i++){
                //aliases.add(resultSet.getString("Doctor"));
                DoctorSearchResult result=new DoctorSearchResult();
                DoctorProfile profile=new DoctorProfile();
                profile=getDoctorProfile(aliases.get(i));
                result.gender=profile.gender;
                result.name=profile.name;
                result.profile_link=profile.profile_link;
                result.avg_rating=profile.avg_rating;
                result.review_count=profile.review_count;
                results.add(result);            
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
    public static String appendWhereORAnd(String statement, int conditionCount){
            if (conditionCount==1){
                statement+= " WHERE ";
            }
            else if (conditionCount>=2){
                statement+= " AND ";
            }
        return statement;
    }
}
