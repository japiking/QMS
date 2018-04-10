<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
    
<%@ include file="/jsp/inc/inc_common.jsp" %>
<%@ include file="/jsp/inc/inc_header.jsp" %>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="qms.util.StringUtil"%>
<%@ include file="/jsp/inc/inc_loading.jsp" %>
<%
	String referer					= request.getHeader("referer");
	String returnUrl				= "/" + referer.substring(referer.indexOf("QMS"));
	String userId					= StringUtil.null2void(userSession.getUserID());	
	String boardID 					= StringUtil.null2void(request.getParameter("BOARD_ID"));
	String bbsID 					= StringUtil.null2void(request.getParameter("BBS_ID"));
	String pageNum					= StringUtil.null2void(request.getParameter("PAGE_NUM"));
	
	LogUtil.getInstance().debug("SAMGU-bbs_oneRowList_delete_do.jsp >> boardID:"+boardID+", bbsID:"+bbsID);
	
	StringBuffer commentSql			= new StringBuffer();
	StringBuffer boardSql			= new StringBuffer();
	List<String> commentList		= new ArrayList<String>();
	List<String> boardList			= new ArrayList<String>();
	int boardResult					= 0;
	// 한줄 게시물 지우기
	try {
		Map paramU002 = new HashMap<String,String>();
		paramU002.put("BOARD_ID",	boardID);
		paramU002.put("BBS_ID",		bbsID);
		
		boardResult = qmsDB.update("QMS_BBS_ONELOW.BOARD_U002", paramU002);
	} catch (Exception e) {
		if (qmsDB != null) try { qmsDB.close(); } catch (Exception e1) {} 
	}

	
	out.println("<script type='text/javascript'>");
	if (boardResult!=0) {
		out.println("alert('삭제 완료가 되었습니다.');");
	} else {
		out.println("alert('삭제에 실패하였습니다.');");	
	}
	
	
	//out.println("opener.uf_inq('0');");
	out.println("window.location.href='"+returnUrl+"';");
	out.println("</script>");

%>

<%@ include file="/jsp/inc/inc_bottom.jsp" %>