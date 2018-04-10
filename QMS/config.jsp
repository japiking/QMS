<%@ page import="java.util.*"%>
<%@ page contentType="text/html;charset=euc-kr" %>

<%
String name				= null;
String value			= null;
String reqName			= null;
String className		= null;
java.net.URL classUrl	= null;

reqName = request.getParameter("reqName");

if (reqName == null || reqName.trim().length() == 0) {
	reqName 	= "";
} else {
	if (!reqName.startsWith("/"))	reqName = "/" + reqName;
	if (reqName.endsWith(".class"))	reqName = reqName.substring(0, reqName.indexOf(".class"));
	
	className	= reqName;
	
	reqName		= replaceAll(reqName, ".", "/");
	className	= replaceAll(reqName, "/", ".");
	
	if (className.startsWith("."))	className = className.substring(1);
	
	reqName		= reqName+".class";
}

%>

<html>
<body onLoad="document.form1.reqButton.focus();">
<br><hr align=center><br>
[Search] (ex) /java/util/Vector.class
<form action="config.jsp" name=form1>
<input type=text name="reqName" value="<%= reqName %>" size='60'>
<input type=submit name=reqButton value="0K" >
</form>

<%
if (reqName.trim().length() != 0) {
%>

[Search Result]
<br>
<%
	classUrl = this.getClass().getResource(reqName);
	//this.getClass().getClassLoader();
	if (classUrl == null) {
		out.println(reqName + " not found");
	} else {
		out.println("<b>" + reqName + "</b>: [" + classUrl.getFile() + "]\n");
	}
	out.println("<br>");
	out.println("ClassLoader :[<b>"+ Class.forName(className).getClassLoader().getClass().getName() +"</b>]");
	out.println("<br>");
	
}
%>

<br><hr align=center><br>
[Property List]
<br>
<%
	Properties prop	= System.getProperties();
	Enumeration e1	= prop.propertyNames();
	while (e1.hasMoreElements()) {
		name	= (String) e1.nextElement();
		value	= (String) prop.get(name);
		out.println("<b>" + name + "</b>: " + value);
		out.println("<br>");
	}
%>

<%!
	public static String replaceAll(String str, String src, String des) throws Exception {
		StringBuffer sb = new StringBuffer(str.length());
		int startIdx	= 0;
		int oldIdx		= 0;
		while (true) {
			startIdx = str.indexOf(src, startIdx);
			if (startIdx == -1) {
				sb.append(str.substring(oldIdx));
				break;
			}

			sb.append(str.substring(oldIdx, startIdx));
			sb.append(des);

			startIdx += src.length();
			oldIdx = startIdx;
		}

		return sb.toString();
	}
%>

