<%@page import="java.util.Enumeration"%>
<%@page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%@page import="qms.session.UserSession"%>
<%@page import="java.util.Map"%>
<%@page import="qms.util.StringUtil"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="java.io.File"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<title>Insert title here</title>
</head>
<body>
<%@ include file="/jsp/inc/inc_common.jsp" %>
<%@ include file="/jsp/inc/inc_loading.jsp" %>
<%
request.setCharacterEncoding("euc-kr");

//파일업로드
MultipartRequest multi	=	null;
String savePath=PropertyUtil.getInstance().getProperty("FilePath"); // 저장할 디렉토리 (절대경로)
int sizeLimit = 30 * 1024 * 1024 ; // 10메가까지 제한 넘어서면 예외발생
String fileName="";
String originalFileName = "";
String strFileFlag ="";


String strBoardId		="";
String strBbsId			="";
String strSeq			="";
String strTitle			="";
String strRegText		="";
String strStat			="";
String strPageNum		="";
String strChanlName		="";
String strCmptDate1		="";
String confirm_user		="";
String strCmptDate2		="";

String [] strDelFileList = null;
multi = new MultipartRequest(request, savePath, sizeLimit,"euc-kr", new DefaultFileRenamePolicy());

 strBoardId 		=	StringUtil.null2void(multi.getParameter("BOARD_ID"));
 strBbsId			=	StringUtil.null2void(multi.getParameter("BBS_ID"));
 strSeq				=	StringUtil.null2void(multi.getParameter("SEQ"));
 strTitle			= 	StringUtil.null2void(multi.getParameter("REG_TITLE"));
 strRegText			= 	StringUtil.null2void(multi.getParameter("REG_TEXT"));
 strPageNum			= 	StringUtil.null2void(multi.getParameter("PAGE_NUM"));
 strFileFlag		= StringUtil.null2void(multi.getParameter("FIEL_EXIST_YN"));// 첨부파일 존재여부
 strChanlName		= StringUtil.null2void(multi.getParameter("CHANEL_NAME"));	//
 strCmptDate2		= StringUtil.null2void(multi.getParameter("INQ_DATE1"));	// 완료예정일
 strCmptDate1		= StringUtil.null2void(multi.getParameter("CMPT_DATE1"));	//
 confirm_user		= StringUtil.null2void(multi.getParameter("CONFIRM_USER_PROC")); // 확인자
 int updateCount = 0;
 strDelFileList		= 	multi.getParameterValues("delFile");
 try{
	 if ( strDelFileList != null && strDelFileList.length >0 ){
			for( int i =0 ; i < strDelFileList.length; i++){
				LogUtil.getInstance().debug("strDelFileList[i]  ::  "+strDelFileList[i]);
				Map<String,String> param = new HashMap<String,String>();
				param.put("BBS_ID",strBbsId);
				param.put("SEQ",""+strDelFileList[i]);
				qmsDB.update("QMS_BBS_WRITE.BBS_ATTACHMENT_U001", param);
			}
		}
	 Map<String,String> param = new HashMap<String,String>();
	 
	 param.put("TITLE",strTitle);
	 param.put("CONTENTS",strRegText);
	 param.put("BBS_FILE",strFileFlag);
	 param.put("CHANEL_NAME",strChanlName);
	 param.put("BOARD_ID",strBoardId);
	 param.put("BBS_ID",strBbsId);
	 param.put("SEQ",			strSeq);	
	 param.put("COMPLETE_DATE",	strCmptDate1);		// 완료일
	 param.put("CONFIRM_USER",		confirm_user);	// 확인자
	 param.put("COMPLETION_DATE",	strCmptDate2);	// 완료예정일
	 
	 
	 updateCount	= qmsDB.update("QMS_BBS_WRITE.BOARD_U001", param);
	 
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

//화면으로 이동
out.println("<script type='text/javascript'>");
if(updateCount!=0){
	out.println("alert('수정완료 되었습니다.');");
}else{
	out.println("alert('수정이 실패하였습니다.');");	
}
out.println("window.location.href='/QMS/jsp/view/bbs/bbs_list_view.jsp?BOARD_ID="+strBoardId+"&BBS_ID="+strBbsId+"&SEQ="+strSeq+"&PAGE_NUM="+strPageNum+"';");
out.println("</script>");

%>
</body>
</html>