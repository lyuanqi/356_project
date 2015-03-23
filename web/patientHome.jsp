<%-- 
    Document   : patientHome
    Created on : Mar 21, 2015, 5:27:44 PM
    Author     : liyuanqi
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">
<!DOCTYPE html>
<html lang="en">
  <head>
  </head>

<body>
    <h1>User: ${sessionScope.alias}</h1>
    <h2><a href="patientSearch.jsp">Patient Search</a></h2>
    <h2><a href="doctorSearch.jsp">Doctor Search</a></h2>
    <h2><a href="FriendListServlet">View Friends</a></h2>
</body>
</html>