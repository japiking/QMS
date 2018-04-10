<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR" errorPage="/jsp/comm/error.jsp" %>
    
<%@ include file="/jsp/inc/inc_common.jsp" %>
<%@ include file="/jsp/inc/inc_header.jsp" %>
<%  
	String userId	= request.getParameter("USER_ID");
	
	
	// 프로젝트 조회하기
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
				<td style="text-align:center"><b><%=userSession.getUserName()%>(<%=userSession.getUserID()%>)</b>님 환영합니다. 작업하실 프로젝트를 선택해 주시기 바랍니다.</td>
			</tr>
			<tr>
				<td>
				
					<!-- 로그인창 -->
					<table style="width:400px; margin:20px auto;">
						<colgroup>
							<col width="100px"/>
							<col width="*"/>
						</colgroup>
						<tbody>
							<tr>
								<th>프로젝트</th>
								<td><%=combo%></td>
							</tr>
						</tbody>
					</table>
					
					
				
					<div class="btnWrapC">
						<a href="#FIT" class="btn" id="btn_confirm"><span>확인</span></a>
						<a href="#FIT" class="btn" onclick="javascript:uf_cancel();"><span>취소</span></a>
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
