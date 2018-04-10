<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
    
<%@ include file="/jsp/inc/inc_common.jsp" %>
<%@ include file="/jsp/inc/inc_header.jsp" %>
<%
	String testId				=	request.getParameter("TEST_ID1");
	String projectId			=	request.getParameter("PROJECT_ID");
	Map<String,String> param2	=	new HashMap<String,String>();
	param2.put("TEST_ID",testId);	
%>
<script type="text/javascript"> 
//���� ��� �˾�
function sc_regidit1(){
	var frm 			= document.frm;
	var test_id			=frm.TEST_ID.value;
	
	var wid	  			= 300;
	var hei   			= 200;
	var LeftPosition	= (screen.width)  ? (screen.width-wid) /2 : 0;
	var TopPosition		= (screen.height) ? (screen.height-hei)/2 : 0;
	var setting  		= 'scrollbars=no,toolbar=yes,resizable=no,width='+wid+',height='+hei+',left='+LeftPosition+',top='+TopPosition;
	window.open('', '_popup', setting);
	
	frm.target			= "_popup";
    frm.action			= "/QMS/jsp/view/qcl/qcl_test_regist_popup_view.jsp";
    frm.submit();
    window.close();
}
</script>
<%@ include file="/jsp/inc/inc_topMenu.jsp" %>
<%@ include file="/jsp/inc/inc_leftMenu.jsp" %>
<script src="/QMS/js/qcl/qcl_test_regist_view.js"></script>

<form name="frm" method="post"> 
<input type="hidden" name="TEST_ID" id="TEST_ID" value="<%=param2.get("TEST_ID")%>" />
<input type="hidden" name="SC_ID" id="SC_ID"/>
<input type="hidden" name="CS_ID" id="CS_ID"/>
<h3>�׽�Ʈ ����</h3>	

<div id="dialog2" title="Dialog Title" style="display:none">
	<table id="jqGrid2"></table>
<div id="jqGridPager2"></div>

<script type="text/javascript"> 
//������ ��� �׸��� ���	
	 $("#jqGrid2").jqGrid({
   	 	sortable: 	true,
        caption: 	"�׽��� ���",
        datatype: 	"local",
        colNames:	['�׽��� ID','����� ��'],
        colModel: 	[
			{ label: '�׽��� ID'	,	index: 'TESTER_ID', 		name: 'TESTER_ID',		width: 85, editable: true},
			{ label: '����ڸ�'	,	index: 'USERNAME', 			name: 'USERNAME',		width: 85, editable: true},
	        ],
      
        loadonce		: true, 
        multiselect		: true,
        recordpos		:'right',
		viewrecords		: true,				
        width			:  630,					//�׸��� ����
        height			: 420,					//�׸��� ����
        rowNum			: 20,						//�⺻ ���������� �����ִ� row��
        rowList			:[10,20,50,100],     	//���������� �����ִ� row��
        userDataOnFooter: true, 		//
        rownumbers		: true,
        pager			: "#jqGridPager2",
	 });
$(".ui-jqgrid-titlebar").hide();
</script>
</div>
<a href="#" class="btn" onclick="javascript:sc_regidit1();"><span>�������</span></a>
<table>	
	<tr>
		<td>
			<table id="jqGrid"></table>
			<div id="jqGridPager"></div>
		</td>
		<td>
			<table id="jqGrid1"></table>
			<div id="jqGridPager1"></div>
		</td>
			
	</tr>
</table>
<script type="text/javascript"> 
//�ó����� �׸���
     $(document).ready(function() {	
    	 $("#jqGrid").jqGrid({
        	 sortable: true,
             caption: "�ó����� ���",
             datatype: "local",
             colNames:['TEST_ID','SCENARIO_ID','�ó����� ��','TEST ������','TEST ������','��������'],
             colModel: [
                { label: 'TEST_ID'  	,   index: 'TEST_ID'	,		id: 'TEST_ID'		,	name: 'TEST_ID'		,	key:true, hidden:true,	editable: true},
                { label: 'SCENARIO_ID'	, 	index: 'SCENARIO_ID',		id: 'SCENARIO_ID'	,	width: 100			,	name: 'SCENARIO_ID'	,	key:true, hidden:false,	editable: true,	searchoptions:{sopt:["eq","bw","le"]}},
				{ label: '�ó����� ��'		,	index: 'SCENARIO_NM', 		name: 'SCENARIO_NM'	,	width: 140			, 	editable: true,			searchoptions:{sopt:["eq","bw","le"]}},
				{ label: 'TEST ������'		,	index: 'START_DATE'	, 		name: 'START_DATE'	, 	width: 85 			, 	editable: true,			editoptions:{size:12, dataInit:datepicker_view},	searchoptions:{sopt:["eq","bw","le"]}},
				{ label: 'TEST ������'		,	index: 'END_DATE'	, 		name: 'END_DATE'	, 	width: 85 			, 	editable: true,			editoptions:{size:12, dataInit:datepicker_view},	searchoptions:{sopt:["eq","bw","le"]}},
				{ label: '��������'		,	index: 'DEL_FLAG'	, 		name: 'DEL_FLAG'	,	width: 30			, 	editable: true,			edittype:'select',formatter:'select',	editoptions:{value:'Y:Y;N:N'}},
             ],
           
             loadonce			: true, 
             multiselect		: false,
             recordpos			:'right',
			 viewrecords		: true,				
             width				: 650,				//�׸��� ����
             height				: 500,					//�׸��� ����
             rowNum				: 20,						//�⺻ ���������� �����ִ� row��
             rowList			:[10,20,50,100],     	//���������� �����ִ� row��
             userDataOnFooter	: true, 		//
             rownumbers			: true,
             pager				: "#jqGridPager",
             
             /* onSelectRow : function(rowid){  	
            	 
             }, */
             onPaging : function(){
            	 var tsId=$("#TEST_ID").val();
            	 var psId=$("#PROJECT_ID").val();	
            	 uf_loadProgState(tsId,psId);	//�ó����� �׸��� ���
             },
             
             ondblClickRow :function(rowid){	
            	 uf_loadProgState1(rowid);		//���̽� �׸��� ���
             }
           
    	  });
    	 //�˻� option
    	 var gridOption = {searchOperators:true
    			 ,stringResult: true
    			 ,searchOnEnter: true
    			 ,odata: [{ oper:'eq', text:'equal'},{ oper:'ne', text:'not equal'},{ oper:'lt', text:'less'},{ oper:'le', text:'less or equal'},{ oper:'gt', text:'greater'},{ oper:'ge', text:'greater or equal'},{ oper:'bw', text:'begins with'},{ oper:'bn', text:'does not begin with'},{ oper:'in', text:'is in'},{ oper:'ni', text:'is not in'},{ oper:'ew', text:'ends with'},{ oper:'en', text:'does not end with'},{ oper:'cn', text:'contains'},{ oper:'nc', text:'does not contain'}] };
    	 jQuery("#jqGrid").jqGrid('filterToolbar',gridOption);
    	 
         $("#jqGrid").navGrid("#jqGridPager",
            {search:false,refresh: true,add:false ,edit: true,del:false,view:false,edittext:"����",position: "left",	cloneToTop: false },
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
         $("#jqGrid").navGrid("#jqGridPager").jqGrid(
        		 'navButtonAdd',"#jqGridPager",{
        		  caption:"������ ���",
        		  buttonicon:"ui-icon-arrowthickstop-1-s",
        		  onClickButton: function(){
        			  $("#dialog2").dialog({
        				  autoOpen: true, 
        				  width: 650,
        				  height: 530,
        				  title: "�ó����� �������� ���"
        				  });
        			  uf_loadProgState2(); 
        			  },
        		  position:"first"
        		 
        		 });
         
       	uf_loadProgState('<%=testId%>','<%=projectId%>'); //����Ʈ ������ ȣ��
//���̽� �׸���       
    	 $("#jqGrid1").jqGrid({
        	 sortable: true,
             caption: "���̽� ���",
             datatype: "local",
             colNames:['TEST_ID','CASE_ID','SCENARIO_ID','���̽��� ��','TEST ������','TEST ������','��������'],
             colModel: [
                { label: 'TEST_ID'  	,   index: 'TEST_ID'	,          	name: 'TEST_ID'		,	key: true	,	width: 75	, 	hidden:true,	editable: true},
                { label: 'CASE_ID'  	,   index: 'CASE_ID'	,           name: 'CASE_ID'		,	key: true	,	width: 130	, 	hidden:false,	editable: true,searchoptions:{sopt:["eq","bw","le"]}},
                { label: 'SCENARIO_ID'	, 	index: 'SCENARIO_ID',           name: 'SCENARIO_ID'	,	key: true	,	width: 75	, 	hidden:true,	editable: true},
				{ label: '���̽� ��'		,	index: 'CASE_NM'	, 			name: 'CASE_NM'		,	width: 120	, 	editable: true, searchoptions:{sopt:["eq","bw","le"]}},
				{ label: 'TEST ������'		,	index: 'START_DATE'	, 			name: 'START_DATE'	, 	width: 80 	, 	editable: true,	editoptions:{size:12, dataInit:datepicker_view},searchoptions:{sopt:["eq","bw","le"]}},
				{ label: 'TEST ������'		,	index: 'END_DATE'	, 			name: 'END_DATE'	, 	width: 80 	, 	editable: true,	editoptions:{size:12, dataInit:datepicker_view},searchoptions:{sopt:["eq","bw","le"]}},
				{ label: '��������'		,	index: 'DEL_FLAG'	, 			name: 'DEL_FLAG'	,	width: 30	,  	editable: true, edittype:'select',formatter:'select',editoptions:{value:'Y:Y;N:N'}},
             ],
           
             loadonce			:true, 
             multiselect		: false,
             recordpos			:'right',
			 viewrecords		: true,				
             width				: 650,				//�׸��� ����
             height				: 500,					//�׸��� ����
             rowNum				: 20,						//�⺻ ���������� �����ִ� row��
             rowList			:[10,20,50,100],     	//���������� �����ִ� row��
             userDataOnFooter	: true, 		//
             rownumbers			:true,
             pager				: "#jqGridPager1",
             
             ondblClickRow :function(rowid,iCol){
            	 	var frm				=document.frm;
            	 	var list 			= jQuery("#jqGrid1").getRowData(rowid);
            	 	frm.SC_ID.value		=list.SCENARIO_ID;
            	 	frm.CS_ID.value		=list.CASE_ID;
            		
            	 	var wid	  			= 1205;
            		var hei   			= 630;
            		var LeftPosition	= (screen.width)  ? (screen.width-wid) /2 : 0;
            		var TopPosition		= (screen.height) ? (screen.height-hei)/2 : 0;
            		var setting  		= 'scrollbars=no,toolbar=yes,resizable=no,width='+wid+',height='+hei+',left='+LeftPosition+',top='+TopPosition;
            		window.open('', '_popup', setting);

            		frm.target	= "_popup";
            	    frm.action			= "/QMS/jsp/view/qcl/qcl_test_case_popup_view.jsp";
            	    frm.submit();
             }
             
    	  });
    	 $("#jqGrid1").navGrid("#jqGridPager1",
    		 {search:false,refresh: false,add: false, edit: true,del:false,view:false,edittext:"����",position: "left",	cloneToTop: false },
        	 
        	 {
             	/* Edit options */
             	addCaption: "Add Record",	editCaption: "���Լ���",	bSubmit: "����",	bCancel: "���",	bClose: "�ݱ�",	saveData: "�����Ͻðڽ��ϱ�?",
         		bYes : "Yes",	bNo : "No",	bExit : "Cancel",	
         		
         		ShowForm: function(form) {
         		    form.closest('div.ui-jqdialog').center();
         		},
         		onclickSubmit 	: edit_submit1,
         		closeAfterEdit	: true,
         		recreateForm	: true,
         		viewPagerButtons: true,
         		closeOnEscape	:true
             	
             });
    	 //������ ��� �޴�
    	 $("#jqGrid1").navGrid("#jqGridPager1").jqGrid(
        		 'navButtonAdd',"#jqGridPager1",{
        		  caption:"������ ���",
        		  buttonicon:"ui-icon-arrowthickstop-1-s",
        		  onClickButton: function(){
        			  $("#dialog2").dialog({
        				  autoOpen: true, 
        				  width: 650,
        				  height: 530,
        				  title: "���̽� �������� ���"
        				  });
        			  uf_loadProgState3();
        			  },
        		  position:"first"
        		 });
    	 //�˻� option
    	 var gridOption = {searchOperators:true
    			 ,stringResult: true
    			 ,searchOnEnter: true
    			 ,odata: [{ oper:'eq', text:'equal'},{ oper:'ne', text:'not equal'},{ oper:'lt', text:'less'},{ oper:'le', text:'less or equal'},{ oper:'gt', text:'greater'},{ oper:'ge', text:'greater or equal'},{ oper:'bw', text:'begins with'},{ oper:'bn', text:'does not begin with'},{ oper:'in', text:'is in'},{ oper:'ni', text:'is not in'},{ oper:'ew', text:'ends with'},{ oper:'en', text:'does not end with'},{ oper:'cn', text:'contains'},{ oper:'nc', text:'does not contain'}] };
    	 jQuery("#jqGrid1").jqGrid('filterToolbar',gridOption);
     });
     
</script>
</form>
<%@ include file="/jsp/inc/inc_bottom.jsp" %>