<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>    
<%@ include file="/jsp/inc/inc_common.jsp" %>
<%@ include file="/jsp/inc/inc_header.jsp" %>

<%
	String strDUE_DATE	= StringUtil.null2void(request.getParameter("DUE_DATE"));
	String prj_gbn		= StringUtil.null2void(request.getParameter("PROC_GBN"));
	String prj_id		= StringUtil.null2void(request.getParameter("PROJECT_ID"));
	String sql			= "";
	String prj_nm		= "";
	String prjStartDate	= "";
	String prjEndDate	= "";
	String pm_id		= "";
	String bigo			= "";
	String btn_nm		= "";
	
	Map<String, String> to_dateMap = null;
	if(!"U".equals(prj_gbn)){
		// ������Ʈ ���
		strDUE_DATE  = DateTime.getInstance().getDate("yyyy-MM-dd");
		prjStartDate = strDUE_DATE;
		prjEndDate   = prjStartDate;
		btn_nm		 = "���";
	} else {
		try{
			// ������Ʈ ����
			Map<String,String> param1		= new HashMap<String,String>();
			param1.put("PROJECTID", prj_id);
			to_dateMap	= qmsDB.selectOne("QMS_SUPERUSER.PROJECTINFO_R003", param1);
	
			prj_nm		= StringUtil.null2void(to_dateMap.get("PROJECTNAME"));
			prjStartDate= StringUtil.null2void(to_dateMap.get("PROJECTSTARTDATE"));
			prjEndDate	= StringUtil.null2void(to_dateMap.get("PROJECTENDDATE"));
			pm_id		= StringUtil.null2void(to_dateMap.get("PROJECTMANAGERID"));
			bigo		= StringUtil.null2void(to_dateMap.get("BIGO"));
			btn_nm		 = "����";
		}catch(Exception e){
			e.printStackTrace(System.out);
			if (qmsDB != null)
				try { qmsDB.close(); } catch (Exception e1) {}
		}
	}
	
%>

<script type="text/javascript">
	function uf_regedit() {
		if(frm.PROJECTNAME.value == "") {
			alert("������Ʈ���� �ʼ� �Է»����Դϴ�.");
			return;
		}
		
		if(frm.PROJECTMANAGERID.value == "") {
			alert("PM ID�� �ʼ� �Է»����Դϴ�.");
			return;
		}
		
		if(frm.BIGO.value == "") {
			alert("���� �ʼ� �Է»����Դϴ�.");
			return;
		}
		
		frm.target			= '_self';
		frm.action			= "/QMS/jsp/proc/mng/mng_projectReg_do.jsp";
		frm.submit();

	}
	// PM id ã��
	function uf_search(){
		var cw=screen.availWidth;     //ȭ�� ����
		var ch=screen.availHeight;    //ȭ�� ����
		
		sw=800;    //��� â�� ����
		sh=400;    //��� â�� ����
		ml=(cw-sw)/2;        //��� �������� â�� x��ġ
		mt=(ch-sh)/2;         //��� �������� â�� y��ġ
		window.open('','EXCEL','width='+sw+',height='+sh+',top='+mt+',left='+ml+',resizable=no,scrollbars=yes');
		//[��ó] �ڹٽ�ũ��Ʈ �˾� ��� ���� �˾� ��� ����|�ۼ��� �糪
		
		//window.open('', 'EXCEL', 'scrollbars=no,toolbar=yes,resizable=no,width=400,height=180,left=350,top=200');
		frm.target			= "EXCEL";
		frm.action			= "/QMS/jsp/view/mng/mng_userSearch_popup_view.jsp";
		frm.submit();
	}
	
	$(document).ready(function() {
		$("#PROJECTSTARTDATE").datepicker();
		$("#PROJECTENDDATE").datepicker();
	});
	
</script> 
 

<%@ include file="/jsp/inc/inc_topMenu.jsp" %>
<%@ include file="/jsp/inc/inc_leftMenu.jsp" %>
 
<form name="frm" method="post">
<input type="hidden" name="PROC_GBN"   value="<%=prj_gbn%>"/>
<input type="hidden" name="PROJECT_ID" value="<%=prj_id%>" />
<!-- <div  style="width:750px;"> -->

<div class="wrap">
	<h3>�ý��۰����� &gt; ������Ʈ ���</h3>
	<table>
		<colgroup>
			<col width="150px"/>
			<col width="250px"/>
			<col width="100px"/>
			<col width="*"/>
		</colgroup>
		<tbody>
			<tr>				
				<th>������Ʈ��</th>
				<td colspan="3">
					<input type="text" name="PROJECTNAME" style="width:200px" value="<%=prj_nm%>"/>		
				</td>			
			</tr>
			<tr>				
				<th>������Ʈ �Ⱓ</th>
				<td colspan="3">
					<input readonly="readonly" id="PROJECTSTARTDATE" name="PROJECTSTARTDATE" value="<%=prjStartDate%>" style="width: 70px"  /><!--  ������ -->
					 &nbsp ~ &nbsp
					<input readonly="readonly" id="PROJECTENDDATE" name="PROJECTENDDATE" value="<%=prjEndDate%>"  style="width: 70px" /><!--  ������ -->
				</td>			
			</tr>
			<tr>				
				<th>PM ID</th>
				<td colspan="3">
					<input type="text" id="PROJECTMANAGERID" name="PROJECTMANAGERID" value="<%=pm_id%>"  style="width:120px" value=""/>
					<a href="#FIT" class="btn" onclick="javascript:uf_search();"><span>ã��</span></a>		
				</td>		
			</tr>	
			<tr>				
				<th>���(�������)</th>
				<td colspan="3">
					<textarea id="BIGO" name="BIGO" cols="50" rows="4"><%=bigo%></textarea>	
				</td>		
			</tr>		
		</tbody>
	</table>


	<div class="btnWrapR">
		<a href="#FIT" class="btn" onclick="javascript:uf_regedit();"><span><%=btn_nm%></span></a>
	</div>

</div>
<!-- //wrap -->
</form>
<IFRAME SRC="" frameborder="0" id="HiddenFrame" name="HiddenFrame" width="0" height="0" marginwidth="0" marginheight="0" scrolling="no" allowtransparency="true"></IFRAME>



<%@ include file="/jsp/inc/inc_bottom.jsp" %>