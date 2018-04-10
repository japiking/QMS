/**
 * 
 */
jQuery.fn.center = function() {
	this.css("position", "absolute");
	this.css("width", "70%");
	this.css("height", "auto");
	this.css("top", "0px");
	this.css("left", ($(window).width() - this.width()) / 2 + $(window).scrollLeft() + "px");
	return this;
}
function edit_field(form) {

	$('#STEP_ID').attr("disabled", true);

}
//스텝 그리드 출력
function uf_loadProgState(testId, projectId, scenarioId, caseId) {
	$("#jqGrid").jqGrid("clearGridData", true).trigger("reloadGrid");
		
	var rowsData;
	try {
		// 공통부
		var ajax = jex.createAjaxUtil("test_case_popup_do"); // 호출할 페이지

		ajax.set("TASK_PACKAGE", "qcl"); // [필수]업무 package 호출할 페이지 패키
		ajax.set("TEST_ID", testId);
		ajax.set("PROJECT_ID", projectId);
		ajax.set("SCENARIO_ID", scenarioId);
		ajax.set("CASE_ID", caseId);

		ajax.execute(function(dat) {
			try {
				rowsData = dat["_tran_res_data"][0];
				var result = rowsData.rows;
				for (var i = 0; i <= result.length; i++) { // 그리드에 로컬데이터 추가
					$("#jqGrid").jqGrid('addRowData', i + 1, result[i]);
				}

			}catch (e) {
				alert("오류가 발생하였습니다.");
				bizException(e, "error");
			}

		});

	}catch (e){
		alert("실행도중 오류가 발생하였습니다.");
		bizException(e, "error");
	}
}

//실행자 목록 그리드 출력
function uf_loadProgState1() {
	$("#jqGrid1").jqGrid("clearGridData", true).trigger("reloadGrid");
	var rowid 		= jQuery("#jqGrid").jqGrid('getGridParam', "selrow" );
	var list 		= jQuery("#jqGrid").getRowData(rowid);
	
	$("#stID").val(list.STEP_ID);
	$("#stNM").val(list.STEP_NM);

	var projectId	=list.PROJECT_ID;
	var testId		=list.TEST_ID;
	var scenarioId	=list.SCENARIO_ID;
	var caseId		=list.CASE_ID;
	var stepId		=list.STEP_ID;
	var rowsData;
	try {
		// 공통부
		var ajax = jex.createAjaxUtil("test_step_history_do"); // 호출할 페이지
		
		ajax.set("TASK_PACKAGE", "qcl"); // [필수]업무 package 호출할 페이지 패키
		ajax.set("PROJECT_ID",	 projectId);
		ajax.set("TEST_ID",		 testId);
		ajax.set("SCENARIO_ID",	 scenarioId);
		ajax.set("CASE_ID",	 	caseId);
		ajax.set("STEP_ID",		stepId);

		ajax.execute(function(dat) {
			try {
				rowsData = dat["_tran_res_data"][0];
				var result = rowsData.rows;
				var count = rowsData.count;
				for (var i = 0; i <= result.length; i++) { // 그리드에 로컬데이터 추가
					$("#jqGrid1").jqGrid('addRowData', i + 1, result[i]);
				}
				$("#tsNUM").val(count); //history 건수
				
			} catch (e) {
				alert("오류가 발생하였습니다.");
				bizException(e, "error");
			}

		});

	} catch (e) {
		alert("실행도중 오류가 발생하였습니다.");
		bizException(e, "error");
	}
}
//수정
function edit_submit(param, posdata) {
	try {
		// 공통부
		var ajax = jex.createAjaxUtil("test_regist_case_popup_do"); // 호출할 페이지
		ajax.set("TASK_PACKAGE", "qcl"); // [필수]업무 package 호출할 페이지 패키
		ajax.set("data", posdata);

		ajax.execute(function(dat) {
			var data = dat["_tran_res_data"][0];
			var result = data.RESULT;
			if (result == "1"){
				alert("수정이 완료되었습니다.");
			} else {
				alert("수정중 오류가 발생 되었습니다");
			}

		});
	} catch (e) {
		alert("수정 중 오류가 발생하였습니다.");
	} finally {
		$('#cData').trigger('click');
	}
	$("#jqGrid").jqGrid("clearGridData", true).trigger("reloadGrid");
	uf_loadProgState();
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
//삭제
function del_Submit(param,posdata){
	 var dataFromTheRow = $('#jqGrid').jqGrid ('getRowData', posdata); //row데이터 가져오기 posdata->rowid	 
		try{
			// 공통부  
			var ajax = jex.createAjaxUtil("test_case_popup_delete_do");	// 호출할 페이지
			ajax.set("TASK_PACKAGE"	, "qcl" );					// [필수]업무 package 호출할 페이지 패키
			ajax.set("data"			, dataFromTheRow ); 
				 						
			ajax.execute(function(dat) {
				var data = dat["_tran_res_data"][0];
				var result = data.RESULT;
				if(result == "1"){
					alert("삭제 되습니다.");
				}else{
					alert("삭제중 오류가 발생 되었습니다");
				}
			});		
		} catch(e) {
			alert("삭제 중 오류가 발생하였습니다.");
		}finally{
			$('#cData').trigger('click');
		}
		$("#jqGrid").jqGrid("clearGridData", true).trigger("reloadGrid");
		uf_loadProgState();
}