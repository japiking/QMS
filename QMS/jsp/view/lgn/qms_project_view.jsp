<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR" errorPage="/jsp/comm/error.jsp" %>
    
<%@ include file="/jsp/inc/inc_common.jsp" %>
<%@ include file="/jsp/inc/inc_header.jsp" %>
<%  
	String userId	= request.getParameter("USER_ID");
	
	
	// ������Ʈ ��ȸ�ϱ�
	Map<String,String> param = new HashMap<String,String>();
	param.put("USER_ID", 		userId);
		
	String combo =	ComboUtil.makeExtendCombo("QMS_LOGIN.PROJECTINFO_R001", "PROJECT_ID","PROJECTID","PROJECTNAME", null, param);

	
	//response.sendRedirect(strUrl);
	
%>
   <script type="text/javascript">
   	function uf_cancel() {
   		document.location.href = "/QMS/jsp/main.jsp";
   	}
   </script> 
  <table>
  	<tr>
    
  <form name="frm" method="post">
  	<input type = "hidden" name = "returnUrl" value = "/QMS/jsp/main.jsp"/>
  	<input type = "hidden" id = "USER_ID" 		value = "<%=userId%>"/>
  <div class="wrap2">
	<table style="width:500px; margin:20px auto;  margin-top:20px;">
		<colgroup>
			<col width="500px"/>
			<col width="*"/>  
		</colgroup>
		<tbody>
			<tr>
				<td style="text-align:center"><b><%=userSession.getUserName()%>(<%=userSession.getUserID()%>)</b>�� ȯ���մϴ�. �۾��Ͻ� ������Ʈ�� ������ �ֽñ� �ٶ��ϴ�.</td>
			</tr>
			<tr>
				<td>
				
					<!-- �α���â -->
					<table style="width:400px; margin:20px auto;">
						<colgroup>
							<col width="100px"/>
							<col width="*"/>
						</colgroup>
						<tbody>
							<tr>
								<th>������Ʈ</th>
								<td><%=combo%></td>
							</tr>
						</tbody>
					</table>
					
					
				
					<div class="btnWrapC">
						<a href="#FIT" class="btn" id="btn_confirm"><span>Ȯ��</span></a>
						<a href="#FIT" class="btn" onclick="javascript:uf_cancel();"><span>���</span></a>
					</div>
				
				</td>
			</tr>
		</tbody>
	</table>


 
</div>
<!-- //wrap -->
 
</form>
<script src="/QMS/js/bbs/Q00101.js"></script>
<%@ include file="/jsp/inc/inc_bottom.jsp" %>
