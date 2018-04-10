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
	String userId					= StringUtil.null2void(userSession.getUserID());	
	String boardID 					= StringUtil.null2void(request.getParameter("BOARD_ID"));
	String bbsID 					= StringUtil.null2void(request.getParameter("BBS_ID"));
	String seq 						= StringUtil.null2void(request.getParameter("SEQ"));
	String pageNum					= StringUtil.null2void(request.getParameter("PAGE_NUM"));
	String depth					= StringUtil.null2void(request.getParameter("DEPTH"));
	LogUtil.getInstance().debug("SAMGU-bbs_delete_do.jsp >> boardID:"+boardID+", bbsID:"+bbsID+", seq:"+seq);
	
	StringBuffer commentSql			= new StringBuffer();
	StringBuffer boardSql			= new StringBuffer();
	List<String> commentList		= new ArrayList();
	List<String> boardList			= new ArrayList();
	int commentResult				= 0;
	int boardResult					= 0;
	// 댓글지우기
	try {
		Map<String,String> paramU001 = new HashMap<String,String>();
		paramU001.put("BBS_ID", bbsID);
	
		commentResult = qmsDB.update("QMS_BBS_DETAIL.BBS_COMMENT_U003", paramU001);
	
	} catch (Exception e) { 
		if (qmsDB != null) try { qmsDB.close(); } catch (Exception e1) {}
	}

	// 게시물지우기
	try {
		Map<String,String> paramU002 = new HashMap<String,String>();
		paramU002.put("BOARD_ID",	boardID);
		paramU002.put("BBS_ID",		bbsID);
		paramU002.put("SEQ",		seq);
		paramU002.put("DEPTH",		depth);
		
		boardResult = qmsDB.update("QMS_BBS_DETAIL.BOARD_U002", paramU002);
	
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
	out.println("window.location.href='/QMS/jsp/view/bbs/bbs_noticeList_view.jsp?BOARD_ID="+boardID+"&BBS_ID="+bbsID+"&SEQ="+seq+"&PAGE_NUM="+pageNum+"';");
	out.println("</script>");

%>

<%@ include file="/jsp/inc/inc_bottom.jsp" %>