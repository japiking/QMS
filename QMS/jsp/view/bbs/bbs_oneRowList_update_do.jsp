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
	String strUserId		    = StringUtil.null2void(userSession.getUserID());
	String boardID 				= StringUtil.null2void(multi.getParameter("BOARD_ID"));
	String bbsID 				= StringUtil.null2void(multi.getParameter("BBS_ID"));
	String title				= StringUtil.null2void(multi.getParameter("TITLE"));
	String pageNum				= StringUtil.null2void(multi.getParameter("PAGE_NUM"));
	
	String strFileFlag			= "N";
	LogUtil.getInstance().debug("SAMGU-bbs_oneRowList_update_do.jsp >> boardID:"+boardID+", bbsID:"+bbsID+", title:"+title);
	
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
		boardResult = qmsDB.update("QMS_BBS_ONELOW.BOARD_U001", paramU001);
		
	} catch (Exception e) {
		if (qmsDB != null) try { qmsDB.close(); } catch (Exception e1) {}
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