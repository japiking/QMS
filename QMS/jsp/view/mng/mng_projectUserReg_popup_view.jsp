<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>    
<%@ include file="/jsp/inc/inc_common.jsp" %>
<%@ include file="/jsp/inc/inc_header.jsp" %>

<script type="text/javascript">
	var check_yn;
	$(document).ready(function(){
		check_yn = "N";
   });
	/**
	* QMS 회원가입처리 
	**/
	function uf_regedit() {
		if(frm.USER_ID.value == "") {
			alert("ID는 필수 입력사항입니다.");
			return;
		}
		if(frm.USER_NAME.value == "") {
			alert("이름은 필수 입력사항입니다.");
			return;
		}
		if(frm.USER_PASSWD.value == "") {
			alert("비밀번호는 필수 입력사항입니다.");
			return;
		}
		
		if("N" == check_yn){
			alert("ID 중복체크는 필수입니다.");
			return;
		}
		/* 
		if(frm.USER_IP.value == "") {
			alert("사용자 IP는 필수 입력사항입니다.");
			return;
		}
		*/
		frm.target			= '_self';
		frm.action			= "/QMS/jsp/proc/mng/mng_UserInfoReg_do.jsp";
		frm.submit();

	}	
	// ID중복 체크
	function uf_idCheck(){
		var id = $("#USER_ID").val();
		if(id != null) id = $.trim(id);
		
		if(id == ""){
			alert("ID를 입력하세요.");
			return false;
		}
		
		frm.target			= 'HiddenFrame';
		frm.action			= "/QMS/jsp/proc/mng/mng_UserIdCheck_do.jsp";
		frm.submit();
	}
</script> 
  

<form name="frm" method="post">
<div class="wrap">
	<h3>사용자 등록</h3>
	<table>
		<colgroup>
			<col width="130px"/>
			<col width="400px"/>
			<col width="130px"/>
			<col width="*"/>
		</colgroup>
		<tbody>
			<tr>				
				<th>사용자ID</th>
				<td>
					<input type="text" name="USER_ID" id="USER_ID" style="width:140px"/>
					<a href="#" class="btn" onclick="javascript:uf_idCheck();"><span>중복체크</span></a>
				</td>			
				<th>사용자명</th>
				<td>
					<input type="text" name="USER_NAME" style="width: 200px" />
					</td>
			</tr>
			<tr>				
				<th>사용자비밀번호</th>
				<td>
					<input type="password" name="USER_PASSWD" style="width:200px"/>		
				</td>
				<th>사용자IP</th>
				<td>
					<input type="text" name="USER_IP" style="width:200px"/>		
				</td>
			</tr>
			<tr>				
				<th>비고(참고사항)</th>
				<td colspan="3">
					<textarea id="BIGO" name="BIGO" cols="50" rows="4"></textarea>	
				</td>		
			</tr>		
		</tbody>
	</table>


	<div class="btnWrapR">
		<a href="#FIT" class="btn" onclick="javascript:uf_regedit();"><span>등록</span></a>
	</div>

</div>
<!-- //wrap -->
</form>
<IFRAME SRC="" frameborder="0" id="HiddenFrame" name="HiddenFrame" width="0" height="0" marginwidth="0" marginheight="0" scrolling="no" allowtransparency="true"></IFRAME>
