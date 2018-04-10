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

//add ����     
 function add_field(form){
	 CKEDITOR.replace('DEFECT_CNTS');
	 form.closest('div.ui-jqdialog').center();
	 
	 $('#tr_DEFECT_PROCESS_DATE').hide();
	 $('#tr_DEFECT_CHECK_DATE').hide();
	 $('#tr_DEFECT_STATUS').hide();
	 $('#DEFECT_START_DATE').attr("disabled",true);
	 $('#DEFECT_START_DATE').val(default_date);
	 
 }
 //add�� ����ھ��̵� �־��ְ� �����Ұ�
 function add_custom_value(id){
	 $("#TESTER_ID").val(id);
	 $('#TESTER_ID').attr("disabled",true);
 }
 
 
//edit ����
function edit_field(form){
	 CKEDITOR.replace('DEFECT_CNTS');
	 form.closest('div.ui-jqdialog').center();
	 $('#DEFECT_START_DATE').attr("disabled",true);
	 $('#DEFECT_PROCESS_DATE').val(default_date());
	 $('#DEFECT_CHECK_DATE').val(default_date());
	 $('#tr_DEFECT_CHECK_DATE').hide();
	 $('#tr_DEFECT_PROCESS_DATE').hide();
	 $('#TESTER_ID').attr("disabled",true);
} 

//���ó�¥ ��������
function default_date(){
	var currentTime = new Date();
	var month = parseInt(currentTime.getMonth() + 1);
	month = month <= 9 ? "0"+month : month;
	var day = currentTime.getDate();
	day = day <= 9 ? "0"+day : day;
	var year = currentTime.getFullYear();
	return year+"-"+month + "-"+day;
}


//gird load �� ���Ը���Ʈ ������ ��������
function uf_loadProgState(testid){
	//$("#jqGrid").jqGrid("clearGridData", true).trigger("reloadGrid");
	$("#jqGrid").jqGrid('clearGridData');
	      
	var rowsData;
	try{
		// �����  
		var ajax = jex.createAjaxUtil("defect_list_do");	// ȣ���� ������
		ajax.set("TASK_PACKAGE"	, "qcl" );					// [�ʼ�]���� package ȣ���� ������ ��Ű
		if(null!=testid && undefined!=testid){
			ajax.set("TEST_ID"	, testid);
		}
		ajax.execute(function(data) {
			try{
				rowsData = data["_tran_res_data"][0];
				var result = rowsData.rows;
				 for(var i=0;i<=result.length;i++){ //�׸��忡 ���õ����� �߰�
			           $("#jqGrid").jqGrid('addRowData',i+1,result[i]);
			       }
				 
			}catch(e){
				alert("������ �߻��Ͽ����ϴ�.");
			}
			
		});
		
	} catch(e) {
		alert("���൵�� ������ �߻��Ͽ����ϴ�.");
		}
}


    
//���     
function add_Submit(param,posdata){
	var conts	=	CKEDITOR.instances.DEFECT_CNTS.getData();	//�󼼼���
	try{
		// �����  
		var ajax = jex.createAjaxUtil("defect_insert_do");	// ȣ���� ������
		ajax.set("TASK_PACKAGE"	, "qcl" );					// [�ʼ�]���� package ȣ���� ������ ��Ű
		ajax.set("data"			, posdata );
		ajax.set("DEFECT_CNTS"	, conts );
			 						
		ajax.execute(function(dat) {
			var data = dat["_tran_res_data"][0];
			var result = data.RESULT;
			
			if(result == "1"){
				alert("�������߽��ϴ�.");
			}else{
				alert("��� �� ������ �߻� �Ǿ����ϴ�");
			}
			
		});
	} catch(e) {
		alert("���൵�� ������ �߻��Ͽ����ϴ�.");
	}finally{
		$('#cData').trigger('click');
	}
	//$("#jqGrid").jqGrid("clearGridData", true).trigger("reloadGrid");
	uf_loadProgState();
}


//����
function edit_submit(param,posdata){

	var conts	=	CKEDITOR.instances.DEFECT_CNTS.getData();	//�󼼼���
	try{
		// �����  
		var ajax = jex.createAjaxUtil("defect_update_do");	// ȣ���� ������
		ajax.set("TASK_PACKAGE"	, "qcl" );					// [�ʼ�]���� package ȣ���� ������ ��Ű
		ajax.set("data"			, posdata ); 
		ajax.set("DEFECT_CNTS"	, conts );
			 						
		ajax.execute(function(dat) {
			var data = dat["_tran_res_data"][0];
			var result = data.RESULT;
			if(result == "1"){
				alert("������ �Ϸ�Ǿ����ϴ�.");
			}else{
				alert("������ ������ �߻� �Ǿ����ϴ�");
			}
			
			
		});		
	} catch(e) {
		alert("������ ������ �߻��Ͽ����ϴ�.");
	}finally{
		$('#cData').trigger('click');
	}
	$("#jqGrid").jqGrid("clearGridData", true).trigger("reloadGrid");
	uf_loadProgState();
}


//����
function del_Submit(param,posdata){
	var dataFromTheRow = $('#jqGrid').jqGrid ('getRowData', posdata);  //row������ �������� posdata->rowid
	try{ 
		// �����  
		var ajax = jex.createAjaxUtil("defect_delete_do");	// ȣ���� ������
		ajax.set("TASK_PACKAGE"	, "qcl" );					// [�ʼ�]���� package ȣ���� ������ ��Ű
		ajax.set("data"			, dataFromTheRow ); 
			 						
		ajax.execute(function(dat) {
			var data = dat["_tran_res_data"][0];
			var result = data.flag;
			if(result == "1"){
				alert("���� �ǽ��ϴ�.");
			}else{
				alert("������ ������ �߻� �Ǿ����ϴ�");
			}
		});		
	} catch(e) {
		alert("������ ������ �߻��Ͽ����ϴ�.");
	}finally{
		$('#cData').trigger('click');
	}
	$("#jqGrid").jqGrid("clearGridData", true).trigger("reloadGrid");
	uf_loadProgState();
}



//DEFECT_CNTS custom 
function defect_cnts_custom(value, options){
	 nmVal = options.id;
	var parts = '<textarea name ="'+options.id+'" id="'+options.id+'" rows="30" cols="" wrap="soft"></textarea>';
	return $(parts)[0];
}




//TEST_ID custom
function test_id_custom(value, options){
	nmVal = options.id;
}


//�߿䵵 select��
function importance_custom(){
	
	return  "��:��;��:��;��:��";
}



var strtest="";
var strscen="";
var strcas ="";
//code�� ��� ��������
function getCode(code,test,scen,cas){
		var rCode;
		//strtest = $("select[name=TEST_ID option:selected]").val();
		//strscen = $("select[name=SCENARIO_ID]").val();
		//strcas = $("select[name=CASE_ID]").val();

		
		try{
			var ajax = jex.createAjaxUtil("defect_codelist_do");	// ȣ���� ������
			ajax.setAsync(false);									//����ȭ
			ajax.set("TASK_PACKAGE"	, "qcl" );						// [�ʼ�]���� package ȣ���� ������ ��Ű
			ajax.set("CODE",code);
			
			if("2"==code && strtest){							//scenario_id
				ajax.set("TEST_ID",strtest);
			}else if("3"==code){					//case_id
				ajax.set("TEST_ID",strtest);
				ajax.set("SCENARIO_ID",strscen);
			}else if("4"==code){					//step_id
				ajax.set("TEST_ID",strtest);
				ajax.set("SCENARIO_ID",strscen);
				ajax.set("CASE_ID",strcas);
			}
			
			ajax.execute(function(dat) {
				var data = dat["_tran_res_data"][0];
					if(""==data.result||null==data.result || undefined==data.result){
						rCode=":�����Ͱ� �����ϴ�.";
					}else{
						rCode = eval(JSON.stringify(data.result)).toString().trim();
					}
			});
		}catch(e){
			alert("�����͸� �������� ���ϰ� �ֽ��ϴ�.");
		}
		return rCode;
}



//select �ó����� change �̺�Ʈ
function testChangdata(e){
	
	var strtest = $(e.target).val();
	//console.log(strtest);
	try{
		var ajax = jex.createAjaxUtil("defect_codelist_do");	// ȣ���� ������
		ajax.set("TASK_PACKAGE"	, "qcl" );						// [�ʼ�]���� package ȣ���� ������ ��Ű
		ajax.set("CODE",'2');
		ajax.set("TEST_ID",strtest);
		
		ajax.execute(function(dat) {
			var data = dat["_tran_res_data"][0];
				if(""==data.result2||null==data.result2 || undefined==data.result2){
					rCode=":�����Ͱ� �����ϴ�.";
				}else{
					$("select[name=SCENARIO_ID] option").remove();
					var result='';
					$("select[name=SCENARIO_ID]").append('<option value="' + data.result2[0].ID + '">' + data.result2[0].NM + '</option>');
					for(var idx=1; idx < data.result2.length; idx++) {
						var map = data.result2[idx];
						var str = map.NM;
						var strID = map.ID;
						
						//result += '<option value="' + value[idx] + '">' + str[idx] + '</option>';
						result += '<option value="' + strID + '">' + str + '</option>';
					}
					$("select[name=SCENARIO_ID]").append(result);
				}
		});
	}catch(e){
		alert("�����͸� �������� ���ϰ� �ֽ��ϴ�.");
	}

}

//select ���̽� change �̺�Ʈ
function scenarioChangdata(e){
	var strtest		= $("#TEST_ID").val();
	var strscenario = $(e.target).val();
	
	try{
		var ajax = jex.createAjaxUtil("defect_codelist_do");	// ȣ���� ������
		ajax.set("TASK_PACKAGE"	, "qcl" );						// [�ʼ�]���� package ȣ���� ������ ��Ű
		ajax.set("CODE",'3');
		ajax.set("TEST_ID",strtest);
		ajax.set("SCENARIO_ID",strscenario);
		
		ajax.execute(function(dat) {
			var data = dat["_tran_res_data"][0];
				if(""==data.result2||null==data.result2 || undefined==data.result2){
					rCode=":�����Ͱ� �����ϴ�.";
				}else{
					
					$("select[name=CASE_ID] option").remove();
					var result='';
					for(var idx=0; idx < data.result2.length; idx++) {
						var map = data.result2[idx];
						var str = map.NM;
						var strID = map.ID;
					
						result += '<option value="' + strID + '">' + str + '</option>';
					}	
					$("select[name=CASE_ID]").append(result);
				}
		});
	}catch(e){
		alert("�����͸� �������� ���ϰ� �ֽ��ϴ�.");
	}
	
	
}

//select ���� change �̺�Ʈ
function caseChangdata(e){
	var strtest		= $("#TEST_ID").val();
	var strscenario = $("#SCENARIO_ID").val();
	var strcase 	= $(e.target).val();
	
	try{
		var ajax = jex.createAjaxUtil("defect_codelist_do");	// ȣ���� ������
		ajax.set("TASK_PACKAGE"	, "qcl" );						// [�ʼ�]���� package ȣ���� ������ ��Ű
		ajax.set("CODE",'4');
		ajax.set("TEST_ID",strtest);
		ajax.set("SCENARIO_ID",strscenario);
		ajax.set("CASE_ID",strcase);
			
		ajax.execute(function(dat) {
			var data = dat["_tran_res_data"][0];
				if(""==data.result2||null==data.result2 || undefined==data.result2){
					rCode=":�����Ͱ� �����ϴ�.";
				}else{
					var result='';
					$("select[name=STEP_ID] option").remove();
					for(var idx=0; idx < data.result2.length; idx++) {
						var map = data.result2[idx];
						var str = map.NM;
						var strID = map.ID;
						
						//result += '<option value="' + value[idx] + '">' + str[idx] + '</option>';
						result += '<option value="' + strID + '">' + str + '</option>';
					}	
					$("select[name=STEP_ID]").append(result);
				}
				
		});
	}catch(e){
		alert("�����͸� �������� ���ϰ� �ֽ��ϴ�.");
	}
	
	
}




