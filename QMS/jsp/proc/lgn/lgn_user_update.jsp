<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%@ include file="/jsp/inc/inc_common.jsp" %>
<%@ include file="/jsp/inc/inc_header.jsp" %>
<%
	String userId	="";
	String flag =request.getParameter("MNG_FLAG");
	Map<String,String> param=new HashMap<String,String>();
	if("Y".equals(flag)){
		userId =  request.getParameter("rd_update");
	}else{
		
		userId	=	userSession.getUserID();
	}
	param.put("USER_ID",userId);
	Map<String,String> listData	= null;
	listData=qmsDB.selectOne("QMS_LOGIN.USERINFO_R003",param);
%>
<script type="text/javascript">
function us_update(){
	var frm = document.frm;
	if($("#us_flag").val() == "Y"){
		if($("#now_password").val() == ''){
			alert("비밀번호를 입력하십시요.");
			return;
		}
	}else{
	if($("#bf_password").val() != $("#pass").val()){
		alert("비밀번호가 틀립니다.");
		return;
	}
	else if($("#now_password").val() == ''){
		alert("비밀번호를 입력하십시요.");
		return;
	}}
			
	frm.target			= '_self';
	frm.action			= "/QMS/jsp/proc/lgn/lgn_user_update_do.jsp";
	frm.submit();
}

</script>
<form name="frm" method="post">
<input type="hidden" name="pass" id="pass" value="<%=listData.get("USERPASSWORD")%>"/>
<input type="hidden" name="us_flag" id="us_flag" value="<%=flag%>"/>
<h3>사용자 정보 변경</h3>
<!-- 사용자 정보 변경 -->
<div class="wrap">
	<table>
	
		<colgroup>
			<col width="100px"/>
			<col width="100px"/>
			<col width="100px"/>
			<col width="100px"/>
			<col width="100px"/>
			<col width="100px"/>	
		</colgroup>
		<tbody>
		
			<tr>
				<th>사용자 ID</th>
					<td>
						<input type="text" id="us_id" name="us_id" style="width:100px" value="<%=userId%>" readonly />
					</td>						
				<th>사용자 명</th>
					<td>
						<input type="text" id="us_nm" name="us_nm" style="width:100px" value="<%=listData.get("USERNAME") %>" />
					</td>
			</tr>	
			<tr><%if("Y".equals(flag)){}else{ %>				
				<th>기존 PASSWORD</th>
				<td>
					<input type="password" id="bf_password" name="bf_password" style="width:100px"/>
				</td>
				<%} %>
				<th>변경 PASSWORD</th>
				<td>
					<%if("Y".equals(flag)){%>
					<input type="password" id="now_password" name="now_password" style="width:100px" value="<%=listData.get("USERPASSWORD") %>"/>
					<%}else{ %>
					<input type="password" id="now_password" name="now_password" style="width:100px"/>
					<%} %>
				</td>
			<%if("Y".equals(flag)){}else{ %>	
			</tr>
			<tr><%} %>
				<th>사용자 IP</th>
					<td>
						<input type="text" id="us_ip" name="us_ip" style="width:100px" value="<%=listData.get("USERIP") %>" />
					</td>				
			</tr>
			<tr>	
				<th>비고(참고사항)</th>
				<td colspan="3">
					<textarea id="us_bigo" name="us_bigo" cols="80" rows="10"style="width:500px; height:100px; overflow-y:hidden;" ><%=listData.get("BIGO") %></textarea>	
				</td>		
			</tr>	

	</tbody>				
	</table>
	</div>
	<br>
<div class="btnWrapR">
<a href="#FIT" class="btn" style="vertical-align: bottom" onclick="javascript:us_update();"><span>수정</span></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</div>
</form>				
<%@ include file="/jsp/inc/inc_bottom.jsp" %>