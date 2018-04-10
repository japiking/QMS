<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR" errorPage="/jsp/comm/error.jsp" %>

<%@ include file="/jsp/inc/inc_common.jsp" %>

<%
	try{
		session.invalidate();		
		
		out.println("<script type='text/javascript'>				");
		out.println("	location.href='/QMS/jsp/main.jsp';			");
		out.println("</script>										");
// 		response.sendRedirect(Const.URL_VIEW_LOGIN + "?return_url=" + request.getRequestURI());
		
	} catch(Exception e){
		e.printStackTrace(System.out);
	}

%>