<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR" errorPage="/jsp/comm/error.jsp" %>

<%@ include file="/jsp/inc/inc_common.jsp" %>

<%
	String prj_id			= StringUtil.null2void(request.getParameter("PROJECT_ID"));
	String proc_gbn			= StringUtil.null2void(request.getParameter("PROC_GBN"));

	try{
		
		StringBuffer sql	= new StringBuffer();
		
		if("D".equals(proc_gbn)){
			// 프로젝터 정보 삭제
			StringBuffer sql1	= new StringBuffer();
			Map<String,String> param1	= new HashMap<String,String>();
			param1.put("PROJECTID", 	prj_id);
			
			int dbRlt1		= qmsDB.delete("QMS_SUPERUSER.PROJECTINFO_D001",	param1);
			int dbRlt2		= qmsDB.delete("QMS_SUPERUSER.PROJECTUSERINFO_D001",param1);
			int dbRlt3		= qmsDB.delete("QMS_SUPERUSER.MENU_D001",			param1);
		}
		
			
		out.println("<script type='text/javascript'>								");
		out.println("	alert('정상 처리 되었습니다.');								");
		out.println("	location.href='/QMS/jsp/view/mng/mng_projectMng_view.jsp';	");
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