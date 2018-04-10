<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ include file="/jsp/inc/inc_common.jsp" %>
<%@ include file="/jsp/inc/inc_header.jsp" %>
<%
	String testId		=	request.getParameter("TS_ID");
	String projectId	=	userSession.getProjectID();
	String caseId		=	request.getParameter("CS_ID");
	String scenarioId	=	request.getParameter("SC_ID");

%>
<form name="frm" method="post"> 
<script src="/QMS/js/qcl/qcl_test_step_popup_view.js"></script>
<!-- ���� �� �׽��� ���� -->
<h3>�׽�Ʈ ������</h3>
	<div id="dialog1" title="Dialog Title" style="display:none">
	<table>
		<tr>
			<th>
				STEP ID
			</th>
			<td>
				<input readonly="readonly" id="stID" name="stID" style="width:180px"/>
			</td>						
			<th>
				STEP ��
			</th>
			<td>
				<input readonly="readonly" id="stNM" name="stNM" style="width:160px"/>
			</td>
			<th>
				TEST �� �Ǽ�
			</th>
			<td>
				<input readonly="readonly" id="tsNUM" name="tsNUM" style="width:30px"/>
			</td>						
		</tr>
	</table>
	
	<table id="jqGrid1"></table>
	<div id="jqGridPager1"></div>
				
	<script type="text/javascript">
	//���� �׸���
		$("#jqGrid1").jqGrid({
		        	 sortable: true,
		             caption: "���� ���",
		             datatype: "local",
		             colNames:['ACTION_SEQ','TEST_ID','SCENARIO_ID','CASE_ID','���� ID','�׽��� ID','���������','����������','����','���� ����','����'],
		             colModel: [
						{ label: 'ACTION_SEQ'  	,  	index: 'ACTION_SEQ'		,	name: 'ACTION_SEQ'	,		key:true	,	hidden:true,	editable: true},
						{ label: 'TEST_ID'  	,  	index: 'TEST_ID'		,	name: 'TEST_ID'		,		key:true	,	hidden:true,	editable: true},
						{ label: 'SCENARIO_ID'	,	index: 'SCENARIO_ID'	,	name: 'SCENARIO_ID'	,		key:true	,	hidden:true,	editable: true},
						{ label: 'CASE_ID'		,	index: 'CASE_ID'		,	name: 'CASE_ID'		,		key:true	,	hidden:true,	editable: true},
						{ label: '���� ID'		,	index: 'STEP_ID'		,	name: 'STEP_ID'		,	 	key:true	,	hidden:true,	editable: true},
		                { label: '�׽��� ID'		,	index: 'TESTER_ID'		,	name: 'TESTER_ID'	,	 	width: 20	,	editable: true},
						{ label: 'TEST ������'		,	index: 'START_DATE'		,	name: 'START_DATE'	, 		width: 20	, 	editable: true,  editoptions:{size:12, dataInit:datepicker_view}},
						{ label: 'TEST ������'		,	index: 'END_DATE'		,	name: 'END_DATE'	, 		width: 20	, 	editable: true,  editoptions:{size:12, dataInit:datepicker_view}},
						{ label: '����'			,	index: 'STEP_STATUS'	,	name: 'STEP_STATUS'	,	 	width: 20	, 	editable: true},
						{ label: '���� ����'		,	index: 'STATUS_LEVEL'	,	name: 'STATUS_LEVEL',	 	width: 20	, 	editable: true,hidden:true},
						{ label: '����'			,	index: 'DEL_FLAG'		,	name: 'DEL_FLAG'	,		width: 20	,	editable: true, formatter: exe_del}
		             ],
		             hidegrid: false,
		             loadonce:true, 
		             recordpos:'right',
					 viewrecords: false,				
					 width:  915,					//�׸��� ����
			         height: 300,					//�׸��� ����
		             rowNum: 20,					//�⺻ ���������� �����ִ� row��
		             rowList:[10,20,50,100],     	//���������� �����ִ� row��
		             userDataOnFooter: true, 		//
		             rownumbers:true, 
		             pager: "#jqGridPager1"
		            	
		    	  });	
		$(".ui-jqgrid-titlebar").hide();	//titlebar �Ⱥ��̰� ó��
	</script>			
	</div>
	<table>	
		
	<table id="jqGrid"></table>
	<div id="jqGridPager"></div>
	</table>
	<script type="text/javascript"> 
	   
	     $(document).ready(function () {	
	    	 $("#jqGrid").jqGrid({
	        	 sortable: true,
	             caption: "���� ���",
	             datatype: "local",
	             colNames:['TEST_ID','SCENARIO_ID','CASE_ID','���� ID','���� ��','TEST ������','TEST ������'],
	             colModel: [
	                { label: 'TEST_ID'  	,  	index: 'TEST_ID'		,           name: 'TEST_ID'		,		key:true, hidden:true,	editable: true},
	                { label: 'SCENARIO_ID'	,	index: 'SCENARIO_ID'	,       	name: 'SCENARIO_ID'	,		key:true, hidden:true,	editable: true},
	                { label: 'CASE_ID'		,	index: 'CASE_ID'		,       	name: 'CASE_ID'		,		key:true, hidden:true,	editable: true},
	                { label: '���� ID'		,	index: 'STEP_ID'		, 			name: 'STEP_ID'		,	 	width: 85, 	editable: true,	searchoptions:{sopt:["eq","bw","le"]}},
					{ label: '���� ��'			,	index: 'STEP_NM'		, 			name: 'STEP_NM'		,		width: 140, editable: true,	searchoptions:{sopt:["eq","bw","le"]}},
					{ label: 'TEST ������'		,	index: 'START_DATE'		, 			name: 'START_DATE'	, 		width: 50 , editable: true, editoptions:{size:12, dataInit:datepicker_view},	searchoptions:{sopt:["eq","bw","le"]}},
					{ label: 'TEST ������'		,	index: 'END_DATE'		, 			name: 'END_DATE'	, 		width: 50 , editable: true, editoptions:{size:12, dataInit:datepicker_view},	searchoptions:{sopt:["eq","bw","le"]}},
				
	             ],
	           
	             loadonce:true, 
	             recordpos:'right',
				 viewrecords: true,				
				 width				: 1200,				//�׸��� ����
	             height				: 400,					//�׸��� ����
	             rowNum: 20,					//�⺻ ���������� �����ִ� row��
	             rowList:[10,20,50,100],     	//���������� �����ִ� row��
	             userDataOnFooter: true, 		//
	             rownumbers:true, 
	             pager: "#jqGridPager",

	    	  });
	    	 
	    	 $("#jqGrid").navGrid("#jqGridPager",
	    		 {search:false, refresh:false, edit:false, del:false, view:false, add:false, edittext:"����", position:"left", cloneToTop: false }
	        	);
	    	 //���� ��� ��� �޴�
	      	 $("#jqGrid").navGrid("#jqGridPager").jqGrid('navButtonAdd',"#jqGridPager",
	      			 {
	        		  caption:"������ ���",
	        		  buttonicon:"ui-icon-arrowthickstop-1-s",
	        		  onClickButton: function(){
	        			  $("#dialog1").dialog({
	        				  autoOpen:true, 
	        				  width:  940,					//�׸��� ����
	        		          height: 440,					//�׸��� ����
	        				  title: "�����ϸ��"
	        				  });
	        			  uf_loadProgState1();				
	        			  },
	        		  position:"first",
	        		  title:"�׽��� ���"
	        		 }
	       	 );	
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