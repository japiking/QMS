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
//엑셀 등록 팝업
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
<h3>테스트 관리</h3>	

<div id="dialog2" title="Dialog Title" style="display:none">
	<table id="jqGrid2"></table>
<div id="jqGridPager2"></div>

<script type="text/javascript"> 
//실행자 목록 그리드 출력	
	 $("#jqGrid2").jqGrid({
   	 	sortable: 	true,
        caption: 	"테스터 목록",
        datatype: 	"local",
        colNames:	['테스터 ID','사용자 명'],
        colModel: 	[
			{ label: '테스터 ID'	,	index: 'TESTER_ID', 		name: 'TESTER_ID',		width: 85, editable: true},
			{ label: '사용자명'	,	index: 'USERNAME', 			name: 'USERNAME',		width: 85, editable: true},
	        ],
      
        loadonce		: true, 
        multiselect		: true,
        recordpos		:'right',
		viewrecords		: true,				
        width			:  630,					//그리드 넓이
        height			: 420,					//그리드 높이
        rowNum			: 20,						//기본 한페이지에 보여주는 row수
        rowList			:[10,20,50,100],     	//한페이지에 보여주는 row수
        userDataOnFooter: true, 		//
        rownumbers		: true,
        pager			: "#jqGridPager2",
	 });
$(".ui-jqgrid-titlebar").hide();
</script>
</div>
<a href="#" class="btn" onclick="javascript:sc_regidit1();"><span>엑셀등록</span></a>
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
//시나리오 그리드
     $(document).ready(function() {	
    	 $("#jqGrid").jqGrid({
        	 sortable: true,
             caption: "시나리오 목록",
             datatype: "local",
             colNames:['TEST_ID','SCENARIO_ID','시나리오 명','TEST 시작일','TEST 종료일','삭제여부'],
             colModel: [
                { label: 'TEST_ID'  	,   index: 'TEST_ID'	,		id: 'TEST_ID'		,	name: 'TEST_ID'		,	key:true, hidden:true,	editable: true},
                { label: 'SCENARIO_ID'	, 	index: 'SCENARIO_ID',		id: 'SCENARIO_ID'	,	width: 100			,	name: 'SCENARIO_ID'	,	key:true, hidden:false,	editable: true,	searchoptions:{sopt:["eq","bw","le"]}},
				{ label: '시나리오 명'		,	index: 'SCENARIO_NM', 		name: 'SCENARIO_NM'	,	width: 140			, 	editable: true,			searchoptions:{sopt:["eq","bw","le"]}},
				{ label: 'TEST 시작일'		,	index: 'START_DATE'	, 		name: 'START_DATE'	, 	width: 85 			, 	editable: true,			editoptions:{size:12, dataInit:datepicker_view},	searchoptions:{sopt:["eq","bw","le"]}},
				{ label: 'TEST 종료일'		,	index: 'END_DATE'	, 		name: 'END_DATE'	, 	width: 85 			, 	editable: true,			editoptions:{size:12, dataInit:datepicker_view},	searchoptions:{sopt:["eq","bw","le"]}},
				{ label: '삭제여부'		,	index: 'DEL_FLAG'	, 		name: 'DEL_FLAG'	,	width: 30			, 	editable: true,			edittype:'select',formatter:'select',	editoptions:{value:'Y:Y;N:N'}},
             ],
           
             loadonce			: true, 
             multiselect		: false,
             recordpos			:'right',
			 viewrecords		: true,				
             width				: 650,				//그리드 넓이
             height				: 500,					//그리드 높이
             rowNum				: 20,						//기본 한페이지에 보여주는 row수
             rowList			:[10,20,50,100],     	//한페이지에 보여주는 row수
             userDataOnFooter	: true, 		//
             rownumbers			: true,
             pager				: "#jqGridPager",
             
             /* onSelectRow : function(rowid){  	
            	 
             }, */
             onPaging : function(){
            	 var tsId=$("#TEST_ID").val();
            	 var psId=$("#PROJECT_ID").val();	
            	 uf_loadProgState(tsId,psId);	//시나리오 그리드 출력
             },
             
             ondblClickRow :function(rowid){	
            	 uf_loadProgState1(rowid);		//케이스 그리드 출력
             }
           
    	  });
    	 //검색 option
    	 var gridOption = {searchOperators:true
    			 ,stringResult: true
    			 ,searchOnEnter: true
    			 ,odata: [{ oper:'eq', text:'equal'},{ oper:'ne', text:'not equal'},{ oper:'lt', text:'less'},{ oper:'le', text:'less or equal'},{ oper:'gt', text:'greater'},{ oper:'ge', text:'greater or equal'},{ oper:'bw', text:'begins with'},{ oper:'bn', text:'does not begin with'},{ oper:'in', text:'is in'},{ oper:'ni', text:'is not in'},{ oper:'ew', text:'ends with'},{ oper:'en', text:'does not end with'},{ oper:'cn', text:'contains'},{ oper:'nc', text:'does not contain'}] };
    	 jQuery("#jqGrid").jqGrid('filterToolbar',gridOption);
    	 
         $("#jqGrid").navGrid("#jqGridPager",
            {search:false,refresh: true,add:false ,edit: true,del:false,view:false,edittext:"편집",position: "left",	cloneToTop: false },
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
         $("#jqGrid").navGrid("#jqGridPager").jqGrid(
        		 'navButtonAdd',"#jqGridPager",{
        		  caption:"실행자 목록",
        		  buttonicon:"ui-icon-arrowthickstop-1-s",
        		  onClickButton: function(){
        			  $("#dialog2").dialog({
        				  autoOpen: true, 
        				  width: 650,
        				  height: 530,
        				  title: "시나리오 실행등록자 목록"
        				  });
        			  uf_loadProgState2(); 
        			  },
        		  position:"first"
        		 
        		 });
         
       	uf_loadProgState('<%=testId%>','<%=projectId%>'); //리스트 데이터 호출
//케이스 그리드       
    	 $("#jqGrid1").jqGrid({
        	 sortable: true,
             caption: "케이스 목록",
             datatype: "local",
             colNames:['TEST_ID','CASE_ID','SCENARIO_ID','케이스명 명','TEST 시작일','TEST 종료일','삭제여부'],
             colModel: [
                { label: 'TEST_ID'  	,   index: 'TEST_ID'	,          	name: 'TEST_ID'		,	key: true	,	width: 75	, 	hidden:true,	editable: true},
                { label: 'CASE_ID'  	,   index: 'CASE_ID'	,           name: 'CASE_ID'		,	key: true	,	width: 130	, 	hidden:false,	editable: true,searchoptions:{sopt:["eq","bw","le"]}},
                { label: 'SCENARIO_ID'	, 	index: 'SCENARIO_ID',           name: 'SCENARIO_ID'	,	key: true	,	width: 75	, 	hidden:true,	editable: true},
				{ label: '케이스 명'		,	index: 'CASE_NM'	, 			name: 'CASE_NM'		,	width: 120	, 	editable: true, searchoptions:{sopt:["eq","bw","le"]}},
				{ label: 'TEST 시작일'		,	index: 'START_DATE'	, 			name: 'START_DATE'	, 	width: 80 	, 	editable: true,	editoptions:{size:12, dataInit:datepicker_view},searchoptions:{sopt:["eq","bw","le"]}},
				{ label: 'TEST 종료일'		,	index: 'END_DATE'	, 			name: 'END_DATE'	, 	width: 80 	, 	editable: true,	editoptions:{size:12, dataInit:datepicker_view},searchoptions:{sopt:["eq","bw","le"]}},
				{ label: '삭제여부'		,	index: 'DEL_FLAG'	, 			name: 'DEL_FLAG'	,	width: 30	,  	editable: true, edittype:'select',formatter:'select',editoptions:{value:'Y:Y;N:N'}},
             ],
           
             loadonce			:true, 
             multiselect		: false,
             recordpos			:'right',
			 viewrecords		: true,				
             width				: 650,				//그리드 넓이
             height				: 500,					//그리드 높이
             rowNum				: 20,						//기본 한페이지에 보여주는 row수
             rowList			:[10,20,50,100],     	//한페이지에 보여주는 row수
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
    		 {search:false,refresh: false,add: false, edit: true,del:false,view:false,edittext:"편집",position: "left",	cloneToTop: false },
        	 
        	 {
             	/* Edit options */
             	addCaption: "Add Record",	editCaption: "결함수정",	bSubmit: "수정",	bCancel: "취소",	bClose: "닫기",	saveData: "수정하시겠습니까?",
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
    	 //실행자 목록 메뉴
    	 $("#jqGrid1").navGrid("#jqGridPager1").jqGrid(
        		 'navButtonAdd',"#jqGridPager1",{
        		  caption:"실행자 목록",
        		  buttonicon:"ui-icon-arrowthickstop-1-s",
        		  onClickButton: function(){
        			  $("#dialog2").dialog({
        				  autoOpen: true, 
        				  width: 650,
        				  height: 530,
        				  title: "케이스 실행등록자 목록"
        				  });
        			  uf_loadProgState3();
        			  },
        		  position:"first"
        		 });
    	 //검색 option
    	 var gridOption = {searchOperators:true
    			 ,stringResult: true
    			 ,searchOnEnter: true
    			 ,odata: [{ oper:'eq', text:'equal'},{ oper:'ne', text:'not equal'},{ oper:'lt', text:'less'},{ oper:'le', text:'less or equal'},{ oper:'gt', text:'greater'},{ oper:'ge', text:'greater or equal'},{ oper:'bw', text:'begins with'},{ oper:'bn', text:'does not begin with'},{ oper:'in', text:'is in'},{ oper:'ni', text:'is not in'},{ oper:'ew', text:'ends with'},{ oper:'en', text:'does not end with'},{ oper:'cn', text:'contains'},{ oper:'nc', text:'does not contain'}] };
    	 jQuery("#jqGrid1").jqGrid('filterToolbar',gridOption);
     });
     
</script>
</form>
<%@ include file="/jsp/inc/inc_bottom.jsp" %>