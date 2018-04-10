<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR" errorPage="/jsp/comm/error.jsp" %>
<!DOCTYPE html>
<%@ page import="java.util.Enumeration"%>
<%@ page import="java.io.File"%>
<%@ page import="qms.util.*"%>
<%@ include file="/jsp/inc/inc_common.jsp" %>
<%@ include file="/jsp/inc/inc_loading.jsp" %>
<%
	

	String project_id		= userSession.getProjectID();
	String test_id			= StringUtil.null2void(request.getParameter("tsId"));
 	String scenario_nm		= StringUtil.null2void(request.getParameter("scenario_nm"));
	String start_date		= StringUtil.null2void(request.getParameter("sttg_date"));
	String end_date 		= StringUtil.null2void(request.getParameter("endg_date"));
	String scenario_id	  	= StringUtil.null2void(request.getParameter("scId"));
	
	int dbRlt=0;

	
	try{
	Map<String,String > paramU001= new HashMap<String,String>();
	
	paramU001.put("PROJECT_ID",		project_id);
	paramU001.put("TEST_ID", 		test_id);
	paramU001.put("SCENARIO_NM", 	scenario_nm);
	paramU001.put("START_DATE", 	start_date);
	paramU001.put("END_DATE", 		end_date);
	paramU001.put("SCENARIO_ID", 	scenario_id);
	paramU001.put("DEL_FLAG", 		"N");
	
	dbRlt= qmsDB.update("QMS_QUALITYCONTROL.SCENARIO_U001", paramU001);
	
	} catch (Exception e) {
		if (qmsDB != null) try { qmsDB.rollback(); } catch (Exception e1) {}
	} finally {
		if (qmsDB != null) try { qmsDB.close(); } catch (Exception e1) {}
	}
	out.println("<script type='text/javascript'>");
	if (dbRlt!=0) {
		out.println("alert('수정 되었습니다.');");
	} else {
		out.println("alert('수정에 실패하였습니다.');");	
	}
	
	out.println("location.href='/QMS/jsp/view/qcl/qcl_test_regist_view.jsp';");

	out.println("</script>");

%>