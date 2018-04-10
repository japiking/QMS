<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
    
<%@ include file="/jsp/inc/inc_common.jsp" %>
<%@ include file="/jsp/inc/inc_header.jsp" %>

<%
String today		= DateTime.getInstance().getDate("yyyy-mm-dd");
String inq_date		= StringUtil.null2void(request.getParameter("INQ_DATE1"), today);
String userId		= StringUtil.null2void(userSession.getUserID());
String projectId	= StringUtil.null2void(userSession.getProjectID()); 
String boardId		= StringUtil.null2void(request.getParameter("BOARD_ID"));
String pageNum      = StringUtil.null2void(request.getParameter("PAGE_NUM"), "1");
String pageCount	= StringUtil.null2void(request.getParameter("PAGE_COUNT"), "10");
int pageNumberCount = 10;
int start_rowId		= 1;
int end_rowId		= 0;
int page_num		= 1;
int page_count		= 0;
int tot_page_count	= 0;

//����¡����
int req_cnt			= Integer.parseInt("".equals(pageNum) ? "10" : pageCount);	// ��û�Ǽ�
int req_page		= Integer.parseInt("".equals(pageNum) ? "1"  : pageNum);	// ��û������
int fromcnt			= ((req_page-1)*req_cnt)+1;		// ���۹�ȣ
int tocnt			= (req_page*req_cnt);			// �����ȣ
List<Map<String,String>> list	= null;

// �ıǰԽ��� ��� ��ȸ
try {
	Map<String,String> paramR001 = new HashMap<String,String>();
	paramR001.put("PROJECT_ID",		projectId);              
	paramR001.put("BOARD_ID",		String.valueOf(boardId));
	paramR001.put("RECIPIENT_ID",	String.valueOf(userId)); 
	paramR001.put("FROMCNT",		String.valueOf(fromcnt));
	paramR001.put("TOCNT",			String.valueOf(tocnt));
	paramR001.put("BBS_REG_DATE",	String.valueOf(inq_date));
	
	
	list = qmsDB.selectList("QMS_BBS_MEALTICKET.BOARD_R001", paramR001);
} catch (Exception e) {
	if (qmsDB != null) try { qmsDB.close(); } catch (Exception e1) {}
}


String date			= new String();
String new_yn		= "N";
int startpage		= 0;
int endpage			= 0;
int maxpage			= 0;
Map<String,String> countMap	= null;

// �ıǰԽ��Ǹ�� �Ǽ� ��ȸ
try {
	Map<String,String> paramR002 = new HashMap<String,String>();
	paramR002.put("PROJECT_ID",		projectId);              
	paramR002.put("BOARD_ID",		String.valueOf(boardId));
	paramR002.put("RECIPIENT_ID",	String.valueOf(userId)); 
	paramR002.put("BBS_REG_DATE",	String.valueOf(inq_date));
	
	countMap	= qmsDB.selectOne("QMS_BBS_MEALTICKET.BOARD_R002", paramR002);
	
} catch (Exception e) {
	if(qmsDB !=null) try { qmsDB.close(); } catch (Exception e1) {}
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
		if (title.trim() == "") {
			alert("�޽����� �Է��� �ּ���");
			$("#sendTitle").focus();
			return false;
		} else if (receiver.trim() == "" && hiddenReceiver.trim() == "") {
			alert("�޴»���� ������ �ּ���");
			return false;
		} else {
			multipart_form.RECEIVER_LIST.value  = hiddenReceiver;
			multipart_form.TITLE.value				= title;
			multipart_form.target				= "_self";
			multipart_form.action				= "/QMS/jsp/view/bbs/bbs_oneRowList_write_do.jsp";
			multipart_form.submit();
		}
	});
	
	$("#fileAttach").click(function() {
		addFileForm();
	});
	$("#INQ_DATE1").datepicker();
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
		html += file.value + "&nbsp;<a href=\"javascript:removeFileForm("+i+");\">����</a><br />";
	}
	document.getElementById("fileList").innerHTML = html;
}
 
function removeFileForm(index) {
	  var child = document.getElementById("file[" + index + "]");
	  document.getElementById("fileForm").removeChild(child);
	  drawFileList();
}
 
/**
 * ����¡ ó��
 */
function uf_inq(pagenum) {	// �Ķ���� : ��ȸ ������
	var form			= document.frm;
	if (null == pagenum || pagenum == 0) {
		pagenum = '1';
	}
	form.BOARD_ID.value	= '<%=boardId%>';
	form.PAGE_NUM.value	= pagenum;
	form.INQ_DATE1.value = $("#INQ_DATE1").val();
	form.target			= "_self";
	form.action			= "/QMS/jsp/view/bbs/bbs_mealTicket_view.jsp";
	form.submit();
}

function uf_addReceiver() {
	window.name 		= "oneRowListAddReceiver";
	var form 			= document.frm1;
	var wid	  			= 800;
	var hei   			= 400;
	var LeftPosition	= (screen.width)  ? (screen.width-wid)/2  : 0;
	var TopPosition	 	= (screen.height) ? (screen.height-hei)/2 : 0;
	var setting  		= 'scrollbars=no,toolbar=yes,resizable=no,width='+wid+',height='+hei+',left='+LeftPosition+',top='+TopPosition;
	window.open('', '_popup', setting);
	form.target			= "_popup";
	form.action			= "/QMS/jsp/view/bbs/bbs_receive_popup_view.jsp";
	form.submit();
}

function uf_oneRowUpdate(boardId, bbsId, recUserList, titleAdnContens) {
	var board			= boardId;
	var bbs 			= bbsId;
	var recUsers 		= recUserList;		// �޴»������Ʈ(ȭ����¿뵥����)
	var tAC 			= titleAdnContens;	// Ÿ��Ʋ�� ����(���ٰԽ����� Ÿ��Ʋ�� �������� ����.)
	//alert(boardId+","+bbsId+","+recUserList+","+titleAdnContens);
	window.name 		= "oneRowListUpdate";

	// ���۵����� ����
	var form 				= document.frm;	// multipart/form-data
	form.BOARD_ID.value		= boardId;
	form.BBS_ID.value		= bbsId;
	form.LBRECEIVER.value	= recUsers;
	form.TIT_AND_CONT.value	= titleAdnContens;
	form.PAGE_NUM.value		= '<%=pageNum%>';
	
	// popupâ ����
	var wid	  			= 900;
	var hei   			= 300;
	var LeftPosition	= (screen.width)  ? (screen.width-wid) /2 : 0;
	var TopPosition		= (screen.height) ? (screen.height-hei)/2 : 0;
	var setting  		= 'scrollbars=no,toolbar=yes,resizable=no,width='+wid+',height='+hei+',left='+LeftPosition+',top='+TopPosition;
	window.open('', '_popup', setting);
	form.target			= "_popup";
	form.action			= "/QMS/jsp/view/bbs/bbs_oneRowList_update_popup_view.jsp";
	form.submit();
}

function uf_oneRowDelete(boardId, bbsId, bbs_user){
	var board	= boardId;
	var bbs 	= bbsId;
	
	if (confirm("������ �����Ͻðڽ��ϱ�?") == true){
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
 * �亯�� ��� ó�� �̺�Ʈ
 */
function uf_oneRowAnswer(id, name) {
	$("#lbReceiver").text(name+"("+id+")");
	$("#hiddenReceiver").val(id);
	$("#sendIn").hide();
	$("#sendMsgArea").show();
	$("#sendTitle").focus();
}

/**
 * ���� �ٿ�ε�
 */
function uf_FileDownLoad(fnm) {
	if("NO_FILE" != fnm){
		location.href = "/QMS/jsp/comm/FileDown.jsp?filename=" + escape(encodeURIComponent(fnm));
	}
}


</script>
<%@ include file="/jsp/inc/inc_topMenu.jsp" %>
<%@ include file="/jsp/inc/inc_leftMenu.jsp" %>
<form name="frm" method="post">
<%-- <input type="hidden" name="PROJECT_ID" value=""/> --%><!-- inc_leftMenu setting -->
<%-- <input type="hidden" name="BOARD_ID"	value=""/> --%><!-- inc_leftMenu setting -->
	<input type="hidden" name="BOARD_ID"   value="<%=boardId%>"/>
	<input type="hidden" name="BBS_ID"		value=""/>
	<input type="hidden" name="SEQ"			value=""/>
	<input type="hidden" name="PAGE_NUM"	value="<%=pageNum%>"/>
	<input type="hidden" name="PAGE_COUNT"	value="<%=pageCount%>"/>
	<input type="hidden" name="TIT_AND_CONT"value=""/><!-- update��� -->
	<input type="hidden" name="LBRECEIVER"	value=""/><!-- update��� -->
	<input type="hidden" name="INQ_DATE1"	value="<%=inq_date%>"/><!-- uf_inq()���� ���	 -->
	
</form>
<form name="frm1" method="post" enctype="multipart/form-data">
	<input type="hidden" name="BOARD_ID1"	value="<%=boardId%>"/>
	<input type="hidden" name="BBS_ID1"		value=""/>

	<div class="wrap">
		<h3>�ıǰ���</h3>
	<!-- �޷� start -->
		<div class="btnWrapR">
			<input readonly="readonly" id="INQ_DATE1" name="INQ_DATE1" value="<%=inq_date%>" style="width: 70px" /><!--  ������ -->
			<a href="#FIT" class="btn" onclick="javascript:uf_inq();"><span>��ȸ</span></a>
		</div>
	<!-- �˻���� end -->
	<!-- �޽��� ������ �Է� start -->
		<div>
			<div class="btnWrapl" style="margin-bottom:10px;"> 
				<input type="text" id="sendIn" value="" placeholder="�Բ� �ְ� ���� �޽����� �Է��ϼ���." style="width:300px;"/>
			</div>
			
			<div id="sendMsgArea">
				<div class="btnWrapl">
					<a href="#" class="btn" onclick="javascript:uf_addReceiver();"><span>������</span></a>
					<input id="hiddenReceiver" name="RECEIVER_LIST" type="hidden" value=""/>
					<label id="lbReceiver" name="RECIPIENT_ID"></label>
				</div>
				<br/>
				<textarea rows="5" cols="50" id="sendTitle" name="TITLE" placeholder="�Բ� �ְ� ���� �޽����� �Է��ϼ���." value="" maxlength="50" style="width:97%;"></textarea>
				<div>
					<div class="btnWrapR">
						<a href="#" class="btn" id="fileAttach"><span>÷������</span></a>
						<a href="#" class="btn" id="goSend"><span>�ۼ�</span></a>
						<a href="#" class="btn" id="sendCancel"><span>���</span></a>
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
	<!-- �޽��� ������ �Է� end -->
	
	<!-- �ۼ��� �޽��� ����Ʈ start -->
		<table class="list">
			<colgroup>
				<col width="5%"/>
				<col width="50%"/>
				<col width="15%"/>
				<col width="10%"/>
				<col width="15%"/>
				<col width="5%"/>
			</colgroup>
			<thead>
				<tr>
					<th scope="col" style="text-align: center;">����</th>
					<th scope="col">�޽���</th>
					<th scope="col" style="text-align: center;">����/����/�亯</th>
					<th scope="col" style="text-align: center;">�������</th>				
					<th scope="col" style="text-align: center;">�ð�</th>		
					<th scope="col" style="text=align: center;">÷��</th>
				</tr>
			</thead>
			<tbody>
				<% if( list == null || list.size() == 0 ) { %>
				<tr>
					<td colspan="7"><b>��ȸ �����Ͱ� �����ϴ�.</b></td>
				</tr>
				<% } else {
					LogUtil.getInstance().debug("");
					String rec_id				= "";
					Map<String,String> dataMap	= null;
					for (int i = 0; i < list.size(); i++) {
						dataMap	= list.get(i);
						new_yn = "N";// ���� ���� üũ
						date = dataMap.get("BBS_REG_DATE").substring(0,10);
						if(today.equals(date)) new_yn = "Y";
				%>		
				<tr>
					<td>
					<% if("R".equals(dataMap.get("RECIPIENT_DVD"))) {	// ���� �޽����ϰ�� %>		
						<img src="/QMS/img/receive.PNG" width="30" height="30" />
					<% } else {%>
						<img src="/QMS/img/send.PNG" width="30" height="30" />
					<% } %>
					</td>
					<td class="alL">
						<div>
							<span style="font-weight:bold;font-size:15px;"><%=dataMap.get("TITLE")%></span><%if(new_yn.equals("Y")) out.print("<img src='/QMS/img/new.jpg'>");%>
						</div>
						<div style="font-size: 12px; color: gray;">
					<%
						try {
							// �Խù��� �ش��ϴ� ����� ���� �ҷ�����
							Map<String, String> paramR003 = new HashMap<String,String>();
							paramR003.put("PROJECT_ID", projectId);
							paramR003.put("BOARD_ID",	boardId);
							paramR003.put("BBS_ID", 	dataMap.get("BBS_ID"));
							
							List<Map<String,String>> sublist = qmsDB.selectList("QMS_BBS_MEALTICKET.BBS_RECIPIENT_R003", paramR003);
							
							rec_id = "";
							for(int k=0; k<sublist.size(); k++){
								Map<String,String> tmp = sublist.get(k);
								rec_id += tmp.get("NAME")+" ";
							}
							out.print(rec_id);
						} catch (Exception e) {
							LogUtil.getInstance().debug("SAMGU ERROR3" + e.toString());
							e.printStackTrace();
							if (qmsDB != null) try { qmsDB.close(); } catch (Exception e1) {}
						}
					%>
						</div>
					</td>
					<td>
					<%	if ("S".equals(dataMap.get("RECIPIENT_DVD")) || "00".equals(userSession.getAuthorityGrade())) { // �����޽����� ��� �����Ҽ� �ִ�.%>
						<a href="#FIT" class="btn" onclick="javascript:uf_oneRowUpdate('<%=dataMap.get("BOARD_ID")%>','<%=dataMap.get("BBS_ID")%>','<%=rec_id%>','<%=dataMap.get("TITLE")%>');" ><span>����</span></a>
						<a href="#FIT" class="btn" onclick="javascript:uf_oneRowDelete('<%=dataMap.get("BOARD_ID")%>','<%=dataMap.get("BBS_ID")%>');" ><span>����</span></a>
					<%  } else { %>
<%-- 						<a href="#FIT" class="btn" onclick="javascript:uf_oneRowDetail('<%=dataMap.get("BOARD_ID")%>','<%=dataMap.get("BBS_ID")%>');" ><span>�󼼺���</span></a> --%>
							<a href="#FIT" class="btn" onclick="javascript:uf_oneRowAnswer('<%=dataMap.get("BBS_USER")%>', '<%=dataMap.get("USERNAME")%>');" ><span>�亯</span></a>
					<%  } %>
					</td>
					<td><%=dataMap.get("USERNAME")%>(<%=dataMap.get("BBS_USER")%>)</td>
					<td><%=dataMap.get("BBS_REG_DATE")%></td>
					<td>
					<%	
						if (!dataMap.get("BBS_FILE").equals("N")) {
							List<Map<String,String>> ar	= null;
							try {
								Map<String,String> paramR004 = new HashMap<String,String>();
								paramR004.put("BBS_ID", dataMap.get("BBS_ID"));
								ar	= qmsDB.selectList("QMS_BBS_ONELOW.BBS_ATTACHMENT_R004", paramR004);
							} catch (Exception e) {
								LogUtil.getInstance().debug("SAMGU ERROR4:" + e.toString());
								e.printStackTrace();
								if (qmsDB != null) try { qmsDB.close(); } catch (Exception e1) {}
							}
							for (int k=0; k<ar.size(); k++) {
					%>
								<a href="#FIT" class="sBtn" onclick="javascript:uf_FileDownLoad('<%=ar.get(k).get("FILE_INFO")%>');"><span><b>÷��<%=k+1 %></b></span></a><br/>
					<%
							}
						}	
					%>
					</td>
				</tr>
				<%
					} //end for
				} //end else
			  	%>
			</tbody>
		</table>
	<!-- �ۼ��� �޽��� ����Ʈ end -->
	
		<div class="paging">
			<ul>
				<li class="bt"><a href="javascript:uf_inq('1')">[First]</a></li>
				<li class="bt"><a href="javascript:uf_inq('<%=page_num - 1%>')">[Prev]</a></li>
	<%		for (int a = startpage; a <= endpage; a++) { %>
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
