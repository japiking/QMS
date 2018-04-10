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

//���Ͼ��ε�
MultipartRequest multi	=	null;
String savePath=PropertyUtil.getInstance().getProperty("FilePath"); // ������ ���丮 (������)
int sizeLimit = 30 * 1024 * 1024 ; // 10�ް����� ���� �Ѿ�� ���ܹ߻�
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
String [] strDelFileList = null;
multi = new MultipartRequest(request, savePath, sizeLimit,"euc-kr", new DefaultFileRenamePolicy());

 strBoardId 		=	StringUtil.null2void(multi.getParameter("BOARD_ID"));
 strBbsId			=	StringUtil.null2void(multi.getParameter("BBS_ID"));
 strSeq				=	StringUtil.null2void(multi.getParameter("SEQ"));
 strTitle			= 	StringUtil.null2void(multi.getParameter("REG_TITLE"));
 strRegText			= 	StringUtil.null2void(multi.getParameter("REG_TEXT"));
 strPageNum			= 	StringUtil.null2void(multi.getParameter("PAGE_NUM"));
 strFileFlag		= StringUtil.null2void(multi.getParameter("FIEL_EXIST_YN"));	// ÷������ ���翩��
 strDelFileList			= 	multi.getParameterValues("delFile");
 int updateCount	=0;
try{
	
	
	//���� ��ϵ� ���� ������ DB����ó��
	if ( strDelFileList != null && strDelFileList.length >0 ){
		for( int i =0 ; i < strDelFileList.length; i++){
			Map<String,String> param = new HashMap<String,String>();
			param.put("BBS_ID",strBbsId);
			param.put("SEQ",""+strDelFileList[i]);
			qmsDB.update("QMS_BBS_WRITE.BBS_ATTACHMENT_U001", param);
		}
	}
	
	Map<String,String> param = new HashMap<String,String>();
	param.put("TITLE"	,String.valueOf(strTitle));
	param.put("CONTENTS",strRegText	);
	param.put("BBS_FILE",strFileFlag);
	param.put("BOARD_ID",strBoardId	);
	param.put("BBS_ID"	,strBbsId	);
	param.put("SEQ"		,String.valueOf(strSeq));
	
	updateCount	=	qmsDB.update("QMS_BBS_NOTICE.BOARD_U001", param);
}catch(Exception e){
	LogUtil.getInstance().debug(e);
	if (qmsDB != null)try {qmsDB.close();} catch (Exception e1) {}
}

//ȭ������ �̵�
out.println("<script type='text/javascript'>");
if(updateCount!=0){
	out.println("alert('�����Ϸ� �Ǿ����ϴ�.');");
}else{
	out.println("alert('������ �����Ͽ����ϴ�.');");	
}
out.println("window.location.href='/QMS/jsp/view/bbs/bbs_noticeList_view.jsp?BOARD_ID="+strBoardId+"&BBS_ID="+strBbsId+"&SEQ="+strSeq+"&PAGE_NUM="+strPageNum+"';");
out.println("</script>");

%>
</body>
</html>