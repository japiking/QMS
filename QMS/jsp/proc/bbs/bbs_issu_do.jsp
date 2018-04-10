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

int updateCount			= 0 ;	// DB�ŷ� ��������
String save_date 		= DateTime.getInstance().getDate("yyyyMMdd");
String save_time 		= DateTime.getInstance().getDate("hh24miss");
String strFileFlag 		= "Y";
String receivers[]		= null;

// ���Ͼ��ε�
String path 			= "/uploadfile/"+userSession.getUserID()+"/"+save_date+"/"+save_time;
String savePath			= PropertyUtil.getInstance().getProperty("rootPath")+path; // ������ ���丮 (������)
int sizeLimit 			= 30 * 1024 * 1024 ; // 10�ް����� ���� �Ѿ�� ���ܹ߻�

// �����θ� �����.
File desti = new File(savePath);
if(!desti.exists()){
	desti.mkdirs();
}

MultipartRequest multi	= new MultipartRequest(request, savePath, sizeLimit,"euc-kr", new DefaultFileRenamePolicy());
Enumeration formNames	= multi.getFileNames();					// ���� �̸� ��ȯ

if(formNames.hasMoreElements()){
	String formName			= (String)formNames.nextElement();
	String fileName			= multi.getFilesystemName(formName);	// ������ �̸� ���
	String originalFileName = multi.getOriginalFileName(formName);	// ���� �̸� ��������
	if(fileName == null || "".equals(fileName)) {  // ������ ���ε� ���� �ʾ�����
		System.out.print("���� ���ε� ���� �ʾ���");
		strFileFlag = "N";
	} else {  				// ������ ���ε� �Ǿ�����
		strFileFlag = "Y";
	}
	LogUtil.getInstance().debug("file �±� �̸� : " + formName);
	LogUtil.getInstance().debug("����� ���ϸ� : " + fileName);
	LogUtil.getInstance().debug("���� ���ϸ� : " + originalFileName);
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
	
	//�޽��� ���� ����Ʈ
	ArrayList<String> userList = new ArrayList<String>();
	//userList.add(strUserId);	//������ ���
	String receiver	= StringUtil.null2void(multi.getParameter("RECEIVER_LIST"));
	if (receiver != null && !"".equals(receiver)) {
		receivers = receiver.split(",");
		for (int i=0 ; i < receivers.length ; i++) {
			userList.add(receivers[i].trim());
		}
	}
	
	// sql1 BBS_ID �޾ƿ���
	String bbsId = DBSeqUtil.getBbsId();
	int intResult 			= 0;

	LogUtil.getInstance().debug(strProjectId);
	//�޴»��|�����»�� ���� �ֱ�
	Map<String,String> param	= 	new HashMap<String,String>();
	param.put("PROJECT_ID",strProjectId);
	param.put("BOARD_ID",strBoardId);
	param.put("BBS_ID",bbsId);
	
	//�������
	param.put("RECIPIENT_ID",strUserId);
	param.put("RECIPIENT_DVD"	,"S");		// S: ������ ���, R:�޴»��
											// �����ڿ���
	intResult += qmsDB.insert("QMS_BBS_ISSU.BBS_RECIPIENT_C003", param);

	//Ȯ����
	param.put("RECIPIENT_ID",confirmUserId);
	param.put("RECIPIENT_DVD"	,"R");		// S: ������ ���, R:�޴»��
											// �����ڿ���
	intResult += qmsDB.insert("QMS_BBS_ISSU.BBS_RECIPIENT_C003", param);
	
	//������
	for (int i=0 ; i < userList.size(); i++) {
		param.put("RECIPIENT_ID",userList.get(i));
		param.put("RECIPIENT_DVD",strUserId.equals(StringUtil.null2void(userList.get(i))) ? "S":"R");		// S: ������ ���, R:�޴»��
		param.put("REC_YN", 		"Y");											// �����ڿ���
		//if(proc_userid.contains(userList.get(i))) continue;
		intResult += qmsDB.insert("QMS_BBS_ISSU.BBS_RECIPIENT_C001", param);
	}

	// ó�������� �Է�
	String []ar = proc_userid.split(",");
	for(int i=0; i<ar.length; i++){
		param.put("RECIPIENT_ID",   StringUtil.null2void(ar[i]).trim());
		param.put("RECIPIENT_DVD",  strUserId.equals(StringUtil.null2void(ar[i]).trim()) ? "S":"R");		// S: ������ ���, R:�޴»��
		param.put("PROC_YN", 		"Y");											// ó���ڿ���
		intResult = qmsDB.insert("QMS_BBS_ISSU.BBS_RECIPIENT_C002", param);
	}
	
	//�۾���
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


// ȭ������ �̵�
out.println("<script type='text/javascript'>");
if(updateCount!=0){
	out.println("alert('���� ��� �Ǿ����ϴ�.');");
}else{
	out.println("alert('����� �����Ͽ����ϴ�.');");
}
//out.println("opener.uf_inq('0');");                      // ó�� �� ȭ�� ���÷��� ó��
out.println("window.location.href='/QMS/jsp/view/bbs/bbs_issu_view.jsp?BOARD_ID="+strBoardId+"';");
out.println("</script>");

%>

<%@ include file="/jsp/inc/inc_bottom.jsp" %>
