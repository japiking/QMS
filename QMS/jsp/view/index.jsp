<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
    
<%@ include file="/jsp/inc/inc_common.jsp" %>
<%@ include file="/jsp/inc/inc_header.jsp" %>

<%
	List<Map<String,String>> list = qmsDB.selectList("QMS_SUPERUSER.PROJECTINFO_R002");      
%> 



<%@ include file="/jsp/inc/inc_topMenu.jsp" %>
<%@ include file="/jsp/inc/inc_leftMenu.jsp" %>
<form name="frm" method="post">
  <input type="hidden" name="MODE" />
  <input type="hidden" name="ROW_ID" />
  <input type="hidden" name="PAGE_NUM"		value="1" />
  <input type="hidden" name="PAGE_COUNT"	value="20" />


<div class="wrap">
	<h3>�ý��۰����� > ������Ʈ�� ��Ȳ(������ȸ)</h3>	
	
	<table class="list alR">
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
				<th class="alC">������Ʈ �ڵ�</th>
				<th class="alC">������Ʈ��</th>
				<th class="alC">������</th>
				<th class="alC">������</th>
				<th class="alC">PM ID</th>
				<th class="alC">PM ��</th>
				<th class="alC">�̿��ڼ�</th>
				<th class="alC">�Խ��Ǽ�</th>
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
<!-- //wrap -->

</form>

<%@ include file="/jsp/inc/inc_bottom.jsp" %>