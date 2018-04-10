<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR" errorPage="/jsp/comm/error.jsp" %>

<%@ include file="/jsp/inc/inc_common.jsp" %>
<%@ include file="/jsp/inc/inc_loading.jsp" %>
<%
	request.setAttribute(Const.ERROR_RETURN_URL, "POPUP");

	String wbs_seq			= StringUtil.null2void(request.getParameter("WBS_SEQ"));
	String state			= StringUtil.null2void(request.getParameter("STATE"));
	String board_id			= StringUtil.null2void(request.getParameter("BOARD_ID"));
	String in_progress		= StringUtil.null2void(request.getParameter("IN_PROGRESS"));
	
	StringBuffer sql	= new StringBuffer();
	Map<String,String> param = new HashMap<String,String>();
	
	param.put("PROJECT_ID", userSession.getProjectID());
	param.put("SEQ", 		wbs_seq);

	if("CR".equals(state)){
		// �Ϸ��û
		param.put("NOW_STAT", 		"333");
	} else if("C".equals(state)){
		// �Ϸ�
		param.put("NOW_STAT", 		"111");
	} else if("ER".equals(state)){
		// ���ܿ�û
		param.put("NOW_STAT", 		"888");
	} else if("E".equals(state)){
		// ����
		param.put("NOW_STAT", 		"999");
	} else if("P".equals(state)){
		// ����
		param.put("NOW_STAT",		"000");
		param.put("REAL_PROGRESS",	in_progress+"%");
	}else if("REJECT".equals(state)){
		// ���ΰź�
		param.put("NOW_STAT",		"222");
	}
	
	try{
		int dbRlt					= qmsDB.update("QMS_BBS_LIST.WBS_U001",param);
	} catch(Exception e){
		if (qmsDB != null) try { qmsDB.rollback(); } catch (Exception e1) {}
	} finally {
		if (qmsDB != null) try { qmsDB.close(); } catch (Exception e1) {}
	}

	// �α��� ȭ������ �̵�
	out.println("<script type='text/javascript'>");
	out.println("alert('���� ó�� �Ǿ����ϴ�.');");
	out.println("window.location.replace('/QMS/jsp/view/bbs/bbs_wbs_view.jsp?BOARD_ID="+board_id+"');");
	out.println("</script>");
%>