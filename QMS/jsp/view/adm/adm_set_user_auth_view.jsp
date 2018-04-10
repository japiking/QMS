<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
    
<%@ include file="/jsp/inc/inc_common.jsp" %>
<%@ include file="/jsp/inc/inc_header.jsp" %>
<%
String strProjectId = StringUtil.null2void(userSession.getProjectID());
String strUSerId 	= StringUtil.null2void(userSession.getUserID());

List<Map<String,String>> statsListMap = null;
List<Map<String,String>> statsListMap2= null;
try{
	Map<String,String> param = new HashMap<String,String>();
	
	param.put("PROJECTID",strProjectId);
	param.put("USERID",strUSerId);
	
	statsListMap = qmsDB.selectList("QMS_ADMIN.PROJECTUSERINFO_R001", param);
	
	statsListMap2	= qmsDB.selectList("QMS_ADMIN.AUTHORITY_R001");
	
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


%>

<script type="text/javascript">

function delrow(obj){
	$(obj).parent().parent().remove();
}

function searchuser(){
	var cw=screen.availWidth;     //화면 넓이
	var ch=screen.availHeight;    //화면 높이
	
	sw=800;    //띄울 창의 넓이
	sh=400;    //띄울 창의 높이
	ml=(cw-sw)/2;        //가운데 띄우기위한 창의 x위치
	mt=(ch-sh)/2;         //가운데 띄우기위한 창의 y위치
	window.open('','popup','width='+sw+',height='+sh+',top='+mt+',left='+ml+',resizable=no,scrollbars=yes');
	//window.open('','popup','toolbar=0,resizable=no,location=0,directories=0,status=0,titlebar=0,menubar=0,width='+sw+',height='+sh+',top='+mt+',left='+ml);


	frm.target			= "popup";
	frm.action			= "/QMS/jsp/view/adm/adm_userSearch_popup_view.jsp";
	frm.submit();
}

function uf_submit(){
	
rowCount = $('#AddOption tr').length;
	for(var i = 0; i<rowCount; i++){
		
		$("#AddOption tr:eq('"+i+"')").attr('id',"tr"+i);
		$("#AddOption tr:eq('"+i+"') input[name^=userid]").attr("name","userid"+i);
		$("#AddOption tr:eq('"+i+"') input[name^=username]").attr("name","username"+i);
		$("#AddOption tr:eq('"+i+"') select[name^=authval]").attr("name","authval"+i);
	}
	
	var frm				= document.frm;
	frm.count.value		= rowCount;
	frm.target			= "_self";
	frm.action= "/QMS/jsp/proc/adm/adm_set_user_auth_do.jsp";
	frm.submit(); 
}


function uf_deleteUser(userID){
	if(confirm("삭제하시겠습니까?")){
		var frm						= document.frm;
		frm.deleteUserID.value		= userID;
		frm.target					= "_self";
		frm.action= "/QMS/jsp/proc/adm/adm_user_delete_do.jsp";
		frm.submit();
	}
}

</script>


<%@ include file="/jsp/inc/inc_topMenu.jsp" %>
<%@ include file="/jsp/inc/inc_leftMenu.jsp" %>
<form name="frm" method="post">
<input  type="hidden" name="count" />
<input  type="hidden" name="PROJECTID" value="<%=strProjectId%>"/>
	<div style="width: 100%;">
<!-- 	<span>사용자등급설정</span> -->
	<button style="float: right;" id="btn" onclick="searchuser(); return false;">사용자 추가</button>
	<br/><br/>
		<div>
			<table id="authlist" border="1">
				<colgroup>
					<col>
					<col>
					<col>
					<col>
				</colgroup>
				<thead>
					<tr>
						<th>순번</th>
						<th>사용자ID</th>
						<th>사용자명</th>
						<th>사용자_선택</th>
						<th>삭제</th>
					</tr>
				</thead>
				<tbody id="AddOption">
					<%for(int i = 0; i< statsListMap.size(); i++){%>
					<tr>
						<td><%=i+1%></td>
						<td><span><%=statsListMap.get(i).get("USERID")%></span><input type="hidden" name="userid" value="<%=statsListMap.get(i).get("USERID")%>" /></td>
						<td><span><%=statsListMap.get(i).get("USERNAME")%></span><input type="hidden" name="username" value="<%=statsListMap.get(i).get("USERID")%>" /></td>
						<td>
							<select name="authval<%=i%>">
								<%for(int j = 0; j<statsListMap2.size(); j++){ 
									String AuthGrade = statsListMap2.get(j).get("AUTHORITYGRADE");
									String AuthName = statsListMap2.get(j).get("AUTH_NAME");
								%>			
									<option value="<%=AuthGrade%>" <%=statsListMap.get(i).get("AUTHORITYGRADE").trim().equals(AuthGrade.trim()) ? "selected=selected":""%>><%=AuthName%></option>
								<%}%>
							</select>
						</td>
						<td>
							<button onclick="javascript:uf_deleteUser('<%=statsListMap.get(i).get("USERID") %>'); return false;">삭제</button>
						</td>
					</tr>
				<%}//for %>
				</tbody>
			</table>
		</div>
		<br/>
		<div style="float: left;">
			<button onclick="uf_submit();return false;">저장</button>
			<button onclick="">취소</button>
		</div>
	</div>
<input type="hidden" name="deleteUserID">
</form>

<%@ include file="/jsp/inc/inc_bottom.jsp" %>
