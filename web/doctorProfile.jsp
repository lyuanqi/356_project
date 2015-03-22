<%-- 
    Document   : doctorProfile
    Created on : Mar 22, 2015, 1:33:08 AM
    Author     : liyuanqi
--%>

<%@page import="java.util.ArrayList"%>
<%@page import="ece356Types.DoctorProfile"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% DoctorProfile profile=(DoctorProfile) request.getAttribute("profile");%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Doctor Profile</title>
    </head>
    <body>
        <h1>Doctor: <%= profile.name%></h1>
        <h3>Average Star Rating: <%=profile.avg_rating%> </h3>
        <h3>Years since licensed: <%=profile.years_licensed%> </h3>
        <h3>Specialization Areas:</h3>
            <%
                for (String area : profile.specializations) {
            %>
            <p><%=area%><p>
            <%
                }
            %>
        <h3>Office Locations:</h3>
            <%
                for (String address : profile.addresses) {
            %>
            <p><%=address%><p>
            <%
                }
            %>
        <h3>Related Reviews (Total: <%=profile.review_count%>)</h3>
            <%
                for (String link : profile.review_links ) {
            %>
            <p><a href="<%=link%>"></a><p>
            <%
                }
            %>
        <h3>Write a review for this doctor:</h3>
        <p><a href="<%=profile.write_link%>">Click to write a review</a></p>
        

    </body>
</html>
