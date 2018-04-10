<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
    
<%@ include file="/jsp/inc/inc_common.jsp" %>
<%@ page import="java.util.*, java.text.*"  %>
<%
String boardId		= StringUtil.null2void(request.getParameter("BOARD_ID"));
//String today		= DateTime.getInstance().getDate("yyyy-mm-dd");
String pageNum		= StringUtil.null2void(request.getParameter("PAGE_NUM"),   "1");
String pageCount	= StringUtil.null2void(request.getParameter("PAGE_COUNT"), "20");
//String inq_date		= StringUtil.null2void(request.getParameter("INQ_DATE"), today);
String inq_date		= StringUtil.null2void(request.getParameter("INQ_DATE"));

int pageNumberCount = 10;
int start_rowId		= 1;
int end_rowId		= 0;
int page_num		= 1;
int page_count		= 0;
int tot_page_count	= 0;

//페이징관련
int req_cnt  = Integer.parseInt("".equals(pageNum) ? "20" : pageCount);	// 요청건수
int req_page = Integer.parseInt("".equals(pageNum) ? "1"  : pageNum);	// 요청페이지
int fromcnt = ((req_page-1)*req_cnt)+1;		// 시작번호
int tocnt	= (req_page*req_cnt);			// 종료번호
int startpage = 0;		// 시작페이지
int endpage	=0;			// 종료페이지
int maxpage	=0;			// 총페이지

List<Map<String,String>> list	= null;

// 파라미터 셋팅
Map<String,Object> param 	= new HashMap<String,Object>();
Map<String,String> countMap	= new HashMap<String,String>();
param.put("PROJECTID", 		userSession.getProjectID());
param.put("ATTENTION_DATE", inq_date);
param.put("FROM_SEQ", 		fromcnt);
param.put("TO_SEQ", 		tocnt);

try{
	list		= qmsDB.selectList("QMS_BBS_LIST.ATTENTIONMANAGER_R001", param);	// 근태관리 목록 불러오기
	countMap	= qmsDB.selectOne("QMS_BBS_LIST.ATTENTIONMANAGER_R002", param);		// 건수조회 SQL
}catch(Exception e){
	e.printStackTrace(System.out);
	if (qmsDB != null) try { qmsDB.close(); } catch (Exception e1) {}
}finally{
	if (qmsDB != null) try { qmsDB.close(); } catch (Exception e1) {}
}

int totCount				= StringUtil.null2zero(StringUtil.null2void(countMap.get("COUNT"), "0"));

page_num			= StringUtil.null2zero(pageNum);
page_count			= StringUtil.null2zero(pageCount);
tot_page_count		= totCount / page_count;

if( (totCount % page_count) > 0 ) tot_page_count++;
		
maxpage= tot_page_count; 

startpage = (((int) ((double)page_num / 10 + 0.9)) - 1) * 10 + 1;
endpage = maxpage; 
 
if (endpage>startpage+10-1) endpage=startpage+10-1;

String excel_name = new String("로그인날짜:".getBytes(),"ISO8859_1");

response.setHeader("Content-Disposition", "attachment;filename="+ excel_name+inq_date+".xls");
response.setHeader("Content-Description", "JSP Generated Data"); 
response.setContentType("application/vnd.ms-excel;charset=euc-kr");
%>
<script type="text/javascript">

</script>
<form name="frm" method="post">
	<input type="hidden" name="PAGE_NUM"	value="1" 	/>
  	<input type="hidden" name="PAGE_COUNT"	value="20" 	/>

	<div class="wrap">
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
	</div>
</form>
