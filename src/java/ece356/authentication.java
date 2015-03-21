/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ece356;

import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.spec.InvalidKeySpecException;
import java.sql.*;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;
/**
 *
 * @author liyuanqi
 */
public class authentication {
    
    public static String generateSalt()
        throws NoSuchAlgorithmException, InvalidKeySpecException
    {
        // Generate a random salt
        SecureRandom random = new SecureRandom();
        byte[] salt = new byte[PasswordHash.SALT_BYTE_SIZE];
        random.nextBytes(salt);

        // format iterations:salt:hash
        return PasswordHash.toHex(salt);
    }
    
    public static boolean validate(String user, String pass, String userType) throws SQLException, NamingException, ClassNotFoundException{
        boolean hasMatch=false;
        String salt="";
        String table="";
        
        switch (userType) {
            case "doctor":
                table="356_doctors";
                break;
            case "patient":
                table="356_patients";
                break;
        }
        
        String statement1="SELECT Salt FROM "+table+" WHERE Alias=?";
        String statement2="SELECT * FROM "+table+" WHERE Alias=? AND Password=SHA2(CONCAT(?,?),256)";

        //Connection con=DBAO.getConnection();
        Connection con=DBAO.getTestConnection();
        try {
            
            PreparedStatement stmt = con.prepareStatement(statement1);
            stmt.setString(1, user);
            ResultSet resultSet = stmt.executeQuery();
            if(resultSet.next())
            {
                salt = resultSet.getString("Salt");
            }
            if (!salt.equals("")){
                stmt = con.prepareStatement(statement2);
                stmt.setString(1, user);
                stmt.setString(2, salt);
                stmt.setString(3, pass);
                System.out.println(stmt);
                resultSet = stmt.executeQuery();
                if(resultSet.next())
                {
                    hasMatch=true;
                }
            }

        }
        catch (Exception e) {  
            System.out.println(e);  
        }
        finally{
            con.close(); // this statement returns the connection back to the pool
        }
        return hasMatch;
    }
}
