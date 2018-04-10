
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

String strBoardId 		=	StringUtil.null2void(request.getParameter("BOARD_ID"));
String strPrjId 		=	StringUtil.null2void(request.getParameter("PROJECT_ID"));
String strBbsId			=	StringUtil.null2void(request.getParameter("BBS_ID"));
String strSeq			=	StringUtil.null2void(request.getParameter("SEQ"));
strPageNum				=	StringUtil.null2void(request.getParameter("PAGE_NUM"));
strDetailState			=	StringUtil.null2void(request.getParameter("DETAIL_STATE"),"");
String today			= 	DateTime.getInstance().getDate("yyyy-mm-dd");

String struserId  		=	StringUtil.null2void((String)userSession.getUserID());
String struserName  	=	StringUtil.null2void((String)userSession.getUserName());

String strRef			=	request.getHeader("referer").substring(request.getHeader("referer").indexOf("QMS")-1,request.getHeader("referer").lastIndexOf("."));

List<Map<String,String>> statsMapList=null;
Map<String,String> statsMap = null;
//수정시
if("U".equals(strDetailState)){
	try{
		Map<String,String> param = new HashMap<String,String>();
		param.put("BOARD_ID",strBoardId);
		param.put("BBS_ID",strBbsId);
		param.put("SEQ",strSeq);
		
		statsMap	=	qmsDB.selectOne("QMS_BBS_NOTICE.BOARD_R003", param);
	
		//파일테이블
		Map<String,String> param2	=	new HashMap<String,String>();
		param2.put("BBS_ID",strBbsId);
		
		statsMapList	=	qmsDB.selectList("QMS_BBS_NOTICE.BBS_ATTACHMENT_R001", param2);
		
	}catch(Exception e){
		LogUtil.getInstance().debug(e);
		if (qmsDB != null)try {qmsDB.close();} catch (Exception e1) {}
	}
}

strTitle			= StringUtil.null2void(statsMap.get("TITLE"));			//제목
strContents 		= StringUtil.null2void(statsMap.get("CONTENTS"));		//내용
strDepth			= StringUtil.null2void(statsMap.get("DEPTH"));			//단계
strfileFlag 		= StringUtil.null2void(statsMap.get("BBS_FILE"));		//파일존재여부
strStat  			= StringUtil.null2void(statsMap.get("STATE"));			//상태
struserId  			= StringUtil.null2void(statsMap.get("BBS_USER"));		//사용자
%>
<style type="text/css">

</style>

<script type="text/javascript">
window.onload = event_check;
var uf = 0;
//onload시 수정사항중 상태값 셋팅
function event_check(){
	// 에디터 사용
	CKEDITOR.replace('REG_TEXT');
	//var oEditor = CKEDITOR.instances.REG_TEXT; 
	//oEditor.insertHtml('<%=strContents%>');  
	
	if('<%=strStat%>'=='111'){
		document.getElementById("a").selected = true;
	}else if('<%=strStat%>'=='000'){
		document.getElementById("b").selected = true;
	}else if('<%=strStat%>'=='999'){
		document.getElementById("c").selected = true;
	}
}


//취소
function uf_cancel(param){
	var frm				= document.frm;
	frm.BOARD_ID.value	= param;
	frm.target			= "_self";
	frm.action= "/QMS/jsp/view/bbs/bbs_list_view.jsp";
	frm.submit();
}

//신규저장
function save(){
	var frm				= document.form1;	
	var title			= frm.REG_TITLE.value;
	var text			= CKEDITOR.instances.REG_TEXT.getData();
	var chanel			=frm.CHANEL_NAME.value;
	var inq_date		= Number($("#INQ_DATE1").val().replaceAll("-",""));
	var today_date		= '<%=today%>'.replaceAll("-","");
		today_date		= Number(today_date);
	
	var dat = $("#fileForm").html();
	
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
	
	frm.target			= "_self";
	
	if(ComUtil.isEmpty(dat)) {
		frm.action = "/QMS/jsp/view/bbs/bbs_notice_write_noattach_do.jsp";
		$("#FIEL_EXIST_YN").val("N");
	}else {
		frm.action = "/QMS/jsp/view/bbs/bbs_notice_write_do.jsp";
		$("#FIEL_EXIST_YN").val("Y");
	}
	
	frm.submit();
	
}

//수정
function uf_change(){
	var frm				= 	document.form1;	
	var title			=	frm.REG_TITLE.value;	//제목
	var text			=	frm.REG_TEXT.value;		//내용
	
	frm.target = "_self";
	var dat = $("#fileForm").html();
	var dat2 = $("#prevFileList").html();
	if(ComUtil.isEmpty(dat)&& ComUtil.isEmpty(dat2)) {
		frm.action = "/QMS/jsp/view/bbs/bbs_notice_rewrite_noattach_do.jsp";
		$("#FIEL_EXIST_YN").val("N");
	}else {
		frm.action = "/QMS/jsp/view/bbs/bbs_notice_rewrite_do.jsp";
		$("#FIEL_EXIST_YN").val("Y");
	}
	
	frm.submit();

}

//파일업로드
 var fileIndex = 0;
 
function initFileForm(){
	addFileForm();
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
 

//기존 존재 파일 삭제목록만들기
function uf_prevAttachDel(seq) {
	  var delFile = document.createElement("input");
	  delFile.type = "hidden";
	  delFile.value = seq;
	  delFile.name = "delFile";
	  document.getElementById("form1").appendChild(delFile);
	  document.getElementById("prevFileList").removeChild(document.getElementById("fileInfo_"+seq));
}
</script>
<%@ include file="/jsp/inc/inc_topMenu.jsp" %>
<%@ include file="/jsp/inc/inc_leftMenu.jsp" %>
<form name="frm" method="post">
</form>
 <form name="form1" id="form1" enctype="multipart/form-data" method="post">
 <input type="hidden" name="BOARD_ID" value="<%=strBoardId%>"/><!--  -->
 <input type="hidden" name="BBS_ID" value="<%=strBbsId%>"/><!--  -->
 <input type="hidden" name="SEQ" value="<%=strSeq%>"/><!--  -->
 <input type="hidden" name="PAGE_NUM" value="<%=strPageNum%>"/>
 <input type="hidden" id="FIEL_EXIST_YN" name="FIEL_EXIST_YN"/>
 <input type="hidden" name="DEPTH" value="<%=strDepth%>"/>
 <input type="hidden" name="DETAIL_STATE" value="<%=strDetailState%>"/>

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
						<% if ("U".equals(strDetailState)) { %>
							<a href="#" class="btn" onclick="javascript:uf_change(); return false;"><span>수정</span></a>
						<% } else { %>
							<a href="#" class="btn" onclick="javascript:save(); return false;"><span>작성완료</span></a>
						<% } %>
							<a href="#" class="btn" onclick="javascript:uf_cancel('<%=strBoardId%>'); return false;"><span>취소</span></a>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
</form>
	<%@ include file="/jsp/inc/inc_bottom.jsp"%>