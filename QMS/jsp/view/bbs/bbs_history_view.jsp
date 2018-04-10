<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="qms.util.StringUtil"%>
    
<%@ include file="/jsp/inc/inc_common.jsp" %>
<%@ include file="/jsp/inc/inc_header.jsp" %>
<%
	
	String today		= DateTime.getInstance().getDate("yyyy-mm-dd");

	String userId					= StringUtil.null2void(userSession.getUserID());
	String userName					= StringUtil.null2void(userSession.getUserName());
	String boardID 					= StringUtil.null2void(request.getParameter("BOARD_ID"));
	String bbsID 					= StringUtil.null2void(request.getParameter("BBS_ID"));
	String seq 						= StringUtil.null2void(request.getParameter("SEQ"));
	String depth					= StringUtil.null2void(request.getParameter("DEPTH"));
	String pageNum					= StringUtil.null2void(request.getParameter("PAGE_NUM"));
	String confirm_user				= StringUtil.null2void(request.getParameter("CONFIRM"));
	
	LogUtil.getInstance().debug("/QMS/jsp/view/bbs/bbs_history_view.jsp:::" +boardID+ ", bbsID:"+ bbsID +", seq:"+ seq );
	StringBuffer boardSql			= new StringBuffer();
	StringBuffer commentSql			= new StringBuffer();
	List<String> boardList			= new ArrayList();
	List<String> commentList		= new ArrayList(); 
	
	List<Map<String,String>> list	= null;
	List<Map<String,String>> list2	= null;
	List<Map<String,String>> resultCommentList = null;
	Map<String,String> dataMap		= null;
	
	String state 					= new String();
	List<Map<String,String>> attach_list	= null;
	String rec_user  = "";	//참여자
	String proc_user = "";	//처리자
	
try{
	
	Map<String,String> param = new HashMap<String,String>();
	
	param.put("BOARD_ID",boardID);
	param.put("BBS_ID",bbsID);
	param.put("SEQ",seq);
	list				=	qmsDB.selectList("QMS_BBS_ISSU.BOARD_R003", param);
	list2				=	qmsDB.selectList("QMS_BBS_ISSU.BBS_RECIPIENT_R002", param);
	
	for(int i=0; i<list2.size(); i++){
		Map<String,String> map = list2.get(i);
		String proc_yn	= StringUtil.null2void(map.get("PROC_YN"));
		String rec_yn	= StringUtil.null2void(map.get("REC_YN"));
		String re_dvd	= StringUtil.null2void(map.get("RECIPIENT_DVD"),"");
		
		if("Y".equals(proc_yn)){
			proc_user += StringUtil.null2void(map.get("USERNAME"))+"("+StringUtil.null2void(map.get("USERID"))+")"+",";
		}else if("Y".equals(rec_yn)){
			rec_user  += StringUtil.null2void(map.get("USERNAME"))+"("+StringUtil.null2void(map.get("USERID"))+")"+",";
		}
	}
	proc_user = proc_user.substring(0, proc_user.length()-1);
	rec_user  = rec_user.substring(0, rec_user.length()-1);
	
	Map<String,String> param2 = new HashMap<String,String>();
	
	param2.put("BBS_ID",bbsID);
	resultCommentList	=	qmsDB.selectList("QMS_BBS_ISSU.BBS_COMMENT_R001", param2);
	
}catch(Exception e){
	if (qmsDB != null) try { qmsDB.close(); } catch (Exception e1) {}
}
%>


<script type="text/javascript">
function uf_goList() {
	var frm				= document.frm;
	frm.BOARD_ID.value	= '<%=boardID%>';
	frm.target			= "_self";
	frm.action			= "/QMS/jsp/view/bbs/bbs_issu_view.jsp";
	frm.submit();
}
//수정
<%-- function uf_goUpdate() {
	frm.BOARD_ID.value	= '<%=boardID%>';
	frm.target			= "_self";
	frm.action			= "/QMS/jsp/view/bbs/bbs_write_view.jsp";
	frm.submit();
} --%>

//삭제
<%-- function uf_goDelete() {
	
	if (confirm("정말로 삭제하시겠습니까?") == true){
		frm.BOARD_ID.value	= '<%=boardID%>';
		frm.target			= "_self";
		frm.action			= "/QMS/jsp/view/bbs/bbs_delete_do.jsp";
		frm.submit();
	}
} --%>

function uf_goComment() {
	var frm						= document.frm;
	var contents		= frm.CONTENTS.value;
	if (contents.trim() == "") {
		alert("댓글을 입력해주시기 바랍니다.");
		frm.CONTENTS.focus();
		return false;
	} else {
		frm.BOARD_ID.value	= '<%=boardID%>';
		frm.target			= "_self";
		frm.action			= "/QMS/jsp/view/bbs/bbs_comment_do.jsp";
		frm.submit();
	}
	
}

//댓글 삭제
function comDel(commentid,bbsid,seq){
	var frm						= document.frm;
	frm.BOARD_ID.value		= '<%=boardID%>';
	frm.COMMENT_ID.value	= commentid;
	frm.BBS_ID.value		= bbsid;
	frm.target					= "_self";
	frm.action					= "/QMS/jsp/view/bbs/bbs_comment_delete_do.jsp";
	frm.submit();
}

function uf_FileDownLoad(fnm) {
	location.href = "/QMS/jsp/comm/FileDown.jsp?filename=" + escape(encodeURIComponent(fnm));
}

function uf_deleteComment(bbsID,commentID) {
	if (confirm("정말로 삭제하시겠습니까?") == true){
		var ajax = jex.createAjaxUtil("comment_delete_do");	// 호출할 페이지
		ajax.set("TASK_PACKAGE",    "bbs" );				// [필수]업무 package 호출할 페이지 패키
		ajax.set("BBS_ID",   bbsID );	
		ajax.set("COMMENT_ID",commentID );	
		ajax.execute(function(dat) {
			var data = dat["_tran_res_data"][0];
			var result = data.RESULT;
			if(result == "Y"){
				uf_loadComment();
			}else{
				alert("삭제 중 오류가 발생 되었습니다");
			}
		});
	}
}

function uf_insertComment() {
	// 공통부  
	var contents			= frm.CONTENTS.value;
	if (contents.trim() == "") {
		alert("댓글을 입력해주시기 바랍니다.");
		frm.CONTENTS.focus();
		return false;
	}
	var ajax = jex.createAjaxUtil("comment_insert_do");	// 호출할 페이지
	ajax.set("TASK_PACKAGE",    "bbs" );				// [필수]업무 package 호출할 페이지 패키
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
			alert("등록 중 오류가 발생 되었습니다");
		}
	});
}


function uf_loadComment(){
	try {
		var ajax = jex.createAjaxUtil("comment_load_do");	// 호출할 페이지

		// 공통부         		
		ajax.set("TASK_PACKAGE",    "bbs" );	 						// [필수]업무 package 호출할 페이지 패키

		// 개별부
		ajax.set("BBS_ID",    "<%=bbsID%>" );		
		ajax.execute(function(dat) {
			try{
				var data = dat["_tran_res_data"][0];
				var commentList = data.LIST;
				if ( commentList.length==0){
					$("#commentArea").html("<span><b>조회된 히스토리가 없습니다.</b></span>");
				}else{
					var commentCount = data.LIST.length;
					var innerHtml = "<h3>댓글 "+commentCount+"</h4>"+
					"<table class=\"mgT10\">"+
						"<colgroup>"+
							"<col width=\"10%\"/>"+
							"<col width=\"*\"/>"+
							"<col width=\"10%\"/>"+
							"<col width=\"5%\"/>"+
						"</colgroup>"+
						"<tbody>";
						var user_id = '<%=userSession.getUserID()%>';
						var pm_id = '<%=userSession.getProjectManagerID()%>';
					for (var i=0; i< commentCount; i++) { 
						var comment =  data.LIST[i]; 
						innerHtml+=	"<tr><th scope=\"row\">"+comment.COMMENT_USER+"&nbsp;("+comment.USERNAME+")</th>"+			
								"<td>"+comment.CONTENTS+"</td>"+
								"<td>"+comment.COMMENT_REG_DATE+"</td>";
						innerHtml+=	"	<td>";
								if ( user_id == comment.COMMENT_USER || pm_id == user_id ){
									if( comment.COMMENT_USER == user_id){
										innerHtml+="	<a href=\"#FIT\" class=\"btn\" onclick=\"javascript:uf_deleteComment(\'"+comment.BBS_ID+"\',\'"+comment.COMMENT_ID+"\');\" ><span style='color:blue;'>삭제</span></a>";
									}else{
										innerHtml+="	<a href=\"#FIT\" class=\"btn\" onclick=\"javascript:uf_deleteComment(\'"+comment.BBS_ID+"\',\'"+comment.COMMENT_ID+"\');\" ><span style='color:red;'>삭제</span></a>";
									}
								}
						innerHtml +=	"</td></tr>";
					}		
					innerHtml+="</tbody></table>";
					$("#commentArea").html(innerHtml);
				}
			} catch(e) {bizException(e, "error");}
		});
	} catch(e) {bizException(e, "error");}
}

$(document).ready(function(){
	uf_loadComment();
});
</script>

<%@ include file="/jsp/inc/inc_topMenu.jsp" %>
<%@ include file="/jsp/inc/inc_leftMenu.jsp" %>
<form name="frm" method="post">
  	<input type="hidden" name="BOARD_ID"					 />
  	<input type="hidden" name="BBS_ID"		value='<%=bbsID%>' />
  	<input type="hidden" name="SEQ"			value='<%=seq%>' />
  	<input type="hidden" name="PAGE_NUM"	value='<%=pageNum%>' />
  	<input type="hidden" name="COMMENT_ID"	value='<%=pageNum%>' />
	<div class="wrap">
		<h3>이슈 히스토리</h3>
		<div class="btnWrapR">
			<a href="#" class="btn" onclick="javascript:uf_goList();"><span>리스트로</span></a>

		<% if (list == null || list.size() == 0) { %>
			<span>조회된 데이터가 없습니다.</span>
		<% } else {
			dataMap	= list.get(0);  // 첫번째 데이터는 게시글
			state = dataMap.get("STATE");
			if("000".equals(state)) state = "open(등록)";
			else if("001".equals(state)) state = "Progress(처리중)";
			else if("002".equals(state)) state = "Resolved(처리)";
			else if("999".equals(state)) state = "Canceled(취소)";
			
			if("Y".equals(dataMap.get("BBS_FILE"))){
				try{
					Map<String,String> param3 =new HashMap<String,String>();
					param3.put("BBS_ID", bbsID);
					
					attach_list = qmsDB.selectList("QMS_BBS_ISSU.BBS_ATTACHMENT_R001", param3);
				}catch(Exception e){
					LogUtil.getInstance().debug(e);
					if (qmsDB != null) try { qmsDB.close(); } catch (Exception e1) {}
				}
				
			}
			
		%>
		
		<% if (userId.equals(dataMap.get("BBS_USER"))) { %>
			<!-- <a href="#" class="btn" onclick="javascript:uf_goUpdate();"><span>수정</span></a>
			<a href="#" class="btn" onclick="javascript:uf_goDelete();"><span>삭제</span></a> -->
		<% } %>
		</div>
			<table class="mgT10">
				<colgroup>
					<col width="15%"/>
					<col width="*"/>
				</colgroup>
				<tbody>	
					<tr>
						<th scope="row">메시지</th>			
						<td><%=dataMap.get("TITLE")%></td>
					</tr>
					<tr>	
						<th scope="row">작성자</th>			
						<td><%=dataMap.get("USERNAME")%>(<%=dataMap.get("BBS_USER")%>)</td>								
					</tr>
					<tr>	
						<th scope="row">등록일</th>			
						<td><%=dataMap.get("BBS_REG_DATE")%></td>								
					</tr>
					<tr>	
						<th scope="row">완료예정일</th>			
						<td><%=dataMap.get("COMPLETION_DATE")%></td>								
					</tr>
					<tr>	
						<th scope="row">완료일</th>
						<%if(null != dataMap.get("COMPLETE_DATE") && !"".equals(dataMap.get("COMPLETE_DATE"))){%>			
						<td><%=dataMap.get("COMPLETE_DATE")%></td>
						<%}else{%>
						<td>-</td>
						<%}%>								
					</tr>
					<tr>	
						<th scope="row">상태</th>			
						<td>
						<%
							int comDate = Integer.parseInt(dataMap.get("COMPLETION_DATE").substring(0, 10).replaceAll("-",""));
							int intToday = Integer.parseInt(today.replaceAll("-", ""));
							if(intToday > comDate && !"002".equals(dataMap.get("STATE").trim()) && !"999".equals(dataMap.get("STATE").trim())){ 
						%>
							지연
						<%}else{%>
							<%if("000".equals(dataMap.get("STATE").trim())){%>
								open(등록)
							<%}else if("001".equals(dataMap.get("STATE").trim())){%>
								Progress(처리중)
							<%}else if("002".equals(dataMap.get("STATE").trim())){%>
								Resolved(처리)
							<%}else if("999".equals(dataMap.get("STATE").trim())){%>
								Canceled(취소)
							<%}%>
						<%}%>
						</td>								
					</tr>
					<tr>	
						<th scope="row">참여자</th>			
						<td><%=rec_user%></td>								
					</tr>
					<tr>	
						<th scope="row">처리자</th>			
						<td><%=proc_user%></td>								
					</tr>
					<tr>	
						<th scope="row">확인자</th>			
						<td><%=confirm_user%></td>								
					</tr>
				<%-- 	<tr>	
						<th scope="row">처리상태</th>			
						<td><%=state%></td>								
					</tr> --%>
					<%-- <tr>
						<th scope="row">첨부파일</th>
						<td class="wBtn">
							<% 
							if(null != attach_list &&  attach_list.size() > 0){
								String file = "";
								for(int i=0; i<attach_list.size(); i++){
									Map<String,String> tempMap	= attach_list.get(i);
									file = tempMap.get("FILE_PATH")+"/"+tempMap.get("FILE_NAME");
							%>
									<a href="#FIT" class="sBtn" onclick="javascript:uf_FileDownLoad('<%=file%>');"><span><b><%=tempMap.get("FILE_NAME")%></b></span></a>
							<%
								}
							}
							%>
						</td>				
					</tr>	 --%>								
				</tbody>
			</table>
			
			<br/>
			<p style="height: 2px; background: #d7dadf;"></p>
			<br/>
		<% }%>
			
			<div id=commentArea></div>
		
		<div>
			<h4>히스토리 남기기</h4>
			<div class="btnWrapR">
				<%-- <span>현재 사용자 : <%=userName%></span> --%>
				<textarea rows="5" cols="50" name="CONTENTS" value="" maxlength="50"></textarea>
				<a href="#" class="btn" onclick="javascript:uf_insertComment();"><span>확인</span></a>
			</div>
		</div>
	
	</div>

</form>
<%@ include file="/jsp/inc/inc_bottom.jsp" %>