var _thisPage = new (Jex.extend({
    onload:function() {
        try {
        } catch(e) {bizException(e, "onload");}
    }
    ,event:function(){
        // ������Ʈ ������ Ȯ�� ���궧
        this.addEvent("#btn_confirm", "click", function(e) {
        	_thisPage.project_info_inquery();
        });
    }
    /**
     * ������Ʈ ���� ��ȸ
     */
    ,project_info_inquery:function() {
    	try {
    		var ajax = jex.createAjaxUtil("Q00101_do");	// ȣ���� ������

    		// �����         		
    		ajax.set("TASK_PACKAGE",    "bbs" );	 						// [�ʼ�]���� package ȣ���� ������ ��Ű

    		// ������
    		ajax.set("PROJECT_ID",      $("select[name=PROJECT_ID]").find('option:selected').val() );						// ���õ� ������ƮID
    		ajax.set("PROJECT_MANAGER", $("select[name=PROJECT_ID]").find('option:selected').attr("projectmanagerid") );	// ���õ� ������Ʈ�Ŵ���
    		ajax.set("PROJECT_NAME",    $("select[name=PROJECT_ID]").find('option:selected').attr("projectname") );		// ���õ� ������Ʈ��
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

