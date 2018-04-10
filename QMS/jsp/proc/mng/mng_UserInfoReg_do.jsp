<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR" errorPage="/jsp/comm/error.jsp" %>

<%@ include file="/jsp/inc/inc_common.jsp" %>

<%
	String user_id			= StringUtil.null2void(request.getParameter("USER_ID"));
	String user_nm			= StringUtil.null2void(request.getParameter("USER_NAME"));
	String user_pwd			= StringUtil.null2void(request.getParameter("USER_PASSWD"));
	String user_ip			= StringUtil.null2void(request.getParameter("USER_IP"));
	String user_bigo		= StringUtil.null2void(request.getParameter("BIGO"));
	String page_falg		= StringUtil.null2void(request.getParameter("PAGE_FALG")); //������ ����� �߰���
	try{
		Map<String,String> param1		= new HashMap<String,String>();
		int rlt = 0;
		String rlt_text = new String("");
		param1.put("USERID", user_id);
		try{
			Map<String,String> map = qmsDB.selectOne("QMS_SUPERUSER.USERINFO_R001", param1);
			rlt = Integer.parseInt(StringUtil.null2void(map.get("USERCOUNT")));
		}catch(Exception e1){
			rlt = 0;	
		}
		if(rlt>0){
			rlt_text = user_id+"�� ����ϽǼ� ���� ID�Դϴ�.";
			out.println("<script type='text/javascript'>					");
			out.println("	alert('"+rlt_text+"');							");
			out.println("</script>											");
		}else{
			Map<String,String> param12 = new HashMap<String,String>();
			param12.put("USERID", 			user_id);
			param12.put("USERNAME", 		user_nm);
			param12.put("USERPASSWORD", 	user_pwd);
			param12.put("USERIP", 			user_ip);
			param12.put("BIGO", 			user_bigo);
			int dbRlt2			= qmsDB.insert("QMS_SUPERUSER.USERINFO_C002", param12);
			
			String prj_id = StringUtil.null2void(userSession.getProjectID());
			if(!"".equals(prj_id)){
				param12.put("PROJECTID", 		prj_id);
				int dbRlt3			= qmsDB.insert("QMS_SUPERUSER.PROJECTUSERINFO_C002", param12);
			}
			
			if(!"1".equals(page_falg)){
			%>
				<script type='text/javascript'>	
				alert('ȸ�������� �Ϸ�Ǿ����ϴ�.');
				opener.location.href='/QMS/jsp/view/mng/mng_projectUserReg_view.jsp'
				window.close();
				</script>
			<%
			}else{
			%>
				rlt_text = "";
				<script type='text/javascript'>
				alert("ȸ�������� �Ϸ�Ǿ����ϴ�.");
				parent.frm2.style.display='none';
				parent.document.getElementById('idSearch').value = parent.frm2.USER_ID.value;
				parent.userSearch();
				</script>									
			<%			
			}
			
		}
	} catch(Exception e){
			e.printStackTrace(System.out);
			String rlt_text = "ó���� ������ �߻��Ͽ����ϴ�.";
			out.println("<script type='text/javascript'>					");
			out.println("	alert('"+rlt_text+"');							");
			out.println("</script>											");
		if (qmsDB != null)
			try { qmsDB.rollback(); } catch (Exception e1) {}
%>
<%
	} finally{
		if (qmsDB != null)
			try { qmsDB.close(); } catch (Exception e1) {}
	}

%>
