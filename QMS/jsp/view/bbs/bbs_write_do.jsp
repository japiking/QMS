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
<body>
<%@ include file="/jsp/inc/inc_loading.jsp" %>
<%
try{
	request.setCharacterEncoding("euc-kr");
	DBSeqUtil DButil = new DBSeqUtil();
	request.setAttribute(Const.ERROR_RETURN_URL, "POPUP");
	int updateCount	=0 ; //DB거래 성공여부
	String save_date = DateTime.getInstance().getDate("yyyyMMdd");
	String save_time = DateTime.getInstance().getDate("hh24miss");
	
	String path = "/uploadfile/"+userSession.getUserID()+"/"+save_date+"/"+save_time;
	
	//파일업로드
	MultipartRequest multi	=	null;
	String savePath=PropertyUtil.getInstance().getProperty("rootPath")+path; //저장할 디렉토리 (절대경로)
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
	String strDepth			= StringUtil.null2void(multi.getParameter("DEPTH"),"");        
	String strFileFlag		= StringUtil.null2void(multi.getParameter("FIEL_EXIST_YN"));	// 첨부파일 존재여부
	String strDetailState	= StringUtil.null2void(multi.getParameter("DETAIL_STATE"));		//답글 구분
	String strChanelName	= StringUtil.null2void(multi.getParameter("CHANEL_NAME"));		//채널명
	String strInqDate		= StringUtil.null2void(multi.getParameter("INQ_DATE1"));		//완료예정일
	String confirm_user		= StringUtil.null2void(multi.getParameter("CONFIRM_USER_PROC")); // 확인자
	String strSEQ			= StringUtil.null2void(multi.getParameter("SEQ"));
	String today			= DateTime.getInstance().getDate("yyyy-mm-dd");						//오늘날자
	String strBbsId			= StringUtil.null2void(DButil.getBbsId());

	
	// 첨부파일 존재여부 체크 
	if("Y".equals(strFileFlag)){
		if(formNames.hasMoreElements()) {  	
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
		              
		            Map<String,String> param = new HashMap<String,String>();
            		param.put("BBS_ID",strBoardId);
	            	
	            	int dbRlt2 = qmsDB.delete("QMS_BBS_WRITE.BBS_ATTACHMENT_D001", param);
	            	
	            	Map<String,String> param2 = new HashMap<String,String>();
	            	param2.put("BBS_ID",strBbsId);
	            	param2.put("SEQ",""+seq);
	            	param2.put("FILE_NAME",originFileName);
	            	param2.put("FILE_PATH","/QMS"+path);
	            	param2.put("DEL_FLAG","N");
	            	
	            	int dbRlt1	= qmsDB.insert("QMS_BBS_WRITE.BBS_ATTACHMENT_C001", param2);
		        	
					seq++;
		        }
			}
		}
	} else {
			LogUtil.getInstance().debug("파일 업로드 되지 않았음");
			strFileFlag="N";
	}
	
	int intDepth=1;

	if("A".equals(strDetailState)){
		Map<String,String> param = new HashMap<String,String>();
		param.put("BOARD_ID",strBoardId);
		param.put("BBS_ID",multi.getParameter("BBS_ID"));
		
		Map<String,String> ResultDepth	= qmsDB.selectOne("QMS_BBS_WRITE.BOARD_R002", param);
		intDepth = Integer.parseInt(ResultDepth.get("DEPTH"))+1;
	}
	
	String strCount="0";
	LogUtil.getInstance().debug("bgh----->"+intDepth);
	Map<String,String> param2 = new HashMap<String,String>();
	param2.put("BOARD_ID",		strBoardId);
	
	if("A".equals(strDetailState)){
		param2.put("BBS_ID",		multi.getParameter("BBS_ID"));
		param2.put("SEQ",			strSEQ);
		param2.put("DETAIL_STATE",		strDetailState);
	}else{
		param2.put("BBS_ID",		strBbsId);
	}
	
	param2.put("DEPTH",				String.valueOf(intDepth));
	param2.put("TITLE",				strTitle);
	param2.put("CONTENTS",			strRegText);
	param2.put("BBS_USER",			strUserId);
	param2.put("BBS_REG_DATE",		today);
	param2.put("BBS_FILE",			strFileFlag);
	param2.put("COUNT",				strCount);
	param2.put("STATE",				"222");
	param2.put("CHANEL_NAME",		strChanelName);
	param2.put("COMPLETION_DATE",	strInqDate);
	param2.put("DEL_YN",			"N");
	param2.put("CONFIRM_USER",		confirm_user);
	
	updateCount	= qmsDB.insert("QMS_BBS_WRITE.BOARD_C001", param2);
	

	
	// 화면으로 이동
	out.println("<script type='text/javascript'>");
	if(updateCount!=0){
		out.println("alert('정상 등록 되었습니다.');");
	}else{
		out.println("alert('등록이 실패하였습니다.');");	
	}
	//out.println("opener.uf_inq('0');");                      // 처리 후 화면 리플레시 처리
	out.println("window.location.href='/QMS/jsp/view/bbs/bbs_list_view.jsp?BOARD_ID="+strBoardId+"';");
	out.println("</script>");
} catch(Exception e){
	e.printStackTrace(System.out);
	if (qmsDB != null){
        try { qmsDB.close(); } catch (Exception e1) {}
	}
}finally{
	if (qmsDB != null){
        try { qmsDB.close(); } catch (Exception e1) {}
	}
}
%>
</body>
</html>