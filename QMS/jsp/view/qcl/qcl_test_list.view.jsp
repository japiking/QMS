<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ include file="/jsp/inc/inc_common.jsp" %>
<%@ include file="/jsp/inc/inc_header.jsp" %>
 
<script src="/QMS/js/qcl/qcl_test_list.view.js"></script>

<%@ include file="/jsp/inc/inc_topMenu.jsp" %>
<%@ include file="/jsp/inc/inc_leftMenu.jsp" %>
<form name="frm" method="post">

<input type="hidden" name="TEST_ID" id="TEST_ID" />

<h3>�׽�Ʈ ������</h3>


<table id="jqGrid"></table>
<div id="jqGridPager"></div>

<script type="text/javascript"> 
//�׽�Ʈ �׸���   
     $(document).ready(function () {	
    	 $("#jqGrid").jqGrid({
        	 sortable: true,
             caption: "�׽�Ʈ���",
             datatype: "local",
             colNames:['TEST_ID','�׽�Ʈ ��','�ó����� �Ǽ�','���̽� �Ǽ�','step �Ǽ�', 'TEST ������','TEST ������','TEST_BIGO'],
             colModel: [
                { label: 'TEST_ID'  	,	index: 'TEST_ID',           	name: 'TEST_ID',			width: 75, 	hidden:false,	editable: true,searchoptions:{sopt:["eq","bw","le"]}},
				{ label: '�׽�Ʈ ��'		,	index: 'TEST_NM', 			 	name: 'TEST_NM',	 		width: 75, 	editable: true,	searchoptions:{sopt:["eq","bw","le"]}},
				{ label: '�ó����� �Ǽ�'		,	index: 'SCENARIO_CNT', 			name: 'SCENARIO_CNT',		width: 75, 	editable: true},
				{ label: '���̽� �Ǽ�'		,	index: 'CASE_CNT', 				name: 'CASE_CNT', 			width: 75, 	editable: true},
				{ label: 'step �Ǽ�'		,	index: 'STEP_CNT', 				name: 'STEP_CNT',	 		width: 100, editable: true},
				{ label: 'TEST ������'	,	index: 'TEST_STTG_DATE', 		name: 'TEST_STTG_DATE', 	width: 80 , editable: true,	searchoptions:{sopt:["eq","bw","le"]}},
				{ label: 'TEST ������'	,	index: 'TEST_ENDG_DATE', 		name: 'TEST_ENDG_DATE', 	width: 80 , editable: true,	searchoptions:{sopt:["eq","bw","le"]}},
				{ label: 'TEST_BIGO'	,   index: 'TEST_BIGO',             name: 'TEST_BIGO',			width: 75, 	hidden:true,	editable: true},
             ],
           
             loadonce			:true, 
			 viewrecords		: true,				
             autowidth			: true,				//�׸��� ����
             height				: 500,					//�׸��� ����
             rowNum				: 20,						//�⺻ ���������� �����ִ� row��
             rowList			:[10,20,50,100],     	//���������� �����ִ� row��
             userDataOnFooter	: true, 		//
             rownumbers			:true, 
             pager				: "#jqGridPager",
                                     
             ondblClickRow : function(rowid, iCol){ 
             		var frm				=document.frm;
             		var list 			= jQuery("#jqGrid").getRowData(rowid);
             		$('#TEST_ID').val(list.TEST_ID); 										//�ó����� ȭ������ �̵� �̺�Ʈ
             		
             		frm.target			='_self';
             		frm.action			="/QMS/jsp/view/qcl/qcl_scenario_list_view.jsp";
             		frm.submit();
             		
             	},    
    	  });
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