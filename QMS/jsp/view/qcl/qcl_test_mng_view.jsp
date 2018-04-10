<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%@ include file="/jsp/inc/inc_common.jsp" %>
<%@ include file="/jsp/inc/inc_header.jsp" %>
<%
String today		= DateTime.getInstance().getDate("yyyy-mm-dd");
String inq_date		= StringUtil.null2void(request.getParameter("INQ_DATE"), today);
%>
<script src="/QMS/js/qcl/qcl_test_mng_view.js"></script>
<script type="text/javascript">
//TEST ID 중복 체크	
function ts_idCheck(){
	var id = $("#test_id").val();
	if(id != null) id = $.trim(id);
	
	if(id == ""){
		alert("ID를 입력하세요.");
		return false;
	}
	
	frm.target			= 'HiddenFrame';
	frm.action			= "/QMS/jsp/proc/qcl/qcl_test_idCheck_do.jsp";
	frm.submit();
}
//TEST ID 등록
function ts_regedit() {
	var frm = document.frm;
	
	if(frm.test_nm.value == "") {
		alert("TEST 명은 필수 입력사항입니다.");
		return;
	}
		
	frm.target			= '_self';
	frm.action			= "/QMS/jsp/proc/qcl/qcl_test_insert_do.jsp";
	frm.submit();

}

</script>
<%@ include file="/jsp/inc/inc_topMenu.jsp" %>
<%@ include file="/jsp/inc/inc_leftMenu.jsp" %>
<form name="frm" method="post" action="/QMS/jsp/view/qcl/qcl_test_regist_view.jsp" >
<input type="hidden" name="TEST_ID1" id="TEST_ID1" />
<input type="hidden" name="STT_DATE" />
<input type="hidden" name="END_DATE" />
<input type="hidden" name="BIGO" />
<input type="hidden" name="NM" />
<h3>테스트 관리</h3>
<!-- 테스트 등록  -->
<div class="wrap">
	<table>
	
		<colgroup>
			<col width="15%"/>
			<col width="15%"/>
			<col width="15%"/>
			<col width="15%"/>
			<col width="*"/>	
		</colgroup>
		<tbody>
		
			<tr>
				<th>TEST ID</th>
					<td>
						<input type="text" id="test_id" name="test_id" style="width:200px"/>
						<a href="#FIT" class="btn" onclick="javascript:ts_idCheck();"><span>중복확인</span></a>
					</td>						
				<th>TEST 명</th>
					<td>
						<input type="text" id="test_nm" name="test_nm" style="width:200px" />
					</td>
			</tr>	
			<tr>				
				<th>TEST 시작일</th>
				<td>
					<div class="btnWrapL">
						<input readonly="readonly" id="test_sttg_date" name="test_sttg_date" value="<%=inq_date%>" style="width: 70px"  onclick="javascript:datepicker_view(frm.test_sttg_date);" />
					    <!-- <a href="#FIT" onclick="javascript:datepicker_view(frm.test_sttg_date);"><img src="/QMS/img/btn_s_cal.gif" alt="달력" class="bt_i"></a> -->
					</div>
				</td>
				<th>TEST 종료일</th>
				<td>
					<div class="btnWrapL">
						<input readonly="readonly" id="test_endg_date" name="test_endg_date" value="<%=inq_date%>" style="width: 70px"  onclick="javascript:datepicker_view(frm.test_endg_date);" />
					    <!-- <a href="#FIT" onclick="javascript:datepicker_view(frm.test_endg_date);"><img src="/QMS/img/btn_s_cal.gif" alt="달력" class="bt_i"></a> -->
					</div>
				</td>
			</tr>
			<tr>				
				<th>비고(참고사항)</th>
				<td colspan="5">
					<textarea id="test_bigo" name="test_bigo" cols="80" rows="10" style="width:1000px; height:100px; overflow-y:hidden;"></textarea>	
				</td>		
			</tr>	

	</tbody>
						
	</table>
	</div>
	<br>
<div class="btnWrapL">
	<a href="#FIT" class="btn" style="vertical-align: bottom" onclick="javascript:ts_regedit();"><span>등록</span></a>
</div>					
<br>

<table id="jqGrid"></table>
<div id="jqGridPager"></div>
<script type="text/javascript"> 
   
     $(document).ready(function () {
    	 
    	 //달력 이벤트
    	 $("#test_sttg_date").datepicker({
 			dateFormat : 'yy-mm-dd',
 			showAnim: "slideDown"
 		});
    	 $("#test_endg_date").datepicker({
 			dateFormat : 'yy-mm-dd',
 			showAnim: "slideDown"
 		});
    	 
    	 //test목록 그리드
    	 $("#jqGrid").jqGrid({
        	 sortable: true,
             caption: "TEST 목록",
             datatype: "local",
             colNames:['TEST_ID','테스트 명','시나리오 건수','케이스 건수','step 건수', 'TEST 시작일','TEST 종료일','삭제여부','TEST_BIGO'],
             colModel: [
                { label: 'TEST_ID'  , 	index: 'TEST_ID',           	name: 'TEST_ID',			key:true,	width: 75,editable: true,searchoptions:{sopt:["eq","bw","le"]}},
				{ label: '테스트 명'	,	index: 'TEST_NM', 			 	name: 'TEST_NM',	 		width: 75, 	editable: true,searchoptions:{sopt:["eq","bw","le"]}},
				{ label: '시나리오 건수'	,	index: 'SCENARIO_CNT', 			name: 'SCENARIO_CNT',		width: 75, 	editable: true},
				{ label: '케이스 건수'	,	index: 'CASE_CNT', 				name: 'CASE_CNT', 			width: 75, 	editable: true},
				{ label: 'step 건수'	,	index: 'STEP_CNT', 				name: 'STEP_CNT',	 		width: 100, editable: true},
				{ label: 'TEST 시작일'	,	index: 'TEST_STTG_DATE', 		name: 'TEST_STTG_DATE', 	width: 80 , editable: true,editoptions:{size:12, dataInit:datepicker_view},searchoptions:{sopt:["eq","bw","le"]}},
				{ label: 'TEST 종료일'	,	index: 'TEST_ENDG_DATE', 		name: 'TEST_ENDG_DATE', 	width: 80 , editable: true,editoptions:{size:12, dataInit:datepicker_view},searchoptions:{sopt:["eq","bw","le"]}},
				{ label: '삭제여부'	,	index: 'DEL_FLAG', 				name: 'DEL_FLAG', 			width: 80 , editable: true,edittype:'select',formatter:'select',editoptions:{value:'Y:Y;N:N'}},
				{ label: 'TEST_BIGO',   index: 'TEST_BIGO',             name: 'TEST_BIGO',			width: 75, 	hidden:true,	editable: true},
				
             ],
             rownumbers			:true,
             loadonce			:true, 
             multiselect		: true,
			 viewrecords		: true,				
             autowidth			: true,				//그리드 넓이
             height				: 300,					//그리드 높이
             rowNum				: 20,						//기본 한페이지에 보여주는 row수
             rowList			:[10,20,50,100],     	//한페이지에 보여주는 row수
             userDataOnFooter	: true, 		//
             multiselect		: false, 
             pager				: "#jqGridPager",
             
             ondblClickRow : function(rowid, iCol){ 
             		var frm				=document.frm;
             		var list 			= jQuery("#jqGrid").getRowData(rowid);
             		$('#TEST_ID1').val(list.TEST_ID); 
             		
             		frm.target			='_self';
             		frm.action			="/QMS/jsp/view/qcl/qcl_test_regist_view.jsp";
             		frm.submit();
             		
             	}    
    	  });
    	
    	 $("#jqGrid").navGrid("#jqGridPager",
                 {
        	 add:false,search:false,refresh: false, edit: true,del:false,view:true,edittext:"편집",position: "left",	cloneToTop: false },
        	
        	 {
             	/* Edit options */
             	addCaption: "Add Record",	editCaption: "결함수정",	bSubmit: "수정",	bCancel: "취소",	bClose: "닫기",	saveData: "수정하시겠습니까?",
         		bYes : "Yes",	bNo : "No",	bExit : "Cancel",	
         		ShowForm: function(form) {
         		    form.closest('div.ui-jqdialog').center();
         		},
         		onclickSubmit 	:edit_submit,
         		closeAfterEdit	: true,
         		recreateForm	: true,
         		viewPagerButtons: true,
         		closeOnEscape	:true
             	
             }
        	 );
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