var _display = new Array(4);
var _displayHistory = [];	//해당시점에서 show상태인 div
var sf_pwd_div_id, sf_is_check_pwd, sf_is_check_phone, sf_is_visible_phone, sf_pre_function, sf_scroll_id;//, sf_vPos_gubn;
var _tmpArr = [];	//씨크리트카드발행번호 난수번호 3개
//var sf_cer_so_gubn, sf_cer_sccd_no, sf_cer_web_sccd_no, sf_cer_web_sccd_no1;	//(주의)"인증서발급/재발급"에서만사용!!(그밖에 업무는 넣지않는다)
var sf_btn_nm;		//(주의)[각업무별도Button사용시]!!(그밖에 업무는 넣지않는다)	
var sf_lgn_gubn;	//권유자직원번호
var _thisSForm_ExeBtn;	//W클릭 방지 2013.05.10 [secretForm이체성거래 Button able] ==> true : click 가능, false : click 불가
var _wClickCertSign;	//인증서팝업 확인버튼 W클릭 방지
var _thisSForm;		// this of jex.mobile.secretform.js
var _parentThis;	// this of parent
var _callBackFunc;	// 스마트뱅킹가입동의를 위한 callBack Func
var _hp_no_history;	// hp_no history
//(function() {
	var sForm_attrs = {
		"id"						: "data-jx-secretform"							//호출할 svc 명
		,"parentId"					: "data-jx-secretform-parent-id"				//상위 Step 이나 영역 Id	
		,"sf_is_visible_phone"		: "data-jx-secretform-is-visible-phone"			//[option]불능시연락처 [true or false]	(show or hide)
		,"sf_is_check_phone"		: "data-jx-secretform-is-check-phone"			//[option]불능시연락처 [true or false]	유효성검증
		,"sf_is_check_pwd"			: "data-jx-secretform-is-check-drot-acnt-pwd"	//[option]계좌비밀번호 [true or false]	유효성검증
		,"sf_pwd_div_id"			: "data-jx-secretform-drot-acnt-pwd-div-id"		//[option]계좌비밀번호필드가 있는 부모 영역 ID
		,"sf_pre_function"			: "data-jx-secretform-pre-execute-function"		//[option]씨크리트폼 실행버튼시 전처리(콜백함수 존재) :: 각업무에서정의한다.
		,"sf_scroll_id"				: "data-jx-secretform-scroll-id"				//[option]scroll id
//		,"sf_vPos_gubn"				: "data-jx-secretform-vPos-gubn"				//[option]보안키패드 위치 0:상단, 1:중단, 2:하단
		,"sf_btn_nm"				: "data-jx-secretform-btn-gubn"					//[option][각업무별Button이름다를경우]
//		,"sf_lgn_gubn"				: "data-jx-secretform-lgn-gubn"					//[option]권유자 직원번호, 보안계좌등록 ["lgn" or "svc040101"]
			
		//(주의)"인증서발급/재발급"에서만사용
//		,"sf_cer_so_gubn"			: "data-jx-secretform-is-cer-so-gubn"		//[option](주의)"인증서발급/재발급"에서만사용!!(그밖에 업무는 넣지않는다) ["S" or "O"]  [씨크리트 or OTP]
//		,"sf_cer_sccd_no"			: "data-jx-secretform-is-cer-sccd-no"		//[option](주의)"인증서발급/재발급"에서만사용!!(그밖에 업무는 넣지않는다) [E01004_S0] 에서 받아온다.	[씨크리트카드발행번호]
//		,"sf_cer_web_sccd_no"		: "data-jx-secretform-is-cer-web-sccd-no"	//[option](주의)"인증서발급/재발급"에서만사용!!(그밖에 업무는 넣지않는다) [E01004_S0] 에서 받아온다.	[난수번호1]
//		,"sf_cer_web_sccd_no1"		: "data-jx-secretform-is-cer-web-sccd-no1"	//[option](주의)"인증서발급/재발급"에서만사용!!(그밖에 업무는 넣지않는다) [E01004_S0] 에서 받아온다.	[난수번호2]
	};
	
	var _ComSecretForm = function(){
		
		this.$object = "";
		
		// OTP/씨크리트 태그 초기화
		this.initDraw = function() {
			var _parentId = this.$object.attr(sForm_attrs.parentId);	//상위 Step 이나 영역 Id	
			if(undefined == _parentId || "" == _parentId || null == _parentId) {
				$("#comSecretForm").html("");
				$("#comSecretForm").addClass("inquiry_wrap");
				$("#comSecretForm").html('<div class="fildelist"><div id="comSecretForm_div" class="inquiry_form"></div></div>');
            	$("#comSecretForm_div").append(this.draw_phone_form());
            	$("#comSecretForm_div").append(this.draw_secret_form());
            	$("#comSecretForm_div").append(this.draw_otp_form());
            	//$("#comSecretForm_div").append(this.draw_agree_emno());
            	$("#comSecretForm_div").append(this.draw_secret_otp_btn_form());
			} else {
				//[2013.05.22] div에 id 와 class 에 "comSecretForm" 셋팅 필수!! (예시)<div id="comSecretForm" class="comSecretForm"></div>
				$("body").find(".comSecretForm").each(function(){ $(this).html(""); $(this).addClass("inquiry_wrap");});
				
				$(_parentId).find("#comSecretForm").html('<div class="fildelist"><div id="comSecretForm_div" class="inquiry_form"></div></div>');
				$(_parentId).find("#comSecretForm_div").append(this.draw_phone_form());
				$(_parentId).find("#comSecretForm_div").append(this.draw_secret_form());
				$(_parentId).find("#comSecretForm_div").append(this.draw_otp_form());
				//$(_parentId).find("#comSecretForm_div").append(this.draw_agree_emno());
				$(_parentId).find("#comSecretForm_div").append(this.draw_secret_otp_btn_form());
			}
			
			if($("#comSecretForm_div").find("#cert_signed_msg").length > 0) $("#cert_signed_msg").remove();
			$("#comSecretForm_div").append('<input id="cert_signed_msg" type="hidden"/>');	//전자서명

			//TODO OTP, 보안카드 파란색 테두리
			 /*$("#otp_num,#ebnk_sccd_pwd,#ebnk_sccd_pwd2,#hp_no99").unbind("focusin");
			 $("#otp_num,#ebnk_sccd_pwd,#ebnk_sccd_pwd2,#hp_no99").bind("focusin", function() {
				 	//input에 포커스 가면 파란색 테두리 그려줌
					$(this).parent().addClass("on");
			 });
			 $("#otp_num,#ebnk_sccd_pwd,#ebnk_sccd_pwd2,#hp_no99").unbind("focusout");
			 $("#otp_num,#ebnk_sccd_pwd,#ebnk_sccd_pwd2,#hp_no99").bind("focusout", function() {
					//파란색 테두리 제거
					$(this).parent().removeClass("on");
			 });*/
			 
		}
		
		//불능시연락처
		this.draw_phone_form = function() {
			var phone_form = ''
				+'<div id="phone_form" class="section some split" style="display:none;">'
					+'<div class="pilsu">'
						+'<label for="a13">불능 시 연락처</label>'
						+'<span>타행이체시 필수 입력</span>'
					+'</div>'
					+'<a class="int_position type2">'
						+'<input id="hp_no01" type="hidden" />'
	            		+'<input id="hp_no02" type="hidden" />'
	            		+'<input id="hp_no03" type="hidden" />'
						+'<input id="hp_no99" type="tel" placeholder="" maxlength="11" title="휴대폰번호" />'
						+'<span class="btn_close"></span>'
					+'</a>'
					+'<button id="hp_no_btn" class="btn_raund btn_reg">변 경</button>'
				+'</div>';
        	/*+ '<div id="phone_form" class="wrap" style="display:none;">'
        		+ '<h2 class="mt_20"><label for="hp_no99">불능시연락처</label></h2>'
        		+ '<span><em class="t_13"></em> 타행이체시 필수</span>'
    			+ '<div class="in_bt mt_10">'
    				+ '<div class="input" style="width:75%">'
    					+ '<input id="hp_no01" type="hidden" />'
	            		+ '<input id="hp_no02" type="hidden" />'
	            		+ '<input id="hp_no03" type="hidden" />'
	            		+ '<input id="hp_no99" type="tel" placeholder="" maxlength="11" title="휴대폰번호"/>'
	            		+ '<button type="button">'
	            			+ '<span class="gray_del" style="display:none;"></span><span class="hidden">텍스트 지우기</span>'
	            		+ '</button>'
	            	+ '</div>'
	            	+ '<button id="hp_no_btn" type="button" class="btn_gray" style="width: 20%">변경</button>'
	            + '</div>'
        	+ '</div>';*/
			return phone_form;
		}
		
		//씨크리트카드 발급고객
		this.draw_secret_form = function() {
			var secret_form = ''
				+'<div id="secret_form" class="section half" style="display:none;">'
					+'<div class="pilsu">'
						+'<label for="a13">보안카드 입력</label>'
					+'</div>'
					+'<div class="security_card">'
						+'<ul>'
							+'<li>'
								+'<label for="a1"><em id="ebnk_sccd_no" ></em>번째 <em>앞</em> 2자리</label>'
								+'<span class="enter">'
									+'<input id="ebnk_sccd_pwd" type="text"  maxlength="2" title="앞2자리" readonly="readonly"/>'	// readonly="readonly"
									+'<img src="/img/img_decode.png" alt="">'
								+'</span>'
							+'</li>'
							+'<li>'
								+'<label for="a2"><em id="ebnk_sccd_no2"></em>번째 <em>뒤</em> 2자리</label>'
								+'<span class="enter">'
									+'<img src="/img/img_decode.png" alt="">'
									+'<input type="text" id="ebnk_sccd_pwd2"  maxlength="2" title="뒤2자리" readonly="readonly"/>'	//readonly="readonly"
								+'</span>'
							+'</li>'
						+'</ul>'
					+'</div>'
				+'</div>';
			
        	/*+ '<div id="secret_form" style="display:none;" class="wrap">'
        		+ '<div id="cer_only_form" style="display:none">'
        			+ '<h2 class="mt_20 mb_10">씨크리트카드 발행번호 입력 </h2>'
        			+ '<p class="info mb_10">씨크리트 카드 우측상단의 숫자 8자리로 되어 있는 발행번호에서 해당되는 자리수의 숫자를 입력해주세요.</p>'
        			+ '<div class="round secrit">보안카드 발행번호의 <span id="secret_no_1" class="t_orange">2</span>,<span id="secret_no_2" class="t_orange">3</span>,<span id="secret_no_3" class="t_orange">4</span>번째 입력</div>'
            		+ '<div id="secret_no_form" class="round secrit">'
	            		+ '<span>●</span>'
	            		+ '<div class="input">'
	            			+ '<input type="text" id="secret_no_input_1" readonly="readonly" maxlength="1" title="보안카드발행번호 2번째자리" class="secret_serial_no"/>'
	            		+ '</div>'
	            		+ '<div class="input">'
	            			+ '<input type="text" id="secret_no_input_2" readonly="readonly" maxlength="1" title="보안카드발행번호 3번째자리" class="secret_serial_no"/>'
	            		+ '</div>'
	            		+ '<div class="input">'
	            			+ '<input type="text" id="secret_no_input_3" readonly="readonly" maxlength="1" title="보안카드발행번호 4번째자리" class="secret_serial_no"/>'
	            		+ '</div>'
	            		+ '<span>●</span>'
	            		+ '<span>●</span>'
	            		+ '<span>●</span>'
	            		+ '<span>●</span>'
	            	+ '</div>'
	            + '</div>'
	            + '<h2 class="mt_20"><label for="name_01">씨크리트카드</label></h2>'
	            + '<span class="t_13"><em class="t_orange">3회</em> 오류시 서비스가 제한됩니다.</span>'
	            + '<ul class="card round p_10 mt_10">'
	            	+ '<li>'
		            	+ '<label for="ebnk_sccd_pwd">[<em id="ebnk_sccd_no" class="t_orange"></em>] 앞 2자리</label>'
		            	+ '<div class="input">'
			            	+ '<input type="text" id="ebnk_sccd_pwd" placeholder="앞2자리" readonly="readonly" maxlength="2" title="앞2자리"/>'
			            + '</div>'
			            + '<div class="dot_area">'
			            	+ '<span></span>'
			            	+ '<span></span>'
			            + '</div>'
			        + '</li>'
			        + '<li class="mt_10">'
			        	+ '<label for="ebnk_sccd_pwd2">[<em id="ebnk_sccd_no2" class="t_orange"></em>] 뒤 2자리</label>'
			        	+ '<div class="dot_area">'
			            	+ '<span></span>'
			            	+ '<span></span>'
			            + '</div>'
			        	+ '<div class="input mt_5">'
			        		+ '<input type="text" id="ebnk_sccd_pwd2" placeholder="뒤2자리" readonly="readonly" maxlength="2" title="뒤2자리"/>'
		        		+ '</div>'
	        		+ '</li>'
        		+ '</ul>'
        	+ '</div>';*/
			return secret_form;
		}
		
		//OTP카드 발급고객
		this.draw_otp_form = function() {
			var otp_form = ''
				+'<div id="otp_form" class="section half line_box2" style="display:none;" >'
		    	+'<div class="otp">'
					+'<label for="a14">OTP번호</label>'
					+'<span>'
						+'<input id="otp_num"  type="text" maxlength="6" placeholder="숫자 6자리" title="OTP번호" readonly="readonly" />'  //readonly="readonly"
					+'</span>'
				+'</div>'
			+'</div>';
				
        	/*+ '<div id="otp_form" class="wrap" style="display:none;">'
        		+ '<h2 id="agree_h" style="display:none"><label>OTP발생번호</label></h2>'
        		+ '<p id="agree_p" class="info mt_5" style="display:none">보유중인 OTP단말기에 생성되는 발생번호 6자리입력</p>'
        		+ '<ul class="round form mt_10">'
        			+ '<li class="mt_1">'
	            		+ '<label for="otp_num">OTP번호</label>'
	            		+ '<div class="right">'
	            			+ '<div class="input">'
	            				+ '<input type="text" id="otp_num" placeholder="숫자 6자리" maxlength="6" readonly="readonly" title="OTP번호"/>'
			            		+ '<button type="button">'
			            			+ '<span class="gray_del" style="display:none;"></span><span class="hidden">텍스트 지우기</span>'
	            				+ '</button>'
            				+ '</div>'
        				+ '</div>'
    				+ '</li>'
        		+ '</ul>'
        	+ '</div>';*/
			return otp_form;
		}
		
		//[약관동의(전용)]권유자 직원번호
		/*,draw_agree_emno : function() {
			var agree_emno = ''
        	+ '<div id="agree_emno" class="wrap" style="display:none;">'
        		+ '<h2 class="mt_20 mb_10">권유자 직원번호</h2>'
        		+ '<ul class="round p_10">'
        			+ '<li>'
        				+ '<div class="input">'
        					+ '<input type="tel" id="id_number" maxlength="5" title="권유자 직원번호" data-jx-chk="true" data-jx-chk-opt=\{"name":"숫자만","charType":"num"}\ />'
        					+ '<button type="button">'
        						+ '<span class="gray_del"></span><span class="hidden">텍스트 지우기</span>'
        					+ '</button>'
						+ '</div>'	
        			+ '</li>'
        		+ '</ul>'
        	+ '</div>';
			return agree_emno;
		}*/
		
		//씨크리트카드 및 OTP카드 BUTTON FORM
		this.draw_secret_otp_btn_form = function() {
			var secret_otp_btn_form = ''
				+'<div id="secret_otp_btn_form" class="btn_ct" style="display:none;">'
					+'<a id="btn_secret_otp_cancel" class="btn">'
						+'<span>취 소</span>'
					+'</a>'
					+'<a id="btn_secret_otp_execute" class="btn dep">'
						+'<span class="btn_next">다 음</span>'
					+'</a>'
				+'</div>';
				//+'<br/><br/><br/><br/><br/><br/>';
        	/*+ '<div id="secret_otp_btn_form" class="wrap" style="display:none;">'
        		+ '<div class="btn_area b2 mt_10">'
            		+ '<button id="btn_secret_otp_cancel" type="button" class="btn_orange">취소</button>'
            		+ '<button id="btn_secret_otp_execute" type="button" class="btn_blue">이체</button>'
        		+ '</div>'
        	+ '</div>';*/
			return secret_otp_btn_form;
		}
		
		this.displayAllHide	= function() {
			for (var i =0; i< _display.length ; i++) {
				_display[i].hide();
			}
		}
		
		this.getSecretForm	= function($obj,func) {
			
			this.$object = $obj;
			
			if(typeof func == "function") {
				_callBackFunc = func;
			}
			
			this.initDraw();
			try {
				_thisSForm = this;			// this of jex.mobile.secretform.js
	            _parentThis = _thisPage;	// this of parent
	            _thisSForm_ExeBtn = true;	//W클릭 방지
	            
	            _display[0] = $("#comSecretForm_div").find("#secret_form");			// 씨크리트카드
	         	_display[1] = $("#comSecretForm_div").find("#otp_form");			// OTP카드
	         	_display[2] = $("#comSecretForm_div").find("#phone_form");			// 불능시연락처
	         	_display[3] = $("#comSecretForm_div").find("#secret_otp_btn_form");	// 씨크리트카드 및 OTP카드 BUTTON
	         	
	            _thisSForm.displayAllHide();
	         	
	            sf_pwd_div_id = this.$object.attr(sForm_attrs.sf_pwd_div_id);		//계좌비밀번호필드가 있는 부모 영역 ID
	            sf_is_check_pwd = this.$object.attr(sForm_attrs.sf_is_check_pwd);	//계좌비밀번호 [true or false]
	            sf_is_check_phone = this.$object.attr(sForm_attrs.sf_is_check_phone);//불능시연락처 [true or false]
	            sf_is_visible_phone = this.$object.attr(sForm_attrs.sf_is_visible_phone);// 불능시연락처 무조건[true or false] show
	            sf_pre_function = this.$object.attr(sForm_attrs.sf_pre_function);// 씨크리트폼 실행버튼시 전처리(콜백함수 Name)
	            sf_scroll_id = this.$object.attr(sForm_attrs.sf_scroll_id);	//scroll id
//	            sf_vPos_gubn = this.$object.attr(sForm_attrs.sf_vPos_gubn);	//보안키패드 위치 0:상단, 1:중단, 2:하단  (default : 1)
	            sf_btn_nm = this.$object.attr(sForm_attrs.sf_btn_nm);	//[각업무별Button이름다를경우]
	            //sf_lgn_gubn = this.$object.attr(sForm_attrs.sf_lgn_gubn);//권유자 직원번호 
	            
	            //(주의)"인증서발급/재발급"에서만사용!!(그밖에 업무는 넣지않는다) ["S" or "O"]  씨크리트 or OTP
	            // sf_cer_so_gubn = this.$object.attr(sForm_attrs.sf_cer_so_gubn);//[인증서발급/재발급]업무만사용
	            //sf_cer_sccd_no = this.$object.attr(sForm_attrs.sf_cer_sccd_no);//씨크리트카드발행번호
	            //sf_cer_web_sccd_no = this.$object.attr(sForm_attrs.sf_cer_web_sccd_no);//난수번호1
	            //sf_cer_web_sccd_no1 = this.$object.attr(sForm_attrs.sf_cer_web_sccd_no1);//난수번호2
	            
	            
	            //계좌비밀번호필드가 있는 부모 영역 ID
	         	sf_pwd_div_id = sf_pwd_div_id == undefined ? "" :sf_pwd_div_id;
	         	
	         	//계좌비밀번호 [true or false]	유효성검증
	         	sf_is_check_pwd = sf_is_check_pwd == undefined ? false : eval(sf_is_check_pwd);	//계좌비밀번호
	         	
	         	//불능시연락처 [true or false]	유효성검증
	         	sf_is_check_phone = sf_is_check_phone == undefined ? false : eval(sf_is_check_phone);
	         	
	         	// 불능시연락처 무조건 show
	         	sf_is_visible_phone = sf_is_visible_phone == undefined ? false : eval(sf_is_visible_phone);	
	         	
	         	// 씨크리트폼 실행버튼시 전처리(콜백함수 존재여부) :: 각업무에서정의한다.
	         	sf_pre_function = (sf_pre_function == undefined || sf_pre_function == "") ? "" : sf_pre_function;	
	         	
	         	//Scroll id
	         	sf_scroll_id = sf_scroll_id == undefined ? "" :sf_scroll_id;
	         	
	         	
	         	//보안키패드 위치 0:상단, 1:중단, 2:하단  (default : 1)
//	         	sf_vPos_gubn = sf_vPos_gubn == undefined ? "1" :sf_vPos_gubn;
//	         	sf_vPos_gubn = (sf_vPos_gubn!="0" && sf_vPos_gubn!="1" && sf_vPos_gubn!="2") ? "1" : sf_vPos_gubn;
	         	
	         	//[각업무별Button이름다를경우]
	         	sf_btn_nm = (sf_btn_nm == undefined || sf_btn_nm == "") ? "" :sf_btn_nm;//[각업무별Button이름다를경우]
	         	if(sf_btn_nm != "") $("#btn_secret_otp_execute span").text(sf_btn_nm);
	         	
	         	
	         	//(주의)"인증서발급/재발급"에서만사용!!(그밖에 업무는 넣지않는다) ["S" or "O"]  씨크리트 or OTP
	         	//sf_cer_so_gubn = (sf_cer_so_gubn == undefined || sf_cer_so_gubn == "") ? "" :sf_cer_so_gubn;//[인증서발급/재발급]업무만사용
	         	//sf_cer_sccd_no = (sf_cer_sccd_no == undefined || sf_cer_sccd_no == "") ? "" :sf_cer_sccd_no;//씨크리트카드발행번호
	         	//sf_cer_web_sccd_no = (sf_cer_web_sccd_no == undefined || sf_cer_web_sccd_no == "") ? "" :sf_cer_web_sccd_no;//난수번호1
	         	//sf_cer_web_sccd_no1 = (sf_cer_web_sccd_no1 == undefined || sf_cer_web_sccd_no1 == "") ? "" :sf_cer_web_sccd_no1;//난수번호2
	         	
	         	
	            //권유자 직원번호 
	         	 /* sf_lgn_gubn = (sf_lgn_gubn == undefined || sf_lgn_gubn == "") ? "" :sf_lgn_gubn;
	          	if(sf_lgn_gubn == "lgn") {
	            	$("#comSecretForm_div").find("#agree_emno").show();	//또는 .attr("style","display:''");
	            	$("#comSecretForm_div").find("#agree_emno").attr("style","display:'block'");
	            	$("#comSecretForm_div").find("#agree_sc").hide();
	            }*/
	        	
	        	//[불능시연락처] 변경 BUTTON
	        	$("#hp_no_btn").bind("click", function(e) {
	        		//tts_text("변경");
	        		if(_hp_no_history == $("#hp_no99").val()){
	        			ComPopup.showAlertPopup("[불능시 연락처] 변경전 전화번호와 동일합니다. <br />전화번호를 확인해주세요.");
    					return;
	        		}
	        		
	        		ComPopup.showConfirmPopup("[불능시 연락처] 변경하시겠습니까?","안내",function(){
	    				if("" == $("#hp_no99").val().trim()){
	    					ComPopup.showAlertPopup("[불능시 연락처] 필수 입력 사항입니다.");
	    					return; 
	    				}
	    				else if($.trim($("#hp_no99").val()).length < 10){
	    					ComPopup.showAlertPopup("[불능시 연락처] 자릿수를 확인하세요.");
	    					return;
	    				}
	    				else{
	    					var hp_no99 = $.trim($("#hp_no99").val().substring(0, 3));
	    					if(!(hp_no99 == "010" || hp_no99 == "011" || hp_no99 == "016" 
	    						|| hp_no99 == "017" || hp_no99 == "018" || hp_no99 == "019"))
	    					{
	    						ComPopup.showAlertPopup("[불능시 연락처]국번를 확인하세요.");
	    						return;
	    					}else {
	    						_thisSForm.com_S02069_SA0();
	    					}
	    				}
	    			});
	        	});
	        	
	        	//[이체실행] BUTTON (씨크리트카드 및 OTP카드)
	        	$("#btn_secret_otp_execute").bind("click", function(e) {
	        		if(sf_btn_nm == "") sf_btn_nm = "이체";
	        		//alert(_thisSForm_ExeBtn);
	        		if(_thisSForm_ExeBtn){
	    				_thisSForm_ExeBtn = false;	//W클릭 방지
	    				_thisSForm.secret_otp_execute();
	    			}
	        	});
	        	
	        	//[취소] BUTTON (씨크리트카드 및 OTP카드 )
	        	$("#btn_secret_otp_cancel").bind("click", function(e) {
	        		//tts_text("취소");
	        		_parentThis.call_uf_cancel();
	        	});
	        	
	        	
	        	//계좌비밀번호 보안키패드 적용
	        	$("#drot_acnt_pwd").bind("click", function(e) {
	        		$(this).parent().addClass("on");
	    			_callRaonKeypad('drot_acnt_pwd', '1', '4', '4', '계좌비밀번호 4자리','Y');
	        	});
	        	//OTP카드 보안키패드 적용
	        	$("#otp_num").bind("click", function(e) {
	        		$(this).parent().addClass("on");
	    			_callRaonKeypad('otp_num', '1', '6', '6', 'OTP발생번호 6자리', _thisSForm.isLogin);
	        	});
	        	//씨크리트카드앞2자리 보안키패드 적용
	        	$("#ebnk_sccd_pwd").bind("click", function(e) {
	        		$(this).parent().addClass("on");
	    			_callRaonKeypad('ebnk_sccd_pwd', '1', '2', '2', '씨크리트카드앞2자리', _thisSForm.isLogin, "", 'ebnk_sccd_pwd2');
	        	});
	        	//씨크리트카드뒤2자리 보안키패드 적용
	        	$("#ebnk_sccd_pwd2").bind("click", function(e) {
	        		$(this).parent().addClass("on");
	    			_callRaonKeypad('ebnk_sccd_pwd2', '1', '2', '2', '씨크리트카드뒤2자리', _thisSForm.isLogin);
	        	});
	        	
	        	
	        	//if(sf_cer_so_gubn != "" && sf_cer_so_gubn != undefined){
	            //	_thisSForm.isLogin = "N";		//로그인유무 = "Y":login, "N":need not login
	            	//_thisSForm.cer_SECRET_LOAD();	//(주의)"인증서발급/재발급"에서만사용!! cer
	            //}else{
	            	_thisSForm.isLogin = "Y";		//로그인유무 = "Y":login, "N":need not login
	            	_thisSForm.com_SECRET_FORM();	//SECRET_FORM LOAD
	            //}
	        	
	        } catch(e) {bizException(e, "JEX_MOBILE getSecretForm");}
		}
		
		//[이체실행] BUTTON (씨크리트카드 및 OTP카드)
		this.secret_otp_execute = function() {
	       // try {
	        	// 씨크리트폼 실행버튼시 전처리(콜백함수 존재여부) :: 각업무에서정의한다.
			
				if("" != sf_pre_function ){		
					var break_Bool = true;
					
					// return true  ==> 이후진행
					// return false ==> stop
					break_Bool = eval(sf_pre_function);	//각 업무단 에서 필요한 작업 수행..
					
					if(! break_Bool) {
						_thisSForm_ExeBtn = true;	//W클릭 방지
						return false; 
					}
				}
				
	        	//출금계좌 비밀번호
	    		if (sf_is_check_pwd != undefined &&  sf_is_check_pwd) {
	    			var _drot_acnt_pwd = "drot_acnt_pwd";
	    			
	    			//계좌비밀번호필드가 있는 부모 영역 ID
	    			if(sf_pwd_div_id != "") _drot_acnt_pwd = sf_pwd_div_id+" #drot_acnt_pwd";
	    			
					if($("#"+_drot_acnt_pwd).val().length != 4){
						ComPopup.showAlertPopup("[출금계좌 비밀번호]필수 입력 사항입니다.");
						_thisSForm_ExeBtn = true;	//W클릭 방지
						return false;
					}
	    		}
	    		
	    		//불능시 연락처 new
	    		if (sf_is_check_phone != undefined &&  sf_is_check_phone) {
					if($("#hp_no99").val().trim()==""){
						ComPopup.showAlertPopup("[불능시 연락처] 필수 입력 사항입니다.");
						_thisSForm_ExeBtn = true;	//W클릭 방지
						return; 
					}else if($.trim($("#hp_no99").val()).length < 10){
						ComPopup.showAlertPopup("[불능시 연락처] 자릿수를 확인하세요.");
						_thisSForm_ExeBtn = true;	//W클릭 방지
						return;
					}
	    		}
	    		
	    		//사용자가 [불능시 연락처] 변경했다면
	    		if( $.trim($("#hp_no99").val()) != ($("#hp_no01").val()+$("#hp_no02").val()+$("#hp_no03").val())){
	    			var hp_no99 = $.trim($("#hp_no99").val());			//불능시 연락처
	         		var hp1, hp2, hp3 = "";
	         		hp1 = hp_no99.substring(0, 3);
	         		hp2 = hp_no99.length==10?hp_no99.substring(3, 6):hp_no99.substring(3, 7);
	         		hp3 = hp_no99.substring(hp_no99.length-4, hp_no99.length);
	    			$("#hp_no01").val(hp1);	//hidden
	    			$("#hp_no02").val(hp2);	//hidden
	    			$("#hp_no03").val(hp3);	//hidden
	    		}
	    		
	    		// Secret or OTP
	    		var autho_sc = $.trim(_thisSForm.resultData["AUTHO_SC"]);	// S:씨크리트카드 발급고객, O:OTP카드 발급고객 (알파벳 O)
	    		if(autho_sc == "S"){			//S:씨크리트카드
	    			if($("#ebnk_sccd_pwd").val().length != 2 || $("#ebnk_sccd_pwd2").val().length != 2){
	    				ComPopup.showAlertPopup("[씨크리트카드번호]필수 입력 사항입니다.");
	    				_thisSForm_ExeBtn = true;	//W클릭 방지
	    				return false;
	    			}
	    		} else if(autho_sc == "O"){		//OTP카드
	    			if($("#otp_num").val().length != 6){
	    				ComPopup.showAlertPopup("[OTP발생번호]필수 입력 사항입니다.");
	    				_thisSForm_ExeBtn = true;	//W클릭 방지
	    				return false;
	    			}
	    		}
	    		
	    		/*if(sf_lgn_gubn == "lgn") {	// 스마트 약관동의
	    			var id_number = $("#id_number").val();
	    			if (id_number != "") {
						if(id_number.length < 4 || id_number.length > 5 ) {
							ComPopup.showAlertPopup("권유자 직원번호는 네 자리 또는 다섯 자리입니다.");
							$("#emno").val("");
							_thisSForm_ExeBtn = true;	//W클릭 방지
							return;
						}
	    			}
					_parentThis.call_uf_submit(); 		//실행
				}*/
	    		
	    		//(주의)"보안계좌등록"에서만사용
	    		/*else if(sf_lgn_gubn == "svc040101") {	
	    			_parentThis.call_uf_submit(); 		//실행
	    		}
	    		else {*/	//default
	    			
    			var signData = "";
				try {
					signData = _parentThis.getSignData();
				} catch (e) {
					ComPopup.showAlertPopup("getSignData() function이 없습니다. ");
				}
				
				var cert_serialkey = $.trim(_thisSForm.resultData["cert_serial"]);	//서명값 에서 꺼낸 인증서 시리얼번호
				
				_wClickCertSign = false;	//인증서팝업 확인버튼 W클릭 방지
				
				//전자서명호출
				callCertSign(signData, cert_serialkey);
				
				if("X" == ComUtil.getPhoneType()){	//TEST일 경우
					alert("TEST일 경우");
					_parentThis.call_uf_submit(); 	//실행
				}
	       /* } catch(e) {
	        	bizException(e, "secret_otp_execute");
	        	_thisSForm_ExeBtn = true;	//W클릭 방지
	        }*/
	    }
	    
	    //[인증서발급/재발급]업무만사용 [다음] BUTTON 
	   /* ,cer_next_execute:function() {
	    	try {
	    		if(_thisSForm_ExeBtn == true) {
	    			_thisSForm_ExeBtn = false;	//W클릭 방지
	    			
	    			if(sf_cer_so_gubn == "S"){			//보안카드 발행번호
	    				if($("#secret_no_input_1").val().length != 1 || $("#secret_no_input_1").val().length != 1 || $("#secret_no_input_3").val().length != 1){
	    					ComPopup.showAlertPopup("[보안카드 발행번호]필수 입력 사항입니다.");
	    					_thisSForm_ExeBtn = true;	//W클릭 방지
	    					return false;
	    				}
	    				if($("#ebnk_sccd_pwd").val().length != 2 || $("#ebnk_sccd_pwd2").val().length != 2){
	    					ComPopup.showAlertPopup("[씨크리트카드번호]필수 입력 사항입니다.");
	    					_thisSForm_ExeBtn = true;	//W클릭 방지
	    					return false;
	    				}
	    			}else if(sf_cer_so_gubn == "O"){	//OTP카드
	    				if($("#otp_num").val().length != 6){
	    					ComPopup.showAlertPopup("[OTP발생번호]필수 입력 사항입니다.");
	    					_thisSForm_ExeBtn = true;	//W클릭 방지
	    					return false;
	    				}
	    			}
	    			_parentThis.call_uf_submit();	//실행
	    		}
	    		
	    	} catch(e) {
	        	bizException(e, "cer_next_execute");
	        	_thisSForm_ExeBtn = true;	//W클릭 방지
	        }
	    }*/
		//SECRET_FORM LOAD
		this.com_SECRET_FORM = function() {
	        try {
	     		var ajax = jex.createAjaxUtil("SECRET_FORM");
	     		
	            //공통부     
	            ajax.set("TASK_PACKAGE",         "com" );	//[필수]업무 package  
	             
	            ajax.execute(function(dat) {
	                try{
                		//result data
                		var resultData = dat["_tran_res_data"][0];		//result data
                		_thisSForm.resultData = resultData;
                		
                		// S:씨크리트카드 발급고객, O:OTP카드 발급고객 (알파벳 O)
                		if($.trim(resultData["AUTHO_SC"]) == "S"){
                			//_thisSForm.com_C01060_S0();	//SECRET 난수번호조회 ===> com_SECRET_FORM.jsp(씨크리트카드 난수번호조회) 에서 처리 [2013-05-09]
                			$("#comSecretForm_div").find("#secret_form").show();
                			$("#comSecretForm_div").find("#otp_form").hide();
                			
                			//씨크리트카드 난수번호 setting
                			$("#ebnk_sccd_no").text(resultData["ebnk_sccd_no"]);	//씨크리트카드 난수번호 1
                			$("#ebnk_sccd_no2").text(resultData["ebnk_sccd_no1"]);	//씨크리트카드 난수번호 2
                			
                		}else if($.trim(resultData["AUTHO_SC"]) == "O"){
                			$("#comSecretForm_div").find("#secret_form").hide();
                			$("#comSecretForm_div").find("#otp_form").show();
                		}
                		
                		//약관동의
                		/*if($.trim(resultData["AUTHO_SC"]) == "O" && sf_lgn_gubn == "lgn"){
                			$("#comSecretForm_div").find("#agree_h").show();			
                			$("#comSecretForm_div").find("#agree_p").show();
                		}*/
                		
                		//불능시연락처 setting
                		$("#hp_no01").val($.trim(resultData["ctct_tlno1"]));	//hidden
                		$("#hp_no02").val($.trim(resultData["ctct_tlno2"]));	//hidden
                		$("#hp_no03").val($.trim(resultData["ctct_tlno3"]));	//hidden
                		
                		//불능시연락처 setting
                		$("#hp_no99").val($.trim(resultData["ctct_tlno1"]) + $.trim(resultData["ctct_tlno2"]) + $.trim(resultData["ctct_tlno3"]));
                		_hp_no_history = $("#hp_no99").val();
                		
                		// 불능시연락처 무조건 show
                		if(sf_is_visible_phone) $("#comSecretForm_div").find("#phone_form").show();
                		
                		$("#comSecretForm_div").find("#secret_otp_btn_form").show();	//씨크리트카드 및 OTP카드 BUTTON FORM
                		
                		if(typeof _callBackFunc == "function") {
                			_callBackFunc.apply();
                		}
	            		
	                } catch(e) {bizException(e, "com_SECRET_FORM");}
	            });
	        } catch(e) {bizException(e, "com_SECRET_FORM");}
	    }
	    
	    //(주의)"인증서발급/재발급"에서만사용!!
/*	    ,cer_SECRET_LOAD:function() {
	    	try {
	    		//(주의)"인증서발급/재발급"에서만사용!!(그밖에 업무는 넣지않는다) ["S" or "O"]  씨크리트 or OTP
	    		if(sf_cer_so_gubn == "S"){
	    			if(sf_cer_web_sccd_no != "" && sf_cer_web_sccd_no1 != ""){
	    				_tmpArr = [];	//씨크리트카드 난수번호 3개
	    				for(var i=0;i<3;i++){
	    					_tmpArr[i] = Math.floor((Math.random()*8)+1);
	    					if(i>0){
	    						for(var j=0;j<i;j++){
	    							if(String(_tmpArr[i]) == String(_tmpArr[j])){
	    								i--;
	    								break;
	    							}
	    						}
	    					}
	    				}
	    				//버블정렬 오름차순 정렬
	    				for(var i=0;i<2;i++){
	    					for(var j=0;j<2-i;j++){
	    						if(_tmpArr[j] > _tmpArr[j+1]){
	    							var tmp = _tmpArr[j];
	    							_tmpArr[j] = _tmpArr[j+1];
	    							_tmpArr[j+1] = tmp;
	    						}
	    					}
	    				}
	    				$("#secret_no_1").text(_tmpArr[0]);	//씨크리트카드발행번호 난수번호 1
	    				$("#secret_no_2").text(_tmpArr[1]);	//씨크리트카드발행번호 난수번호 2
	    				$("#secret_no_3").text(_tmpArr[2]);	//씨크리트카드발행번호 난수번호 3
	    				
	    				$("#secret_no_form").html("");
	    				$("#secret_no_form").children().remove();
	    				var tmpNo = 1;
	    				for(var i=1; i<9; i++){
	    					if(i == _tmpArr[tmpNo-1]){	//씨크리트카드 난수번호 3개
	    						$("#secret_no_form").append("<div class='input'>"+ 
	    								"<input id='secret_no_input_"+tmpNo+"' type='text' readonly='readonly' maxlength='1' class='secret_serial_no' title='보안카드발행번호 "+tmpNo+"번째자리'/>"+
	    						"</div>");
	    						tmpNo++;
	    					}else{
	    						$("#secret_no_form").append("<span>●</span>");
	    					}
	    				}
	    				
	    				_thisSForm.secretSerialEvent();	//보안카드 발행번호 보안키패드 적용 Event
	    				
	    				$("#comSecretForm_div").find("#cer_only_form").show();
	    				
	    				
	    				//씨크리트카드 난수번호 setting
	    				$("#ebnk_sccd_no").text(sf_cer_web_sccd_no);	//cer에서 받아온  난수번호 1
	    				$("#ebnk_sccd_no2").text(sf_cer_web_sccd_no1);	//cer에서 받아온  난수번호 2
	    			}
	    			$("#comSecretForm_div").find("#otp_form").hide();
	    			$("#comSecretForm_div").find("#secret_form").show();	//S:씨크리트카드
	    		}else if(sf_cer_so_gubn == "O"){
	    			$("#comSecretForm_div").find("#secret_form").hide();
	    			$("#comSecretForm_div").find("#otp_form").show();		//OTP카드
	    		}
	    		
	    		$("#comSecretForm_div").find("#secret_otp_btn_form").hide();	//씨크리트카드 및 OTP카드 BUTTON FORM
	    		
	    	} catch(e) {bizException(e, "cer_SECRET_LOAD");}
	    }*/
	    
	    //보안카드 발행번호 보안키패드 적용 Event (현재 "인증서발급/재발급"에서만사용!!)
/*	    ,secretSerialEvent = function() {
	    	$("body").find(".secret_serial_no").each(function(){
				//씨크리트카드 발행번호 1번째자리 보안키패드 적용
				if ($(this).attr("id") == "secret_no_input_1" ) {
					$(this).bind("click", function(){
						$(this).parent().addClass("on");
						_callRaonKeypad('secret_no_input_1', '1', '1', '1', '발행번호 1번째자리', _thisSForm.isLogin, "", 'secret_no_input_2');
					});
				}
				//씨크리트카드 발행번호 2번째자리 보안키패드 적용
				if ($(this).attr("id") == "secret_no_input_2" ) {
					$(this).bind("click", function(){
						$(this).parent().addClass("on");
						_callRaonKeypad('secret_no_input_2', '1', '1', '1', '발행번호 2번째자리', _thisSForm.isLogin, "", 'secret_no_input_3');
					});
				}
				//씨크리트카드 발행번호 3번째자리 보안키패드 적용
				if ($(this).attr("id") == "secret_no_input_3" ) {
					$(this).bind("click", function(){
						$(this).parent().addClass("on");
						_callRaonKeypad('secret_no_input_3', '1', '1', '1', '발행번호 3번째자리', _thisSForm.isLogin);
					});
				}
			});
	    }*/
		
	    //불능시연락처 등록/변경
		this.com_S02069_SA0 = function() {
	        try {
	     		var ajax = jex.createAjaxUtil("S02069_SA0");	
	     		
	     		var hp_no99 = $.trim($("#hp_no99").val());			//불능시 연락처
	     		var hp1, hp2, hp3 = "";
	     		hp1 = hp_no99.substring(0, 3);
	     		hp2 = hp_no99.length==10?hp_no99.substring(3, 6):hp_no99.substring(3, 7);
	     		hp3 = hp_no99.substring(hp_no99.length-4, hp_no99.length);
	         		
	            //공통부     
	            ajax.set("TASK_PACKAGE",         "com" );	//[필수]업무 package  
	            
	            //변경한 전화번호
	    		ajax.set("CTCT_TLNO1",         hp1);
	    		ajax.set("CTCT_TLNO2",         hp2);
	    		ajax.set("CTCT_TLNO3",         hp3);
	    		
	    		//변경전 전화번호
	    		ajax.set("PRE_CTCT_TLNO1",     $.trim(_thisSForm.resultData["ctct_tlno1"]==undefined?"":_thisSForm.resultData["ctct_tlno1"]));
	    		ajax.set("PRE_CTCT_TLNO2",     $.trim(_thisSForm.resultData["ctct_tlno2"]==undefined?"":_thisSForm.resultData["ctct_tlno2"]));
	    		ajax.set("PRE_CTCT_TLNO3",     $.trim(_thisSForm.resultData["ctct_tlno3"]==undefined?"":_thisSForm.resultData["ctct_tlno3"]));
	    		
	            ajax.execute(function(dat) {
	                try{
	                	ComPopup.showAlertPopup("불능시연락처 [등록/변경] 되었습니다.");
	                	
	                	_thisSForm.displayAllHide();
	            		_thisSForm.com_SECRET_FORM();
	            		
	                } catch(e) {bizException(e, "com_S02069_SA0");}
	            });
	        } catch(e) {bizException(e, "com_S02069_SA0");}
	    }

	};
	
	//jex.plugin.add("JEX_MOBILE_SECRETFORM", JexMobileSecretForm, "data-jx-secretform");
//})();

var ComSecretForm = new _ComSecretForm();

/**
 * callCertSign() 호출 후의 인증서제출 콜백함수
 */
function uf_signdata(data){
	
	var signData = "";
	
	if(ComUtil.isIphone()){
		signData = data;
	}else if(ComUtil.isAndroid()){
		signData = JSON.parse(data)['_sign_data'];
		signData = decodeURIComponent(signData);
	}
	
	//인증서팝업 확인버튼 W클릭 방지
	if(!_wClickCertSign){
		_wClickCertSign = true;
	}else{ 
		return;
	}
	
	//인증서팝업 취소 button  click 시
	if(signData == "cancel" || signData == "CANCEL"){	
		
		if(ComUtil.isAndroid()){
			ComPopup.showAlertPopup("전자서명이 취소되었습니다.");		
		}
		_thisSForm_ExeBtn = true;	//W클릭 방지
		return;
	} 
	else {//정상
		$("#cert_signed_msg").val(signData);
		_parentThis.call_uf_submit();
	}
}

/**
 * 보안키패드완료 callback (_nextin 있을경우)
 */
var _thisSForm_arr_nextin = ["secret_no_input_2", "secret_no_input_3", "ebnk_sccd_pwd", "ebnk_sccd_pwd2"];	//SecretForm화면상의 _nextin 의 순서
function _callRaonKeypad_SecretForm(_nextin) {	//보안키패드완료 callback
	try{
		var _idx = _thisSForm_arr_nextin.indexOf(_nextin);
		for(var i=_idx; i< _thisSForm_arr_nextin.length; i++){
			if($("#"+_thisSForm_arr_nextin[i]).val().length == 0){
				$("#"+_thisSForm_arr_nextin[i]).trigger("click");
				break;
			}
		}
	} catch(e) {bizException(e, "_callRaonKeypad_SecretForm");}
}