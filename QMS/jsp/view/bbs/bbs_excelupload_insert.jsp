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
	int sizeLimit = 30 * 1024 * 1024; // 용량제한
	Workbook workBook	=  null;
	File dir = new File(savePath);
	
	if(!dir.exists()){		//디렉토리 존재여부 확인
		//디렉토리 생성
		dir.mkdirs(); 
	}
	
	try{
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		DBSeqUtil DButil = new DBSeqUtil();
		MultipartRequest multi = new MultipartRequest(request, savePath, sizeLimit, "euc-kr", new DefaultFileRenamePolicy());
		Map<String,Object> param 	 = new HashMap<String,Object>();
		Enumeration<?> fileNames=multi.getFileNames(); 									// file object의 이름 반환
		String fileName = multi.getFilesystemName(fileNames.nextElement().toString());
		
		if(fileName == null) {   // 파일이 업로드 되지 않았을때
			out.print("파일 업로드 되지 않았음");
			return;
		}
	
		String  tmpFile = savePath + "/" + fileName;		// 업로드 완료후 삭제처리
		
		/** xlsx 파일 읽기 **************************/
		workBook			=  WorkbookFactory.create(new File(tmpFile));
		
		Sheet sheet			=  null;
		Row row				=  null;
		Cell cell			=  null;

		/** xlsx 파일 읽기 **************************/
		int sheetNum     =  workBook.getNumberOfSheets();
		
		String sheetName = new String();
		Object  obj		 = null;
		
		int idx = 0;
		boolean errTrue = false;
		
		// Sheet를 검색
	    for(int k = 0; k < sheetNum; k ++){
	        
	        // 시트를 가져옴
	       sheet = workBook.getSheetAt(k);
	        
	        int rows = sheet.getPhysicalNumberOfRows();
	    	
	        for(int r = 1; r < rows; r ++){
	            
	            // 행 정보를 가져옴
	            row = sheet.getRow(r);
            
	            int cells = row.getPhysicalNumberOfCells();
	            
	            for(short c = 0; c < cells; c ++){
	            
	                // 셀 정보를 가져옴
	                cell = row.getCell(c);
	                idx 	= c;
	                
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
		        			obj = StringUtil.null2void(cell.getStringCellValue());
			        }
					
			     	// row위치에 따라 데이터를 parma에 넣는다.
					switch(idx){
						case 0 :
							param.put("TITLE", obj);
							break;
						case 1 :
							param.put("CONTENTS", obj);
							break;
						case 2 :
							
							if("완료".equals(obj)) {
								param.put("STATE", 				"111");
							}else if("진행".equals(obj)) {
								param.put("STATE", 				"000");
							}else if("제외".equals(obj)) {
								param.put("STATE", 				"999");
							}else if("등록".equals(obj)) {
								param.put("STATE", 				"222");
							}else if("완료요청".equals(obj)) {
								param.put("STATE", 				"333");
							}else if("제외요청".equals(obj)) {
								param.put("STATE", 				"444");
							}else if("삭제요청".equals(obj)) {
								param.put("STATE", 				"555");
							}else {
								param.put("STATE", 				"");
							}
							
							break;
						case 3 :
							
							param.put("CHANEL_NAME", obj);			// 채널명
							break;
						case 4 :
							
							param.put("COMPLETION_DATE", obj);		// 완료일
							break;
						case 5 :
							param.put("CONFIRM_USER", obj);			// 확인자
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
	
		// 엑셀 업로드후 DB입력이 완료되면 업로드된 파일을 삭제한다.
	/* 	File deFile = new File(tmpFile);
		
	 	if(deFile.exists()){
	 		deFile.delete();
	 	} */
		
	    if(errTrue) {
			out.println("<script type='text/javascript'>");
			out.println("alert('처리중 오류가 발생하였습니다.');");
			out.println("location.reload();");
			out.println("</script>");
		}else {
			out.println("<script type='text/javascript'>");
			out.println("alert('정상 등록 되었습니다.');");
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