<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ include file="/jsp/inc/inc_common.jsp" %>
<%@ include file="/jsp/inc/inc_header.jsp" %>
<%
	String test_id			= StringUtil.null2void(request.getParameter("TEST_ID1"));
	String test_nm			= StringUtil.null2void(request.getParameter("NM"));
	String test_sttg_date	= StringUtil.null2void(request.getParameter("STT_DATE"));
	String test_endg_date 	= StringUtil.null2void(request.getParameter("END_DATE"));
	String test_bigo	  	= StringUtil.null2void(request.getParameter("BIGO"));
	String project_id		= userSession.getProjectID();
	
	Map<String,String> param=new HashMap<String,String>();
	param.put("PROJECT_ID",project_id);
	param.put("TEST_ID",test_id);
	param.put("TEST_NM",test_nm);
	param.put("STT_DATE",test_sttg_date);
	param.put("END_DATE",test_endg_date);
	param.put("BIGO",test_bigo);
	
	
%>

<script type="text/javascript">

function ts_update() {
	var frm=document.frm;
	
	if(frm.test_nm.value == "") {
		alert("TEST 명은 필수 입력사항입니다.");
		return;
	}
	
	frm.target			= '_self';
	frm.action			= "/QMS/jsp/proc/qcl/qcl_test_update_do.jsp";
	frm.submit();
}
	 
	
	
</script>
<h3>TEST 등록/목록</h3>
<form name="frm" method="post">
<div id="popup">
	<table>
	
		<colgroup>
			<col width="15%"/>
			<col width="15%"/>
			<col width="15%"/>
			<col width="*"/>	
		</colgroup>
		<tbody>
		
			<tr>						
				<th>TEST 명</th>
				<td>
					<input type="text" id="test_nm" name="test_nm" value="<%=param.get("TEST_NM")%>" style="width: 200px" />
					</td>
			
							
				<th>TEST 시작일</th>
				<td><div class="btnWrapL">
				<input readonly="readonly" id="test_sttg_date" name="test_sttg_date" value=<%=test_sttg_date%> style="width: 70px"  onclick="javascript:openCalendar(frm.test_sttg_date);" />
			    <a href="#FIT" onclick="javascript:openCalendar(frm.test_sttg_date);"><img src="/QMS/img/btn_s_cal.gif" alt="달력" class="bt_i"></a>
				</div>
				</td>
				<th>TEST 종료일</th>
				<td><div class="btnWrapL">
				<input readonly="readonly"  id="test_endg_date" name="test_endg_date" value=<%=test_endg_date%> style="width: 70px"  onclick="javascript:openCalendar(frm.test_endg_date);" />
			    <a href="#FIT" onclick="javascript:openCalendar(frm.test_endg_date);"><img src="/QMS/img/btn_s_cal.gif" alt="달력" class="bt_i"></a>
				</div>
				</td>
			</tr>
			<tr>				
				<th>비고(참고사항)</th>
				<td colspan="5">
					<textarea id="test_bigo" name="test_bigo" cols="80" rows="10" style="width:1000px; overflow-y:hidden;"><%=test_bigo%></textarea>	
				</td>		
			</tr>	

</tbody>
						
</table><br><br>
	<div class="btnWrapL">					
						<a href="#FIT" class="btn" onclick="javascript:ts_update();"><span>수정</span></a>
	</div>			
</form>					
	<%@ include file="/jsp/inc/inc_bottom.jsp" %>