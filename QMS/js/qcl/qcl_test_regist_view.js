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
 //시나리오 그리드 출력
 function uf_loadProgState(testid,projectid){
		$("#jqGrid").jqGrid("clearGridData", true).trigger("reloadGrid");
		var rowsData;
		try{
			// 공통부  
			var ajax = jex.createAjaxUtil("test_regist_do");	// 호출할 페이지
			
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
					bizException(e, "error");
				}
				
			});
			
		} catch(e) {
			alert("실행도중 오류가 발생하였습니다.");
			bizException(e, "error");
			}
	}

 //케이스 그리드 출력
 function uf_loadProgState1(rowid){
		$("#jqGrid1").jqGrid("clearGridData", true).trigger("reloadGrid");
		var list = jQuery("#jqGrid").getRowData(rowid);
		
		var tsId=list.TEST_ID;
		var scId=list.SCENARIO_ID;
		var pjId=list.PROJECT_ID;
		var rowsData;
		try{
			// 공통부  
			var ajax = jex.createAjaxUtil("test_regist_case_do");	// 호출할 페이지
			ajax.set("TASK_PACKAGE"	, "qcl" );					// [필수]업무 package 호출할 페이지 패키
			ajax.set("TEST_ID"	, tsId);
			ajax.set("PROJECT_ID"	, pjId);
			ajax.set("SCENARIO_ID",scId);
			ajax.execute(function(dat) {
				try{
					rowsData = dat["_tran_res_data"][0];
					var result = rowsData.rows;
					
					 for(var i=0;i<=result.length;i++){ //그리드에 로컬데이터 추가
				           $("#jqGrid1").jqGrid('addRowData',i+1,result[i]);
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
//시나리오 실행자 목록 그리드 출력 
 function uf_loadProgState2(){
		$("#jqGrid2").jqGrid("clearGridData", true).trigger("reloadGrid");
		 var rowid 		=	$("#jqGrid").jqGrid('getGridParam', "selrow" ); 
		 var list 		=	jQuery("#jqGrid").getRowData(rowid);
    	 var projectId	=	list.PROJECT_ID;
    	 var testId		=	list.TEST_ID;
    	 var scenarioId	=	list.SCENARIO_ID;
    	 var rowsData;
		try{
			// 공통부  
			var ajax = jex.createAjaxUtil("test_scenario_history_do");	// 호출할 페이지
			ajax.set("TASK_PACKAGE", "qcl" );					// [필수]업무 package 호출할 페이지 패키
			ajax.set("TEST_ID",testId);
			ajax.set("PROJECT_ID",projectId);
			ajax.set("SCENARIO_ID",scenarioId);
			ajax.execute(function(dat) {
				try{
					rowsData = dat["_tran_res_data"][0];
					var result = rowsData.rows;
				
					 for(var i=0;i<=result.length;i++){ //그리드에 로컬데이터 추가
				           $("#jqGrid2").jqGrid('addRowData',i+1,result[i]);
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
 //케이스 실행자 목록 그리드 출력
 function uf_loadProgState3(){
		$("#jqGrid2").jqGrid("clearGridData", true).trigger("reloadGrid");
		var rowid	=	$("#jqGrid1").jqGrid('getGridParam', "selrow" );
		var list	=	jQuery("#jqGrid1").getRowData(rowid);
		
		 projectId	=	list.PROJECT_ID;
		 testId		=	list.TEST_ID;
		 scenarioId	=	list.SCENARIO_ID;
		 caseId		=	list.CASE_ID;
		
		var rowsData;
		try{
			// 공통부  
			var ajax = jex.createAjaxUtil("test_case_history_do");	// 호출할 페이지
			ajax.set("TASK_PACKAGE"	, "qcl" );					// [필수]업무 package 호출할 페이지 패키
			ajax.set("TEST_ID",testId);
			ajax.set("PROJECT_ID",projectId);
			ajax.set("SCENARIO_ID",scenarioId);
			ajax.set("CASE_ID",	caseId);
			ajax.execute(function(dat) {
				try{
					rowsData = dat["_tran_res_data"][0];
					var result = rowsData.rows;
					
					 for(var i=0;i<=result.length;i++){ //그리드에 로컬데이터 추가
				           $("#jqGrid2").jqGrid('addRowData',i+1,result[i]);
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
 //시나리오 그리드 수정
 function edit_submit(param,posdata){

		try{
			// 공통부  
			var ajax = jex.createAjaxUtil("test_regist_update_do");	// 호출할 페이지
			ajax.set("TASK_PACKAGE"	, "qcl" );					// [필수]업무 package 호출할 페이지 패키
			ajax.set("data"			, posdata ); 
									
			ajax.execute(function(dat) {
				var data = dat["_tran_res_data"][0];
				var result = data.RESULT;
				
			});		
		} catch(e) {

		}finally{
			$('#cData').trigger('click');
		}
		$("#jqGrid").jqGrid("clearGridData", true).trigger("reloadGrid");
		var testid=$("#TEST_ID").val();
		var projectid=$("#PROJECT_ID").val();
		console.log(testid);
		uf_loadProgState(testid,projectid);
}
 // 케이스 그리드 수정
 function edit_submit1(param,posdata){

		try{
			// 공통부  
			var ajax = jex.createAjaxUtil("test_regist_case_update_do");	// 호출할 페이지
			ajax.set("TASK_PACKAGE"	, "qcl" );					// [필수]업무 package 호출할 페이지 패키
			ajax.set("data"			, posdata ); 
				 						
			ajax.execute(function(dat) {
				var data = dat["_tran_res_data"][0];
				var result = data.RESULT;
					
			});		
		} catch(e) {

		}finally{
			$('#cData').trigger('click');
		}
		$("#jqGrid1").jqGrid("clearGridData", true).trigger("reloadGrid");
		uf_loadProgState1();
	}
 //달력이벤트
function datepicker_view(el) {

		$(el).datepicker({
			dateFormat : 'yy-mm-dd'
		});
}

	// 오늘날짜 가져오기
	function default_date() {
		var currentTime = new Date();
		var month = parseInt(currentTime.getMonth() + 1);
		month = month <= 9 ? "0" + month : month;
		var day = currentTime.getDate();
		day = day <= 9 ? "0" + day : day;
		var year = currentTime.getFullYear();
		return year + "-" + month + "-" + day;
	}
