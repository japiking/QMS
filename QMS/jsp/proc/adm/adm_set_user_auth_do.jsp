<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ include file="/jsp/inc/inc_common.jsp"%>
<%
	boolean checkFlag = false;
	int count = Integer.parseInt(StringUtil.null2void(request.getParameter("count"), "0"));
	String strProjectID = StringUtil.null2void(request.getParameter("PROJECTID"), "");

	List<Map<String, String>> statMaplist = null;
	String strErrorUserId = "";
	try {
		
		Map<String,String> param = new HashMap<String,String>();
		param.put("PROJECTID", strProjectID);

		statMaplist = qmsDB.selectList("QMS_ADMIN.PROJECTUSERINFO_R003", param);

		int upCount = 0; //등급변경자 성공 횟수

		for (int i = 0; i < count; i++) {
			String strUserId 	= StringUtil.null2void(request.getParameter("userid" + i)	, "");
			String strUserName 	= StringUtil.null2void(request.getParameter("username" + i)	, "");
			String strAuthval 	= StringUtil.null2void(request.getParameter("authval" + i)	, "");
			String strqsllist 	= StringUtil.null2void(request.getParameter("qsllist" + i)	, "");	//삭제여부 체크
			Map<String,String> param2 = new HashMap<String,String>();
			param2.put("AUTHORITYGRADE",strAuthval);
			param2.put("USERID",strUserId);
			param2.put("PROJECTID",strProjectID);
			int updatStat = qmsDB.update("QMS_ADMIN.PROJECTUSERINFO_U001", param2);
			if( updatStat != 1){
				if("".equals(strErrorUserId)){
					strErrorUserId = strUserId;
				}else{
					strErrorUserId = ", "+ strUserId;
				}
			}
			upCount+=updatStat;
		}
		if(count == upCount )
		checkFlag = true;
	} catch (Exception e) {
		LogUtil.getInstance().debug("/QMS/jsp/proc/adm/adm_set_user_auth_do.jsp");
		checkFlag = false;
		e.printStackTrace(System.out);
		if (qmsDB != null){
	        try { qmsDB.rollback(); } catch (Exception e1) {}
		}
	}finally{
		if (qmsDB != null){
	        try { qmsDB.close(); } catch (Exception e1) {}
		}
	}

	//화면으로 이동
	out.println("<script type='text/javascript'>");
	if (checkFlag) {
		out.println("alert('정상 등록 되었습니다.');");
	} else {
		out.println("alert('등록이 실패하였습니다. "+strErrorUserId+"');");
	}
	//out.println("opener.uf_inq('0');");                      // 처리 후 화면 리플레시 처리
	//out.println("window.location.replace('/QMS/jsp/view/bbs/bbs_list_view.jsp');");
	out.println("location.href='/QMS/jsp/view/adm/adm_set_user_auth_view.jsp?PROJECT_ID="
			+ strProjectID + "';");
	out.println("</script>");
%>
