/**
 * 
 */
// 테스트 그리드 출력
 function uf_loadProgState(){
		$("#jqGrid").jqGrid("clearGridData", true).trigger("reloadGrid");
		var rowsData;
		try{
			// 공통부  
			var ajax = jex.createAjaxUtil("test_test_do");	// 호출할 페이지
			
			ajax.set("TASK_PACKAGE"	, "qcl" );					// [필수]업무 package 호출할 페이지 패키
			ajax.execute(function(dat) {
				try{
					rowsData = dat["_tran_res_data"][0];
					var result = rowsData.rows;
					 for(var i=0;i<=result.length;i++){ //그리드에 로컬데이터 추가
				           $("#jqGrid").jqGrid('addRowData',i+1,result[i]);    
				       }
				}catch(e){
					bizException(e, "error");
				}	
			});			
		} catch(e) {
			bizException(e, "error");
		}
}

 