<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
    
<%@ include file="/jsp/inc/inc_common.jsp" %>
<%@ include file="/jsp/inc/inc_header.jsp" %>
<%
	String testId						=	request.getParameter("TEST_ID");
	String projectId					=	request.getParameter("PROJECT_ID");
	Map<String,String> param2			=new HashMap<String,String>();
	param2.put("PROJECT_ID",projectId);
	param2.put("TEST_ID",testId);	
	List<Map<String,String>> listData	=null;
	listData=qmsDB.selectList("QMS_QUALITYCONTROL.SCENARIO_R002",param2);
%>
<%@ include file="/jsp/inc/inc_topMenu.jsp" %>
<%@ include file="/jsp/inc/inc_leftMenu.jsp" %>
<script src="/QMS/js/qcl/qcl_test_excute_scenario_view.js"></script>

<form name="frm" method="post"> 
<input type="hidden" name="TEST_ID" id="TEST_ID" value="<%=testId%>"/>	
<input type="hidden" name="SC_ID" id="SC_ID"/>
<input type="hidden" name="CS_ID" id="CS_ID"/>
<input type="hidden" name="SC_NM" id="SC_NM"/>
<input type="hidden" name="SC_START" id="SC_START"/>
<input type="hidden" name="SC_END" id="SC_END"/>

	<h3>�׽�Ʈ �������</h3>
	
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
	   
	     $(document).ready(function () {	
	    	 $("#jqGrid").jqGrid({
	        	 sortable: true,
	             caption: "�ó����� ���",
	             datatype: "local",
	             colNames:['TEST_ID','SCENARIO_ID','�ó����� ��','TEST ������','TEST ������'],
	             colModel: [
	                { label: 'TEST_ID'  		,   index: 'TEST_ID'		,	name: 'TEST_ID'		,	key:true	,	hidden:true	,	editable: true},
	                { label: 'SCENARIO_ID'		,	index: 'SCENARIO_ID'	,   name: 'SCENARIO_ID'	,	width: 100	,	key:true	,	hidden:false,	editable: true,	searchoptions:{sopt:["eq","bw","le"]}},     
					{ label: '�ó����� ��'			,	index: 'SCENARIO_NM'	,	name: 'SCENARIO_NM'	,	width: 140	, 	editable: true,	searchoptions:{sopt:["eq","bw","le"]}},
					{ label: 'TEST ������'			,	index: 'START_DATE'		, 	name: 'START_DATE'	, 	width: 85 	, 	editable: true,	searchoptions:{sopt:["eq","bw","le"]}},
					{ label: 'TEST ������'			,	index: 'END_DATE'		, 	name: 'END_DATE'	, 	width: 85 	, 	editable: true,	searchoptions:{sopt:["eq","bw","le"]}},
	             ],
	             loadonce:true,
	             rownumbers:true, 
	             recordpos:'left',
				 viewrecords: true,				
	             width:  660,					//�׸��� ����
	             height: 500,					//�׸��� ����
	             rowNum: 20,					//�⺻ ���������� �����ִ� row��
	             rowList:[10,20,50,100],     	//���������� �����ִ� row��
	             userDataOnFooter: true, 		
	             pager: "#jqGridPager",
	                         
	             ondblClickRow :function(rowid){uf_loadProgState1(rowid);}
	            	
	    	  });
	    	 var gridOption = {searchOperators:true
	    			 ,stringResult: true
	    			 ,searchOnEnter: true
	    			 ,odata: [{ oper:'eq', text:'equal'},{ oper:'ne', text:'not equal'},{ oper:'lt', text:'less'},{ oper:'le', text:'less or equal'},{ oper:'gt', text:'greater'},{ oper:'ge', text:'greater or equal'},{ oper:'bw', text:'begins with'},{ oper:'bn', text:'does not begin with'},{ oper:'in', text:'is in'},{ oper:'ni', text:'is not in'},{ oper:'ew', text:'ends with'},{ oper:'en', text:'does not end with'},{ oper:'cn', text:'contains'},{ oper:'nc', text:'does not contain'}] };
	    	 jQuery("#jqGrid").jqGrid('filterToolbar',gridOption);
	    
	    	 
	    	
	       	uf_loadProgState('<%=testId%>','<%=projectId%>'); //����Ʈ ������ ȣ��
	
	    	 $("#jqGrid1").jqGrid({
	        	 sortable: true,
	             caption: "���̽� ���",
	             datatype: "local",
	             colNames:['TEST_ID','CASE_ID','SCENARIO_ID','���̽��� ��','TEST ������','TEST ������'],
	             colModel:[
	                { label: 'TEST_ID'  	,   index: 'TEST_ID'	,	name: 'TEST_ID'		,	key:true	,	width: 75,	hidden:true,	editable: true},
	                { label: 'CASE_ID'  	,   index: 'CASE_ID'	,   name: 'CASE_ID'		,	key:true	,	width: 110,	hidden:false,	editable: true,searchoptions:{sopt:["eq","bw","le"]}},
	                { label: 'SCENARIO_ID'	, 	index: 'SCENARIO_ID',   name: 'SCENARIO_ID'	,	key:true	,	width: 75,	hidden:true,	editable: true},
					{ label: '���̽� ��'		,	index: 'CASE_NM'	,	name: 'CASE_NM'		,	width: 130	, 	editable: true,searchoptions:{sopt:["eq","bw","le"]}},
					{ label: 'TEST ������'		,	index: 'START_DATE'	, 	name: 'START_DATE'	, 	width: 80 	, 	editable: true,searchoptions:{sopt:["eq","bw","le"]}},
					{ label: 'TEST ������'		,	index: 'END_DATE'	,	name: 'END_DATE'	, 	width: 80 	, 	editable: true,searchoptions:{sopt:["eq","bw","le"]}}
	             ],
	           
	             loadonce:true, 
	             recordpos:'right',
				 viewrecords: true,				
	             width:  660,				//�׸��� ����
	             height: 500,					//�׸��� ����
	             rowNum: 20,						//�⺻ ���������� �����ִ� row��
	             rowList:[10,20,50,100],     	//���������� �����ִ� row��
	             userDataOnFooter: true, 		//
	             rownumbers:true,
	             pager: "#jqGridPager1",
	             
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
	
	            		frm.target			= "_popup";
	            	    frm.action			= "/QMS/jsp/view/qcl/qcl_test_excute_step_view.jsp";
	            	    frm.submit();
	             }
	    	  });
	    	 var gridOption = {searchOperators:true
	    			 			,stringResult: true
	    			 			,searchOnEnter: true
	    			 			,odata: [{ oper:'eq', text:'equal'},{ oper:'ne', text:'not equal'},{ oper:'lt', text:'less'},{ oper:'le', text:'less or equal'},{ oper:'gt', text:'greater'},{ oper:'ge', text:'greater or equal'},{ oper:'bw', text:'begins with'},{ oper:'bn', text:'does not begin with'},{ oper:'in', text:'is in'},{ oper:'ni', text:'is not in'},{ oper:'ew', text:'ends with'},{ oper:'en', text:'does not end with'},{ oper:'cn', text:'contains'},{ oper:'nc', text:'does not contain'}] };
	    	 jQuery("#jqGrid1").jqGrid('filterToolbar',gridOption);
	    
	     });
	</script>
</form>
<%@ include file="/jsp/inc/inc_bottom.jsp" %>