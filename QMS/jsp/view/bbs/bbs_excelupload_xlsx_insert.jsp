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
	String savePath = PropertyUtil.getInstance().getProperty("FilePath")+"/project_upload/"+projectId+"/WBS"; // 저장할 디렉토리     
	int sizeLimit = 30 * 1024 * 1024; // 용량제한
	XSSFWorkbook workBook	= null;
	
	File dir = new File(savePath);
	
	if(!dir.exists()){		//디렉토리 존재여부 확인
		//디렉토리 생성
		dir.mkdirs(); 
	}
	try{
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		MultipartRequest multi = new MultipartRequest(request, savePath, sizeLimit, "euc-kr", new DefaultFileRenamePolicy());
		Map<String,Object> param 	 = new HashMap<String,Object>();
		Enumeration<?> fileNames=multi.getFileNames(); 									// file object의 이름 반환
		String fileName = multi.getFilesystemName(fileNames.nextElement().toString());
		
		if(fileName == null) {   // 파일이 업로드 되지 않았을때
			out.print("파일 업로드 되지 않았음");
			return;
		}
		
		File tmpFile = new File(savePath + "/" + fileName);		// 업로드 완료후 삭제처리
		

		LogUtil.getInstance().debug("LSJ===FILE1>>"+tmpFile.getPath());
		LogUtil.getInstance().debug("LSJ===FILE2>>"+tmpFile.getName());
		
		param.put("PROJECT_ID", 	userSession.getProjectID());
		// 데이터를 입력전 모두 삭제한다.
		int updateCount2	= qmsDB.insert("QMS_EXCEL_PROC.WBS_D001", param);

		/** xlsx 파일 읽기 **************************/
		workBook				=  new XSSFWorkbook(new FileInputStream(tmpFile));
		XSSFSheet sheet			=  null;
		XSSFRow row				=  null;
		XSSFCell cell			=  null;
		/** xlsx 파일 읽기 **************************/
		int sheetNum     =  workBook.getNumberOfSheets();
		String sheetName = new String();
		Object  obj		 = null;
		
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
						LogUtil.getInstance().debug("excel["+r+"]"+"["+c+"]----CellType["+cell.getCellType()+"] value("+(idx)+")["+obj+"]");
				        
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
						// row위치에 따라 데이터를 parma에 넣는다.
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
						
						if( 0 == idx){//계획진척율
 							param.put("SEQ",cell.getRawValue() );
 						} else if( 1 == idx){//계획진척율
 							param.put("TASK_LEVEL",cell.getRawValue() );
 						}  else if(16 == idx){//계획진척율
							if(String.valueOf(obj) != null && !"".equals(String.valueOf(obj))){
	 							try{
									double prc_val = Double.parseDouble(String.valueOf(obj));
		 							param.put("PROGRESS_DATE", String.format("%.2f",  prc_val*100d) +"%");
	 							}catch(NumberFormatException e){
	 								LogUtil.getInstance().debug("number type error excel["+r+"]"+"["+c+"] CellType["+cell.getCellType()+"] CellValue["+cell.getRawValue()+"]");
	 								param.put("PROGRESS_DATE", String.format("%.2f",  0) +"%");
	 							}
							}
 						} else if(17 == idx){// 실제진척율 Cells
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
		
		// 엑셀 업로드후 DB입력이 완료되면 업로드된 파일을 삭제한다.
		if(tmpFile.exists()){
			tmpFile.delete();
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
		
	}catch (Exception e) {
		e.printStackTrace();
		if (qmsDB != null) try { qmsDB.rollback(); } catch (Exception e1) {}
	}finally{
		if(workBook != null) workBook.close();
		if (qmsDB != null) try { qmsDB.close(); } catch (Exception e1) {}
	}
	
%>
<%@ include file="/jsp/inc/inc_bottom.jsp"%>