<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ include file="/jsp/inc/inc_common.jsp"%>
<%
	boolean checkFlag = false;
	String strProjectID = StringUtil.null2void(request.getParameter("PROJECTID"), "");
	String strUserID = StringUtil.null2void(request.getParameter("deleteUserID"), "");

	List<Map<String, String>> statMaplist = null;
	
	try {
		Map<String,String> param = new HashMap<String,String>();
		param.put("PROJECTID", strProjectID);
		param.put("USERID", strUserID);
		int result = qmsDB.delete("QMS_ADMIN.PROJECTUSERINFO_D001", param);
		if(result == 1){
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
	//ȭ������ �̵�
	out.println("<script type='text/javascript'>");
	if (checkFlag) {
		out.println("alert('������� �Ǿ����ϴ�.');");
	} else {
		out.println("alert('���� �����Ͽ����ϴ�.');");
	}
	//out.println("opener.uf_inq('0');");                      // ó�� �� ȭ�� ���÷��� ó��
	//out.println("window.location.replace('/QMS/jsp/view/bbs/bbs_list_view.jsp');");
	out.println("location.href='/QMS/jsp/view/adm/adm_set_user_auth_view.jsp?PROJECT_ID="+ strProjectID + "';");
	out.println("</script>");
%>
