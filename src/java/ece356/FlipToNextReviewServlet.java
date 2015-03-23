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
public class FlipToNextReviewServlet extends HttpServlet {

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
        String ID=request.getParameter("ID");
        String doctor=request.getParameter("doctor");
        String url = "viewReviewPage.jsp";
        int intID=Integer.parseInt(ID);
        response.setContentType("text/html");    
        PrintWriter out = response.getWriter();   
        Review nextReview;
        try {
            int next=DBAO.getNextReviewID(intID,doctor);
            if (next<=0)
            {
                out.print("<p style=\"color:red\">Already the last review.</p>"); 
                nextReview=DBAO.getReviewByID(intID);
            }
            else{
                nextReview=DBAO.getReviewByID(next);
            }
            request.setAttribute("review_entry", nextReview);
            
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
