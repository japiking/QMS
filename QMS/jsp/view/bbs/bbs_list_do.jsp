<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR" errorPage="/jsp/comm/error.jsp" %>

<%@ include file="/jsp/inc/inc_common.jsp" %>
<%@ include file="/jsp/inc/inc_loading.jsp" %>
<%
request.setAttribute(Const.ERROR_RETURN_URL, "POPUP");
request.setCharacterEncoding("euc-kr");

String board_id		= StringUtil.null2void(request.getParameter("BOARD_ID"));
String seq			= StringUtil.null2void(request.getParameter("SEQ"));
String bbsId		= StringUtil.null2void(request.getParameter("BBS_ID"));
String PAGE_NUM		= StringUtil.null2void(request.getParameter("PAGE_NUM"));
String state		= StringUtil.null2void(request.getParameter("STAT"));
String b_state		= StringUtil.null2void(request.getParameter("BEFORE_STAT"));

String CHANEL_TYPE		= StringUtil.null2void(request.getParameter("CHANEL_TYPE"));
String task_nm		= StringUtil.null2void(request.getParameter("task_nm"));
String inq_type		= StringUtil.null2void(request.getParameter("inq_type"));
try{
	StringBuffer sql	= new StringBuffer();
	Map<String,String >param	= new HashMap<String,String>();
	
	param.put("BOARD_ID", 	board_id);
	param.put("BBS_ID", 	bbsId);
	param.put("SEQ", 		seq);
	/**** 
	"000" = "����";
	"111" = "�Ϸ�";
	"222" = "���";
	"333" = "�Ϸ��û";
	"444" = "���ܿ�û";
	"555" = "������û";
	"999" = "����";
	 ****/
	if("C".equals(state)){
		// �Ϸ��û
		param.put("STATE", "333");
	} else if("D".equals(state)){
		// ������û
		param.put("STATE", "555");
	} else if("E".equals(state)){
		// ���ܿ�û
		param.put("STATE", "444");
	}else if("S".equals(state)){
		// ����(ó����)
		param.put("STATE", "000");
	}else if("A".equals(state)){
		// �Ϸ� - ���� - ����
		if("333".equals(b_state))
			param.put("STATE", "111");
		else if("555".equals(b_state))
			param.put("DEL_YN", "Y");
		else if("444".equals(b_state))
			param.put("STATE", "999");
	}else if("R".equals(state)){
		// �Ϸ� - ���� - ����
		param.put("STATE", "000");
	}

	if("A".equals(state) && "333".equals(b_state)){
		qmsDB.update("QMS_BBS_LIST.BOARD_U002", param);
	} else { 
		qmsDB.update("QMS_BBS_LIST.BOARD_U001", param);
	}
}catch(Exception e){
	if (qmsDB != null) try { qmsDB.rollback(); } catch (Exception e1) {}
}finally{
	if (qmsDB != null) try { qmsDB.close(); } catch (Exception e1) {}
}
// �α��� ȭ������ �̵�
out.println("<form style='display: hidden' name='frm' action='/QMS/jsp/view/bbs/bbs_list_view.jsp' method='POST'		");
out.println("	<input type='hidden' name='PAGE_NUM' 	value='"+PAGE_NUM+"'	/>");
out.println("	<input type='hidden' name='BOARD_ID' 	value='"+board_id+"'	/>");
out.println("	<input type='hidden' name='CHANEL_TYPE' value='"+CHANEL_TYPE+"'	/>");
out.println("	<input type='hidden' name='inq_type' 	value='"+inq_type+"'	/>");
out.println("	<input type='hidden' name='task_nm' 	value='"+task_nm+"'		/>");
out.println("</form>																									");
out.println("<script type='text/javascript'>	");
out.println("	alert('���� ó�� �Ǿ����ϴ�.');	");
out.println("	var frm = document.frm;			");
out.println("	frm.target			= '_self';	");
out.println("	frm.submit();					");
// out.println("window.location.replace('/QMS/jsp/view/bbs/bbs_list_view.jsp?PAGE_NUM="+PAGE_NUM+"&BOARD_ID="+board_id+"&CHANEL_TYPE="+CHANEL_TYPE+"&task_nm="+task_nm+"&inq_type="+inq_type+"');");
out.println("</script>");
	
	
%>