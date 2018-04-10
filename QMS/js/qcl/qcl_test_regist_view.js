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
 //�ó����� �׸��� ���
 function uf_loadProgState(testid,projectid){
		$("#jqGrid").jqGrid("clearGridData", true).trigger("reloadGrid");
		var rowsData;
		try{
			// �����  
			var ajax = jex.createAjaxUtil("test_regist_do");	// ȣ���� ������
			
			ajax.set("TASK_PACKAGE"	, "qcl" );					// [�ʼ�]���� package ȣ���� ������ ��Ű
			ajax.set("TEST_ID"	, testid);
			ajax.set("PROJECT_ID"	, projectid);
			ajax.execute(function(dat) {
				try{
					rowsData = dat["_tran_res_data"][0];
					var result = rowsData.rows;
					
					 for(var i=0;i<=result.length;i++){ //�׸��忡 ���õ����� �߰�
				           $("#jqGrid").jqGrid('addRowData',i+1,result[i]);
				       }
					 
				}catch(e){
					bizException(e, "error");
				}
				
			});
			
		} catch(e) {
			alert("���൵�� ������ �߻��Ͽ����ϴ�.");
			bizException(e, "error");
			}
	}

 //���̽� �׸��� ���
 function uf_loadProgState1(rowid){
		$("#jqGrid1").jqGrid("clearGridData", true).trigger("reloadGrid");
		var list = jQuery("#jqGrid").getRowData(rowid);
		
		var tsId=list.TEST_ID;
		var scId=list.SCENARIO_ID;
		var pjId=list.PROJECT_ID;
		var rowsData;
		try{
			// �����  
			var ajax = jex.createAjaxUtil("test_regist_case_do");	// ȣ���� ������
			ajax.set("TASK_PACKAGE"	, "qcl" );					// [�ʼ�]���� package ȣ���� ������ ��Ű
			ajax.set("TEST_ID"	, tsId);
			ajax.set("PROJECT_ID"	, pjId);
			ajax.set("SCENARIO_ID",scId);
			ajax.execute(function(dat) {
				try{
					rowsData = dat["_tran_res_data"][0];
					var result = rowsData.rows;
					
					 for(var i=0;i<=result.length;i++){ //�׸��忡 ���õ����� �߰�
				           $("#jqGrid1").jqGrid('addRowData',i+1,result[i]);
				       }
					 
				}catch(e){
					alert("������ �߻��Ͽ����ϴ�.");
					bizException(e, "error");
				}
				
			});
			
		} catch(e) {
			alert("���൵�� ������ �߻��Ͽ����ϴ�.");
			bizException(e, "error");
			}
	}
//�ó����� ������ ��� �׸��� ��� 
 function uf_loadProgState2(){
		$("#jqGrid2").jqGrid("clearGridData", true).trigger("reloadGrid");
		 var rowid 		=	$("#jqGrid").jqGrid('getGridParam', "selrow" ); 
		 var list 		=	jQuery("#jqGrid").getRowData(rowid);
    	 var projectId	=	list.PROJECT_ID;
    	 var testId		=	list.TEST_ID;
    	 var scenarioId	=	list.SCENARIO_ID;
    	 var rowsData;
		try{
			// �����  
			var ajax = jex.createAjaxUtil("test_scenario_history_do");	// ȣ���� ������
			ajax.set("TASK_PACKAGE", "qcl" );					// [�ʼ�]���� package ȣ���� ������ ��Ű
			ajax.set("TEST_ID",testId);
			ajax.set("PROJECT_ID",projectId);
			ajax.set("SCENARIO_ID",scenarioId);
			ajax.execute(function(dat) {
				try{
					rowsData = dat["_tran_res_data"][0];
					var result = rowsData.rows;
				
					 for(var i=0;i<=result.length;i++){ //�׸��忡 ���õ����� �߰�
				           $("#jqGrid2").jqGrid('addRowData',i+1,result[i]);
				       }
					 
				}catch(e){
					alert("������ �߻��Ͽ����ϴ�.");
					bizException(e, "error");
				}
				
			});
			
		} catch(e) {
			alert("���൵�� ������ �߻��Ͽ����ϴ�.");
			bizException(e, "error");
			}
}
 //���̽� ������ ��� �׸��� ���
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
			// �����  
			var ajax = jex.createAjaxUtil("test_case_history_do");	// ȣ���� ������
			ajax.set("TASK_PACKAGE"	, "qcl" );					// [�ʼ�]���� package ȣ���� ������ ��Ű
			ajax.set("TEST_ID",testId);
			ajax.set("PROJECT_ID",projectId);
			ajax.set("SCENARIO_ID",scenarioId);
			ajax.set("CASE_ID",	caseId);
			ajax.execute(function(dat) {
				try{
					rowsData = dat["_tran_res_data"][0];
					var result = rowsData.rows;
					
					 for(var i=0;i<=result.length;i++){ //�׸��忡 ���õ����� �߰�
				           $("#jqGrid2").jqGrid('addRowData',i+1,result[i]);
				       }
					 
				}catch(e){
					alert("������ �߻��Ͽ����ϴ�.");
					bizException(e, "error");
				}
				
			});
			
		} catch(e) {
			alert("���൵�� ������ �߻��Ͽ����ϴ�.");
			bizException(e, "error");
			}
}
 //�ó����� �׸��� ����
 function edit_submit(param,posdata){

		try{
			// �����  
			var ajax = jex.createAjaxUtil("test_regist_update_do");	// ȣ���� ������
			ajax.set("TASK_PACKAGE"	, "qcl" );					// [�ʼ�]���� package ȣ���� ������ ��Ű
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
 // ���̽� �׸��� ����
 function edit_submit1(param,posdata){

		try{
			// �����  
			var ajax = jex.createAjaxUtil("test_regist_case_update_do");	// ȣ���� ������
			ajax.set("TASK_PACKAGE"	, "qcl" );					// [�ʼ�]���� package ȣ���� ������ ��Ű
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
 //�޷��̺�Ʈ
function datepicker_view(el) {

		$(el).datepicker({
			dateFormat : 'yy-mm-dd'
		});
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
