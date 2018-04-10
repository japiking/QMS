
<%@page import="java.util.Map"%>
<%@page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>

<%@ include file="/jsp/inc/inc_common.jsp" %>
<%@ include file="/jsp/inc/inc_header.jsp"%>
<%

String strTitle			=	"";
String strContents 		=	"";
String strDepth			=	"";
String strfileFlag 		=	"";
String strStat  		=	"";
String strPageNum  		=	"";
String struserNm		=	"";
String strDetailState	=	"";
String strChanelName	=	"";
String strCompDate	    =	"";
String strCompDate1	    =	"";


String strBoardId 	=	StringUtil.null2void(request.getParameter("BOARD_ID"));
String strPrjId 	=	StringUtil.null2void(request.getParameter("PROJECT_ID"));
String strBbsId		=	StringUtil.null2void(request.getParameter("BBS_ID"));
String strSeq		=	StringUtil.null2void(request.getParameter("SEQ"));
strDepth			=	StringUtil.null2void(request.getParameter("DEPTH"));
strPageNum			=	StringUtil.null2void(request.getParameter("PAGE_NUM"));
strDetailState		=	StringUtil.null2void(request.getParameter("DETAIL_STATE"),"");
String today		= DateTime.getInstance().getDate("yyyy-mm-dd");

String struserId  	=	StringUtil.null2void((String)userSession.getUserID());
String struserName  =	StringUtil.null2void((String)userSession.getUserName());
String strConfUser  = "";
String strRef		=	request.getHeader("referer").substring(request.getHeader("referer").indexOf("QMS")-1,request.getHeader("referer").lastIndexOf("."));

List<Map<String,String>> statsMapList=null;

//수정시
if("U".equals(strDetailState)){
	Map<String,String> statsMap = null;
	try{
	Map<String,String> param = new HashMap<String,String>();
	
	param.put("BOARD_ID",strBoardId);
	param.put("BBS_ID",strBbsId);
	param.put("SEQ",strSeq);
	param.put("DEPTH",strDepth);
	
	statsMap	= qmsDB.selectOne("QMS_BBS_WRITE.BOARD_R001", param);
	
	strTitle			= StringUtil.null2void(statsMap.get("TITLE"));			//제목
	strConfUser			= StringUtil.null2void(statsMap.get("CONFIRM_USER"));	//확인자
	strContents 		= StringUtil.null2void(statsMap.get("CONTENTS"));		//내용
	strDepth			= StringUtil.null2void(statsMap.get("DEPTH"));			//단계
	strfileFlag 		= StringUtil.null2void(statsMap.get("BBS_FILE"));		//파일존재여부
	strStat  			= StringUtil.null2void(statsMap.get("STATE"));			//상태
	struserId  			= StringUtil.null2void(statsMap.get("BBS_USER"));		//사용자
	strChanelName  		= StringUtil.null2void(statsMap.get("CHANEL_NAME"));	//채널명
	strCompDate  		= StringUtil.null2void(statsMap.get("COMPLETION_DATE"));//완료예정일
	strCompDate1  		= StringUtil.null2void(statsMap.get("COMPLETE_DATE"));  //완료일
	
	//파일테이블
	Map<String,String> param2 = new HashMap<String,String>();
	param2.put("BBS_ID",strBbsId);
	
	statsMapList = qmsDB.selectList("QMS_BBS_WRITE.BBS_ATTACHMENT_R001",param2);	
	
	}catch(Exception e){
		e.printStackTrace(System.out);
		if (qmsDB != null){
	        try { qmsDB.close(); } catch (Exception e1) {}
		}
	}finally{
		if (qmsDB != null){
	        try { qmsDB.close(); } catch (Exception e1) {}
		}
	}
	 
}

%>

<script type="text/javascript">
window.onload = event_check;
brd_id = '<%=strBoardId%>';
var uf = 0;
//onload시 수정사항중 상태값 셋팅
function event_check(){
	// 에디터 사용
	CKEDITOR.replace('REG_TEXT');
	
	 //달력 이벤트
	 $("#INQ_DATE1").datepicker({
		dateFormat : 'yy-mm-dd',
		showAnim: "slideDown"
	});
	 $("#CMPT_DATE1").datepicker({
			dateFormat : 'yy-mm-dd',
			showAnim: "slideDown"
		});
}


//취소
function uf_cancel(param){
	var frm				= document.form1;
	frm.BOARD_ID.value	= param;
	frm.target			= "_self";
	frm.action= "/QMS/jsp/view/bbs/bbs_list_view.jsp";
	frm.submit();
}

//신규저장(답변)
function save(){
	var frm				= document.form1;	
	var title			= frm.REG_TITLE.value;
	var text			= CKEDITOR.instances.REG_TEXT.getData();
	var chanel			= frm.CHANEL_NAME.value;
	var inq_date		= Number($("#INQ_DATE1").val().replaceAll("-",""));
	var today_date		= '<%=today%>'.replaceAll("-","");
		today_date		= Number(today_date);
		frm.BOARD_ID.value	= brd_id;
	var dat = $("#fileForm").html();
	var confirm = $("#confirm_usernm").text();
	
	//채널명 체크
	if(chanel.trim()==""){
		alert("채널명을 입력해주세요");
		frm.CHANEL_NAME.focus();
		return false;
	}
	//제목 체크
	if(title.trim()==""){
		alert("제목을 입력해 주세요");
		frm.REG_TITLE.focus();
		return false;
	}
	
	//내용체크
	if(text.trim()==""){
		alert("내용을 입력해 주세요");
		frm.REG_TEXT.focus();
		return false;
	}
	
	if(inq_date < today_date){
		alert("오늘 이후 날자만 선택이 가능합니다.");
		frm.INQ_DATE1.focus();
		return false;
	}
	
	if(confirm == ""){
		alert("확인자는 필수입니다.");
		return false;
	}
	
	frm.CONFIRM_USER_PROC.value = confirm;
	frm.target			= "_self";
	
	if(ComUtil.isEmpty(dat)) {
		frm.action = "/QMS/jsp/view/bbs/bbs_write_noattach_do.jsp";
		$("#FIEL_EXIST_YN").val("N");
	}else {
		frm.action = "/QMS/jsp/view/bbs/bbs_write_do.jsp";
		$("#FIEL_EXIST_YN").val("Y");
	}
	
	frm.submit();
	
}

//수정
function change(){
	var frm				= 	document.form1;	
	var title			=	frm.REG_TITLE.value;	//제목
	var text			=	frm.REG_TEXT.value;		//내용
	frm.BOARD_ID.value	= brd_id;
	
	frm.target = "_self";
	var dat = $("#fileForm").html();
	var dat2 = $("#prevFileList").html();
	var confirm = $("#confirm_usernm").text();
	
	if(confirm == ""){
		alert("확인자는 필수입니다.");
		return false;
	}
	
	frm.CONFIRM_USER_PROC.value = confirm;
	
	if(ComUtil.isEmpty(dat) && ComUtil.isEmpty(dat2)) {
		frm.action = "/QMS/jsp/view/bbs/bbs_rewrite_noattach_do.jsp";
		$("#FIEL_EXIST_YN").val("N");
	}else {
		frm.action = "/QMS/jsp/view/bbs/bbs_rewrite_do.jsp";
		$("#FIEL_EXIST_YN").val("Y");
	}
	
	frm.submit();

}

//파일업로드_삭제
var fileIndex = 0;

function initFileForm(){
	addFileForm();
}

function addFileForm(){
	var file = document.createElement("input");
	file.type = "file";
	file.id = "file[" + this.fileIndex + "]";
	file.name = "file[" + (this.fileIndex++) + "]";
	file.onchange = function(){ this.style.display="none";drawFileList(); };
	document.getElementById("fileForm").appendChild(file);
}
function removeFileForm(index){
	var child = document.getElementById("file[" + index + "]");
	document.getElementById("fileForm").removeChild(child);
	drawFileList();
}

function drawFileList(){
	var html = "";
	var file;

	for(var i = 0; i < this.fileIndex; i++){
  		file = document.getElementById("file[" + i + "]");
	  	if(file == null){
	   		continue;
	  	}
	 	if(file.value.length == 0){
	   		continue;
	  	}
	 	html += file.value + "&nbsp;<a href=\"javascript:removeFileForm(" + i + ");\">삭제</a><br />";
	}
 	document.getElementById("addFileList").innerHTML = html;
}
//파일다운로드
function uf_FileDownLoad(fnm) {
	location.href = "/QMS/jsp/comm/FileDown.jsp?filename=" + escape(encodeURIComponent(fnm));
}

 
// 기존 존재 파일 삭제목록만들기
function uf_prevAttachDel(seq) {
	  var delFile = document.createElement("input");
	  delFile.type = "hidden";
	  delFile.value = seq;
	  delFile.name = "delFile";
	  document.getElementById("form1").appendChild(delFile);
	  document.getElementById("prevFileList").removeChild(document.getElementById("fileInfo_"+seq));
}

//처리자 id 찾기
function uf_search(){
	var cw=screen.availWidth;     //화면 넓이
	var ch=screen.availHeight;    //화면 높이
	
	sw=800;    //띄울 창의 넓이
	sh=400;    //띄울 창의 높이
	ml=(cw-sw)/2;        //가운데 띄우기위한 창의 x위치
	mt=(ch-sh)/2;         //가운데 띄우기위한 창의 y위치
	window.open('','EXCEL','width='+sw+',height='+sh+',top='+mt+',left='+ml+',resizable=no,scrollbars=yes');
	
	frm.target			= "EXCEL";
	frm.action			= "/QMS/jsp/view/bbs/bbs_userSearch_popup_view.jsp";
	frm.submit();
}
</script>

<%@ include file="/jsp/inc/inc_topMenu.jsp" %>
<%@ include file="/jsp/inc/inc_leftMenu.jsp" %>
<form name="frm" method="post" id="frm">
</form>
 <form name="form1" id="form1" enctype="multipart/form-data" method="post">
 <input type="hidden" name="BOARD_ID" value="<%=strBoardId%>"/><!--  -->
 <input type="hidden" name="BBS_ID" value="<%=strBbsId%>"/><!--  -->
 <input type="hidden" name="SEQ" value="<%=strSeq%>"/><!--  -->
 <input type="hidden" name="PAGE_NUM" value="<%=strPageNum%>"/>
 <input type="hidden" id="FIEL_EXIST_YN" name="FIEL_EXIST_YN"/>
 <input type="hidden" name="DEPTH" value="<%=strDepth%>"/>
 <input type="hidden" name="DETAIL_STATE" value="<%=strDetailState%>"/>
 <input type="hidden" name="CONFIRM_USER_PROC" />

	<div class="wrap">
		<table>
			<colgroup>
				<col class="item">
				<col class="opt">
				<col class="quickAddr">
			</colgroup>
			<tbody>
				<tr>
					<th scope="row"><span><a>제목</a></span></th>
					<td colspan="2">
						<div>
							<input type="text" name="REG_TITLE" style="width: 99%;"  maxlength="40" value="<%=strTitle%>" />
						</div>
					</td>
				</tr>
				<tr>
					<th scope="row"><span><a>채널명</a></span></th>
					<td colspan="2">
						<div>
							<input type="text" name="CHANEL_NAME"  maxlength="15" size="20" value="<%=strChanelName%>" />
						</div>
					</td> 
				</tr>
				<tr>
					<th scope="row"><span><a>예정일</a></span></th>
					<td colspan="2">
						<div class="btnWrapL">
						<%if("U".equals(strDetailState)){%>
							<%-- <input readonly="readonly" id="INQ_DATE1" name="INQ_DATE1" value="<%=today%>" style="width: 70px" /> --%><!--  시작일 -->
							<input readonly="readonly" id="INQ_DATE1" name="INQ_DATE1" value="<%=strCompDate%>" style="width: 70px"  onclick="javascript:datepicker_view(frm.INQ_DATE1);" />
						<%}else{%>
							<%-- <input readonly="readonly" id="INQ_DATE1" name="INQ_DATE1" value="<%=today%>" style="width: 70px"  onclick="javascript:openCalendar(form1.INQ_DATE1);" /> --%><!--  시작일 -->
							<input readonly="readonly" id="INQ_DATE1" name="INQ_DATE1" value="<%=today%>" style="width: 70px"  onclick="javascript:datepicker_view(frm.INQ_DATE1);" />
							<!-- <a href="#FIT" onclick="javascript:openCalendar(form1.INQ_DATE1);"><img src="/QMS/img/btn_s_cal.gif" alt="달력" class="bt_i"></a> -->
						<%}%>
						</div>
					</td>
				</tr>
				<%if("U".equals(strDetailState)){%>
				<tr>
					<th scope="row"><span><a>완료일</a></span></th>
					<td colspan="2">
						<div class="btnWrapL">
							<input readonly="readonly" id="CMPT_DATE1" name="CMPT_DATE1" value="<%=strCompDate1%>" style="width: 70px"  onclick="javascript:datepicker_view(frm.CMPT_DATE1);" />
						</div>
					</td>
				</tr>
				<%}%>
				<tr>
					<th scope="row"><span>작성자</span>
					</th>
					<td colspan="2">
						<div>
							<!-- 작성자 ID나 이름  -->
							<span><%=struserName%>(<%=struserId%>)</span>
						</div>
					</td>
				</tr>
				<tr>
					<th scope="row"><span>확인자</span>
					<td colspan="2">
						<span id="confirm_usernm"><%=strConfUser%></span>
						<a href="#FIT" class="btn" onclick="javascript:uf_search();"><span>찾기</span></a>
					</td>
				</tr>
				<tr>
					<th scope="row">
						파일첨부
					</th>
					<td colspan="2">
					    <div id="fileForm"></div>
					    <div id="prevFileList">
					    <%if( null!=statsMapList  && statsMapList.size()!=0){ 
					    	for(int i = 0; i < statsMapList.size();i++	){
					    %>
					    	<div id="fileInfo_<%=statsMapList.get(i).get("SEQ")%>"><span><%=statsMapList.get(i).get("FILE_NAME")%></span><a href="#" onclick="javascript:uf_prevAttachDel('<%=statsMapList.get(i).get("SEQ") %>'); return false;">삭제</a><br></div>
					    <%
					    	}
					    }
					    %>
					    </div>
					    <div id="addFileList"></div>
  						<a href="javascript:initFileForm();">파일첨부</a>
						<!-- 파일추가및 존재시 -->
						<%if("Y".equals(strfileFlag)){ %>
							<span></span>
							<span></span>
						<%}%>
						
					</td>
				</tr>
				<tr>
					<!-- 글 작성  -->
					<th>내용</th>
					<td colspan="2">
						<textarea name ="REG_TEXT" id="REG_TEXT" rows="20" cols="" wrap="soft"><%=strContents%></textarea>
					</td>
				</tr>
				<tr>
					<td colspan="3" style="text-align: right;">
						<%if("U".equals(strDetailState)){%>
							<a href="#" class="btn" onclick="javascript:change(); return false;"><span>수정</span></a>
						<%}else{%>
							<a href="#" class="btn" onclick="javascript:save(); return false;"><span>작성완료</span></a>
						<%}%>
							<a href="#" class="btn" onclick="javascript:uf_cancel('<%=strBoardId%>'); return false;"><span>취소</span></a>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
</form>
	<%@ include file="/jsp/inc/inc_bottom.jsp"%>