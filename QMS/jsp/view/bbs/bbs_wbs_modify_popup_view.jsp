<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
    
<%@ include file="/jsp/inc/inc_common.jsp" %>
<%@ include file="/jsp/inc/inc_header.jsp" %>

<%

	String seq =  StringUtil.null2void(request.getParameter("MOD_WBS_SEQ"));
	String board_id =  StringUtil.null2void(request.getParameter("BOARD_ID"));
	Map<String,String> param = new HashMap<String,String>();
	param.put("PROJECT_ID", 		userSession.getProjectID());
	param.put("SEQ", 		seq);
	Map<String,String> preMap		= qmsDB.selectOne("QMS_BBS_LIST.WBS_R002", param);          
%>
<script type="text/javascript">
$(document).ready(function() {
	var menu_nm = $("#"+'<%=board_id%>').text();
	$("h3").text(menu_nm);
	$("#PLAN_STTG_DATE").datepicker();
	$("#PLAN_ENDG_DATE").datepicker();
	$("#REAL_STTG_DATE").datepicker();
	$("#REAL_ENDG_DATE").datepicker();
});

function uf_modify(){
	var ajax = jex.createAjaxUtil("wbs_modify_do");		// 호출할 페이지
	ajax.set("TASK_PACKAGE",    	"bbs" );				// [필수]업무 package 호출할 페이지 패키
	ajax.set("TASK_TITLE",    		$("#TASK_TITLE").val() );				
	ajax.set("TASK_DOCUMENT",    	$("#TASK_DOCUMENT").val() );				
	ajax.set("TASK_RNR",    		$("#TASK_RNR").val() );				
	ajax.set("PLAN_STTG_DATE",    	$("#PLAN_STTG_DATE").val() );			
	ajax.set("PLAN_ENDG_DATE",    	$("#PLAN_ENDG_DATE").val() );			
	ajax.set("PLAN_TERM",    		$("#PLAN_TERM").val() );				
	ajax.set("REAL_STTG_DATE",    	$("#REAL_STTG_DATE").val() );			
	ajax.set("REAL_ENDG_DATE",    	$("#REAL_ENDG_DATE").val() );			
	ajax.set("REAL_TERM",    		$("#REAL_TERM").val() );			
	ajax.set("SEQ",    				"<%=seq%>" );
	
	ajax.execute(function(dat) {
		var data = dat["_tran_res_data"][0];
		var result = data.RESULT;
		if(result == "Y"){
			alert("수정이 완료 되었습니다.");
			opener.location="/QMS/jsp/view/bbs/bbs_wbs_view.jsp"
			window.close();
		}else{
			alert("등록 중 오류가 발생 되었습니다");
		}
	});
}
</script>
<form name="frm" method="post">
	<div>
		<h3></h3>
		<table>
			<thead>
				<tr>
					<th scope="col" style="text-align: center;">항목명</th>
					<th scope="col">항목값</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td>Title</td>
					<td><input type="text" id="TASK_TITLE" name="TASK_TITLE" value="<%=StringUtil.null2void(preMap.get("TASK_TITLE")) %>"></td>
					
				</tr>
				<tr>
					<td>Doc</td>
					<td><input type="text" id="TASK_DOCUMENT" name="TASK_DOCUMENT" value="<%=StringUtil.null2void(preMap.get("TASK_DOCUMENT")) %>"></td>
				</tr>
				<tr>
					<td>R&R</td>
					<td><input type="text" id="TASK_RNR" name="TASK_RNR" value="<%=StringUtil.null2void(preMap.get("TASK_RNR")) %>"></td>
				</tr>
				<tr>
					<td>계획일정</td>
					<td><input type="text" readonly="readonly" id="PLAN_STTG_DATE" name="PLAN_STTG_DATE" value="<%=StringUtil.null2void(preMap.get("PLAN_STTG_DATE")) %>"> ~ <input type="text" readonly="readonly" id="PLAN_ENDG_DATE" name="PLAN_ENDG_DATE" value="<%=StringUtil.null2void(preMap.get("PLAN_ENDG_DATE")) %>"></td>
				</tr>
				<tr>
					<td>계획기간</td>
					<td><input type="text" id ="PLAN_TERM" name="PLAN_TERM" value="<%=StringUtil.null2void(preMap.get("PLAN_TERM")) %>"></td>
				</tr>
				<tr>
					<td>실제일정</td>
					<td><input type="text" readonly="readonly" id="REAL_STTG_DATE" name="REAL_STTG_DATE" value="<%=StringUtil.null2void(preMap.get("REAL_STTG_DATE")) %>"> ~ <input type="text" readonly="readonly" id="REAL_ENDG_DATE" name="REAL_ENDG_DATE" value="<%=StringUtil.null2void(preMap.get("REAL_ENDG_DATE")) %>"></td>
				</tr>
				<tr>
					<td>실제기간</td>
					<td><input type="text" id="REAL_TERM" name="REAL_TERM" value="<%=StringUtil.null2void(preMap.get("REAL_TERM")) %>"></td>
				</tr>
			</tbody>
		</table>
		<div class="btnWrapC">
			<a href="#FIT" class="btn" id="MODIFY" onclick="uf_modify();return false;"><span>수정</span></a>
			<a href="#FIT" class="btn" onclick="javascript:window.close();"><span>취소</span></a>
		</div>
	</div>
</form>

	