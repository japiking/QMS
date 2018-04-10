var _thisPage = new (Jex.extend({
    onload:function() {
        try {
        } catch(e) {bizException(e, "onload");}
    }
    ,event:function(){
        // 로그인
        this.addEvent("#login_btn", "click", function(e) {
        	_thisPage.login();
        });
        // 로그인 엔터키 입력
        this.addEvent("#USER_ID, #USER_PASSWORD","keydown",function(e){
        	if(e.keyCode==13){
        		_thisPage.login();
        	}
        });
        // 취소
        this.addEvent("#cancle_btn", "click", function(e) {
        	document.location.href = "/QMS/main.jsp";
        });
    }
    /**
     * 프로젝트 정보 조회
     */
    ,login:function() {
    	try {
    		
    		var user_id  = $("#USER_ID").val();
        	if(ComUtil.isEmpty(user_id)) {
        		alert("사용자 ID를 입력하세요.");
        		$("#USER_ID").focus();
       			return false;
        	}

        	var user_pwd = $("#USER_PASSWORD").val();
        	if(ComUtil.isEmpty(user_pwd)) {
        		alert("비밀번호를 입력하세요.");
        		$("#USER_PASSWORD").focus();
       			return false;
        	}
    		
    		var ajax = jex.createAjaxUtil("login_do");	// 호출할 페이지

    		// 공통부         		
    		ajax.set("TASK_PACKAGE",    "lgn" );	 						// [필수]업무 package 호출할 페이지 패키
    		
    		// 개별부
    		ajax.set("USER_ID",    		$("#USER_ID").val());
    		ajax.set("USER_PASSWORD",   $("#USER_PASSWORD").val());
    		
    		ajax.execute(function(dat) {
    			try{
    				var data = dat["_tran_res_data"][0];
    				
    				var gubun = data.PAGE_GBN;
    				var url;

    				if("S" == gubun) url = "/QMS/jsp/view/bbs/bbs_index.jsp";		// 프로젝트 메인페이지
    				else if("M" == gubun) url = "/QMS/jsp/view/lgn/qms_project_view.jsp";	// 프로젝트 선택페이지
    				else if("P" == gubun) url = "/QMS/jsp/view/index.jsp";			// 프로젝트 관리페이지
    				
    	       		frm.target = "_self";
    	       		frm.action = url;
    	       		frm.submit();
    				
    			} catch(e) {bizException(e, "login");}
    		});
    	} catch(e) {bizException(e, "login");}
    }
}))();

