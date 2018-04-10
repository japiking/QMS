/**
 * 공통 팝업
 */

var _comPopup = function(){
	this.$errorPopupObj = $("#comErrorPopup");
	this.$alertPopupObj = $("#comAlertPopup");
	this.$confirmPopupObj = $("#comConfirmPopup");
	this.$btnComErrorConfirm = $("#btnComErrorConfirm");
	this.$btnComAlertConfirm = $("#btnComAlertConfirm");
	this.$btnComConfirm = $("#btnComConfirm");
	this.isClickConfirm = undefined;				//confirm 팝업에서 취소,확인버튼 클릭여부 - 취소:false,확인:true 
	this.initWindowHeight = $(window).height();
	this.isWebViewExitForError = false;				//Error팝업에서 확인버튼 눌렀을때 webViewExit호출해줄지의 여부
	/* 에러 팝업 태그 */
	this.getErrorTag = function(){
		
		var errorTag = 
			"<div id='comErrorPopup' class=\"error con_sp\" style='display:none'>"
				+"<div class=\"errorguide\">"
					+"<p class=\"tit\">이용에 불편을 드려 죄송합니다.</p>"	
					+"<p>오류 내용을 확인하시고 다시 이용해 주세요.</p>"	
				+"</div>"
				+"<div class=\"errorCodeBox\">"
					+"<div class=\"errormsg\" id='comErrorMsg'>" 
					+" </div>"
					+"<div class=\"errorcode\" id='comErrorCode'> 오류코드 :"
					+" </div>"
				+"</div>"
				+"<div class=\"btn_center\">"
					+"<button type=\"button\" class=\"btn btn_type1\" id='btnComErrorConfirm'>확 인</button>"
				+"</div>"
			+"</div>";
		return errorTag;
	},
	/* alert 팝업 태그 */
	this.getAlertTag = function(){
		var alertTag = 
			"<div class='popup'>"
				+"<div id='comAlertPopup' class='layerpop_wrap' style='display:none;top:40%;' >"
					+"<div class='layerpop_header'>"
						+"<h1 class='tit' id='comAlertTitle'>안내</h1>"
					+"</div>"
					+"<div class='layerpop_contents'>"
						+"<p class='con' id='comAlertMsg'></p>"
					+"</div>"
					+"<div class='layerpop_footer'>"
						+"<div class='btn_ct' >"
							+"<a class='btn_blue' id='btnComAlertConfirm'>확 인</a>"
						+"</div>"
					+"</div>"
				+"</div>"
			+"</div>";
		return alertTag;
	},
	/* confirm 팝업 태그 */
	this.getConfirmTag = function(){
		var confirmTag = 
			"<div class='popup'>"
				+"<div id='comConfirmPopup' class='layerpop_wrap' style='display:none;top:40%'>"
					+"<div class='layerpop_header'>"
						+"<h1 class='tit' id='comConfirmTitle'>안내</h1>"
					+"</div>"
					+"<div class='layerpop_contents'>"
						+"<p class='con' id='comConfirmMsg'></p>"
					+"</div>"
					+"<div class='layerpop_footer'>"
						+"<div class='btn_ct' >"
							+"<a class='btn_orange first' id='btnComConfirmCancel'>취소</a>"
							+"<a class='btn_blue' id='btnComConfirm'>확 인</a>"
						+"</div>"
					+"</div>"
				+"</div>"	
			+"</div>";
		
		return confirmTag;
	},
	/* Popup 보여줌 */
	this.show = function($popupObj){
		//alert("show");
		$popupObj.show();
		//position 가온데
		this.resetPositionPopup($popupObj);
	},
	/* Popup 숨김 */
	this.hide = function($popupObj){
		$popupObj.hide();
	},
	
	/* uf_back에서 사용하는 error popup 닫기 함수 */
	this.hideErrorPopupForBack = function(){
		if(0 != ComPopup.$errorPopupObj.size()){
			if("none" != ComPopup.$errorPopupObj.css("display")){
				ComPopup.$errorPopupObj.hide();
				//ComPopup.hideErrorPopup(uf_errorCallback);
			}
		}
	},
	/* ERROR 팝업*/
	this.showErrorPopupForData = function(data){
		alert(JSON.stringify(data));
		
		var code = data["_tran_res_data"][0]["ERROR_CODE"];
		var msg  = data["_tran_res_data"][0]["ERROR_MESSAGE"];
		this.showErrorPopup(code,msg);
	},
	/* ERROR 팝업 */
	this.showErrorPopup = function( code, msg , callback){
		try {
			alert(msg);
			return false;
			// MobUtil.moveScrollTop();
		} catch(e) {bizException(e, "showErrorPopup");}
	},
	/* ALERT 팝업 */
	this.showAlertPopup = function(msg, title, callback){
		try {
			
			if(typeof _thisSForm_ExeBtn != "undefined") _thisSForm_ExeBtn = true;	//W클릭 방지 2013.05.10 [secretForm이체성거래 Button able]
			
			var _this = this;
			
			if( undefined == title || null == title || "" == title) {
				title = "안내";
			}
			
			if( 0 == this.$alertPopupObj.size()){
				$("#wrap").prepend(this.getAlertTag());
				this.$alertPopupObj = $("#comAlertPopup");
				this.$btnComAlertConfirm = $("#btnComAlertConfirm");
			}
			
			//position 가온데 (위치계산)
			//this.resetPositionPopup(this.$alertPopupObj);
			
			this.$alertPopupObj.find("#comAlertTitle").html(title);
			this.$alertPopupObj.find("#comAlertMsg").html(msg);
			
			//alert 팝업의 확인버튼 클릭
			this.$alertPopupObj.find("#btnComAlertConfirm").unbind("click");
			this.$alertPopupObj.find("#btnComAlertConfirm").bind("click",function(){
				_this.hideAlertPopup(callback);
			});
			
		}catch(e) {bizException(e, "showAlertPopUp");}
	},
	/* confirm 팝업 */
	this.showConfirmPopup = function(msg, title, callback, err_callback, dvcd){
		try {
			var _this = this;
			this.isClickConfirm = undefined;
			if( undefined == title || null == title || "" == title) {
				title = "안내";
			}

			if( 0 == this.$confirmPopupObj.size()){
				$("#wrap").prepend(this.getConfirmTag());
				this.$confirmPopupObj = $("#comConfirmPopup");
				this.$btnComConfirm = $("#btnComConfirm");
			}
			
			//position 가온데 (위치계산)
			//this.resetPositionPopup(this.$confirmPopupObj);
						
			this.$confirmPopupObj.find("#comConfirmTitle").html(title);
			this.$confirmPopupObj.find("#comConfirmMsg").html(msg);
			
			this.$confirmPopupObj.find("#btnComConfirmCancel").unbind("click");
			this.$confirmPopupObj.find("#btnComConfirmCancel").bind("click",function(){
				_this.isClickConfirm = false;
				_this.hideBackground();
				_this.hideConfirmPopup(err_callback, dvcd);
				//_this.hide(_this.$confirmPopupObj);
			});
			
			this.$confirmPopupObj.find("#btnComConfirm").unbind("click");
			this.$confirmPopupObj.find("#btnComConfirm").bind("click",function(){
				_this.isClickConfirm = true;
				_this.hideBackground();
				_this.hideConfirmPopup(callback, dvcd);
			});
			
		}catch(e) {bizException(e, "showConfirmPopup");}
	},
	/* 에러팝업 확인버튼 */
	/* ************************************************************************
	 * 	 Title : 이체성 거래중 에러가 발생시 페이지 이동 처리부분
	 * 	- 현재스텝 유지 : OTP 1~9회오류 / 계좌비밀번호 1~2회오류 / 이용자비밀번호 1~2회 오류
	 * 	- 첫페이지 이동 : OTP 10회 오류 / 이용자비밀번호 3회 오류 / 계좌비밀번호 3회 오류
	 *  - OTP시간 재설정 오류 발생시 : OTP시간재설정 화면으로 이동 처리
	 **************************************************************************/
	this.hideErrorPopup = function(errCallBackFunc){
		
		var code = $.trim($("#comErrorCode").text());
		code = code.replace(/[^0-9a-zA-Z]/g,"");
		
		// webVeiw 나가도록 설정된 경우
		/*
		 * 9999	- 세션이 종료되었습니다.
		 * 9993 - 비정상적인 접근입니다!\n확인후 다시 거래 하여 주시길 바랍니다.
		 * 702  - 중복로그인되었습니다.
		 */
		if(code == "9999" || code == "9993" || code == "702" || code == "100" ||
		   code == "00009999" || code == "00009993" || code == "00000702"){
			_callAppAction(ActionCode.GO_HOME_AFTER_LOGOUT, "false");	//로그아웃 후 홈으로 이동
		}
		else if(this.isErrorCodeForExit()){
//			alert("_callAppAction:"+ActionCode.GO_BACK_VIEW);
			_webViewExit();
		} else {
			
			
			this.hide(this.$errorPopupObj);
			if( (code == "ECBKEBK01112") || (code == "ECBKEBK01199") ||	// OTP입력오류
				(code == "ECBKEBK01113") || (code == "ECBKEBK01200") ||
				(code == "ECBKEBK01114") || (code == "ECBKEBK01201") ||
				(code == "ECBKEBK01183") || (code == "ECBKEBK01202") ||
				(code == "ECBKEBK01203") ||
				(code == "ECBKEBK01185") || (code == "ECBKEBK01204") ||
				(code == "ECBKEBK01186") || (code == "ECBKEBK01205") ||
				(code == "ECBKEBK01187") || (code == "ECBKEBK01188") ||
				(code == "ECBKEBK01115") ||
				(code == "ECBKEBK00090") || (code == "ECBKEBK00091")){		// 이용자비밀번호 1~2회 오류
				
//				(code == "823494") || (code == "823581") ||	// OTP입력오류
//				(code == "823495") || (code == "823582") ||
//				(code == "823496") || (code == "823583") ||
//				(code == "823565") || (code == "823584") ||
//				(code == "823585") ||
//				(code == "823567") || (code == "823586") ||
//				(code == "823568") || (code == "823587") ||
//				(code == "823569") || (code == "823570") ||
//				(code == "823497") ||
//				(code == "821088") || (code == "821089")
				
				this.isOpenTab;
				ComStep.showStep(this.preStep);
			}
			// 2013.12.30 계좌비밀오류시만 리로드  821115, 821116 - 계좌비밀번호 1~2회 오류
			else if( code == "ECBKEBK00120" || code == "ECBKEBK00121"){	
				var pathName = $(location).attr("pathname");
				if(-1 == pathName.indexOf("/jsp/view/fsc/fsc050101.jsp")){	
					location.reload(true);
				}else{
					/* 원뱅킹 : 즉시이체만 이전 STEP이동 
					 * 앱통장 : reload시 약관페이지로 이동하는 것이 결함사유로 지적되어 이전 STEP으로 이동
					 */ 
					$('[com-step-id="step1"]').find("#drot_acnt_pwd").val("");
					ComStep.showStep(this.preStep);
//					ComStep.showPreStep();
				}
			}
			/*
			 * WEB008 - 공휴일은 예약이체일로 지정할 수 없습니다.
			 * WEB009 - 예약이체는 현재시간에서 1시간 이후부터 가능합니다.
			 */
			else if(code == "WEB008" || code == "WEB009"){
				// 링크 TODO 
				//MobUtil.menuLink("../trn/", "trn010102.html",{"iMenuId":"AIB_MENU2_1","aMenuId":"AIB_MENU2_1"});
			}else{
				//callback함수 호출
				
				if(undefined != errCallBackFunc && null != errCallBackFunc ){
					eval(errCallBackFunc)();
				}else{
					//이전 step으로 이동
					ComStep.showStep(this.preStep);
				}
				
				/*if("function" == typeof(errCallBackFunc)){ //콜백함수: 에러팝업창 뜬후 [확인]이나 [백]버튼 클릭시 그후의 작업기술..
					errCallBackFunc.apply();
				}else{
					//이전 step으로 이동
					ComStep.showStep(this.preStep);
				}*/
			}
		}
	},
	/**
	 * 현재 에러팝업의 에러코드가 webViewExit 처리하는 에러인지 여부 반환
	 */
	
	this.isErrorCodeForExit = function(){
		var code = $.trim($("#comErrorCode").text());
		code = code.replace(/[^0-9a-zA-Z]/g,"");
		var errorCodeForExit = false;
		// webVeiw 나가도록 설정된 경우
		if(this.isWebViewExitForError){
			this.isWebViewExitForError = false;
			errorCodeForExit = true;
		}
		/* 9991	  - 일자전환중입니다.
		 * 100    - 장시간 사용하지 않아 접속이 종료되었습니다. 다시 로그인하여 주시기 바랍니다. 
		 * BIZ992 - 거래응답시간 초과입니다. 확인후 다시 거래하시기 바랍니다.
		 * BC0219 - BC카드 미발급
		 * BC0067 - 신용카드 포인트조회 거래시간처리 경과
		 * FRS99999 - 시스템오류
		 * 00C021 - 데이터가 존재하지 않습니다. 문의전화 : 신탁사업단 02-6322-5394/5142/5329
		 * 822010 - 씨크릿카드 3회이상 오류입니다.
		 * SE0001 - 보안계좌로 등록할 계좌가 없습니다.
		 * 
		 * 금융상품
		 * AR832 , AR833 : 이미 가입하신 회원입니다.
		 * 850118        : 미개시 상태입니다.
		 * 150008		 : 대상계좌가 없거나 스마트 FUN정기적금 또는 정기예금 미가입 고객입니다.
		 * 910001	: 요청한 정보를 찾지 못했습니다．확인후 다시거래하세요
		 * 
		 * 821119  - 계좌비밀번호 3회오류
		 * 823571  - OTP 10회오류
		 * 821032  - 보안카드 3회오류
		 * 821023  - 출금계좌오류횟수 초과입니다. 신분증 지참후 가까운 저희은행 영업점에 방문하셔서 계좌비밀번호 오류해제거래를 요청하신 후 사용하십시오.
		 * 824324  - OTP 10회이상오류
		 * 
		 * BC0702  - 해지예정등록된 회원이므로 해지처리가 불가능합니다. 부득히 당일 해지를 원하실경우에는 가까운영업점에 방문해주십시요.
		 * MOB001 	- 죄송합니다. 고객님께서 선택하신 서비스는 현재 사용하실 수 없는 서비스입니다. 서비스이용 가능시간에 이용하여 주십시오.
		 * 828140  - 이미  스마트  뱅킹에  가입되어  있습니다．
		 * 823590 - OTP 10회오류
		 * [com_CHECK_TRANERROR.jsp]이체성 거래의 보안매체및 이체비밀번호 관련 에러 처리
		 * W98000~W98003,W98017,W00095,W98016,W98018,W98007,W98008
		 * W00141 - 전자서명에러
		 *
		 *
		 */
		else if
		(	   code =="9991" 			|| code =="BC0219" 			|| code =="100" 			|| code=="BC0067" 
			|| code == "BIZ992" 		|| code == "FRS99999" 		|| code == "ECBKEBK00469"	
			|| code == "SE0001"			|| code == "ECBKEBK00124" 	|| code == "ECBKEBK01439"
			|| code =="ECBKEBK01189"	|| code =="ECBKEBK00034"	|| code == "ECBKEBK00025" 	|| code == "BC0702"
			|| code =="AR832" 			|| code =="AR833" 			|| code =="ECBKEXT00775" 
			|| code =="ECBKARR03333"  	|| code == "MOB001"
			|| code=="ECBKEBK00222" 	|| code=="ECBKEBK01208"	
			|| code=="ECBKEBK01251"		|| code=="ECBKEBK00092" 	|| code=="ECBKEBK01685"
			|| code=="W98000" 			|| code=="W98001" 			|| code=="W98002"	
			|| code=="W98003"			|| code=="W98017" 			|| code=="W00095"
			|| code=="W98016" 			|| code=="W98018" 			|| code=="W98007" 	
			|| code=="W98008"			|| code == "W00141"
			//			|| code =="910001"		
		){						
			errorCodeForExit = true;
		}else {
			errorCodeForExit = false;
		}
		
		return errorCodeForExit;
	},
	
	/* alert 팝업 확인 버튼 */
	this.hideAlertPopup = function(alertCallBackFunc){
		this.hideBackground();
		this.hide(this.$alertPopupObj);
		
		if(undefined != alertCallBackFunc && null != alertCallBackFunc){
			eval(alertCallBackFunc)();
		}
		/*if( "function" == typeof (alertCallBackFunc) ){
			//콜백함수: uf_alert 뜬후 [확인] 클릭시 그후의 작업기술..
			alertCallBackFunc.apply(); 
		}*/
	},
	
	/* confirm 팝업 hide*/
	this.hideConfirmPopup = function(confirmCallBackFunc, dvcd){
		this.hideBackground();
		this.hide(this.$confirmPopupObj);
		
		if(undefined != confirmCallBackFunc && null != confirmCallBackFunc){
			eval(confirmCallBackFunc)(dvcd);
		}
		
		/*if("function" == typeof(confirmCallBackFunc)){ 
			//콜백함수: uf_alert 뜬후 [확인] 클릭시 그후의 작업기술..
			confirmCallBackFunc.apply(); 	
		}*/
	},
	/* background 보여줌 */
	this.showBackground = function(){
		$("#comPopupBackground").remove();
		//$("#wrap").prepend("<div id='comPopupBackground' class='dim' ></div>");
		//$("#wrap").prepend("<div id='comPopupBackground' class='dim' style='display:none;height:"+$(document).height()+"px;width:"+$(document).width()+"px;z-index:5000'></div>");
		$("#wrap").prepend("<div id='comPopupBackground' class='dim' style='height:"+$(document).height()+"px'></div>");
		$("#comPopupBackground").show();
		
		//popup 띄웠을때 모바일에서 touchmove시 popup이 움직이지 않도록 설정
		$("body").unbind("touchmove");
		$("body").bind("touchmove",function(e){
			e.preventDefault();
		});
		
		//document변경을 고려하여 0.5후 background size change
		//setTimeout(function(){$("#comPopupBackground").css({"height":$(document).height()+"px","width":$(document).width()+"px"});},500);
		
		/*$(document).bind("DOMSubtreeModified",function(){
			//alert("modifined");
			$("#comPopupBackground").css("height",$(document).height()+"px");
		});*/
	},
	/* background 숨기기 */
	this.hideBackground = function(){
		//popup 닫을때  모바일에서 touchmove시 popup이 다시 움직이도록 설정
		$("body").unbind("touchmove");
		$("#comPopupBackground").hide();
		$("#comPopupBackground").remove();
	},
	/* error popup이 열렸는지 여부 알려줌*/
	this.isOpenErrorPopup = function(){
		var isOpenError = false;
		var code = "";
		
		if( 0 < this.$errorPopupObj.size() && "none" != this.$errorPopupObj.css("display")){
			isOpenError = true;
			code = this.$errorPopupObj.find("#comErrorCode").html();
			code = code.replace(/[^0-9a-zA-Z]/g, "");
			this.hideBackground();
			this.hide(this.$errorPopupObj);
			
			/**
			 * 9992 - 서비스이용가능시간 아님
			 * 9993 - 비정상적접근
			 * 9999 - 세션종료
			 */
			if(code=="9999" || code=="9993" || code=="702"){	 
				_callAppAction(ActionCode.GO_HOME_AFTER_LOGOUT, "false");	//로그아웃 후 홈으로 이동
			}
			/**
			 * 9992 	- 서비스이용가능시간
			 */
			else if("9992" == code ){
				_webViewExit();
			}else if(this.isErrorCodeForExit()){
				_webViewExit();
			}else if( code == "ECBKEBK00120" || code == "ECBKEBK00121"){	
				location.reload(true);
			}else{
				ComStep.showStep(ComStep.curStep);
			}
		}
		
		return isOpenError;
	},
	/* alert popup이 열렸는지 여부 알려줌*/
	this.isOpenAlertPopup = function(){
		var isOpenAlert = false;
		if( 0 < this.$alertPopupObj.size() && "none" != this.$alertPopupObj.css("display")){
			isOpenAlert = true;
			this.hideBackground();
			this.hide(this.$alertPopupObj);
		}
		return isOpenAlert;
	},
	/* confirm popup이 열렸는지 여부 알려줌*/
	this.isOpenConfirmPopup = function(){
		var isOpenConfirm = false;
		if( 0 < this.$confirmPopupObj.size() && "none" != this.$confirmPopupObj.css("display")){
			isOpenConfirm = true;
			this.hideBackground();
			this.hide(this.$confirmPopupObj);
		}
		return isOpenConfirm;
	},
	/**
	 * position 제설정해줌
	 */
	this.resetPositionPopup = function($popupObj){
		var windowMidPosition = $(window).height()/2;
		var popupMidPosition = $popupObj.parent(".popup").height()/2;
		var popupTop = windowMidPosition-popupMidPosition+$(window).scrollTop();
		
		/*console.log("windowMidPosition:"+windowMidPosition);
		console.log("popupMidPosition:"+popupMidPosition);
		console.log("$(window).scrollTop():"+$(window).scrollTop());
		console.log("top:"+popupTop);
		
		alert("windowMidPosition:"+windowMidPosition+"\npopupMidPosition:"+popupMidPosition+"\n$(window).scrollTop():"+$(window).scrollTop()+"\ntop:"+popupTop);*/
		$popupObj.parent(".popup").css("top",popupTop+"px");

	};
};

var ComPopup = new _comPopup();

/**
 * 키패드와 올라와있는 경우에는 키패드가 내려간후 popup의 위치 재설정 하기위해 필요
 */
/*$(window).resize(function(){
	if( 0 < ComPopup.$alertPopupObj.size() && "none" != ComPopup.$alertPopupObj.css("display")){
		ComPopup.resetPositionPopup = function($ComPopup.$alertPopupObj)
	}
});*/