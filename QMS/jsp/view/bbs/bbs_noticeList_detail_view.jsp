<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
    
<%@ include file="/jsp/inc/inc_common.jsp" %>
<%@ include file="/jsp/inc/inc_header.jsp" %>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="qms.util.StringUtil"%>
<%
	String referer					= request.getHeader("referer");
	String grade 					= StringUtil.null2void(userSession.getAuthorityGrade());
	String returnUrl				= "/" + referer.substring(referer.indexOf("QMS"));
	
//	LogUtil.getInstance().debug("SAMGU  returnUrl>>"+returnUrl);
	
	String userId					= StringUtil.null2void(userSession.getUserID());
	String userName					= StringUtil.null2void(userSession.getUserName());
	String boardID 					= StringUtil.null2void(request.getParameter("BOARD_ID"));
	String bbsID 					= StringUtil.null2void(request.getParameter("BBS_ID"));
	String seq 						= StringUtil.null2void(request.getParameter("SEQ"));
	String pageNum					= StringUtil.null2void(request.getParameter("PAGE_NUM"));
	String depth					= StringUtil.null2void(request.getParameter("DEPTH"));
//	LogUtil.getInstance().debug("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<depth:"  + depth);
//	LogUtil.getInstance().debug("SAMGU detailpage boardID:" +boardID+ ", bbsID:"+ bbsID +", seq:"+ seq +", depth:"+ depth );
	StringBuffer countSql			= new StringBuffer();
	StringBuffer boardSql			= new StringBuffer();
	StringBuffer commentSql			= new StringBuffer();
	List<String> countParamList		= new ArrayList();
	List<String> boardList			= new ArrayList();
	List<String> commentList		= new ArrayList(); 
	Object[] countParam				= null;
	Map<String,String> boardParam	= new HashMap<String,String>();
	Object[] commentParam			= null;
	List<Map<String,String>> list	= null;
	List<Map<String,String>> resultCommentList = null;
	Map<String,String> dataMap		= null;
	
	String state 					= new String();
	List<Map<String,String>> attach_list	= null;
	
	// ��ȸ�� ����
	try {
		Map<String,String> paramU001 = new HashMap<String,String>();
		paramU001.put("BOARD_ID",	boardID);
		paramU001.put("BBS_ID", 	bbsID);			
		paramU001.put("SEQ", 		seq);			
		paramU001.put("DEPTH",		depth);			

		int bb = qmsDB.update("QMS_BBS_DETAIL.BOARD_U001", paramU001);

	} catch (Exception e) {
		if (qmsDB != null)
			try {
				qmsDB.close();
			} catch (Exception e1) {
			}
		LogUtil.getInstance().info(
				"��ȸ�� ������ query error : " + e.toString());
	}

	// �Խñ� ��ȸ
	try {
		Map<String, String> paramR001 = new HashMap<String, String>();
		paramR001.put("BOARD_ID", boardID);
		paramR001.put("BBS_ID", bbsID);
		paramR001.put("SEQ", seq);
		paramR001.put("DEPTH", depth);

		list = qmsDB.selectList("QMS_BBS_DETAIL.BOARD_R004", paramR001);

		LogUtil.getInstance().info("SAMGU >>> value:" + list);

	} catch (Exception e) {
		if (qmsDB != null)
			try {
				qmsDB.close();
			} catch (Exception e1) {
			}
		LogUtil.getInstance().info(
				"�Խñ� ��ȸ query error : " + e.toString());
	}
%>
<style type="text/css">
	.u_board {
		border: solid red 1px;
	}
	.u_comment {
		border: solid blue 1px;
	}
</style>

<script type="text/javascript">
function uf_goList() {
	var frm 				= document.frm;
	frm.BOARD_ID.value		= '<%=boardID%>';
	frm.target				= "_self";
	frm.action				= '<%=returnUrl%>';
	frm.submit();
}

function uf_goUpdate() {
	var frm 				= document.frm;
	frm.DETAIL_STATE.value	= "U";	// ����
	//alert("samgu DETAIL_STATE : "+ frm.DETAIL_STATE.value);
	frm.BOARD_ID.value		= '<%=boardID%>';
	frm.target				= "_self";
	frm.action				= "/QMS/jsp/view/bbs/bbs_noticeList_write_view.jsp";
	frm.submit();
}

function uf_goDelete() {
	
	if (confirm("������ �����Ͻðڽ��ϱ�?") == true){
		var frm 			= document.frm;
		frm.BOARD_ID.value	= '<%=boardID%>';
		frm.DEPTH.value		= '<%=depth%>';
		frm.target			= "_self";
		frm.action			= "/QMS/jsp/view/bbs/bbs_delete_do.jsp";
		frm.submit();
	}
}

function uf_goComment() {
	var frm 				= document.frm;
	var contents			= frm.CONTENTS.value;
	if (contents.trim() == "") {
		alert("����� �Է����ֽñ� �ٶ��ϴ�.");
		frm.CONTENTS.focus();
		return false;
	} else {
		frm.DEPTH.value		= '<%=depth%>';
		frm.BOARD_ID.value	= '<%=boardID%>';
		frm.target			= "_self";
		frm.action			= "/QMS/jsp/view/bbs/bbs_comment_do.jsp";
		frm.submit();f
	}
}

function uf_deleteComment(bbsID,commentID) {
	if (confirm("������ �����Ͻðڽ��ϱ�?") == true){
		var ajax = jex.createAjaxUtil("comment_delete_do");	// ȣ���� ������
		ajax.set("TASK_PACKAGE",    "bbs" );				// [�ʼ�]���� package ȣ���� ������ ��Ű
		ajax.set("BBS_ID",   bbsID );	
		ajax.set("COMMENT_ID",commentID );	
		ajax.execute(function(dat) {
			var data = dat["_tran_res_data"][0];
			var result = data.RESULT;
			if(result == "Y"){
				uf_loadComment();
			}else{
				alert("���� �� ������ �߻� �Ǿ����ϴ�");
			}
		});
	}
}

function uf_insertComment() {
	// �����  
	var contents			= frm.CONTENTS.value;
	if (contents.trim() == "") {
		alert("����� �Է����ֽñ� �ٶ��ϴ�.");
		frm.CONTENTS.focus();
		return false;
	}
	var ajax = jex.createAjaxUtil("comment_insert_do");	// ȣ���� ������
	ajax.set("TASK_PACKAGE",    "bbs" );				// [�ʼ�]���� package ȣ���� ������ ��Ű
	ajax.set("BOARD_ID", "<%=boardID%>" );	 						
	ajax.set("BBS_ID",   "<%=bbsID%>" );	
	ajax.set("CONTENTS", contents );
	ajax.execute(function(dat) {
		var data = dat["_tran_res_data"][0];
		var result = data.RESULT;
		if(result == "Y"){
			frm.CONTENTS.value = "";
			uf_loadComment();
			frm.CONTENTS.focus();
		}else{
			alert("��� �� ������ �߻� �Ǿ����ϴ�");
		}
	});
}


function uf_loadComment(){
	try {
		var ajax = jex.createAjaxUtil("comment_load_do");	// ȣ���� ������

		// �����         		
		ajax.set("TASK_PACKAGE",    "bbs" );	 						// [�ʼ�]���� package ȣ���� ������ ��Ű

		// ������
		ajax.set("BBS_ID",    "<%=bbsID%>" );		
		ajax.execute(function(dat) {
			try{
				var data = dat["_tran_res_data"][0];
				var commentList = data.LIST;
				if ( commentList.length==0){
					$("#commentArea").html("<span><b>��ȸ�� ����� �����ϴ�.</b></span>");
				}else{
					var commentCount = data.LIST.length;
					var innerHtml = "<h4>��� "+commentCount+"</h4>"+
					"<table class=\"mgT10\">"+
						"<colgroup>"+
							"<col width=\"10%\"/>"+
							"<col width=\"*\"/>"+
							"<col width=\"10%\"/>"+
							"<col width=\"5%\"/>"+
						"</colgroup>"+
						"<tbody>";
					var user_id = '<%=userSession.getUserID()%>';
					var grade = '<%=userSession.getAuthorityGrade()%>';
					for (var i=0; i< commentCount; i++) { 
						var comment =  data.LIST[i]; 
						innerHtml+=	"<tr><th scope=\"row\">"+comment.USERNAME+"("+comment.USERID+")"+"</th>";	
						if(comment.COMMENT_USER == user_id || grade == "00"){	// �ۼ��ڰ� �ڱ��ڽ��̰ų� �����ڴ� ���������� �����ϴ�.
							innerHtml+= "<td>"+comment.CONTENTS+"</td>";
							innerHtml+= "<td>"+comment.COMMENT_REG_DATE+"</td>";
							innerHtml+= "<td>";
							if( comment.COMMENT_USER == user_id){
								innerHtml+="	<a href=\"#FIT\" class=\"btn\" onclick=\"javascript:uf_deleteComment(\'"+comment.BBS_ID+"\',\'"+comment.COMMENT_ID+"\');\" ><span style='color:blue;'>����</span></a>";
							}else{
								innerHtml+="	<a href=\"#FIT\" class=\"btn\" onclick=\"javascript:uf_deleteComment(\'"+comment.BBS_ID+"\',\'"+comment.COMMENT_ID+"\');\" ><span style='color:red;'>����</span></a>";
							}
							innerHtml+="</td></tr>";
						} else {
							innerHtml+= "<td colspan='2'>"+comment.CONTENTS+"</td>";
							innerHtml+="</tr>";
						}
					}		
					innerHtml+="</tbody></table>";
					$("#commentArea").html(innerHtml);
				}
			} catch(e) {bizException(e, "error");}
		});
	} catch(e) {bizException(e, "error");}
}

function uf_goCommentDelete(bbsID, CommentID){
	if (confirm("������ �����Ͻðڽ��ϱ�?") == true){
		var frm 			= document.frm;
		frm.BBS_ID.value	= bbsID;
		frm.COMMENT_ID.value= CommentID;
		frm.BOARD_ID.value	= '<%=boardID%>';
		frm.target			= "_self";
		frm.action			= "/QMS/jsp/view/bbs/bbs_comment_delete_do.jsp";
		frm.submit();
	}
}

<%-- function uf_goAnswer(){
	var frm 				= document.frm;
	frm.DETAIL_STATE.value  = "A";	// ���
	frm.BOARD_ID.value			= '<%=boardID%>';
	frm.target				= "_self";
	frm.action				= "/QMS/jsp/view/bbs/bbs_noticeList_write_view.jsp";
	frm.submit();
} --%>

function uf_FileDownLoad(fnm) {
	location.href = "/QMS/jsp/comm/FileDown.jsp?filename=" + escape(encodeURIComponent(fnm));
}

$(document).ready(function(){
	uf_loadComment();
});
</script>
<%@ include file="/jsp/inc/inc_topMenu.jsp" %>
<%@ include file="/jsp/inc/inc_leftMenu.jsp" %>
<form name="frm" method="post">
	<input type="hidden" name="COMMENT_ID"	value="" />
  	<input type="hidden" name="BOARD_ID"	/>
  	<input type="hidden" name="BBS_ID"		value='<%=bbsID%>' />
  	<input type="hidden" name="SEQ"			value='<%=seq%>' />
  	<input type="hidden" name="PAGE_NUM"	value='<%=pageNum%>' />
  	<input type="hidden" name="DETAIL_STATE"value="" />
  	<input type="hidden" name="DEPTH"		value="" />
	<div class="wrap">
		<h3>����</h3>
		<div class="btnWrapR">
			<a href="#" class="btn" onclick="javascript:uf_goList();"><span>����Ʈ��</span></a>
		<% if (list == null || list.size() == 0) { %>
			<span>��ȸ�� �����Ͱ� �����ϴ�.</span>
		<% } else {
			dataMap	= list.get(0);  // ù��° �����ʹ� �Խñ�
			state = dataMap.get("STATE");
			if 		("000".equals(state)) { state = "����";}
			else if ("111".equals(state)) { state = "�Ϸ�";}
			else if ("999".equals(state)) { state = "����";}
			if ("Y".equals(dataMap.get("BBS_FILE"))) {
				boardParam.put("BBS_ID", bbsID);
				attach_list		= qmsDB.selectList("QMS_BBS_LIST.BBS_ATTACHMENT_R001", boardParam);
			} if (userId.equals(dataMap.get("BBS_USER")) || "00".equals(grade)) { %>
			<a href="#" class="btn" onclick="javascript:uf_goUpdate();"><span>����</span></a>
			<a href="#" class="btn" onclick="javascript:uf_goDelete();"><span>����</span></a>
		<%	} if ("00".equals(grade) && "1".equals(depth)) { %>
			<!-- <a href="#" class="btn" onclick="javascript:uf_goAnswer();"><span>�亯</span></a> -->
		<%
			} // end if
		} // end else 
		%>
		</div>
			<table class="mgT10">
				<colgroup>
					<col width="15%"/>
					<col width="*"/>
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">���NO</th>			
						<td><%=dataMap.get("SEQ")%></td>
					</tr>
					<tr>
						<th scope="row">����</th>			
						<td><%=dataMap.get("TITLE")%></td>
					</tr>
					<tr>	
						<th scope="row">�ۼ���</th>			
						<td><%=dataMap.get("USERNAME")%>(<%=dataMap.get("BBS_USER")%>)</td>								
					</tr>
					<tr>	
						<th scope="row">�����</th>			
						<td><%=dataMap.get("BBS_REG_DATE")%></td>								
					</tr>
					<tr>	
						<th scope="row">��ȸ��</th>			
						<td><%=dataMap.get("COUNT")%></td>								
					</tr>
					<%-- <tr>	
						<th scope="row">ó������</th>			
						<td><%=state%></td>								
					</tr> --%>
					<tr>
						<th scope="row">����</th>			
						<td style="height: 250px; width: 400px"><%=dataMap.get("CONTENTS")%></td>
					</tr>
					<tr>
						<th scope="row">÷������</th>
						<td class="wBtn">
							<% 
							if (null != attach_list &&  attach_list.size() > 0) {
								String file = "";
								for (int i=0; i<attach_list.size(); i++) {
									Map<String,String> tempMap	= attach_list.get(i);
									file = tempMap.get("FILE_PATH")+"/"+tempMap.get("FILE_NAME");
							%>
									<a href="#FIT" class="sBtn" onclick="javascript:uf_FileDownLoad('<%=file%>');"><span><b><%=tempMap.get("FILE_NAME")%></b></span></a>
							<%
								} // end for
							} // end if
							%>
						</td>				
					</tr>									
				</tbody>
			</table>
			
			<br/>
			<p style="height: 2px; background: #d7dadf;"/>
			<br/>
		<div id="commentArea"></div>
		<div>
			<h4>��۾���</h4>
			<div class="btnWrapR">
				<span>���� ����� : <%=userName%>(<%=userSession.getUserID()%>)</span>
				<textarea rows="5" cols="50" name="CONTENTS" value="" maxlength="50"></textarea>
				<a href="#" class="btn" onclick="javascript:uf_insertComment();"><span>Ȯ��</span></a>
			</div>
		</div>
	
	</div>

</form>
<%@ include file="/jsp/inc/inc_bottom.jsp" %>