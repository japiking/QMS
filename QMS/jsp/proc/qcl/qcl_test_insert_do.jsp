<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR" errorPage="/jsp/comm/error.jsp" %>

<%@ include file="/jsp/inc/inc_common.jsp" %>

<%
	String test_id			= StringUtil.null2void(request.getParameter("test_id"));
	String test_nm			= StringUtil.null2void(request.getParameter("test_nm"));
	String test_sttg_date	= StringUtil.null2void(request.getParameter("test_sttg_date"));
	String test_endg_date 	= StringUtil.null2void(request.getParameter("test_endg_date"));
	String test_bigo	  	= StringUtil.null2void(request.getParameter("test_bigo"));
	String project_id		= userSession.getProjectID();
	int insertData=0;
	
	try{
		
		//seq 생성
		Map<String,String> param=new HashMap<String,String>();
		
		param.put("TEST_ID", test_id);
		param.put("PROJECT_ID",project_id);
		param.put("TEST_NM", test_nm);
		param.put("TEST_STTG_DATE", test_sttg_date);
		param.put("TEST_ENDG_DATE", test_endg_date);
		param.put("TEST_BIGO", test_bigo);
		param.put("DEL_FLAG", "N");
		
		insertData = qmsDB.insert("QMS_QUALITYCONTROL.TEST_MANAGEMENT_C001",param);
		
	} catch(Exception e){
		out.println("<script type='text/javascript'>			");
		out.println("	alert('처리중 오류가 발생하였습니다.');	");
		out.println("</script>									");
		e.printStackTrace(System.out);
		if (qmsDB != null)
			try { qmsDB.rollback(); } catch (Exception e1) {}
	} finally{
		if (qmsDB != null)
			try { qmsDB.close(); } catch (Exception e1) {}
	}
	out.println("<script type='text/javascript'>				");
	out.println("	location.href='/QMS/jsp/view/qcl/qcl_test_mng_view.jsp';");
	out.println("</script>										");
%>