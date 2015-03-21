/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ece356;

import java.sql.*;
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
}
