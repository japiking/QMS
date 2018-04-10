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
	
	String savePath=PropertyUtil.getInstance().getProperty("rootPath"); // 저장할 디렉토리 (절대경로)
	String virPath="/QMS"; // 저장할 디렉토리 (가상경로)
	if(file_type.contains("image")){
		savePath = savePath + path1 +"image";
		virPath  = virPath  + path1 +"image";
	} else {
		savePath = savePath + path1 + path2;
		virPath  = virPath  + path1 + path2;
	}
	
	//파일업로드
	MultipartRequest multi	=	null;
	
	int sizeLimit = 30 * 1024 * 1024 ; // 10메가까지 제한 넘어서면 예외발생
	String fileName="";
	String originalFileName = "";
	
	// 저장경로를 만든다.
	File desti = new File(savePath);
	if(!desti.exists()){
		desti.mkdirs(); 
	}
	
	multi = new MultipartRequest(request, savePath, sizeLimit,"euc-kr", new DefaultFileRenamePolicy());
	Enumeration formNames=multi.getFileNames();  // 폼의 이름 반환
	
	String fncnum	= StringUtil.null2void(multi.getParameter("CKEditorFuncNum"));
	
	String fileInput = "";
    String type = "";
    File fileObj = null;
    String originFileName = "";    
    String fileExtend = "";
    String fileSize = "";
	if(formNames.hasMoreElements()) {  	// 파일이 업로드 되지 않았을때
    
		while(formNames.hasMoreElements()) {
			fileInput = (String)formNames.nextElement();                		// 파일인풋 이름
	        fileName = multi.getFilesystemName(fileInput);            			// 파일명
	        if (fileName != null) {
	             type = multi.getContentType(fileInput);                   		//콘텐트타입    
	             fileObj = multi.getFile(fileInput);                        	//파일객체
	             originFileName = multi.getOriginalFileName(fileInput);     	//초기 파일명
	             fileExtend = fileName.substring(fileName.lastIndexOf(".")+1); 	//파일 확장자
	             fileSize = String.valueOf(fileObj.length());               	// 파일크기
	             
	             LogUtil.getInstance().debug("콘텐트타입----["+type+"]");
	             LogUtil.getInstance().debug("초기 파일명---["+originFileName+"]");
	             LogUtil.getInstance().debug("파일 확장자---["+fileExtend+"]");
	             LogUtil.getInstance().debug("파일크기------["+fileSize+"]");
	        }
		}
	}
	virPath = virPath+"/"+originFileName;

	out.print("<script type='text/javascript'>																				");
	out.print("		window.onload=function(){																				");
	out.print("			window.parent.CKEDITOR.tools.callFunction("+fncnum+", '"+virPath+"', '전송 완료되었습니다.');		");
	out.print("		}																										");
	out.print("</script>");
} catch(Exception e){
	e.printStackTrace(System.out);
}
%>
</body>
</html>