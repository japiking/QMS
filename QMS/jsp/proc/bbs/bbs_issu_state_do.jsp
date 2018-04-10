<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ include file="/jsp/inc/inc_common.jsp" %>
<%

int state 				=	0;
String strProjectID 	=	StringUtil.null2void(request.getParameter("PROJECT_ID"));
String strBoardI 		=	StringUtil.null2void(request.getParameter("BOARD_ID"));
String strBbsId 		=	StringUtil.null2void(request.getParameter("BBS_ID"));
String strSeq 			=	StringUtil.null2void(request.getParameter("SEQ"));
String strPageNm		=	StringUtil.null2void(request.getParameter("PAGE_NUM"));
String strState			=	StringUtil.null2void(request.getParameter("STATE"));

LogUtil.getInstance().debug("jsp/view/bbs/bbs_issu_view.jsp"+strBoardI+"::"+strBbsId+"::"+strSeq+"::"+strPageNm+"::"+strState);
try{
	Map<String,String> param = new HashMap<String,String>();
	param.put("STATE",strState);
	param.put("BOARD_ID",strBoardI);
	param.put("BBS_ID",strBbsId);
	param.put("SEQ",strSeq);
	
	if("002".equals(strState) || "999".equals(strState)){
		state	=	qmsDB.update("QMS_BBS_ISSU.BOARD_U002", param);
	}else{
		state	=	qmsDB.update("QMS_BBS_ISSU.BOARD_U001", param);
	}
	
}catch(Exception e){
	
	LogUtil.getInstance().debug("error::/QMS/jsp/proc/bbs/bbs_issu_state_do.jsp"+e);
	if (qmsDB != null) try { qmsDB.rollback(); } catch (Exception e1) {}
}finally{
	if (qmsDB != null) try { qmsDB.close(); } catch (Exception e1) {}
}

	//화면으로 이동
	out.println("<script type='text/javascript'>");
	if(state==1){
		out.println("alert('상태변경이 되었습니다.');");
	}else{
		out.println("alert('상태변경이 실패하였습니다.');");	
	}
	//out.println("opener.uf_inq('0');");                      // 처리 후 화면 리플레시 처리
	//out.println("window.location.replace('/QMS/jsp/view/bbs/bbs_list_view.jsp');");
	out.println("location.href='/QMS/jsp/view/bbs/bbs_issu_view.jsp?BOARD_ID="+strBoardI+"';");
	out.println("</script>");

%>
