<%@page language="java" contentType="text/html; charset=EUC-KR"	pageEncoding="EUC-KR"%>
<%@page import="java.util.Date"%>
<%@page import="org.apache.poi.ss.usermodel.DateUtil"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="org.apache.poi.xssf.usermodel.XSSFCellStyle"%>

<%@page import="org.apache.poi.xssf.usermodel.XSSFCell"%>
<%@page import="org.apache.poi.xssf.usermodel.XSSFRow"%>
<%@page import="org.apache.poi.xssf.usermodel.XSSFSheet"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="org.apache.poi.xssf.usermodel.XSSFWorkbook"%>
<%@page import="java.io.File"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="java.util.Enumeration"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@ include file="/jsp/inc/inc_common.jsp" %>
<%@ include file="/jsp/inc/inc_header.jsp"%>
<%
	String projectId = userSession.getProjectID();
	String savePath = PropertyUtil.getInstance().getProperty("FilePath")+"/project_upload/"+projectId+"/WBS"; // ������ ���丮     
	int sizeLimit = 30 * 1024 * 1024; // �뷮����
	XSSFWorkbook workBook	= null;
	
	File dir = new File(savePath);
	
	if(!dir.exists()){		//���丮 ���翩�� Ȯ��
		//���丮 ����
		dir.mkdirs(); 
	}
	try{
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		MultipartRequest multi = new MultipartRequest(request, savePath, sizeLimit, "euc-kr", new DefaultFileRenamePolicy());
		Map<String,Object> param 	 = new HashMap<String,Object>();
		Enumeration<?> fileNames=multi.getFileNames(); 									// file object�� �̸� ��ȯ
		String fileName = multi.getFilesystemName(fileNames.nextElement().toString());
		
		if(fileName == null) {   // ������ ���ε� ���� �ʾ�����
			out.print("���� ���ε� ���� �ʾ���");
			return;
		}
		
		File tmpFile = new File(savePath + "/" + fileName);		// ���ε� �Ϸ��� ����ó��
		

		LogUtil.getInstance().debug("LSJ===FILE1>>"+tmpFile.getPath());
		LogUtil.getInstance().debug("LSJ===FILE2>>"+tmpFile.getName());
		
		param.put("PROJECT_ID", 	userSession.getProjectID());
		// �����͸� �Է��� ��� �����Ѵ�.
		int updateCount2	= qmsDB.insert("QMS_EXCEL_PROC.WBS_D001", param);

		/** xlsx ���� �б� **************************/
		workBook				=  new XSSFWorkbook(new FileInputStream(tmpFile));
		XSSFSheet sheet			=  null;
		XSSFRow row				=  null;
		XSSFCell cell			=  null;
		/** xlsx ���� �б� **************************/
		int sheetNum     =  workBook.getNumberOfSheets();
		String sheetName = new String();
		Object  obj		 = null;
		
		int idx = 0;
		boolean errTrue = false;
		// Sheet�� �˻�
		for(int k=0;k<sheetNum; k++){
			sheet		= workBook.getSheetAt(k);
			sheetName	= sheet.getSheetName();
			
			// WBS��Ʈ�� ���븸 �о�´�.
			if("WBS".equals(sheetName)){
				int rows	=  sheet.getPhysicalNumberOfRows();
				
				// Row���� �о�´�.
				for(int r=13;r<rows;r++){
					row     =  sheet.getRow(r);
					int cells   =  row.getPhysicalNumberOfCells();
					
					// Column ���� �о�´�.
				    for(short c=1; c<19; c++){
				    	cell   	= row.getCell(c);
				    	idx 	= c-1;
						LogUtil.getInstance().debug("excel["+r+"]"+"["+c+"]----CellType["+cell.getCellType()+"] value("+(idx)+")["+obj+"]");
				        
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
			        			obj = StringUtil.null2void(cell.getRawValue());
				        }
						
				        if(idx == 7||idx == 8||idx == 11||idx == 12 ){
				        	try {
				        		cell.getDateCellValue();
				        	}catch(IllegalStateException e){
				        		LogUtil.getInstance().debug("date type error excel["+r+"]"+"["+c+"] CellType["+cell.getCellType()+"] CellValue["+cell.getRawValue()+"]");
				        		continue;
			        		}
				        	if(cell.getDateCellValue() != null){
								Date date = cell.getDateCellValue();								
								obj = formatter.format(date);
				        	}
						} 
						// row��ġ�� ���� �����͸� parma�� �ִ´�.
						switch(idx){
							case 0 :
								param.put("SEQ", obj);
								break;
							case 1 :
								param.put("TASK_LEVEL", obj);
								break;
							case 2 :
								param.put("TASK_CODE", obj);
								break;
							case 3 :
								param.put("TASK_TITLE", obj);
								break;
							case 4 :
								param.put("TASK_DOCUMENT", obj);
								break;
							case 5 :
								param.put("TASK_RNR", obj);
								break;
							case 6 :
								param.put("STATE", obj);
								break;
							case 7 :
								param.put("PLAN_STTG_DATE", obj);
								break;
							case 8 :
								param.put("PLAN_ENDG_DATE", obj);
								break;
							case 9 :
								param.put("PLAN_MAJOR", obj);
								break;
							case 10 :
								param.put("PLAN_TERM", obj);
								break;
							case 11 :
								param.put("REAL_STTG_DATE", obj);
								break;
							case 12 :
								param.put("REAL_ENDG_DATE", obj);
								break;
							case 13 :
								param.put("REAL_MAJOR", obj);
								break;
							case 14 :
								param.put("REAL_TERM", obj);
								break;
							case 15 :
								param.put("TOT_PERIOD", obj);
								break;
							case 16 :
								param.put("PROGRESS_DATE", obj);
								break;
							case 17 :
								param.put("REAL_PROGRESS", obj);
								break;
						}
						
						if( 0 == idx){//��ȹ��ô��
 							param.put("SEQ",cell.getRawValue() );
 						} else if( 1 == idx){//��ȹ��ô��
 							param.put("TASK_LEVEL",cell.getRawValue() );
 						}  else if(16 == idx){//��ȹ��ô��
							if(String.valueOf(obj) != null && !"".equals(String.valueOf(obj))){
	 							try{
									double prc_val = Double.parseDouble(String.valueOf(obj));
		 							param.put("PROGRESS_DATE", String.format("%.2f",  prc_val*100d) +"%");
	 							}catch(NumberFormatException e){
	 								LogUtil.getInstance().debug("number type error excel["+r+"]"+"["+c+"] CellType["+cell.getCellType()+"] CellValue["+cell.getRawValue()+"]");
	 								param.put("PROGRESS_DATE", String.format("%.2f",  0) +"%");
	 							}
							}
 						} else if(17 == idx){// ������ô�� Cells
 							if(String.valueOf(obj) != null && !"".equals(String.valueOf(obj))){
 								try{
									double prc_val = Double.parseDouble(String.valueOf(obj));
		 							param.put("REAL_PROGRESS", String.format("%.2f",  prc_val*100d) +"%");
	 							}catch(NumberFormatException e){
	 								LogUtil.getInstance().debug("number type error excel["+r+"]"+"["+c+"] CellType["+cell.getCellType()+"] CellValue["+cell.getRawValue()+"]");
	 								param.put("REAL_PROGRESS", String.format("%.2f",  0) +"%");
	 							}
 							}
 						}
 						
						
				    }
				    int updateCount	= qmsDB.insert("QMS_EXCEL_PROC.WBS_C001", param);
			  		
			  		if(updateCount == 0){
						errTrue = true;
					}else{
						errTrue = false;
					}
				}
			}
		}
		
		// ���� ���ε��� DB�Է��� �Ϸ�Ǹ� ���ε�� ������ �����Ѵ�.
		if(tmpFile.exists()){
			tmpFile.delete();
		}

		if(errTrue) {
			out.println("<script type='text/javascript'>");
			out.println("alert('ó���� ������ �߻��Ͽ����ϴ�.');");
			out.println("location.reload();");
			out.println("</script>");
		}else {
			out.println("<script type='text/javascript'>");
			out.println("alert('���� ��� �Ǿ����ϴ�.');");
			out.println("window.self.close()");
			out.println("opener.location.href='/QMS/jsp/view/bbs/bbs_wbs_view.jsp?BOARD_ID="+multi.getParameter("BOARD_ID")+"';");
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