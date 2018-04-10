<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<%@ include file="/jsp/inc/inc_common.jsp"%>
<%@ include file="/jsp/inc/inc_header.jsp"%>
<%
	String userNm							=StringUtil.null2void(request.getParameter("us_nm"));
	String userPassword						=StringUtil.null2void(request.getParameter("now_password"));
	String userIp							=StringUtil.null2void(request.getParameter("us_ip"));
	String userbigo							=StringUtil.null2void(request.getParameter("us_bigo"));
	String flag								=StringUtil.null2void(request.getParameter("us_flag"));
	String us_id							=StringUtil.null2void(request.getParameter("us_id"));
	int result=0;

	try{
		Map<String,String> param = new HashMap<String,String>();
		if("Y".equals(flag)){
			param.put("USERID",			us_id);				
		}else{
			param.put("USERID",			userSession.getUserID());
		}
		param.put("USERNAME",		userNm);
		param.put("USERPASSWORD",	userPassword);
		param.put("USERIP",			userIp);
		param.put("BIGO",			userbigo);
		
		result = qmsDB.update("QMS_LOGIN.USERINFO_U001",param);	
		
	}catch(Exception e){
		e.printStackTrace(System.out);
	if (qmsDB != null){
        try { qmsDB.close(); } catch (Exception e1) {}
	}
	}finally{
		if (qmsDB != null){
        	try { qmsDB.close(); } catch (Exception e1) {}
		}
	}
	out.println("<script type='text/javascript'>");
	out.println("alert('정상 처리 되었습니다.');");
	out.println("window.close();");
	out.println("opener.location.reload();");
	out.println("</script>");
%>
<%@ include file="/jsp/inc/inc_bottom.jsp" %>