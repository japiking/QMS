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
 //�׸��� ���
 function uf_loadProgState(testId,projectId){
		$("#jqGrid").jqGrid("clearGridData", true).trigger("reloadGrid");
		var rowsData;
		try{
			// �����  
			var ajax = jex.createAjaxUtil("test_execute_scenario_do");	// ȣ���� ������
			
			ajax.set("TASK_PACKAGE"	, "qcl" );					// [�ʼ�]���� package ȣ���� ������ ��Ű
			ajax.set("TEST_ID"	, testId);
			ajax.set("PROJECT_ID"	, projectId);
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
			bizException(e, "error");
		}
}

//�׸��� ��� 
 function uf_loadProgState1(rowid){
		$("#jqGrid1").jqGrid("clearGridData", true).trigger("reloadGrid");
		var list = jQuery("#jqGrid").getRowData(rowid);
		var tsId=list.TEST_ID;
		var scId=list.SCENARIO_ID;
		var pjId=list.PROJECT_ID;
		var rowsData;
		try{
			// �����  
			var ajax = jex.createAjaxUtil("test_excute_case_do");	// ȣ���� ������
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
					bizException(e, "error");
				}
				
			});
			
		} catch(e) {
			bizException(e, "error");
		}
}
 