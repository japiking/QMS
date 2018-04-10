<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
    
<%@ include file="/jsp/inc/inc_common.jsp" %>
<%@ include file="/jsp/inc/inc_header.jsp" %>

<%
String boardId		= StringUtil.null2void(request.getParameter("BOARD_ID"));
String today		= DateTime.getInstance().getDate("yyyy-mm");
/* String pageNum		= StringUtil.null2void(request.getParameter("PAGE_NUM"),   "1");
String pageCount	= StringUtil.null2void(request.getParameter("PAGE_COUNT"), "20"); */
//String inq_date	= StringUtil.null2void(request.getParameter("INQ_DATE"));
String confirm_date	= StringUtil.null2void(request.getParameter("CONFIRM_DATE"),today);
String userId		= userSession.getUserID();
String dateFlag = StringUtil.null2void(request.getParameter("DATE_FLAG"),"");;

/* int pageNumberCount = 10;
int start_rowId		= 1;
int end_rowId		= 0;
int page_num		= 1;
int page_count		= 0;
int tot_page_count	= 0; */

//페이징관련
//int req_cnt  = Integer.parseInt("".equals(pageNum) ? "20" : pageCount);	// 요청건수
//int req_page = Integer.parseInt("".equals(pageNum) ? "1"  : pageNum);	// 요청페이지
//int fromcnt = ((req_page-1)*req_cnt)+1;		// 시작번호
//int tocnt	= (req_page*req_cnt);			// 종료번호
//int startpage = 0;		// 시작페이지
//int endpage	=0;			// 종료페이지
//int maxpage	=0;			// 총페이지


List<Map<String,String>> list	= null;

// 파라미터 셋팅
Map<String,Object> param 	= new HashMap<String,Object>();
Map<String,String> countMap	= new HashMap<String,String>();
param.put("PROJECTID", 		userSession.getProjectID());
/* param.put("FROM_SEQ", 		fromcnt);
param.put("TO_SEQ", 		tocnt); */
param.put("USERID",			userId);
param.put("ATTENTION_DATE", confirm_date);

try{
	list		= qmsDB.selectList("QMS_BBS_LIST.ATTENTIONMANAGER_R003", param);	// 근태관리 목록 불러오기
	countMap	= qmsDB.selectOne("QMS_BBS_LIST.ATTENTIONMANAGER_R004", param);		// 건수조회 SQL
}catch(Exception e){
	e.printStackTrace(System.out);
	if (qmsDB != null) try { qmsDB.close(); } catch (Exception e1) {}
}finally{
	if (qmsDB != null) try { qmsDB.close(); } catch (Exception e1) {}
}

//int totCount				= StringUtil.null2zero(StringUtil.null2void(countMap.get("COUNT"), "0"));

/* page_num			= StringUtil.null2zero(pageNum);
page_count			= StringUtil.null2zero(pageCount);
tot_page_count		= totCount / page_count; 

if( (totCount % page_count) > 0 ) tot_page_count++;
		
maxpage= tot_page_count; 

startpage = (((int) ((double)page_num / 10 + 0.9)) - 1) * 10 + 1;
endpage = maxpage; 
 
if (endpage>startpage+10-1) endpage=startpage+10-1;
*/
%>

<style>
.ui-datepicker table{
    display: none;
}
</style>

<script src="/QMS/js/common/custom_datepicker.js"></script>
<script type="text/javascript">
function uf_inq(pagenum) {                        // 파라메터 : 조회 페이지
	var frm				= document.frm;
	if(null == pagenum || pagenum == 0){
		pagenum = '1';
	}
	frm.PAGE_NUM.value	= pagenum;
	frm.target			= "_self";
	frm.action			= "/QMS/jsp/view/bbs/bbs_attention_confirm_view.jsp";
	frm.submit();
}
$(document).ready(function() {
	var menu_nm = $("#"+'<%=boardId%>').text();
	$("h3").text(menu_nm);
	
	$("#INQ_DATE").datepicker({
		closeText :"선택",
		currentText: "이번달",
		changeMonth: true,
		changeYear: true,
		showButtonPanel: true,
		dateFormat: 'yy-mm',
		onClose: function(dateText, inst){
		var month = $("#ui-datepicker-div .ui-datepicker-month :selected").val();
		var year = $("#ui-datepicker-div .ui-datepicker-year :selected").val();
		$(this).datepicker('setDate', new Date(year, month, 1));
		}
	});
});

function uf_find(){
	var frm = document.frm;

	frm.DATE_FLAG.value="Y";
	frm.target			= "_self";
	frm.action			= "/QMS/jsp/view/bbs/bbs_attention_confirm_view.jsp";
	frm.submit();
	
}
</script>

<%@ include file="/jsp/inc/inc_topMenu.jsp" %>
<%@ include file="/jsp/inc/inc_leftMenu.jsp" %>
<form name="frm" method="post">
	<input type="hidden" name="PAGE_NUM"	value="1" 	/>
  	<input type="hidden" name="PAGE_COUNT"	value="20" 	/>
	<input type="hidden" name="DATE_FLAG" value="<%=dateFlag%>"/>
  	
	<div class="wrap">
		<h3></h3>
		<div class="btnWrapR">
			<input readonly="readonly" id="INQ_DATE" name="CONFIRM_DATE" value="<%=confirm_date%>" style="width: 70px"/><!--  시작일 -->
			<a href="#FIT" class="btn" onclick="javascript:uf_find();"><span>조회</span></a>
		</div>
		<table class="list">
			<colgroup>
				<col width="20%"/>
				<col width="20%"/>
				<col width="20%"/>
				<col width="20%"/>
				<col width="*"/>			
			</colgroup>
			<thead>
				<tr>
					<th style="text-align: center;" scope="col">사용자명</th>
					<th style="text-align: center;" scope="col">사용자ID</th>
					<th style="text-align: center;" scope="col">날짜</th>
					<th style="text-align: center;" scope="col">최초로그인시각</th>				
					<th style="text-align: center;" scope="col">최종로그인시각</th>				
				</tr>
			</thead>
			<tbody>
				<% if( list == null || list.size() == 0 ) { %>
				<tr>
					<td colspan="6">조회 데이터가 없습니다.</td>
				</tr>
				<% } else {
					Map<String,String> dataMap	= null;
					for( int i = 0; i < list.size(); i++ ) {
					dataMap	= list.get(i);
				%>
				
				<tr>
					<td><%=dataMap.get("USERNAME")%></td>
					<td><%=dataMap.get("USERID")%></td>
					<td><%=dataMap.get("ATTENTION_DATE")%></td>
					<td><%=dataMap.get("IN_TIME")%></td>
					<td><%=StringUtil.null2void(dataMap.get("OUT_TIME"), "-")%></td>
				</tr>
				<%
					}
			  	 } // end else
			  	%>
			</tbody>
		</table>
		<div class="paging">
			
		</div>
	</div>

</form>

<%@ include file="/jsp/inc/inc_bottom.jsp" %>