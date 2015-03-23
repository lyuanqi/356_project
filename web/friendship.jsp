<%-- 
    Document   : checkFriendship.jsp
    Created on : 22-Mar-2015, 7:43:47 PM
    Author     : JieJerryLin
--%>

<%@page import="java.util.ArrayList"%>
<%@page import="ece356Types.FriendshipRequestInfo"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% ArrayList<FriendshipRequestInfo> requests = (ArrayList<FriendshipRequestInfo>)request.getAttribute("requests");
    ArrayList<String> friends = (ArrayList<String>)request.getAttribute("friends");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Friend requests from other patients!</h1>
        <% if(requests == null) {%>
        <p>Nothing</p>
        <% } else { %>
             <table border=1>
                 <tr><th>Alias</th>
                     <th>Address</th>
                     <th>Accept</th>
                 </tr>
                <% for (FriendshipRequestInfo r : requests) { %>
                <tr>
                    <td><%= r.request_alias %></td>
                    <td><%= r.email %></td>
                    <td><a href="AddFriendServlet?friend=<%= r.request_alias%>" >Confirm friendship</a></td>
                </tr>
                <% } %>
             </table>
        <% } %> 
        <h1>Friend list</h1>
                <% if(friends == null) {%>
         <img src="http://fc02.deviantart.net/fs71/f/2010/239/d/f/forever_alone_by_foreveraloneplz.png" >
        <% } else { %>
             <table border=1>
                 <tr><th>Alias</th>
                 </tr>
                <% for (String f : friends) { %>
                <tr>
                    <td><%= f %></td>
                </tr>
                <% } %>
             </table>
        <% } %> 
    </body>
</html>
