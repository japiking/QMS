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
			// �����  
			var ajax = jex.createAjaxUtil("test_regist_case_do");	// ȣ���� ������
			
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
					alert("������ �߻��Ͽ����ϴ�.");
					bizException(e, "error");
				}
				
			});
			
		} catch(e) {
			alert("���൵�� ������ �߻��Ͽ����ϴ�.");
			bizException(e, "error");
		}
}

 