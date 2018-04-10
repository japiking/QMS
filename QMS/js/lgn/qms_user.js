var _thisPage = new (Jex.extend({
    onload:function() {
        try {
        } catch(e) {bizException(e, "onload");}
    }
    ,event:function(){
        // ����ڼ��ý�
        this.addEvent("#aSelect", "click", function(e) {
        	var viewList  = [];
    		var hidenList = [];
    		if ($("input:checkbox[class='inputChoice']:checked").length==0) {
    		    alert("����ڸ� ������ �ּ���.");
    		    return;
    		} else {
    			$("input:checkbox[class='inputChoice']:checked").each(function() {
    				if (this.checked == true) {
    					hidenList.push($(this).parent().next().next().text());
    					viewList.push($(this).val());
    				}
    			});
    	
    			$("#lbReceiver", opener.document).text(viewList);
    			$("#hiddenReceiver", opener.document).val(hidenList);
    			window.close();
    		}
        });
        // ��ü���� ��ư Ŭ����
        this.addEvent("#allCheck", "click",function(e){
        	if (this.checked) {
    			$(".inputChoice").prop("checked", true);
    		} else {
    			$(".inputChoice").prop("checked", false);
    		}
        });
        // ���
        this.addEvent("#inqury", "click", function(e) {
        	_thisPage.inquery();
        });
    }
    /**
     * ����ڰ˻�
     */
    ,inquery:function() {
    	try {
    		
    		var user_id  = $("#ipSearch").val();
    		/*
        	if(ComUtil.isEmpty(user_id)) {
        		alert("�˻��� ������� ID�� �̸��� �Է��ϼ���.");
        		$("#USER_ID").focus();
       			return false;
        	}
    		*/
    		var ajax = jex.createAjaxUtil("onerow_do");	// ȣ���� ������

    		// �����         		
    		ajax.set("TASK_PACKAGE",    "bbs" );	 						// [�ʼ�]���� package ȣ���� ������ ��Ű
    		
    		// ������
    		ajax.set("USER_ID",    		user_id);
    		
    		ajax.execute(function(dat) {
    			try{
    				var data = dat["_tran_res_data"][0];
    				
    				var list = data.list;
    				var html = "";
    				
    				for(var i=0; i<list.length; i++){
    					var dat = list[i];
    					
    					html += "<tr>";
    					html += "	<td><input class='inputChoice' type='checkbox' name='checkBox' value='"+dat.USERID+"("+dat.USERNAME+")'/></td>";
    					html += "	<td><span>"+dat.USERNAME+"</span></td>";
    					html += "	<td><span>"+dat.USERID+"</span></td>";
    					html += "</tr>";
    				}
    				

    				$("#user_list").html(html);
    				
    			} catch(e) {bizException(e, "onerow_do");}
    		});
    	} catch(e) {bizException(e, "onerow_do");}
    }
}))();

