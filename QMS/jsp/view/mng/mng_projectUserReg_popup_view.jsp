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
	* QMS ȸ������ó�� 
	**/
	function uf_regedit() {
		if(frm.USER_ID.value == "") {
			alert("ID�� �ʼ� �Է»����Դϴ�.");
			return;
		}
		if(frm.USER_NAME.value == "") {
			alert("�̸��� �ʼ� �Է»����Դϴ�.");
			return;
		}
		if(frm.USER_PASSWD.value == "") {
			alert("��й�ȣ�� �ʼ� �Է»����Դϴ�.");
			return;
		}
		
		if("N" == check_yn){
			alert("ID �ߺ�üũ�� �ʼ��Դϴ�.");
			return;
		}
		/* 
		if(frm.USER_IP.value == "") {
			alert("����� IP�� �ʼ� �Է»����Դϴ�.");
			return;
		}
		*/
		frm.target			= '_self';
		frm.action			= "/QMS/jsp/proc/mng/mng_UserInfoReg_do.jsp";
		frm.submit();

	}	
	// ID�ߺ� üũ
	function uf_idCheck(){
		var id = $("#USER_ID").val();
		if(id != null) id = $.trim(id);
		
		if(id == ""){
			alert("ID�� �Է��ϼ���.");
			return false;
		}
		
		frm.target			= 'HiddenFrame';
		frm.action			= "/QMS/jsp/proc/mng/mng_UserIdCheck_do.jsp";
		frm.submit();
	}
</script> 
  

<form name="frm" method="post">
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
					<input type="text" name="USER_NAME" style="width: 200px" />
					</td>
			</tr>
			<tr>				
				<th>����ں�й�ȣ</th>
				<td>
					<input type="password" name="USER_PASSWD" style="width:200px"/>		
				</td>
				<th>�����IP</th>
				<td>
					<input type="text" name="USER_IP" style="width:200px"/>		
				</td>
			</tr>
			<tr>				
				<th>���(�������)</th>
				<td colspan="3">
					<textarea id="BIGO" name="BIGO" cols="50" rows="4"></textarea>	
				</td>		
			</tr>		
		</tbody>
	</table>


	<div class="btnWrapR">
		<a href="#FIT" class="btn" onclick="javascript:uf_regedit();"><span>���</span></a>
	</div>

</div>
<!-- //wrap -->
</form>
<IFRAME SRC="" frameborder="0" id="HiddenFrame" name="HiddenFrame" width="0" height="0" marginwidth="0" marginheight="0" scrolling="no" allowtransparency="true"></IFRAME>
