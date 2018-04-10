<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>

<%@ page errorPage="/jsp/comm/error.jsp" %>
<%@page import="qms.util.LogUtil"%>
<%@ page import="qms.session.UserSession"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="qms.util.StringUtil"%>
<%@ page import="qms.util.ComboUtil"%>
<%@ page import="qms.Const"%>

<%
	UserSession userSession	= (UserSession) session.getAttribute(Const.QMS_SESSION_ID);

	LogUtil.getInstance().debug("로그인 서비스 (POP_UP) ======>"+StringUtil.isService(request));
	if( !StringUtil.isService(request) ) {
		out.println("<script type='text/javascript'>");
		out.println("alert('로그아웃 되었습니다. 다시 로그인 하세요.');");
		out.println("window.close();");
		out.println("</script>");
	}
	request.setCharacterEncoding("euc-kr");
%>