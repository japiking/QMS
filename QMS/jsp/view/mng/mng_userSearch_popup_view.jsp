<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>

<%@ include file="/jsp/inc/inc_common.jsp"%>
<%@ include file="/jsp/inc/inc_header.jsp"%>
<%
Map<String,String> dataMap		= null;
List<Map<String,String>> list	= new ArrayList();
list 							= qmsDB.selectList("QMS_BBS_LIST.USERINFO_R001");

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
		var temp = [];
		var name = $("#ipSearch").val();
		for(var i=0; i<dat_list.length; i++){
			var dat = dat_list[i];
			var str = dat.USERNAME;
			if(str == name) {
				temp.push(dat);
			}
		}
		$("#tbody_area").empty();
		
		var html = "";
		for(var j=0; j<temp.length; j++){
			var html_dat = temp[j];
			html += "<tr>";
			html += "	<td style='text-align: center;'>";
			html += "   	<input type='radio' name='check_rdo'/>";
			html += "	</td>";
			html += "	<td style='text-align: center;'  id='user_id' >"+html_dat.USERID+"</td>";
			html += "	<td style='text-align: center;' >"+html_dat.USERNAME+"</td>";
			html += "	<td style='text-align: center;' >"+html_dat.USERIP+"</td>";
			html += "	<td style='text-align: center;' >"+html_dat.BIGO+"</td>";
			html += "</tr>";
		}
		$("#tbody_area").html(html);
	});
	
	// 사용자명 검색시
	$("#aSelect").click(function() {
		$("#tbody_area tr").each(function() {
            var item = {};
           if( $("input:radio", this).is(":checked")) {
              $('#PROJECTMANAGERID', opener.document).val($(this).find("#user_id").text());
              window.close();
           }
        }); 
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
			<col width="20%"/>
			<col width="*%"/>
		</colgroup>
		<thead>
			<th scope="row"></th>
			<th scope="row">ID</th>
			<th scope="row">이름</th>
			<th scope="row">IP</th>
			<th scope="row">비고</th>
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
				<td style="text-align: center;" ><%=dataMap.get("USERIP") %></td>
				<td><%=StringUtil.null2void(dataMap.get("BIGO")) %></td>
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