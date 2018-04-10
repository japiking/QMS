/**
 * 
 */
jQuery.fn.center = function() {
	this.css("position", "absolute");
	this.css("width", "70%");
	this.css("height", "auto");
	this.css("top", "0px");
	this.css("left", ($(window).width() - this.width()) / 2	+ $(window).scrollLeft() + "px");
	return this;
}

function edit_field(form) {

	$('#STEP_ID').attr("disabled", true);

}
// ���� ������ load
function uf_loadProgState(testId, projectId, scenarioId, caseId) {
	$("#jqGrid").jqGrid("clearGridData", true).trigger("reloadGrid");
		
	var rowsData;
	try {
		// �����
		var ajax = jex.createAjaxUtil("test_case_popup_do"); // ȣ���� ������

		ajax.set("TASK_PACKAGE", "qcl"); // [�ʼ�]���� package ȣ���� ������ ��Ű
		ajax.set("TEST_ID", testId);
		ajax.set("PROJECT_ID", projectId);
		ajax.set("SCENARIO_ID", scenarioId);
		ajax.set("CASE_ID", caseId);

		ajax.execute(function(dat) {
			try {
				rowsData = dat["_tran_res_data"][0];
				var result = rowsData.rows;
				for (var i = 0; i <= result.length; i++) { // �׸��忡 ���õ����� �߰�
					$("#jqGrid").jqGrid('addRowData', i + 1, result[i]);
				}
			} catch (e) {
				alert("������ �߻��Ͽ����ϴ�.");
				bizException(e, "error");
			}
		});

	} catch (e) {
		alert("���൵�� ������ �߻��Ͽ����ϴ�.");
		bizException(e, "error");
	}
}
//������ ��� ������ load
function uf_loadProgState1(rowid) {
	$("#jqGrid1").jqGrid("clearGridData", true).trigger("reloadGrid");
	var list 		= jQuery("#jqGrid").getRowData(rowid);
	var projectId	=list.PROJECT_ID;
	var testId		=list.TEST_ID;
	var scenarioId	=list.SCENARIO_ID;
	var caseId		=list.CASE_ID;
	var stepId		=list.STEP_ID;
	
	$("#stID").val(list.STEP_ID);		//���� ���̵� ���
	$("#stNM").val(list.STEP_NM);		//���� �̸� ���
	
	var rowsData;
	try {
		// �����
		var ajax = jex.createAjaxUtil("test_step_history_do"); // ȣ���� ������
		
		ajax.set("TASK_PACKAGE", "qcl"); // [�ʼ�]���� package ȣ���� ������ ��Ű
		ajax.set("PROJECT_ID",	 projectId);
		ajax.set("TEST_ID",		 testId);
		ajax.set("SCENARIO_ID",	 scenarioId);
		ajax.set("CASE_ID",	 	caseId);
		ajax.set("STEP_ID",		stepId);

		ajax.execute(function(dat) {
			try {
				rowsData = dat["_tran_res_data"][0];
				var result = rowsData.rows;
				
				for (var i = 0; i <= result.length; i++) { // �׸��忡 ���õ����� �߰�
					$("#jqGrid1").jqGrid('addRowData', i + 1, result[i]);
				}

			} catch (e) {
				alert("������ �߻��Ͽ����ϴ�.");
				bizException(e, "error");
			}

		});

	} catch (e) {
		alert("���൵�� ������ �߻��Ͽ����ϴ�.");
		bizException(e, "error");
	}
}
//����
function edit_submit(param, posdata) {

	try {
		// �����
		var ajax = jex.createAjaxUtil("test_regist_case_popup_do"); // ȣ���� ������
		ajax.set("TASK_PACKAGE", "qcl"); 							// [�ʼ�]���� package ȣ���� ������ ��Ű
		ajax.set("data", posdata);

		ajax.execute(function(dat) {
			var data = dat["_tran_res_data"][0];
			var result = data.RESULT;
			if (result == "1") {
				alert("������ �Ϸ�Ǿ����ϴ�.");
			} else {
				alert("������ ������ �߻� �Ǿ����ϴ�");
			}

		});
	} catch (e) {
		alert("���� �� ������ �߻��Ͽ����ϴ�.");
	} finally {
		$('#cData').trigger('click');
	}
	$("#jqGrid").jqGrid("clearGridData", true).trigger("reloadGrid");
	uf_loadProgState();
}


// ���ó�¥ ��������
function default_date() {
	var currentTime = new Date();
	var month = parseInt(currentTime.getMonth() + 1);
	month = month <= 9 ? "0" + month : month;
	var day = currentTime.getDate();
	day = day <= 9 ? "0" + day : day;
	var year = currentTime.getFullYear();
	return year + "-" + month + "-" + day;
}
//����
function del_Submit(param,posdata){
	 var dataFromTheRow = $('#jqGrid').jqGrid ('getRowData', posdata); //row������ �������� posdata->rowid
	 
		try{
			// �����  
			var ajax = jex.createAjaxUtil("test_case_popup_delete_do");	// ȣ���� ������
			ajax.set("TASK_PACKAGE"	, "qcl" );					// [�ʼ�]���� package ȣ���� ������ ��Ű
			ajax.set("data"			, dataFromTheRow ); 
				 						
			ajax.execute(function(dat) {
				var data = dat["_tran_res_data"][0];
				var result = data.RESULT;
				if(result == "1"){
					alert("���� �ǽ��ϴ�.");
				}else{
					alert("������ ������ �߻� �Ǿ����ϴ�");
				}
			});		
		} catch(e) {
			alert("���� �� ������ �߻��Ͽ����ϴ�.");
		}finally{
			$('#cData').trigger('click');
		}
		$("#jqGrid").jqGrid("clearGridData", true).trigger("reloadGrid");
		uf_loadProgState();
	}


//���������丮 ������
function uf_loadProgState1() {
	$("#jqGrid1").jqGrid("clearGridData", true).trigger("reloadGrid");
	var rowid =  $("#jqGrid").jqGrid('getGridParam', "selrow" );  
	var list 		= jQuery("#jqGrid").getRowData(rowid);
	var projectId	=list.PROJECT_ID;
	var testId		=list.TEST_ID;
	var scenarioId	=list.SCENARIO_ID;
	var caseId		=list.CASE_ID;
	var stepId		=list.STEP_ID;
	
	$("#stID").val(list.STEP_ID);	//step ���̵�
	$("#stNM").val(list.STEP_NM);	//step ��
	
	var rowsData;
	try {
		// �����
		var ajax = jex.createAjaxUtil("test_excute_step_do"); // ȣ���� ������
		ajax.setAsync(true);									//����ȭ
		ajax.set("TASK_PACKAGE"	, "qcl"); // [�ʼ�]���� package ȣ���� ������ ��Ű
		ajax.set("PROJECT_ID"	,	projectId);
		ajax.set("TEST_ID"		,	testId);
		ajax.set("SCENARIO_ID"	,	scenarioId);
		ajax.set("CASE_ID"		,	caseId);
		ajax.set("STEP_ID"		,	stepId);
		ajax.execute(function(dat) {
			try {
				rowsData = dat["_tran_res_data"][0];
				var result = rowsData.rows;
				var count = rowsData.count;
				var statLvl=0;
				$("#tsNUM").val(count);		// �׽�Ʈ �� ���
				for (var i = 0; i < result.length; i++) { // �׸��忡 ���õ����� �߰�
					statLvl = eval(result[i].STATUS_LEVEL);
					if(statLvl==3 ||statLvl==4){
						result[i].STEP_STATUS = "�Ϸ�";
					}
					$("#jqGrid1").jqGrid('addRowData', i + 1, result[i]);
				}

			} catch (e) {
				bizException(e,"������ �߻��Ͽ����ϴ�.");
			}

		});

	} catch (e) {
		bizException(e, "���൵�� ������ �߻��Ͽ����ϴ�.");
	}
}
// ���� ��ư
function exe_del(cellvalue, options, rowObject){
	var rowid = options.rowId;
	var str = '<button id="'+rowid+'" onclick=del_click("'+rowid+'");>����</button>';
        return str;
	
}
// ����
function del_click(rowid){
 
	var list 		= jQuery("#jqGrid1").getRowData(rowid);
	var projectId	=list.PROJECT_ID;
	var testId		=list.TEST_ID;
	var testerId	=list.TESTER_ID;
	var scenarioId	=list.SCENARIO_ID;
	var caseId		=list.CASE_ID;
	var stepId		=list.STEP_ID;
	var action_Seq	=list.ACTION_SEQ;
	
		try{
			// �����  
			var ajax = jex.createAjaxUtil("test_step_popup_del_do");	// ȣ���� ������
			ajax.set("TASK_PACKAGE", 	"qcl" );					// [�ʼ�]���� package ȣ���� ������ ��Ű
			ajax.set("TEST_ID",			testId);
			ajax.set("TESTER_ID",		testerId);
			ajax.set("SCENARIO_ID",     scenarioId);
			ajax.set("CASE_ID",			caseId);
			ajax.set("STEP_ID",			stepId);
			ajax.set("ACTION_SEQ",		action_Seq);
			
			ajax.execute(function(dat) {
				var data = dat["_tran_res_data"][0];
				var result = data.RESULT;
				if(flag == "1"){
					alert("���� �ǽ��ϴ�.");
				}else{
					alert("������ ������ �߻� �Ǿ����ϴ�");
				}
			});		
		} catch(e) {
			alert("���� �� ������ �߻��Ͽ����ϴ�.");
		}finally{
			$('#cData').trigger('click');
		}
		$("#jqGrid1").jqGrid("clearGridData", true).trigger("reloadGrid");
		uf_loadProgState1();
	}

