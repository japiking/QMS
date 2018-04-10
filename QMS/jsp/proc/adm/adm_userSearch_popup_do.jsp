<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@page import="java.net.URLDecoder"%>
<%@ include file="/jsp/inc/inc_common.jsp"%>
<%
String strIdSearch		=	URLDecoder.decode(request.getParameter("ipSearch"), "UTF-8");
String strflag 			=	request.getParameter("flag");
String strProject		=	request.getParameter("projectId");
int count =0;
Map<String,String> statsMap = null;
Map<String,String> statsMap1 = new HashMap<String,String>();
if("1".equals(strflag.trim())){
	try{
		
		Map<String,String> param	 =	new HashMap<String,String>();

		param.put("PROJECTID",strProject);
		param.put("USERID",strIdSearch);
		
		statsMap	= qmsDB.selectOne("QMS_ADMIN.PROJECTUSERINFO_R002",param);
	
		count  = Integer.parseInt(StringUtil.null2void(statsMap.get("CNT"),"0"));
	}catch(Exception e){
		e.printStackTrace(System.out);
		if (qmsDB != null){
	        try { qmsDB.close(); } catch (Exception e1) {}
		}
	}
	if(count>0){
	%>
		[{"msg":"사용자등급에 추가된 ID 입니다."}]
	<%
	}else{
		try{
			Map<String,String> param2	=	new HashMap<String,String>();
			param2.put("USERID",strIdSearch);
			
			statsMap1	= (Map)qmsDB.selectOne("QMS_ADMIN.USERINFO_R002",param2);
		
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
	%>
		[{
		"userId":"<%=statsMap1.get("USERID")%>",
		"userName":"<%=statsMap1.get("USERNAME")%>"
		}]	
<%
	}//end if
}
%>
<%if (qmsDB != null) try { qmsDB.close(); } catch (Exception e1) {}  %>

		

