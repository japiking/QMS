<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
    
<%@ include file="/jsp/inc/inc_common.jsp" %>
<%@ include file="/jsp/inc/inc_header.jsp" %>
<%
	String testId		=	StringUtil.null2void(request.getParameter("TEST_ID"));
%> 
<%@ include file="/jsp/inc/inc_topMenu.jsp" %>
<%@ include file="/jsp/inc/inc_leftMenu.jsp" %>
<form name="frm" method="post">
<input type="hidden" name="SC_ID" 	id="SC_ID"/>
<input type="hidden" name="CS_ID" 	id="CS_ID"/>
<input type="hidden" 	 name="TS_ID" id="TS_ID"/> 
<script src="/QMS/js/qcl/qcl_scenario_list_view.js"></script>
<h3>�׽�Ʈ ������</h3>
	<table>	
		<tr>
			<td colspan="2">
				<a href="#" class="btn" onclick ="javascript:exec();" id ="exec"><span>������</span></a>
			</td>
		</tr>
		<tr>
			<td>
				<table id="scGrid"></table>
				<div id="scGridPager"></div>
			</td>
			<td>
				<table id="caGrid"></table>
				<div id="caGridPager"></div>
			</td>
				
		</tr>
	</table>

<script type="text/javascript"> 
//�ó����� �׸���
   
     $(document).ready(function () {	
    	 
    	//�ó����� �׸���
    	 $("#scGrid").jqGrid({
        	 sortable: true,
             caption: "�ó����� ���",
             datatype: "local",
             colNames:['TEST_ID','SCENARIO_ID','�ó����� ��','TEST ������','TEST ������'],
             colModel: [
                { label: 'TEST_ID'  	,   index: 'TEST_ID'		,          	name: 'TEST_ID'		,	hidden:true,	editable: true},
                { label: 'SCENARIO_ID'	, 	index: 'SCENARIO_ID'	,       	name: 'SCENARIO_ID'	,	width: 100,		hidden:false,	editable: true,searchoptions:{sopt:["eq","bw","le"]}},
				{ label: '�ó����� ��'		,	index: 'SCENARIO_NM'	, 			name: 'SCENARIO_NM'	,	width: 140, 	editable: true,searchoptions:{sopt:["eq","bw","le"]}},
				{ label: 'TEST ������'		,	index: 'START_DATE'		, 			name: 'START_DATE'	, 	width: 80 , 	editable: true,searchoptions:{sopt:["eq","bw","le"]}},
				{ label: 'TEST ������'		,	index: 'END_DATE'		, 			name: 'END_DATE'	, 	width: 80 , 	editable: true,searchoptions:{sopt:["eq","bw","le"]}}
			
             ],
           
             loadonce			:true, 
             recordpos			:'right',
			 viewrecords		: true,				
			 width				: 660,					//�׸��� ����
             height				: 500,					//�׸��� ����
             rowNum				: 20,												//�⺻ ���������� �����ִ� row��
             rowList			:[10,20,50,100],     								//���������� �����ִ� row��
             userDataOnFooter	: true, 		
             multiselect		: true,
             multiboxonly		:true,
             rownumbers			:true,
             pager				: "#scGridPager",
             ondblClickRow  :function(rowid){uf_loadCase(rowid);},		//row ����Ŭ���� �̺�Ʈ
             beforeSelectRow: function (rowid, e) {						//checkbox��ü�������� �κм��ý� 			
            	    var $myGrid = $(this),
            	        i = $.jgrid.getCellIndex($(e.target).closest('td')[0]),
            	        
            	        cm = $myGrid.jqGrid('getGridParam', 'colModel');
            	    
            	    return (cm[i].name === 'cb');
            	}
            	
    	  });
    	 $("#scGrid").jqGrid('filterToolbar',{
    		 	searchOnEnter: true,
    		    ignoreCase: true,
    		    searchOperators: true,}); //�˻�
       	uf_loadProgState('<%=testId%>'); //����Ʈ ������ ȣ��

       	var gridOption = {searchOperators:true
   			 ,stringResult: true
   			 ,searchOnEnter: true
   			 ,odata: [{ oper:'eq', text:'equal'},{ oper:'ne', text:'not equal'},{ oper:'lt', text:'less'},{ oper:'le', text:'less or equal'},{ oper:'gt', text:'greater'},{ oper:'ge', text:'greater or equal'},{ oper:'bw', text:'begins with'},{ oper:'bn', text:'does not begin with'},{ oper:'in', text:'is in'},{ oper:'ni', text:'is not in'},{ oper:'ew', text:'ends with'},{ oper:'en', text:'does not end with'},{ oper:'cn', text:'contains'},{ oper:'nc', text:'does not contain'}] };
   	 jQuery("#scGrid").jqGrid('filterToolbar',gridOption);
   
       	
       	var test="<input type='checkbox' name='chk_info' value='HTML'>"; //test
       	
       	//���̽� �׸���
    	 $("#caGrid").jqGrid({
        	 sortable: true,
             caption: "���̽� ���",
             datatype: "local",
             colNames:['�糪���� rowID','�׽�Ʈ_ID','���̽�_ID','�ó�����_ID','���̽��� ��','TEST ������','TEST ������'],
             colModel: [
				{ label: '�糪���� rowID'  ,   index: 'SNROW_ID'		,	name: 'SNROW_ID'	,	key:true	,	width: 75, 	hidden:true,	editable: true},
                { label: '�׽�Ʈ_ID'  		,   index: 'TEST_ID'		,	name: 'TEST_ID'		,	key:true	,	width: 75, 	hidden:true,	editable: true},
                { label: '���̽�_ID'  		,   index: 'CASE_ID'		,   name: 'CASE_ID'		,	key:true	,	width: 120,	hidden:false,	editable: true,searchoptions:{sopt:["eq","bw","le"]}},
                { label: '�ó�����_ID'		, 	index: 'SCENARIO_ID'	,   name: 'SCENARIO_ID'	,	key:true	,	width: 75, 	hidden:true,	editable: true},
				{ label: '���̽� ��'		,	index: 'CASE_NM'		,	name: 'CASE_NM'		,	width: 140	, 	editable: true,searchoptions:{sopt:["eq","bw","le"]}},
				{ label: 'TEST ������'		,	index: 'START_DATE'		, 	name: 'START_DATE'	, 	width: 80 	, 	editable: true,searchoptions:{sopt:["eq","bw","le"]}},
				{ label: 'TEST ������'		,	index: 'END_DATE'		, 	name: 'END_DATE'	, 	width: 80 	, 	editable: true,searchoptions:{sopt:["eq","bw","le"]}}
			
             ],
           
             loadonce:true, 
             recordpos			:'right',
			 viewrecords		: true,				
			 width				:  660,				//�׸��� ����
             height				: 500,					//�׸��� ����
             rowNum				: 20,											//�⺻ ���������� �����ִ� row��
             rowList			:[10,20,50,100],     							//���������� �����ִ� row��
             userDataOnFooter	: true, 		
             multiselect		: true,
             rownumbers			:true,
             pager				: "#caGridPager",
             ondblClickRow :function(rowid,iCol){					//row ����Ŭ���� �̺�Ʈ
         	 	var frm				=document.frm;
         	 	var list 			= $("#caGrid").getRowData(rowid);
         	 	frm.SC_ID.value=list.SCENARIO_ID;
         	 	frm.CS_ID.value=list.CASE_ID;
         	 	frm.TS_ID.value=list.TEST_ID;
         	 	var wid	  			= 1205;
        		var hei   			= 630;
         		var LeftPosition	= (screen.width)  ? (screen.width-wid) /2 : 0;
         		var TopPosition		= (screen.height) ? (screen.height-hei)/2 : 0;
         		var setting  		= 'scrollbars=no,toolbar=yes,resizable=no,width='+wid+',height='+hei+',left='+LeftPosition+',top='+TopPosition;
         		window.open('', '_popup', setting);

         		frm.target			= "_popup";
         	    frm.action			= "/QMS/jsp/view/qcl/qcl_test_step_popup_view.jsp";
         	    frm.submit();
          },
          beforeSelectRow: function (rowid, e) {					//checkbox��ü�������� �κ������� Ǯ�� 
      	    	var $myGrid = $(this),
      	        i 			= $.jgrid.getCellIndex($(e.target).closest('td')[0]),
      	        
      	        cm 			= $myGrid.jqGrid('getGridParam', 'colModel');
      	  		
          		var RowData = $("#caGrid").jqGrid('getRowData', rowid);
      	  		var calength=  $("#caGrid").jqGrid('getGridParam', 'selarrrow');
      	  		
          		//if(calength != ){
      	  		//���̽� üũ�� �ϳ��� Ǯ���� �ó����� üũ�� Ǯ������
      	  		/* var  carowData =   $("#caGrid").jqGrid('getRowData', rowid);
				$("#scGrid").jqGrid('setSelection', carowData['SNROW_ID'],false);
          		//} */
      	  		
      	    return (cm[i].name === 'cb');
        	 
      		},
      		onSelectAll: function(aRowids, status){		//��ücheckbox üũ����
      			selectcheckAll(aRowids,status);
      			
      		},
      		onselectRow: function(rowid){
      			
      		}
             
    	  });
   
    	 $("#caGrid input[id^=jqg_caGrid_]").each(function(pi,po) {
    	    	var test = $(this).attr(aria-selected);
    	 		
    	 		});
    		var gridOption = {searchOperators:true
    	   			 ,stringResult: true
    	   			 ,searchOnEnter: true
    	   			 ,odata: [{ oper:'eq', text:'equal'},{ oper:'ne', text:'not equal'},{ oper:'lt', text:'less'},{ oper:'le', text:'less or equal'},{ oper:'gt', text:'greater'},{ oper:'ge', text:'greater or equal'},{ oper:'bw', text:'begins with'},{ oper:'bn', text:'does not begin with'},{ oper:'in', text:'is in'},{ oper:'ni', text:'is not in'},{ oper:'ew', text:'ends with'},{ oper:'en', text:'does not end with'},{ oper:'cn', text:'contains'},{ oper:'nc', text:'does not contain'}] };
    	   	 jQuery("#caGrid").jqGrid('filterToolbar',gridOption);
    	   
    	 
     });
</script>
</form>
<%@ include file="/jsp/inc/inc_bottom.jsp" %>