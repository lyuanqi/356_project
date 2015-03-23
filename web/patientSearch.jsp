<%-- 
    Document   : patientSearch
    Created on : Mar 21, 2015, 7:46:27 PM
    Author     : liyuanqi
--%>

<%@page import="java.util.ArrayList"%>
<%@page import="ece356Types.FriendshipRequestInfo"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% ArrayList<String> cities = (ArrayList<String>)request.getAttribute("cities");
    ArrayList<String> provinces = (ArrayList<String>)request.getAttribute("provinces");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Patient Search</title>
    </head>
    <body>
      <form action="PatientSearchServlet" method="post">
        <h2>Please fill in search criteria</h2>
        <h4>Enter alias:</h4>
        <input type="text" name="alias">
        <h4>Enter city</h4>
        <Select name="city">
            <option></option>
            <%  if(cities != null) {
                    for (String c : cities) {
            %>
                <option><%= c %></option>
            <%      }
                }
            %>
        </Select>
        <h4>Enter province</h4>
         <Select name="province">
            <option></option>
             <%  if(provinces != null) {
                    for (String p : provinces) {
            %>
                <option><%= p %></option>
            <%      }
                }
            %>
        </Select>
        <button type="submit">Search</button>
      </form>
    </body>
</html>
