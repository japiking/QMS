<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>

<%@ page import="java.util.Enumeration"%>
<%@ page import="java.io.File"%>
<%@ page import="qms.util.*"%>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%@ include file="/jsp/inc/inc_common.jsp" %>
<%@ include file="/jsp/inc/inc_header.jsp" %>

<%

request.setCharacterEncoding("euc-kr");
request.setAttribute(Const.ERROR_RETURN_URL, "POPUP");

int updateCount			= 0 ;	// DB거래 성공여부
String save_date 		= DateTime.getInstance().getDate("yyyyMMdd");
String save_time 		= DateTime.getInstance().getDate("hh24miss");
String strFileFlag 		= "Y";
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

MultipartRequest multi	= new MultipartRequest(request, savePath, sizeLimit,"euc-kr", new DefaultFileRenamePolicy());
Enumeration formNames	= multi.getFileNames();					// 폼의 이름 반환

if(formNames.hasMoreElements()){
	String formName			= (String)formNames.nextElement();
	String fileName			= multi.getFilesystemName(formName);	// 파일의 이름 얻기
	String originalFileName = multi.getOriginalFileName(formName);	// 원래 이름 가져오기
	if(fileName == null || "".equals(fileName)) {  // 파일이 업로드 되지 않았을때
		System.out.print("파일 업로드 되지 않았음");
		strFileFlag = "N";
	} else {  				// 파일이 업로드 되었을때
		strFileFlag = "Y";
	}
	LogUtil.getInstance().debug("file 태그 이름 : " + formName);
	LogUtil.getInstance().debug("저장된 파일명 : " + fileName);
	LogUtil.getInstance().debug("원래 파일명 : " + originalFileName);
}else{
	strFileFlag = "N";
}

String strUserId					= StringUtil.null2void(userSession.getUserID());
String strProjectId					= StringUtil.null2void(userSession.getProjectID()); 
String strBoardId					= StringUtil.null2void(multi.getParameter("BOARD_ID1"));  
String strTitle						= StringUtil.null2void(multi.getParameter("TITLE")).replaceAll("\r\n","<br/>"); 
String strInqDate					= StringUtil.null2void(multi.getParameter("INQ_DATE1"));
String proc_userid					= StringUtil.null2void(multi.getParameter("proc_userid"));
String strImportanceGradeid			= StringUtil.null2void(multi.getParameter("IMPGRADE"));
String confirmUserId				= StringUtil.null2void(multi.getParameter("CONFIRM_USER_ID"));

String today						= DateTime.getInstance().getDate("yyyy-mm-dd");
try{
	
	//메시지 전송 리스트
	ArrayList<String> userList = new ArrayList<String>();
	//userList.add(strUserId);	//보내는 사람
	String receiver	= StringUtil.null2void(multi.getParameter("RECEIVER_LIST"));
	if (receiver != null && !"".equals(receiver)) {
		receivers = receiver.split(",");
		for (int i=0 ; i < receivers.length ; i++) {
			userList.add(receivers[i].trim());
		}
	}
	
	// sql1 BBS_ID 받아오기
	String bbsId = DBSeqUtil.getBbsId();
	int intResult 			= 0;

	LogUtil.getInstance().debug(strProjectId);
	//받는사람|보내는사람 정보 넣기
	Map<String,String> param	= 	new HashMap<String,String>();
	param.put("PROJECT_ID",strProjectId);
	param.put("BOARD_ID",strBoardId);
	param.put("BBS_ID",bbsId);
	
	//보낸사람
	param.put("RECIPIENT_ID",strUserId);
	param.put("RECIPIENT_DVD"	,"S");		// S: 보내는 사람, R:받는사람
											// 참여자여부
	intResult += qmsDB.insert("QMS_BBS_ISSU.BBS_RECIPIENT_C003", param);

	//확인자
	param.put("RECIPIENT_ID",confirmUserId);
	param.put("RECIPIENT_DVD"	,"R");		// S: 보내는 사람, R:받는사람
											// 참여자여부
	intResult += qmsDB.insert("QMS_BBS_ISSU.BBS_RECIPIENT_C003", param);
	
	//참조자
	for (int i=0 ; i < userList.size(); i++) {
		param.put("RECIPIENT_ID",userList.get(i));
		param.put("RECIPIENT_DVD",strUserId.equals(StringUtil.null2void(userList.get(i))) ? "S":"R");		// S: 보내는 사람, R:받는사람
		param.put("REC_YN", 		"Y");											// 참여자여부
		//if(proc_userid.contains(userList.get(i))) continue;
		intResult += qmsDB.insert("QMS_BBS_ISSU.BBS_RECIPIENT_C001", param);
	}

	// 처리자정보 입력
	String []ar = proc_userid.split(",");
	for(int i=0; i<ar.length; i++){
		param.put("RECIPIENT_ID",   StringUtil.null2void(ar[i]).trim());
		param.put("RECIPIENT_DVD",  strUserId.equals(StringUtil.null2void(ar[i]).trim()) ? "S":"R");		// S: 보내는 사람, R:받는사람
		param.put("PROC_YN", 		"Y");											// 처리자여부
		intResult = qmsDB.insert("QMS_BBS_ISSU.BBS_RECIPIENT_C002", param);
	}
	
	//글쓰기
	Map<String,String> param2	=	new HashMap<String,String>();
	param2.put("BOARD_ID" 			,strBoardId);
	param2.put("BBS_ID"				,bbsId);
	param2.put("DEPTH"				,String.valueOf(1));
	param2.put("TITLE"				,strTitle);
	param2.put("CONTENTS"			,strTitle);
	param2.put("BBS_USER"			,userSession.getUserID());
	param2.put("BBS_REG_DATE"		,today);
	param2.put("COMPLETION_DATE"	,strInqDate);
	param2.put("BBS_FILE"			,strFileFlag);
	param2.put("COUNT"				,String.valueOf(0));
	param2.put("DEL_YN"				,"N");
	param2.put("STATE"				,"000");
	param2.put("CONFIRM_USER"		,confirmUserId);
	param2.put("IMPORTANCE_GRADE_ID",strImportanceGradeid);
	
	updateCount = qmsDB.insert("QMS_BBS_ISSU.BOARD_C001", param2);
	
}catch(Exception e){
	LogUtil.getInstance().debug(e);
	if (qmsDB != null) try { qmsDB.rollback(); } catch (Exception e1) {}
}finally{
	if (qmsDB != null) try { qmsDB.close(); } catch (Exception e1) {}
}


// 화면으로 이동
out.println("<script type='text/javascript'>");
if(updateCount!=0){
	out.println("alert('정상 등록 되었습니다.');");
}else{
	out.println("alert('등록이 실패하였습니다.');");
}
//out.println("opener.uf_inq('0');");                      // 처리 후 화면 리플레시 처리
out.println("window.location.href='/QMS/jsp/view/bbs/bbs_issu_view.jsp?BOARD_ID="+strBoardId+"';");
out.println("</script>");

%>

<%@ include file="/jsp/inc/inc_bottom.jsp" %>
