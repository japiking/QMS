<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ include file="/jsp/inc/inc_common.jsp" %>
<%@ include file="/jsp/inc/inc_header.jsp" %>>
<%
	String testId		=	request.getParameter("TEST_ID");
	String projectId	=	userSession.getProjectID();
	String caseId		=	request.getParameter("CS_ID");
	String scenarioId	=	request.getParameter("SC_ID");
	String stepId		=	request.getParameter("SP_ID");
	
%>
<form name="frm" method="post"> 
<script src="/QMS/js/qcl/qcl_test_case_popup_view.js"></script>
<h3>�׽�Ʈ ����</h3>
<!-- ������ ��� ���� ���� -->
	<div id="dialog2" title="���� ��� ���" style="display:none">
	
		<table>
			<tr>
				<th>���� ID</th>
					<td>
						<input readonly="readonly" id="stID" name="stID" style="width:200px"/>
					</td>						
				<th>���� ��</th>
					<td>
						<input readonly="readonly" id="stNM" name="stNM" style="width:100px"/>
					</td>
				<th>�׽�Ʈ �� �Ǽ�</th>
					<td>
						<input readonly="readonly" id="tsNUM" name="tsNUM" style="width:50px"/>
					</td>						
			</tr>
		</table>
		<table id="jqGrid1"></table>
		<div id="jqGridPager1"></div>			
		<script type="text/javascript"> 
		//������ ��� �׸���
		$("#jqGrid1").jqGrid({
		        	 sortable: true,
		             caption: "���� ���",
		             datatype: "local",
		             colNames:['�׽��� ID','���������','����������','����','���� ����'],
		             
		             colModel: [
		                { label: '�׽��� ID'		,	index: 'TESTER_ID'		,		name: 'TESTER_ID'	,	 	width: 20, 	editable: true},
						{ label: 'TEST ������'		,	index: 'START_DATE'		,		name: 'START_DATE'	, 		width: 20 , editable: true,  editoptions:{size:12, dataInit:datepicker_view}},
						{ label: 'TEST ������	'	,	index: 'END_DATE'		,		name: 'END_DATE'	, 		width: 20 , editable: true,  editoptions:{size:12, dataInit:datepicker_view}},
						{ label: '����'			,	index: 'STEP_STATUS'	,		name: 'STEP_STATUS'	,		width: 20 , editable: true},
						{ label: '���� ����'		,	index: 'DEL_FLAG'		,		name: 'DEL_FLAG'	,		width: 20 , editable: true}
						
		
		             ],
		           
		             loadonce			: true, 
		             recordpos			: 'right',
					 viewrecords		: true,				
			         width				: 915,					//�׸��� ����
			         height				: 300,					//�׸��� ����
		             rowNum				: 20,						//�⺻ ���������� �����ִ� row��
		             rowList			:[10,20,50,100],     	//���������� �����ִ� row��
		             userDataOnFooter	: true, 		//
		             rownumbers			: true, 
		             pager				: "#jqGridPager1",
		             
		            	
		    	  });	
		$(".ui-jqgrid-titlebar").hide();		//�׸��� ����
		</script>			
	</div>
<input type="hidden" name="st_id" id="st_id"/>
<input type="hidden" name="st_nm" id="st_nm"/>
<table>		
			<table id="jqGrid"></table>
			<div id="jqGridPager"></div>
</table>
<script type="text/javascript"> 
//���� �׸���
     $(document).ready(function () {	
    	 $("#jqGrid").jqGrid({
        	 sortable: true,
             caption: "���� ���",
             datatype: "local",
             colNames:['TEST_ID','SCENARIO_ID','CASE_ID','���� ID','���� ��','TEST ������','TEST ������','��������','����'],
             colModel: [
                { label: 'TEST_ID'  	,  	index: 'TEST_ID'	,       name: 'TEST_ID',		key:true, hidden:true,	editable: true},
                { label: 'SCENARIO_ID'	,	index: 'SCENARIO_ID',       name: 'SCENARIO_ID',	key:true, hidden:true,	editable: true},
                { label: 'CASE_ID'		,	index: 'CASE_ID'	,      	name: 'CASE_ID',		key:true, hidden:true,	editable: true},
                { label: '���� ID'		,	index: 'STEP_ID'	,		name: 'STEP_ID',	 	width: 85, 	editable: true,	searchoptions:{sopt:["eq","bw","le"]}},
				{ label: '���� ��'			,	index: 'STEP_NM'	,		name: 'STEP_NM',		width: 140, editable: true,	searchoptions:{sopt:["eq","bw","le"]}},
				{ label: 'TEST ������'		,	index: 'START_DATE'	, 		name: 'START_DATE', 	width: 50 , editable: true,  editoptions:{size:12, dataInit:datepicker_view},searchoptions:{sopt:["eq","bw","le"]}},
				{ label: 'TEST ������'		,	index: 'END_DATE'	,		name: 'END_DATE', 		width: 50 , editable: true,  editoptions:{size:12, dataInit:datepicker_view},searchoptions:{sopt:["eq","bw","le"]}},
				{ label: '��������'		,	index: 'DEL_FLAG'	,		name: 'DEL_FLAG',	 	width: 20, 	editable: true,  editable: true,edittype:'select',formatter:'select',editoptions:{value:'Y:Y;N:N'}},
				{ label: '����'			,	index: 'STEP_STATUS',		name: 'STEP_STATUS',	width: 20, 	editable: true,	searchoptions:{sopt:["eq","bw","le"]}}
             ],
             loadonce			: true, 
             recordpos			:'right',
			 viewrecords		: true,				
             width				: 1200,				//�׸��� ����
             height				: 400,					//�׸��� ����
             rowNum				: 20,						//�⺻ ���������� �����ִ� row��
             rowList			: [10,20,50,100],     	//���������� �����ִ� row��
             userDataOnFooter	: true, 		//
             rownumbers			: true, 
             pager				: "#jqGridPager",
             
             onSelectRow : function(rowid){ 
            	 	
            		//uf_loadProgState1(rowid);
            		/* var frm=document.frm;
            		var kk 	= jQuery("#jqGrid").getRowData(rowid);
            		frm.stID.value	= kk.STEP_ID;
            		frm.stNM.value	= kk.STEP_NM; */
            		
             }
	
    	  });
    	 
    	 $("#jqGrid").navGrid("#jqGridPager",
    		 {search:false,refresh: false,add:false ,edit: true,del:false,view:false,edittext:"����",position: "left",	cloneToTop: false },
        	 {
             	/* Edit options */
             	addCaption: "Add Record",	editCaption: "���Լ���",	bSubmit: "����",	bCancel: "���",	bClose: "�ݱ�",	saveData: "�����Ͻðڽ��ϱ�?",
         		bYes : "Yes",	bNo : "No",	bExit : "Cancel",	
         		ShowForm: function(form) {
         		    form.closest('div.ui-jqdialog').center();
         		},
         		onclickSubmit : edit_submit,
         		closeAfterEdit: true,
         		recreateForm: true,
         		viewPagerButtons: true,
         		closeOnEscape:true
             });
    	 //������ ��� �޴�
    	 $("#jqGrid").navGrid("#jqGridPager").jqGrid('navButtonAdd',"#jqGridPager",
    			 {
        		  caption:"������ ���",
        		  buttonicon:"ui-icon-arrowthickstop-1-s",
        		  onClickButton: function(){
        			  $("#dialog2").dialog({
        				  autoOpen: true, 
        		          width:  940,					//�׸��� ����
        		          height: 440,					//�׸��� ����
        				  });
        			  
        			  uf_loadProgState1(); //������ ����Ʈ ��������
        			  
        		  },
        		  position:"first",
        		  title:"�׽��� ���",
        		 });	
		//�˻� option
    	 var gridOption = {searchOperators:true
    			 ,stringResult: true
    			 ,searchOnEnter: true
    			 ,odata: [{ oper:'eq', text:'equal'},{ oper:'ne', text:'not equal'},{ oper:'lt', text:'less'},{ oper:'le', text:'less or equal'},{ oper:'gt', text:'greater'},{ oper:'ge', text:'greater or equal'},{ oper:'bw', text:'begins with'},{ oper:'bn', text:'does not begin with'},{ oper:'in', text:'is in'},{ oper:'ni', text:'is not in'},{ oper:'ew', text:'ends with'},{ oper:'en', text:'does not end with'},{ oper:'cn', text:'contains'},{ oper:'nc', text:'does not contain'}] };
    	 jQuery("#jqGrid").jqGrid('filterToolbar',gridOption);
    	 
       	uf_loadProgState('<%=testId%>','<%=projectId%>','<%=scenarioId%>','<%=caseId%>'); //����Ʈ ������ ȣ��
     });

</script>
</form>
<%@ include file="/jsp/inc/inc_bottom.jsp" %>