<%-- 
    Document   : patientSearch
    Created on : Mar 21, 2015, 7:46:27 PM
    Author     : liyuanqi
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
        <input type="text" name="city">
        <h4>Enter province</h4>
        <input type="text" name="province">
        <button type="submit">Search</button>
      </form>
    </body>
</html>
