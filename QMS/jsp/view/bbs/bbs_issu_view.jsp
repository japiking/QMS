<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
    
<%@ include file="/jsp/inc/inc_common.jsp" %>
<%@ include file="/jsp/inc/inc_header.jsp" %>

<%
String userId		= StringUtil.null2void(userSession.getUserID());
String projectId	= StringUtil.null2void(userSession.getProjectID()); 
String boardId		= StringUtil.null2void(request.getParameter("BOARD_ID"));
String pageNum		= StringUtil.null2void(request.getParameter("PAGE_NUM"),   "1");
String pageCount	= StringUtil.null2void(request.getParameter("PAGE_COUNT"), "10");
int pageNumberCount = 10;
int start_rowId		= 1;
int end_rowId		= 0;
int page_num		= 1;
int page_count		= 0;
int tot_page_count	= 0;

//페이징관련
int req_cnt			= Integer.parseInt("".equals(pageNum) ? "10" : pageCount);	// 요청건수
int req_page		= Integer.parseInt("".equals(pageNum) ? "1"  : pageNum);	// 요청페이지

int fromcnt			= ((req_page-1)*req_cnt)+1;		// 시작번호
int tocnt			= (req_page*req_cnt);			// 종료번호

String today		= DateTime.getInstance().getDate("yyyy-mm-dd");
String date			= new String();
String new_yn		= "N";
int startpage		= 0;
int endpage			= 0;
int maxpage			= 0;

List<Map<String,String>> list			= null;
Map<String,String> countMap				= null;
List<Map<String,String>> ImpGradeMap	=null;
try{
	Map<String,String> param = new HashMap<String,String>();
	Map<String,String> param2 = new HashMap<String,String>();
	
	//리스트 목록
	param.put("PROJECT_ID"		,projectId);
	param.put("BOARD_ID"		,boardId);
	param.put("RECIPIENT_ID"	,userId);
	param.put("START"			,String.valueOf(fromcnt));
	param.put("END"				,String.valueOf(tocnt));
	
	list = qmsDB.selectList("QMS_BBS_ISSU.BOARD_R001",param);
	
	//카운트값
	param2.put("PROJECT_ID", projectId);
	param2.put("BOARD_ID", boardId);
	param2.put("RECIPIENT_ID", userId);
	
	countMap = qmsDB.selectOne("QMS_BBS_ISSU.BOARD_R002", param2);
	
	//등급값
	ImpGradeMap = qmsDB.selectList("QMS_BBS_ISSU.IMPORTANCE_GRADE");
	
}catch(Exception e){
	LogUtil.getInstance().debug(e);
	if (qmsDB != null) try { qmsDB.close(); } catch (Exception e1) {}
}

int totCount				= StringUtil.null2zero(StringUtil.null2void(countMap.get("COUNT"), "0"));

page_num					= StringUtil.null2zero(pageNum);
page_count					= StringUtil.null2zero(pageCount);
tot_page_count				= totCount / page_count;

if( (totCount % page_count) > 0 ) tot_page_count++;
		
maxpage= tot_page_count; 

startpage	= (((int) ((double)page_num / 10 + 0.9)) - 1) * 10 + 1;
endpage 	= maxpage; 
 
if (endpage>startpage+10-1) endpage=startpage+10-1;

%>
<script type="text/javascript">
$(document).ready(function() {
	
	//달력 이벤트
	 $("#INQ_DATE1").datepicker();
	
	
	$("#sendMsgArea").hide();
	$("#sendTitle").val("");
	$("#lbReceiver").text("");     
	$("#hiddenReceiver").val("");  
	
	$("#sendIn").click(function() {
		$("#sendMsgArea").show();
		$("#sendIn").hide();
		$("#sendTitle").focus();
	});
	
	$("#sendCancel").click(function() {
		$("#lbReceiver").text("");     
		$("#hiddenReceiver").val("");
		$("#sendTitle").val("");
		$("#sendIn").val("");
		$("#sendMsgArea").hide();
		$("#sendIn").show();
		$("#fileForm").remove();
	});
	
	$("#goSend").click(function() {
		$("#sendIn").val("");
		var multipart_form	= document.frm1;
		var title			= $("#sendTitle").val();
		var receiver		= $("#lbReceiver").text();
		var hiddenReceiver	= $("#hiddenReceiver").val();
		var inq_date		= Number($("#INQ_DATE1").val().replaceAll("-",""));
		var today_date		= '<%=today%>'.replaceAll("-","");
			today_date		= Number(today_date);
		if (title.trim() == "") {
			alert("메시지를 입력해 주세요");
			$("#sendTitle").focus();
			return false;
		} else if (receiver.trim() == "" && hiddenReceiver.trim() == "") {
			alert("참여자를 선택해 주세요");
			return false;
		} else if(inq_date < today_date){
			alert("오늘 이후 날자만 선택이 가능합니다.");
			return false;
		}else if($("#proc_userid").val() == ""){
			alert("처리자를 선택해 주세요");
			return false;
		}else if($("#CONFIRM_USER_ID").val() == ""){
			alert("확인자를 선택해 주세요");
			return false;
		}else {
			multipart_form.RECEIVER_LIST.value  = hiddenReceiver;
			multipart_form.TITLE.value				= title;
			multipart_form.target				= "_self";
			multipart_form.action				= "/QMS/jsp/proc/bbs/bbs_issu_do.jsp";
			multipart_form.submit();
		}
		
				
	});
	
	$("#fileAttach").click(function() {
		addFileForm();
	});

	var menu_nm = $("#"+'<%=boardId%>').text();
	$("h3").text(menu_nm);
	
});
 
var fileIndex = 0;
function addFileForm() {
	if(this.fileIndex > 0){
		  document.getElementById("file[" +(this.fileIndex-1) + "]").style.display = "none";
	  }
	  var file = document.createElement("input");
	  file.type = "file";
	  file.id = "file[" + this.fileIndex + "]";
	  file.name = "file[" + (this.fileIndex++) + "]";
	  file.onchange = function(){ addFileForm() };

	  document.getElementById("fileForm").appendChild(file);
	  
	  drawFileList();
}
function drawFileList() {
	var html = "";
	var file;
	
	for (var i = 0; i < this.fileIndex; i++) {
		file = document.getElementById("file[" + i + "]");
		if (file == null) {
	 	continue;
		}
		if (file.value.length == 0){
			continue;
		}
		html += file.value + "&nbsp;<a href=\"javascript:removeFileForm("+i+");\">삭제</a><br />";
	}
	document.getElementById("fileList").innerHTML = html;
}
 
function removeFileForm(index){
	  var child = document.getElementById("file[" + index + "]");
	  document.getElementById("fileForm").removeChild(child);
	  drawFileList();
 }
 
function uf_inq(pagenum) {	// 파라메터 : 조회 페이지
	var form	= document.frm;
	if(pagenum == 0){
		pagenum = '1';
	}
	form.PAGE_NUM.value	= pagenum;
	form.target			= "_self";
	form.action			= "/QMS/jsp/view/bbs/bbs_issu_view.jsp";
	form.submit();
}

function uf_addReceiver() {
	//window.name 		= "oneRowListAddReceiver";
	var form 			= document.frm1;
	var wid	  			= 800;
	var hei   			= 400;
	var LeftPosition	= (screen.width)  ? (screen.width-wid)/2  : 0;
	var TopPosition	 	= (screen.height) ? (screen.height-hei)/2 : 0;
	var setting  		= 'scrollbars=yes,toolbar=yes,resizable=no,width='+wid+',height='+hei+',left='+LeftPosition+',top='+TopPosition;
	window.open('', '_popup', setting);
	form.target			= "_popup";
	form.action			= "/QMS/jsp/view/bbs/issu_receive_popup_view.jsp";
	form.submit();
}

//수정 팝업으로 이동
function uf_oneRowUpdate(boardId,bbsId, titleAdnContens,completionDate,recUserList,pro_nmList,gradeId,recId,procId,comId,comNm) {
	var board			= boardId;
	var bbs 			= bbsId;
	var recUsers 		= recUserList;		// 받는사람리스트(화면출력용데이터)
	var tAC 			= titleAdnContens;	// 타이틀과 내용(한줄게시판의 타이틀과 컨텐츠는 같다.)
	window.name 		= "oneRowListUpdate";

	// 전송데이터 셋팅
	var form 					= document.frm;	// multipart/form-data
	var form1 					= document.frm1;	// multipart/form-data
	form.BOARD_ID.value			= boardId;
	form.BBS_ID.value			= bbsId;
	form.LBRECEIVER.value		= recUsers;
	form.PRO_NM_LIST.value		= pro_nmList;
	form.TIT_AND_CONT.value		= titleAdnContens;
	form.COMPLETION_DATE.value	= completionDate;
	form.GRADE_ID.value			= gradeId
	form.REC_ID.value			= recId;
	form.PROC_ID.value			= procId;
	form.CONFIRM_ID.value		= comId;
	form.CONFIRM_NM.value		= comNm;
	form.PAGE_NUM.value			= '<%=pageNum%>';
	
	// popup창 생성
	var wid	  			= 800;
	var hei   			= 600;
	var LeftPosition	= (screen.width)  ? (screen.width-wid) /2 : 0;
	var TopPosition		= (screen.height) ? (screen.height-hei)/2 : 0;
	var setting  		= 'scrollbars=no,toolbar=yes,resizable=no,width='+wid+',height='+hei+',left='+LeftPosition+',top='+TopPosition;
	window.open('', '_popup', setting);
	form.target			= "_popup";
	form.action			= "/QMS/jsp/view/bbs/bbs_issu_update_view.jsp";
	form.submit();
}

//삭제
function uf_oneRowDelete(boardId, bbsId, bbs_user){
	var board	= boardId;
	var bbs 	= bbsId;
	
	if (confirm("정말로 삭제하시겠습니까?") == true){
		var form				= document.frm;
		form.BOARD_ID.value		= board;
		form.BBS_ID.value		= bbs;
		form.PAGE_NUM.value		= '<%=pageNum%>';
		form.target				= "_self";
		form.action				= "/QMS/jsp/view/bbs/bbs_oneRowList_delete_do.jsp";
		form.submit();
	}
}

/**
 * 답변일 경우 처리 이벤트
 */
function uf_oneRowAnswer(id, name){
	$("#lbReceiver").text(name+"("+id+")");
	$("#hiddenReceiver").val(id);
	$("#sendIn").hide();
	$("#sendMsgArea").show();
	$("#sendTitle").focus();
}

/* 상태처리 */
function processing(code,boradId,bbsId,seq){ 
	var frm						= document.frm;
	frm.STATE.value				= code;
	frm.BOARD_ID.value			= boradId;
	frm.BBS_ID.value			= bbsId;
	frm.SEQ.value				= seq;
	frm.target					= "_self";
	frm.action					= "/QMS/jsp/proc/bbs/bbs_issu_state_do.jsp";
	frm.submit();
}

/* 히스토리등록 */
 function histoInsert(bbsId,seq,depth,con){
	var frm						= document.frm;
	frm.BBS_ID.value			= bbsId;
	frm.BOARD_ID.value			= '<%=boardId%>';
	frm.SEQ.value				= seq;
	frm.DEPTH.value				= depth;
	frm.CONFIRM.value			= con;
	frm.target					= "_self";
	frm.action					= "/QMS/jsp/view/bbs/bbs_history_view.jsp";
	frm.submit();
}

//처리자 선택
function uf_search(){
	var cw=screen.availWidth;     //화면 넓이
	var ch=screen.availHeight;    //화면 높이
	
	sw=800;    //띄울 창의 넓이
	sh=400;    //띄울 창의 높이
	ml=(cw-sw)/2;        //가운데 띄우기위한 창의 x위치
	mt=(ch-sh)/2;         //가운데 띄우기위한 창의 y위치
	window.open('','_popup2','width='+sw+',height='+sh+',top='+mt+',left='+ml+',resizable=no,scrollbars=yes');
	
	frm.target			= "_popup2";
	frm.action			= "/QMS/jsp/view/bbs/bbs_popup_issu_view.jsp";
	frm.submit();
}

//확인자 선택
function uf_src_confirm(){
	var cw=screen.availWidth;     //화면 넓이
	var ch=screen.availHeight;    //화면 높이
	
	sw=800;    //띄울 창의 넓이
	sh=400;    //띄울 창의 높이
	ml=(cw-sw)/2;        //가운데 띄우기위한 창의 x위치
	mt=(ch-sh)/2;         //가운데 띄우기위한 창의 y위치
	window.open('','_popup3','width='+sw+',height='+sh+',top='+mt+',left='+ml+',resizable=no,scrollbars=yes');
	
	frm.target			= "_popup3";
	frm.action			= "/QMS/jsp/view/bbs/bbs_issu_confirm_popup_view.jsp";
	frm.submit();
}
</script>
<%@ include file="/jsp/inc/inc_topMenu.jsp" %>
<%@ include file="/jsp/inc/inc_leftMenu.jsp" %>
<form name="frm" method="post">
	<input type="hidden" name="BOARD_ID"   		value="<%=boardId%>"/>
	<input type="hidden" name="BBS_ID"			value=""/>
	<input type="hidden" name="SEQ"				value=""/>
	<input type="hidden" name="DEPTH"			value=""/>
	<input type="hidden" name="PAGE_NUM"		value="<%=pageNum%>"/>
	<input type="hidden" name="PAGE_COUNT"		value="<%=pageCount%>"/>
	<input type="hidden" name="TIT_AND_CONT" 	value=""/>		<!-- update사용 -->
	<input type="hidden" name="LBRECEIVER"		value=""/>		<!-- update사용 -->
	<input type="hidden" name="STATE"			value=""/>		<!-- 상태값변경 -->
	<input type="hidden" name="COMPLETION_DATE"	value=""/>	<!-- 완료예정일 -->
	<input type="hidden" name="PRO_NM_LIST"		value=""/>		<!-- 처리자명 리스트 -->
	<input type="hidden" name="GRADE_ID"		value=""/>		<!-- 중요도 -->
	<input type="hidden" name="REC_ID" 			value="" />
	<input type="hidden" name="PROC_ID" 		value="" />
	<input type="hidden" name="CONFIRM_ID" 	/>
	<input type="hidden" name="CONFIRM_NM" 	/>
	<input type="hidden" name="CONFIRM" 	/>
	
</form>
<form name="frm1" method="post" enctype="multipart/form-data">
	<input type="hidden" name="BOARD_ID1"	value="<%=boardId%>"/>
	<input type="hidden" name="BBS_ID1"		value=""/>
	<input type="hidden" name="proc_userid" id="proc_userid"	/>
	<input type="hidden" name="CONFIRM_USER_ID" id="CONFIRM_USER_ID"	/>

	<div class="wrap">
		<h3></h3> 
	<!-- 검색기능 start -->
	<%/*
		<div class="btnWrapl">
			<input type="text" id="ipSearch" placeholder="메시지검색"/>
			<a href="#" class="btn" id=""><span>검색</span></a>
		</div>
	*/%>
	<!-- 검색기능 end -->
	<!-- 메시지 보낼글 입력 start -->
		<div>
			<div class="btnWrapl" style="margin-bottom:10px;"> 
				<input type="text" id="sendIn" value="" placeholder="함께 주고 받을 메시지를 입력하세요." style="width:300px;"/>
			</div>
			
			<div id="sendMsgArea">
				<div class="btnWrapl">
					<a href="#" class="btn" onclick="javascript:uf_addReceiver();"><span>참여자</span></a>
					<input id="hiddenReceiver" name="RECEIVER_LIST" type="hidden" value=""/>
					<label id="lbReceiver" name="RECIPIENT_ID"></label>
					
				</div>
				<table>
					<colgroup>
						<col width="10%"/>
						<col width="90%"/>
					</colgroup>
					<tbody>
						<tr>
							<th>완료예정일</th>
							<td>
								<!--  시작일 -->
								<input readonly="readonly" id="INQ_DATE1" name="INQ_DATE1" value="<%=today%>" style="width: 70px"  onclick="javascript:datepicker_view(frm.INQ_DATE1);" />
								<!-- <a href="#FIT" onclick="javascript:openCalendar(frm1.INQ_DATE1);"><img src="/QMS/img/btn_s_cal.gif" alt="달력" class="bt_i"></a> -->
							</td>
						</tr>
						<tr>
							<th>중요도</th>
							<td>
								<select name="IMPGRADE">
								<%for(int i = 0; i<ImpGradeMap.size();i++){ %>
									<option value="<%=ImpGradeMap.get(i).get("IMPORTANCE_GRADE_ID")%>"><%=ImpGradeMap.get(i).get("KR_IMPORTANCE_GRADE")%></option>
								<%}%>
								</select>
							</td>
						</tr>
						<tr>
							<th>처리자</th>
							<td>
								<a href="#FIT" class="btn" onclick="javascript:uf_search();"><span>검색</span></a>
								<span id="proc_usernm"></span>
							</td>
						</tr>
						<tr>
							<th>확인자(이슈제기자)</th>
							<td>
								<a href="#FIT" class="btn" onclick="javascript:uf_src_confirm();"><span>검색</span></a>
								<span id="CONFIRM_USER_NM"></span>
							</td>
						</tr>
					</tbody>
				</table>
				<br/>
				<textarea rows="5" cols="50" id="sendTitle" name="TITLE" placeholder="함께 주고 받을 메시지를 입력하세요." value="" maxlength="50" style="width:97%;"></textarea>
				<div>
					<div class="btnWrapR">
						<!-- <a href="#" class="btn" id="fileAttach"><span>첨부파일</span></a> -->
						<a href="#" class="btn" id="goSend"><span>작성</span></a>
						<a href="#" class="btn" id="sendCancel"><span>취소</span></a>
					</div>
					<div class="btnWrapL">
						<div id="fileForm"></div>
					    <div id="fileList"></div>
						<!-- <div id="fileForm">
							<input type="file" value="" style="display:none;"/>
						</div> -->
					</div>
				</div>
			</div>
		</div>
	<!-- 메시지 보낼글 입력 end -->
	
	<!-- 송수신 메시지 리스트 start -->
		<table class="list">
			<colgroup>
				<col width="5%"/>
				<col width="25%"/>
				<col width="8%"/>
				<col width="8%"/>
				<col width="8%"/>
				<col width="5%"/>
				<col width="8%"/>
				<col width="8%"/>
				<col width="8%"/>
				<col width="8%"/>
				<col width="8%"/>
				<col width="*"/>
			</colgroup>
			<thead>
				<tr>
					<th scope="col" style="text-align: center;">전송</th>
					<th scope="col" style="text-align: center;">메시지</th>
					<th scope="col" style="text-align: center;">중요도</th>
					<th scope="col" style="text-align: center;">상태</th>
					<th scope="col" style="text-align: center;">상태변경</th>
					<th scope="col" style="text-align: center;">수정/삭제</th>
					<th scope="col" style="text-align: center;">보낸사람</th>
					<th scope="col" style="text-align: center;">확인자</th>				
					<th scope="col" style="text-align: center;">등록일자</th>
					<th scope="col" style="text-align: center;">완료예정일</th>
					<th scope="col" style="text-align: center;">완료일</th>				
					<th scope="col" style="text-align: center;">히스토리</th>
				</tr>
			</thead>
			<tbody>
				<% if( list == null || list.size() == 0 ) { %>
				<tr>
					<td colspan="9"><b>조회 데이터가 없습니다.</b></td>
				</tr>
				<% } else {
					Map<String,String> dataMap	= null;
					for (int i = 0; i < list.size(); i++) {
						dataMap	= list.get(i);
						new_yn = "N";// 새글 여부 체크
						date = dataMap.get("BBS_REG_DATE").substring(0,10);
						
						if(today.equals(date)) new_yn = "Y";
						int comDate = Integer.parseInt(dataMap.get("COMPLETION_DATE").substring(0, 10).replaceAll("-",""));
						int intToday = Integer.parseInt(today.replaceAll("-", ""));	
						
						String title = StringUtil.null2void(dataMap.get("TITLE"));
						title = title.replaceAll("<br/>", "");
						if(title.length() > 20)  title = title.substring(0, 19) +" ...";
				%>		
				<tr>
					<td>
					<% if(!(userSession.getUserID().trim()).equals(dataMap.get("BBS_USER").trim())) {	// 받은 메시지일경우 %>		
						<img src="/QMS/img/receive.PNG" width="30" height="30" />
					<% } else {%>
						<img src="/QMS/img/send.PNG" width="30" height="30" />
					<% } %>
					</td>
					<td class="alL">
						<div>
							<span style="font-weight:bold;font-size:15px;">
							<a href="#FIT" onclick="histoInsert('<%=dataMap.get("BBS_ID")%>','<%=dataMap.get("SEQ")%>','<%=dataMap.get("DEPTH")%>','<%=dataMap.get("CONFIRM_NM")%>(<%=dataMap.get("CONFIRM_USER")%>)')"><%=title%></a>
							</span>
							<%if(new_yn.equals("Y")) out.print("<img src='/QMS/img/new.jpg'>");%>
						</div>
						<div style="font-size: 12px; color: gray;">
							<%
								List<Map<String,String>> sublist	= null;
							try{
								Map<String,String> param3 = new HashMap<String,String>();
								param3.put("PROJECT_ID",projectId);
								param3.put("BOARD_ID",boardId);
								param3.put("BBS_ID",dataMap.get("BBS_ID"));
								
								sublist = qmsDB.selectList("QMS_BBS_ISSU.BBS_RECIPIENT_R001", param3);
							}catch(Exception e){
								LogUtil.getInstance().debug(e);
								if (qmsDB != null) try { qmsDB.close(); } catch (Exception e1) {}
							}
							
							String rec_id = "";
							String pro_id = "";
							String rec_nm = "";
							String pro_nm = "";	
							String prc_yn = "";
							String rec_yn = "";
							String re_dvd = "";
							if(null != sublist && 0<sublist.size()){
								for(int k=0; k<sublist.size(); k++){
									Map<String,String> tmp = sublist.get(k);
									prc_yn = tmp.get("PROC_YN");
									rec_yn = tmp.get("REC_YN");
									re_dvd	= StringUtil.null2void(tmp.get("RECIPIENT_DVD"),"");
										if("Y".equals(prc_yn)){
											pro_nm += tmp.get("NAME")+"("+tmp.get("RECIPIENT_ID")+"),";
											pro_id += tmp.get("RECIPIENT_ID")+", ";
											
										}else if("Y".equals(rec_yn)){
											rec_nm += tmp.get("NAME")+"("+tmp.get("RECIPIENT_ID")+"),";
											rec_id += tmp.get("RECIPIENT_ID")+", ";
										}
									
								}
								if(rec_nm.length()!=0){	
									rec_nm = rec_nm.substring(0, rec_nm.lastIndexOf(','));
									rec_id = rec_id.substring(0, rec_id.lastIndexOf(','));
								}
								if(pro_nm.length()!=0){
									pro_nm = pro_nm.substring(0, pro_nm.lastIndexOf(','));
									pro_id = pro_id.substring(0, pro_id.lastIndexOf(','));
								}
							}
							%>
							참여자 : <%=rec_nm%><br>
							처리자: <%=pro_nm%>

						</div>
					</td>
					<td>
						<%if("001".equals(dataMap.get("IMPORTANCE_GRADE_ID"))){%>
							<span style="color: red; font-weight: 900;"  ><%=dataMap.get("KR_IMPORTANCE_GRADE")%></span>
						<%}else if("002".equals(dataMap.get("IMPORTANCE_GRADE_ID"))){%>
							<span style="color: #ff7f00; font-weight: 900;"><%=dataMap.get("KR_IMPORTANCE_GRADE")%></span>
						<%}else if("003".equals(dataMap.get("IMPORTANCE_GRADE_ID"))){%>
							<span style="color:blue; font-weight: 900;"><%=dataMap.get("KR_IMPORTANCE_GRADE")%></span>
						<%}else{%>
							<span style="color: green; font-weight: 900;"><%=dataMap.get("KR_IMPORTANCE_GRADE")%></span>
						<%}%>
					</td>
					<td>
						<%if(intToday > comDate && !"002".equals(dataMap.get("STATE").trim()) && !"999".equals(dataMap.get("STATE").trim()) && !"004".equals(dataMap.get("STATE").trim())){ %>
							지연
						<%}else{%>
							<%if("000".equals(dataMap.get("STATE").trim())){%>
								등록
							<%}else if("001".equals(dataMap.get("STATE").trim())){%>
								처리중
							<%}else if("002".equals(dataMap.get("STATE").trim())){%>
								처리요청
							<%}else if("003".equals(dataMap.get("STATE").trim())){%>
								취소요청
							<%}else if("004".equals(dataMap.get("STATE").trim())){%>
								완료
							<%}%>
						<%}%>
					</td>
					<td>
						<!--
								000 등록
								001처리중
								002처리요청 
								003취소요청
								004완료
								
								
							-최초등록시 자동 open
							-이슈 해결시 버튼이 모두 사라짐
							-취소되면 버튼 모두 사라짐
							-처리중 해결됨과 취소 두개 버튼이 생성
						  -->
						  <%
						  //로그인 사용자가 처리자 체크
						  String strproId="";
						  boolean proFlag = false;
						
						  if(null!= pro_id && pro_id.length() > 0 && !"".equals(pro_id)){
						  String []ar = pro_id.split(",");
							for(int k=0; k<ar.length; k++){
								strproId = StringUtil.null2void(ar[k]).trim();
								if((userSession.getUserID().trim()).equals(strproId)){
									proFlag =true;
								}
							}
						  }
						  %>
						  <%if("01".equals(userSession.getAuthorityGrade()) && userSession.getUserID().trim().equals(dataMap.get("CONFIRM_USER").trim())){ %>
						  	<%if("002".equals(dataMap.get("STATE").trim()) || "003".equals(dataMap.get("STATE").trim())){%>
						  		<a class="btn" onclick="javascript:processing('004','<%=dataMap.get("BOARD_ID")%>','<%=dataMap.get("BBS_ID")%>','<%=dataMap.get("SEQ")%>')"><span>승인</span></a>
						  		<a class="btn" onclick="javascript:processing('000','<%=dataMap.get("BOARD_ID")%>','<%=dataMap.get("BBS_ID")%>','<%=dataMap.get("SEQ")%>')"><span>거부</span></a>
						  	<%}else{%>
						  		-
						  	<%}%>
						  <%}else{%>
							  <%if(intToday > comDate && !"002".equals(dataMap.get("STATE").trim()) && !"999".equals(dataMap.get("STATE").trim()) && !"999".equals(dataMap.get("STATE").trim())){ %>
							  		<%if("Y".equals(dataMap.get("PROC_YN")) || "00".equals(userSession.getAuthorityGrade())){%>
									 	<a class="btn" onclick="javascript:processing('002','<%=dataMap.get("BOARD_ID")%>','<%=dataMap.get("BBS_ID")%>','<%=dataMap.get("SEQ")%>')"><span>처리요청</span></a>
										<a class="btn" onclick="javascript:processing('003','<%=dataMap.get("BOARD_ID")%>','<%=dataMap.get("BBS_ID")%>','<%=dataMap.get("SEQ")%>')"><span>취소요청</span></a>
									<%} else {%>-<%} %>
								<%}else{%>
									 <%if(proFlag || "00".equals(userSession.getAuthorityGrade())){
									 	if("000".equals(dataMap.get("STATE").trim())){%>
										<a class="btn" onclick="javascript:processing('001','<%=dataMap.get("BOARD_ID")%>','<%=dataMap.get("BBS_ID")%>','<%=dataMap.get("SEQ")%>')"><span>처리중</span></a>
										<a class="btn" onclick="javascript:processing('002','<%=dataMap.get("BOARD_ID")%>','<%=dataMap.get("BBS_ID")%>','<%=dataMap.get("SEQ")%>')"><span>처리요청</span></a>
										<a class="btn" onclick="javascript:processing('003','<%=dataMap.get("BOARD_ID")%>','<%=dataMap.get("BBS_ID")%>','<%=dataMap.get("SEQ")%>')"><span>취소요청</span></a>
									<%}else if("001".equals(dataMap.get("STATE").trim())){%>                                                           
										<a class="btn" onclick="javascript:processing('002','<%=dataMap.get("BOARD_ID")%>','<%=dataMap.get("BBS_ID")%>','<%=dataMap.get("SEQ")%>')"><span>처리요청</span></a>
										<a class="btn" onclick="javascript:processing('003','<%=dataMap.get("BOARD_ID")%>','<%=dataMap.get("BBS_ID")%>','<%=dataMap.get("SEQ")%>')"><span>취소요청</span></a>
									<%}else {%>-<%
									  }
								 	} else {%>-<%}
							 }%>
						 <%} %>
					</td>
					<td>
						<%if((userSession.getUserID().trim()).equals(dataMap.get("BBS_USER").trim()) || "00".equals(userSession.getAuthorityGrade()) || proFlag) { // 보낸메시지일 경우 수정할수 있다.%>
							<a href="#FIT" class="btn" onclick="javascript:uf_oneRowUpdate('<%=dataMap.get("BOARD_ID")%>','<%=dataMap.get("BBS_ID")%>','<%=dataMap.get("TITLE").replaceAll("\r\n", "</br>")%>','<%=dataMap.get("COMPLETION_DATE")%>','<%=rec_nm%>','<%=pro_nm%>','<%=dataMap.get("IMPORTANCE_GRADE_ID")%>','<%=rec_id%>','<%=pro_id%>','<%=dataMap.get("CONFIRM_USER")%>','<%=dataMap.get("CONFIRM_NM")%>');"><span>수정</span></a>
							<a href="#FIT" class="btn" onclick="javascript:uf_oneRowDelete('<%=dataMap.get("BOARD_ID")%>','<%=dataMap.get("BBS_ID")%>');" ><span>삭제</span></a>
						<%}%>	
					</td>
					<td><%=dataMap.get("USERNAME")%>(<%=dataMap.get("BBS_USER")%>)</td>
					<td><%=dataMap.get("CONFIRM_NM")%>(<%=dataMap.get("CONFIRM_USER")%>)</td>
					<td><%=dataMap.get("BBS_REG_DATE")%></td>
					<td><%=dataMap.get("COMPLETION_DATE")%></td>
						<%if(null!=dataMap.get("COMPLETE_DATE") && !"".equals(dataMap.get("COMPLETE_DATE"))){ %>
							<td><%=dataMap.get("COMPLETE_DATE")%></td>
						<%}else{%>
							<td>-</td>
						<%}%>
					<td>
						<a class="btn" onclick="histoInsert('<%=dataMap.get("BBS_ID")%>','<%=dataMap.get("SEQ")%>','<%=dataMap.get("DEPTH")%>','<%=dataMap.get("CONFIRM_NM")%>(<%=dataMap.get("CONFIRM_USER")%>)')"><span>등록</span></a>
					</td>
				</tr>	
				<%
						} 
					} 
			  	%>
			</tbody>
		</table>
	<!-- 송수신 메시지 리스트 end -->
	
		<div class="paging">
			<ul>
				<li class="bt"><a href="javascript:uf_inq('1')">[First]</a></li>
				<li class="bt"><a href="javascript:uf_inq('<%=page_num - 1%>')">[Prev]</a></li>
	<% for (int a = startpage; a <= endpage; a++) { %>
				<li><a href="#" onclick='javascript:uf_inq(<%=a%>);'>
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
