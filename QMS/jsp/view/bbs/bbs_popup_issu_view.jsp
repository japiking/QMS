<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>

<%@ include file="/jsp/inc/inc_common.jsp"%>
<%@ include file="/jsp/inc/inc_header.jsp"%>
<%
Map<String,String> dataMap		= null;
Map<String,String> param		= new HashMap<String,String>();
List<Map<String,String>> list	= new ArrayList();

param.put("PROJECTID", userSession.getProjectID());
list 							= qmsDB.selectList("QMS_BBS_LIST.USERINFO_R002", param);

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
		dat_list.push(item);
<%
	}
}
%>
$(document).ready(function(){
	
	// 사용자명 검색시
	$("#btn_inqry").click(function() {
		var temp = [];
		var name = $("#ipSearch").val();
		for(var i=0; i<dat_list.length; i++){
			var dat = dat_list[i];
			var str = dat.USERNAME;
			var dataId = dat.USERID;
			if(str.indexOf(name) > -1 || dataId.indexOf(name) > -1) {
				temp.push(dat);
			}
		}
		$("#tbody_area").empty();
		
		var html = "";
		for(var j=0; j<temp.length; j++){
			var html_dat = temp[j];
			html += "<tr>";
			html += "	<td style='text-align: center;'>";
			html += "   	<input type='checkbox' name='check_rdo'/>";
			html += "	</td>";
			html += "	<td style='text-align: center;'  id='user_id' >"+html_dat.USERID+"</td>";
			html += "	<td style='text-align: center;'  id='user_nm' >"+html_dat.USERNAME+"</td>";
			html += "</tr>";
		}
		$("#tbody_area").html(html);
	});
	
	// 사용자명 검색시
	$("#aSelect").click(function() {
		var userId_list = "";
		var userNm_list = "";
		$("#tbody_area tr").each(function() { 
           if( $("input:checkbox", this).is(":checked")) {
              userId_list += $(this).find("#user_id").text() +", ";
              userNm_list += $(this).find("#user_nm").text() +"("+$(this).find("#user_id").text()+"), ";
           }
        });
		userId_list = userId_list.substring(0, userId_list.length-2)
		userNm_list = userNm_list.substring(0, userNm_list.length-2)
        $('#proc_userid', opener.document).val(userId_list);
        $('#proc_usernm', opener.document).text(userNm_list);
        window.close();
	});
});
	
</script>
<form name="frm" method="post">
<div class="wrap">
	<div class="btnWrapl">
		<input type="text" id="ipSearch" placeholder="사용자명 검색"/>
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
					<input type="checkbox" name="check_rdo"/>
				</td>
				<td style="text-align: center;" id="user_id"><%=dataMap.get("USERID") %></td>
				<td style="text-align: center;" id="user_nm"><%=dataMap.get("USERNAME") %></td>
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
<% if (qmsDB != null) try { qmsDB.close(); } catch (Exception e1) {} %>