/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ece356;

import ece356Types.DoctorSearchResult;
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
public class DoctorSearchServlet extends HttpServlet {

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
        
        HttpSession session = request.getSession(false); 
        String self=(String)session.getAttribute("alias");

        String first=request.getParameter("first");
        String last=request.getParameter("last");
        String licensed_years=request.getParameter("years");
        String gender=request.getParameter("gender");
        String specialization=request.getParameter("special");
        String stnum=request.getParameter("stnum");
        String stname=request.getParameter("stname");
        String sttype=request.getParameter("sttype");
        String pre=request.getParameter("prefix");
        String suff=request.getParameter("suffix");
        String city=request.getParameter("city");
        String province=request.getParameter("province");
        String keyword=request.getParameter("keyword");
        String rating=request.getParameter("rating");
        String reviewed="";
        if (request.getParameter("reviewed")!=null){
            reviewed=request.getParameter("reviewed");
        }
        

        String url = null;
        String successUrl = "doctorSearchResult.jsp";
        String failUrl = "doctorSearch.jsp";
        
        response.setContentType("text/html");    
        PrintWriter out = response.getWriter();    
        
        try {
            ArrayList<DoctorSearchResult> results=DBAO.doctorSearch(self,first,last,licensed_years,gender,specialization,stnum,stname,sttype,pre,suff,city,province,keyword,rating,reviewed);
            if (results.size()>0){
                url = successUrl;
                request.setAttribute("results", results);
            }
            else{
                url=failUrl;
                out.print("<p style=\"color:red\">Sorry, no matched record</p>");
                
                out.print("\""+self+"\",\""+first+"\",\""+last+"\",\""+licensed_years+"\",\""+gender+"\",\""+specialization+"\",\""+stnum+"\",\""+stname+"\",\""+sttype+"\",\""+pre+"\",\""+suff+"\",\""+city+"\",\""+province+"\",\""+keyword+"\",\""+rating+"\",\""+reviewed+"\"");
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
