<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>

<%@ include file="/jsp/inc/inc_common.jsp"%>
<%@ include file="/jsp/inc/inc_header.jsp"%>
<%
String userId					= StringUtil.null2void(userSession.getUserID());
String projectId				= StringUtil.null2void(userSession.getProjectID());
StringBuffer sbSql				= new StringBuffer();
Map<String,String> dataMap		= null;
List<Map<String,String>> list	= new ArrayList<Map<String,String>>();
List<String> aList				= new ArrayList<String>();

try {
	Map<String,String> paramR001 = new HashMap<String,String>();
	paramR001.put("PROJECTID",	projectId);
	paramR001.put("USERID",		userId);
	list = qmsDB.selectList("QMS_BBS_ONELOW.USERINFO_R001", paramR001);

} catch (Exception e) {
	if (qmsDB != null) try { qmsDB.close(); } catch (Exception e1) {}
}

%>
<form name="frm" method="post" action="bbs_oneRowList_view.jsp" target="oneRowListAddReceiver" >
<div class="wrap">
	<div class="btnWrapl">
		<input type="text" id="ipSearch" placeholder="사용자검색"/>
		<a href="#FIT" class="btn" id="inqury"><span>검색</span></a>
	</div>
	<table id="tbl001" class="list">
		<colgroup>
			<col width="10%"/>
			<col width="45%"/>
			<col width="45%"/>
		</colgroup>
		<thead>
			<tr>
				<th scope="col"><input type="checkbox" name="checkBox" id="allCheck" /></th>
				<th scope="col">사용자이름</th>
				<th scope="col">사용자ID</th>
			</tr>
		</thead>
		<tbody id="user_list">
			<!-- Inner Html -->
		<% if (list == null || list.size() == 0) { %>
			<tr>
				<td colspan="4">조회 데이터가 없습니다.</td>
			</tr>
		<% } else {
				for (int i=0; i<list.size(); i++) {
					dataMap	= list.get(i);
		%>
			<tr>
				<td><input class="inputChoice" type="checkbox" name="checkBox" value="<%=dataMap.get("USERNAME")%>(<%=dataMap.get("USERID")%>)"/></td>
				<td><span><%=dataMap.get("USERNAME")%></span></td>
				<td><span><%=dataMap.get("USERID")%></span></td>
			</tr>
		<%		}//end for
	  	   }// end else
	  	%>
		</tbody>
	</table>
	<div class="btnWrapC">
		<a href="#FIT" class="btn" id="aSelect"><span>선택</span></a>
		<a href="#FIT" class="btn" onclick="javascript:window.close();"><span>취소</span></a>
	</div>
</div>
</form>
<script src="/QMS/js/bbs/bbs_receive_popup.js"></script>
<%
if (qmsDB != null) try { qmsDB.close(); } catch (Exception e1) {}
%>