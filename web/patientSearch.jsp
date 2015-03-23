<%-- 
    Document   : patientSearch
    Created on : Mar 21, 2015, 7:46:27 PM
    Author     : liyuanqi
--%>

<%@page import="java.util.ArrayList"%>
<%@page import="ece356.DBAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Patient Search</title>
    </head>
    
    <body>
        <h3><a href="patientHome.jsp">Home</a></h3>
      <form action="PatientSearchServlet" method="post">
        <h2>Please fill in search criteria</h2>
        <h4>Enter alias:</h4>
        <input type="text" name="alias">
        <h4>Select city:</h4>
        <Select name="city">
            <option></option>
            <% ArrayList<String> cities=(ArrayList<String>)DBAO.getAllElements("patient","city");%>
            <%for(String result : cities){%>
            <option value="<%=result%>"><%=result%></option>
            <%}%>
        </Select>
        <h4>Select province:</h4>
        <Select name="province">
            <option></option>
            <% ArrayList<String> provinces=(ArrayList<String>)DBAO.getAllElements("patient","province");%>
            <%for(String result : provinces){%>
            <option value="<%=result%>"><%=result%></option>
            <%}%>
        </Select>
        <button type="submit">Search</button>
      </form>
    </body>
</html>
