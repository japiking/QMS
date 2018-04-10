<%@page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%@page import="qms.Const"%>
<%@page import="qms.util.DateTime"%>
<%@page import="java.util.Enumeration"%>
<%@page import="java.util.Map"%>
<%@page import="qms.util.StringUtil"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="java.io.File"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Insert title here</title>
<script type="text/javascript" src="/QMS/jsp/comm/ckeditor/ckeditor.js"></script>
</head>
<%@ include file="/jsp/inc/inc_common.jsp" %>
<body>
<%
try{
	request.setCharacterEncoding("euc-kr");
	request.setAttribute(Const.ERROR_RETURN_URL, "POPUP");

	String save_date = DateTime.getInstance().getDate("yyyyMMdd");
	String save_time = DateTime.getInstance().getDate("hh24miss");
	
	String path1 = "/uploadfile/"+userSession.getUserID()+"/";
	String path2 = save_date+"/"+save_time;
	
	String file_type = request.getContentType();
	
	String savePath=PropertyUtil.getInstance().getProperty("rootPath"); // ������ ���丮 (������)
	String virPath="/QMS"; // ������ ���丮 (������)
	if(file_type.contains("image")){
		savePath = savePath + path1 +"image";
		virPath  = virPath  + path1 +"image";
	} else {
		savePath = savePath + path1 + path2;
		virPath  = virPath  + path1 + path2;
	}
	
	//���Ͼ��ε�
	MultipartRequest multi	=	null;
	
	int sizeLimit = 30 * 1024 * 1024 ; // 10�ް����� ���� �Ѿ�� ���ܹ߻�
	String fileName="";
	String originalFileName = "";
	
	// �����θ� �����.
	File desti = new File(savePath);
	if(!desti.exists()){
		desti.mkdirs(); 
	}
	
	multi = new MultipartRequest(request, savePath, sizeLimit,"euc-kr", new DefaultFileRenamePolicy());
	Enumeration formNames=multi.getFileNames();  // ���� �̸� ��ȯ
	
	String fncnum	= StringUtil.null2void(multi.getParameter("CKEditorFuncNum"));
	
	String fileInput = "";
    String type = "";
    File fileObj = null;
    String originFileName = "";    
    String fileExtend = "";
    String fileSize = "";
	if(formNames.hasMoreElements()) {  	// ������ ���ε� ���� �ʾ�����
    
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
	        }
		}
	}
	virPath = virPath+"/"+originFileName;

	out.print("<script type='text/javascript'>																				");
	out.print("		window.onload=function(){																				");
	out.print("			window.parent.CKEDITOR.tools.callFunction("+fncnum+", '"+virPath+"', '���� �Ϸ�Ǿ����ϴ�.');		");
	out.print("		}																										");
	out.print("</script>");
} catch(Exception e){
	e.printStackTrace(System.out);
}
%>
</body>
</html>