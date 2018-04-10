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
<h3>테스트 관리</h3>
<!-- 실행자 목록 스텝 정보 -->
	<div id="dialog2" title="실행 등록 목록" style="display:none">
	
		<table>
			<tr>
				<th>스텝 ID</th>
					<td>
						<input readonly="readonly" id="stID" name="stID" style="width:200px"/>
					</td>						
				<th>스텝 명</th>
					<td>
						<input readonly="readonly" id="stNM" name="stNM" style="width:100px"/>
					</td>
				<th>테스트 총 건수</th>
					<td>
						<input readonly="readonly" id="tsNUM" name="tsNUM" style="width:50px"/>
					</td>						
			</tr>
		</table>
		<table id="jqGrid1"></table>
		<div id="jqGridPager1"></div>			
		<script type="text/javascript"> 
		//실행자 목록 그리드
		$("#jqGrid1").jqGrid({
		        	 sortable: true,
		             caption: "스텝 목록",
		             datatype: "local",
		             colNames:['테스터 ID','실행시작일','실행종료일','상태','삭제 여부'],
		             
		             colModel: [
		                { label: '테스터 ID'		,	index: 'TESTER_ID'		,		name: 'TESTER_ID'	,	 	width: 20, 	editable: true},
						{ label: 'TEST 시작일'		,	index: 'START_DATE'		,		name: 'START_DATE'	, 		width: 20 , editable: true,  editoptions:{size:12, dataInit:datepicker_view}},
						{ label: 'TEST 종료일	'	,	index: 'END_DATE'		,		name: 'END_DATE'	, 		width: 20 , editable: true,  editoptions:{size:12, dataInit:datepicker_view}},
						{ label: '상태'			,	index: 'STEP_STATUS'	,		name: 'STEP_STATUS'	,		width: 20 , editable: true},
						{ label: '삭제 여부'		,	index: 'DEL_FLAG'		,		name: 'DEL_FLAG'	,		width: 20 , editable: true}
						
		
		             ],
		           
		             loadonce			: true, 
		             recordpos			: 'right',
					 viewrecords		: true,				
			         width				: 915,					//그리드 넓이
			         height				: 300,					//그리드 높이
		             rowNum				: 20,						//기본 한페이지에 보여주는 row수
		             rowList			:[10,20,50,100],     	//한페이지에 보여주는 row수
		             userDataOnFooter	: true, 		//
		             rownumbers			: true, 
		             pager				: "#jqGridPager1",
		             
		            	
		    	  });	
		$(".ui-jqgrid-titlebar").hide();		//그리드 숨김
		</script>			
	</div>
<input type="hidden" name="st_id" id="st_id"/>
<input type="hidden" name="st_nm" id="st_nm"/>
<table>		
			<table id="jqGrid"></table>
			<div id="jqGridPager"></div>
</table>
<script type="text/javascript"> 
//스텝 그리드
     $(document).ready(function () {	
    	 $("#jqGrid").jqGrid({
        	 sortable: true,
             caption: "스텝 목록",
             datatype: "local",
             colNames:['TEST_ID','SCENARIO_ID','CASE_ID','스텝 ID','스텝 명','TEST 시작일','TEST 종료일','삭제여부','상태'],
             colModel: [
                { label: 'TEST_ID'  	,  	index: 'TEST_ID'	,       name: 'TEST_ID',		key:true, hidden:true,	editable: true},
                { label: 'SCENARIO_ID'	,	index: 'SCENARIO_ID',       name: 'SCENARIO_ID',	key:true, hidden:true,	editable: true},
                { label: 'CASE_ID'		,	index: 'CASE_ID'	,      	name: 'CASE_ID',		key:true, hidden:true,	editable: true},
                { label: '스텝 ID'		,	index: 'STEP_ID'	,		name: 'STEP_ID',	 	width: 85, 	editable: true,	searchoptions:{sopt:["eq","bw","le"]}},
				{ label: '스텝 명'			,	index: 'STEP_NM'	,		name: 'STEP_NM',		width: 140, editable: true,	searchoptions:{sopt:["eq","bw","le"]}},
				{ label: 'TEST 시작일'		,	index: 'START_DATE'	, 		name: 'START_DATE', 	width: 50 , editable: true,  editoptions:{size:12, dataInit:datepicker_view},searchoptions:{sopt:["eq","bw","le"]}},
				{ label: 'TEST 종료일'		,	index: 'END_DATE'	,		name: 'END_DATE', 		width: 50 , editable: true,  editoptions:{size:12, dataInit:datepicker_view},searchoptions:{sopt:["eq","bw","le"]}},
				{ label: '삭제여부'		,	index: 'DEL_FLAG'	,		name: 'DEL_FLAG',	 	width: 20, 	editable: true,  editable: true,edittype:'select',formatter:'select',editoptions:{value:'Y:Y;N:N'}},
				{ label: '상태'			,	index: 'STEP_STATUS',		name: 'STEP_STATUS',	width: 20, 	editable: true,	searchoptions:{sopt:["eq","bw","le"]}}
             ],
             loadonce			: true, 
             recordpos			:'right',
			 viewrecords		: true,				
             width				: 1200,				//그리드 넓이
             height				: 400,					//그리드 높이
             rowNum				: 20,						//기본 한페이지에 보여주는 row수
             rowList			: [10,20,50,100],     	//한페이지에 보여주는 row수
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
    		 {search:false,refresh: false,add:false ,edit: true,del:false,view:false,edittext:"편집",position: "left",	cloneToTop: false },
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
    	 //실행자 목록 메뉴
    	 $("#jqGrid").navGrid("#jqGridPager").jqGrid('navButtonAdd',"#jqGridPager",
    			 {
        		  caption:"실행자 목록",
        		  buttonicon:"ui-icon-arrowthickstop-1-s",
        		  onClickButton: function(){
        			  $("#dialog2").dialog({
        				  autoOpen: true, 
        		          width:  940,					//그리드 넓이
        		          height: 440,					//그리드 높이
        				  });
        			  
        			  uf_loadProgState1(); //데이터 리스트 가져오기
        			  
        		  },
        		  position:"first",
        		  title:"테스터 목록",
        		 });	
		//검색 option
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