/**
 * 
 */
jQuery.fn.center = function () {
	    this.css("position","absolute");
	    this.css("width", "70%");
	    this.css("height", "auto");
	    this.css("top", "0px");
	    this.css("left", ( $(window).width() - this.width() ) / 2+$(window).scrollLeft() + "px");
	    return this;
}
 
 function uf_loadProgState1(testid,projectid){
		$("#jqGrid1").jqGrid("clearGridData", true).trigger("reloadGrid");
		var rowsData;
		try{
			// 공통부  
			var ajax = jex.createAjaxUtil("test_regist_case_do");	// 호출할 페이지
			
			ajax.set("TASK_PACKAGE"	, "qcl" );					// [필수]업무 package 호출할 페이지 패키
			ajax.set("TEST_ID"	, testid);
			ajax.set("PROJECT_ID"	, projectid);
			ajax.execute(function(dat) {
				try{
					rowsData = dat["_tran_res_data"][0];
					var result = rowsData.rows;
					
					 for(var i=0;i<=result.length;i++){ //그리드에 로컬데이터 추가
				           $("#jqGrid").jqGrid('addRowData',i+1,result[i]);
				       }
					 
				}catch(e){
					alert("오류가 발생하였습니다.");
					bizException(e, "error");
				}
				
			});
			
		} catch(e) {
			alert("실행도중 오류가 발생하였습니다.");
			bizException(e, "error");
		}
}

 