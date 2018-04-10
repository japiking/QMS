<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>    
<%@ include file="/jsp/inc/inc_common.jsp" %>
<%@ include file="/jsp/inc/inc_header.jsp" %>

<%
	List<Map<String,String>> list	= null;
	
	list		= qmsDB.selectList("QMS_SUPERUSER.PROJECTINFO_R001");
	LogUtil.getInstance().debug("��������");
%>

<script type="text/javascript">
	function uf_edit(prj_id) {
		frm.PROJECT_ID.value = prj_id;
		frm.PROC_GBN.value  = "U";
		frm.target			= '_self';
		frm.action			= "/QMS/jsp/view/mng/mng_projectReg_view.jsp";
		frm.submit();
	}
	
	function uf_delete(prj_id) {
		frm.PROJECT_ID.value = prj_id;
		frm.PROC_GBN.value  = "D";
		frm.target			= '_self';
		frm.action			= "/QMS/jsp/proc/mng/mng_projectUpd_do.jsp";
		frm.submit();
	}
	
</script> 
  




<%@ include file="/jsp/inc/inc_topMenu.jsp" %>
<%@ include file="/jsp/inc/inc_leftMenu.jsp" %>
<form name="frm" method="post">
<input type="hidden" name="PROC_GBN" />
<input type="hidden" name="PROJECT_ID" />
<div class="wrap">
	<h3>�ý��۰����� &gt; ������Ʈ ����</h3>
	
	<table class="list">
		<colgroup>
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
				<th scope="col" style="text-align: center;">������Ʈ �ڵ�</th>
				<th scope="col" style="text-align: center;">������Ʈ��</th>
				<th scope="col" style="text-align: center;">�����</th>
				<th scope="col" style="text-align: center;">������</th>
				<th scope="col" style="text-align: center;">������</th>
				<th scope="col" style="text-align: center;">PM ID</th>
				<th scope="col" style="text-align: center;">����/����</th>
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
						LogUtil.getInstance().debug("������");
		%>
			<tr>
				<td class="alC"><%=dataMap.get("PROJECTID")%></td>
				<td class="alL"><%=dataMap.get("PROJECTNAME")%></td>
				<td class="alC"><%=dataMap.get("PROJECTREGDATE")%></td>
				<td class="alC"><%=dataMap.get("PROJECTSTARTDATE")%></td>
				<td class="alC"><%=dataMap.get("PROJECTENDDATE")%></td>
				<td class="alC"><%=dataMap.get("PROJECTMANAGERID")%></td>
				<td class="wBtn"><a href="#" class="sBtn" onclick="javascript:uf_edit('<%=dataMap.get("PROJECTID")%>');">����</a>&nbsp;<a href="#" class="sBtn" onclick="javascript:uf_delete('<%=dataMap.get("PROJECTID")%>');">����</a>&nbsp;</td>
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
<IFRAME SRC="" frameborder="0" id="HiddenFrame" name="HiddenFrame" width="0" height="0" marginwidth="0" marginheight="0" scrolling="no" allowtransparency="true"></IFRAME>



<%@ include file="/jsp/inc/inc_bottom.jsp" %>