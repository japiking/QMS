<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>

<%@ include file="/jsp/inc/inc_common.jsp"%>
<%@ include file="/jsp/inc/inc_header.jsp"%>
<%
String strProjectId = StringUtil.null2void(userSession.getProjectID());
String search = StringUtil.null2void(request.getParameter("idSearch"));
List<Map<String,String>> statsListMap = null;
List<Map<String,String>> userList = new ArrayList<Map<String,String>>();
try{
	Map<String,String> param = new HashMap<String,String>();
	param.put("PROJECTID",	strProjectId);
	param.put("USERID", 	search);
	statsListMap = qmsDB.selectList("QMS_ADMIN.AUTHORITY_R001", param);	// �������
	
	userList	= qmsDB.selectList("QMS_ADMIN.USERINFO_R002",param);	// ���� ������Ʈ�� ���Ե��� �ʴ� ����� �˻�
}catch(Exception e){
	e.printStackTrace(System.out);
	if (qmsDB != null){
        try { qmsDB.close(); } catch (Exception e1) {}
	}
}finally{
	if (qmsDB != null){
        try { qmsDB.close(); } catch (Exception e1) {}
	}
}


// ������� html
StringBuffer gradeHTML = new StringBuffer();
gradeHTML.append("<select name='authval' id='authval'>						");

for(int j = 0; j<statsListMap.size(); j++){ 
	String AuthGrade = statsListMap.get(j).get("AUTHORITYGRADE");
	String AuthName = statsListMap.get(j).get("AUTH_NAME");
	gradeHTML.append("<option value='"+AuthGrade+"'>"+AuthName+"</option>	");
}
gradeHTML.append("</select>													");

%>
<script type="text/javascript">


$(document).ready(function() {
	$("form[name=frm2]").hide();

	//����� ��ȸ
	$("#btn_inqry").click(function(){
		var frm				= document.frm;
				
		frm.target			= "_self";
		frm.action			= "/QMS/jsp/view/adm/adm_userSearch_popup_view.jsp";
		frm.submit();
	});	
	
	// ����� ����
	$("#aSelect").click(function(){
		var useridlist = "";
		var userGrade  = "";
		var cnt = 0;
		$("#tbody_content tr").each(function() { 
	        if( $("input:checkbox", this).is(":checked")) {
	        	cnt++;
	        	useridlist += $(this).find("#userid").text() +",";
	        	userGrade  += $(this).find("#authval").val() +",";
	        }
	    });
		if(cnt == 0){
			alert("�߰��ϰ� ���� ����ڸ� �����Ͻʽÿ�.");
			return false;
		}
		
		useridlist = useridlist.substring(0, useridlist.length -1);
		userGrade  = userGrade.substring(0, userGrade.length -1);
		
		
		var frm				= document.frm;
		frm.USERID.value			= useridlist;
		frm.AUTHORITYGRADE.value	= userGrade;		
		frm.target			= "_self";
		frm.action= "/QMS/jsp/proc/adm/adm_user_insert_do.jsp";
		frm.submit();
	});	
	
	
	//����� ���
	$("#INSERT_USER").click(function(){
		var ajax = jex.createAjaxUtil("UserInfoReg_do");	// ȣ���� ������
 		// �����         		
 		ajax.set("TASK_PACKAGE",    "mng" );	 						// [�ʼ�]���� package ȣ���� ������ ��Ű
 		// ������
 		ajax.set("USER_ID",    	$("#USER_ID").val());
 		ajax.set("USERNAME",   $("#USER_NAME").val());
 		ajax.set("USERPASSWORD", $("#USER_PASSWD").val());
 		ajax.set("USER_IP",   	$("#USER_IP").val());
 		ajax.set("BIGO",   		$("#BIGO").val());
 		ajax.set("PAGE_FALG",   "1");
 		ajax.execute(function(dat) {
 	       	alert(dat[0].msg);
			$("form[name=frm2]").hide();
			$("form[name=frm] #idSearch").val(form_data2.USER_ID);
			$("form[name=frm] #btn_inqry").click();
 		});
	});
	$("#allCheck").on("click",function(){
		if (this.checked) {
			$(".inputChoice").prop("checked", true);
		} else {
			$(".inputChoice").prop("checked", false);
		}
	});
	
});
//����� ��ȸ


function uf_insertUser(){
	var frm						= document.frm;
	frm.USERID.value			= $("#userid").text();
	frm.AUTHORITYGRADE.value	= $("#authval").val();
	frm.target					= "_self";
	frm.action= "/QMS/jsp/proc/adm/adm_user_insert_do.jsp";
	frm.submit();
}
/**
* QMS ȸ������ó�� 
**/
function uf_regUser() {
	var frm2 = document.frm2; 
	if(frm2.USER_ID.value == "") {
		alert("ID�� �ʼ� �Է»����Դϴ�.");
		return;
	}
	if(frm2.USER_NAME.value == "") {
		alert("�̸��� �ʼ� �Է»����Դϴ�.");
		return;
	}
	if(frm2.USER_PASSWD.value == "") {
		alert("��й�ȣ�� �ʼ� �Է»����Դϴ�.");
		return;
	}
	frm2.target			= 'HiddenFrame';
	frm2.action			= "/QMS/jsp/proc/mng/mng_UserInfoReg_do.jsp";
	frm2.submit();

}	
// ID�ߺ� üũ
function uf_idCheck(){
	var frm2 = document.frm2; 
	var id = $("#USER_ID").val();
	if(id != null) id = $.trim(id);
	
	if(id == ""){
		alert("ID�� �Է��ϼ���.");
		return false;
	}
	frm2.target			= 'HiddenFrame';
	frm2.action			= "/QMS/jsp/proc/mng/mng_UserIdCheck_do.jsp";
	frm2.submit();
}
</script>
<form name="frm" method="post">
<input type="hidden" name="projectId" value="<%=strProjectId%>"/>
<input type="hidden" name="USERID"/>
<input type="hidden" name="AUTHORITYGRADE"/>
<div class="wrap">
	<div class="btnWrapl">
		<input type="text" id="idSearch" name="idSearch" placeholder="����� �˻�" value="<%=search%>" />
		<a href="#FIT" class="btn" id="btn_inqry"><span>�˻�</span></a>
	</div>
	<div><span id="message"></span> </div>
	<div id="grup">
		<div id="checkuser">
			<table>
				<colgroup>
					<col width="10%"/>
					<col width="30%"/>
					<col width="30%"/>
					<col width="*%"/>
				</colgroup>		
				<thead>
					<th scope="row"><input type="checkbox" name="checkBox" id="allCheck" /></th>
					<th scope="row">���̵�</th>
					<th scope="row">�̸�</th>
					<th scope="row">�����_����</th>
				</thead>
				<tbody id="tbody_content">
				<%
				if(null != userList && userList.size() != 0){
					String userid = "";
					String username = "";
					for(int i=0; i<userList.size(); i++){
						Map<String,String> map = userList.get(i);
						userid 		= StringUtil.null2void(map.get("USERID"));
						username 	= StringUtil.null2void(map.get("USERNAME"));
				%>
					<tr>
						<td  class="alC"><input type="checkbox" name="check" class="inputChoice"/></td>
						<td  class="alC"><span id="userid"><%=userid %></span></td>
						<td  class="alC"><span id="username"><%=username %></span></td>
						<td  class="alC">
							<%=gradeHTML.toString() %>
						</td>
					</tr>
				<% 
					}
				} else {
				%>
					<tr>
						<td  class="alC" colspan="4">��ȸ ����ڰ� �����ϴ�.</td>
					</tr>
				<%
				}
				%>
				</tbody>
			</table>
		</div>	
		<div class="btnWrapC" id="btn_area">
			<a href="#FIT" class="btn" id="aSelect"><span>����</span></a>
			<a href="#FIT" class="btn" onclick="javascript:window.close();"><span>���</span></a>
		</div>
	</div>
</div>

</form>
<form name="frm2" id="frm2" method="post">
<input type="hidden" name="PAGE_FALG" value="1">
<div class="wrap">
	<h3>����� ���</h3>
	<table>
		<colgroup>
			<col width="130px"/>
			<col width="400px"/>
			<col width="130px"/>
			<col width="*"/>
		</colgroup>
		<tbody>
			<tr>				
				<th>�����ID</th>
				<td>
					<input type="text" name="USER_ID" id="USER_ID" style="width:140px"/>
					<a href="#" class="btn" onclick="javascript:uf_idCheck();"><span>�ߺ�üũ</span></a>
				</td>			
				<th>����ڸ�</th>
				<td>
					<input type="text" name="USER_NAME" id="USER_NAME" style="width: 200px" />
					</td>
			</tr>
			<tr>				
				<th>����ں�й�ȣ</th>
				<td>
					<input type="password" name="USER_PASSWD" id="USER_PASSWD" style="width:200px"/>		
				</td>
				<th>�����IP</th>
				<td>
					<input type="text" name="USER_IP" id="USER_IP" style="width:200px"/>		
				</td>
			</tr>
			<tr>				
				<th>���(�������)</th>
				<td colspan="3">
					<textarea id="BIGO" name="BIGO" id="BIGO" cols="50" rows="4"></textarea>	
				</td>		
			</tr>		
		</tbody>
	</table>


	<div class="btnWrapR">
		<a href="#FIT" class="btn" id="INSERT_USER" onclick="uf_regUser()"><span>���</span></a>
	</div>

</div>
<!-- //wrap -->
</form>
<IFRAME SRC="" frameborder="0" id="HiddenFrame" name="HiddenFrame" width="0" height="0" marginwidth="0" marginheight="0" scrolling="no" allowtransparency="true"></IFRAME>