<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR" errorPage="/jsp/comm/error.jsp" %>

<%@ include file="/jsp/inc/inc_common.jsp" %>

<%
	String user_id			= StringUtil.null2void(request.getParameter("USER_ID"));
	try{
		
		String rlt_text 	= new String("");
		String rlt = new String("");
		Map<String,String> param1		= new HashMap<String,String>();
		param1.put("USERID", user_id);
		
		Map<String,String> map = qmsDB.selectOne("QMS_SUPERUSER.USERINFO_R001", param1);
		rlt = StringUtil.null2void(map.get("CNT"));
		
		if("0".equals(rlt)){
			rlt_text = user_id+"는 사용하실수 있는 ID입니다.";
			out.println("<script type='text/javascript'>								");
			out.println("	alert('"+rlt_text+"');								");
			out.println("	window.parent.check_yn = 'Y';								");
			out.println("</script>														");
		}else{
			rlt_text = user_id+"는 사용하실수 없는 ID입니다.";
			out.println("<script type='text/javascript'>								");
			out.println("	alert('"+rlt_text+"');								");
			out.println("	window.parent.check_yn = 'N';								");
			out.println("</script>														");
		}
			
	} catch(Exception e){
		e.printStackTrace(System.out);
		if (qmsDB != null)
			try { qmsDB.rollback(); } catch (Exception e1) {}
	} finally{
		if (qmsDB != null)
			try { qmsDB.close(); } catch (Exception e1) {}
	}

%>