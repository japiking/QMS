<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ include file="/jsp/inc/inc_common.jsp" %>
<%@ include file="/jsp/inc/inc_header.jsp" %>>
<%
	String testId		=	request.getParameter("TEST_ID");
	String projectId	=	userSession.getProjectID();
	String caseId		=	request.getParameter("CS_ID");
	String scenarioId	=	request.getParameter("SC_ID");

%>
<script src="/QMS/js/qcl/qcl_test_excute_step_view.js"></script>
<h3>테스트  실행관리</h3>
<form name="frm" method="post"> 
	<input type="hidden" name="st_id" id="st_id"/>
	<input type="hidden" name="st_nm" id="st_nm"/>
	
	<div id="dialog2" title="Dialog Title" style="display:none">
		<table>
			<tr>
				<th>
					STEP ID
				</th>
				<td>
					<input readonly="readonly" id="stID" name="stID" style="width:180px"/>
				</td>						
				<th>
					STEP 명
				</th>
				<td>
					<input readonly="readonly" id="stNM" name="stNM" style="width:160px"/>
				</td>
				<th>
					TEST 총 건수
				</th>
				<td>
					<input readonly="readonly" id="tsNUM" name="tsNUM" style="width:30px"/>
				</td>						
			</tr>
		</table>
		
		<table id="jqGrid1"></table>
		<div id="jqGridPager1"></div>			
		<script type="text/javascript"> 			
		$("#jqGrid1").jqGrid({
		        	 sortable: true,
		             caption: "스탭 목록",
		             datatype: "local",
		             colNames:['ACTION_SEQ','TEST_ID','SCENARIO_ID','CASE_ID','스탭 ID','테스터 ID','실행시작일','실행종료일','상태','상태 레벨','상태변경'],
		             colModel: [
						{ label: 'ACTION_SEQ'  	,  	index: 'ACTION_SEQ'		,	name: 'ACTION_SEQ'	,		key:true	,	hidden:true,	editable: true},
						{ label: 'TEST_ID'  	,  	index: 'TEST_ID'		,	name: 'TEST_ID'		,		key:true	,	hidden:true,	editable: true},
						{ label: 'SCENARIO_ID'	,	index: 'SCENARIO_ID'	,	name: 'SCENARIO_ID'	,		key:true	,	hidden:true,	editable: true},
						{ label: 'CASE_ID'		,	index: 'CASE_ID'		,	name: 'CASE_ID'		,		key:true	,	hidden:true,	editable: true},
						{ label: '스탭 ID'		,	index: 'STEP_ID'		,	name: 'STEP_ID'		,	 	key:true	,	hidden:true,	editable: true},
		                { label: '테스터 ID'		,	index: 'TESTER_ID'		,	name: 'TESTER_ID'	,	 	width: 20	,	editable: true},
						{ label: 'TEST 시작일'		,	index: 'START_DATE'		,	name: 'START_DATE'	, 		width: 20	, 	editable: true,  editoptions:{size:12, dataInit:datepicker_view}},
						{ label: 'TEST 종료일'		,	index: 'END_DATE'		,	name: 'END_DATE'	, 		width: 20	, 	editable: true,  editoptions:{size:12, dataInit:datepicker_view}},
						{ label: '상태'			,	index: 'STEP_STATUS'	,	name: 'STEP_STATUS'	,	 	width: 20	, 	editable: true},
						{ label: '상태 레벨'		,	index: 'STATUS_LEVEL'	,	name: 'STATUS_LEVEL',	 	width: 20	, 	editable: true,	hidden:true},
						{ label: '상태 변경'		,	index: 'STATUS'			,	name: 'STATUS'		,		width: 20	,	editable: true, edittype:'select',formatter: seldata, editoptions:{dataEvents:[{type:'change',fn:changdata}]}}
		             ],
		             loadonce			: true, 
		             recordpos			: 'center',
					 viewrecords		: true,				
					 width				: 915,						//그리드 넓이
			         height				: 300,						//그리드 높이
		             rowNum				: 20,						//기본 한페이지에 보여주는 row수
		             rowList			: [10,20,50,100],     		//한페이지에 보여주는 row수
		             userDataOnFooter	: true, 			//
		             rownumbers			: true, 
		             pager				: "#jqGridPager1",
		     
		    	  });	
		

		$(".ui-jqgrid-titlebar").hide();	//titlebar 안보이게 처리
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
	             caption: "스탭 목록",
	             datatype: "local",
	             colNames:['TEST_ID','SCENARIO_ID','CASE_ID','스탭 ID','스탭 명','TEST 시작일','TEST 종료일'/* ,'삭제여부' */],
	             colModel: [
	                { label: 'TEST_ID'  	,  	index: 'TEST_ID'	,   name: 'TEST_ID'		,	key:true	,	hidden:true		,	editable: true},
	                { label: 'SCENARIO_ID'	,	index: 'SCENARIO_ID',	name: 'SCENARIO_ID'	,	key:true	,	hidden:true		,	editable: true},
	                { label: 'CASE_ID'		,	index: 'CASE_ID'	,  	name: 'CASE_ID'		,	key:true	,	hidden:true		,	editable: true},
	                { label: '스탭 ID'		,	index: 'STEP_ID'	,	name: 'STEP_ID'		,	width: 85	, 	editable: true	,	searchoptions:{sopt:["eq","bw","le"]}},
					{ label: '스탭 명'			,	index: 'STEP_NM'	,	name: 'STEP_NM'		,	width: 150	,	editable: true	,	searchoptions:{sopt:["eq","bw","le"]}},
					{ label: 'TEST 시작일'		,	index: 'START_DATE'	,	name: 'START_DATE'	, 	width: 70 	,	editable: true	,	editoptions:{size:12, dataInit:datepicker_view},searchoptions:{sopt:["eq","bw","le"]}},
					{ label: 'TEST 종료일'		,	index: 'END_DATE'	,	name: 'END_DATE'	, 	width: 70 	,	editable: true	,	editoptions:{size:12, dataInit:datepicker_view},searchoptions:{sopt:["eq","bw","le"]}},
					/* { label: '삭제여부'		,	index: 'DEL_FLAG', 			name: 'DEL_FLAG'	,	 	width: 30, 	editable: true}, */
	             ],
	             loadonce			:true, 
	             recordpos			:'right',
				 viewrecords		: true,				
				 width				: 1200,				//그리드 넓이
	             height				: 400,					//그리드 높이
	             rowNum				: 20,						//기본 한페이지에 보여주는 row수
	             rowList			:[10,20,50,100],     	//한페이지에 보여주는 row수
	             userDataOnFooter	: true, 		//
	             rownumbers			:true, 
	             pager				: "#jqGridPager"
	             
	    	  });
	    	 
	    	 $("#jqGrid").navGrid("#jqGridPager",
	    		 {search:false,refresh: false, add:false, edit: false,del:false,view:false,edittext:"편집",position: "left",	cloneToTop: false },
	        	 {
	             	/* Edit options */
	             	addCaption: "Add Record",	editCaption: "결함수정",	bSubmit: "수정",	bCancel: "취소",	bClose: "닫기",	saveData: "수정하시겠습니까?",
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
	    	 
	    	 $("#jqGrid").navGrid("#jqGridPager").jqGrid(
	        		 'navButtonAdd',"#jqGridPager",{
	        		  caption:"스텝실행목록",
	        		  buttonicon:"ui-icon-arrowthickstop-1-s",
	        		  onClickButton: function(){
	        			  $("#dialog2").dialog({
	        				  autoOpen: true, 
	        				  width:  940,					//그리드 넓이
	        		          height: 440,					//그리드 높이
	        				  title: "스텝실행목록"
	        				  });
	        			  uf_loadProgState1();
	        			  },
	        		  position:"first",
	        		  title:"테스터 목록",
	        		 });	
	
	    	 var gridOption = {searchOperators:true
	    			 ,stringResult: true
	    			 ,searchOnEnter: true
	    			 ,odata: [{ oper:'eq', text:'equal'},{ oper:'ne', text:'not equal'},{ oper:'lt', text:'less'},{ oper:'le', text:'less or equal'},{ oper:'gt', text:'greater'},{ oper:'ge', text:'greater or equal'},{ oper:'bw', text:'begins with'},{ oper:'bn', text:'does not begin with'},{ oper:'in', text:'is in'},{ oper:'ni', text:'is not in'},{ oper:'ew', text:'ends with'},{ oper:'en', text:'does not end with'},{ oper:'cn', text:'contains'},{ oper:'nc', text:'does not contain'}] };
	    	 jQuery("#jqGrid").jqGrid('filterToolbar',gridOption);
	    
	    	 
	       	uf_loadProgState('<%=testId%>','<%=projectId%>','<%=scenarioId%>','<%=caseId%>'); //리스트 데이터 호출
	       	
	       	
	       	
	     });
	
	</script>
</form>
<%@ include file="/jsp/inc/inc_bottom.jsp" %>