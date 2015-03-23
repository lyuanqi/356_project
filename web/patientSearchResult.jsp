<%-- 
    Document   : PatientSearchResult
    Created on : Mar 21, 2015, 10:37:48 PM
    Author     : liyuanqi
--%>

<%@page import="java.util.ArrayList"%>
<%@page import="ece356Types.PatientSearchResult"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% ArrayList<PatientSearchResult> results=(ArrayList<PatientSearchResult>) request.getAttribute("results");%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Patient Search Results</title>
    </head>
    <body>
        <h1>Patient Data</h1>
        <table border=1><tr><th>Patient Alias</th><th>Address</th><th>Review Count</th><th>Last Review Date</th><th>Add Friend Link</th></tr>
            <%
                for (PatientSearchResult result : results) {
            %>
            <tr>
                <td><%= result.alias%></td>
                <td><%= result.home_address%></td>
                <td><%= result.review_count%></td>
                <td><%= result.GetLastReviewDate()%></td>
                <td> <% 
                        if(result.friendship != "none") {
                     %>
                     <%= result.friendship %>
                     <% } else { %>
                           <a href="<%= result.link%>" >Add as a friend</a>
                     <% } %>
                </td>
            </tr>
            <%
                }
            %>
        </table>
    </body>
</html>
