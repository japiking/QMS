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

//����¡����
int req_cnt			= Integer.parseInt("".equals(pageNum) ? "10" : pageCount);	// ��û�Ǽ�
int req_page		= Integer.parseInt("".equals(pageNum) ? "1"  : pageNum);	// ��û������

int fromcnt			= ((req_page-1)*req_cnt)+1;		// ���۹�ȣ
int tocnt			= (req_page*req_cnt);			// �����ȣ

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
	
	//����Ʈ ���
	param.put("PROJECT_ID"		,projectId);
	param.put("BOARD_ID"		,boardId);
	param.put("RECIPIENT_ID"	,userId);
	param.put("START"			,String.valueOf(fromcnt));
	param.put("END"				,String.valueOf(tocnt));
	
	list = qmsDB.selectList("QMS_BBS_ISSU.BOARD_R001",param);
	
	//ī��Ʈ��
	param2.put("PROJECT_ID", projectId);
	param2.put("BOARD_ID", boardId);
	param2.put("RECIPIENT_ID", userId);
	
	countMap = qmsDB.selectOne("QMS_BBS_ISSU.BOARD_R002", param2);
	
	//��ް�
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
	
	//�޷� �̺�Ʈ
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
			alert("�޽����� �Է��� �ּ���");
			$("#sendTitle").focus();
			return false;
		} else if (receiver.trim() == "" && hiddenReceiver.trim() == "") {
			alert("�����ڸ� ������ �ּ���");
			return false;
		} else if(inq_date < today_date){
			alert("���� ���� ���ڸ� ������ �����մϴ�.");
			return false;
		}else if($("#proc_userid").val() == ""){
			alert("ó���ڸ� ������ �ּ���");
			return false;
		}else if($("#CONFIRM_USER_ID").val() == ""){
			alert("Ȯ���ڸ� ������ �ּ���");
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
		html += file.value + "&nbsp;<a href=\"javascript:removeFileForm("+i+");\">����</a><br />";
	}
	document.getElementById("fileList").innerHTML = html;
}
 
function removeFileForm(index){
	  var child = document.getElementById("file[" + index + "]");
	  document.getElementById("fileForm").removeChild(child);
	  drawFileList();
 }
 
function uf_inq(pagenum) {	// �Ķ���� : ��ȸ ������
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

//���� �˾����� �̵�
function uf_oneRowUpdate(boardId,bbsId, titleAdnContens,completionDate,recUserList,pro_nmList,gradeId,recId,procId,comId,comNm) {
	var board			= boardId;
	var bbs 			= bbsId;
	var recUsers 		= recUserList;		// �޴»������Ʈ(ȭ����¿뵥����)
	var tAC 			= titleAdnContens;	// Ÿ��Ʋ�� ����(���ٰԽ����� Ÿ��Ʋ�� �������� ����.)
	window.name 		= "oneRowListUpdate";

	// ���۵����� ����
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
	
	// popupâ ����
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

//����
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
function uf_oneRowAnswer(id, name){
	$("#lbReceiver").text(name+"("+id+")");
	$("#hiddenReceiver").val(id);
	$("#sendIn").hide();
	$("#sendMsgArea").show();
	$("#sendTitle").focus();
}

/* ����ó�� */
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

/* �����丮��� */
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

//ó���� ����
function uf_search(){
	var cw=screen.availWidth;     //ȭ�� ����
	var ch=screen.availHeight;    //ȭ�� ����
	
	sw=800;    //��� â�� ����
	sh=400;    //��� â�� ����
	ml=(cw-sw)/2;        //��� �������� â�� x��ġ
	mt=(ch-sh)/2;         //��� �������� â�� y��ġ
	window.open('','_popup2','width='+sw+',height='+sh+',top='+mt+',left='+ml+',resizable=no,scrollbars=yes');
	
	frm.target			= "_popup2";
	frm.action			= "/QMS/jsp/view/bbs/bbs_popup_issu_view.jsp";
	frm.submit();
}

//Ȯ���� ����
function uf_src_confirm(){
	var cw=screen.availWidth;     //ȭ�� ����
	var ch=screen.availHeight;    //ȭ�� ����
	
	sw=800;    //��� â�� ����
	sh=400;    //��� â�� ����
	ml=(cw-sw)/2;        //��� �������� â�� x��ġ
	mt=(ch-sh)/2;         //��� �������� â�� y��ġ
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
	<input type="hidden" name="TIT_AND_CONT" 	value=""/>		<!-- update��� -->
	<input type="hidden" name="LBRECEIVER"		value=""/>		<!-- update��� -->
	<input type="hidden" name="STATE"			value=""/>		<!-- ���°����� -->
	<input type="hidden" name="COMPLETION_DATE"	value=""/>	<!-- �ϷΌ���� -->
	<input type="hidden" name="PRO_NM_LIST"		value=""/>		<!-- ó���ڸ� ����Ʈ -->
	<input type="hidden" name="GRADE_ID"		value=""/>		<!-- �߿䵵 -->
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
	<!-- �˻���� start -->
	<%/*
		<div class="btnWrapl">
			<input type="text" id="ipSearch" placeholder="�޽����˻�"/>
			<a href="#" class="btn" id=""><span>�˻�</span></a>
		</div>
	*/%>
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
				<table>
					<colgroup>
						<col width="10%"/>
						<col width="90%"/>
					</colgroup>
					<tbody>
						<tr>
							<th>�ϷΌ����</th>
							<td>
								<!--  ������ -->
								<input readonly="readonly" id="INQ_DATE1" name="INQ_DATE1" value="<%=today%>" style="width: 70px"  onclick="javascript:datepicker_view(frm.INQ_DATE1);" />
								<!-- <a href="#FIT" onclick="javascript:openCalendar(frm1.INQ_DATE1);"><img src="/QMS/img/btn_s_cal.gif" alt="�޷�" class="bt_i"></a> -->
							</td>
						</tr>
						<tr>
							<th>�߿䵵</th>
							<td>
								<select name="IMPGRADE">
								<%for(int i = 0; i<ImpGradeMap.size();i++){ %>
									<option value="<%=ImpGradeMap.get(i).get("IMPORTANCE_GRADE_ID")%>"><%=ImpGradeMap.get(i).get("KR_IMPORTANCE_GRADE")%></option>
								<%}%>
								</select>
							</td>
						</tr>
						<tr>
							<th>ó����</th>
							<td>
								<a href="#FIT" class="btn" onclick="javascript:uf_search();"><span>�˻�</span></a>
								<span id="proc_usernm"></span>
							</td>
						</tr>
						<tr>
							<th>Ȯ����(�̽�������)</th>
							<td>
								<a href="#FIT" class="btn" onclick="javascript:uf_src_confirm();"><span>�˻�</span></a>
								<span id="CONFIRM_USER_NM"></span>
							</td>
						</tr>
					</tbody>
				</table>
				<br/>
				<textarea rows="5" cols="50" id="sendTitle" name="TITLE" placeholder="�Բ� �ְ� ���� �޽����� �Է��ϼ���." value="" maxlength="50" style="width:97%;"></textarea>
				<div>
					<div class="btnWrapR">
						<!-- <a href="#" class="btn" id="fileAttach"><span>÷������</span></a> -->
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
					<th scope="col" style="text-align: center;">����</th>
					<th scope="col" style="text-align: center;">�޽���</th>
					<th scope="col" style="text-align: center;">�߿䵵</th>
					<th scope="col" style="text-align: center;">����</th>
					<th scope="col" style="text-align: center;">���º���</th>
					<th scope="col" style="text-align: center;">����/����</th>
					<th scope="col" style="text-align: center;">�������</th>
					<th scope="col" style="text-align: center;">Ȯ����</th>				
					<th scope="col" style="text-align: center;">�������</th>
					<th scope="col" style="text-align: center;">�ϷΌ����</th>
					<th scope="col" style="text-align: center;">�Ϸ���</th>				
					<th scope="col" style="text-align: center;">�����丮</th>
				</tr>
			</thead>
			<tbody>
				<% if( list == null || list.size() == 0 ) { %>
				<tr>
					<td colspan="9"><b>��ȸ �����Ͱ� �����ϴ�.</b></td>
				</tr>
				<% } else {
					Map<String,String> dataMap	= null;
					for (int i = 0; i < list.size(); i++) {
						dataMap	= list.get(i);
						new_yn = "N";// ���� ���� üũ
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
					<% if(!(userSession.getUserID().trim()).equals(dataMap.get("BBS_USER").trim())) {	// ���� �޽����ϰ�� %>		
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
							������ : <%=rec_nm%><br>
							ó����: <%=pro_nm%>

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
							����
						<%}else{%>
							<%if("000".equals(dataMap.get("STATE").trim())){%>
								���
							<%}else if("001".equals(dataMap.get("STATE").trim())){%>
								ó����
							<%}else if("002".equals(dataMap.get("STATE").trim())){%>
								ó����û
							<%}else if("003".equals(dataMap.get("STATE").trim())){%>
								��ҿ�û
							<%}else if("004".equals(dataMap.get("STATE").trim())){%>
								�Ϸ�
							<%}%>
						<%}%>
					</td>
					<td>
						<!--
								000 ���
								001ó����
								002ó����û 
								003��ҿ�û
								004�Ϸ�
								
								
							-���ʵ�Ͻ� �ڵ� open
							-�̽� �ذ�� ��ư�� ��� �����
							-��ҵǸ� ��ư ��� �����
							-ó���� �ذ�ʰ� ��� �ΰ� ��ư�� ����
						  -->
						  <%
						  //�α��� ����ڰ� ó���� üũ
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
						  		<a class="btn" onclick="javascript:processing('004','<%=dataMap.get("BOARD_ID")%>','<%=dataMap.get("BBS_ID")%>','<%=dataMap.get("SEQ")%>')"><span>����</span></a>
						  		<a class="btn" onclick="javascript:processing('000','<%=dataMap.get("BOARD_ID")%>','<%=dataMap.get("BBS_ID")%>','<%=dataMap.get("SEQ")%>')"><span>�ź�</span></a>
						  	<%}else{%>
						  		-
						  	<%}%>
						  <%}else{%>
							  <%if(intToday > comDate && !"002".equals(dataMap.get("STATE").trim()) && !"999".equals(dataMap.get("STATE").trim()) && !"999".equals(dataMap.get("STATE").trim())){ %>
							  		<%if("Y".equals(dataMap.get("PROC_YN")) || "00".equals(userSession.getAuthorityGrade())){%>
									 	<a class="btn" onclick="javascript:processing('002','<%=dataMap.get("BOARD_ID")%>','<%=dataMap.get("BBS_ID")%>','<%=dataMap.get("SEQ")%>')"><span>ó����û</span></a>
										<a class="btn" onclick="javascript:processing('003','<%=dataMap.get("BOARD_ID")%>','<%=dataMap.get("BBS_ID")%>','<%=dataMap.get("SEQ")%>')"><span>��ҿ�û</span></a>
									<%} else {%>-<%} %>
								<%}else{%>
									 <%if(proFlag || "00".equals(userSession.getAuthorityGrade())){
									 	if("000".equals(dataMap.get("STATE").trim())){%>
										<a class="btn" onclick="javascript:processing('001','<%=dataMap.get("BOARD_ID")%>','<%=dataMap.get("BBS_ID")%>','<%=dataMap.get("SEQ")%>')"><span>ó����</span></a>
										<a class="btn" onclick="javascript:processing('002','<%=dataMap.get("BOARD_ID")%>','<%=dataMap.get("BBS_ID")%>','<%=dataMap.get("SEQ")%>')"><span>ó����û</span></a>
										<a class="btn" onclick="javascript:processing('003','<%=dataMap.get("BOARD_ID")%>','<%=dataMap.get("BBS_ID")%>','<%=dataMap.get("SEQ")%>')"><span>��ҿ�û</span></a>
									<%}else if("001".equals(dataMap.get("STATE").trim())){%>                                                           
										<a class="btn" onclick="javascript:processing('002','<%=dataMap.get("BOARD_ID")%>','<%=dataMap.get("BBS_ID")%>','<%=dataMap.get("SEQ")%>')"><span>ó����û</span></a>
										<a class="btn" onclick="javascript:processing('003','<%=dataMap.get("BOARD_ID")%>','<%=dataMap.get("BBS_ID")%>','<%=dataMap.get("SEQ")%>')"><span>��ҿ�û</span></a>
									<%}else {%>-<%
									  }
								 	} else {%>-<%}
							 }%>
						 <%} %>
					</td>
					<td>
						<%if((userSession.getUserID().trim()).equals(dataMap.get("BBS_USER").trim()) || "00".equals(userSession.getAuthorityGrade()) || proFlag) { // �����޽����� ��� �����Ҽ� �ִ�.%>
							<a href="#FIT" class="btn" onclick="javascript:uf_oneRowUpdate('<%=dataMap.get("BOARD_ID")%>','<%=dataMap.get("BBS_ID")%>','<%=dataMap.get("TITLE").replaceAll("\r\n", "</br>")%>','<%=dataMap.get("COMPLETION_DATE")%>','<%=rec_nm%>','<%=pro_nm%>','<%=dataMap.get("IMPORTANCE_GRADE_ID")%>','<%=rec_id%>','<%=pro_id%>','<%=dataMap.get("CONFIRM_USER")%>','<%=dataMap.get("CONFIRM_NM")%>');"><span>����</span></a>
							<a href="#FIT" class="btn" onclick="javascript:uf_oneRowDelete('<%=dataMap.get("BOARD_ID")%>','<%=dataMap.get("BBS_ID")%>');" ><span>����</span></a>
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
						<a class="btn" onclick="histoInsert('<%=dataMap.get("BBS_ID")%>','<%=dataMap.get("SEQ")%>','<%=dataMap.get("DEPTH")%>','<%=dataMap.get("CONFIRM_NM")%>(<%=dataMap.get("CONFIRM_USER")%>)')"><span>���</span></a>
					</td>
				</tr>	
				<%
						} 
					} 
			  	%>
			</tbody>
		</table>
	<!-- �ۼ��� �޽��� ����Ʈ end -->
	
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
