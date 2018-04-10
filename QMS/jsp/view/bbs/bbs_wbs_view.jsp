<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
    
<%@ include file="/jsp/inc/inc_common.jsp" %>
<%@ include file="/jsp/inc/inc_header.jsp" %>

<%
	String board_id =  StringUtil.null2void(request.getParameter("BOARD_ID"));

	Map<String,String> param = new HashMap<String,String>();
	param.put("PROJECT_ID", 		userSession.getProjectID());
	List<Map<String,String>> list	= qmsDB.selectList("QMS_BBS_LIST.WBS_R001", param);          
%>
<script type="text/javascript">
$(document).ready(function() {
	var menu_nm = $("#"+'<%=board_id%>').text();
	$("h3").text(menu_nm);
	uf_changeColor();
});
//Excel파일 업로드 팝업
function uf_upload() {
	var frm				= document.frm;
	window.open('', 'EXCEL2', 'scrollbars=no,toolbar=yes,resizable=no,width=400,height=180,left=0,top=0');
	frm.target			= "EXCEL2";
	frm.BOARD_ID.value	= '<%=board_id%>';
	frm.action			= "/QMS/jsp/view/bbs/bbs_popup2_view.jsp";
	frm.submit();
}

function uf_stateUpdate(param1, param2) {
	var frm				= document.frm;
// 	var progressVal		= document.getElementsByName(param3)[0].value;
	
	frm.WBS_SEQ.value 	= param1;
	frm.STATE.value 	= param2;
	frm.BOARD_ID.value	= '<%=board_id%>';
// 	frm.IN_PROGRESS.value = progressVal;
	frm.target			= "_self";
	frm.action			= "/QMS/jsp/proc/bbs/bbs_wbs_state_do.jsp";
	frm.submit();
}

function uf_progState(param1, param2 , param3){
	
	var progressVal			= document.getElementsByName(param2)[0].value;
	var ajax = jex.createAjaxUtil("wbs_progresss_do");	// 호출할 페이지
	ajax.set("TASK_PACKAGE"	, "bbs" );				// [필수]업무 package 호출할 페이지 패키
	ajax.set("WBS_SEQ"		, param1 );	 						
	ajax.set("IN_PROGRESS"	, progressVal );
	
	ajax.execute(function(dat) {
		var data = dat["_tran_res_data"][0];
		var result = data.RESULT;
		if(result == "Y"){
			uf_loadProgState(param1,param3);
		}else{
			alert("수정중 오류가 발생 되었습니다");
		}
	});
}

function uf_loadProgState(param1, param2){
	try{
		// 공통부  
		var ajax = jex.createAjaxUtil("wbs_progresss_load_do");	// 호출할 페이지
		ajax.set("TASK_PACKAGE"	, "bbs" );				// [필수]업무 package 호출할 페이지 패키
		ajax.set("SEQ"		, param1 );	 						
		
		ajax.execute(function(dat) {
			try{
			var data = dat["_tran_res_data"][0];
			var result = data.REAL_PROGRESS;
			
			$("#"+param2).text(result);
			
			}catch(e){
				bizException(e, "error");
			}
		});
		
	} catch(e) {bizException(e, "error");}
}


function keyCodeNum(obj){
	
    var num_regx=/^[0-9]*$/;

	if( !num_regx.test(obj.value) ) {
		alert('숫자만 입력가능합니다.');
    	obj.value = obj.value.substring(0, obj.value.length-1 );
    }
}

function uf_changeColor(){
	$("tbody tr[state]").each(function(index,value){
		var state_nm = $(this).attr("state");
		if(state_nm=="지연"){
			$(this).css("color","red");
		}else if (state_nm=="진행"){
			$(this).css("color","bule");
		}else if (state_nm=="완료"){
			$(this).css("color","green");
		}else if (state_nm=="제외"){
			$(this).css("font-weight","bold");
		}
	});
}

function uf_modify(seq){
	var frm				= document.frm;
	var wid	  			= 800;
	var hei   			= 400;
	var LeftPosition	= (screen.width)  ? (screen.width-wid)/2  : 0;
	var TopPosition	 	= (screen.height) ? (screen.height-hei)/2 : 0;
	var setting  		= 'scrollbars=no,toolbar=yes,resizable=no,width='+wid+',height='+hei+',left='+LeftPosition+',top='+TopPosition;
	window.open('', '_popup', setting);
	frm.target			= "_popup";
	frm.action			= "/QMS/jsp/view/bbs/bbs_wbs_modify_popup_view.jsp";
	frm.MOD_WBS_SEQ.value 	= seq;
	frm.submit();
}

</script>
<%@ include file="/jsp/inc/inc_topMenu.jsp" %>
<%@ include file="/jsp/inc/inc_leftMenu.jsp" %>
<form name="frm" method="post">
<input type="hidden" name="WBS_SEQ"	/>	
<input type="hidden" name="MOD_WBS_SEQ"	/>	
<input type="hidden" name="STATE"	/>
<input type="hidden" name="BOARD_ID"	/>
<input type="hidden" name="IN_PROGRESS" /> 

	<div>
		<h3></h3>
		<div class="btnWrapL">
			<a href="#" class="btn" onclick="javascript:window.location.href='/QMS/jsp/view/bbs/bbs_wbs_summary_view.jsp;'"><span>WBS진척률 확인</span></a>
			<a href="#" class="btn" onclick="javascript:uf_upload();"><span>엑셀파일 업로드</span></a>
		</div>
		<table style="width: 1600px;">
			<colgroup>
				<col width="10px;">
				<col width="10px;">
				<col width="30px;">
				<col width="150px;">
				<col width="100px;">
				<col width="100px;">
				<col width="40px;">
				<col width="90px;">
				<col width="90px;">
				<col width="40px;">
				<col width="40px;">
				<col width="90px;">
				<col width="90px;">
				<col width="40px;">
				<col width="40px;">
				<col width="40px;">
				<col width="90px;">
				<col width="10px;">
				<col width="80px;">
				<col width="90px;">
				<col width="120px;">
				<col width="40px;">
			</colgroup>
			<thead>
				<tr>
					<th scope="col" style="text-align: center;" colspan="7">PROJECT</th>
					<th scope="col" style="text-align: center;" colspan="4" rowspan="2">계획 일정</th>
					<th scope="col" style="text-align: center;" colspan="4" rowspan="2">실제 일정</th>
					<th scope="col" style="text-align: center;" colspan="3" rowspan="2">진척표시</th>
					<th scope="col" style="text-align: center;" colspan="1" rowspan="2"></th>	
					<th scope="col" style="text-align: center;" colspan="1" rowspan="2"></th>
					<th scope="col" style="text-align: center;" colspan="1" rowspan="2"></th>
					<th scope="col" style="text-align: center;" colspan="1" rowspan="2"></th>			
				</tr>
				<tr>
					<th scope="col" style="text-align: center;" rowspan="3">ID</th>
					<th scope="col" style="text-align: center;" colspan="5">TASK</th>
					<th scope="col" style="text-align: center;" rowspan="3">진행<br/>상태</th>
				</tr>
				<tr>
					<th scope="col" style="text-align: center;" rowspan="2">Level</th>
					<th scope="col" style="text-align: center;" rowspan="2">Code of<br/>Account</th>
					<th scope="col" style="text-align: center;" rowspan="2">Title</th>				
					<th scope="col" style="text-align: center;" rowspan="2">Doc</th>		
					<th scope="col" style="text-align: center;" rowspan="2">R&R</th>
					<th scope="col" style="text-align: center;" rowspan="2">시작일</th>
					<th scope="col" style="text-align: center;">완료</th>
					<th scope="col" style="text-align: center;" rowspan="2">가중치</th>
					<th scope="col" style="text-align: center;">기간</th>
					<th scope="col" style="text-align: center;" rowspan="2">시작일</th>
					<th scope="col" style="text-align: center;">완료</th>
					<th scope="col" style="text-align: center;">기간</th>
					<th scope="col" style="text-align: center;" rowspan="2">가중치</th>
					<th scope="col" style="text-align: center;" rowspan="2">계획<br/>총기간</th>
					<th scope="col" style="text-align: center;" rowspan="2">진척일</th>
					<th scope="col" style="text-align: center;" rowspan="2">실제 진척율</th>
					<th scope="col" style="text-align: center;" rowspan="2">상태</th>
					<th scope="col" style="text-align: center;" rowspan="2">상태변경</th>
					<th scope="col" style="text-align: center;" rowspan="2">진행상태</th>
					<th scope="col" style="text-align: center;" rowspan="2">수정</th>
				</tr>
				<tr>
					<th scope="col" style="text-align: center;">월-일</th>
					<th scope="col" style="text-align: center;">Day</th>
					<th scope="col" style="text-align: center;">월-일</th>
					<th scope="col" style="text-align: center;">Day</th>
				</tr>

			</thead>
			<tbody>
			<%
				if( list == null || list.size() == 0 ) {
			%>
				<tr>
					<td colspan="20">조회 데이터가 없습니다.</td>
				</tr>
			<%
				} else {
					Map<String,String> dataMap	= null;
					String plan_sttd_date = new String();
					String plan_endg_date = new String();
					String real_sttd_date = new String();
					String real_endg_date = new String();
					String prog_totl_date = new String();
					for( int i = 0; i < list.size(); i++ ) {
						String state_nm ="";
						String state_style="";
						dataMap = list.get(i);
						plan_sttd_date = StringUtil.null2void(dataMap.get("PLAN_STTG_DATE"),"-");
						plan_endg_date = StringUtil.null2void(dataMap.get("PLAN_ENDG_DATE"),"-");
						real_sttd_date = StringUtil.null2void(dataMap.get("REAL_STTG_DATE"),"-");
						real_endg_date = StringUtil.null2void(dataMap.get("REAL_ENDG_DATE"),"-");
						prog_totl_date = StringUtil.null2void(dataMap.get("PROGRESS_DATE"),"-");
						/* if(plan_sttd_date.contains("."))
							plan_sttd_date = BizUtil.getPadString(plan_sttd_date.split("\\.")[1].trim(), 2, "0") +"."+ BizUtil.getPadString(plan_sttd_date.split("\\.")[2].trim(), 2, "0");
						if(plan_endg_date.contains("."))
							plan_endg_date = BizUtil.getPadString(plan_endg_date.split("\\.")[1].trim(), 2, "0") +"."+ BizUtil.getPadString(plan_endg_date.split("\\.")[2].trim(), 2, "0");
						if(real_sttd_date.contains("."))
							real_sttd_date = BizUtil.getPadString(real_sttd_date.split("\\.")[1].trim(), 2, "0") +"."+ BizUtil.getPadString(real_sttd_date.split("\\.")[2].trim(), 2, "0");
						if(real_endg_date.contains("."))
							real_endg_date = BizUtil.getPadString(real_endg_date.split("\\.")[1].trim(), 2, "0") +"."+ BizUtil.getPadString(real_endg_date.split("\\.")[2].trim(), 2, "0");
						if(prog_totl_date.contains("."))
							prog_totl_date = BizUtil.getPadString(prog_totl_date.split("\\.")[1].trim(), 2, "0") +"."+ BizUtil.getPadString(prog_totl_date.split("\\.")[2].trim(), 2, "0");
						 */
						//상태값을 위한 변수값
						int intRealEndgDate=0;
						int intToday = Integer.parseInt(DateTime.getInstance().getDate("yyyymmdd"));
						if(real_endg_date.contains(".")){
							intRealEndgDate = Integer.parseInt("2015"+real_endg_date.replaceAll("\\.", ""));
						} else if(real_endg_date.contains("-")) {
							intRealEndgDate = Integer.parseInt(real_endg_date.replaceAll("-", ""));
						}
						
						// 제외상태일때는 그리지 않는다.
						/* if("999".equals(dataMap.get("NOW_STAT"))) continue; */
						if ("333".equals(dataMap.get("NOW_STAT"))){
							state_nm = "완료요청";
						}else if ("888".equals(dataMap.get("NOW_STAT"))){
							state_nm = "제외요청";
						}else if(intRealEndgDate !=0 && intRealEndgDate < intToday && !"111".equals(dataMap.get("NOW_STAT")) && !"999".equals(dataMap.get("NOW_STAT"))){
							state_nm = "지연";
						}else{
							if("000".equals(dataMap.get("NOW_STAT"))){
								state_nm = "진행";
							} else if ("111".equals(dataMap.get("NOW_STAT"))) {
								state_nm = "완료";
							} else if ("222".equals(dataMap.get("NOW_STAT"))) {
								state_nm = "등록";
							} else if ("999".equals(dataMap.get("NOW_STAT"))){
								state_nm = "제외";
							} else state_nm="-";
						}
			%>
				<tr state="<%=state_nm %>">
					<td style="text-align: center;"><%=StringUtil.null2void(dataMap.get("SEQ"),"-")%></td>
					<td style="text-align: center;"><%=StringUtil.null2void(dataMap.get("TASK_LEVEL"),"-")%></td>
					<td ><%=StringUtil.null2void(dataMap.get("TASK_CODE"),"-")%></td>
					<td><%=StringUtil.null2void(dataMap.get("TASK_TITLE"),"-")%></td>
					<td><%=StringUtil.null2void(dataMap.get("TASK_DOCUMENT"),"-")%></td>
					<td style="text-align: center;"><%=StringUtil.null2void(dataMap.get("TASK_RNR"),"-")%></td>
					<td style="text-align: center;"><%=StringUtil.null2void(dataMap.get("STATE"),"-")%></td>
					<td style="text-align: center;"><%=plan_sttd_date%></td>
					<td style="text-align: center;"><%=plan_endg_date%></td>
					<td	style="text-align: center;"><%=StringUtil.null2void(dataMap.get("PLAN_MAJOR"),"-")%></td>
					<td	style="text-align: center;"><%=StringUtil.null2void(dataMap.get("PLAN_TERM"),"-")%></td>
					<td style="text-align: center;"><%=real_sttd_date%></td>
					<td style="text-align: center;"><%=real_endg_date%></td>
					<td style="text-align: center;"><%=StringUtil.null2void(dataMap.get("REAL_TERM"),"-")%></td>
					<td style="text-align: center;"><%=StringUtil.null2void(dataMap.get("REAL_MAJOR"),"-")%></td>
					<td style="text-align: center;"><%=StringUtil.null2void(dataMap.get("TOT_PERIOD"),"-")%></td>
					<td style="text-align: center;"><%=prog_totl_date%></td>
					<td style="text-align: center;" id="REAL_PROGRESS<%=i%>"><%=StringUtil.null2void(dataMap.get("REAL_PROGRESS"),"-")%></td>
					<td style="text-align: center;"><%=state_nm %></td>
					<%
					// 000 진행
					// 111 완료
					// 222 등록
					// 333 완료요청
					// 888 제외요청
					// 999 제외
					%>
					<td>
						<%if( ("222".equals(dataMap.get("NOW_STAT"))||"000".equals(dataMap.get("NOW_STAT")) ) && !userSession.getUserID().equals(dataMap.get("CONFIRM_USER"))) {%>
							<a href="#FIT" class="btn" onclick="javascript:uf_stateUpdate('<%=dataMap.get("SEQ")%>', 'CR');" ><span>완료요청</span></a>
							<a href="#FIT" class="btn" onclick="javascript:uf_stateUpdate('<%=dataMap.get("SEQ")%>', 'ER');" ><span>제외요청</span></a>
						<%} else if("111".equals(dataMap.get("NOW_STAT")) && !userSession.getUserID().equals(dataMap.get("CONFIRM_USER"))) {%>
							<a href="#FIT" class="btn" onclick="javascript:uf_stateUpdate('<%=dataMap.get("SEQ")%>', 'ER');" ><span>제외요청</span></a>
						<%} 
						// 확인자의경우
						else if("333".equals(dataMap.get("NOW_STAT")) && userSession.getUserID().equals(dataMap.get("CONFIRM_USER"))) {%>
							<a href="#FIT" class="btn" onclick="javascript:uf_stateUpdate('<%=dataMap.get("SEQ")%>', 'C');" ><span>완료승인</span></a>
							<a href="#FIT" class="btn" onclick="javascript:uf_stateUpdate('<%=dataMap.get("SEQ")%>', 'REJECT');" ><span>완료거부</span></a>
						<%} else if ("888".equals(dataMap.get("NOW_STAT")) &&  userSession.getUserID().equals(dataMap.get("CONFIRM_USER"))) {%>
							<a href="#FIT" class="btn" onclick="javascript:uf_stateUpdate('<%=dataMap.get("SEQ")%>', 'E');" ><span>제외승인</span></a>
							<a href="#FIT" class="btn" onclick="javascript:uf_stateUpdate('<%=dataMap.get("SEQ")%>', 'REJECT');" ><span>제외거부</span></a>
						<%
						}
						LogUtil.getInstance().debug("userSession.getUserID()"+userSession.getUserID());
						LogUtil.getInstance().debug("dataMap.getdataMap.ge"+dataMap.get("CONFIRM_USER"));
						%>
					</td>
					<td>
						<div>
							<div style="display: inline; float:left;">	
									<%
										String inPogress = StringUtil.null2void(dataMap.get("REAL_PROGRESS").replaceAll("%",""),"").trim();
									%>
									<progress min="0" max="100" value="<%=inPogress%>" style="width: 50px"></progress><br>
									<input type="text" name="POGRESS<%=i%>" size="5" value="<%=inPogress%>" onkeyup="javasciprt:keyCodeNum(this);" />%
							</div>
							<div style="display: inline;float:right;">
									<a href="#FIT" class="btn" onclick="javascript:uf_progState('<%=dataMap.get("SEQ")%>','POGRESS<%=i%>','REAL_PROGRESS<%=i%>');" ><span>진행</span></a>
							</div>
						</div>
					</td>
					<td>
						<a href="#" class="btn" onclick="javascript:uf_modify('<%=StringUtil.null2void(dataMap.get("SEQ"),"-")%>')">수정</a>
					</td>
				</tr>
				<%
					}
				}
				%>
			</tbody>
		</table>
	</div>
</form>

<%@ include file="/jsp/inc/inc_bottom.jsp" %>
