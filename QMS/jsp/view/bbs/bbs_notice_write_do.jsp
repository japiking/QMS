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
<%@ include file="/jsp/inc/inc_common.jsp" %>
<%@ include file="/jsp/inc/inc_header.jsp"%>
<%
try {
	request.setCharacterEncoding("euc-kr");
	DBSeqUtil DButil = new DBSeqUtil();
	request.setAttribute(Const.ERROR_RETURN_URL, "POPUP");
	int updateCount	=0 ; //DB거래 성공여부
	String save_date = DateTime.getInstance().getDate("yyyyMMdd");
	String save_time = DateTime.getInstance().getDate("hh24miss");
	
	String path = "/uploadfile/"+userSession.getUserID()+"/"+save_date+"/"+save_time;
	
	//파일업로드
	MultipartRequest multi	=	null;
	String savePath=PropertyUtil.getInstance().getProperty("rootPath")+path; // 저장할 디렉토리 (절대경로)
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
	
	String strTitle			= StringUtil.null2void(multi.getParameter("REG_TITLE"));
	String strRegText		= StringUtil.null2void(multi.getParameter("REG_TEXT"));
	String strUserId		= StringUtil.null2void(userSession.getUserID());
	String strStat			= StringUtil.null2void(multi.getParameter("STAT"));         
	String strBoardId		= StringUtil.null2void(multi.getParameter("BOARD_ID"));     
	String strFileFlag		= StringUtil.null2void(multi.getParameter("FIEL_EXIST_YN"));	// 첨부파일 존재여부
	String strSEQ			= StringUtil.null2void(multi.getParameter("SEQ"));
	String today			= DateTime.getInstance().getDate("yyyy-mm-dd");						//오늘날자
	String strBbsId			= StringUtil.null2void(DButil.getBbsId());
	Map<String,String> paramC002 = null;
	// 첨부파일 존재여부 체크 
	if("Y".equals(strFileFlag)){
		if(formNames.hasMoreElements()) {  	// 파일이 업로드 되지 않았을때
			strFileFlag="Y";
			String fileInput = "";
		    String type = "";
		    File fileObj = null;
		    String originFileName = "";    
		    String fileExtend = "";
		    String fileSize = "";
			int seq = 1;	
	    
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
		              
					// 첨부파일정보 입력
					try {
						Map<String,String> paramC001 = new HashMap<String,String>();
						paramC001.put("BBS_ID",		strBbsId);
						paramC001.put("SEQ",		Integer.toString(seq));
						paramC001.put("FILE_NAME",	originFileName);
						paramC001.put("FILE_PATH",	"/QMS"+path);
						qmsDB.insert("QMS_BBS_NOTICE.BBS_ATTACHMENT_C001", paramC001);   // DF MST INSERT
			        	
					} catch (Exception e) { 
						if (qmsDB != null) try { qmsDB.close(); } catch (Exception e1) {}
					}
				
					seq++;
		        }
			}
		}
	} else {
			LogUtil.getInstance().debug("파일 업로드 되지 않았음");
			strFileFlag="N";
	}
	
	// DF MST INSERT
	try {
		paramC002 = new HashMap<String,String>();
		paramC002.put("BOARD_ID",	strBoardId);
		paramC002.put("BBS_ID",		strBbsId);
		paramC002.put("DEPTH",		"1");
		paramC002.put("REG_TITLE",	strTitle);
		paramC002.put("REG_TEXT",	strRegText);
		paramC002.put("BBS_USER",	strUserId);
		paramC002.put("REG_DATE",	today);
		paramC002.put("BBS_FILE",	strFileFlag);
		paramC002.put("COUNT",		"0");
		paramC002.put("STAT",		"222");
		paramC002.put("DEL_YN",		"N");
		
		updateCount	= qmsDB.insert("QMS_BBS_NOTICE.BBS_BOARD_C002", paramC002);   // DF MST INSERT
		
	} catch (Exception e) { 
		if (qmsDB != null) try { qmsDB.close(); } catch (Exception e1) {}
	}

	
	// 화면으로 이동
	out.println("<script type='text/javascript'>");
	if (updateCount!=0){
		out.println("alert('정상 등록 되었습니다.');");
	} else {
		out.println("alert('등록이 실패하였습니다.');");	
	}
	//out.println("opener.uf_inq('0');");                      // 처리 후 화면 리플레시 처리
	out.println("window.location.href='/QMS/jsp/view/bbs/bbs_noticeList_view.jsp?BOARD_ID="+strBoardId+"';");
	out.println("</script>");
} catch(Exception e){
	e.printStackTrace(System.out);
}
%>
<%@ include file="/jsp/inc/inc_bottom.jsp" %>