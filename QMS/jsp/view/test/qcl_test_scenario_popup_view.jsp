<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ include file="/jsp/inc/inc_common.jsp" %>
<%@ include file="/jsp/inc/inc_header.jsp" %>
<%
	String test_id			= StringUtil.null2void(request.getParameter("TEST_ID"));
	String project_id		= userSession.getProjectID();
	String sc_id			= StringUtil.null2void(request.getParameter("SC_ID"));
	String sc_nm			= StringUtil.null2void(request.getParameter("SC_NM"));
	String sc_start			= StringUtil.null2void(request.getParameter("SC_START"));
	String sc_end			= StringUtil.null2void(request.getParameter("SC_END"));
	Map<String,String> param=new HashMap<String,String>();
	param.put("PROJECT_ID",	project_id);
	param.put("TEST_ID",   	test_id);
	param.put("SCENARIO_ID",sc_id);
	param.put("SCENARIO_NM",sc_nm);
	param.put("START_DATE",	sc_start);
	param.put("END_DATE",	sc_end);
%>

<script type="text/javascript">

function sc_update1() {
	var frm=document.frm;
	var ts_id=frm.tsId.value;
	var sc_id=frm.scId.value;
	var sc_nm=frm.scenario_nm.value;
	var start_date=frm.sttg_date.value;
	var end_date=frm.endg_date.value
	

	frm.target			= '_self';
	frm.action			= "/QMS/jsp/proc/qcl/qcl_test_scenario_update_do.jsp";
	frm.submit();
}
	 
	
	
</script>
<h3>TEST 등록/목록</h3>
<form name="frm" method="post">

<input type="hidden" name="scId" id="scId" value="<%=param.get("SCENARIO_ID")%>"/>
<input type="hidden" name="tsId" id="tsId" value="<%=param.get("TEST_ID")%>"/>

<div id="popup">
	<table>
	
		<colgroup>
			<col width="15%"/>
			<col width="15%"/>
			<col width="15%"/>	
		</colgroup>
		<tbody>
		
			<tr>						
				<th>시나리오 명</th>
				<td>
					<input type="text" id="scenario_nm" name="scenario_nm" value="<%=param.get("SCENARIO_NM")%>" style="width: 400px" />
					</td>
			
							
				<th>시작일</th>
				<td><div class="btnWrapL">
				<input readonly="readonly" id="sttg_date" name="sttg_date" value="<%=param.get("START_DATE")%>" style="width: 70px"  onclick="javascript:openCalendar(frm.test_sttg_date);" />
			    <a href="#FIT" onclick="javascript:openCalendar(frm.test_sttg_date);"><img src="/QMS/img/btn_s_cal.gif" alt="달력" class="bt_i"></a>
				</div>
				</td>
				<th>종료일</th>
				<td><div class="btnWrapL">
				<input readonly="readonly"  id="endg_date" name="endg_date" value="<%=param.get("END_DATE")%>" style="width: 70px"  onclick="javascript:openCalendar(frm.test_endg_date);" />
			    <a href="#FIT" onclick="javascript:openCalendar(frm.test_endg_date);"><img src="/QMS/img/btn_s_cal.gif" alt="달력" class="bt_i"></a>
				</div>
				</td>
			</tr>
			

</tbody>
						
</table><br><br>
	<input type="button" id="sc_update" name="sc_update" value="수정" onclick="javascript:sc_update1();"/>
</form>					
	<%@ include file="/jsp/inc/inc_bottom.jsp" %>