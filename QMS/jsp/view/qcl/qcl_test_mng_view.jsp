<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%@ include file="/jsp/inc/inc_common.jsp" %>
<%@ include file="/jsp/inc/inc_header.jsp" %>
<%
String today		= DateTime.getInstance().getDate("yyyy-mm-dd");
String inq_date		= StringUtil.null2void(request.getParameter("INQ_DATE"), today);
%>
<script src="/QMS/js/qcl/qcl_test_mng_view.js"></script>
<script type="text/javascript">
//TEST ID �ߺ� üũ	
function ts_idCheck(){
	var id = $("#test_id").val();
	if(id != null) id = $.trim(id);
	
	if(id == ""){
		alert("ID�� �Է��ϼ���.");
		return false;
	}
	
	frm.target			= 'HiddenFrame';
	frm.action			= "/QMS/jsp/proc/qcl/qcl_test_idCheck_do.jsp";
	frm.submit();
}
//TEST ID ���
function ts_regedit() {
	var frm = document.frm;
	
	if(frm.test_nm.value == "") {
		alert("TEST ���� �ʼ� �Է»����Դϴ�.");
		return;
	}
		
	frm.target			= '_self';
	frm.action			= "/QMS/jsp/proc/qcl/qcl_test_insert_do.jsp";
	frm.submit();

}

</script>
<%@ include file="/jsp/inc/inc_topMenu.jsp" %>
<%@ include file="/jsp/inc/inc_leftMenu.jsp" %>
<form name="frm" method="post" action="/QMS/jsp/view/qcl/qcl_test_regist_view.jsp" >
<input type="hidden" name="TEST_ID1" id="TEST_ID1" />
<input type="hidden" name="STT_DATE" />
<input type="hidden" name="END_DATE" />
<input type="hidden" name="BIGO" />
<input type="hidden" name="NM" />
<h3>�׽�Ʈ ����</h3>
<!-- �׽�Ʈ ���  -->
<div class="wrap">
	<table>
	
		<colgroup>
			<col width="15%"/>
			<col width="15%"/>
			<col width="15%"/>
			<col width="15%"/>
			<col width="*"/>	
		</colgroup>
		<tbody>
		
			<tr>
				<th>TEST ID</th>
					<td>
						<input type="text" id="test_id" name="test_id" style="width:200px"/>
						<a href="#FIT" class="btn" onclick="javascript:ts_idCheck();"><span>�ߺ�Ȯ��</span></a>
					</td>						
				<th>TEST ��</th>
					<td>
						<input type="text" id="test_nm" name="test_nm" style="width:200px" />
					</td>
			</tr>	
			<tr>				
				<th>TEST ������</th>
				<td>
					<div class="btnWrapL">
						<input readonly="readonly" id="test_sttg_date" name="test_sttg_date" value="<%=inq_date%>" style="width: 70px"  onclick="javascript:datepicker_view(frm.test_sttg_date);" />
					    <!-- <a href="#FIT" onclick="javascript:datepicker_view(frm.test_sttg_date);"><img src="/QMS/img/btn_s_cal.gif" alt="�޷�" class="bt_i"></a> -->
					</div>
				</td>
				<th>TEST ������</th>
				<td>
					<div class="btnWrapL">
						<input readonly="readonly" id="test_endg_date" name="test_endg_date" value="<%=inq_date%>" style="width: 70px"  onclick="javascript:datepicker_view(frm.test_endg_date);" />
					    <!-- <a href="#FIT" onclick="javascript:datepicker_view(frm.test_endg_date);"><img src="/QMS/img/btn_s_cal.gif" alt="�޷�" class="bt_i"></a> -->
					</div>
				</td>
			</tr>
			<tr>				
				<th>���(�������)</th>
				<td colspan="5">
					<textarea id="test_bigo" name="test_bigo" cols="80" rows="10" style="width:1000px; height:100px; overflow-y:hidden;"></textarea>	
				</td>		
			</tr>	

	</tbody>
						
	</table>
	</div>
	<br>
<div class="btnWrapL">
	<a href="#FIT" class="btn" style="vertical-align: bottom" onclick="javascript:ts_regedit();"><span>���</span></a>
</div>					
<br>

<table id="jqGrid"></table>
<div id="jqGridPager"></div>
<script type="text/javascript"> 
   
     $(document).ready(function () {
    	 
    	 //�޷� �̺�Ʈ
    	 $("#test_sttg_date").datepicker({
 			dateFormat : 'yy-mm-dd',
 			showAnim: "slideDown"
 		});
    	 $("#test_endg_date").datepicker({
 			dateFormat : 'yy-mm-dd',
 			showAnim: "slideDown"
 		});
    	 
    	 //test��� �׸���
    	 $("#jqGrid").jqGrid({
        	 sortable: true,
             caption: "TEST ���",
             datatype: "local",
             colNames:['TEST_ID','�׽�Ʈ ��','�ó����� �Ǽ�','���̽� �Ǽ�','step �Ǽ�', 'TEST ������','TEST ������','��������','TEST_BIGO'],
             colModel: [
                { label: 'TEST_ID'  , 	index: 'TEST_ID',           	name: 'TEST_ID',			key:true,	width: 75,editable: true,searchoptions:{sopt:["eq","bw","le"]}},
				{ label: '�׽�Ʈ ��'	,	index: 'TEST_NM', 			 	name: 'TEST_NM',	 		width: 75, 	editable: true,searchoptions:{sopt:["eq","bw","le"]}},
				{ label: '�ó����� �Ǽ�'	,	index: 'SCENARIO_CNT', 			name: 'SCENARIO_CNT',		width: 75, 	editable: true},
				{ label: '���̽� �Ǽ�'	,	index: 'CASE_CNT', 				name: 'CASE_CNT', 			width: 75, 	editable: true},
				{ label: 'step �Ǽ�'	,	index: 'STEP_CNT', 				name: 'STEP_CNT',	 		width: 100, editable: true},
				{ label: 'TEST ������'	,	index: 'TEST_STTG_DATE', 		name: 'TEST_STTG_DATE', 	width: 80 , editable: true,editoptions:{size:12, dataInit:datepicker_view},searchoptions:{sopt:["eq","bw","le"]}},
				{ label: 'TEST ������'	,	index: 'TEST_ENDG_DATE', 		name: 'TEST_ENDG_DATE', 	width: 80 , editable: true,editoptions:{size:12, dataInit:datepicker_view},searchoptions:{sopt:["eq","bw","le"]}},
				{ label: '��������'	,	index: 'DEL_FLAG', 				name: 'DEL_FLAG', 			width: 80 , editable: true,edittype:'select',formatter:'select',editoptions:{value:'Y:Y;N:N'}},
				{ label: 'TEST_BIGO',   index: 'TEST_BIGO',             name: 'TEST_BIGO',			width: 75, 	hidden:true,	editable: true},
				
             ],
             rownumbers			:true,
             loadonce			:true, 
             multiselect		: true,
			 viewrecords		: true,				
             autowidth			: true,				//�׸��� ����
             height				: 300,					//�׸��� ����
             rowNum				: 20,						//�⺻ ���������� �����ִ� row��
             rowList			:[10,20,50,100],     	//���������� �����ִ� row��
             userDataOnFooter	: true, 		//
             multiselect		: false, 
             pager				: "#jqGridPager",
             
             ondblClickRow : function(rowid, iCol){ 
             		var frm				=document.frm;
             		var list 			= jQuery("#jqGrid").getRowData(rowid);
             		$('#TEST_ID1').val(list.TEST_ID); 
             		
             		frm.target			='_self';
             		frm.action			="/QMS/jsp/view/qcl/qcl_test_regist_view.jsp";
             		frm.submit();
             		
             	}    
    	  });
    	
    	 $("#jqGrid").navGrid("#jqGridPager",
                 {
        	 add:false,search:false,refresh: false, edit: true,del:false,view:true,edittext:"����",position: "left",	cloneToTop: false },
        	
        	 {
             	/* Edit options */
             	addCaption: "Add Record",	editCaption: "���Լ���",	bSubmit: "����",	bCancel: "���",	bClose: "�ݱ�",	saveData: "�����Ͻðڽ��ϱ�?",
         		bYes : "Yes",	bNo : "No",	bExit : "Cancel",	
         		ShowForm: function(form) {
         		    form.closest('div.ui-jqdialog').center();
         		},
         		onclickSubmit 	:edit_submit,
         		closeAfterEdit	: true,
         		recreateForm	: true,
         		viewPagerButtons: true,
         		closeOnEscape	:true
             	
             }
        	 );
    	 //�˻� option
    	 var gridOption = {searchOperators:true
    			 ,stringResult: true
    			 ,searchOnEnter: true
    			 ,odata: [{ oper:'eq', text:'equal'},{ oper:'ne', text:'not equal'},{ oper:'lt', text:'less'},{ oper:'le', text:'less or equal'},{ oper:'gt', text:'greater'},{ oper:'ge', text:'greater or equal'},{ oper:'bw', text:'begins with'},{ oper:'bn', text:'does not begin with'},{ oper:'in', text:'is in'},{ oper:'ni', text:'is not in'},{ oper:'ew', text:'ends with'},{ oper:'en', text:'does not end with'},{ oper:'cn', text:'contains'},{ oper:'nc', text:'does not contain'}] };
    	 jQuery("#jqGrid").jqGrid('filterToolbar',gridOption);
    	 
       	uf_loadProgState(); //����Ʈ ������ ȣ��
 
     });
</script>
</form>
<%@ include file="/jsp/inc/inc_bottom.jsp" %>