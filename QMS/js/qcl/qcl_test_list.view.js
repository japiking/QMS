/**
 * 
 */
// �׽�Ʈ �׸��� ���
 function uf_loadProgState(){
		$("#jqGrid").jqGrid("clearGridData", true).trigger("reloadGrid");
		var rowsData;
		try{
			// �����  
			var ajax = jex.createAjaxUtil("test_test_do");	// ȣ���� ������
			
			ajax.set("TASK_PACKAGE"	, "qcl" );					// [�ʼ�]���� package ȣ���� ������ ��Ű
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

 