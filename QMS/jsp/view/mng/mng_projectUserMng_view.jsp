<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>    
<%@ include file="/jsp/inc/inc_common.jsp" %>
<%@ include file="/jsp/inc/inc_header.jsp" %>

<%
List<Map<String,String>> list	= new ArrayList();
list 							= qmsDB.selectList("QMS_SUPERUSER.USERINFO_R002");

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
<div class="wrap">
<input type="hidden" name="PROC_GBN" />
	<h3>�ý��۰����� &gt; ������Ʈ ����</h3>
	
	<table class="list" style="width:730px;">
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
				<th scope="col">������Ʈ �ڵ�</th>
				<th scope="col">������Ʈ��</th>
				<th scope="col">�����</th>
				<th scope="col">������</th>
				<th scope="col">������</th>
				<th scope="col">PM ID</th>
				<th scope="col">����/����</th>
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
				<td class="alC"><%=dataMap.get("USERID")%></td>
				<td class="alL"><%=dataMap.get("USERNAME")%></td>
				<td class="alC"><%=dataMap.get("USERIP")%></td>
				<td class="alC"><%=dataMap.get("BIGO")%></td>
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