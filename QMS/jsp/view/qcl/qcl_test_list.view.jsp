<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ include file="/jsp/inc/inc_common.jsp" %>
<%@ include file="/jsp/inc/inc_header.jsp" %>
 
<script src="/QMS/js/qcl/qcl_test_list.view.js"></script>

<%@ include file="/jsp/inc/inc_topMenu.jsp" %>
<%@ include file="/jsp/inc/inc_leftMenu.jsp" %>
<form name="frm" method="post">

<input type="hidden" name="TEST_ID" id="TEST_ID" />

<h3>테스트 실행등록</h3>


<table id="jqGrid"></table>
<div id="jqGridPager"></div>

<script type="text/javascript"> 
//테스트 그리드   
     $(document).ready(function () {	
    	 $("#jqGrid").jqGrid({
        	 sortable: true,
             caption: "테스트목록",
             datatype: "local",
             colNames:['TEST_ID','테스트 명','시나리오 건수','케이스 건수','step 건수', 'TEST 시작일','TEST 종료일','TEST_BIGO'],
             colModel: [
                { label: 'TEST_ID'  	,	index: 'TEST_ID',           	name: 'TEST_ID',			width: 75, 	hidden:false,	editable: true,searchoptions:{sopt:["eq","bw","le"]}},
				{ label: '테스트 명'		,	index: 'TEST_NM', 			 	name: 'TEST_NM',	 		width: 75, 	editable: true,	searchoptions:{sopt:["eq","bw","le"]}},
				{ label: '시나리오 건수'		,	index: 'SCENARIO_CNT', 			name: 'SCENARIO_CNT',		width: 75, 	editable: true},
				{ label: '케이스 건수'		,	index: 'CASE_CNT', 				name: 'CASE_CNT', 			width: 75, 	editable: true},
				{ label: 'step 건수'		,	index: 'STEP_CNT', 				name: 'STEP_CNT',	 		width: 100, editable: true},
				{ label: 'TEST 시작일'	,	index: 'TEST_STTG_DATE', 		name: 'TEST_STTG_DATE', 	width: 80 , editable: true,	searchoptions:{sopt:["eq","bw","le"]}},
				{ label: 'TEST 종료일'	,	index: 'TEST_ENDG_DATE', 		name: 'TEST_ENDG_DATE', 	width: 80 , editable: true,	searchoptions:{sopt:["eq","bw","le"]}},
				{ label: 'TEST_BIGO'	,   index: 'TEST_BIGO',             name: 'TEST_BIGO',			width: 75, 	hidden:true,	editable: true},
             ],
           
             loadonce			:true, 
			 viewrecords		: true,				
             autowidth			: true,				//그리드 넓이
             height				: 500,					//그리드 높이
             rowNum				: 20,						//기본 한페이지에 보여주는 row수
             rowList			:[10,20,50,100],     	//한페이지에 보여주는 row수
             userDataOnFooter	: true, 		//
             rownumbers			:true, 
             pager				: "#jqGridPager",
                                     
             ondblClickRow : function(rowid, iCol){ 
             		var frm				=document.frm;
             		var list 			= jQuery("#jqGrid").getRowData(rowid);
             		$('#TEST_ID').val(list.TEST_ID); 										//시나리오 화면으로 이동 이벤트
             		
             		frm.target			='_self';
             		frm.action			="/QMS/jsp/view/qcl/qcl_scenario_list_view.jsp";
             		frm.submit();
             		
             	},    
    	  });
    	 //검색 option
    	 var gridOption = {searchOperators:true
    			 ,stringResult: true
    			 ,searchOnEnter: true
    			 ,odata: [{ oper:'eq', text:'equal'},{ oper:'ne', text:'not equal'},{ oper:'lt', text:'less'},{ oper:'le', text:'less or equal'},{ oper:'gt', text:'greater'},{ oper:'ge', text:'greater or equal'},{ oper:'bw', text:'begins with'},{ oper:'bn', text:'does not begin with'},{ oper:'in', text:'is in'},{ oper:'ni', text:'is not in'},{ oper:'ew', text:'ends with'},{ oper:'en', text:'does not end with'},{ oper:'cn', text:'contains'},{ oper:'nc', text:'does not contain'}] };
    	 jQuery("#jqGrid").jqGrid('filterToolbar',gridOption);
    

       	uf_loadProgState(); //리스트 데이터 호출

     });
</script>

	</form>
<%@ include file="/jsp/inc/inc_bottom.jsp" %>