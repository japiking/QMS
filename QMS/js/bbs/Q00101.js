var _thisPage = new (Jex.extend({
    onload:function() {
        try {
        } catch(e) {bizException(e, "onload");}
    }
    ,event:function(){
        // 프로젝트 선택후 확인 누룰때
        this.addEvent("#btn_confirm", "click", function(e) {
        	_thisPage.project_info_inquery();
        });
    }
    /**
     * 프로젝트 정보 조회
     */
    ,project_info_inquery:function() {
    	try {
    		var ajax = jex.createAjaxUtil("Q00101_do");	// 호출할 페이지

    		// 공통부         		
    		ajax.set("TASK_PACKAGE",    "bbs" );	 						// [필수]업무 package 호출할 페이지 패키

    		// 개별부
    		ajax.set("PROJECT_ID",      $("select[name=PROJECT_ID]").find('option:selected').val() );						// 선택된 프로젝트ID
    		ajax.set("PROJECT_MANAGER", $("select[name=PROJECT_ID]").find('option:selected').attr("projectmanagerid") );	// 선택된 프로젝트매니져
    		ajax.set("PROJECT_NAME",    $("select[name=PROJECT_ID]").find('option:selected').attr("projectname") );		// 선택된 프로젝트명
    		ajax.execute(function(dat) {
    			try{
    				var data = dat["_tran_res_data"][0];
    	       		
    	       		frm.target = "_self";
    	       		frm.action = "/QMS/jsp/view/bbs/bbs_index.jsp";
    	       		frm.submit();
    				
    			} catch(e) {bizException(e, "login");}
    		});
    	} catch(e) {bizException(e, "login");}
    }
}))();

