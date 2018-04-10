<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%@ include file="/jsp/inc/inc_common.jsp" %>
<%@ include file="/jsp/inc/inc_header.jsp" %>


<%
String board_id		= StringUtil.null2void(request.getParameter("BOARD_ID"));
String channel_nm	= StringUtil.null2void(request.getParameter("CHANEL_TYPE"));
String task_nm		= StringUtil.null2void(request.getParameter("task_nm"));  		// Task명
String inq_type		= StringUtil.null2void(request.getParameter("inq_type"), "A");  		// 조회타입
String strTodaty	= DateTime.getInstance().getDate("yyyy-mm-dd");

String pageNum		= StringUtil.null2void(request.getParameter("PAGE_NUM"),   "1");
String pageCount	= StringUtil.null2void(request.getParameter("PAGE_COUNT"), "10");  
int pageNumberCount = 10;
int start_rowId		= 1;
int end_rowId		= 0;
int page_num		= 1;
int page_count		= 0;
int tot_page_count	= 0;

//페이징관련
int req_cnt  = Integer.parseInt("".equals(pageNum) ? "10" : pageCount);	// 요청건수
int req_page = Integer.parseInt("".equals(pageNum) ? "1"  : pageNum);	// 요청페이지
int fromcnt = ((req_page-1)*req_cnt)+1;		// 시작번호
int tocnt	= (req_page*req_cnt);			// 종료번호

// 파라미터 셋팅
Map<String,Object> param = new HashMap<String,Object>();
param.put("BOARD_ID", 	board_id);
param.put("FROM_SEQ", 	fromcnt);
param.put("TO_SEQ", 	tocnt);
param.put("TODAY", 		strTodaty);

// 채널명 검색
if(!"".equals(channel_nm) && "C".equals(inq_type)){
	param.put("CHANEL_NAME", 	channel_nm);
}

// Task명 검색(타이틀)
if(!"".equals(task_nm) && "T".equals(inq_type)){
	param.put("TITLE", 	task_nm);
}

List<Map<String,String>> list	= qmsDB.selectList("QMS_BBS_LIST.BOARD_R001",	param);

String today = DateTime.getInstance().getDate("yyyy-mm-dd");
int intToday = Integer.parseInt(DateTime.getInstance().getDate("yyyymmdd"));
String date  = new String();
String state = new String();
String new_yn = "N";

int startpage = 0;
int endpage	=0;
int maxpage	=0;

// 건수조회 SQL
Map<String,String> countMap	=qmsDB.selectOne("QMS_BBS_LIST.BOARD_R002", param);
int totCount		= StringUtil.null2zero(StringUtil.null2void(countMap.get("COUNT"), "0"));

page_num			= StringUtil.null2zero(pageNum);
page_count			= StringUtil.null2zero(pageCount);
tot_page_count		= totCount / page_count;

if( (totCount % page_count) > 0 ) tot_page_count++;
		
maxpage= tot_page_count; 

startpage = (((int) ((double)page_num / 10 + 0.9)) - 1) * 10 + 1;
endpage = maxpage; 
 
if (endpage>startpage+10-1) endpage=startpage+10-1;

// 통계처리위한 로직
Map<String,String> statsMap	= new HashMap<String,String>();
int sta1					= 0;			//진행중
int sta2					= 0; 			//완료
int sta3					= 0;			//제외
int sta4					= 0;			//완료예정
double tot_rate 			= 0.0; 
double exp_rate 			= 0.0; 
try{
	statsMap	= qmsDB.selectOne("QMS_BBS_LIST.BOARD_R003", param);
	sta1				= StringUtil.null2zero(statsMap.get("STA1"));
	sta2				= StringUtil.null2zero(statsMap.get("STA2"));
	sta3				= StringUtil.null2zero(statsMap.get("STA3"));
	sta4				= StringUtil.null2zero(statsMap.get("STA4"));
	//tot_rate = (sta2*100)/(sta1+sta2);
	if(totCount == 0 ){
		tot_rate = 0;
	}else{
		tot_rate = 	(double)(sta2 + sta3) / (double)totCount * 100;
	}
	if(sta4 == 0){
		exp_rate =100;
	}else{
		exp_rate = 	(double)(sta2 + sta3) /(double)sta4 * 100;
	}
}catch(Exception e){
	e.printStackTrace();
	sta1				= 0;
	sta2				= 0; 
	sta3				= 0;
	tot_rate			= 0;
}

//검색 select박스 데이터
List<Map<String,String>> opt_list = null;
try{
	opt_list = qmsDB.selectList("QMS_BBS_LIST.BOARD_R004", param);
}catch(Exception e){
	LogUtil.getInstance().debug(e);
}


%>
<script type="text/javascript">
	var frm;
	var brd;
	$(document).ready(function(){
		frm = document.form1;
		brd_id = '<%=board_id%>'
		$("#CHANEL_NAME").val('<%=channel_nm%>');
		$("#inq_type").val('<%=inq_type%>');
		
		var menu_nm = $("#"+brd_id).text();
		$("h3").text(menu_nm);
		
		var tp = '<%=inq_type%>';
		if("A" == tp){
			$("#CHANEL_NAME").hide();
			$("#task_nm").hide();
		} else if("T" == tp){
			$("#CHANEL_NAME").hide();
			$("#task_nm").show();
		} else if("C" == tp){
			$("#CHANEL_NAME").show();
			$("#task_nm").hide();
		}
		
		
		// 검색조건이 바뀔경우 타는 함수
		$("#inq_type" ).change(function() {
			var type = $("#inq_type").val();
			if("A" == type){
				$("#CHANEL_NAME").hide();
				$("#task_nm").hide();
			} else if("T" == type){
				$("#CHANEL_NAME").hide();
				$("#task_nm").show();
			} else if("C" == type){
				$("#CHANEL_NAME").show();
				$("#task_nm").hide();
			}
		});
	});
	function uf_inq(pagenum) {                        // 파라메터 : 조회 페이지
		var frm				= document.frm;
		if(pagenum == 0){
			pagenum = '1';
		}
		frm.PAGE_NUM.value	= pagenum;
		frm.BOARD_ID.value	= brd_id;
				
		frm.target			= "_self";
		frm.action			= "/QMS/jsp/view/bbs/bbs_list_view.jsp";
		frm.submit();
	}
	
	function uf_search(param) {                        // 파라메터 : 조회 페이지
		var frm				= document.frm;
		var nm = $("#CHANEL_NAME").val();
		var type = $("#inq_type").val();
		
		if("A" == type){
			frm.CHANEL_TYPE.value = '';
			frm.task_nm.value = '';
		} else if("T" == type){
			frm.CHANEL_TYPE.value = '';
		} else if("C" == type){
			frm.CHANEL_TYPE.value = nm;
			frm.task_nm.value = '';
		}
		
		frm.CHANEL_TYPE.value = nm;
		frm.BOARD_ID.value	= brd_id;
				
		frm.target			= "_self";
		frm.action			= "/QMS/jsp/view/bbs/bbs_list_view.jsp";
		frm.submit();
	}
	
	
	function uf_cancel(rowid) {
				return;
	}
	
	function uf_FileDownLoad(fnm) {		
		//alert(fnm);
		location.href = "/QMS/jsp/comm/FileDown.jsp?filename=" + encodeURI(fnm);
	}
	
	function uf_detail(rowid, seq, depth) {
		var frm				= document.frm;	
		frm.BBS_ID.value	= rowid;
		frm.BOARD_ID.value	= brd_id;
		frm.SEQ.value		= seq;
		frm.DEPTH.value		= depth;
		frm.target			= "_self";
		frm.action			= "/QMS/jsp/view/bbs/bbs_detail_view.jsp";
		frm.submit();
	}
	
	function uf_modify(param, seq, depth) { 
		var frm				= document.frm;
		if(param == 1) frm.BBS_ID.value	= "";
		else frm.BBS_ID.value	= param;
		
		frm.BOARD_ID.value			= brd_id;
		frm.SEQ.value				= seq;
		frm.DEPTH.value				= depth;
		frm.DETAIL_STATE.value		= "U";
		frm.target					= "_self";
		frm.action			= "/QMS/jsp/view/bbs/bbs_write_view.jsp";
		frm.submit();
	}
	
	function uf_reg() { 
		var frm				= document.frm;
		frm.BBS_ID.value	= "";
		frm.BOARD_ID.value			= brd_id;
		frm.target					= "_self";
		frm.action			= "/QMS/jsp/view/bbs/bbs_write_view.jsp";
		frm.submit();
	}
	// Excel파일 업로드 팝업
	function uf_upload() {
		var frm				= document.frm;
		window.open('', 'EXCEL', 'scrollbars=no,toolbar=yes,resizable=no,width=400,height=180,left=0,top=0');
		frm.target			= "EXCEL";
		frm.BOARD_ID.value	= brd_id;
		frm.action			= "/QMS/jsp/view/bbs/bbs_popup_view.jsp";
		frm.submit();
	}
	/**
	* 진행상태 수정
	**/
	function uf_stateUpdate(bbsId, stat, seq, b_stat) {
		var frm				= document.frm;
		frm.BOARD_ID.value	= brd_id;
		frm.BBS_ID.value	= bbsId;
		frm.STAT.value		= stat; // C:완료 D:삭제, E:제외
		frm.BEFORE_STAT.value = b_stat; // 이전 상태값
		frm.SEQ.value		= seq;
		frm.BOARD_ID.value	= brd_id;
		
        var nm = $("#CHANEL_NAME").val();
		var type = $("#inq_type").val();
		
		if("A" == type){
			frm.CHANEL_TYPE.value = '';
			frm.task_nm.value = '';
		} else if("T" == type){
			frm.CHANEL_TYPE.value = '';
		} else if("C" == type){
			frm.CHANEL_TYPE.value = nm;
			frm.task_nm.value = '';
		}
		
		frm.CHANEL_TYPE.value = nm;
		frm.target			= '_self';
// 		frm.target			= "HiddenFrame";
		frm.action			= "/QMS/jsp/view/bbs/bbs_list_do.jsp";
		frm.submit();
	}
	
</script>
<%@ include file="/jsp/inc/inc_topMenu.jsp" %>
<%@ include file="/jsp/inc/inc_leftMenu.jsp" %>
<form name="frm" method="post">
	<input type="hidden" name="PAGE_NUM"	value="<%=pageNum%>" 	/>
	<input type="hidden" name="CHANEL_TYPE"	value="" 	/>
  	<input type="hidden" name="PAGE_COUNT"	value="<%=pageCount %>" 	/>
  	<input type="hidden" name="BOARD_ID"	value="<%=board_id %>"	/>
  	<input type="hidden" name="BBS_ID"		value="" 	/>
  	<input type="hidden" name="SEQ"			value="" 	/>
  	<input type="hidden" name="STAT"		value="" 	/>
  	<input type="hidden" name="BEFORE_STAT"	value="" 	/>
	<input type="hidden" name="DEPTH"		value="" 	/>
	<input type="hidden" name="DETAIL_STATE" 	value="" 	/>
	<div class="wrap">
		<h3></h3>
		<%-- <table>
			<colgroup>
				<col width="20%"/>
				<col width="20%"/>
				<col width="20%"/>
				<col width="20%"/>
				<col width="20%"/>
			</colgroup>
			<tbody>
				<tr>
					<th scope="row" style="text-align: center;">총본수</th>
					<th scope="row" style="text-align: center;">진행중</th>
					<th scope="row" style="text-align: center;">완료</th>
					<th scope="row" style="text-align: center;">제외</th>
					<th scope="row" style="text-align: center;">완료율</th>
				</tr>
				<tr>
					<td scope="row" style="text-align: center;"><%=totCount %></td>
					<td scope="row" style="text-align: center;"><%=sta1 %></td>
					<td scope="row" style="text-align: center;"><%=sta2 %></td>
					<td scope="row" style="text-align: center;"><%=sta3 %></td>
					<td scope="row" style="text-align: center;"><%=tot_rate %>%</td>
				</tr>
			</tbody>
		</table> 
		<br/>
		<br/>	--%>	
		<table>
		<colgroup>
				<col width="12%"/>
				<col width="12%"/>
				<col width="12%"/>
				<col width="12%"/>
				<col width="12%"/>
				<col width="12%"/>
				<col width="12%"/>
				<col width="12%"/>
			</colgroup>
			<tbody>
			<tr>
				<th scope="row" style="text-align: center;">채널구분</th>
				<th scope="row" style="text-align: center;">총본수</th>
				<th scope="row" style="text-align: center;">진행중</th>
				<th scope="row" style="text-align: center;">완료예정</th>
				<th scope="row" style="text-align: center;">완료</th>
				<th scope="row" style="text-align: center;">제외</th>
				<th scope="row" style="text-align: center;">완료율</th>
				<th scope="row" style="text-align: center;">계획대비진척률</th>
			</tr>
	<%	
	//전체통계
	
	%>
	
		<tr>
			<td scope="row" style="text-align: center;">전체</td>
			<td scope="row" style="text-align: center;"><%=totCount %></td>
			<td scope="row" style="text-align: center;"><%=sta1 %></td>
			<td scope="row" style="text-align: center;"><%=sta4 %></td>
			<td scope="row" style="text-align: center;"><%=sta2 %></td>
			<td scope="row" style="text-align: center;"><%=sta3 %></td>
			<td scope="row" style="text-align: center;"><%=String.format("%.2f",tot_rate)  %>%</td>
			<td scope="row" style="text-align: center;"><%=String.format("%.2f",exp_rate)  %>%</td>
		</tr>
	<%
	//체널별통계
for(int i=0; i < opt_list.size();i++){
	// 건수조회 SQL
	String strChanel_name = opt_list.get(i).get("CHANEL_NAME");
	Map<String,Object> param_ch = new HashMap<String,Object>();
	param_ch.put("TODAY", 		strTodaty);
	param_ch.put("BOARD_ID", 	board_id);
	param_ch.put("CHANEL_NAME", strChanel_name);
	Map<String,String> countMap_ch	=qmsDB.selectOne("QMS_BBS_LIST.BOARD_R002", param_ch);
	int totCount_ch		= StringUtil.null2zero(StringUtil.null2void(countMap_ch.get("COUNT"), "0"));
	Map<String,String> statsMap_ch	= new HashMap<String,String>();
	int sta1_ch					= 0;			//진행중
	int sta2_ch					= 0; 			//완료
	int sta3_ch					= 0;			//제외
	int sta4_ch					= 0;			//완료예정
	double tot_rate_ch			= 0.0; 
	double exp_rate_ch			= 0.0; 
	try{
		statsMap	= qmsDB.selectOne("QMS_BBS_LIST.BOARD_R003", param_ch);
		sta1_ch				= StringUtil.null2zero(statsMap.get("STA1"));	//진행중 
		sta2_ch				= StringUtil.null2zero(statsMap.get("STA2"));	//완료  
		sta3_ch				= StringUtil.null2zero(statsMap.get("STA3"));	//제외  
		sta4_ch				= StringUtil.null2zero(statsMap.get("STA4"));	//완료예정
		if(totCount_ch == 0 ){
			tot_rate_ch = 0;
		}else{
			tot_rate_ch = 	(double)(sta2_ch + sta3_ch) / (double)totCount_ch * 100;
		}
		if(sta4_ch == 0){
			exp_rate_ch =100;
		}else{
			exp_rate_ch = 	(double)(sta2_ch + sta3_ch) /(double)sta4_ch * 100;
		}
		%>
				<tr>
					<td scope="row" style="text-align: center;"><%=strChanel_name %></td>
					<td scope="row" style="text-align: center;"><%=totCount_ch %></td>
					<td scope="row" style="text-align: center;"><%=sta1_ch %></td>
					<td scope="row" style="text-align: center;"><%=sta4_ch %></td>
					<td scope="row" style="text-align: center;"><%=sta2_ch %></td>
					<td scope="row" style="text-align: center;"><%=sta3_ch %></td>
					<td scope="row" style="text-align: center;"><%=String.format("%.2f",tot_rate_ch)  %>%</td>
					<td scope="row" style="text-align: center;"><%=String.format("%.2f",exp_rate_ch)  %>%</td>
				</tr>
			
		<%
	}catch(Exception e){
		e.printStackTrace();
		sta1_ch				= 0;
		sta2_ch				= 0; 
		sta3_ch				= 0;
		tot_rate_ch 		= 0;
		exp_rate_ch			= 0;
	}
}
 %>
 			</tbody>
		</table>
		<br/><br/>
		<div class="btnWrapR">
			<a href="#" class="btn" onclick="javascript:uf_reg(1);"><span>글쓰기</span></a>
			<a href="#" class="btn" onclick="javascript:uf_upload();"><span>Excel 파일 등록</span></a>
			&nbsp;&nbsp;&nbsp;
			<select name="inq_type" id="inq_type">
				<option value="A">전체</option>
				<option value="T">Task명</option>
				<option value="C">채널</option>
			</select>
			<select name="CHANEL_NAME" id="CHANEL_NAME" style="display: none;">
				<option value="">전체</option>
				<%
				if(null != opt_list && !opt_list.isEmpty()){
					for(int k=0; k<opt_list.size(); k++){
						Map<String,String> tmp = opt_list.get(k);
				%>
				<option value="<%=StringUtil.null2void(tmp.get("CHANEL_NAME")) %>"><%=StringUtil.null2void(tmp.get("CHANEL_NAME")) %></option>
				<%
					}
				}
				%>
			</select>
			<input type="text" id="task_nm" name="task_nm" value="<%=task_nm %>" style="display: none;" />
			<a href="#FIT" class="btn" onclick="javascript:uf_search();"><span>검색</span></a>
		</div>
		<table class="list">
			<colgroup>
				<col width="3%"/>
				<col width="30%"/>
				<col width="5%"/>
				<col width="6%"/>
				<col width="20%"/>
				<col width="8%"/>
				<col width="8%"/>
				<col width="8%"/>
				<col width="8%"/>
				<col width="*"/>			
			</colgroup>
			<thead>
				<tr>
					<th scope="col" style="text-align: center;">No</th>
					<th scope="col" style="text-align: center;">Task명</th>
					<th scope="col" style="text-align: center;">채널</th>
					<th scope="col" style="text-align: center;">현재상태</th>
					<th scope="col" style="text-align: center;">진척</th>
					<th scope="col" style="text-align: center;">등록자</th>				
					<th scope="col" style="text-align: center;">등록일시</th>
					<th scope="col" style="text-align: center;">완료예정일</th>					
					<th scope="col" style="text-align: center;">완료일자</th>				
<!-- 					<th scope="col" style="text-align: center;">완료시각</th> -->
					<th scope="col" style="text-align: center;">첨부</th>
				</tr>
			</thead>
			<tbody>
				<% if( list == null || list.size() == 0 ) { %>
				<tr>
					<td colspan="9">조회 데이터가 없습니다.</td>
				</tr>
				<% } else {
					Map<String,String> dataMap	= null;
					String state_nm = new String();
					for( int i = 0; i < list.size(); i++ ) {
						dataMap	= list.get(i);
						state_nm = "";
						String cmptDate = StringUtil.null2void(dataMap.get("COMPLETION_DATE"), "1999-12-31");
						cmptDate		= cmptDate.replaceAll("-", "");
						
						// 상태값 체크
						state =  StringUtil.null2void(dataMap.get("STATE"));
						if(intToday > Integer.parseInt(cmptDate) && !"111".equals(state) && !"999".equals(state)){
							state_nm = "지연";
						}else{
							if("000".equals(state)) state_nm = "진행";
							else if("111".equals(state)) state_nm = "완료";
							else if("222".equals(state)) state_nm = "등록";
							else if("333".equals(state)) state_nm = "완료요청";
							else if("444".equals(state)) state_nm = "제외요청";
							else if("555".equals(state)) state_nm = "삭제요청";
							else if("999".equals(state)) state_nm = "제외";
						}
						// 새글 여부 체크
						new_yn = "N";
						date = dataMap.get("BBS_REG_DATE");
						if(today.equals(date)) new_yn = "Y";
						
						LogUtil.getInstance().debug("LSJ----CONFIRM_USER>>"+dataMap.get("CONFIRM_USER"));
				%>
				<tr height="45px">
					<td><%=dataMap.get("ROW_SEQ")%></td>
					<%if(dataMap.get("DEPTH").equals("1")){
					%>
					<td class="alL">
						<a href="#" onclick="javascript:uf_detail('<%=dataMap.get("BBS_ID")%>','<%=dataMap.get("SEQ")%>','<%=dataMap.get("DEPTH")%>');"><%=dataMap.get("TITLE")%><%if(new_yn.equals("Y")) out.print("<img src='/QMS/img/new.jpg'>");%></a>
					</td>
					<td><%=dataMap.get("CHANEL_NAME")%></td>
					<td><%=state_nm%></td>
					<td>
						<%
						// 완료나 승인요청일 경우
						if(!"333".equals(state) && !"444".equals(state) && !"555".equals(state)){
							if(intToday > Integer.parseInt(cmptDate) && !"111".equals(state) && !"999".equals(state)){ %>
								<%if(userSession.getUserID().equals(dataMap.get("BBS_USER")) || "00".equals(userSession.getAuthorityGrade())){%>
									<a href="#FIT" class="btn" onclick="javascript:uf_stateUpdate('<%=dataMap.get("BBS_ID")%>', 'C','<%=dataMap.get("SEQ")%>');" ><span>완료</span></a>
									<a href="#FIT" class="btn" onclick="javascript:uf_stateUpdate('<%=dataMap.get("BBS_ID")%>', 'E','<%=dataMap.get("SEQ")%>');" ><span>제외</span></a>
									<a href="#FIT" class="btn" onclick="javascript:uf_stateUpdate('<%=dataMap.get("BBS_ID")%>', 'D','<%=dataMap.get("SEQ")%>');" ><span>삭제</span></a>
								<%}%>
							<%}else{ %>
								<%if(userSession.getUserID().equals(dataMap.get("BBS_USER")) || "00".equals(userSession.getAuthorityGrade())){%>
									<%if("222".equals(state)) {%>
										<a href="#FIT" class="btn" onclick="javascript:uf_stateUpdate('<%=dataMap.get("BBS_ID")%>', 'S','<%=dataMap.get("SEQ")%>');" ><span>진행</span></a>
										<a href="#FIT" class="btn" onclick="javascript:uf_stateUpdate('<%=dataMap.get("BBS_ID")%>', 'C','<%=dataMap.get("SEQ")%>');" ><span>완료</span></a>
										<a href="#FIT" class="btn" onclick="javascript:uf_stateUpdate('<%=dataMap.get("BBS_ID")%>', 'E','<%=dataMap.get("SEQ")%>');" ><span>제외</span></a>
										<a href="#FIT" class="btn" onclick="javascript:uf_stateUpdate('<%=dataMap.get("BBS_ID")%>', 'D','<%=dataMap.get("SEQ")%>');" ><span>삭제</span></a>
									<%} else if("000".equals(state)) {%>
										<a href="#FIT" class="btn" onclick="javascript:uf_stateUpdate('<%=dataMap.get("BBS_ID")%>', 'C','<%=dataMap.get("SEQ")%>');" ><span>완료</span></a>
										<a href="#FIT" class="btn" onclick="javascript:uf_stateUpdate('<%=dataMap.get("BBS_ID")%>', 'E','<%=dataMap.get("SEQ")%>');" ><span>제외</span></a>
										<a href="#FIT" class="btn" onclick="javascript:uf_stateUpdate('<%=dataMap.get("BBS_ID")%>', 'D','<%=dataMap.get("SEQ")%>');" ><span>삭제</span></a>
									<%} else {%>
										<a href="#FIT" class="btn" onclick="javascript:uf_modify('<%=dataMap.get("BBS_ID")%>','<%=dataMap.get("SEQ")%>','<%=dataMap.get("DEPTH")%>');"				><span>수정</span></a>
	<%-- 									<a href="#FIT" class="btn" onclick="javascript:uf_stateUpdate('<%=dataMap.get("BBS_ID")%>', 'D','<%=dataMap.get("SEQ")%>');" ><span>삭제</span></a> --%>
									<%}%>
								<%}%>
							<%}
						} else { 
							if(userSession.getUserID().equals(dataMap.get("CONFIRM_USER")) && "01".equals(userSession.getAuthorityGrade())){
						%>
						
							<a href="#FIT" class="btn" onclick="javascript:uf_stateUpdate('<%=dataMap.get("BBS_ID")%>', 'A','<%=dataMap.get("SEQ")%>','<%=state%>');" ><span>승인</span></a>
							<a href="#FIT" class="btn" onclick="javascript:uf_stateUpdate('<%=dataMap.get("BBS_ID")%>', 'R','<%=dataMap.get("SEQ")%>','<%=state%>');" ><span>거부</span></a>
						<%
							}
						} 
						%>
					</td>
					<%} else { %> 
					<td class="alL">
						└답변:<a href="#FIT" onclick="javascript:uf_detail('<%=dataMap.get("BBS_ID")%>', '<%=dataMap.get("SEQ")%>', '<%=dataMap.get("DEPTH")%>');"><%=dataMap.get("TITLE")%></a>
					</td>
					<td><%=dataMap.get("CHANEL_NAME")%></td>
					<td>-</td>
					<td>-</td>
					<%}//end else %>
					<td><%=dataMap.get("USERNAME")%>(<%=dataMap.get("BBS_USER")%>)</td>
					<td><%=dataMap.get("BBS_REG_DATE")%></td>
					<td><%=dataMap.get("COMPLETION_DATE")%></td>
					<td><%=StringUtil.null2void(dataMap.get("COMPLETE_DATE"))%></td>
<%-- 					<td><%=StringUtil.null2void(dataMap.get("COMPLETE_TIME"))%></td> --%>
					<td>
					<%	
							List<Map<String,String>> ar	= null;
							try {
								Map<String,String> paramR004 = new HashMap<String,String>();
								paramR004.put("BBS_ID", dataMap.get("BBS_ID"));
								ar	= qmsDB.selectList("QMS_BBS_ONELOW.BBS_ATTACHMENT_R004", paramR004);
							} catch (Exception e) {
								if (qmsDB != null) try { qmsDB.close(); } catch (Exception e1) {}
							}
							
							if(null != ar && ar.size() > 0){
								for (int k=0; k<ar.size(); k++) {
					%>
								<a href="#FIT" class="sBtn" onclick="javascript:uf_FileDownLoad('<%=ar.get(k).get("FILE_INFO")%>');"><span><b>첨부<%=k+1 %></b></span></a><br/>
					<%
								}
							}
					%>
					</td>								
				</tr>
				<%
					}
			  	 } // end else
			  	%>
			</tbody>
		</table>
		<div class="paging">
			<ul>
				<li class="bt"><a href="javascript:uf_inq('1')">[First]</a></li>
				<li class="bt"><a href="javascript:uf_inq('<%=page_num - 1%>')">[Prev]</a></li>
	<%		for( int a = startpage; a <= endpage; a++ ) { %>
				<li><a href="#FIT" onclick='javascript:uf_inq(<%=a%>);'>
				<%
					if(a == page_num){ 
						out.print("<B>" + a + "</B>");
					} else { 
						out.print(a);
					} 
				%></a></li>
	<%		}  %>
				<li class="bt"><a href="javascript:uf_inq('<%=page_num + 1%>')">[Next]</a></li>
				<li class="bt"><a href="javascript:uf_inq('<%=tot_page_count%>')">[Last]</a></li>
			</ul>
		</div>
	</div>
 
</form>

<%@ include file="/jsp/inc/inc_bottom.jsp" %>
