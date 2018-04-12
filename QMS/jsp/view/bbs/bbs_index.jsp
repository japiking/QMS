<%@page import="java.math.BigDecimal"%>
<%@page import="java.util.Vector"%>
<%@page import="qms.wbs.WBSUtil"%>
<%@page import="qms.wbs.WBSNode"%>
<%@page import="qms.batch.AttentionProc"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
    
<%@ include file="/jsp/inc/inc_common.jsp" %>
<%@ include file="/jsp/inc/inc_header.jsp" %>

<%

	String prj_id		= userSession.getProjectID();
	String user_id 		= userSession.getUserID();
	List<Map<String,String>> list	= null;
	List<Map<String,String>> list1  = null;
	List<Map<String,String>> list3	= null;
	List<Map<String,String>> list4	= null;
	Map<String,String> 		 map	= null;
	double tot_progress				= 0;
	
	Map<String,String> param = new HashMap<String,String>();
	try{
		param.put("PROJECTID", 			prj_id);
		param.put("PROJECT_ID", 		prj_id);
		param.put("USERID", 			user_id);
		param.put("BBS_REG_DATE", 		DateTime.getInstance().getCurDateFormatFromDay("yyyy-MM-dd",-2));
		
		// 프로젝트 정보 조회
		list		= qmsDB.selectList("QMS_BBS_INDEX.PROJECTINFO_R001", 	param);
		
		// WBS 간략조회
		list1       = qmsDB.selectList("QMS_BBS_INDEX.WBS_R001", 			param);
		 
		// 새글 진척외 목록 조회
		list4		= qmsDB.selectList("QMS_BBS_INDEX.BOARD_R004", 			param); 
		
		// 새글 진척목록 조회
		list3		= qmsDB.selectList("QMS_BBS_INDEX.BOARD_R003", 			param); 
		
		
		
// 		new Thread(new AttentionProc()).start();
	}catch(Exception e){
		e.printStackTrace();
			if (qmsDB != null) 
				try { qmsDB.rollback(); } catch (Exception e1) {}
	}finally{
		if (qmsDB != null) 
			try { qmsDB.close(); } catch (Exception e1) {}
	}
%>




<%@ include file="/jsp/inc/inc_topMenu.jsp" %>
<%@ include file="/jsp/inc/inc_leftMenu.jsp" %>
<form name="frm" method="post">
  <input type="hidden" name="MODE"						/>
  <input type="hidden" name="ROW_ID" 					/>
  <input type="hidden" name="PAGE_NUM"		value="1"	/>
  <input type="hidden" name="PAGE_COUNT"	value="20"	/>
  <input type="hidden" name="BOARD_ID"		value=""	/>
  
    <input type="hidden" name="BBS_ID"		value="" 	/>
  	<input type="hidden" name="SEQ"			value="" 	/>
	<input type="hidden" name="DEPTH"		value="" 	/>
  <div class="wrap">
	<h3>프로젝트 개요 : <%=list.get(0).get("BIGO")%></h3>
	<div>	
		<h3>프로젝트별 현황(간략조회)</h3>
		
		<table class="list alR" >
			<colgroup>
				<col width=""/>
				<col width=""/>
				<col width=""/>
				<col width=""/>
				<col width=""/>
				<col width=""/>
				<col width=""/>
				<col width=""/>
			</colgroup>
			<thead>
				<tr>
					<th class="alC">프로젝트 ID</th>
					<th class="alC">프로젝트명</th>
					<th class="alC">시작일</th>
					<th class="alC">종료일</th>
					<th class="alC">PM ID</th>
					<th class="alC">PM 명</th>
					<th class="alC">이용자수</th>
					<th class="alC">게시판수</th>
				</tr>
			</thead>
			<tbody>
			<%
				//if("0".equals(mode)){
					if( list == null || list.size() == 0 ) {
					} else {
						Map<String,String> dataMap	= null;
						for( int i = 0; i < list.size(); i++ ) {
							dataMap	= list.get(i);
			%>
				<tr>
					<td class="alC"><%=((String)dataMap.get("PROJECTID")).trim()%></td>
					<td class="alC"><%=((String)dataMap.get("PROJECTNAME")).trim()%></td>
					<td class="alC"><%=((String)dataMap.get("PROJECTSTARTDATE")).trim()%></td>
					<td class="alC"><%=((String)dataMap.get("PROJECTENDDATE")).trim()%></td>
					<td class="alC"><%=((String)dataMap.get("PROJECTMANAGERID")).trim()%></td>
					<td class="alC"><%=((String)dataMap.get("USERNAME")).trim()%></td>
					<td class="alC"><%=((String)dataMap.get("USERCOUNT")).trim()%></td>
					<td class="alC"><%=((String)dataMap.get("BOARDCOUNT")).trim()%></td>
				</tr>			
				<%
						}
					}
				//}
				%>
			</tbody>
		</table>
	</div>
	<br/>
	
	<div>
		<h3 style="margin-top:20px; margin-bottom:0px;">프로젝트 전체 진척률</h3>
<%-- 		<progress max="100" value="<%=tot_progress%>" style="height: 30px; width: 100%;"><%=tot_progress%>%</progress> --%>
		<div class="progress">
			<%
				if ( list1 == null || list1.size() == 0 ) {
				} else {
					Map<String,String> dataMap	= null;
					String sttd_date = "";
					String endg_date = "";
					String stg_cmpl = "";		// 예정 진척율
					int btwn_date    = 0;
					String state     = "";
					for( int i = 0; i < list1.size(); i++ ) {
						dataMap	= list1.get(i);
						
						String real_major = "".equals(dataMap.get("REAL_MAJOR")) ? "0":dataMap.get("REAL_MAJOR");
						String real_prg   = "".equals(dataMap.get("REAL_PROGRESS")) ? "0":dataMap.get("REAL_PROGRESS");
						real_prg = real_prg.replaceAll("%", "");
// 						LogUtil.getInstance().debug("LSJ---real_major>>"+real_major);
						double temp = 0;
						double tot = 0;
						try{
							if("0".equals(real_prg)){
								tot = 0;
							} else {
								temp = Double.parseDouble(real_prg) / 100;
								tot = Double.parseDouble(real_major)*temp;
							}
						}catch(Exception e){
							
						}
						tot_progress += tot;
			%>
		  <%
					}	// end for
				}		// end else
				tot_progress = tot_progress * 100;
							
				BigDecimal bd3		 = new BigDecimal(String.valueOf(tot_progress));
				BigDecimal calc_rlt3 = bd3.setScale(2, BigDecimal.ROUND_DOWN);
				tot_progress 				 = Long.parseLong(calc_rlt3.toString());
		  %>
			  <div class="progress-bar progress-bar-success" role="progressbar" style="width:<%=tot_progress%>%">
			    <%=tot_progress%>%
			  </div>
		</div>
		<table>
			<colgroup>
				<col width="7%"/>
				<col width="13%"/>
				<col width="10%"/>
				<col width="10%"/>
				<col width="10%"/>
				<col width="10%"/>
				<col width="10%"/>
				<col width="10%"/>
				<col width="10%"/>
				<col width="10%"/>
			</colgroup>
			<thead>
				<tr>
					<th class="alC" rowspan="2">WBS코드</th>
					<th class="alC" rowspan="2">단계</th>
					<th class="alC" colspan="4">계획</th>
					<th class="alC" colspan="2">현재</th>
					<th class="alC" rowspan="2">상태</th>
				</tr>
				<tr>
					<th class="alC">예정시작일</th>
					<th class="alC">예정종료일</th>
					<th class="alC">예정진척률</th>
					<th class="alC">전체대비 예정공정율</th>
					<th class="alC">실제진척률</th>
					<th class="alC">전체대비실제공정율</th>
				</tr>
			</thead>
			<tbody>
			<%
			
				WBSNode rootNode = null;
				try{
					rootNode = WBSUtil.makeWBSTree(userSession.getProjectID());
				}catch(Exception e){
				}
				
					if ( list1 == null || list1.size() == 0 || rootNode == null) {
					} else {
						Map<String,String> dataMap	= null;
						String sttd_date = "";
						String endg_date = "";
						String stg_cmpl = "";		// 예정 진척율
						String strTaskCode = "";
						int btwn_date    = 0;
						String state     = "";
						for( int i = 0; i < list1.size(); i++ ) {
							dataMap	= list1.get(i);
							sttd_date = dataMap.get("PLAN_STTG_DATE");
							endg_date = dataMap.get("PLAN_ENDG_DATE");
							strTaskCode = dataMap.get("TASK_CODE");
							WBSNode tempNode = WBSUtil.findNode(rootNode, strTaskCode);
					    	int nTotalCount = tempNode.getLeafCount();
					    	int nLeafCount = tempNode.getLeafCount();//총갯수
							int nExpected = tempNode.getSumValueDate("PLAN_ENDG_DATE"); //현시점 예상완료갯수
							int nIng = tempNode.getSumValue("NOW_STAT", "222"); //진행중
							int nEd = tempNode.getSumValue("NOW_STAT", "111"); //완료
							int nEx = tempNode.getSumValue("NOW_STAT", "999"); //제외
							double progressRateTotal = (double)(nEd+nEx)/(double)nLeafCount*100;// 진행율
							double progressRateByPlan = (double)(nEd+nEx)/(double)nExpected*100; //계획대비진척률
							double expectedRate = (double)nExpected/(double)nLeafCount*100;
							if(nExpected == 0){
								progressRateByPlan =0;
							}
							
							// 시작일
							if(sttd_date.contains(".")){
								String []temp = sttd_date.split("\\.");
								sttd_date = "20"+temp[0]+BizUtil.getPadString(temp[1].trim(), 2, "0") + BizUtil.getPadString(temp[2].trim(), 2, "0");
							} else {
								sttd_date = sttd_date.replaceAll("-", "");
							}
							
							// 종료일
							if(endg_date.contains(".")){
								String []temp = endg_date.split("\\.");
								endg_date = "20"+temp[0]+BizUtil.getPadString(temp[1].trim(), 2, "0") + BizUtil.getPadString(temp[2].trim(), 2, "0");
							} else {
								endg_date = endg_date.replaceAll("-", "");
							}
							
							int temp_day = DateTime.getInstance().getDayBetween(sttd_date, DateTime.getInstance().getDate("yyyyMMdd"));
							
							if(progressRateTotal == 100){
								state = "<span>완료</span>";
							} else if(temp_day < 0){
								state = "<span>진행전</span>";
							} else if(expectedRate > progressRateByPlan) {
								state = "<span style=\"color: red	\">지연</span>";
							} else{  
								state = "<span style=\"color: blue	\">진행</span>";
							}
							
							
			%>
				<tr>
					<td class="alC"><%=dataMap.get("TASK_LEVEL")%></td>
					<td class="alC"><%=dataMap.get("TASK_TITLE")%></td>
					<td class="alC"><%=dataMap.get("PLAN_STTG_DATE")%></td>
					<td class="alC"><%=dataMap.get("PLAN_ENDG_DATE")%></td>
					<td class="alC"><%=String.format("%.2f" , expectedRate) %>%</td>
					<td class="alL">
						&nbsp;&nbsp;&nbsp;
						<progress max="100" value="<%=expectedRate%>" style="width: 70px">
						</progress>
						<%=dataMap.get("PLAN_MAJOR")%><%="".equals(dataMap.get("PLAN_MAJOR")) ? "":"%"%>
					</td>
					<td class="alC"><%=String.format("%.2f" , progressRateByPlan)%>%</td>
					<td class="alL">
						&nbsp;&nbsp;&nbsp;
						<progress max="100" value="<%=progressRateTotal%>" style="width: 70px;">
						</progress>
						<%=dataMap.get("REAL_MAJOR")%><%="".equals(dataMap.get("REAL_MAJOR")) ? "":"%"%>
					</td>
					<td class="alC"><%=state%></td>
				</tr>
			</tbody>
			<%
						}	// end for
					}		// end else
			%>
		</table>
		
		</div>
	<br/>

	<div style="width:100%;" >
	
		<h3 style="margin-top:20px; margin-bottom:0px;">신규게시물(오늘/어제)</h3>
		
		<div style="float:left; width:46%;">
			<table class="list all">
				<thead>
					<tr>
						<th class="alC">진척관련 게시물</th>
					</tr>
				</thead>
				<tbody>
				<%
				// 진척목록 조회
					if( list3 == null || list3.size() == 0 ) {
					} else {
						Map<String,String> dataMap	= null;
						for( int i = 0; i < list3.size(); i++ ) {
							dataMap	= list3.get(i);
				%>
					<tr>
						<td class="alL">
							<a href="#FIT" onclick="javascript:uf_detail('<%=dataMap.get("BBS_ID")%>','<%=dataMap.get("SEQ")%>','<%=dataMap.get("DEPTH")%>','<%=dataMap.get("BOARD_ID")%>');"><%=dataMap.get("TITLE")%></a>
						</td>
					</tr>
				<%
						}
					}
				%>
				</tbody>
				
			</table>
		</div>
		
		<div style="float:left; width:46%; margin-left:8%">
			<table class="list all">
				<thead>
					<tr>
						<th class="alC">메뉴</th>
						<th class="alC">게시물내용</th>
					</tr>
				</thead>
				<tbody>
					<%
					// (진척,공유,식권,이슈) 진척외 목록 조회
						if( list4 == null || list4.size() == 0 ) {
						} else {
							Map<String,String> dataMap	= null;
							for( int i = 0; i < list4.size(); i++ ) {
								dataMap	= list4.get(i);
					%>
					
						<tr>
							<td class="alC"><%=StringUtil.null2void(dataMap.get("KOR_MENU_NAME"))%></td>
							<td class="alL">
								<%=dataMap.get("TITLE")%>
<%-- 								<a href="#FIT" onclick="javascript:uf_detail2('<%=dataMap.get("BBS_ID")%>','<%=dataMap.get("SEQ")%>','<%=dataMap.get("DEPTH")%>','<%=dataMap.get("BOARD_ID")%>');"><%=dataMap.get("TITLE")%></a> --%>
							</td>
						</tr>
					<%
							}
						}
					%>
				</tbody>
			</table>
		</div>
	</div>
</div>
<!-- //wrap -->

</form>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="/QMS/css/bootstrap.min.css" />
<script src="/QMS/js/common/bootstrap.min.js"></script>
<script type="text/javascript">
<!--최신글 메뉴링크 함수입니다.-->
//메뉴링크
function uf_newbbslink(param, param2, param3) {
	var pkg = param.substring(0,param.indexOf("_")); 
	menufrm.BOARD_ID.value	= param2;
	menufrm.BOARD_TYPE.value	= param3;
		menufrm.target = "_self";
		menufrm.action = "/QMS/jsp/view/"+pkg+"/"+param+".jsp?BOARD_ID="+param2;
		menufrm.submit();
}
/**
 * 진척관리 새글
 */
function uf_detail(rowid, seq, depth, brd_id) {
	var frm				= document.frm;	
	frm.BBS_ID.value	= rowid;
	frm.BOARD_ID.value	= brd_id;
	frm.SEQ.value		= seq;
	frm.DEPTH.value		= depth;
	frm.target			= "_self";
	frm.action			= "/QMS/jsp/view/bbs/bbs_detail_view.jsp";
	frm.submit();
}
/**
 * 진척관리외 새글 상세보기
 */
function uf_detail2(rowid, seq, depth, brd_id) {
	var frm				= document.frm;	
	frm.BBS_ID.value	= rowid;
	frm.BOARD_ID.value	= brd_id;
	frm.SEQ.value		= seq;
	frm.DEPTH.value		= depth;
	frm.target			= "_self";
	frm.action			= "/QMS/jsp/view/bbs/bbs_noticeList_detail_view.jsp";
	frm.submit();
}
</script>
<%@ include file="/jsp/inc/inc_bottom.jsp" %>