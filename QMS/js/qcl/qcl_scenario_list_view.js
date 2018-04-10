/**
 * 
 */

//�ó����� ������ load
 function uf_loadProgState(testid){
		$("#scGrid").jqGrid("clearGridData", true).trigger("reloadGrid");
		var rowsData;
		try{
			// �����  
			var ajax = jex.createAjaxUtil("test_scenario_do");	// ȣ���� ������
			
			ajax.set("TASK_PACKAGE"	, "qcl" );					// [�ʼ�]���� package ȣ���� ������ ��Ű
			ajax.set("TEST_ID"	, testid);
			ajax.execute(function(dat) {
				try{
					rowsData = dat["_tran_res_data"][0];
					var result = rowsData.rows;
					for(var i=0;i<=result.length;i++){ //�׸��忡 ���õ����� �߰�
				       $("#scGrid").jqGrid('addRowData',i+1,result[i]);
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

 //���̽� ������ load
 function uf_loadCase(rowid){
		$("#caGrid").jqGrid("clearGridData", true).trigger("reloadGrid");
		var list = $("#scGrid").getRowData(rowid);
		var checkList =$("#scGrid").jqGrid('getGridParam', 'selarrrow'); 	//check
		var checkFlag;
		var testId=list.TEST_ID;
		var scenarioId=list.SCENARIO_ID;
		var rowsData;
		
		if(null != checkList && checkList !=undefined && checkList.length > 0){  
		  for(var j=0; j<=checkList.length; j++ ){     //check rowid array
			  if(checkList[j]==rowid){				   //������ rowid�� array�� �ִ� rowid��� ��
				  checkFlag= true;
				  break;
			  }
		  }
		}		
		try{
			// �����  
			var ajax = jex.createAjaxUtil("test_case_do");	// ȣ���� ������
			
			ajax.set("TASK_PACKAGE"	, "qcl" );					// [�ʼ�]���� package ȣ���� ������ ��Ű
			ajax.set("TEST_ID"		, testId);
			ajax.set("SCENARIO_ID"	,scenarioId);
			ajax.set("SNROW_ID"	,rowid);
			ajax.execute(function(dat) {
				try{
					rowsData = dat["_tran_res_data"][0];
					var result = rowsData.rows;
					 for(var i=0;i<=result.length;i++){ //�׸��忡 ���õ����� �߰�
				           $("#caGrid").jqGrid('addRowData',i+1,result[i]);
				           if(null != checkList && checkList !=undefined && checkList.length > 0 && checkFlag){
				        	   if(checkFlag){
						        	   $("#caGrid").jqGrid('setSelection',i,true);
					           }
				           }
					 }
					 
					 if(null != checkList && checkList !=undefined && checkList.length > 0 && checkFlag){ //��ü üũ
			      	   if(checkFlag){
			      		  $('#cb_caGrid').attr("checked",true);
				        }
				     }
				}catch(e){
					bizException(e, "error");
				}
				
			});
			
		} catch(e) {
			bizException(e, "error");
		}	
}
 
function selectcheckAll(aRowids,status){	 
			  
	/*	var  carowData =   $("#caGrid").jqGrid('getRowData', aRowids[0]);
		$("#scGrid").jqGrid('setSelection', carowData['SNROW_ID']);*/
	 
} 
 
//������
function exec(){
	 
		var arrsc = new Array();
		var arrca = new Array();
		var s = $("#scGrid").jqGrid('getGridParam','selarrrow');   //�ó�����rowid �迭
		var v = $("#caGrid").jqGrid('getGridParam','selarrrow');	//���̽� rowid	 �迭
		var srowCont = $("#scGrid").getGridParam("reccount");
		var crowCont = $("#caGrid").getGridParam("reccount");
		if(0 != s.length || 0!=v.length){
			if(undefined != s.length && null != s.length && 0 != s.length){ //�ó����� ��ü���ý�
				for(var i = 0; i< s.length; i++){
					var scRowData	=	$("#scGrid").jqGrid('getRowData', s[i]);
					arrsc.push(scRowData);
				}
			}
			if(undefined!=v.length && null!=v.length && 0!=v.length){
				var flag = true;
				if(undefined != s.length && null != s.length && 0 != s.length){
					for(var i = 0; i<s.length; i++){
						var RowData	=	$("#caGrid").jqGrid('getRowData', v[i]);
						var SNROW_ID = eval(RowData.SNROW_ID);
						if(s[i] == SNROW_ID){
							flag=false;
							break;
						}
							
					}
				}
				if(flag){
					for(var j = 0; j<v.length; j++){
							var caRowData	=	$("#caGrid").jqGrid('getRowData', v[j]);
							arrca.push(caRowData);
					}//end for
				}
			}
		}else{
			alert("���̽� ���û����� �����ϴ�.");
		}
			
		
		try{
			// �����  
			var ajax = jex.createAjaxUtil("test_execute_insert_do");	// ȣ���� ������
			
			ajax.set("TASK_PACKAGE"	, "qcl" );					// [�ʼ�]���� package ȣ���� ������ ��Ű
			ajax.set("SCDATA_LIST"	, arrsc );					// [�ʼ�]���� package ȣ���� ������ ��Ű
			ajax.set("CADATA_LIST"	, arrca );					// [�ʼ�]���� package ȣ���� ������ ��Ű
			ajax.execute(function(dat) {
				try{
					rowsData = dat["_tran_res_data"][0];
				    falg = rowsData.result;
				    if(falg==1){
				    	alert("�������� �Ϸ�Ǿ����ϴ�.");
				    }
				}catch(e){
					bizException(e, "error");
				}
				
			});
			
		} catch(e) {
			bizException(e, "error");
		}
 }

