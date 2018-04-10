<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR" errorPage="/jsp/comm/error.jsp" %>

<%@ include file="/jsp/inc/inc_common.jsp" %>

<%
	String user_id			= StringUtil.null2void(request.getParameter("test_id"));
	try{
		
		String rlt_text 				= new String("");
		String rlt 						= new String("");
		Map<String,String> param1		= new HashMap<String,String>();
		param1.put("TEST_ID", user_id);
		
		try{
			Map<String,String> map 		= qmsDB.selectOne("QMS_QUALITYCONTROL.TEST_MANAGEMENT_R002", param1);
			rlt 						= StringUtil.null2void(map.get("TEST_ID"));
		}catch(Exception e1){
			rlt = "";	
		}
		
		if("".equals(rlt)){
			rlt_text = user_id+"는 사용하실수 있는 ID입니다.";
		}else{
			rlt_text = user_id+"는 사용하실수 없는 ID입니다.";
		}
			
		out.println("<script type='text/javascript'>								");
		out.println("	alert('"+rlt_text+"');								");
	//	out.println("	location.href='/QMS/jsp/view/qcl/qcl_test_mng_view.jsp';	");
		out.println(" window.close();");
		out.println("</script>														");
		
	} catch(Exception e){
		e.printStackTrace(System.out);
		if (qmsDB != null)
			try { qmsDB.rollback(); } catch (Exception e1) {}
	} finally{
		if (qmsDB != null)
			try { qmsDB.close(); } catch (Exception e1) {}
	}

%>