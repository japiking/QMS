<%
	out.println("	<tr>");
	out.println("		<td valign=\"top\">");
%>
<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%
String left_prjId = userSession.getProjectID();	// ������Ʈ ID

// ������Ʈ �޴�����
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
		<h2>�ý��� ������ �޴�</h2>
		<ul>
			<li><a href="#FIT" onclick="javascript:uf_link5();" >������Ʈ ��Ȳ</a></li>
			<li><a href="#FIT" onclick="javascript:uf_link1();" >������Ʈ ���</a></li>
			<li><a href="#FIT" onclick="javascript:uf_link3();" >������Ʈ ����</a></li>
			<li><a href="#FIT" onclick="javascript:uf_link2();" >����� ���</a></li>
			<!--�߰����� <li><a href="#FIT" onclick="javascript:uf_link6();" >����� ��������</a></li> -->
		</ul>
		

		
	<%}else {%>
	<%
		// ���� ������� ��� ���� �޴�
		if("00".equals(userSession.getAuthorityGrade())){	
	%>
		<h2>���� �޴�</h2>
		<ul>
			<li><a href="#FIT" onclick="javascript:uf_link4('adm_set_menu_view');" >�޴�����</a></li>
			<li><a href="#FIT" onclick="javascript:uf_link4('adm_set_user_auth_view');" >����ڰ���</a></li>
			<li><a href="#FIT" onclick="javascript:uf_link2();" >����� ���</a></li>
			<!--�߰����� <li><a href="#FIT" onclick="javascript:uf_link6();" >����� ��������</a></li> -->
		</ul>
	<%
		}// end if
	%>
		
	<%
		// �޴������ �׸���.
		if(null != menu_list && !menu_list.isEmpty()){
	%>
			<h2>����� �޴�</h2>	
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
		<!-- <h2>QUALITY CONTROL �޴�</h2>
		<ul>
			
					<%if("00".equals(userSession.getAuthorityGrade())){%> 
					<li><a href="#FIT" onclick="javascript:uf_link6('qcl_test_mng_view');">�׽�Ʈ����</a></li>
					<li><a href="#FIT" onclick="javascript:uf_link6('qcl_test_list.view');">�׽�Ʈ ������</a></li>
				<%}else if("02".equals(userSession.getAuthorityGrade())){%>
					<li><a href="#FIT" onclick="javascript:uf_link6('qcl_test_list.view');">�׽�Ʈ ������</a></li>
				<%} %>
					<li><a href="#FIT" onclick="javascript:uf_link6('qcl_test_execute_view');">�׽�Ʈ �������</a></li>
					<li><a href="#FIT" onclick="javascript:uf_link6('qcl_defect_mng_view');">���԰���</a></li>
		</ul>
		 -->
		</div>
			<%} %>
	</div>
	<%
		out.println("		</td>");	//�޴���
		out.println("	<td style=\"text-align:left\"><!--������ ��������-->");
	%>
		<script>
		var menufrm;
		$(document).ready(function(){
			menufrm = document.FormLeftMenu;
		});
			// ������Ʈ ���
			function uf_link5() {
				menufrm.target = "_self";
				menufrm.action = "/QMS/jsp/view/index.jsp";
				menufrm.submit();
			}
		
			// ������Ʈ ���
			function uf_link1() {
				menufrm.target = "_self";
				menufrm.action = "/QMS/jsp/view/mng/mng_projectReg_view.jsp";
				menufrm.submit();
			}
			
			// ����� ���
			function uf_link2() {
				menufrm.target = "_self";
				menufrm.action = "/QMS/jsp/view/mng/mng_projectUserReg_view.jsp";
				menufrm.submit();
			}
			
			// ������Ʈ ����
			function uf_link3() {
				menufrm.target = "_self";
				menufrm.action = "/QMS/jsp/view/mng/mng_projectMng_view.jsp";
				menufrm.submit();
			}
			
			//�Ŵ���|������-ȸ������ ����
			function uf_link6(){
				menufrm.target = "_self";
				menufrm.action = "/QMS/jsp/view/";
				menufrm.submit();
			}
			// �޴���ũ
			function uf_link0(param, param2, param3) {
				var pkg = param.substring(0,param.indexOf("_")); 
				menufrm.BOARD_ID.value	= param2;
				menufrm.BOARD_TYPE.value	= param3;
		   		menufrm.target = "_self";
		   		menufrm.action = "/QMS/jsp/view/"+pkg+"/"+param+".jsp";
		   		menufrm.submit();
			}
			 
			//admin �޴���ũ 
			function uf_link4(param){
				menufrm.target = "_self";
				menufrm.action = "/QMS/jsp/view/adm/"+param+".jsp";
				menufrm.submit();
			}
		
			//QC�޴���ũ
			function uf_link6(param){
				menufrm.target = "_self";
				menufrm.action = "/QMS/jsp/view/qcl/"+param+".jsp";
				menufrm.submit();
			}
			
		</script>
