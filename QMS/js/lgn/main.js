var _thisPage = new (Jex.extend({
    onload:function() {
        try {
        } catch(e) {bizException(e, "onload");}
    }
    ,event:function(){
        // �α���
        this.addEvent("#login_btn", "click", function(e) {
        	_thisPage.login();
        });
        // �α��� ����Ű �Է�
        this.addEvent("#USER_ID, #USER_PASSWORD","keydown",function(e){
        	if(e.keyCode==13){
        		_thisPage.login();
        	}
        });
        // ���
        this.addEvent("#cancle_btn", "click", function(e) {
        	document.location.href = "/QMS/main.jsp";
        });
    }
    /**
     * ������Ʈ ���� ��ȸ
     */
    ,login:function() {
    	try {
    		
    		var user_id  = $("#USER_ID").val();
        	if(ComUtil.isEmpty(user_id)) {
        		alert("����� ID�� �Է��ϼ���.");
        		$("#USER_ID").focus();
       			return false;
        	}

        	var user_pwd = $("#USER_PASSWORD").val();
        	if(ComUtil.isEmpty(user_pwd)) {
        		alert("��й�ȣ�� �Է��ϼ���.");
        		$("#USER_PASSWORD").focus();
       			return false;
        	}
    		
    		var ajax = jex.createAjaxUtil("login_do");	// ȣ���� ������

    		// �����         		
    		ajax.set("TASK_PACKAGE",    "lgn" );	 						// [�ʼ�]���� package ȣ���� ������ ��Ű
    		
    		// ������
    		ajax.set("USER_ID",    		$("#USER_ID").val());
    		ajax.set("USER_PASSWORD",   $("#USER_PASSWORD").val());
    		
    		ajax.execute(function(dat) {
    			try{
    				var data = dat["_tran_res_data"][0];
    				
    				var gubun = data.PAGE_GBN;
    				var url;

    				if("S" == gubun) url = "/QMS/jsp/view/bbs/bbs_index.jsp";		// ������Ʈ ����������
    				else if("M" == gubun) url = "/QMS/jsp/view/lgn/qms_project_view.jsp";	// ������Ʈ ����������
    				else if("P" == gubun) url = "/QMS/jsp/view/index.jsp";			// ������Ʈ ����������
    				
    	       		frm.target = "_self";
    	       		frm.action = url;
    	       		frm.submit();
    				
    			} catch(e) {bizException(e, "login");}
    		});
    	} catch(e) {bizException(e, "login");}
    }
}))();

