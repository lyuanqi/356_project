/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ece356;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Wojciech Golab
 */
public class LoginServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP
     * <code>GET</code> and
     * <code>POST</code> methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String userType = request.getParameter("type");
        String user=request.getParameter("username");    
        String pass=request.getParameter("userpass");   
        String url = null;
        String successUrl = null;
        String failUrl = null;
        
        switch (userType) {
            case "doctor":
                successUrl="protected/success.jsp";
                failUrl="doctorSignInPage.jsp";
                break;
            case "patient":
                successUrl="protected/success.jsp";
                failUrl="patientSignInPage.jsp";
                break;
        }
        response.setContentType("text/html");    
        PrintWriter out = response.getWriter();    
        
        HttpSession session = request.getSession(false);  
        try {
            if (Authentication.validate(user,pass,userType)==true){
                url = successUrl;
                if(session!=null){
                    session.setAttribute("alias", user);
                }
            }
            else{
                url=failUrl;
                out.print("<p style=\"color:red\">Sorry, unmatched username or password</p>");    
            }
            
        } catch (Exception e) {
            request.setAttribute("exception", e);
            url = "fancyError.jsp";
        }
            RequestDispatcher rd=request.getRequestDispatcher(url);    
            rd.include(request,response);  
            out.close();  
    }
}
