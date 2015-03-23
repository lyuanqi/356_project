<%-- 
    Document   : doctor
    Created on : Mar 23, 2015, 5:21:51 AM
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
    <h1>User: ${sessionScope.doctor}</h1>
    <h2><a href="GetDoctorProfileServlet?alias=${sessionScope.doctor}">View Profile</a></h2>
    <h2><a href="LogoutServlet">Logout</a></h2>
</body>
</html>