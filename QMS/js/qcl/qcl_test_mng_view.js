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
//�׽�Ʈ �׸��� ���
 function uf_loadProgState(){
		$("#jqGrid").jqGrid("clearGridData", true).trigger("reloadGrid");
		var rowsData;
		try{
			// �����  
			var ajax = jex.createAjaxUtil("test_list_do");	// ȣ���� ������
			
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
 //����
 function edit_submit(param,posdata){

		try{
			// �����  
			var ajax = jex.createAjaxUtil("test_update_do");	// ȣ���� ������
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
		uf_loadProgState();
	}
