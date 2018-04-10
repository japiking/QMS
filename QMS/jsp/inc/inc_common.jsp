<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>

<%@ page errorPage="/jsp/comm/error.jsp" %>

<%@page import="qms.db.DBSessionManager"%>
<%@ page import="qms.session.UserSession"%>
<%-- <%@ page import="qms.db.QueryHelper"%> --%>
<%@ page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="qms.util.StringUtil"%>
<%@ page import="qms.util.ComboUtil"%>
<%@ page import="qms.Const"%>
<%@ page import="qms.util.DateTime"%>
<%@ page import="qms.util.DBSeqUtil"%>
<%@ page import="qms.util.BizUtil"%>
<%@ page import="qms.util.PropertyUtil"%>
<%@ page import="qms.util.LogUtil"%>
<%
	request.setCharacterEncoding("euc-kr");
	
	UserSession userSession	= (UserSession) session.getAttribute(Const.QMS_SESSION_ID);

	LogUtil.getInstance().debug("로그인 서비스:=====>>["+StringUtil.isService(request)+"]");	
	LogUtil.getInstance().debug("return URL:=====>>["+request.getParameter("return_url")+"]");
	
	if( !StringUtil.isService(request) ) {
		
		response.sendRedirect(Const.URL_VIEW_LOGIN + "?return_url=" + request.getRequestURI());
	}
	DBSessionManager qmsDB = new DBSessionManager();
%>