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
        String first=request.getParameter("first");
        String last=request.getParameter("last");
        String licensed_years=request.getParameter("years");
        String gender=request.getParameter("gender");
        String speciliazation=request.getParameter("special");
        String stnum=request.getParameter("stnum");
        String stname=request.getParameter("stname");
        String sttype=request.getParameter("sttype");
        String pre=request.getParameter("prefix");
        String suff=request.getParameter("suffix");
        String city=request.getParameter("city");
        String province=request.getParameter("province");
        String keyword=request.getParameter("keyword");

        String url = null;
        String successUrl = "doctorSearchResult.jsp";
        String failUrl = "doctorSearch.jsp";
        
        response.setContentType("text/html");    
        PrintWriter out = response.getWriter();    
        
        try {
            ArrayList<DoctorSearchResult> results=DBAO.doctorSearch(first, last, licensed_years, gender, speciliazation, stnum, stname, sttype, pre, suff, city, province, keyword);
            if (results.size()>0){
                url = successUrl;
                request.setAttribute("results", results);
            }
            else{
                url=failUrl;
                out.print("<p style=\"color:red\">Sorry, no matched record</p>");
                
                out.print(first+","+last+","+licensed_years+","+gender+","+speciliazation+","+stnum+","+stname+","+sttype+","+pre+","+suff+","+city+","+province+","+keyword);
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
