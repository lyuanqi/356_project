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
        <title>Doctor Search</title>
    </head>
    <body>
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
            <option>surgeon</option>
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
        <p>Street Name: <input type="text" name="stname"></p>
        <p>Street Type: <input type="text" name="sttype"></p>
        <p>Postal Code Prefix: <input type="text" name="prefix"></p>
        <p>Postal Code Suffix: <input type="text" name="suffix"></p>
        <p>City: <input type="text" name="city"></p>
        <p>Province: <input type="text" name="province"></p>
        <button type="submit">Search</button>
      </form>
    </body>
</html>
