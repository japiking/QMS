<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>

<%@ page import="java.util.Enumeration"%>
<%@ page import="java.io.File"%>
<%@ page import="qms.util.*"%>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%@ include file="/jsp/inc/inc_common.jsp" %>
<%@ include file="/jsp/inc/inc_header.jsp" %>
<%@ include file="/jsp/inc/inc_loading.jsp" %>
<%

request.setCharacterEncoding("euc-kr");
request.setAttribute(Const.ERROR_RETURN_URL, "POPUP");
String today				= DateTime.getInstance().getDate("yyyy-mm-dd");
DBSeqUtil DButil = new DBSeqUtil();
String referer			= request.getHeader("referer");
String returnUrl		= "/" + referer.substring(referer.indexOf("QMS"));

int updateCount			= 0 ;	// DB거래 성공여부
String save_date 		= DateTime.getInstance().getDate("yyyyMMdd");
String save_time 		= DateTime.getInstance().getDate("hh24miss");
String strFileFlag 		= "N";
String receivers[]		= null;

// 파일업로드
String path 			= "/uploadfile/"+userSession.getUserID()+"/"+save_date+"/"+save_time;
String savePath			= PropertyUtil.getInstance().getProperty("rootPath")+path; // 저장할 디렉토리 (절대경로)
int sizeLimit 			= 30 * 1024 * 1024 ; // 10메가까지 제한 넘어서면 예외발생

// 저장경로를 만든다.
File desti = new File(savePath);
if(!desti.exists()){
	desti.mkdirs();
}


//sql1 BBS_ID 받아오기
String bbsId = StringUtil.null2void(DButil.getBbsId());


MultipartRequest multi	= new MultipartRequest(request, savePath, sizeLimit,"euc-kr", new DefaultFileRenamePolicy());

//sql4 첨부파일 경로 등록
Enumeration formNames	= multi.getFileNames();					// 폼의 이름 반환
String fileName 		= "";

if(formNames.hasMoreElements()){
    File fileObj			= null;
	strFileFlag				= "Y";
	String fileInput		= "";
    String type				= "";
    String originFileName	= "";    
    String fileExtend		= "";
    String fileSize			= "";
	int seq					= 1;	

	while(formNames.hasMoreElements()) {
		fileInput		= (String)formNames.nextElement();                		// 파일인풋 이름
        fileName		= multi.getFilesystemName(fileInput);            		// 파일명
        if (fileName != null) {
        	type			= multi.getContentType(fileInput);                  // 콘텐트타입    
            fileObj			= multi.getFile(fileInput);                        	// 파일객체
            originFileName	= multi.getOriginalFileName(fileInput);     		// 초기 파일명
            fileExtend		= fileName.substring(fileName.lastIndexOf(".")+1); 	// 파일 확장자
            fileSize		= String.valueOf(fileObj.length());               	// 파일크기
             
            LogUtil.getInstance().debug("콘텐트타입----["+type+"]");
            LogUtil.getInstance().debug("초기 파일명---["+originFileName+"]");
            LogUtil.getInstance().debug("파일 확장자---["+fileExtend+"]");
            LogUtil.getInstance().debug("파일크기------["+fileSize+"]");
            try {
            	// 첨부파일정보 입력
    			Map<String,String> paramC005 = new HashMap<String,String>();
    			paramC005.put("BBS_ID",		bbsId);
    			paramC005.put("SEQ", 		Integer.toString(seq));
    			paramC005.put("FILE_NAME",	originFileName);
    			paramC005.put("FILE_PATH",	"/QMS"+path);
    			
    			int db2Rlt	= qmsDB.insert("QMS_BBS_ONELOW.BBS_ATTACHMENT_C005", paramC005);   // DF MST INSERT
    			seq++;
            } catch (Exception e) {
            	if (qmsDB != null) try{ qmsDB.close(); } catch (Exception e1) {}
            }
			
        }
	}
}

String strUserId			= StringUtil.null2void(userSession.getUserID());
String strProjectId			= StringUtil.null2void(userSession.getProjectID()); 
String strBoardId			= StringUtil.null2void(multi.getParameter("BOARD_ID1"));  
String strTitle				= StringUtil.null2void(multi.getParameter("TITLE")); 

// 메시지 전송 리스트
ArrayList<String> userList = new ArrayList<String>();
userList.add(strUserId);	//보내는 사람
String receiver	= StringUtil.null2void(multi.getParameter("RECEIVER_LIST"));
if (receiver != null && !"".equals(receiver)) {
	receivers = receiver.split(",");
	for (int i=0 ; i < receivers.length ; i++) {
		userList.add(receivers[i].trim());
	}
}

// sql2 한줄게시판 받는사람 테이블에 테이블 정보와 사용자 등록
int intResult 			= 0;
try {
	Map<String, String> paramC006 = new HashMap<String, String>();
	paramC006.put("PROJECT_ID",		strProjectId);
	paramC006.put("BOARD_ID",		strBoardId);
	paramC006.put("BBS_ID",			bbsId);
	for (int i=0 ; i < userList.size(); i++) {
		paramC006.put("RECIPIENT_ID",	userList.get(i));
		paramC006.put("RECIPIENT_DVD",	strUserId.equals(userList.get(i)) ? "S":"R");// S: 보내는 사람, R:받는사람
		
		intResult = qmsDB.insert("QMS_BBS_ONELOW.BBS_RECIPIENT_C006", paramC006);
	}		
} catch (Exception e) {
	if (qmsDB != null) try { qmsDB.close(); } catch(Exception e1) {}
}


// sql3 한줄게시판에 내용등록
try {
	Map<String,String> paramC007 = new HashMap<String, String>();
	paramC007.put("BOARD_ID",		strBoardId);
	paramC007.put("BBS_ID",			bbsId);
	paramC007.put("TITLE",			strTitle);
	paramC007.put("CONTENTS",		strTitle);
	paramC007.put("BBS_USER",		userSession.getUserID());
	paramC007.put("BBS_REG_DATE", 	today);
	paramC007.put("BBS_FILE", 		strFileFlag);
	updateCount	= qmsDB.insert("QMS_BBS_ONELOW.BOARD_C007", paramC007);

} catch (Exception e) { 
	if (qmsDB != null) try { qmsDB.close(); } catch(Exception e1) {}  
} finally {
	if (qmsDB != null) try { qmsDB.close(); } catch(Exception e1) {}
}

// 화면으로 이동
out.println("<script type='text/javascript'>");
if(updateCount!=0){
	out.println("alert('정상 등록 되었습니다.');");
}else{
	out.println("alert('등록이 실패하였습니다.');");
}
//out.println("opener.uf_inq('0');");                      // 처리 후 화면 리플레시 처리

out.println("window.location.href='"+returnUrl+"?BOARD_ID="+strBoardId+"';");
out.println("</script>");

%>

<%@ include file="/jsp/inc/inc_bottom.jsp" %>
