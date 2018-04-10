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
	String savePath = PropertyUtil.getInstance().getProperty("FilePath") +"/excelFile/"; // 저장할 디렉토리   
	int sizeLimit = 30 * 1024 * 1024; // 용량제한
	
	try{
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		MultipartRequest multi = new MultipartRequest(request, savePath, sizeLimit, "euc-kr", new DefaultFileRenamePolicy());
			
		Enumeration<?> fileNames=multi.getFileNames(); 									// file object의 이름 반환
		String fileName = multi.getFilesystemName(fileNames.nextElement().toString());
		
		if(fileName == null) {   // 파일이 업로드 되지 않았을때
			out.print("파일 업로드 되지 않았음");
			return;
		}
		
		File tmpFile = new File(savePath + "/" + fileName);		// 업로드 완료후 삭제처리
		
		LogUtil.getInstance().debug("LSJ===FILE1>>"+tmpFile.getPath());
		LogUtil.getInstance().debug("LSJ===FILE2>>"+tmpFile.getName());
		
		// 데이터를 입력전 모두 삭제한다.
		StringBuffer sb1 = new StringBuffer();
		sb1.append("DELETE                									\n");
		sb1.append("FROM   WBS                								\n");
		sb1.append("WHERE PROJECT_ID = '"+userSession.getProjectID()+"'     \n");
		int updateCount2	= QueryHelper.execute(sb1.toString(), null);   // DF MST INSERT

		/** xlsx 파일 읽기 **************************/
		XSSFWorkbook workBook	=  new XSSFWorkbook(new FileInputStream(tmpFile));
		XSSFSheet sheet			=  null;
		XSSFRow row				=  null;
		XSSFCell cell			=  null;
		/** xlsx 파일 읽기 **************************/
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
		// Sheet를 검색
		for(int k=0;k<sheetNum; k++){
			sheet		= workBook.getSheetAt(k);
			sheetName	= sheet.getSheetName();
			
			// WBS시트의 내용만 읽어온다.
			if("WBS".equals(sheetName)){
				int rows	=  sheet.getPhysicalNumberOfRows();
				
				// Row행을 읽어온다.
				for(int r=13;r<rows;r++){
					row     =  sheet.getRow(r);
					int cells   =  row.getPhysicalNumberOfCells();
					
					// Column 열을 읽어온다.
				    for(short c=1; c<19; c++){
				    	cell   	= row.getCell(c);
				    	idx 	= c-1;
				        
						// Null일 경우
				        if(cell== null){
							continue;
						}
						
						// 해당 타입에 맞게 데이터를 가져온다.
				        switch(cell.getCellType()){
				        	case 0 :
				        		// Date 형식일 경우 MM-dd형태로 포맷
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
 						
						// 13번(첫째)열은 수식으로 날짜타입이 만들어져 있어 강제로 포맷팅을 한다.
						if(r==13){
 							if(idx == 7 || idx == 8 || idx == 11 || idx == 12 || idx == 16){
 								if(null != cell.getDateCellValue()){
		 							Date date = cell.getDateCellValue();
									param[idx] = formatter.format(date);
 								}
 							}
 						}
 						
 						// 실제진척율 Cell
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
			out.println("alert('처리중 오류가 발생하였습니다.');");
			out.println("location.reload();");
			out.println("</script>");
		}else {
			out.println("<script type='text/javascript'>");
			out.println("alert('정상 등록 되었습니다.');");
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