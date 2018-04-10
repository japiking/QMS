<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
    
<%@ include file="/jsp/inc/inc_common.jsp" %>
<%@ include file="/jsp/inc/inc_header.jsp" %>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="qms.util.StringUtil"%>
<%

	String referer					= request.getHeader("referer");
	String returnUrl				= "/" + referer.substring(referer.indexOf("QMS"));
	String userId					= StringUtil.null2void(userSession.getUserID());	
	String boardID 					= StringUtil.null2void(request.getParameter("BOARD_ID"));
	String bbsID 					= StringUtil.null2void(request.getParameter("BBS_ID"));
	String seq 						= StringUtil.null2void(request.getParameter("SEQ"));
	String contents 				= StringUtil.null2void(request.getParameter("CONTENTS"));
	String pageNum					= StringUtil.null2void(request.getParameter("PAGE_NUM"));
	String depth					= StringUtil.null2void(request.getParameter("DEPTH"));
	int result 						= 0;
	if (referer.indexOf(".jsp") >-1) referer = referer.substring(0, referer.indexOf(".jsp") + 4);
//	LogUtil.getInstance().debug("SAMGU :: >>> " + referer);
//	LogUtil.getInstance().debug("SAMGU bbs_comment_do boardID:" +boardID+ ", bbsID:"+ bbsID +", seq:"+ seq +", depth:"+ depth );

	// 화면으로 이동
	out.println("<script type='text/javascript'>");
	if(!"".equals(contents)){
		
		// 댓글 내용 저장
		try {
			Map<String,String> paramC001 = new HashMap<String,String>();
			paramC001.put("BBS_ID",			bbsID);
			paramC001.put("COMMENT_ID",		DBSeqUtil.getCommentId());
			paramC001.put("CONTENTS",		contents);
			paramC001.put("COMMENT_USER",	userId);
			
			result = qmsDB.insert("QMS_BBS_DETAIL.BOARD_C001", paramC001);
		} catch (Exception e) {
			if (qmsDB != null) try { qmsDB.close(); } catch (Exception e1) {}
			LogUtil.getInstance().info("댓글 내용 저장 query error : " + e.toString());
		} finally {
			if (qmsDB != null) try { qmsDB.close(); } catch (Exception e1) {}
		}
		
		if (result!=0) {
			out.println("alert('댓글이 완료 되었습니다.');");
		} else {
			out.println("alert('댓글 작성에 실패하였습니다.');");	
		}
	} else {
		out.println("alert('댓글의 내용이 없습니다.');");
	}
	
	
	// out.println("opener.uf_inq('0');");  
	LogUtil.getInstance().debug("bbs_comment_do.jsp >> depth	: " + depth);
	out.println("window.location.href='"+returnUrl+"?BOARD_ID="+boardID+"&BBS_ID="+bbsID+"&SEQ="+seq+"&PAGE_NUM="+pageNum+"&DEPTH="+depth+"';");
	LogUtil.getInstance().debug("sssss >>"+returnUrl);
	
	LogUtil.getInstance().debug("window.location.href='"+returnUrl+"?BOARD_ID="+boardID+"&BBS_ID="+bbsID+"&SEQ="+seq+"&PAGE_NUM="+pageNum+"&DEPTH="+depth+"';");
	out.println("</script>");

%>

<%@ include file="/jsp/inc/inc_bottom.jsp" %>