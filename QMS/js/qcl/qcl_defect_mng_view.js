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

//add 셋팅     
 function add_field(form){
	 CKEDITOR.replace('DEFECT_CNTS');
	 form.closest('div.ui-jqdialog').center();
	 
	 $('#tr_DEFECT_PROCESS_DATE').hide();
	 $('#tr_DEFECT_CHECK_DATE').hide();
	 $('#tr_DEFECT_STATUS').hide();
	 $('#DEFECT_START_DATE').attr("disabled",true);
	 $('#DEFECT_START_DATE').val(default_date);
	 
 }
 //add시 사용자아이디 넣어주고 수정불가
 function add_custom_value(id){
	 $("#TESTER_ID").val(id);
	 $('#TESTER_ID').attr("disabled",true);
 }
 
 
//edit 셋팅
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

//오늘날짜 가져오기
function default_date(){
	var currentTime = new Date();
	var month = parseInt(currentTime.getMonth() + 1);
	month = month <= 9 ? "0"+month : month;
	var day = currentTime.getDate();
	day = day <= 9 ? "0"+day : day;
	var year = currentTime.getFullYear();
	return year+"-"+month + "-"+day;
}


//gird load 시 결함리스트 데이터 가져오기
function uf_loadProgState(testid){
	//$("#jqGrid").jqGrid("clearGridData", true).trigger("reloadGrid");
	$("#jqGrid").jqGrid('clearGridData');
	      
	var rowsData;
	try{
		// 공통부  
		var ajax = jex.createAjaxUtil("defect_list_do");	// 호출할 페이지
		ajax.set("TASK_PACKAGE"	, "qcl" );					// [필수]업무 package 호출할 페이지 패키
		if(null!=testid && undefined!=testid){
			ajax.set("TEST_ID"	, testid);
		}
		ajax.execute(function(data) {
			try{
				rowsData = data["_tran_res_data"][0];
				var result = rowsData.rows;
				 for(var i=0;i<=result.length;i++){ //그리드에 로컬데이터 추가
			           $("#jqGrid").jqGrid('addRowData',i+1,result[i]);
			       }
				 
			}catch(e){
				alert("오류가 발생하였습니다.");
			}
			
		});
		
	} catch(e) {
		alert("실행도중 오류가 발생하였습니다.");
		}
}


    
//등록     
function add_Submit(param,posdata){
	var conts	=	CKEDITOR.instances.DEFECT_CNTS.getData();	//상세설명
	try{
		// 공통부  
		var ajax = jex.createAjaxUtil("defect_insert_do");	// 호출할 페이지
		ajax.set("TASK_PACKAGE"	, "qcl" );					// [필수]업무 package 호출할 페이지 패키
		ajax.set("data"			, posdata );
		ajax.set("DEFECT_CNTS"	, conts );
			 						
		ajax.execute(function(dat) {
			var data = dat["_tran_res_data"][0];
			var result = data.RESULT;
			
			if(result == "1"){
				alert("정상등록했습니다.");
			}else{
				alert("등록 중 오류가 발생 되었습니다");
			}
			
		});
	} catch(e) {
		alert("실행도중 오류가 발생하였습니다.");
	}finally{
		$('#cData').trigger('click');
	}
	//$("#jqGrid").jqGrid("clearGridData", true).trigger("reloadGrid");
	uf_loadProgState();
}


//수정
function edit_submit(param,posdata){

	var conts	=	CKEDITOR.instances.DEFECT_CNTS.getData();	//상세설명
	try{
		// 공통부  
		var ajax = jex.createAjaxUtil("defect_update_do");	// 호출할 페이지
		ajax.set("TASK_PACKAGE"	, "qcl" );					// [필수]업무 package 호출할 페이지 패키
		ajax.set("data"			, posdata ); 
		ajax.set("DEFECT_CNTS"	, conts );
			 						
		ajax.execute(function(dat) {
			var data = dat["_tran_res_data"][0];
			var result = data.RESULT;
			if(result == "1"){
				alert("수정이 완료되었습니다.");
			}else{
				alert("수정중 오류가 발생 되었습니다");
			}
			
			
		});		
	} catch(e) {
		alert("수정중 오류가 발생하였습니다.");
	}finally{
		$('#cData').trigger('click');
	}
	$("#jqGrid").jqGrid("clearGridData", true).trigger("reloadGrid");
	uf_loadProgState();
}


//삭제
function del_Submit(param,posdata){
	var dataFromTheRow = $('#jqGrid').jqGrid ('getRowData', posdata);  //row데이터 가져오기 posdata->rowid
	try{ 
		// 공통부  
		var ajax = jex.createAjaxUtil("defect_delete_do");	// 호출할 페이지
		ajax.set("TASK_PACKAGE"	, "qcl" );					// [필수]업무 package 호출할 페이지 패키
		ajax.set("data"			, dataFromTheRow ); 
			 						
		ajax.execute(function(dat) {
			var data = dat["_tran_res_data"][0];
			var result = data.flag;
			if(result == "1"){
				alert("삭제 되습니다.");
			}else{
				alert("삭제중 오류가 발생 되었습니다");
			}
		});		
	} catch(e) {
		alert("삭제중 오류가 발생하였습니다.");
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


//중요도 select값
function importance_custom(){
	
	return  "상:상;중:중;하:하";
}



var strtest="";
var strscen="";
var strcas ="";
//code성 목록 가져오기
function getCode(code,test,scen,cas){
		var rCode;
		//strtest = $("select[name=TEST_ID option:selected]").val();
		//strscen = $("select[name=SCENARIO_ID]").val();
		//strcas = $("select[name=CASE_ID]").val();

		
		try{
			var ajax = jex.createAjaxUtil("defect_codelist_do");	// 호출할 페이지
			ajax.setAsync(false);									//동기화
			ajax.set("TASK_PACKAGE"	, "qcl" );						// [필수]업무 package 호출할 페이지 패키
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
						rCode=":데이터가 없습니다.";
					}else{
						rCode = eval(JSON.stringify(data.result)).toString().trim();
					}
			});
		}catch(e){
			alert("데이터를 가져오지 못하고 있습니다.");
		}
		return rCode;
}



//select 시나리오 change 이벤트
function testChangdata(e){
	
	var strtest = $(e.target).val();
	//console.log(strtest);
	try{
		var ajax = jex.createAjaxUtil("defect_codelist_do");	// 호출할 페이지
		ajax.set("TASK_PACKAGE"	, "qcl" );						// [필수]업무 package 호출할 페이지 패키
		ajax.set("CODE",'2');
		ajax.set("TEST_ID",strtest);
		
		ajax.execute(function(dat) {
			var data = dat["_tran_res_data"][0];
				if(""==data.result2||null==data.result2 || undefined==data.result2){
					rCode=":데이터가 없습니다.";
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
		alert("데이터를 가져오지 못하고 있습니다.");
	}

}

//select 케이스 change 이벤트
function scenarioChangdata(e){
	var strtest		= $("#TEST_ID").val();
	var strscenario = $(e.target).val();
	
	try{
		var ajax = jex.createAjaxUtil("defect_codelist_do");	// 호출할 페이지
		ajax.set("TASK_PACKAGE"	, "qcl" );						// [필수]업무 package 호출할 페이지 패키
		ajax.set("CODE",'3');
		ajax.set("TEST_ID",strtest);
		ajax.set("SCENARIO_ID",strscenario);
		
		ajax.execute(function(dat) {
			var data = dat["_tran_res_data"][0];
				if(""==data.result2||null==data.result2 || undefined==data.result2){
					rCode=":데이터가 없습니다.";
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
		alert("데이터를 가져오지 못하고 있습니다.");
	}
	
	
}

//select 스텝 change 이벤트
function caseChangdata(e){
	var strtest		= $("#TEST_ID").val();
	var strscenario = $("#SCENARIO_ID").val();
	var strcase 	= $(e.target).val();
	
	try{
		var ajax = jex.createAjaxUtil("defect_codelist_do");	// 호출할 페이지
		ajax.set("TASK_PACKAGE"	, "qcl" );						// [필수]업무 package 호출할 페이지 패키
		ajax.set("CODE",'4');
		ajax.set("TEST_ID",strtest);
		ajax.set("SCENARIO_ID",strscenario);
		ajax.set("CASE_ID",strcase);
			
		ajax.execute(function(dat) {
			var data = dat["_tran_res_data"][0];
				if(""==data.result2||null==data.result2 || undefined==data.result2){
					rCode=":데이터가 없습니다.";
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
		alert("데이터를 가져오지 못하고 있습니다.");
	}
	
	
}




