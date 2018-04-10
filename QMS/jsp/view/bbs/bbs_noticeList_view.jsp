<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
    
<%@ include file="/jsp/inc/inc_common.jsp" %>
<%@ include file="/jsp/inc/inc_header.jsp" %>

<%
String board_id		= StringUtil.null2void(request.getParameter("BOARD_ID"));
String pageNum		= StringUtil.null2void(request.getParameter("PAGE_NUM"),   "1");
String pageCount	= StringUtil.null2void(request.getParameter("PAGE_COUNT"), "20");
int pageNumberCount = 10;
int start_rowId		= 1;
int end_rowId		= 0;
int page_num		= 1;
int page_count		= 0;
int tot_page_count	= 0;

//페이징관련
int req_cnt  = Integer.parseInt("".equals(pageCount) ? "20" : pageCount);	// 요청건수
int req_page = Integer.parseInt("".equals(pageNum) ? "1"  : pageNum);	// 요청페이지
int fromcnt = ((req_page-1)*req_cnt)+1;		// 시작번호
int tocnt	= (req_page*req_cnt);			// 종료번호

List<Map<String,String>> list	= null;

//파라미터 셋팅
Map<String,Object> param = new HashMap<String,Object>();
param.put("BOARD_ID", 	board_id);
param.put("FROM_SEQ", 	fromcnt);
param.put("TO_SEQ", 	tocnt);

list	= qmsDB.selectList("QMS_BBS_LIST.BOARD_R001",	param);

String today = DateTime.getInstance().getDate("yyyy-mm-dd");
String date  = new String();
String state = new String();
String new_yn = "N";

int startpage = 0;
int endpage	=0;
int maxpage	=0;

// 건수조회 SQL
Map<String,String> countMap	= qmsDB.selectOne("QMS_BBS_LIST.BOARD_R002", param);
int totCount				= StringUtil.null2zero(StringUtil.null2void(countMap.get("COUNT"), "0"));

page_num			= StringUtil.null2zero(pageNum);
page_count			= StringUtil.null2zero(pageCount);
tot_page_count		= totCount / page_count;

if ((totCount % page_count) > 0) tot_page_count++;

maxpage= tot_page_count;

startpage = (((int) ((double)page_num / 10 + 0.9)) - 1) * 10 + 1;
endpage = maxpage; 
 
if (endpage>startpage+10-1) endpage=startpage+10-1;

%>
<script type="text/javascript">
var frm;
var brd_id;
$(document).ready(function(){
	frm = document.form1;
	brd_id = '<%=board_id%>';
	
	var menu_nm = $("#"+brd_id).text();
	$("h3").text(menu_nm);
});

function uf_inq(pagenum) {                        // 파라메터 : 조회 페이지
	var frm				= document.frm;
	if (pagenum == 0) {
		pagenum = '1';
	}
	frm.PAGE_NUM.value	= pagenum;
	frm.BOARD_ID.value	= brd_id;		
	frm.target			= "_self";
	frm.action			= "/QMS/jsp/view/bbs/bbs_noticeList_view.jsp";
	frm.submit();
}

function uf_cancel(rowid) {
	return;
}

function uf_FileDownLoad(fnm) {		
	//alert(fnm);
	location.href = "/QMS/jsp/comm/FileDown.jsp?filename=" + encodeURI(fnm);
}

function uf_detail(rowid, seq,depth) {
	var frm				= document.frm;	
	frm.BBS_ID.value	= rowid;
	frm.BOARD_ID.value	= brd_id;
	frm.SEQ.value		= seq;
	frm.DEPTH.value		= depth;
	frm.PAGE_NUM.value	= '<%=pageNum%>';
	frm.target			= "_self";
	frm.action			= "/QMS/jsp/view/bbs/bbs_noticeList_detail_view.jsp";
	frm.submit();
}

function uf_reg(param) {
	var frm				= document.frm;
	frm.BOARD_ID.value	= '<%=board_id%>';
	
	if(param == 1) frm.BBS_ID.value	= "";
	else frm.BBS_ID.value	= param;
	
	frm.target			= "_self";
	frm.action			= "/QMS/jsp/view/bbs/bbs_notice_write.jsp";
	frm.submit();
}
</script>

<%@ include file="/jsp/inc/inc_topMenu.jsp" %>
<%@ include file="/jsp/inc/inc_leftMenu.jsp" %>
<form name="frm" method="post">
	<input type="hidden" name="PAGE_NUM"	value="<%=pageNum%>" 	/>
  	<input type="hidden" name="PAGE_COUNT"	value="20" 	/>
  	<input type="hidden" name="BOARD_ID"				/>
  	<input type="hidden" name="BBS_ID"		value="" 	/>
  	<input type="hidden" name="SEQ"			value="" 	/>
  	<input type="hidden" name="DEPTH"		value="" 	/>
	<div class="wrap">
		<h3></h3>
		<div class="btnWrapR">
			<a href="#" class="btn" onclick="javascript:uf_reg(1);"><span>글쓰기</span></a>
		</div>
		<table class="list">
			<colgroup>
				<col width="5%"/>
				<col width="55%"/>
				<col width="10%"/>
				<col width="20%"/>
				<col width="5%"/>
				<col width="*"/>			
			</colgroup>
			<thead>
				<tr>
					<th scope="col">No</th>
					<th scope="col">제목</th>
					<th scope="col">등록자</th>				
					<th scope="col">등록일시</th>				
					<th scope="col">첨부</th>
					<th scope="col">조회수</th>
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
					
					// 상태값 체크
					state =  dataMap.get("STATE");

					// 새글 여부 체크
					new_yn = "N";
					date = dataMap.get("BBS_REG_DATE").substring(0,10);
					if(today.equals(date)) new_yn = "Y";
				%>
				<tr>
					<td><%=dataMap.get("ROW_SEQ")%></td>
					<td class="alL">
						<a href="#" onclick="javascript:uf_detail('<%=dataMap.get("BBS_ID")%>','<%=dataMap.get("SEQ")%>','<%=dataMap.get("DEPTH")%>');"><%=dataMap.get("TITLE")%><%if(new_yn.equals("Y")) out.print("..."+"<img src='/QMS/img/new.jpg'>");%></a>
					</td>
					<td><%=dataMap.get("USERNAME")%>(<%=dataMap.get("BBS_USER")%>)</td>
					<td><%=dataMap.get("BBS_REG_DATE")%></td>
					<td class="wBtn">
					<%	
							List<Map<String,String>> ar	= null;
							try {
								Map<String,String> paramR004 = new HashMap<String,String>();
								paramR004.put("BBS_ID", dataMap.get("BBS_ID"));
								ar	= qmsDB.selectList("QMS_BBS_ONELOW.BBS_ATTACHMENT_R004", paramR004);
							} catch (Exception e) {
								if (qmsDB != null) try { qmsDB.close(); } catch (Exception e1) {}
							}
							for (int k=0; k<ar.size(); k++) {
					%>
								<a href="#FIT" class="sBtn" onclick="javascript:uf_FileDownLoad('<%=ar.get(k).get("FILE_INFO")%>');"><span><b>첨부<%=k+1 %></b></span></a><br/>
					<%
							}
					%>
					</td>
					<td><%=dataMap.get("COUNT")%></td>
				</tr>
				<%
					}
			  	 } // end else
			  	%>
			</tbody>
		</table>
		<div class="paging">
			<ul>
				<li class="bt"><a href="javascript:uf_inq('1')">[First]</a></li>
				<li class="bt"><a href="javascript:uf_inq('<%=page_num - 1%>')">[Prev]</a></li>
	<%		for( int a = startpage; a <= endpage; a++ ) { %>
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
