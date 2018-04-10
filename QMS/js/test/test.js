var _thisPage = new (Jex.extend({
    onload:function() {
        try {
        	
        } catch(e) {bizException(e, "onload");}
    }
    ,event:function(){
        this.addEvent("#aaa", "click", function(e) {
        	_thisPage.login();
        });
       
    }
    /**
     * 가상로그인
     */
    ,login:function() {
    	try {
    		var ajax = jex.createAjaxUtil("test");	// 호출할 페이지
    		//공통부          		
    		ajax.set("TASK_PACKAGE",      "test" );	 	// [필수]업무 package 호출할 페이지 패키
    		ajax.set("aaaa",      "111" );	 	// [필수]업무 package 호출할 페이지 패키
    		
    		ajax.execute(function(dat) {
    			try{
    				alert(JSON.stringify(dat));
    				
    			} catch(e) {bizException(e, "login");}
    		});
    	} catch(e) {bizException(e, "login");}
    }
}))();

