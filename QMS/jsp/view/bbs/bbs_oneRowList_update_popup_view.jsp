<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>

<%@ include file="/jsp/inc/inc_common.jsp"%>
<%@ include file="/jsp/inc/inc_header.jsp"%>
<%
String userID	= StringUtil.null2void(userSession.getUserID());	
String boardID 	= StringUtil.null2void(request.getParameter("BOARD_ID"));
String bbsID 	= StringUtil.null2void(request.getParameter("BBS_ID"));
String recUsers = StringUtil.null2void(request.getParameter("LBRECEIVER"));
String title 	= StringUtil.null2void(request.getParameter("TIT_AND_CONT"));
String pageNum	= StringUtil.null2void(request.getParameter("PAGE_NUM"));
List<Map<String,String>> statsMapList=null;

Map<String,String> statsMap = null;
try{
Map<String,String> param = new HashMap<String,String>();
//파일테이블
Map<String,String> param2 = new HashMap<String,String>();
param2.put("BBS_ID",bbsID);
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

LogUtil.getInstance().debug("SAMGU-bbs_oneRowList_update_popup.jsp >> boardID:"+boardID+", bbsID:"+bbsID+",recUsers:"+recUsers+", title:"+title+", pageNum:"+pageNum);
%>
<script type="text/javascript">
$(document).ready(function(){
	$("#btnUpdate").click(function(){
		
		var form		= document.multiPartForm;
		var title		= $("#sendTitle").val();
		var receiver	= $("#lbReceiver").text();
		
		if (title.trim() == "") {
			alert("메시지를 입력해 주세요");
			$("#sendTitle").focus();
			return false;
		} else if (receiver.trim() == "") {
			alert("받는사람을 선택해 주세요");
			return false;
		} else {
			form.TITLE	= title;
			form.target	= "_self";
			form.action	= "/QMS/jsp/view/bbs/bbs_oneRowList_update_do.jsp";
			form.submit();
		}
	});
	
});
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
	
</script>
<form name="multiPartForm" method="post" id='form1' enctype="multipart/form-data">
<input type="hidden" name="BOARD_ID" value="<%=boardID%>"/>
<input type="hidden" name="BBS_ID"	 value="<%=bbsID%>"/>
<input type="hidden" name="TITLE"    value="<%=title%>"/>
<input type="hidden" name="PAGE_NUM" value="<%=pageNum%>"/>

	<div class="wrap">
		<div id="sendMsgArea">
			<div class="btnWrapl">
				<a href="#" class="btn" onclick="javascript:uf_addReceiver();"><span>참여자</span></a>
				<label id="lbReceiver" name="RECIPIENT_ID"><%=recUsers%></label>
			</div>
			<textarea rows="5" cols="50" id="sendTitle" name="TITLE" placeholder="함께 주고 받을 메시지를 입력하세요." maxlength="50" style="width:97%;"><%=title%></textarea>
			<div>
				<div class="btnWrapC">
					<a href="#" class="btn" id="btnUpdate"><span>수정</span></a>
					<a href="#" class="btn" onclick="javascript:window.close();"><span>취소</span></a>
				</div>
			</div>
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
		</div>
	</div>
</form>