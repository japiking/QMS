<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
    
<%@ include file="/jsp/inc/inc_common.jsp" %>
<%@ include file="/jsp/inc/inc_header.jsp" %>

<%
	String strUserId 	=	userSession.getUserID();
	String userLevel	=	userSession.getAuthorityGrade();
	String projectId	=	userSession.getProjectID();
	List<Map<String,String>> listData	= null;
	Map<String,String> param		= new HashMap<String,String>();
	Map<String,String> MapResult	= null;
	param.put("PROJECT_ID", projectId);	
	try{
		listData = qmsDB.selectList("QMS_QUALITYCONTROL.TEST_MANAGEMENT_R003", param);
	}catch(Exception e){
		e.printStackTrace(System.out);
		if (qmsDB != null) try { qmsDB.close(); } catch (Exception e1) {};
	}finally{
		if (qmsDB != null) try { qmsDB.close(); } catch (Exception e1) {};
	}
	
%>

 <script src="/QMS/js/qcl/qcl_defect_mng_view.js"></script>

<%@ include file="/jsp/inc/inc_topMenu.jsp" %>
<%@ include file="/jsp/inc/inc_leftMenu.jsp" %>
<form name="frm" method="post">
<input type="hidden" name="count" />
<h3>���԰���</h3>
<div>
	�׽�Ʈ�� : <select name="TEST_lIST">
		<%
			if(null != listData && listData.size() > 0){
		%>
		<option value="">��ü</option>`
		<%
				for(int i=0; i <listData.size(); i++){
					MapResult = listData.get(i);
		%>
		<option value="<%=MapResult.get("TEST_ID")%>"><%=MapResult.get("TEST_NM")%></option>
		<%		
				}
			}else{
		%>
				<option>�׽�Ʈ ����� �����ϴ�.</option>
		<%			
			}
		%>
	</select>
</div>
 <table id="jqGrid"></table>
 <div id="jqGridPager"></div>
 <script type="text/javascript"> 
 	var sttestId=$("select[name=TEST_ID] option:selected").val()
 	var stsceId=$("select[name=SCENARIO_ID] option:selected").val()
 
     $(document).ready(function () {
     	 $("input[type=button]").button();
     	 
         $("#jqGrid").jqGrid({
        	 sortable: true,
             caption: "���Ը��",
             datatype: "local",
             colNames:['SEQ','DEFECT_ID','�׽�ƮID','�ó�����ID','���̽�ID','����ID','����','������ID','�׽���ID','�������'/* ,'Ȯ������' */,'ó������','�߿䵵','��೻��','�󼼼���'],
             colModel:[
				{ label: 'SEQ'		,	index: 'DEFECT_SEQ', 			name: 'DEFECT_SEQ', 		width: 75 ,	hidden	: true		,	editable: true },
				{ label: 'DEFECT_ID',	index: 'DEFECT_ID', 			name: 'DEFECT_ID', 			width: 75 ,	hidden	: true		,	editable: true },
				{ label: '�׽�ƮID'	,	index: 'TEST_ID', 				name: 'TEST_ID', 			width: 75 ,	editable: true		,	edittype:'select',  formatter:'select',	editoptions:{value:getCode('1')					, dataEvents:[{type:'click',fn:testChangdata}], dataInit: function(elem) {$(elem).width(200);}},editrules:{required:true},searchoptions:{sopt:["eq","bw","le"]}},
				{ label: '�ó�����ID'	,	index: 'SCENARIO_ID', 			name: 'SCENARIO_ID', 		width: 75 ,	editable: true		,	edittype:'select',	formatter:'select',	editoptions:{value:getCode('2',sttestId)		, dataEvents:[{type:'click',fn:scenarioChangdata}], 	dataInit: function(elem) {$(elem).width(200);}},editrules:{required:true},searchoptions:{sopt:["eq","bw","le"]}},
				{ label: '���̽�ID'	,	index: 'CASE_ID', 				name: 'CASE_ID',			width: 75 ,	editable: true		,	edittype:'select',	formatter:'select',	editoptions:{value:getCode('3',sttestId,stsceId), dataEvents:[{type:'click',fn:caseChangdata}],	dataInit: function(elem) {$(elem).width(200);}},editrules:{required:true},searchoptions:{sopt:["eq","bw","le"]}},
				{ label: '����ID'		,	index: 'STEP_ID', 				name: 'STEP_ID', 			width: 75 , editable: true		,	edittype:'select',	formatter:'select',	editoptions:{value:getCode('4')					, dataInit: function(elem) {$(elem).width(200);}},editrules:{required:true},searchoptions:{sopt:["eq","bw","le"]}},
				{ label: '����'		,	index: 'DEFECT_STATUS', 		name: 'DEFECT_STATUS', 		width: 50 , editable: true		,	edittype:'select',	editoptions:{value:getCode('5'),	editrules:{required:true},dataInit: function(elem) {$(elem).width(200);}},searchoptions:{sopt:["eq","bw","le"]}},
				{ label: '������ID'	,	index: 'DEVELOPER_ID', 			name: 'DEVELOPER_ID', 		width: 50 , editable: true		,	edittype:'select',	editoptions:{value:getCode('6'),	dataInit: function(elem) {$(elem).width(200);}},searchoptions:{sopt:["eq","bw","le"]}},
				{ label: '�׽���ID'	,	index: 'TESTER_ID', 			name: 'TESTER_ID', 			width: 50 , editable: true		,	editoptions:{dataInit: function(elem) {$(elem).width(190);}},searchoptions:{sopt:["eq","bw","le"]}},
				{ label: '���������'	,	index: 'DEFECT_START_DATE', 	name: 'DEFECT_START_DATE', 	width: 50 , editable: true		, 	editrules:{edithidden:true},	editoptions:{size:12/* , dataInit:datepicker_view, dataInit: function(elem) {$(elem).width(190);} */}},
				{ label: '���ó����'	,	index: 'DEFECT_PROCESS_DATE', 	name: 'DEFECT_PROCESS_DATE',width: 50 , editable: true		, 	editrules:{edithidden:true},	editoptions:{size:12/* , dataInit:datepicker_view, dataInit: function(elem) {$(elem).width(190);} */}},
				{ label: '�߿䵵'		,	index: 'IMPORTANCE', 			name: 'IMPORTANCE', 		width: 30 , editable: true		, 	edittype:'select',	editoptions:{value:importance_custom(),dataInit: function(elem) {$(elem).width(200);}},searchoptions:{sopt:["eq","bw","le"]}},
				{ label: '��೻��'	,	index: 'DEFECT_TITLE', 			name: 'DEFECT_TITLE', 		width: 200, editable: true		,	editoptions:{size:150},searchoptions:{sopt:["eq","bw","le"]}},
				{ label: '�󼼼���'	,	index: 'DEFECT_CNTS', 			name: 'DEFECT_CNTS', 		width: 100, editable: true		,	edittype:'textarea',	hidden:true,	editrules:{ edithidden:true},	editoptions:{custom_element : defect_cnts_custom}}
             ],
             	 //cellEdit:true,				//��������
				 loadonce:true, 				
				 viewrecords: true,				//ȭ�� �ϴܿ� �� ��߿��� ���°���� �����ְ� �ִ����� ���� ���ڿ��� ǥ���Ұ����������� ����
	             autowidth: true,				//�׸��� ����
	             height: 500,					//�׸��� ����
	             rowNum: 20,					//�⺻ ���������� �����ִ� row��
	             rowList:[10,20,50,100],     	//���������� �����ִ� row��
	             userDataOnFooter: true, 		
	             pager: "#jqGridPager",
	             rownumbers:true,
	             ondblClickRow:function (rowid, iRow,iCol) {
	             },
	             sortable: true,
	             sortname:'DEFECT_START_DATE',
	             sortorder: 'desc',
	             editurl : 'clientArray',
	             addurl  : 'clientArray'
         });
		
         var gridOption = {searchOperators:true
    			 			,stringResult: true
    			 			,searchOnEnter: true
    			 			,odata: [{ oper:'eq', text:'equal'},
    			 			         { oper:'ne', text:'not equal'},
    			 			         { oper:'lt', text:'less'},
    			 			         { oper:'le', text:'less or equal'},
    			 			         { oper:'gt', text:'greater'},
    			 			         { oper:'ge', text:'greater or equal'},
    			 			         { oper:'bw', text:'begins with'},
    			 			         { oper:'bn', text:'does not begin with'},
    			 			         { oper:'in', text:'is in'},
    			 			         { oper:'ni', text:'is not in'},
    			 			         { oper:'ew', text:'ends with'},
    			 			         { oper:'en', text:'does not end with'},
    			 			         { oper:'cn', text:'contains'},
    			 			         { oper:'nc', text:'does not contain'}
    			 			         ] };
    	 jQuery("#jqGrid").jqGrid('filterToolbar',gridOption);
    	 
         $('#jqGrid').navGrid('#jqGridPager',
            {
        	 <%
        	 	if("00".equals(userLevel) ||"02".equals(userLevel)){
        	 %>
                add: true,		del: true,
             <%   
        	 	}else{
             %>
	             add: false,	del: false,
             <%
        	 	}
             %>
	             search: true,	refresh: true,	edit: true,view:true,	viewtext:"����ȸ",	addtext:"�߰�",	edittext:"����",	deltext:"����",	position: "left",	cloneToTop: false            },
            {
            	/* Edit options */
            	addCaption: "Add Record",	editCaption: "���Լ���",	bSubmit: "����",	bCancel: "���",	bClose: "�ݱ�",	saveData: "�����Ͻðڽ��ϱ�?",
        		bYes : "Yes",	bNo : "No",	bExit : "Cancel",	
        		beforeShowForm : edit_field,
        		ShowForm: function(form) {
        		    form.closest('div.ui-jqdialog').center();
        		},
        		onclickSubmit : edit_submit,
        		closeAfterEdit: true,
        		recreateForm: true,
        		viewPagerButtons: true,
        		closeOnEscape:true
            },
            {
            	/* Add options */
            	addCaption: "Add Record",
        		editCaption: "���Ե��",	bSubmit: "���",	bCancel: "���",	bClose: "�ݱ�",	saveData: "����Ͻðڽ��ϱ�?",
        		bYes : "Yes",	bNo : "No",	bExit : "Cancel",
        		zIndex:1000,
        		beforeShowForm : add_field,
        		afterShowForm: function(form) {
        		    form.closest('div.ui-jqdialog').center();
        		    add_custom_value('<%=strUserId%>');
        		},
        		onclickSubmit : add_Submit,
        		closeAfterEdit: true,
        		recreateForm: true,
        		viewPagerButtons: true,
        		closeOnEscape:true
        		/* jqModal:false */
            },
            {
            	/* Delete options */
            	addCaption: "Add Record",	editCaption: "���Ի���",	bSubmit: "����",	bCancel: "���",	bClose: "�ݱ�",	saveData: "�����Ͻðڽ��ϱ�?",
        		bYes : "Yes",	bNo : "No",	bExit : "Cancel",
        		onclickSubmit : del_Submit,
        		closeOnEpscape:true,
        		reloadAfterSubmit: false
            },
            {
            	/* Search options */
            },
            {
            	/* view parameters */
            	afterShowForm: function(form) {
        		    form.closest('div.ui-jqdialog').center();
        		}
            }
            
         );
         
		//�׽�Ʈ ������Ʈ�� ���ð˻�                 
        $("select[name=TEST_lIST]").change(function(){
        	var test_id = 	$("select option:selected").val();
        	uf_loadProgState(test_id); //����Ʈ ������ ȣ��
        }).change();
         
		//�׸��� ������ ����
        $(window).bind('resize', function() {
    	    $("#jqgrid").setGridWidth($(window).width());
    	}).trigger('resize');
        
       
     });


</script>


</form>
<%@ include file="/jsp/inc/inc_bottom.jsp" %>