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
        <title>Doctor Search</title>
    </head>
    <body>
        <h3><a href="patientHome.jsp">Home</a></h3>
      <form action="DoctorSearchServlet" method="post">
        <h2>Please fill in search criteria</h2>
        <h3>**Doctor Profile Section**</h3>
        <p>Doctor First Name: <input type="text" name="first"></p>
        <p>Doctor Last Name: <input type="text" name="last"></p>
        <p>Number of Years Licensed Greater Than: <input type="text" name="years"></p>
        <p>Gender:
        <Select name="gender">
            <option></option>
            <option value="male">male</option>
            <option value="female">female</option>
        </Select>
        </p>
        <p>Specialization Area
        <Select name="special">
            <option></option>
            <% ArrayList<String> results=(ArrayList<String>)DBAO.getAllSpecialization();%>
            <%for(String result : results){%>
            <option value="<%=result%>"><%=result%></option>
            <%}%>
        </Select>
        </p>
        <p>Average Star Rating Greater Or Equal To:         
        <Select name="rating">
            <option value=""></option>
            <option value="0">0</option>
            <option value="1">1</option>
            <option value="2">2</option>
            <option value="3">3</option>
            <option value="4">4</option>
            <option value="4">5</option>
        </Select>
        </p>
        <p>Reviewed By A Friend<input type="checkbox" name="reviewed"></p>
        <p>Review Keyword: <input type="text" name="keyword"></p>
        <h3>**Doctor Office Section**</h3>
        <p>Street Number: <input type="text" name="stnum"></p>
        <p>Street Name:         
        <Select name="stname">
            <option></option>
            <% ArrayList<String> stnames=(ArrayList<String>)DBAO.getAllElements("doctor","stname");%>
            <%for(String result : stnames){%>
            <option value="<%=result%>"><%=result%></option>
            <%}%>
        </Select>
        </p>
        
        <p>Street Type: 
        <Select name="sttype">
            <option></option>
            <% ArrayList<String> sttypes=(ArrayList<String>)DBAO.getAllElements("doctor","sttype");%>
            <%for(String result : sttypes){%>
            <option value="<%=result%>"><%=result%></option>
            <%}%>
        </Select>
        </p>
        <p>Postal Code Prefix: 
        <Select name="prefix">
            <option></option>
            <% ArrayList<String> prefixes=(ArrayList<String>)DBAO.getAllElements("doctor","prefix");%>
            <%for(String result : prefixes){%>
            <option value="<%=result%>"><%=result%></option>
            <%}%>
        </Select>
        </p>
        <p>Postal Code Suffix: 
        <Select name="suffix">
            <option></option>
            <% ArrayList<String> suffixes=(ArrayList<String>)DBAO.getAllElements("doctor","suffix");%>
            <%for(String result : suffixes){%>
            <option value="<%=result%>"><%=result%></option>
            <%}%>
        </Select>
        </p>
        <p>City: 
        <Select name="city">
            <option></option>
            <% ArrayList<String> cities=(ArrayList<String>)DBAO.getAllElements("doctor","city");%>
            <%for(String result : cities){%>
            <option value="<%=result%>"><%=result%></option>
            <%}%>
        </Select>
        </p>
        <p>Province: 
        <Select name="province">
            <option></option>
            <% ArrayList<String> provinces=(ArrayList<String>)DBAO.getAllElements("doctor","province");%>
            <%for(String result : provinces){%>
            <option value="<%=result%>"><%=result%></option>
            <%}%>
        </Select>
        </p>
        <button type="submit">Search</button>
      </form>
    </body>
</html>
