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


String save_date = DateTime.getInstance().getDate("yyyyMMdd");
String save_time = DateTime.getInstance().getDate("hh24miss");

String path = "/uploadfile/"+userSession.getUserID()+"/"+save_date+"/"+save_time;

//���Ͼ��ε�
MultipartRequest multi	=	null;
String savePath=PropertyUtil.getInstance().getProperty("rootPath")+path; // ������ ���丮 (������)
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
strFileFlag="Y";

File desti = new File(savePath);

if(!desti.exists()){
	desti.mkdirs(); 
}

multi = new MultipartRequest(request, savePath, sizeLimit,"euc-kr", new DefaultFileRenamePolicy());
Enumeration formNames=multi.getFileNames();  // ���� �̸� ��ȯ
//String formName=(String)formNames.nextElement();

strBoardId 			=	StringUtil.null2void(multi.getParameter("BOARD_ID"));
strBbsId			=	StringUtil.null2void(multi.getParameter("BBS_ID"));
strSeq				=	StringUtil.null2void(multi.getParameter("SEQ"));
strTitle			= 	StringUtil.null2void(multi.getParameter("REG_TITLE"));
strRegText			= 	StringUtil.null2void(multi.getParameter("REG_TEXT"));
strPageNum			= 	StringUtil.null2void(multi.getParameter("PAGE_NUM"));
strFileFlag			= StringUtil.null2void(multi.getParameter("FIEL_EXIST_YN"));	// ÷������ ���翩��
strDelFileList			= 	multi.getParameterValues("delFile");
int updateCount = 0;
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
	if("Y".equals(strFileFlag)){
		if(formNames.hasMoreElements()) {  	// ������ ���ε� ���� �ʾ�����
			strFileFlag="Y";
			String fileInput = "";
		    String type = "";
		    File fileObj = null;
		    String originFileName = "";    
		    String fileExtend = "";
		    String fileSize = "";
			int seq = 1;	
		
			while(formNames.hasMoreElements()) {	

				fileInput = (String)formNames.nextElement();                		// ������ǲ �̸�
		        fileName = multi.getFilesystemName(fileInput);            			// ���ϸ�
		        if (fileName != null) {
		             type = multi.getContentType(fileInput);                   		//����ƮŸ��    
		             fileObj = multi.getFile(fileInput);                        	//���ϰ�ü
		             originFileName = multi.getOriginalFileName(fileInput);     	//�ʱ� ���ϸ�
		             fileExtend = fileName.substring(fileName.lastIndexOf(".")+1); 	//���� Ȯ����
		             fileSize = String.valueOf(fileObj.length());               	// ����ũ��
		             
		             LogUtil.getInstance().debug("����ƮŸ��----["+type+"]");
		             LogUtil.getInstance().debug("�ʱ� ���ϸ�---["+originFileName+"]");
		             LogUtil.getInstance().debug("���� Ȯ����---["+fileExtend+"]");
		             LogUtil.getInstance().debug("����ũ��------["+fileSize+"]");
		             
		             /* Map<String,String> param	=	new HashMap<String,String>();
		             param.put("BBS_ID",strBoardId);
		             
		             int dbRlt1	=	qmsDB.delete("QMS_BBS_NOTICE.BBS_ATTACHMENT_D001", param);
		             */ 
		             Map<String,String> param2	=	new HashMap<String,String>();
		             param2.put("BBS_ID"	,	strBbsId			);
		             param2.put("SEQ"		,	String.valueOf(seq)	);
		             param2.put("FILE_NAME"	,	originFileName		);
		             param2.put("FILE_PATH"	,	"/QMS"+path			);
		             
		             int dbRlt2 =	qmsDB.insert("QMS_BBS_NOTICE.BBS_ATTACHMENT_C001", param2);
					
					 seq++;
		        }
			}
		}
	}
	 Map<String,String> param3	=	new HashMap<String,String>();
	 param3.put("TITLE"		,strTitle);
	 param3.put("CONTENTS"	,strRegText);
	 param3.put("BBS_FILE"	,strFileFlag);
	 param3.put("BOARD_ID"	,strBoardId);
	 param3.put("BBS_ID"	,strBbsId);
	 param3.put("SEQ"		,strSeq);
	
	 updateCount	=	qmsDB.insert("QMS_BBS_NOTICE.BOARD_U001", param3);
	  
}catch(Exception e){
	LogUtil.getInstance().debug(e);
	if (qmsDB != null){
		try {qmsDB.close();} catch (Exception e1) {}
	}
}finally{
	if (qmsDB != null){
       try { qmsDB.close(); } catch (Exception e1) {}
	}
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