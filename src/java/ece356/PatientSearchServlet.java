/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ece356;

import ece356Types.PatientSearchResult;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
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
public class PatientSearchServlet extends HttpServlet {

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
        String alias=request.getParameter("alias");    
        String city=request.getParameter("city"); 
        String province = request.getParameter("province");

        String url = null;
        String successUrl = "patientSearchResult.jsp";
        String failUrl = "patientSearch.jsp";
        
        response.setContentType("text/html");    
        PrintWriter out = response.getWriter();    
        
        try {
            ArrayList<PatientSearchResult> results=DBAO.patientSearch(alias,city,province);
            if (results.size()>0){
                url = successUrl;
                request.setAttribute("results", results);
            }
            else{
                url=failUrl;
                out.print("<p style=\"color:red\">Sorry, no matched record</p>");   
                //out.print(alias);
                //out.print(city);
                //out.print(province);
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
