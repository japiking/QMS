<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ include file="/jsp/inc/inc_common.jsp"%>
<%
	boolean checkFlag = false;
	String strUserID = StringUtil.null2void(request.getParameter("USERID"), "");
	String strAuthorityGrade = StringUtil.null2void(request.getParameter("AUTHORITYGRADE"), "");

	List<Map<String, String>> statMaplist = null;
	
	try {
		
		String userList[] = strUserID.split(",");
		String authList[] = strAuthorityGrade.split(",");
		int result		  = 0;
		for(int i=0; i<userList.length; i++){
			String userid = userList[i];
			String auth   = authList[i];
			
			Map<String,String> param = new HashMap<String,String>();
			param.put("PROJECT_ID", 	userSession.getProjectID());
			param.put("USERID", 		userid);
			param.put("AUTHORITYGRADE", auth);
			
			result = qmsDB.insert("QMS_ADMIN.PROJECTUSERINFO_I001", param);
		}
		
		if(result != 0){
			checkFlag = true;
		}
	} catch (Exception e) {
		checkFlag = false;
		e.printStackTrace(System.out);
		if (qmsDB != null){
	        try { qmsDB.rollback(); } catch (Exception e1) {}
		}
	}finally{
		if (qmsDB != null){
	        try { qmsDB.close(); } catch (Exception e1) {}
		}
	}
	//화면으로 이동
	out.println("<script type='text/javascript'>");
	if (checkFlag) {
		out.println("alert('정상 등록 되었습니다.');");
	} else {
		out.println("alert('등록 실패하였습니다.');");
	}
	out.println("window.self.close()");
	out.println("opener.location.href='/QMS/jsp/view/adm/adm_set_user_auth_view.jsp';");
	out.println("</script>");
%>
