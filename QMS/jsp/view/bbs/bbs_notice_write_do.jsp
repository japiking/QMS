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
	int updateCount	=0 ; //DB�ŷ� ��������
	String save_date = DateTime.getInstance().getDate("yyyyMMdd");
	String save_time = DateTime.getInstance().getDate("hh24miss");
	
	String path = "/uploadfile/"+userSession.getUserID()+"/"+save_date+"/"+save_time;
	
	//���Ͼ��ε�
	MultipartRequest multi	=	null;
	String savePath=PropertyUtil.getInstance().getProperty("rootPath")+path; // ������ ���丮 (������)
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
	
	String strTitle			= StringUtil.null2void(multi.getParameter("REG_TITLE"));
	String strRegText		= StringUtil.null2void(multi.getParameter("REG_TEXT"));
	String strUserId		= StringUtil.null2void(userSession.getUserID());
	String strStat			= StringUtil.null2void(multi.getParameter("STAT"));         
	String strBoardId		= StringUtil.null2void(multi.getParameter("BOARD_ID"));     
	String strFileFlag		= StringUtil.null2void(multi.getParameter("FIEL_EXIST_YN"));	// ÷������ ���翩��
	String strSEQ			= StringUtil.null2void(multi.getParameter("SEQ"));
	String today			= DateTime.getInstance().getDate("yyyy-mm-dd");						//���ó���
	String strBbsId			= StringUtil.null2void(DButil.getBbsId());
	Map<String,String> paramC002 = null;
	// ÷������ ���翩�� üũ 
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
		              
					// ÷���������� �Է�
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
			LogUtil.getInstance().debug("���� ���ε� ���� �ʾ���");
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

	
	// ȭ������ �̵�
	out.println("<script type='text/javascript'>");
	if (updateCount!=0){
		out.println("alert('���� ��� �Ǿ����ϴ�.');");
	} else {
		out.println("alert('����� �����Ͽ����ϴ�.');");	
	}
	//out.println("opener.uf_inq('0');");                      // ó�� �� ȭ�� ���÷��� ó��
	out.println("window.location.href='/QMS/jsp/view/bbs/bbs_noticeList_view.jsp?BOARD_ID="+strBoardId+"';");
	out.println("</script>");
} catch(Exception e){
	e.printStackTrace(System.out);
}
%>
<%@ include file="/jsp/inc/inc_bottom.jsp" %>