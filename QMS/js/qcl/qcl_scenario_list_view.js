/**
 * 
 */

//시나리오 데이터 load
 function uf_loadProgState(testid){
		$("#scGrid").jqGrid("clearGridData", true).trigger("reloadGrid");
		var rowsData;
		try{
			// 공통부  
			var ajax = jex.createAjaxUtil("test_scenario_do");	// 호출할 페이지
			
			ajax.set("TASK_PACKAGE"	, "qcl" );					// [필수]업무 package 호출할 페이지 패키
			ajax.set("TEST_ID"	, testid);
			ajax.execute(function(dat) {
				try{
					rowsData = dat["_tran_res_data"][0];
					var result = rowsData.rows;
					for(var i=0;i<=result.length;i++){ //그리드에 로컬데이터 추가
				       $("#scGrid").jqGrid('addRowData',i+1,result[i]);
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

 //케이스 데이터 load
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
			  if(checkList[j]==rowid){				   //선택한 rowid와 array에 있는 rowid들과 비교
				  checkFlag= true;
				  break;
			  }
		  }
		}		
		try{
			// 공통부  
			var ajax = jex.createAjaxUtil("test_case_do");	// 호출할 페이지
			
			ajax.set("TASK_PACKAGE"	, "qcl" );					// [필수]업무 package 호출할 페이지 패키
			ajax.set("TEST_ID"		, testId);
			ajax.set("SCENARIO_ID"	,scenarioId);
			ajax.set("SNROW_ID"	,rowid);
			ajax.execute(function(dat) {
				try{
					rowsData = dat["_tran_res_data"][0];
					var result = rowsData.rows;
					 for(var i=0;i<=result.length;i++){ //그리드에 로컬데이터 추가
				           $("#caGrid").jqGrid('addRowData',i+1,result[i]);
				           if(null != checkList && checkList !=undefined && checkList.length > 0 && checkFlag){
				        	   if(checkFlag){
						        	   $("#caGrid").jqGrid('setSelection',i,true);
					           }
				           }
					 }
					 
					 if(null != checkList && checkList !=undefined && checkList.length > 0 && checkFlag){ //전체 체크
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
 
//실행등록
function exec(){
	 
		var arrsc = new Array();
		var arrca = new Array();
		var s = $("#scGrid").jqGrid('getGridParam','selarrrow');   //시나리오rowid 배열
		var v = $("#caGrid").jqGrid('getGridParam','selarrrow');	//케이스 rowid	 배열
		var srowCont = $("#scGrid").getGridParam("reccount");
		var crowCont = $("#caGrid").getGridParam("reccount");
		if(0 != s.length || 0!=v.length){
			if(undefined != s.length && null != s.length && 0 != s.length){ //시나리오 전체선택시
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
			alert("케이스 선택사항이 없습니다.");
		}
			
		
		try{
			// 공통부  
			var ajax = jex.createAjaxUtil("test_execute_insert_do");	// 호출할 페이지
			
			ajax.set("TASK_PACKAGE"	, "qcl" );					// [필수]업무 package 호출할 페이지 패키
			ajax.set("SCDATA_LIST"	, arrsc );					// [필수]업무 package 호출할 페이지 패키
			ajax.set("CADATA_LIST"	, arrca );					// [필수]업무 package 호출할 페이지 패키
			ajax.execute(function(dat) {
				try{
					rowsData = dat["_tran_res_data"][0];
				    falg = rowsData.result;
				    if(falg==1){
				    	alert("실행등록이 완료되었습니다.");
				    }
				}catch(e){
					bizException(e, "error");
				}
				
			});
			
		} catch(e) {
			bizException(e, "error");
		}
 }

