/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ece356;

import java.security.NoSuchAlgorithmException;
import java.security.spec.InvalidKeySpecException;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.naming.NamingException;

/**
 *
 * @author liyuanqi
 */
public class test {
    public static void main(String[] args) throws NoSuchAlgorithmException, InvalidKeySpecException, SQLException, NamingException, ClassNotFoundException{
        System.out.println(Authentication.validate("doc_cutter","doc_cuter","doctor"));

    }
}
