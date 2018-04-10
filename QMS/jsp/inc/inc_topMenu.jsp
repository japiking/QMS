
<%
	out.println("<table cellspacing=\"0\" cellpadding=\"0\" style=\"width:100%;\">");
	out.println("	<colgroup>");
	out.println("			<col width=\"15%\"/>");
	out.println("		<col width=\"*\"/>");
	//out.println("		<col width=\"*\"/>");
	out.println("	</colgroup>");
	out.println("	<tbody>");
	out.println("		<tr>");
	out.println("			<td colspan=\"2\">");
%>
<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<table class="noline">
	<colgroup>
		<col width="15%" />
		<col width="*" />
		<col width="18%" />
	</colgroup>
	<tbody>
		<tr>
			<%if("0".equals(userSession.getManagementGrade())){%> 
				<td><img src="/QMS/img/img_logo.png" /></td>
			<%}else{%>
				<td><a href="#FIT" onclick="location.href='/QMS/jsp/view/bbs/bbs_index.jsp'; return false;"><img src="/QMS/img/img_logo.png" /></a></td>
			<%}%>
			<td><b style="font-size: 30px"><%=StringUtil.null2void(userSession.getProjectName())%></b></td>
			<td style="text-align: right"><b><%=userSession.getUserName()%>(<%=StringUtil.null2void(userSession.getUserID())%>)</b>님환영합니다.<br> 
				<a href="#FIT" class="btn" onclick="javascript:uf_LogOut();"><span>로그아웃</span></a>
				<a href="#FIT" class="btn" onclick="javascript:uf_infoUpdate();"><span>개인정보수정</span></a>
			</td>
		</tr>
	</tbody>
</table>
<%
	// 	out.println("</td>");
	// 	out.println("		</tr>");
%>
<script type="text/javascript">
	function uf_LogOut() {
		menufrm.target = "_self";
		menufrm.action = "/QMS/jsp/proc/lgn/lgn_logout_do.jsp";
		menufrm.submit();
	}

	function uf_infoUpdate() { //추가중
		var wid	  			= 800;
		var hei   			= 500;
		var LeftPosition	= (screen.width)  ? (screen.width-wid) /2 : 0;
		var TopPosition		= (screen.height) ? (screen.height-hei)/2 : 0;
		var setting  		= 'scrollbars=no,toolbar=yes,resizable=no,width='+wid+',height='+hei+',left='+LeftPosition+',top='+TopPosition;
		window.open('', '_popup', setting);

		menufrm.target = "_popup";
		menufrm.action = "/QMS/jsp/proc/lgn/lgn_user_update.jsp";
		menufrm.submit();
	}
</script>