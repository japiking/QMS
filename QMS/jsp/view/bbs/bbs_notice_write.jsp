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

String strBoardId 		=	StringUtil.null2void(request.getParameter("BOARD_ID"));
String strPrjId 		=	StringUtil.null2void(request.getParameter("PROJECT_ID"));
String strBbsId			=	StringUtil.null2void(request.getParameter("BBS_ID"));
String strSeq			=	StringUtil.null2void(request.getParameter("SEQ"));
strPageNum				=	StringUtil.null2void(request.getParameter("PAGE_NUM"));
strDetailState			=	StringUtil.null2void(request.getParameter("DETAIL_STATE"),"");
String today			=	DateTime.getInstance().getDate("yyyy-mm-dd");

String struserId  		=	StringUtil.null2void((String)userSession.getUserID());
String struserName  	=	StringUtil.null2void((String)userSession.getUserName());

String strRef			=	request.getHeader("referer").substring(request.getHeader("referer").indexOf("QMS")-1,request.getHeader("referer").lastIndexOf("."));

List<Map<String,String>> statsMapList = null;

//������
if("U".equals(strDetailState)){
	Map<String,String> statsMap = null;
	try {
		Map<String,String> paramR001 = new HashMap<String,String>();
		paramR001.put("BOARD",	String.valueOf(strBoardId));
		paramR001.put("BBS_ID", String.valueOf(strBbsId));
		paramR001.put("SEQ",	String.valueOf(strSeq));
		
		statsMap = qmsDB.selectOne("QMS_BBS_NOTICE.BOARD_R001", paramR001);
	} catch (Exception e) {
		if (qmsDB != null) try { qmsDB.close(); } catch (Exception e1) {};  
	}
	
	strTitle			= StringUtil.null2void(statsMap.get("TITLE"));			//����
	strContents 		= StringUtil.null2void(statsMap.get("CONTENTS"));		//����
	strDepth			= StringUtil.null2void(statsMap.get("DEPTH"));			//�ܰ�
	strfileFlag 		= StringUtil.null2void(statsMap.get("BBS_FILE"));		//�������翩��
	strStat  			= StringUtil.null2void(statsMap.get("STATE"));			//����
	struserId  			= StringUtil.null2void(statsMap.get("BBS_USER"));		//�����
	strChanelName  		= StringUtil.null2void(statsMap.get("CHANEL_NAME"));	//ä�θ�
	List<String> statsParamList2 = new ArrayList();
	//�������̺�
	try {
		Map<String,String> paramR002 = new HashMap<String,String>();
		paramR002.put("BBS_ID", String.valueOf(strBbsId));

		statsMapList = qmsDB.selectList("QMS_BBS_NOTICE.BOARD_R002", paramR002);
	} catch (Exception e) {
		if (qmsDB != null) try { qmsDB.close(); } catch (Exception e1) {}
	}
}

%>
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
	frm.action= "/QMS/jsp/view/bbs/bbs_noticeList_view.jsp";
	frm.submit();
}

//�ű�����
function save(){
	var frm				= document.form1;	
	var title			= frm.REG_TITLE.value;
	var text			= CKEDITOR.instances.REG_TEXT.getData();
	
	var dat = $("#fileForm").html();
	
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
function change(){
	var frm				= 	document.form1;	
	var title			=	frm.REG_TITLE.value;	//����
	var text			=	frm.REG_TEXT.value;		//����

	
	frm.target = "_self";
	var dat = $("#fileForm").html();
	if(ComUtil.isEmpty(dat)) {
		frm.action = "/QMS/jsp/view/bbs/bbs_notice_write_noattach_do.jsp";
		$("#FIEL_EXIST_YN").val("N");
	}else {
		frm.action = "/QMS/jsp/view/bbs/bbs_notice_write_do.jsp";
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
	  
	   html += file.value +
	    "&nbsp;<a href=\"javascript:removeFileForm("
	    + i + ");\">����</a><br />";
	  }
	  document.getElementById("fileList").innerHTML = html;
	 }
 //���ϴٿ�ε�
function uf_FileDownLoad(fnm) {
	location.href = "/QMS/jsp/comm/FileDown.jsp?filename=" + escape(encodeURIComponent(fnm));
}
</script>
<%@ include file="/jsp/inc/inc_topMenu.jsp" %>
<%@ include file="/jsp/inc/inc_leftMenu.jsp" %>
<form name="frm" method="post">
</form>
 <form name="form1" enctype="multipart/form-data" method="post">
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
					    <div id="fileList">
					    <%if("Y".equals(strfileFlag) && null!=statsMapList  && statsMapList.size()!=0){ 
					    	for(int i = 0; i < statsMapList.size();i++	){
					    %>
					    	
					    	<span><%=statsMapList.get(i).get("FILE_NAME")%></span><a href="#">����</a><br>
					    <%
					    	}
					    }
					    %>
					    </div>
  						<a href="javascript:initFileForm();">����÷��</a>
  						<!-- <a href="javascript:sw_file_del();">���ϻ���</a> -->
						
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
				<!-- <tr>
					<th scope="row"><span><a>����</a></span></th>
					<td colspan="2">
						<div>
							���� ����
							<select name="STAT">
								<optgroup label="����">
									<option id="b" value="000">������</option>
									<option id="c" value="999">����</option>
									<option id="a" value="111">�Ϸ�</option>
								</optgroup>
							</select>
						</div>
					</td>
				</tr> -->
				<tr>
					<td colspan="3" style="text-align: right;">
						<%if ("U".equals(strDetailState)) {%>
							<a href="#" class="btn" onclick="javascript:change(); return false;"><span>����</span></a>
						<%} else {%>
							<a href="#" class="btn" onclick="javascript:save(); return false;"><span>�ۼ��Ϸ�</span></a>
						<%}%>
							<a href="#" class="btn" onclick="javascript:uf_cancel('<%=strBoardId%>'); return false;"><span>���</span></a>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
</form>
	<%@ include file="/jsp/inc/inc_bottom.jsp"%>