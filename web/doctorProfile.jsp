<%-- 
    Document   : doctorProfile
    Created on : Mar 22, 2015, 1:33:08 AM
    Author     : liyuanqi
--%>

<%@page import="ece356.DBAO"%>
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
        <%session.setAttribute("dalias",profile.alias);%>
        <%if(session.getAttribute("userType")=="patient"){%>
        <h3><a href="patientHome.jsp">Home</a></h3>
        <% } %>
        <%if(session.getAttribute("userType")=="doctor"){%>
        <h3><a href="doctorHome.jsp">Home</a></h3>
        <% } %>
        <h1>Doctor: <%= profile.name%></h1>
        <%if(session.getAttribute("userType")=="doctor"){%>
        <h3>Email: <%=profile.email%></h3>
        <% } %>
        <input type="hidden" name="doc_dalias" value="<%=profile.alias%>">
        <h3>Gender: <%=profile.gender%></h3>
        <h3>Average Star Rating: <%=(double)Math.round(profile.avg_rating * 10) / 10%> </h3>
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
                for (int i=0;i<profile.review_links.size();i++ ) {
            %>
            <p><a href="<%=profile.review_links.get(i) %>">Review <%=i+1%></a><p>
            <%
                }
            %>
        <%if(session.getAttribute("userType")=="patient"){%>
        <h3>Write a review for this doctor:</h3>
        <p><a href="<%=profile.write_link%>">Click to write a review</a></p>
        <% } %>
        
        

    </body>
</html>
