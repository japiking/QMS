<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR" isErrorPage="true" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR" />
	<title>working list</title>
	<script src="/QMS/js/jquery-1.7.1.min.js"></script>
	<script src="/QMS/js/guide.js"></script>
	<script src="/QMS/js/common.js"></script>
	<link rel="stylesheet" href="/QMS/css/guide.css" />
	<link rel="stylesheet" href="/QMS/css/guide_qms.css" />
	<script type="text/javascript"></script>
</head>
<body>

		<p />
		<p />
		<div class="btnWrapL">
<%		if( userSession == null ) { %>
<!-- 			<a href="<%=Const.URL_VIEW_LOGIN%>" class="btn" target="webGuide"><span>로그인</span></a>  -->
<%		} else { %>
<!-- 			<%=userSession.getUserNm()%>님  반갑습니다. <a href="<%=Const.URL_PROC_LOGOUT%>" class="btn" target="webGuide"><span>로그아웃</span></a>  -->
<%		} %>
		</div>
		<p />
		<p />
