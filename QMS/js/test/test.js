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
     * ����α���
     */
    ,login:function() {
    	try {
    		var ajax = jex.createAjaxUtil("test");	// ȣ���� ������
    		//�����          		
    		ajax.set("TASK_PACKAGE",      "test" );	 	// [�ʼ�]���� package ȣ���� ������ ��Ű
    		ajax.set("aaaa",      "111" );	 	// [�ʼ�]���� package ȣ���� ������ ��Ű
    		
    		ajax.execute(function(dat) {
    			try{
    				alert(JSON.stringify(dat));
    				
    			} catch(e) {bizException(e, "login");}
    		});
    	} catch(e) {bizException(e, "login");}
    }
}))();

