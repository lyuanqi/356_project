/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ece356;

import ece356Types.FriendshipRequestInfo;
import ece356Types.Condition;
import ece356Types.DoctorProfile;
import ece356Types.DoctorSearchResult;
import ece356Types.PatientSearchResult;
import ece356Types.Review;
import java.math.BigDecimal;
import java.math.RoundingMode;
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
    public static final String host = "eceweb.uwaterloo.ca";
    public static final String url = "jdbc:mysql://" + host + ":3306/";
    public static final String nid = "ece356db_lyuanqi";
    public static final String user = "user_lyuanqi";
    public static final String pwd = "user_lyuanqi";
    
    public static Connection getConnection()
            throws ClassNotFoundException, SQLException {
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection(url, user, pwd);
        Statement stmt = null;
        try {
            con.createStatement();
            stmt = con.createStatement();
            stmt.execute("USE "+ nid);
        } finally {
            if (stmt != null) {
                stmt.close();
            }
        }
        return con;
    }
    
    public static Connection getTestConnection() throws NamingException, SQLException{
        InitialContext cxt = new InitialContext(); 
        if (cxt == null) {
            throw new RuntimeException("Unable to create naming context!");
        }
        //Context dbContext = (Context) cxt.lookup("java:comp/env"); 
        DataSource ds = (DataSource) cxt.lookup("jdbc/myDatasource_eceweb");
        if (ds == null) {
            throw new RuntimeException("Data source not found!");
        }
        Connection con = ds.getConnection();

        //con.close(); // this statement returns the connection back to the pool

        return con;
    }
    
    private static String getFriendshipStatus(String requestor, String requestee)
                throws SQLException, NamingException, ClassNotFoundException {
        String friendshipStatus="";
        String stmt = "SELECT 356_friends.Friend_Accept FROM 356_friends " + 
                       "WHERE Alias='" + requestor +"' AND Friend_Alias='" + requestee +"'";
         
        int friendshipCode = 0;
        Connection con=null;
        try {
            con=getTestConnection();
            PreparedStatement prepStmt = con.prepareStatement(stmt);
            ResultSet resultSet = prepStmt.executeQuery();
            if(!resultSet.next())
            {
                friendshipStatus = "none";
            }
            else {
                friendshipCode = resultSet.getInt("Friend_Accept");
                if(friendshipCode == 0)
                {
                    friendshipStatus = "Friend request sent";
                }
                else
                    friendshipStatus = "We are friends";
            }
        }
        catch (Exception e) {  
            System.out.println(e);  
        }
        finally{
            con.close(); // this statement returns the connection back to the pool
        }
        return friendshipStatus;
    }
    
    public static ArrayList<PatientSearchResult> patientSearch(String myself, String alias, String city, String province) throws SQLException, NamingException, ClassNotFoundException{
        final String friendship_serv = "AddFriendServlet";
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
        Connection con=null;
        try {
            con=getTestConnection();
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
                    if(myself.equals(result.alias))
                        continue;
                    
                    result.home_address=resultSet.getString("356_patients.Addr_City")+", "+resultSet.getString("356_patients.Addr_Province");
                    result.review_count=resultSet.getInt("Review_Count");
                    result.last_review=resultSet.getDate("MOST_RECENT_DATE");
                    result.link = friendship_serv + "?friend=" + result.alias;
                    result.friendship = getFriendshipStatus(myself, result.alias);
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
        Connection con=null;
        try {
            con=getTestConnection();
            profile.avg_rating= getDoctorAvgRating(alias);
            profile.review_count=getDoctorReviewCount(alias);
            
            PreparedStatement stmt = con.prepareStatement(statement);
            stmt.setString(1,alias);
            ResultSet resultSet = stmt.executeQuery();
            
            while(resultSet.next())
            {
                profile.alias=alias;
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
                
                profile.write_link="writeReview.jsp";
                profile.profile_link="GetDoctorProfileServlet?alias="+alias;
                profile.email=resultSet.getString("Email");
            }
            ArrayList<Integer> list = getReviewIDList(alias);
            for (int i:list){
                profile.review_links.add("ViewReviewByIDServlet?ID="+i);
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
        Connection con=null;
        try {
            con=getTestConnection();
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
        Connection con=null;
        try {
            con=getTestConnection();
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

    public static boolean reviewdByFriend(String patient_alias, String doctor_alias) throws ClassNotFoundException, SQLException {
        boolean reviewed=false;
        String statement="SELECT * FROM 356_friends JOIN 356_review ON 356_friends.Friend_Alias = 356_review.Patient_Alias WHERE 356_friends.Alias=? AND 356_friends.Friend_Accept=1 AND 356_review.Doctor_Alias=?";
        //Connection con=getConnection();
        Connection con = null;
        try {
            con=getTestConnection();
            PreparedStatement stmt = con.prepareStatement(statement);
            stmt.setString(1,patient_alias);
            stmt.setString(2,doctor_alias);
            ResultSet resultSet = stmt.executeQuery();
            
            if(resultSet.next())
            {
                reviewed=true;
            }

        }
        catch (Exception e) {  
            System.out.println(e);  
        }
        finally{
            con.close(); // this statement returns the connection back to the pool
        }
        return reviewed;
    }

        public static ArrayList<String> getAllSpecialization() throws ClassNotFoundException, SQLException {
        ArrayList<String> results=new ArrayList<String>();
        String statement="SELECT DISTINCT Specialization_Area FROM 356_specialization ORDER BY Specialization_Area";
        //Connection con=getConnection();
        Connection con=null;
        try {
            con=getTestConnection();
            PreparedStatement stmt = con.prepareStatement(statement);
            ResultSet resultSet = stmt.executeQuery();
            
            while(resultSet.next())
            {
                results.add(resultSet.getString("Specialization_Area"));
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

        public static ArrayList<String> getAllElements(String targetType, String column) throws ClassNotFoundException, SQLException {
        ArrayList<String> results=new ArrayList<String>();
        String statement="";
        
        switch (targetType) {
            case "patient":
                switch(column){
                    case "province":
                        statement = "SELECT DISTINCT Addr_Province AS Result FROM 356_patients ORDER BY Addr_Province";
                        break;
                    case "city":
                        statement = "SELECT DISTINCT Addr_City AS Result FROM 356_patients ORDER BY Addr_City";
                        break;
                }   break;
            case "doctor":
                switch(column){
                    case "province":
                        statement = "SELECT DISTINCT Province AS Result FROM 356_offices ORDER BY Province";
                        break;
                    case "city":
                        statement = "SELECT DISTINCT City AS Result FROM 356_offices ORDER BY City";
                        break;
                    case "stname":
                        statement = "SELECT DISTINCT St_Name AS Result FROM 356_offices ORDER BY St_Name";
                        break;
                    case "sttype":
                        statement = "SELECT DISTINCT St_Type AS Result FROM 356_offices ORDER BY St_Type";
                        break;
                    case "prefix":
                        statement = "SELECT DISTINCT Postal_Code_pre AS Result FROM 356_offices ORDER BY Postal_Code_pre";
                        break;
                    case "suffix":
                        statement = "SELECT DISTINCT Postal_Code_suff AS Result FROM 356_offices ORDER BY Postal_Code_suff";
                        break;
            }   break;
        }
        


        //Connection con=getConnection();
        Connection con=null;
        try {
            con=getTestConnection();
            PreparedStatement stmt = con.prepareStatement(statement);
            ResultSet resultSet = stmt.executeQuery();
            
            while(resultSet.next())
            {
                results.add(resultSet.getString("Result"));
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
        
    public static ArrayList<DoctorSearchResult> doctorSearch(String self, String first, String last, String licensed_years, String gender, String speciliazation, String stnum, String stname,String sttype,String pre,String suff, String city, String province, String keyword, String rating, String reviewed) throws SQLException, NamingException, ClassNotFoundException{
        int conditionCount=0;
        ArrayList<Condition> conditions=new ArrayList<Condition>();
        ArrayList<String> aliases=new ArrayList<String>();
        ArrayList<DoctorSearchResult> results=new ArrayList<DoctorSearchResult>();
        String statement1="SELECT * FROM Doctor_Details LEFT JOIN 356_review ON Doctor_Details.Doctor=356_review.Doctor_Alias";
        String type;
        
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
            
            if (rating.length()>0){
                ArrayList<String> temp = new ArrayList<String>();
                for (int i=0;i<aliases.size();i++){
                    if(getDoctorAvgRating(aliases.get(i))>=Integer.parseInt(rating)){
                        temp.add(aliases.get(i));
                    } 
                }
                aliases.clear();
                for (int i=0;i<temp.size();i++){
                    aliases.add(temp.get(i));
                }
            }
            System.out.println(aliases);
            if (reviewed.equals("on")){
                ArrayList<String> temp = new ArrayList<String>();
                for (int i=0;i<aliases.size();i++){
                    if(reviewdByFriend(self,aliases.get(i))){
                        temp.add(aliases.get(i));
                    } 
                }
                aliases.clear();
                for (int i=0;i<temp.size();i++){
                    aliases.add(temp.get(i));
                }
            }
            System.out.println(aliases);
            
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
    
    public static void requestFriendship(String requestor, String requestee) 
            throws ClassNotFoundException, SQLException {
        Connection conn = null;
        CallableStatement stmt = null;
        try{
            conn = getTestConnection();

            String sql = "{CALL Test_RequestFriend (?, ?)}";
            stmt = conn.prepareCall(sql);
            stmt.setString(1, requestor);
            stmt.setString(2, requestee);
            stmt.execute();
        }
        catch(SQLException se){
            se.printStackTrace();
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            try{
                if(stmt != null)
                    stmt.close();
            } catch(SQLException se2) {}// nothing to do
            
            try{
                if(conn != null)
                conn.close();
            } catch(SQLException se) {
                se.printStackTrace();
            }
       }
        
    }
    
    public static Boolean checkFriendship(String requestor, String requestee)
            throws ClassNotFoundException, SQLException {
        Boolean friendship = false;
        Connection conn = null;
        CallableStatement stmt = null;
        try{
            conn = getTestConnection();

            String sql = "{CALL AreFriends (?, ?, ?)}";
            stmt = conn.prepareCall(sql);
            stmt.setString(1, requestor);
            stmt.setString(2, requestee);
            stmt.registerOutParameter(3, java.sql.Types.INTEGER);
            stmt.execute();
            int retCode = stmt.getInt(3);
            if(retCode == 1)
                friendship = true;
        }
        catch(SQLException se){
            se.printStackTrace();
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            try{
                if(stmt != null)
                    stmt.close();
            } catch(SQLException se2) {}// nothing to do
            
            try{
                if(conn != null)
                conn.close();
            } catch(SQLException se) {
                se.printStackTrace();
            }
       }
       return friendship;
    }
    
    public static ArrayList<FriendshipRequestInfo>listRequests(String myself)
    {
        ArrayList<FriendshipRequestInfo> results=new ArrayList<FriendshipRequestInfo>();
        String sql = "SELECT 356_friends.Alias AS requestor, 356_patients.Email AS email FROM 356_friends "
                + "JOIN 356_patients ON 356_friends.Alias = 356_patients.Alias "
                + "WHERE 356_friends.Friend_Alias=? AND 356_friends.Friend_Accept = 0 ";

        Connection con = null;
        PreparedStatement stmt = null;
        try {
            con = getTestConnection();
            stmt = con.prepareStatement(sql);
            stmt.setString(1, myself);
            ResultSet resultSet = stmt.executeQuery();
            
            while(resultSet.next())
            {
                FriendshipRequestInfo entry = new FriendshipRequestInfo();
                entry.request_alias = resultSet.getString("requestor");
                entry.email = resultSet.getString("email");
                results.add(entry);
            }
        }
        catch(SQLException se){
            se.printStackTrace();
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            try{
                if(stmt != null)
                    stmt.close();
            } catch(SQLException se2) {}// nothing to do
            
            try{
                if(con != null)
                con.close();
            } catch(SQLException se) {
                se.printStackTrace();
            }
       }
        return results;
    }
    
    public static ArrayList<String>listFriends(String myself)
    {
        ArrayList<String> results=new ArrayList<String>();
        String sql = "SELECT 356_friends.Friend_Alias AS friend FROM 356_friends "
                + "WHERE 356_friends.Friend_Accept = 1 AND 356_friends.Alias=? ";

        Connection con = null;
        PreparedStatement stmt = null;
        try {
            con = getTestConnection();
            stmt = con.prepareStatement(sql);
            stmt.setString(1, myself);
            ResultSet resultSet = stmt.executeQuery();
            
            while(resultSet.next())
            {
                String friend = resultSet.getString("friend");
                results.add(friend);
            }
        }
        catch(SQLException se){
            se.printStackTrace();
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            try{
                if(stmt != null)
                    stmt.close();
            } catch(SQLException se2) {}// nothing to do
            
            try{
                if(con != null)
                con.close();
            } catch(SQLException se) {
                se.printStackTrace();
            }
       }
        return results;
    }
    
    public static ArrayList<String>GetAllDistinctCities()
    {
        ArrayList<String> results=new ArrayList<String>();
        String sql = "SELECT DISTINCT Addr_City AS city FROM 356_patients";

        Connection con = null;
        PreparedStatement stmt = null;
        try {
            con = getTestConnection();
            stmt = con.prepareStatement(sql);
            ResultSet resultSet = stmt.executeQuery();
            
            while(resultSet.next())
            {
                String city = resultSet.getString("city");
                results.add(city);
            }
        }
        catch(SQLException se){
            se.printStackTrace();
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            try{
                if(stmt != null)
                    stmt.close();
            } catch(SQLException se2) {}// nothing to do
            
            try{
                if(con != null)
                con.close();
            } catch(SQLException se) {
                se.printStackTrace();
            }
       }
        return results;
    }
    
    public static ArrayList<String>GetAllDistinctProvinces()
    {
        ArrayList<String> results=new ArrayList<String>();
        String sql = "SELECT DISTINCT Addr_Province AS province FROM 356_patients";

        Connection con = null;
        PreparedStatement stmt = null;
        try {
            con = getTestConnection();
            stmt = con.prepareStatement(sql);
            ResultSet resultSet = stmt.executeQuery();
            
            while(resultSet.next())
            {
                String province = resultSet.getString("province");
                results.add(province);
            }
        }
        catch(SQLException se){
            se.printStackTrace();
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            try{
                if(stmt != null)
                    stmt.close();
            } catch(SQLException se2) {}// nothing to do
            
            try{
                if(con != null)
                con.close();
            } catch(SQLException se) {
                se.printStackTrace();
            }
       }
        return results;
    }

    public static ArrayList<Integer> getReviewIDList(String doc_alias) throws ClassNotFoundException, SQLException, NamingException {
        ArrayList<Integer> list=new ArrayList<Integer>();
        String statement="SELECT * FROM 356_review WHERE Doctor_Alias=? ORDER BY DATE DESC";
        
        //Connection con=getConnection();
        Connection con=getTestConnection();
        try {
            
            PreparedStatement stmt = con.prepareStatement(statement);
            stmt.setString(1,doc_alias);
            ResultSet resultSet = stmt.executeQuery();
            
            while(resultSet.next())
            {
                list.add(resultSet.getInt("Review_ID"));
            }

        }
        catch (Exception e) {  
            System.out.println(e);  
        }
        finally{
            con.close(); // this statement returns the connection back to the pool
        }
        return list;
    }

    public static Review getReviewByID(int ID) throws SQLException, ClassNotFoundException, NamingException {
        Review entry=new Review();
        String statement="SELECT * FROM 356_review WHERE Review_ID=?";
        
        //Connection con=getConnection();
        Connection con=getTestConnection();
        try {
            
            PreparedStatement stmt = con.prepareStatement(statement);
            stmt.setInt(1,ID);
            ResultSet resultSet = stmt.executeQuery();
            
            if(resultSet.next())
            {
                entry.Review_ID=resultSet.getInt("Review_ID");
                entry.Patient_Alias=resultSet.getString("Patient_Alias");
                entry.Doctor_Alias=resultSet.getString("Doctor_Alias");
                entry.Comment=resultSet.getString("Comment");
                entry.Rating=resultSet.getInt("Rating");
                entry.Date=resultSet.getDate("Date");
            }

        }
        catch (Exception e) {  
            System.out.println(e);  
        }
        finally{
            con.close(); // this statement returns the connection back to the pool
        }
        return entry;
    }

    public static int getNextReviewID(int intID, String doctor) throws ClassNotFoundException, SQLException, NamingException {
        int next=-1;
        ArrayList<Integer> list=getReviewIDList(doctor);
        for(int i=0;i<list.size();i++){
            if (list.get(i)==intID && i+1<list.size())
            {
                next= list.get(i+1);
            }
        }
        return next;
    }
    public static int getPreviousReviewID(int intID, String doctor) throws ClassNotFoundException, SQLException, NamingException {
        int previous=-1;
        ArrayList<Integer> list=getReviewIDList(doctor);
        for(int i=0;i<list.size();i++){
            if (list.get(i)==intID && i-1>=0)
            {
                previous=list.get(i-1);
            }
        }
        return previous;
    }

    static boolean writeReview(String doctor_alias, String patient_alias, String comment, int rating) throws SQLException, ClassNotFoundException, NamingException {
        boolean success=false;
        String statement="INSERT INTO 356_review(Patient_Alias,Doctor_Alias,Rating,Comment,date) VALUES (?,?,?,?,NOW());";
        
        //Connection con=getConnection();
        Connection con=getTestConnection();
        try {
            
            PreparedStatement stmt = con.prepareStatement(statement);
            stmt.setString(1,patient_alias);
            stmt.setString(2,doctor_alias);
            stmt.setInt(3,rating);
            stmt.setString(4,comment);
            stmt.executeUpdate();
            success=true;
        }
        catch (Exception e) {  
            System.out.println(e);  
        }
        finally{
            con.close(); // this statement returns the connection back to the pool
        }
        return success;
    }
}
