package ece356;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import ece356Types.FriendshipRequestInfo;
import ece356Types.Review;
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
 * @author JieJerryLin
 */
public class WriteDoctorReviewServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String doctor_alias=(String) session.getAttribute("dalias");
        String patient_alias=(String) session.getAttribute("alias");
        String comment=request.getParameter("comment");
        String rating=request.getParameter("rating");
        int intRating=Integer.parseInt(rating);
        
        boolean success=false;
        boolean commentValid=false;
        PrintWriter out = response.getWriter();    

        
        String url="";
        String successUrl = "writeReview.jsp";
        String failUrl = "writeReview.jsp";
        
        try {
            char[] temp = comment.toCharArray();
            for (char c : temp){
                if (c!=' ')
                {
                    commentValid=true;
                    break;
                }
            }
            if (comment.length()<5){
                success=false;
                out.print("<p style=\"color:red\">Please enter more than 5 characters in your comment</p>");   
            }
            else if (comment.length()>1000){
                success=false;
                out.print("<p style=\"color:red\">Please enter less than 1000 characters in your comment</p>");   
            }
            else if (commentValid==false){
                success=false;
                out.print("<p style=\"color:red\">Please enter non-blank comment</p>");
            }
            
            else{
                success=DBAO.writeReview(doctor_alias,patient_alias,comment,intRating);
            }
            
            if(success==true){
                out.print("<p style=\"color:green\">Comment Submitted!</p>");
                url=successUrl;
            }
            else{
                url=failUrl;
            }
            
        } catch (Exception e) {
            request.setAttribute("exception", e);
            url = "fancyError.jsp";
        } finally {
            RequestDispatcher rd=request.getRequestDispatcher(url);    
            rd.include(request,response);  
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
