package org.apache.jsp;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;

public final class patientSearch_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent {

  private static final JspFactory _jspxFactory = JspFactory.getDefaultFactory();

  private static java.util.List<String> _jspx_dependants;

  private org.glassfish.jsp.api.ResourceInjector _jspx_resourceInjector;

  public java.util.List<String> getDependants() {
    return _jspx_dependants;
  }

  public void _jspService(HttpServletRequest request, HttpServletResponse response)
        throws java.io.IOException, ServletException {

    PageContext pageContext = null;
    HttpSession session = null;
    ServletContext application = null;
    ServletConfig config = null;
    JspWriter out = null;
    Object page = this;
    JspWriter _jspx_out = null;
    PageContext _jspx_page_context = null;

    try {
      response.setContentType("text/html;charset=UTF-8");
      pageContext = _jspxFactory.getPageContext(this, request, response,
      			null, true, 8192, true);
      _jspx_page_context = pageContext;
      application = pageContext.getServletContext();
      config = pageContext.getServletConfig();
      session = pageContext.getSession();
      out = pageContext.getOut();
      _jspx_out = out;
      _jspx_resourceInjector = (org.glassfish.jsp.api.ResourceInjector) application.getAttribute("com.sun.appserv.jsp.resource.injector");

      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("<!DOCTYPE html>\n");
      out.write("<html>\n");
      out.write("    <head>\n");
      out.write("        <meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">\n");
      out.write("        <title>Doctor Search</title>\n");
      out.write("    </head>\n");
      out.write("    <body>\n");
      out.write("      <form action=\"DoctorSearchServlet\" method=\"post\">\n");
      out.write("        <h2>Please fill in search criteria</h2>\n");
      out.write("        <h3>**Doctor Profile Section**</h3>\n");
      out.write("        <p>Doctor First Name: <input type=\"text\" name=\"first\"></p>\n");
      out.write("        <p>Doctor Last Name: <input type=\"text\" name=\"last\"></p>\n");
      out.write("        <p>Gender:\n");
      out.write("        <Select name=\"gender\">\n");
      out.write("            <option>male</option>\n");
      out.write("            <option>female</option>\n");
      out.write("        </Select>\n");
      out.write("        </p>\n");
      out.write("\n");
      out.write("        <h3>**Doctor Office Section**</h3>\n");
      out.write("        <p>Street Number: <input type=\"text\" name=\"stnum\"></p>\n");
      out.write("        <p>Street Name: <input type=\"text\" name=\"stname\"></p>\n");
      out.write("        <p>Street Type: <input type=\"text\" name=\"sttype\"></p>\n");
      out.write("        <p>Postal Code Prefix: <input type=\"text\" name=\"prefix\"></p>\n");
      out.write("        <p>Postal Code Suffix: <input type=\"text\" name=\"suffix\"></p>\n");
      out.write("        <p>City: <input type=\"text\" name=\"city\"></p>\n");
      out.write("        <p>Province: <input type=\"text\" name=\"province\"></p>\n");
      out.write("        <button type=\"submit\">Search</button>\n");
      out.write("      </form>\n");
      out.write("    </body>\n");
      out.write("</html>\n");
    } catch (Throwable t) {
      if (!(t instanceof SkipPageException)){
        out = _jspx_out;
        if (out != null && out.getBufferSize() != 0)
          out.clearBuffer();
        if (_jspx_page_context != null) _jspx_page_context.handlePageException(t);
        else throw new ServletException(t);
      }
    } finally {
      _jspxFactory.releasePageContext(_jspx_page_context);
    }
  }
}
