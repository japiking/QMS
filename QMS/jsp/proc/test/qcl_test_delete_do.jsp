<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR" errorPage="/jsp/comm/error.jsp" %>
<!DOCTYPE html>
<%@ page import="java.util.Enumeration"%>
<%@ page import="java.io.File"%>
<%@ page import="qms.util.*"%>
<%@ include file="/jsp/inc/inc_common.jsp" %>
<%@ include file="/jsp/inc/inc_loading.jsp" %>
<%	
	String test_id			= StringUtil.null2void(request.getParameter("TEST_ID"));
	String project_id		= userSession.getProjectID();
	
	int DBrlt = 0;
	try{
		Map<String,String> paramD001 = new HashMap<String,String>();
		paramD001.put("TEST_ID", test_id);
		paramD001.put("PROJECT_ID", project_id);
		
		DBrlt 				= qmsDB.update("QMS_QUALITYCONTROL.TEST_MANAGEMENT_U002", paramD001);
		
		
	}catch (Exception e) {
			if (qmsDB != null) try { qmsDB.rollback(); } catch (Exception e1) {} 
	}finally{
		if (qmsDB != null) try { qmsDB.close(); } catch (Exception e1) {}
	}

		
		out.println("<script type='text/javascript'>");
		if (DBrlt!=0) {
			out.println("alert('삭제 완료가 되었습니다.');");
		} else {
			out.println("alert('삭제에 실패하였습니다.');");	
		}
		
		
		out.println("	location.href='/QMS/jsp/view/def/test_mng_view.jsp';	");
		out.println("</script>");

	%>

	<%@ include file="/jsp/inc/inc_bottom.jsp" %>