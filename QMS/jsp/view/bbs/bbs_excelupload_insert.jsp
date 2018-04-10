<%@page language="java" contentType="text/html; charset=EUC-KR"	pageEncoding="EUC-KR"%>
<%@page import="java.util.Date"%>
<%@page import="org.apache.poi.ss.usermodel.DateUtil"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="org.apache.poi.xssf.usermodel.XSSFCellStyle"%>

<%@page import="org.apache.poi.ss.usermodel.Cell"%>
<%@page import="org.apache.poi.ss.usermodel.Row"%>
<%@page import="org.apache.poi.ss.usermodel.Sheet"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="org.apache.poi.ss.usermodel.Workbook"%>
<%@page import="org.apache.poi.ss.usermodel.WorkbookFactory"%>
<%@page import="java.io.File"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="java.util.Enumeration"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@ include file="/jsp/inc/inc_common.jsp" %>
<%@ include file="/jsp/inc/inc_header.jsp"%>
<%
	String projectId = userSession.getProjectID();
	String savePath = PropertyUtil.getInstance().getProperty("FilePath")+"/project_upload/"+projectId+"/BBS";   
	int sizeLimit = 30 * 1024 * 1024; // �뷮����
	Workbook workBook	=  null;
	File dir = new File(savePath);
	
	if(!dir.exists()){		//���丮 ���翩�� Ȯ��
		//���丮 ����
		dir.mkdirs(); 
	}
	
	try{
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		DBSeqUtil DButil = new DBSeqUtil();
		MultipartRequest multi = new MultipartRequest(request, savePath, sizeLimit, "euc-kr", new DefaultFileRenamePolicy());
		Map<String,Object> param 	 = new HashMap<String,Object>();
		Enumeration<?> fileNames=multi.getFileNames(); 									// file object�� �̸� ��ȯ
		String fileName = multi.getFilesystemName(fileNames.nextElement().toString());
		
		if(fileName == null) {   // ������ ���ε� ���� �ʾ�����
			out.print("���� ���ε� ���� �ʾ���");
			return;
		}
	
		String  tmpFile = savePath + "/" + fileName;		// ���ε� �Ϸ��� ����ó��
		
		/** xlsx ���� �б� **************************/
		workBook			=  WorkbookFactory.create(new File(tmpFile));
		
		Sheet sheet			=  null;
		Row row				=  null;
		Cell cell			=  null;

		/** xlsx ���� �б� **************************/
		int sheetNum     =  workBook.getNumberOfSheets();
		
		String sheetName = new String();
		Object  obj		 = null;
		
		int idx = 0;
		boolean errTrue = false;
		
		// Sheet�� �˻�
	    for(int k = 0; k < sheetNum; k ++){
	        
	        // ��Ʈ�� ������
	       sheet = workBook.getSheetAt(k);
	        
	        int rows = sheet.getPhysicalNumberOfRows();
	    	
	        for(int r = 1; r < rows; r ++){
	            
	            // �� ������ ������
	            row = sheet.getRow(r);
            
	            int cells = row.getPhysicalNumberOfCells();
	            
	            for(short c = 0; c < cells; c ++){
	            
	                // �� ������ ������
	                cell = row.getCell(c);
	                idx 	= c;
	                
	             	// Null�� ���
			        if(cell== null){
						continue;
					}
	             	
			     	// �ش� Ÿ�Կ� �°� �����͸� �����´�.
			        switch(cell.getCellType()){
			        	case 0 :
			        		// Date ������ ��� MM-dd���·� ����
							if(DateUtil.isCellDateFormatted(cell)){
								Date date = cell.getDateCellValue();
								obj = formatter.format(date);
							} else {
								obj = cell.getNumericCellValue();
							}
			        		break;
			       		case 1 :
			        		obj = cell.getStringCellValue();
			        		break;
		        		default : 
		        			obj = StringUtil.null2void(cell.getStringCellValue());
			        }
					
			     	// row��ġ�� ���� �����͸� parma�� �ִ´�.
					switch(idx){
						case 0 :
							param.put("TITLE", obj);
							break;
						case 1 :
							param.put("CONTENTS", obj);
							break;
						case 2 :
							
							if("�Ϸ�".equals(obj)) {
								param.put("STATE", 				"111");
							}else if("����".equals(obj)) {
								param.put("STATE", 				"000");
							}else if("����".equals(obj)) {
								param.put("STATE", 				"999");
							}else if("���".equals(obj)) {
								param.put("STATE", 				"222");
							}else if("�Ϸ��û".equals(obj)) {
								param.put("STATE", 				"333");
							}else if("���ܿ�û".equals(obj)) {
								param.put("STATE", 				"444");
							}else if("������û".equals(obj)) {
								param.put("STATE", 				"555");
							}else {
								param.put("STATE", 				"");
							}
							
							break;
						case 3 :
							
							param.put("CHANEL_NAME", obj);			// ä�θ�
							break;
						case 4 :
							
							param.put("COMPLETION_DATE", obj);		// �Ϸ���
							break;
						case 5 :
							param.put("CONFIRM_USER", obj);			// Ȯ����
							break;
							/* 
						case 6:
							param.put("COMPLETION_DATE", obj);
							break;
							 */
					}
	            }
				
	            param.put("BOARD_ID", multi.getParameter("BOARD_ID"));
	            param.put("BBS_USER", userSession.getUserID());
				param.put("BBS_ID", DBSeqUtil.getBbsId());
				
	            int updateCount	= qmsDB.insert("QMS_EXCEL_PROC.BOARD_C001", param);				
	       		
	           	if(updateCount == 0){
					errTrue = true;
				}else{
					errTrue = false;
				}
	        }
	    }
	
		// ���� ���ε��� DB�Է��� �Ϸ�Ǹ� ���ε�� ������ �����Ѵ�.
	/* 	File deFile = new File(tmpFile);
		
	 	if(deFile.exists()){
	 		deFile.delete();
	 	} */
		
	    if(errTrue) {
			out.println("<script type='text/javascript'>");
			out.println("alert('ó���� ������ �߻��Ͽ����ϴ�.');");
			out.println("location.reload();");
			out.println("</script>");
		}else {
			out.println("<script type='text/javascript'>");
			out.println("alert('���� ��� �Ǿ����ϴ�.');");
			out.println("window.self.close()");
			out.println("opener.location.href='/QMS/jsp/view/bbs/bbs_list_view.jsp?BOARD_ID="+multi.getParameter("BOARD_ID")+"';");
			out.println("</script>");
		}
	}catch (Exception e) {
		e.printStackTrace();
		if (qmsDB != null) try { qmsDB.rollback(); } catch (Exception e1) {}
	}finally{
		if(workBook != null) workBook.close();
		if (qmsDB != null) try { qmsDB.close(); } catch (Exception e1) {}
	}

%>
<%@ include file="/jsp/inc/inc_bottom.jsp"%>