<%@ page language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%@ page errorPage="/jsp/comm/error.jsp" %>

<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>

<%@ page import="qms.session.UserSession"%>
<%@ page import="qms.util.StringUtil"%>
<%@ page import="qms.util.ComboUtil"%>
<%@ page import="qms.Const"%>
<%@ page import="qms.util.DateTime"%>
<%@page import="qms.util.DataMap"%>
<%@page import="qms.exception.*"%>
<%@page import="qms.util.LogUtil"%>
<%@ page import="qms.util.DBSeqUtil"%>
<%@ page import="qms.util.AppConst"%>
<%@ page import="qms.util.BizUtil"%>
<%@ page import="qms.util.ComboUtil"%>
<%@ page import="qms.util.JacksonJsonToMap"%>
<%@ page import="qms.util.MapToJacksonJson"%>
<%@ page import="qms.db.DBSessionManager"%>
<%@ page import="qms.spbiz.SpbBiz"%>
<%
	request.setCharacterEncoding("euc-kr");
	
	UserSession userSession	= (UserSession) session.getAttribute(Const.QMS_SESSION_ID);
	if( userSession!= null){
		request.setAttribute(Const.QMS_SESSION_ID, userSession);
	}
	LogUtil.getInstance().debug("로그인 서비스:=====>>["+StringUtil.isService(request)+"]");	
	LogUtil.getInstance().debug("return URL:=====>>["+request.getParameter("return_url")+"]");
	
	if( !StringUtil.isService(request) ) {
		
		response.sendRedirect(Const.URL_VIEW_LOGIN + "?return_url=" + request.getRequestURI());
	}
	
%>
