<%
	out.println("	<tr>");
	out.println("		<td valign=\"top\">");
%>
<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%
String left_prjId = userSession.getProjectID();	// 프로젝트 ID

// 프로젝트 메뉴정보
StringBuffer left_sql = new StringBuffer();
List<Map<String,String>> menu_list	= (List<Map<String,String>>)session.getAttribute(Const.QMS_SESSION_MENU);

%>
<form name="FormLeftMenu" method="post">
<input type="hidden" name="PROJECT_ID" value="<%=left_prjId %>" />
<input type="hidden" id="left_brdId" name="BOARD_ID" />
<input type="hidden" id="BOARD_TYPE" name="BOARD_TYPE" />
</form>
<div class="guideLnb">
	<div class="lnb">
	<% if("0".equals(userSession.getManagementGrade())) { %>
		<h2>시스템 관리자 메뉴</h2>
		<ul>
			<li><a href="#FIT" onclick="javascript:uf_link5();" >프로젝트 현황</a></li>
			<li><a href="#FIT" onclick="javascript:uf_link1();" >프로젝트 등록</a></li>
			<li><a href="#FIT" onclick="javascript:uf_link3();" >프로젝트 관리</a></li>
			<li><a href="#FIT" onclick="javascript:uf_link2();" >사용자 등록</a></li>
			<!--추가예정 <li><a href="#FIT" onclick="javascript:uf_link6();" >사용자 정보수정</a></li> -->
		</ul>
		

		
	<%}else {%>
	<%
		// 어드민 사용자일 경우 보일 메뉴
		if("00".equals(userSession.getAuthorityGrade())){	
	%>
		<h2>어드민 메뉴</h2>
		<ul>
			<li><a href="#FIT" onclick="javascript:uf_link4('adm_set_menu_view');" >메뉴설정</a></li>
			<li><a href="#FIT" onclick="javascript:uf_link4('adm_set_user_auth_view');" >사용자관리</a></li>
			<li><a href="#FIT" onclick="javascript:uf_link2();" >사용자 등록</a></li>
			<!--추가예정 <li><a href="#FIT" onclick="javascript:uf_link6();" >사용자 정보수정</a></li> -->
		</ul>
	<%
		}// end if
	%>
		
	<%
		// 메뉴목록을 그린다.
		if(null != menu_list && !menu_list.isEmpty()){
	%>
			<h2>사용자 메뉴</h2>	
			<ul>
	<%				
			Map<String,String> menuMap	= null;
			String bbs_type_id = "";
			String bbs_type_nm = "";
			for(int i=0; i<menu_list.size(); i++){
				menuMap	= menu_list.get(i);
				bbs_type_id 	= StringUtil.null2void(menuMap.get("MENU_TYPE_ID"));
				
	%>
			<li><a href="#FIT" id="<%=menuMap.get("BOARD_ID") %>" onclick="javascript:uf_link0('<%=menuMap.get("MENU_VIEW") %>','<%=menuMap.get("BOARD_ID") %>','<%=bbs_type_id %>');" ><%=menuMap.get("KOR_MENU_NAME") %></a></li>
	<%
			}// end for
		}// end if
	%>
		</ul>
	<%
	}// end else
	%>
			
			<%if(!"0".equals(userSession.getManagementGrade())){%>
		<!-- <h2>QUALITY CONTROL 메뉴</h2>
		<ul>
			
					<%if("00".equals(userSession.getAuthorityGrade())){%> 
					<li><a href="#FIT" onclick="javascript:uf_link6('qcl_test_mng_view');">테스트관리</a></li>
					<li><a href="#FIT" onclick="javascript:uf_link6('qcl_test_list.view');">테스트 실행등록</a></li>
				<%}else if("02".equals(userSession.getAuthorityGrade())){%>
					<li><a href="#FIT" onclick="javascript:uf_link6('qcl_test_list.view');">테스트 실행등록</a></li>
				<%} %>
					<li><a href="#FIT" onclick="javascript:uf_link6('qcl_test_execute_view');">테스트 실행관리</a></li>
					<li><a href="#FIT" onclick="javascript:uf_link6('qcl_defect_mng_view');">결함관리</a></li>
		</ul>
		 -->
		</div>
			<%} %>
	</div>
	<%
		out.println("		</td>");	//메뉴끝
		out.println("	<td style=\"text-align:left\"><!--컨텐츠 영역시작-->");
	%>
		<script>
		var menufrm;
		$(document).ready(function(){
			menufrm = document.FormLeftMenu;
		});
			// 프로젝트 등록
			function uf_link5() {
				menufrm.target = "_self";
				menufrm.action = "/QMS/jsp/view/index.jsp";
				menufrm.submit();
			}
		
			// 프로젝트 등록
			function uf_link1() {
				menufrm.target = "_self";
				menufrm.action = "/QMS/jsp/view/mng/mng_projectReg_view.jsp";
				menufrm.submit();
			}
			
			// 사용자 등록
			function uf_link2() {
				menufrm.target = "_self";
				menufrm.action = "/QMS/jsp/view/mng/mng_projectUserReg_view.jsp";
				menufrm.submit();
			}
			
			// 프로젝트 관리
			function uf_link3() {
				menufrm.target = "_self";
				menufrm.action = "/QMS/jsp/view/mng/mng_projectMng_view.jsp";
				menufrm.submit();
			}
			
			//매니저|관리자-회원정보 수정
			function uf_link6(){
				menufrm.target = "_self";
				menufrm.action = "/QMS/jsp/view/";
				menufrm.submit();
			}
			// 메뉴링크
			function uf_link0(param, param2, param3) {
				var pkg = param.substring(0,param.indexOf("_")); 
				menufrm.BOARD_ID.value	= param2;
				menufrm.BOARD_TYPE.value	= param3;
		   		menufrm.target = "_self";
		   		menufrm.action = "/QMS/jsp/view/"+pkg+"/"+param+".jsp";
		   		menufrm.submit();
			}
			 
			//admin 메뉴링크 
			function uf_link4(param){
				menufrm.target = "_self";
				menufrm.action = "/QMS/jsp/view/adm/"+param+".jsp";
				menufrm.submit();
			}
		
			//QC메뉴링크
			function uf_link6(param){
				menufrm.target = "_self";
				menufrm.action = "/QMS/jsp/view/qcl/"+param+".jsp";
				menufrm.submit();
			}
			
		</script>
