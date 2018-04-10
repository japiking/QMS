<%@page import="qms.QmsProcessInit"%>
<%@page import="qms.util.PropertyUtil"%>
<%@page import="qms.util.LogUtil"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR" isErrorPage="true" %>

<!DOCTYPE html> 
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR" />
	<title>FIT-QMS시스템</title>
	
	<!-- lib -->
	<!-- <script src="/QMS/js/common/lib/cordova-ios.js"></script> -->
	<script src="/QMS/js/common/lib/jfm-1.0.0.js"></script>
	<script src="/QMS/js/common/lib/json2.js"></script>
	<script src="/QMS/js/common/lib/jquery-1.11.1.min.js"></script>
	
	<!-- jexPlugin -->
	<script src="/QMS/js/common/jex/jex.core.js"></script>
	<script src="/QMS/js/common/jexPlugin/jex.mobile.calendar.js"></script>
	<script src="/QMS/js/common/jexPlugin/jex.mobile.msg.js"></script>
	<script src="/QMS/js/common/jexPlugin/jex.mobile.secretform.js"></script>
	<script src="/QMS/js/common/jexPlugin/jex.mobile.tbl.js"></script>
	 
	<!-- common -->
	<script src="/QMS/js/common/swiper.js"></script>
	<script src="/QMS/js/common/guide.js"></script>
	<script src="/QMS/js/common/ibk_prototype.js"></script>
	<script src="/QMS/js/common/ibk.js"></script>
	<script src="/QMS/js/common/common.js"></script>
	<script src="/QMS/js/common/iscroll.js"></script>
<!-- 	<script src="/QMS/js/common/popupCalendar.js"></script> -->
	<script src="/QMS/js/common/publishing.js"></script>
	<script src="/QMS/js/common/comUtil.js"></script>
	<script src="/QMS/js/common/comStep.js"></script>
	<script src="/QMS/js/common/comStringUtil.js"></script>
	<script src="/QMS/js/common/comDateUtil.js"></script>
	<script src="/QMS/js/common/comFormatter.js"></script>
	<!-- <script src="/QMS/js/common/comLoading.js"></script> -->
	<script src="/QMS/js/common/comMobAcctMgr.js"></script>
	<script src="/QMS/js/common/comPopup.js"></script>
	<script src="/QMS/js/common/comValidation.js"></script>
	<script src="/QMS/js/common/front-ui.js"></script>
	
	<link rel="stylesheet" href="/QMS/css/guide.css" />
	<link rel="stylesheet" href="/QMS/css/guide_qms.css" /> 
	<link rel="stylesheet" href="/QMS/css/login.css" /> 
	<script src="/QMS/js/lgn/main.js"></script>
	<script language="javascript">

	$(document).ready(function(){
		
	var cw=screen.availWidth;     //화면 넓이
	var ch=screen.availHeight;    //화면 높이
	var today = new Date();  
	var userDate = "2015-05-01";
	var linkDate = "2015-05-09";
	
	var userDateArray = userDate.split("-");
	var linkDateArray = linkDate.split("-"); 
	
	var userDateObj = new Date(userDateArray[0], Number(userDateArray[1])-1, userDateArray[2]);
	var linkDateObj = new Date(linkDateArray[0], Number(linkDateArray[1])-1, linkDateArray[2]);

	//사용자 정보 팝업
	if(today.getTime()<userDateObj.getTime()){
		sw=1000;    //띄울 창의 넓이
		sh=500;    //띄울 창의 높이
		ml=(cw-sw)/2;        //가운데 띄우기위한 창의 x위치
		mt=(ch-sh)/2;         //가운데 띄우기위한 창의 y위치
		window.open('','popup1','width='+sw+',height='+sh+',top='+mt+',left='+ml+',resizable=no,scrollbars=yes');

		frm.target			= "popup1";
		frm.action			= "/QMS/jsp/view/lgn/qms_user.jsp";
		frm.submit();
	}
	
	//분석설계 사이트 팝업
	if(today.getTime()<linkDateObj.getTime()){
		sw=800;    //띄울 창의 넓이
		sh=700;    //띄울 창의 높이
		ml=(cw-sw)/2;        //가운데 띄우기위한 창의 x위치
		mt=(ch-sh)/2;         //가운데 띄우기위한 창의 y위치
		window.open('','popup2','width='+sw+',height='+sh+',top='+mt+',left='+ml+',resizable=no,scrollbars=yes');

		frm.target			= "popup2";
		frm.action			= "/QMS/jsp/view/lgn/qms_link.jsp";
		frm.submit();
	}
	
});
	
	
	</script>
</head>
<body>           
 	<div id="_LOADING_">
		<img alt="" src="" />
	</div>
 
<%
	String strUrl = request.getParameter("return_url");
/* 
try{
	QmsProcessInit aa = new QmsProcessInit();
	aa.init();
}catch(Exception e){
	e.printStackTrace(System.out);
}
 */
 %>
  <form name="frm" method="post">
  	<input type = "hidden" name = "returnUrl" value = "/QMS/jsp/main.jsp"/>
	 <div id="wrapper" class="login">
		<!-- header -->
		<div id="header">
			<h1><img src="/QMS/img/img_logo.png" alt="weQMS" /></h1>
		</div>

		<fieldset>
			<legend>로그인</legend>
			<div class="loginArea">
				<div class="loginBx">
					<p>
						<label for="id"><img src="/QMS/img/txt_id.png" alt="아이디" /></label>
						<input type="text" id="USER_ID" name="USER_ID" onkeyup = "if(event.keyCode==13) javascript_:uf_login()" />
					</p>
					<p>
						<label for="pw"><img src="/QMS/img/txt_pw.png" alt="비밀번호" /></label>
						<input type="password" id="USER_PASSWORD" name="USER_PASSWORD" onkeyup = "if(event.keyCode==13) javascript_:uf_login()" />
					</p>
					<a href="#none" id="login_btn">
						<img src="/QMS/img/btn_login.gif" alt="로그인" />
					</a>
				</div>
			</div>
		</fieldset>

		<!-- footer -->
		<div id="footer">
			<img src="/QMS/img/img_logo02.png" alt="WebcashFIT" />
			<p><img src="/QMS/img/txt_copy.png" alt="COPYRIGHT &copy; 2015 BY WEBCASHFIT RIGHT RESERVED." /></p>
		</div>
	</div>
<!-- //wrap -->

</form>
</body>
</html>