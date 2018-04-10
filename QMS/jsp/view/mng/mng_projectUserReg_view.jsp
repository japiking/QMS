<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>    
<%@ include file="/jsp/inc/inc_common.jsp" %>
<%@ include file="/jsp/inc/inc_header.jsp" %>

<script type="text/javascript">
	var check_yn;
	$(document).ready(function(){
		check_yn = "N";
   });
	/**
	* QMS 회원가입처리 
	**/
	function uf_regedit() {
		var cw=screen.availWidth;     //화면 넓이
		var ch=screen.availHeight;    //화면 높이
		sw=800;    //띄울 창의 넓이
		sh=400;    //띄울 창의 높이
		ml=(cw-sw)/2;        //가운데 띄우기위한 창의 x위치
		mt=(ch-sh)/2;         //가운데 띄우기위한 창의 y위치
		window.open('','popup','width='+sw+',height='+sh+',top='+mt+',left='+ml+',resizable=no,scrollbars=yes');
		frm.target			= "popup";
		frm.action			= "/QMS/jsp/view/mng/mng_projectUserReg_popup_view.jsp";
		frm.submit();

	}	
	// ID중복 체크
	function uf_idCheck(){
		var id = $("#USER_ID").val();
		if(id != null) id = $.trim(id);
		
		if(id == ""){
			alert("ID를 입력하세요.");
			return false;
		}
		
		frm.target			= 'HiddenFrame';
		frm.action			= "/QMS/jsp/proc/mng/mng_UserIdCheck_do.jsp";
		frm.submit();
	}
	// 페이징처리
	function uf_inq(pagenum) {                        // 파라메터 : 조회 페이지
		var frm				= document.frm;
		if (pagenum == 0) {
			pagenum = '1';
		}
		frm.PAGE_NUM.value	= pagenum;
		frm.target			= "_self";
		frm.action			= "/QMS/jsp/view/mng/mng_projectUserReg_view.jsp";
		frm.submit();
	}
	// 관리자 유저 정보 수정(라디오버튼)
	function uf_update(){
		var frm 			= document.frm;
		
		var wid	  			= 800;
		var hei   			= 500;
		var LeftPosition	= (screen.width)  ? (screen.width-wid) /2 : 0;
		var TopPosition		= (screen.height) ? (screen.height-hei)/2 : 0;
		var setting  		= 'scrollbars=no,toolbar=yes,resizable=no,width='+wid+',height='+hei+',left='+LeftPosition+',top='+TopPosition;
		window.open('', '_popup', setting);

		
		frm.target = "_popup";
		frm.action = "/QMS/jsp/proc/lgn/lgn_user_update.jsp";
		frm.submit();
	}
</script> 
  

<%@ include file="/jsp/inc/inc_topMenu.jsp" %>
<%@ include file="/jsp/inc/inc_leftMenu.jsp" %>
<form name="frm" method="post">
<input type="hidden" id="MNG_FLAG" name="MNG_FLAG" value="Y"/><!-- 개인정보 수정 flag -->
<input type="hidden" id="USER_ID"	name="USER_ID"/><!-- 개인정보 사용자 ID -->
<div class="wrap">
	<div class="btnWrapR">
		<a href="#FIT" class="btn" onclick="javascript:uf_update();"><span>수정</span></a>
		<a href="#FIT" class="btn" onclick="javascript:uf_regedit();"><span>등록</span></a>
	</div>
	
<!-- 	현재가입된 사용자목록을 보여준다. -->
<%
List<Map<String,String>> list	= null;
String pageNum		= StringUtil.null2void(request.getParameter("PAGE_NUM"),   "1");
String pageCount	= StringUtil.null2void(request.getParameter("PAGE_COUNT"), "20");
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

//파라미터 셋팅
Map<String,Object> param = new HashMap<String,Object>();
String prj_id = StringUtil.null2void(userSession.getProjectID());
Map<String,String> countMap = null;
param.put("PROJECTID", 	prj_id);
param.put("FROM_SEQ", 	fromcnt);
param.put("TO_SEQ", 	tocnt);
if("".equals(prj_id)){
	list	 = qmsDB.selectList("QMS_SUPERUSER.USERINFO_R003", param);
	countMap = qmsDB.selectOne("QMS_SUPERUSER.USERINFO_R004");
}else{	
	list	 = qmsDB.selectList("QMS_SUPERUSER.PROJECTUSERINFO_R001",	param);
	countMap = qmsDB.selectOne("QMS_SUPERUSER.PROJECTUSERINFO_R002", param);
}

int startpage = 0;
int endpage	=0;
int maxpage	=0;


// 건수조회 SQL
int totCount				= StringUtil.null2zero(StringUtil.null2void(countMap.get("CNT"), "0"));

page_num			= StringUtil.null2zero(pageNum);
page_count			= StringUtil.null2zero(pageCount);
tot_page_count		= totCount / page_count;

if ((totCount % page_count) > 0) tot_page_count++;

maxpage= tot_page_count;
startpage = (((int) ((double)page_num / 10 + 0.9)) - 1) * 10 + 1;
endpage = maxpage; 
 
if (endpage>startpage+10-1) endpage=startpage+10-1;

%>
<input type="hidden" name="PAGE_NUM"	value="<%=pageNum%>" 	/>
<input type="hidden" name="PAGE_COUNT"	value="20" 	/>
	<table class="list">
		<colgroup>
			<col width="5%"/>
			<col width="20%"/>
			<col width="20%"/>
			<col width="20%"/>
			<col width="*"/>			
		</colgroup>
		<thead>
			<tr>
				<th scope="col" style="text-align: center;">No</th>
				<th scope="col" style="text-align: center;">수정</th>
				<th scope="col" style="text-align: center;">ID</th>
				<th scope="col" style="text-align: center;">이름</th>
				<%if(!"".equals(prj_id)){ %>				
				<th scope="col" style="text-align: center;">등급</th>
				<%} %>
				<th scope="col" style="text-align: center;">비고</th>				
			</tr>
		</thead>
		<tbody>
			<% if( list == null || list.size() == 0 ) { %>
			<tr>
				<td colspan="5">조회 데이터가 없습니다.</td>
			</tr>
			<% } else {
				Map<String,String> dataMap	= null;
				for( int i = 0; i < list.size(); i++ ) {
				dataMap	= list.get(i);
				
			%>
			<tr>
				<td><%=dataMap.get("ROW_SEQ")%></td>
				<td><input type="radio" name ="rd_update" id="rd_update" value="<%=dataMap.get("USERID")%>"/></td>
				<td><%=dataMap.get("USERID")%></td>
				<td><%=dataMap.get("USERNAME")%></td>
				<%if(!"".equals(prj_id)){ %>
				<td><%=dataMap.get("AUTH_NAME")%></td>
				<%} %>
				<td><%=dataMap.get("BIGO")%></td>
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
<!-- //wrap -->
</form>
<IFRAME SRC="" frameborder="0" id="HiddenFrame" name="HiddenFrame" width="0" height="0" marginwidth="0" marginheight="0" scrolling="no" allowtransparency="true"></IFRAME>



<%@ include file="/jsp/inc/inc_bottom.jsp" %>