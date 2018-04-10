<%@page import="java.util.Date"%>
<%@page import="org.apache.poi.ss.usermodel.DateUtil"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="org.apache.poi.xssf.usermodel.XSSFCellStyle"%>
<%@page language="java" contentType="text/html; charset=EUC-KR"	pageEncoding="EUC-KR"%>

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
	String savePath = PropertyUtil.getInstance().getProperty("FilePath") +"/excelFile/"; // ������ ���丮   
	int sizeLimit = 30 * 1024 * 1024; // �뷮����
	
	try{
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		MultipartRequest multi = new MultipartRequest(request, savePath, sizeLimit, "euc-kr", new DefaultFileRenamePolicy());
			
		Enumeration<?> fileNames=multi.getFileNames(); 									// file object�� �̸� ��ȯ
		String fileName = multi.getFilesystemName(fileNames.nextElement().toString());
		
		if(fileName == null) {   // ������ ���ε� ���� �ʾ�����
			out.print("���� ���ε� ���� �ʾ���");
			return;
		}
		
		File tmpFile = new File(savePath + "/" + fileName);		// ���ε� �Ϸ��� ����ó��
		
		LogUtil.getInstance().debug("LSJ===FILE1>>"+tmpFile.getPath());
		LogUtil.getInstance().debug("LSJ===FILE2>>"+tmpFile.getName());
		
		// �����͸� �Է��� ��� �����Ѵ�.
		StringBuffer sb1 = new StringBuffer();
		sb1.append("DELETE                									\n");
		sb1.append("FROM   WBS                								\n");
		sb1.append("WHERE PROJECT_ID = '"+userSession.getProjectID()+"'     \n");
		int updateCount2	= QueryHelper.execute(sb1.toString(), null);   // DF MST INSERT

		/** xlsx ���� �б� **************************/
		XSSFWorkbook workBook	=  new XSSFWorkbook(new FileInputStream(tmpFile));
		XSSFSheet sheet			=  null;
		XSSFRow row				=  null;
		XSSFCell cell			=  null;
		/** xlsx ���� �б� **************************/
		int sheetNum     =  workBook.getNumberOfSheets();
		String sheetName = new String();
		Object[] param 	 = new Object[18];;
		Object  obj		 = null;
		
		StringBuffer sb2 = new StringBuffer();
		sb2.append("INSERT INTO WBS                \n");
		sb2.append("VALUES(                        \n");
		sb2.append("'"+userSession.getProjectID()+"',   /*PROJECT_ID      */      \n");
		sb2.append("?,   /*SEQ             */      \n");
		sb2.append("?,   /*TASK_LEVEL      */      \n");
		sb2.append("?,   /*TASK_CODE       */      \n");
		sb2.append("?,   /*TASK_TITLE      */      \n");
		sb2.append("?,   /*TASK_DOCUMENT   */      \n");
		sb2.append("?,   /*TASK_RNR        */      \n");
		sb2.append("?,   /*STATE           */      \n");
		sb2.append("?,   /*PLAN_STTG_DATE  */      \n");
		sb2.append("?,   /*PLAN_ENDG_DATE  */      \n");
		sb2.append("?,   /*PLAN_MAJOR      */      \n");
		sb2.append("?,   /*PLAN_TERM       */      \n");
		sb2.append("?,   /*REAL_STTG_DATE  */      \n");
		sb2.append("?,   /*REAL_ENDG_DATE  */      \n");
		sb2.append("?,   /*REAL_MAJOR      */      \n");
		sb2.append("?,   /*REAL_TERM       */      \n");
		sb2.append("?,   /*TOT_PERIOD      */      \n");
		sb2.append("?,   /*PROGRESS_DATE   */      \n");
		sb2.append("?,   /*REAL_PROGRESS   */      \n");
		sb2.append("'222', /*NOW_STATE   */        \n");
		sb2.append("'0'    /*IN_PROGRESS   */      \n");
		sb2.append(")                              \n");
		
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
									param[idx] = formatter.format(date);
								} else {
									param[idx] = cell.getNumericCellValue();
								}
				        		break;
				        	case 1 :
				        		param[idx] = cell.getStringCellValue();
				        		break;
			        		default : 
			        			param[idx] = StringUtil.null2void(cell.getRawValue());
				        }
 						
						// 13��(ù°)���� �������� ��¥Ÿ���� ������� �־� ������ �������� �Ѵ�.
						if(r==13){
 							if(idx == 7 || idx == 8 || idx == 11 || idx == 12 || idx == 16){
 								if(null != cell.getDateCellValue()){
		 							Date date = cell.getDateCellValue();
									param[idx] = formatter.format(date);
 								}
 							}
 						}
 						
 						// ������ô�� Cell
 						if(17 == idx){
 							double prc_val = Double.parseDouble(String.valueOf(param[idx]));
 							param[c-1] = (Math.round(prc_val*100d) / 100d) * 100 +"%";
 						}
 						
						LogUtil.getInstance().debug("LSJ----CellType["+cell.getCellType()+"] value("+(idx)+")["+param[idx]+"]");
				    }
				    int updateCount	= QueryHelper.execute(sb2.toString(), param);   // DF MST INSERT
			  		
			  		if(updateCount == 0){
						errTrue = true;
					}else{
						errTrue = false;
					}
				}
			}
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
		
	}catch(Exception e){
		e.printStackTrace(System.out);
		e.printStackTrace(System.out);
	}
	
%>
<%@ include file="/jsp/inc/inc_bottom.jsp"%>