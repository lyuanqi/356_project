<%-- 
    Document   : viewReviewPage
    Created on : Mar 23, 2015, 7:00:44 AM
    Author     : liyuanqi
--%>

<%@page import="ece356Types.Review"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% Review entry=(Review) request.getAttribute("review_entry");%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Review Entry</title>
    </head>
    <body>
        <%if(session.getAttribute("userType")=="patient"){%>
        <h3><a href="patientHome.jsp">Home</a></h3>
        <% } %>
        <%if(session.getAttribute("userType")=="doctor"){%>
        <h3><a href="doctorHome.jsp">Home</a></h3>
        <% } %>
        
        <h3>Reviewed On: <%=entry.Date%></h3>
        <h3>Reviewed By: <%=entry.Patient_Alias%></h3>
        <h3>Doctor: <%=entry.Doctor_Alias%></h3>
        <h3>Rating: <%=entry.Rating%></h3>
        <h3>Comment:</h3>
        <p><%=entry.Comment %></p>
        <a href="FlipToPreviousReviewServlet?doctor=<%=entry.Doctor_Alias %>&ID=<%=entry.Review_ID%>">Previous Review</a>
        <a href="FlipToNextReviewServlet?doctor=<%=entry.Doctor_Alias %>&ID=<%=entry.Review_ID%>">Next Review</a>
    </body>
</html>
