<%-- 
    Document   : fancyError
    Created on : 30-Jan-2013, 9:10:36 PM
    Author     : Wojciech Golab
--%>

<%@page import="java.io.PrintWriter"%>
<%@page import="java.io.StringWriter"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<html>
<head>
<title>Error Page</title>
</head>
<body>
    
<jsp:declaration>
String errorMessage;
String stackTrace;
</jsp:declaration>

<jsp:scriptlet>
Exception myException = (Exception)request.getAttribute("exception");
errorMessage = myException.getMessage();
if (errorMessage == null) { errorMessage = ""; }
StringWriter errorWriter = new StringWriter();
myException.printStackTrace(new PrintWriter(errorWriter));
stackTrace = errorWriter.toString();
</jsp:scriptlet>

<h1>Houston, we have a problem!</h1>
<jsp:scriptlet>
if (errorMessage.startsWith("Access denied")) {    
</jsp:scriptlet>
<h2> Access to DB denied.  Double-check the user ID and password in the DBAO class.</h2>
<jsp:scriptlet>
} else if (errorMessage.startsWith("Communications link failure")) {    
</jsp:scriptlet>
<h2> Unable to connect to database.  Check the url in the DBAO class, then check your network/VPN connection.</h2>
<jsp:scriptlet>
} else if (errorMessage.startsWith("Table") && errorMessage.indexOf("doesn't exist") != -1) {
</jsp:scriptlet>
<h2> Trying to access a table that doesn't exist.  Double-check your SQL. </h2>
<jsp:scriptlet>
} else {
</jsp:scriptlet>
<h2>Exception message:</h2>
<%= myException.getClass().getName() %>: <%= errorMessage %>
<jsp:scriptlet>
}
</jsp:scriptlet>
<h4>Exception stack trace:</h4>
<pre>
    <%= stackTrace %>
</pre>

</body>
</html>