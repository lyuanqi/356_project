<%-- 
    Document   : writeReview
    Created on : Mar 23, 2015, 6:10:42 PM
    Author     : liyuanqi
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Write Review</title>
    </head>
    <body>
        <%if(session.getAttribute("userType")=="patient"){%>
        <h3><a href="patientHome.jsp">Home</a></h3>
        <% } %>
        <%if(session.getAttribute("userType")=="doctor"){%>
        <h3><a href="doctorHome.jsp">Home</a></h3>
        <% } %>
        
        <h3>Reviewer: <%=(String) session.getAttribute("alias")%></h3>
        <h3>Doctor: <%=(String) session.getAttribute("dalias")%></h3>

<form action="WriteDoctorReviewServlet" method="post">
<h3>Rating:</h3>
<Select name="rating">
    <option value="0">0</option>
    <option value="1">1</option>
    <option value="2">2</option>
    <option value="3">3</option>
    <option value="4">4</option>
    <option value="4">5</option>
</Select>
Comments:<br />
<textarea name="comment" id="comments">
</textarea><br />
<input type="submit" value="Submit" />
</form>
    </body>
</html>
