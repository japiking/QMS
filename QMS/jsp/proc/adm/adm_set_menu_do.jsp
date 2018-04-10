<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ include file="/jsp/inc/inc_common.jsp" %>
<%

boolean DbFlag = true;

int count = Integer.parseInt(StringUtil.null2void(request.getParameter("count"), "0"));
String strProjectID = StringUtil.null2void(request.getParameter("PROJECT_ID"), "");


try{
	List<Map<String,String>> statMaplist  = null;
	DBSeqUtil DButil = new DBSeqUtil();

	Map<String,String> param =  new HashMap<String,String>();
	param.put("PROJECT_ID", strProjectID);
	statMaplist = qmsDB.selectList("QMS_ADMIN.MENU_R002",param);
	
	
for(int i =0 ; i<count; i++){
	
	String strTypeId	=	StringUtil.null2void(request.getParameter("typeid"+i),"");
	String strTypeName	=	StringUtil.null2void(request.getParameter("typename"+i),"");
	String strBoard		=	StringUtil.null2void(request.getParameter("board"+i),"");
	String strMenuName	=	StringUtil.null2void(request.getParameter("menuname"+i),"");
	String strAuthVal	=	StringUtil.null2void(request.getParameter("authval"+i),"");
	
	LogUtil.getInstance().debug("/jsp/proc/adm/adm_set_menu_do.jsp--->"+strTypeId+":"+strTypeName+":"+strBoard+":"+strMenuName);
	
	if(!"".equals(strBoard) && null != strBoard){	//기존메뉴 여부 체크 후 수정및 삭제
		
			Map<String,String> param2 = new HashMap<String,String>();
				
			param2.put("SEQ",""+(i+1));
			param2.put("KOR_MENU_NAME",strMenuName);
			param2.put("USE_FLAG","Y");
			param2.put("AUTHORITYGRADE",strAuthVal);
			param2.put("BOARD_ID",strBoard);
			param2.put("PROJECT_ID",strProjectID);
			
			int updatStat = qmsDB.update("QMS_ADMIN.MENU_U001", param2);

	}else{
		
		Map<String,String> param3 = new HashMap<String,String>();
		
		param3.put("PROJECT_ID",strProjectID);
		param3.put("BOARD_ID",DButil.getBoardId());
		param3.put("SORT_SEQ",""+(i+1));
		param3.put("MENU_TYPE_ID",strTypeId);
		param3.put("USE_FLAG","Y");
		param3.put("KOR_MENU_NAME",strMenuName);
		param3.put("AUTHORITYGRADE",strAuthVal);
		
		int insertstat = qmsDB.insert("QMS_ADMIN.MENU_I001", param3);
		
	}

}

	//삭제여부체크
	for(int i=0 ; i<statMaplist.size(); i++){
		StringBuffer sqlupdate = new StringBuffer();
		List<String> statsParamList1	= new ArrayList();		
		Object[] statsParam1	= null;
		String flag = "N";
		
		for(int j =0 ; j<count; j++){
			String strBoard		=	StringUtil.null2void(request.getParameter("board"+j),"");
			if(!"".equals(strBoard) && null != strBoard){				
				
				if(strBoard.trim().equals(statMaplist.get(i).get("BOARD_ID"))){
					flag = "Y";	// 일치하는 ID가 없다.
					break;
				}
			}
		}
		
		if("N".equals(flag)){
			Map<String,String> param4 = new HashMap<String,String>();
			
			param4.put("BOARD_ID",statMaplist.get(i).get("BOARD_ID"));
			param4.put("PROJECT_ID",statMaplist.get(i).get("PROJECT_ID"));
			
			int updatStat = qmsDB.update("QMS_ADMIN.MENU_U002",param4);
		}
	}

		// 메뉴정보 로드
		Map<String,String> param5 = new HashMap<String,String>();
		param5.put("PROJECT_ID",userSession.getProjectID());
		param5.put("USERID",userSession.getUserID());
	
		List<Map<String,String>> menu_info = qmsDB.selectList("QMS_ADMIN.MENU_R003", param5);
		
		session.setAttribute(Const.QMS_SESSION_MENU, menu_info);		// 메뉴정보를 세션에 저장한다.                                                	
}catch(Exception e){
	LogUtil.getInstance().debug("error::/QMS/jsp/proc/adm/adm_set_menu_do.jsp"+e);
	DbFlag = false;
	if (qmsDB != null){
        try { qmsDB.close(); } catch (Exception e1) {}
	}
}finally{
	if (qmsDB != null){
        try { qmsDB.close(); } catch (Exception e1) {}
	}
}

	//화면으로 이동
	out.println("<script type='text/javascript'>");
	if(DbFlag){
		out.println("alert('정상등록 되었습니다.');");
	}else{
		out.println("alert('등록이 실패하였습니다.');");	
	}
	//out.println("opener.uf_inq('0');");                      // 처리 후 화면 리플레시 처리
	//out.println("window.location.replace('/QMS/jsp/view/bbs/bbs_list_view.jsp');");
	out.println("location.href='/QMS/jsp/view/adm/adm_set_menu_view.jsp?PROJECT_ID="+strProjectID+"';");
	out.println("</script>");




%>
