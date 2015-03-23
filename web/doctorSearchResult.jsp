<%-- 
    Document   : doctorSearchResult
    Created on : Mar 22, 2015, 3:34:52 AM
    Author     : liyuanqi
--%>

<%@page import="java.util.ArrayList"%>
<%@page import="ece356Types.DoctorSearchResult"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% ArrayList<DoctorSearchResult> results=(ArrayList<DoctorSearchResult>) request.getAttribute("results");%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Doctor Search Results</title>
    </head>
    <body>
        <h3><a href="patientHome.jsp">Home</a></h3>
        <h1>Patient Data</h1>
        <table border=1><tr><th>Doctor Name</th><th>Gender</th><th>Average Rating</th><th>Related Reviews</th><th>Profile Link</th></tr>
            <%
                for (DoctorSearchResult result : results) {
            %>
            <tr>
                <td><%= result.name %></td>
                <td><%= result.gender%></td>
                <td><%= result.avg_rating%></td>
                <td><%= result.review_count %></td>
                <td><a href="<%= result.profile_link%>">Profile Link</a></td>
            </tr>
            <%
                }
            %>
        </table>
    </body>
</html>
