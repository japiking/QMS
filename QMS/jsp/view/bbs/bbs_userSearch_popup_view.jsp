<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>

<%@ include file="/jsp/inc/inc_common.jsp"%>
<%@ include file="/jsp/inc/inc_header.jsp"%>
<%
String USERID		= StringUtil.null2void(request.getParameter("ipSearch"));
Map<String,String> dataMap		= null;
Map<String,String> param		= new HashMap<String,String>();
List<Map<String,String>> list	= new ArrayList();
param.put("PROJECTID", userSession.getProjectID());
param.put("USERID",    USERID);
param.put("PROJECTID", userSession.getProjectID());
list 							= qmsDB.selectList("QMS_BBS_LIST.USERINFO_R003", param);

%>
<script type="text/javascript">
var dat_list = [];
<%
Map<String,String> tempMap		= null;
if(null != list && !list.isEmpty()){
	for(int i =0; i<list.size(); i++){
		tempMap = list.get(i);
		
%>
		var item = {};
		item.USERID 	= '<%=tempMap.get("USERID")%>';
		item.USERNAME 	= '<%=tempMap.get("USERNAME")%>';
		item.USERIP 	= '<%=tempMap.get("USERIP")%>';
		item.BIGO 		= '<%=StringUtil.null2void(tempMap.get("BIGO"))%>';
		dat_list.push(item);
<%
	}
}
%>
$(document).ready(function(){
	
	// 사용자명 검색시
	$("#btn_inqry").click(function() {
		var pop_frm				= document.form_pop;
		pop_frm.target			= "_self";
		pop_frm.action			= "/QMS/jsp/view/bbs/bbs_userSearch_popup_view.jsp";
		pop_frm.submit();
	});
	
	// 사용자명 검색시
	$("#aSelect").click(function() {
		$("#tbody_area tr").each(function() {
            var item = {};
           if( $("input:radio", this).is(":checked")) {
              $('#confirm_usernm', opener.document).text($(this).find("#user_id").text());
              window.close();
           }
        }); 
	});
});
	
</script>
<form name="form_pop" method="post">
<div class="wrap">
	<div class="btnWrapl">
		<input type="text" id="ipSearch" name="ipSearch" placeholder="사용자명 검색" value="<%=USERID%>" />
		<a href="#FIT" class="btn" id="btn_inqry"><span>검색</span></a>
	</div>
	<br/>
	<table>
		<colgroup>
			<col width="5%"/>
			<col width="15%"/>
			<col width="15%"/>
		</colgroup>
		<thead>
			<th scope="row"></th>
			<th scope="row">ID</th>
			<th scope="row">이름</th>
		</thead>
		<tbody id="tbody_area">
		<%
			if(null != list && !list.isEmpty()){
				for(int i =0; i<list.size(); i++){
					dataMap = list.get(i);
					
		%>
			<tr>
				<td style="text-align: center;">
					<input type="radio" name="check_rdo"/>
				</td>
				<td style="text-align: center;" id="user_id"><%=dataMap.get("USERID") %></td>
				<td style="text-align: center;" ><%=dataMap.get("USERNAME") %></td>
			</tr>
		<%
				}
			}
		%>
		</tbody>
	</table>
	<div class="btnWrapC">
		<a href="#FIT" class="btn" id="aSelect"><span>선택</span></a>
		<a href="#FIT" class="btn" onclick="javascript:window.close();"><span>취소</span></a>
	</div>
</div>
</form>
<%if (qmsDB != null) try { qmsDB.close(); } catch (Exception e1) {}  %>