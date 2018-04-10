
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
//������
if("U".equals(strDetailState)){
	try{
		Map<String,String> param = new HashMap<String,String>();
		param.put("BOARD_ID",strBoardId);
		param.put("BBS_ID",strBbsId);
		param.put("SEQ",strSeq);
		
		statsMap	=	qmsDB.selectOne("QMS_BBS_NOTICE.BOARD_R003", param);
	
		//�������̺�
		Map<String,String> param2	=	new HashMap<String,String>();
		param2.put("BBS_ID",strBbsId);
		
		statsMapList	=	qmsDB.selectList("QMS_BBS_NOTICE.BBS_ATTACHMENT_R001", param2);
		
	}catch(Exception e){
		LogUtil.getInstance().debug(e);
		if (qmsDB != null)try {qmsDB.close();} catch (Exception e1) {}
	}
}

strTitle			= StringUtil.null2void(statsMap.get("TITLE"));			//����
strContents 		= StringUtil.null2void(statsMap.get("CONTENTS"));		//����
strDepth			= StringUtil.null2void(statsMap.get("DEPTH"));			//�ܰ�
strfileFlag 		= StringUtil.null2void(statsMap.get("BBS_FILE"));		//�������翩��
strStat  			= StringUtil.null2void(statsMap.get("STATE"));			//����
struserId  			= StringUtil.null2void(statsMap.get("BBS_USER"));		//�����
%>
<style type="text/css">

</style>

<script type="text/javascript">
window.onload = event_check;
var uf = 0;
//onload�� ���������� ���°� ����
function event_check(){
	// ������ ���
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


//���
function uf_cancel(param){
	var frm				= document.frm;
	frm.BOARD_ID.value	= param;
	frm.target			= "_self";
	frm.action= "/QMS/jsp/view/bbs/bbs_list_view.jsp";
	frm.submit();
}

//�ű�����
function save(){
	var frm				= document.form1;	
	var title			= frm.REG_TITLE.value;
	var text			= CKEDITOR.instances.REG_TEXT.getData();
	var chanel			=frm.CHANEL_NAME.value;
	var inq_date		= Number($("#INQ_DATE1").val().replaceAll("-",""));
	var today_date		= '<%=today%>'.replaceAll("-","");
		today_date		= Number(today_date);
	
	var dat = $("#fileForm").html();
	
	//ä�θ� üũ
	if(chanel.trim()==""){
		alert("ä�θ��� �Է����ּ���");
		frm.CHANEL_NAME.focus();
		return false;
	}
	//���� üũ
	if(title.trim()==""){
		alert("������ �Է��� �ּ���");
		frm.REG_TITLE.focus();
		return false;
	}
	
	//����üũ
	if(text.trim()==""){
		alert("������ �Է��� �ּ���");
		frm.REG_TEXT.focus();
		return false;
	}
	
	if(inq_date < today_date){
		alert("���� ���� ���ڸ� ������ �����մϴ�.");
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

//����
function uf_change(){
	var frm				= 	document.form1;	
	var title			=	frm.REG_TITLE.value;	//����
	var text			=	frm.REG_TEXT.value;		//����
	
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

//���Ͼ��ε�
 var fileIndex = 0;
 
function initFileForm(){
	addFileForm();
}

//���Ͼ��ε�_����
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
	 	html += file.value + "&nbsp;<a href=\"javascript:removeFileForm(" + i + ");\">����</a><br />";
	}
 	document.getElementById("addFileList").innerHTML = html;
}
 //���ϴٿ�ε�
function uf_FileDownLoad(fnm) {
	location.href = "/QMS/jsp/comm/FileDown.jsp?filename=" + escape(encodeURIComponent(fnm));
}
 

//���� ���� ���� ������ϸ����
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
					<th scope="row"><span><a>����</a></span></th>
					<td colspan="2">
						<div>
							<input type="text" name="REG_TITLE" style="width: 99%;"  maxlength="40" value="<%=strTitle%>" />
						</div>
					</td>
				</tr>
				<tr>
					<th scope="row"><span>�ۼ���</span>
					</th>
					<td colspan="2">
						<div>
							<!-- �ۼ��� ID�� �̸�  -->
							<span><%=struserName%>(<%=struserId%>)</span>
						</div>
					</td>
				</tr>
				<tr>
					<th scope="row">
						����÷��
					</th>
					<td colspan="2">
					    <div id="fileForm"></div>
					    <div id="prevFileList">
					    <%if( null!=statsMapList  && statsMapList.size()!=0){ 
					    	for(int i = 0; i < statsMapList.size();i++	){
					    %>
					    	<div id="fileInfo_<%=statsMapList.get(i).get("SEQ")%>"><span><%=statsMapList.get(i).get("FILE_NAME")%></span><a href="#" onclick="javascript:uf_prevAttachDel('<%=statsMapList.get(i).get("SEQ") %>'); return false;">����</a><br></div>
					    <%
					    	}
					    }
					    %>
					    </div>
					    <div id="addFileList"></div>
  						<a href="javascript:initFileForm();">����÷��</a>
						<!-- �����߰��� ����� -->
						<%if("Y".equals(strfileFlag)){ %>
							<span></span>
							<span></span>
						<%}%>
						
					</td>
				</tr>
				<tr>
					<!-- �� �ۼ�  -->
					<th>����</th>
					<td colspan="2">
						<textarea name ="REG_TEXT" id="REG_TEXT" rows="20" cols="" wrap="soft"><%=strContents%></textarea>
					</td>
				</tr>
				<tr>
					<td colspan="3" style="text-align: right;">
						<% if ("U".equals(strDetailState)) { %>
							<a href="#" class="btn" onclick="javascript:uf_change(); return false;"><span>����</span></a>
						<% } else { %>
							<a href="#" class="btn" onclick="javascript:save(); return false;"><span>�ۼ��Ϸ�</span></a>
						<% } %>
							<a href="#" class="btn" onclick="javascript:uf_cancel('<%=strBoardId%>'); return false;"><span>���</span></a>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
</form>
	<%@ include file="/jsp/inc/inc_bottom.jsp"%>