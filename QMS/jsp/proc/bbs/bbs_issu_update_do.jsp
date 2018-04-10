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
	
	int updateCount	=0 ; // DB�ŷ� ��������
	String receivers[]		= null;
	int intResult 			= 0;
	
	// ���Ͼ��ε� ���� ���� ����
	String save_date	= DateTime.getInstance().getDate("yyyyMMdd");
	String save_time	= DateTime.getInstance().getDate("hh24miss");
	String path 		= "/uploadfile/"+userSession.getUserID()+"/"+save_date+"/"+save_time;
	String savePath		= PropertyUtil.getInstance().getProperty("rootPath") + path; // ������ ���丮 (������)
	int sizeLimit 		= 30 * 1024 * 1024 ; // 10�ް����� ���� �Ѿ�� ���ܹ߻�
	String fileName		= "";
	String originalFileName	= "";
	
	// �����θ� �����.
	File desti = new File(savePath);
	if(!desti.exists()){
		desti.mkdirs(); 
	}
	
	// MultipartRequest ����
	MultipartRequest multi	    = new MultipartRequest(request, savePath, sizeLimit,"euc-kr", new DefaultFileRenamePolicy());
	Enumeration formNames=multi.getFileNames();  // ���� �̸� ��ȯ
	// getParameter �� ����
	String strUserId		    		= StringUtil.null2void(userSession.getUserID());
	String boardID 						= StringUtil.null2void(multi.getParameter("BOARD_ID"));
	String bbsID 						= StringUtil.null2void(multi.getParameter("BBS_ID"));
	String title						= StringUtil.null2void(multi.getParameter("TITLE")).replaceAll("\r\n","<br/>");
	String pageNum						= StringUtil.null2void(multi.getParameter("PAGE_NUM"));
	String strInqDate					= StringUtil.null2void(multi.getParameter("INQ_DATE1"));
	String strImportanceGradeid			= StringUtil.null2void(multi.getParameter("IMPGRADE"));
	String receiverList					= StringUtil.null2void(multi.getParameter("RECEIVER_LIST"));
	String proc_List					= StringUtil.null2void(multi.getParameter("PROC_USERID"));
	String confirm_id					= StringUtil.null2void(multi.getParameter("CONFIRM_ID"));
	String projectId					= StringUtil.null2void(multi.getParameter("projectID"));
	String strFileFlag			= "N";
	
	LogUtil.getInstance().debug("SAMGU-bbs_oneRowList_update_do.jsp >> boardID:"+boardID+", bbsID:"+bbsID+", title:"+title+", INQ_DATE1:"+strInqDate+", IMPGRADE:"+strImportanceGradeid);
	
	// SQL���� ���� ����
	StringBuffer commentSql		= new StringBuffer();
	StringBuffer boardSql		= new StringBuffer();
	List<String> commentList	= new ArrayList<String>();
	List<String> boardList		= new ArrayList<String>();
	int boardResult				= 0;
	String [] strDelFileList		= 	multi.getParameterValues("delFile");
	// ���� �Խù� �����ϱ�
	try {
		
		//���� ��ϵ� ���� ������ DB����ó��
		if ( strDelFileList != null && strDelFileList.length >0 ){
			for( int i =0 ; i < strDelFileList.length; i++){
				Map<String,String> param = new HashMap<String,String>();
				param.put("BBS_ID",bbsID);
				param.put("SEQ",""+strDelFileList[i]);
				qmsDB.update("QMS_BBS_WRITE.BBS_ATTACHMENT_U001", param);
			}
		}
		if(formNames.hasMoreElements()) {
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
		            
	            	/* Map<String,String> param = new HashMap<String,String>();
	            	param.put("BBS_ID",strBbsId);
	            	
	            	int dbRlt2 = qmsDB.delete("QMS_BBS_WRITE.BBS_ATTACHMENT_D001", param);
	            	 */
	            	Map<String,String> param2 = new HashMap<String,String>();
	            	param2.put("BBS_ID",bbsID);
	            	param2.put("SEQ",""+seq);
	            	param2.put("FILE_NAME",originFileName);
	            	param2.put("FILE_PATH","/QMS"+path);
	            	
	            	int dbRlt1	= qmsDB.insert("QMS_BBS_WRITE.BBS_ATTACHMENT_C001", param2);
	            	strFileFlag ="Y";
					seq++;
		        }
			}
		}
	
		Map<String,String> paramU001 = new HashMap<String,String>();
		paramU001.put("TITLE",		title);
		paramU001.put("CONTENTS",	title);
		paramU001.put("BOARD_ID",	boardID);
		paramU001.put("BBS_ID",		bbsID);
		paramU001.put("BBS_FILE",	strFileFlag);
		paramU001.put("IMPORTANCE_GRADE_ID",	strImportanceGradeid);
		paramU001.put("COMPLETION_DATE",strInqDate);
		paramU001.put("CONFIRM_USER"		,confirm_id);
		boardResult = qmsDB.update("QMS_BBS_ONELOW.BOARD_U001", paramU001);
		
		//��ü ������|ó���� ����
		Map<String,String> paramU002 = new HashMap<String,String>();
		paramU002.put("PROJECT_ID",projectId);
		paramU002.put("BOARD_ID",	boardID);
		paramU002.put("BBS_ID",		bbsID);
		boardResult = qmsDB.update("QMS_BBS_ISSU.BBS_RECIPIENT_D001", paramU002);
		
		//������ ���� update
		Map<String,String> param1	= 	new HashMap<String,String>();
		ArrayList<String> userList1	=	new ArrayList<String>();
		//userList1.add(strUserId);	//������ ���
		if (receiverList != null && !"".equals(receiverList)) {
			receivers = receiverList.split(",");
			for (int i=0 ; i < receivers.length ; i++) {
				userList1.add(receivers[i].trim());	//������
			}
		}
		
		param1.put("PROJECT_ID",projectId);
		param1.put("BOARD_ID",boardID);
		param1.put("BBS_ID",bbsID);
		
		//Ȯ����
		param1.put("RECIPIENT_ID",confirm_id);
		param1.put("RECIPIENT_DVD"	,"R");		// S: ������ ���, R:�޴»��
												// �����ڿ���
		intResult += qmsDB.insert("QMS_BBS_ISSU.BBS_RECIPIENT_C003", param1);
		
		//�������
		param1.put("RECIPIENT_ID",strUserId);
		param1.put("RECIPIENT_DVD"	,"R");		// S: ������ ���, R:�޴»��
		intResult = qmsDB.insert("QMS_BBS_ISSU.BBS_RECIPIENT_C003", param1);
		
		//������
		for (int i=0 ; i < userList1.size(); i++) {
			param1.put("RECIPIENT_ID",userList1.get(i));
			param1.put("RECIPIENT_DVD",strUserId.equals(userList1.get(i)) ? "S":"R");		// S: ������ ���, R:�޴»��
			param1.put("REC_YN", 		"Y");
			intResult += qmsDB.insert("QMS_BBS_ISSU.BBS_RECIPIENT_C001", param1);
		}

						
		//ó���� ���� update
		String []ar = proc_List.split(",");
		for(int i=0; i<ar.length; i++){
			param1.put("RECIPIENT_ID",   StringUtil.null2void(ar[i]).trim());
			param1.put("RECIPIENT_DVD",  strUserId.equals(StringUtil.null2void(ar[i]).trim()) ? "S":"R");		// S: ������ ���, R:�޴»��
			param1.put("PROC_YN", 		"Y");											// ó���ڿ���
			intResult = qmsDB.insert("QMS_BBS_ISSU.BBS_RECIPIENT_C002", param1);
		}
		
		// ó�������� �Է�
		/* param.put("RECIPIENT_ID",   proc_List);
		param.put("RECIPIENT_DVD",  strUserId.equals(proc_List) ? "S":"R");		// S: ������ ���, R:�޴»��
		param.put("PROC_YN", 		"Y");											// ó���ڿ���
		intResult += qmsDB.insert("QMS_BBS_ISSU.BBS_RECIPIENT_C002", param); */
		
	} catch (Exception e) {
		if (qmsDB != null) try { qmsDB.rollback(); } catch (Exception e1) {}
	} finally {
		if (qmsDB != null) try { qmsDB.close(); } catch (Exception e1) {}
	}
	out.println("<script type='text/javascript'>");
	if (boardResult!=0) {
		out.println("alert('���� �Ǿ����ϴ�.');");
	} else {
		out.println("alert('������ �����Ͽ����ϴ�.');");	
	}
	
	out.println("window.close();");
	out.println("opener.location.reload();");

	out.println("</script>");

%>

<%@ include file="/jsp/inc/inc_bottom.jsp" %>