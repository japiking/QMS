var getAcct_img = mobilePhotoData();
var acct_mgr = acctManager();

var acctMgr_table_list = [];		// 각뷰에 해당하는 테이블 아이디 리스트
var acctMgr_acct_list = [];			// 각 뷰에서 사용하는 계좌리스트
var acctMgr_acct_bankcd = null;	// 은행 코드

var acctMgr_acct_no_id = "";			// 테이블에서 사용하는 계좌번호 필드명을 기록
var acctMgr_call_func = null;			// 이미지 받은후 실행할 함수

var photo_action = 0;		// 0 : 계좌 관리, 1 : 내계좌 꾸미기, 2 : 전체계좌조회
var table_id = "";

var g_send_type = "";		// 계좌 이미지 요청 타입

var acct_lcnt = 0;

function acctManager () {
	return acct_manager = {
		acct_list 			: [],			// 계좌 리스트
		acct_kind_nm 	: "",			// 계좌 종류
		acct_acno		: "", 			// 계좌 번호
		acct_acno_nm	: "",			// 계좌 별명
		acct_blnc		: "",			// 계좌 잔액
		acct_crnc		: "", 			// 계좌 잔액 통화부호
		draw_layer		: "",			// 테이블이 그려질 레이어 이름 # 미포함)
		acct_mgr_jex_table : "",		// jexTable
		all_step			: [],			// 화면스탭
		selectIdx			: 0,			// 
		sel_image		: "",			// Image URL
		table_id			: "",			// table id
		req_img			: "",
		creditcard		: "N",			// 신용카드 여부
		
		set_table_id : function (dat) {
			this.table_id = dat;
		},
		
		set_creditcard : function (dat) {
			this.creditcard = dat;
		},
		
		set_list : function (dat) {
			// 리스트 셋
			this.acct_list = dat;
		},
		
		set_acct_kind_nm : function (dat) {
			// 계좌 종류	, 보통예금, 종합저축....
			this.acct_kind_nm = dat;
		},
		
		set_acct_acno_nm  : function (dat) {
			// 계좌별명
			this.acct_acno_nm = dat;
		},
		
		set_acct_acno : function (dat) {
			// 계좌번호
			this.acct_acno = dat;
		},
		
		set_acct_blnc : function (dat) {
			// 계좌 잔액
			this.acct_blnc = dat;
		},
		
		set_acct_crnc : function (dat) {
			// 계좌 잔액 통화 부호
			this.acct_crnc = dat;
		},
		
		set_draw_layer_id : function (dat) {
			// 테이블이 그려질 레이어
			this.draw_layer = "#" + dat;
		},
		
		
		draw_acct_mgr : function (dat) {
			str = "";
			
			if (dat == 1) {
				str += '<div class="round wrap">';
				
			}
		}
	};
}

// 뷰에 뿌려질 데이터	
function mobilePhotoData (layer) {
	return mPhotoData = {
			sel_seq	: 	0,				// 선택된 seq
			
			// 작업중인 테이블 이름
			set_table_id : function (dat) {
				table_id = dat;
			},
			
			// 사진 목록 요청
			requestPhotoList : function (dat, fileName, type, seq, photo_data, func) {
				/*
				 * type : list, camera, library, delete, complete, ibk_list
				 */
				try {
					// 데이터 전문
					var send_data		= {};
					var send_list		= [];

					if (type != "list" && type != "ibk_list")			// 리스트가 아닐경우엔 seq번호를 받는다
						this.sel_seq = seq;
					
					for (var i in dat) {
						var acct_map	= {};
						
						if (type == "list") acct_map["seq"]	= i;						// seq번호
						else acct_map	["seq"]					= seq;
						
						if (dat[i][fileName] == null || dat[i][fileName] == undefined || dat[i][fileName] == "") 
							acct_map["_filename"]			= "111111";
						else
							acct_map["_filename"]			= dat[i][fileName].replace(/-/g, "").trim();	// 계좌번호
	
						if (type == "ibk_list_complete" || type == "complete")  {
							acct_map["_photo_data"]	= photo_data.replace("data:image/jpeg;base64,", "");		// base64 Encoding String
						}
						else {
							acct_map["_photo_data"]	= "";
						}
						
						if (photo_action == 2) {			// 계좌 리스트 요청시 타행은 일반 이미지로 보여줌
							if (acctMgr_acct_bankcd != null) {
								acct_map["_bank_cd"] = dat[i][acctMgr_acct_bankcd];
							}
							else {
								acct_map["_bank_cd"] = "003";
							}
						}
						else {
							acct_map["_bank_cd"] = "003";
						}
						
						if (fileName == "cscr_no") 			// 신용카드여부 - 필드 여부로 구분
							acct_map["_isCard"] = "Y";
						else 
							acct_map["_isCard"] = "N";
						
						acct_map["_is_photo_sheet"]	= "false";				// sheet 유무?? 
						
						if (_isIphone() == false && _isAndroid() == false)
							acct_map["_is_exist"]				= "N";						// 이미지 유무 여부 Y/N
						else 
							acct_map["_is_exist"]				= "";
						
						send_list.push(acct_map);
					}
					
					// 은행 코드 필드는 초기화
					acctMgr_acct_bankcd = null;
					
					//전문데이터 만들기
					send_data["_action_code"] = "5900";
					send_data["_type"] = type;
					send_data["_data"] = send_list;
					
					this.sendReqData(JSON.stringify(send_data));
				} catch (e) {
					console.log("send acct Mgr Error : " + e);
				}
			},
			
			// 폰으로 전문 보내기
			sendReqData : function (dat) {
				// 보낼 데이터 
//				alert("req : " + dat);
				
				if (g_send_type == "") {
					_callAppAction(5888);
					acct_lcnt++;
				}
				
				if (_isIphone())
					window.location = 'iwebactionneoibk:' + dat;
				else if (_isAndroid())
					window.BrowserBridge.iwebactionneoibk(dat);
				else {
					console.log("모바일에서만 사용가능! 기본이미지 셋팅!");
					photo_all_acct_rec(JSON.parse(dat));
				}
			},
			
			// 폰에서 받은 데이터 처리
			recivedData : function (dat) {
//				alert("rec data : " + JSON.stringify(dat));
				var _type = dat["_type"];
				var _list =  dat["_data"];
				
				if (table_id == "#account_mgr_table") {			// 계좌관리 테이블일경우
					if (_type == "camera" || _type == "library") {
						var _img = "data:image/jpeg;base64," + _list[0]["_photo_data"];
						
						$("#acct_mgr_step04 img").attr("src", _img);
						
						acct_popup.show_step(3);
					}
					else if (_type == "ibk_list") {
						// ibk 배경 이미지
						var _str = '';
						
						for (var i in _list) {
							if (_list[i]["_is_exist"] == "Y") {
								var _img = "data:image/jpeg;base64," + _list[i]["_photo_data"];
								_str += '<li><img src="' + _img + '" alt="" /></li>';
							}
						}
						
						$("#ibk_default_list").html(_str);
						
						$("#ibk_default_list li").click(function (e) {
							// 이미지 파일을 선택했을때
							$("#ibk_default_list li").attr("class", "");
							$(this).attr("class", "on");
							
							$("#acct_mgr_step04 img").attr("src", $(this).find("img").attr("src"));
							acct_popup.show_step(3);		// 선택된 이미지를 보여줌.
						});
						
						acct_popup.show_step(2);
					}
					else if (_type == "list") {
						for (var i in _list) {
							if (_list[i]["_is_exist"] == "Y") {
								var _img = "data:image/jpeg;base64," + _list[i]["_photo_data"];
								$(table_id + " tr[data-rownum=" + i + "] #img_set_btn img").attr("src", _img);
							}
							else {
								// 이미지 없음.
								$(table_id + " tr[data-rownum=" + i + "] img").attr("src", "../../../img/acct_image/thumb_ibk.gif");
								
								/*
								if (_list[i]["_isCard"] != "Y") {
									$(table_id + " tr[data-rownum=" + i + "] img").attr("src", get_acct_image(_list[i]["_filename"]));
								}
								else {
									$(table_id + " tr[data-rownum=" + i + "] img").attr("src", "../../../img/acct_image/thumb_ibk.gif");
								}
								*/
							}
						}
						acct_manager.set_table_scroll();
					}
					else if (_type == "delete") {
						//삭제
						// 이미지 없음.
						
						$(table_id + " tr[data-rownum=" + i + "] img").attr("src", "../../../img/acct_image/thumb_ibk.gif");
						
						/*
						if (_list[i]["_isCard"] != "Y") {
							$(table_id + " tr[data-rownum=" + i + "] img").attr("src", get_acct_image(_list[i]["_filename"]));
						}
						else {
							$(table_id + " tr[data-rownum=" + i + "] img").attr("src", "../../../img/acct_image/thumb_ibk.gif");
						}
						*/
					}
					else if (_type == "ibk_list_complete" || _type == "complete") {
						// 완료
					}
				}
				else {			// 이밖의 테이블은 리스트만 처리 
					if (_type == "list") {
						for (var i in _list) {
							if (_list[i]["_is_exist"] == "Y") {
								var _img = "data:image/jpeg;base64," + _list[i]["_photo_data"];
								$(table_id + " tr[data-rownum=" + i + "] img").attr("src", _img);
							}
							else {
								// 	이미지 없음.
								
								$(table_id + " tr[data-rownum=" + i + "] img").attr("src", "../../../img/acct_image/thumb_ibk.gif");
								
								/*
								if (_list[i]["_isCard"] != "Y") {
									$(table_id + " tr[data-rownum=" + i + "] img").attr("src", get_acct_image(_list[i]["_filename"]));
								}
								else {
									$(table_id + " tr[data-rownum=" + i + "] img").attr("src", "../../../img/acct_image/thumb_ibk.gif");
								}
								*/
							}
						}
					}
				}
			}
	};
}

// 폰으로부터 photoData 요청 결과
function uf_photoData (dat) {
	if (g_send_type == "") {
		_callAppAction(5889);
		acct_lcnt--;
	}
	
	// 받은 데이터를 다시 넘겨주자
	try {
	//	alert("uf_photo : " + photo_action);
		dat = unescape(dat);
//		alert("uf_photo : " + dat);
		
		if (photo_action == 0) {			// 계좌관리
			mgr_rec_photoData(JSON.parse(dat));
		}
		else if (photo_action == 1) {		// 내계좌 꾸미기
			rec_photoData(JSON.parse(dat));
			
		}
		else if (photo_action == 2) 		// 계좌 리스트 사진 받기
			photo_all_acct_rec(JSON.parse(dat));
	} catch (e) {
		console.log("acct Mgr error : " + e);
	}
	
	g_send_type = "";
}


// 계좌 리스트 이미지 요청
//이미지 요청 
function request_acct_image (acct_no_name, func) {
	photo_action = 2;
	
	if(acctMgr_acct_list.length < 1 || acctMgr_acct_list.length > 30) {
//		alert("계좌리스트 데이타가 없음!");
		if (!(typeof func == null || func == undefined || func == "")) {
			func();
		}
		return;
	}
	
	if (acctMgr_table_list.length < 1) {
//		alert("계좌테이블 데이터가 없음!");
		if (!(typeof func == null || func == undefined || func == "")) {
			func();
		}
		return;
	}
	
	
	if (typeof func == null || func == undefined || func == "") {
		acctMgr_call_func = null;
	}else {
		acctMgr_call_func = func;
	}
	
	mobilePhotoData().requestPhotoList(acctMgr_acct_list, acct_no_name, "list", 0);
}

function photo_all_acct_rec (dat) {
	// 사진 데이터 받음.
	photo_action = 0;
	
	_callAppAction(5888);
	acct_lcnt++;
//	alert("uf photo : " + JSON.stringify(dat));
	try {
		var _list =  dat["_data"];
		for (var t_idx in acctMgr_table_list) {
			var _table = acctMgr_table_list[t_idx];
			
			for (var i in _list) {
				var _exist = _list[i]["_is_exist"];
				if (_exist == "Y") {
					var _img = "data:image/jpeg;base64," + _list[i]["_photo_data"];
					
					for (var j = 0; j < $(_table).find("tr").length; j++) {
						if ( _list[i]["_isCard"] == "Y") {
							if ($(_table).find("tr").eq(j).find(acctMgr_acct_no_id).val().replace(/-/g, "").trim() == _list[i]["_filename"].trim()) {
								$(_table).find("tr").eq(j).find("img").attr("src", _img);
							continue;
							}
						}
						else {
							if ($(_table).find("tr").eq(j).find(acctMgr_acct_no_id).text().replace(/-/g, "").trim() == _list[i]["_filename"].trim()) {
								$(_table).find("tr").eq(j).find("img").attr("src", _img);
								continue;
							}
						}
					}
				}
				// 2013.09.24
				// 계좌 이미지가 없을경우....
				/*
				else {
					for (var j = 0; j < $(_table).find("tr").length; j++) {
						if ( _list[i]["_isCard"] == "Y") {
							if ($(_table).find("tr").eq(j).find(acctMgr_acct_no_id).val().replace(/-/g, "").trim() == _list[i]["_filename"].trim()) {
								$(_table).find("tr").eq(j).find("img").attr("src", "../../../img/acct_image/img_sample.png");
								continue;
							}
						}
						else {
							if ($(_table).find("tr").eq(j).find(acctMgr_acct_no_id).text().replace(/-/g, "").trim() == _list[i]["_filename"].trim()) {
								var _bank_cd = _list[i]["_bank_cd"];
								if (_bank_cd == "003" || _bank_cd == "03") {
									$(_table).find("tr").eq(j).find("img").attr("src", get_acct_image(_list[i]["_filename"]));
									continue;
								}
								else {
									$(_table).find("tr").eq(j).find("img").attr("src", "../../../img/acct_image/img_sample.png");
									continue;
								}
							}
						}
					}
				}
				*/
				
			}
		}
	}
	catch (e) {
		console.log("Acct List image set Error" + e);
	}
	
	_callAppAction(5889);
	acct_lcnt--;
	
	if (acct_lcnt > 0) {
		for (var i = 0; i < acct_lcnt; i++) {
			_callAppAction(5889);
		}
	}
	
	if (acctMgr_call_func != null && acctMgr_call_func != undefined && acctMgr_call_func != ""){
		acctMgr_call_func();
		acctMgr_call_func = null;
	}
	
}

/*
 * Image Utility
*/

//계좌별 기본이미지 설정
function get_acct_image (acct) {
	if (acct == undefined || acct == null)
		return;
	var url = "22237";
	var _cd = acct.substr(9, 2);
	
	if (_cd == "01" || _cd == "02" || _cd == "03" || _cd == "04" || _cd == "06" || _cd == "07") {
		// 입출식 통장
		url = "22237";
	}
	else if (_cd == "14" || _cd == "15" || _cd =="75") {
		// 적립식 통장
		url = "22243";
	}
	else if (_cd == "13" || _cd == "11") {
		// 거치식 통장
		url = "22250";
	}
	else if (_cd == "96") {
		//수익증권/뮤추얼 펀드 종합통장
		url = "22361";
	}
	else if (_cd == "32" || _cd == "34") {
		// 대출 통장
		url = "63354";
	}
	else if (_cd == "21") {
		// 중소기업금융채권 등록필증(통장)
		url = "21077";
	}
	else if (_cd == "56") {
		// 기은 외화통장
		url = "22221";
	}
	else if (_cd == "94") {
		// 퇴직연금신탁통장
		url = "22533";
	}
	else if (_cd == 63) {
		//수탁어음거래명세장
		url = "70348";
	}
	else {
		// 그밖의 통장 이미지
	}
	
	return "../../../img/acct_image/" + url + "_02.png";
}


// 이미지가 삭제된것인지를 체크!
function check_delete_img (dat) {
	if (dat.match("data:image/jpeg;base64,") == false) {
		return true;
	}
	return false;
}

/*
 * =========================================
 * 
 */
// 리스트 내의 정보
mgr_acct_no = "";		// 계좌번호 필드
mgr_acct_nm = "";
mgr_acct_prdc = "";
mgr_acct_blnc = "";
mgr_acct_list = [];
//---------------------

mgr_isCard = "N";
mgr_tbl = "";

var mgr_acct_out_1N0012_map = {};
var mgr_old_acct_nm = "";
//계좌관리 함수
function uf_in_acct_1N0012_S0 ($jq, dat) {
	$jq.attr("data-jx-svc-iscall", "true");
	
	var acct_nm = $jq.parent().parent().parent().find("#" + mgr_acct_nm).val();

	if (stringLengthCheck(acct_nm, 15) == false) {
		alert("최대 한글 7자, 영문/숫자 및 특수문자는 15자까지 입력이 가능합니다.");
		var index = Number($jq.parents("tr").attr("data-rownum"));
		$jq.parents("td").find("input").val(mgr_acct_list[index][mgr_acct_nm]);
		$jq.attr("data-jx-svc-iscall", "false");
		return;
	}

	mgr_old_acct_nm = dat[mgr_acct_nm];

	sendData = {};
	mgr_acct_out_1N0012_map = {};
		
	dat["acnt_nm"] = $jq.parent().parent().parent().find("#" + mgr_acct_nm).val();

	var drot_acnt_dscd = "1";
	var gubun = dat[mgr_acct_no].substring(9, 11);
	
	if (mgr_isCard == "Y") {
		drot_acnt_dscd = "5";
	}
	else if (gubun == "56") {
		drot_acnt_dscd = "3";
	}
	else if (gubun == "32" || gubun == "34") {
		drot_acnt_dscd = "4";
	}
		
	sendData["acno"] = dat[mgr_acct_no];					// 계좌번호
	sendData["acnt_nm"] = acct_nm;						// 계좌별명
	sendData["drot_acnt_dscd"] = drot_acnt_dscd;		// 계좌구분		(1:일반계좌, 2:증권계좌, 3:외화계좌, 4:대출계좌, 5:신용카드)
	
	$jq.attr("data-jx-svc-source-direct", JSON.stringify(sendData));
}

function uf_out_acct_1N0012_S0 ($jq, dat) {
	var res = dat["_tran_res_data"][0]["_BeginLoop_list"][0];
	
	var index = Number($jq.parent().parent().parent().attr("data-rownum"));
	var msg = "";
	
	if (res["acnt_nm"].trim() == mgr_old_acct_nm.trim()) {
		msg = "변경사항이 저장되었습니다.";
	}
	else if (res["acnt_nm"].trim() == "") {
		msg = "별명이 삭제되었습니다.";
	}
	else {
		msg = "별명이 " + res["acnt_nm"] + "(으)로 변경되었습니다.";
	}
	
	mgr_acct_list[index][mgr_acct_nm] = res["acnt_nm"];
	
	mgr_acct_out_1N0012_map["msg"] = msg;
	mgr_acct_out_1N0012_map["index"] = index;
	mgr_acct_out_1N0012_map["acnt_nm"] = res["acnt_nm"];
	
	return dat;
}

function uf_acct_execute_1N0012_S0 () {
	var index = mgr_acct_out_1N0012_map["index"];
	var _src = $("#tbl_acct_mgr tbody tr").eq(index).find("img").attr("src");
	
	if (_src.match(/data:image\/jpeg;base64,/gi)) {
		mobilePhotoData().requestPhotoList([mgr_acct_list[index]], mgr_acct_no, "ibk_list_complete", index, _src);
	}
	else {
		mobilePhotoData().requestPhotoList([mgr_acct_list[index]], mgr_acct_no, "delete", index);
	}
	
	// 이미지 저장후 실제 테이블 셋팅
	$(mgr_tbl + " tbody tr").eq(index).find("img").attr("src", $("#tbl_acct_mgr tbody tr").eq(index).find("img").attr("src"));
	$(mgr_tbl + " tbody tr").eq(index).find("#" + mgr_acct_nm).text(mgr_acct_out_1N0012_map["acnt_nm"]);
	
	// 별명이 없을때 처리
	if ($(mgr_tbl + " tbody tr").eq(index).find("#" + mgr_acct_nm).text().trim() == "") {
		$(mgr_tbl + " tbody tr").eq(index).find("#" + mgr_acct_nm).css("display", "none");
		$(mgr_tbl + " tbody tr").eq(index).find("#" + mgr_acct_prdc).css("display", "");
	}
	else {
		$(mgr_tbl + " tbody tr").eq(index).find("#" + mgr_acct_nm).css("display", "");
		$(mgr_tbl + " tbody tr").eq(index).find("#" + mgr_acct_prdc).css("display", "none");
	}
	
	// 리스트 테이블에 데이터 저장
	var trData = $(mgr_tbl + " tr").eq(index).getAll();
	trData[mgr_acct_nm] == mgr_acct_out_1N0012_map["acnt_nm"];
	$(mgr_tbl + " tr").eq(index).setAll(trData);
	
	alert(mgr_acct_out_1N0012_map["msg"]);
}

/*
function uf_btn_mgr_acct_img_setting() {
	// 이미지 설정
	select_index = Number($jq.parent().parent().parent().attr("data-rownum"));
	var send_data = {};
	var btn_list = [];
	
	var _tmap = {};

	_tmap["title"] = "취소";
	_tmap["action"] = "0";
	btn_list.push(_tmap);
	
	btn_list.push({"title":"취소", "action":"0"});
	btn_list.push({"title":"기본이미지", "action":"1"});
	btn_list.push({"title":"사진앨범", "action":"2"});
	btn_list.push({"title":"카메라", "action":"3"});
	
	send_data["_action_code"] = "5999";
	send_data["_data"] = btn_list;
	
	var jString = JSON.stringify(send_data);
	
	if (_isIphone())
		window.location = 'iwebactionneoibk:' + jString;
	else if (_isAndroid())
		window.BrowserBridge.iwebactionneoibk(jString);
	else {
		console.log("모바일에서만 사용가능! 기본이미지 셋팅!");
	}
}
*/

function uf_btn_mgr_acct_reset($jq, dat) {
	$jq.parent().parent().parent().find("#" + mgr_acct_nm).val("");
	
	// 초기화 버튼 누를경우 기본 샘플이미지로 지정
	// 2013-09-24
	$jq.parent().parent().parent().find("img").attr("src", "../../../img/phone/temp_img_sample.png");
	
	
	/*
	 * 수정전
	 * 
	if (mgr_isCard == "Y") {
		$jq.parent().parent().parent().find("img").attr("src", "../../../img/phone/temp_img_sample.png");
	}
	else {
		$jq.parent().parent().parent().find("img").attr("src", get_acct_image(dat[mgr_acct_no].replace(/-/g, "")));
	}
	*/
}

/*
 * 이미지 action Sheet
 */
var mgr_select_index = 0;
function uf_btn_mgr_acct_img_setting ($jq, dat) {
//	alert("callActionSheet");
	// 이미지 설정
	mgr_select_index = Number($jq.parents("tr").attr("data-rownum"));
	var send_data = {};
	var btn_list = [];
	photo_action = 0;
	
	btn_list.push({"title":"취소", "action":"0"});
	btn_list.push({"title":"기본이미지", "action":"1"});
	btn_list.push({"title":"사진앨범", "action":"2"});
	btn_list.push({"title":"카메라", "action":"3"});
	
	send_data["_action_code"] = "5999";
	send_data["_data"] = btn_list;
	
	var jString = JSON.stringify(send_data);
	
	if (_isIphone())
		window.location = 'iwebactionneoibk:' + jString;
	else if (_isAndroid())
		window.BrowserBridge.iwebactionneoibk(jString);
	else {
		console.log("모바일에서만 사용가능! 기본이미지 셋팅!");
	}
}

function uf_select_action_sheet (dat) {
//	alert("uf_select_action_sheet : " + dat);
	var action = "";
	if (dat == "1") {
		// 기본이미지
		action = "ibk_list";
	}
	else if (dat == "2") {
		// 앨범
		action = "library";
	} 
	else if (dat == "3") {
		// 카메라
		action = "camera";
	}
	else {
		return;
	}
	
	g_send_type = action;
	
	if (photo_action == 1) {
		mobilePhotoData().requestPhotoList([all_acct_list[select_index]], "acct_no", action, select_index);
	}
	else {
		mobilePhotoData().requestPhotoList([mgr_acct_list[mgr_select_index]], mgr_acct_no, action, mgr_select_index);
	}
}
 
// 받은 데이터 처리
function mgr_rec_photoData (dat) {
//	alert(JSON.stringify(dat));
	var _list = dat["_data"];
	var _type = dat["_type"];
//	alert(_type);
	
	if (_type == "library" || _type == "camera") {		// 라이브러리나 카메라에서 넘오면 바로 셋팅
		for (var i in _list) {
			var _img = "data:image/jpeg;base64," + _list[i]["_photo_data"];
//			var _seq = 	_list[i]["seq"];
			
			if (_list[i]["_is_exist"] == "Y" && _list[i]["_photo_data"].trim().length > 0) {
				mgr_step3_setImage(_img);
			}
		}
	}
	
	else if (_type == "ibk_list") {
		var _str = "";
		
		for (var i in _list) {
			if (_list[i]["_is_exist"] == "Y") {
				var _img = "data:image/jpeg;base64," + _list[i]["_photo_data"];
				_str += '<li class="round"><img src="' + _img + '" alt="통장이미지' + i +'" style="width:242px" /></li>';
			}
		}
		$("#layer_acct_mgr_step12").html(_str);
		// 이벤트 바인딩
		$("#layer_acct_mgr_step12 li").click(function () {
			$("#layer_acct_mgr_step12 li").removeClass("on");
			$(this).addClass("on");
			
			mgr_step3_setImage($(this).find("img").attr("src"));
		});
		
		uf_move_step(12);
	}
}

function mgr_step3_setImage (dat) {
	// 받은 이미지 저장전 확인
	$("#layer_acct_mgr_step13").find("img").attr("src", dat);
	uf_move_step(13);
}

function mgr_insert_acctImg(img, index) {
	// 테이블에 적용
	$("#tbl_acct_mgr tr").eq(index).find("img").attr("src", img);
	uf_back();
}

function uf_acct_btn_apply () {
	mgr_insert_acctImg($("#layer_acct_mgr_step13 img").attr("src"), mgr_select_index);
}
