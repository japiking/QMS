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

int updateCount			= 0 ;	// DB�ŷ� ��������
String save_date 		= DateTime.getInstance().getDate("yyyyMMdd");
String save_time 		= DateTime.getInstance().getDate("hh24miss");
String strFileFlag 		= "N";
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


//sql1 BBS_ID �޾ƿ���
String bbsId = StringUtil.null2void(DButil.getBbsId());


MultipartRequest multi	= new MultipartRequest(request, savePath, sizeLimit,"euc-kr", new DefaultFileRenamePolicy());

//sql4 ÷������ ��� ���
Enumeration formNames	= multi.getFileNames();					// ���� �̸� ��ȯ
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
		fileInput		= (String)formNames.nextElement();                		// ������ǲ �̸�
        fileName		= multi.getFilesystemName(fileInput);            		// ���ϸ�
        if (fileName != null) {
        	type			= multi.getContentType(fileInput);                  // ����ƮŸ��    
            fileObj			= multi.getFile(fileInput);                        	// ���ϰ�ü
            originFileName	= multi.getOriginalFileName(fileInput);     		// �ʱ� ���ϸ�
            fileExtend		= fileName.substring(fileName.lastIndexOf(".")+1); 	// ���� Ȯ����
            fileSize		= String.valueOf(fileObj.length());               	// ����ũ��
             
            LogUtil.getInstance().debug("����ƮŸ��----["+type+"]");
            LogUtil.getInstance().debug("�ʱ� ���ϸ�---["+originFileName+"]");
            LogUtil.getInstance().debug("���� Ȯ����---["+fileExtend+"]");
            LogUtil.getInstance().debug("����ũ��------["+fileSize+"]");
            try {
            	// ÷���������� �Է�
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

// �޽��� ���� ����Ʈ
ArrayList<String> userList = new ArrayList<String>();
userList.add(strUserId);	//������ ���
String receiver	= StringUtil.null2void(multi.getParameter("RECEIVER_LIST"));
if (receiver != null && !"".equals(receiver)) {
	receivers = receiver.split(",");
	for (int i=0 ; i < receivers.length ; i++) {
		userList.add(receivers[i].trim());
	}
}

// sql2 ���ٰԽ��� �޴»�� ���̺� ���̺� ������ ����� ���
int intResult 			= 0;
try {
	Map<String, String> paramC006 = new HashMap<String, String>();
	paramC006.put("PROJECT_ID",		strProjectId);
	paramC006.put("BOARD_ID",		strBoardId);
	paramC006.put("BBS_ID",			bbsId);
	for (int i=0 ; i < userList.size(); i++) {
		paramC006.put("RECIPIENT_ID",	userList.get(i));
		paramC006.put("RECIPIENT_DVD",	strUserId.equals(userList.get(i)) ? "S":"R");// S: ������ ���, R:�޴»��
		
		intResult = qmsDB.insert("QMS_BBS_ONELOW.BBS_RECIPIENT_C006", paramC006);
	}		
} catch (Exception e) {
	if (qmsDB != null) try { qmsDB.close(); } catch(Exception e1) {}
}


// sql3 ���ٰԽ��ǿ� ������
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

// ȭ������ �̵�
out.println("<script type='text/javascript'>");
if(updateCount!=0){
	out.println("alert('���� ��� �Ǿ����ϴ�.');");
}else{
	out.println("alert('����� �����Ͽ����ϴ�.');");
}
//out.println("opener.uf_inq('0');");                      // ó�� �� ȭ�� ���÷��� ó��

out.println("window.location.href='"+returnUrl+"?BOARD_ID="+strBoardId+"';");
out.println("</script>");

%>

<%@ include file="/jsp/inc/inc_bottom.jsp" %>
