<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<%@ include file="/jsp/inc/inc_common.jsp"%>
<%@ include file="/jsp/inc/inc_header.jsp"%>
<%@ page import="java.sql.*,java.text.*"%>
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="org.apache.poi.poifs.filesystem.POIFSFileSystem"%>
<%@ page import="org.apache.poi.hssf.record.*"%>
<%@ page import="org.apache.poi.hssf.model.*"%>
<%@ page import="org.apache.poi.hssf.usermodel.*"%>
<%@ page import="org.apache.poi.hssf.util.*"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="java.util.Enumeration"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.File"%>
<%@page import="org.apache.poi.xssf.usermodel.XSSFSheet"%>
<%@page import="org.apache.poi.xssf.usermodel.XSSFWorkbook"%>
<%@page import="org.apache.poi.xssf.usermodel.XSSFCellStyle"%>
<%@page import="org.apache.poi.ss.usermodel.DateUtil"%>
<%@page import="org.apache.poi.xssf.usermodel.XSSFCell"%>
<%@page import="org.apache.poi.xssf.usermodel.XSSFRow"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>

<%
	String project_id = userSession.getProjectID();
	

	Map<String, String> sc_param = new HashMap<String, String>();
	Map<String, String> cs_param = new HashMap<String, String>();
	Map<String, String> st_param = new HashMap<String, String>();

	String savePath = PropertyUtil.getInstance().getProperty("FilePath")+"/project_upload/"+project_id+"/QC";
	int sizeLimit = 30 * 1024 * 1024;															//파일 크기 제한	

	File dir = new File(savePath);
	
	if(!dir.exists()){		//디렉토리 존재여부 확인
		//디렉토리 생성
		dir.mkdirs(); 
	}
	
	try {
		MultipartRequest multi 		= new MultipartRequest(request,savePath, sizeLimit, "euc-kr",new DefaultFileRenamePolicy());
		Enumeration<?> fileNames	= multi.getFileNames();
		String fileName 			= multi.getFilesystemName(fileNames.nextElement().toString());
		String tmpFile 				= savePath + "/" + fileName;
		String fileType 			= fileName.substring(fileName.lastIndexOf(".") + 1);
		String test_id 				= StringUtil.null2void(multi.getParameter("TEST_ID"));
		if ("xls".equals(fileType)) {															//.xls 출력
			POIFSFileSystem fs 		= new POIFSFileSystem(new FileInputStream(tmpFile));
			DecimalFormat df 		= new DecimalFormat();

			HSSFWorkbook workbook 	= new HSSFWorkbook(fs);
			int sheetNum 			= workbook.getNumberOfSheets();
			String data 			= null;
			org.apache.poi.ss.usermodel.FormulaEvaluator evaluator = workbook.getCreationHelper().createFormulaEvaluator();
			boolean errTrue = false;
			for (int k = 0; k < sheetNum; k++) {
				String sc_id	  	= null;
				String cs_id	  	= null;
				HSSFSheet sheet 	= workbook.getSheetAt(k);
				int rows 			= sheet.getPhysicalNumberOfRows();

				for (int r = 2; r < rows; r++) {
					
					LogUtil.getInstance().debug("1");
					HSSFRow row 	= sheet.getRow(r);

					if (row != null) {
						int cells 	= row.getPhysicalNumberOfCells();

						for (int c = 0; c <= cells; c++) {
							HSSFCell cell = row.getCell(c);
							
							if (cell == null) {

								continue;
							}

							switch (cell.getCellType()) {							

							case HSSFCell.CELL_TYPE_FORMULA:
								if (!(cell.toString() == "")) {					
									if (evaluator.evaluateFormulaCell(cell) == HSSFCell.CELL_TYPE_NUMERIC) {
										double fddata = cell.getNumericCellValue();
										data = df.format(fddata);
									} else if (evaluator.evaluateFormulaCell(cell) == HSSFCell.CELL_TYPE_STRING) {
										data = cell.getStringCellValue();

									} else if (evaluator.evaluateFormulaCell(cell) == HSSFCell.CELL_TYPE_BOOLEAN) {
										boolean fbdata = cell.getBooleanCellValue();
										data = String.valueOf(fbdata);

									}

								}
								break;

							case HSSFCell.CELL_TYPE_NUMERIC:
								data = cell.getNumericCellValue() + "";
								break;

							case HSSFCell.CELL_TYPE_STRING:
								data = cell.getStringCellValue() + "";
								break;

							case HSSFCell.CELL_TYPE_BLANK:
								data = cell.getBooleanCellValue() + "";
								break;

							case HSSFCell.CELL_TYPE_ERROR:
								data = cell.getErrorCellValue() + "";
								break;
							}
							if (data == "false") {
								continue;
							}

							switch (c) {												//엑셀 내용 DB 저장
							
							case 0:	
								sc_param.put("SCENARIO_ID", data);		
								cs_param.put("SCENARIO_ID", data);
								st_param.put("SCENARIO_ID", data);
								break;
							case 1:
								sc_param.put("SCENARIO_NM", data);			
								break;
							case 3:
								cs_param.put("CASE_ID", data);
								st_param.put("CASE_ID", data);
								break;
							case 4:
								cs_param.put("CASE_NM", data);
								break;
							case 5:
								sc_param.put("START_DATE", data);						
								cs_param.put("START_DATE", data);
								st_param.put("START_DATE", data);
								break;
							case 6:
								sc_param.put("END_DATE", data);
								cs_param.put("END_DATE", data);
								st_param.put("END_DATE", data);
								break;
							case 8:
								st_param.put("STEP_ID", data);
								break;
							case 9:
								st_param.put("EXPLAN", data);
								break;
							case 10:
								st_param.put("STEP_NM",data);
							case 14:
								st_param.put("DETAIL_PLAN", data);
								break;
							}
						}
					}
					sc_param.put("PROJECT_ID", project_id);
					sc_param.put("DEL_FLAG", "N");

					st_param.put("PROJECT_ID", project_id);
					st_param.put("DEL_FLAG", "N");

					cs_param.put("PROJECT_ID", project_id);
					cs_param.put("DEL_FLAG", "N");

					sc_param.put("TEST_ID", test_id);
					cs_param.put("TEST_ID", test_id);
					st_param.put("TEST_ID", test_id);

					if(sc_param.get("SCENARIO_ID")!=""){
						sc_id = sc_param.get("SCENARIO_ID");
						cs_id=cs_param.get("CASE_ID");
						int dbRlt = qmsDB.insert(
								"QMS_QUALITYCONTROL.SCENARIO_C001",
								sc_param);
						int dbRlt1 = qmsDB.insert(
								"QMS_QUALITYCONTROL.CIRCUMSTANCE_C001",
								cs_param);
						int dbRlt2 = qmsDB.insert(
								"QMS_QUALITYCONTROL.STEP_C001", st_param);
					}else if(sc_param.get("SCENARIO_ID")=="" && cs_param.get("CASE_ID")!=""){
						cs_id=cs_param.get("CASE_ID");
						cs_param.put("SCENARIO_ID",sc_id);
						st_param.put("SCENARIO_ID",sc_id);
						int dbRlt1 = qmsDB.insert(
								"QMS_QUALITYCONTROL.CIRCUMSTANCE_C001",
								cs_param);
						int dbRlt2 = qmsDB.insert(
								"QMS_QUALITYCONTROL.STEP_C001", st_param);
					}
					else if(sc_param.get("SCENARIO_ID")=="" && cs_param.get("CASE_ID")==""){
						st_param.put("SCENARIO_ID",sc_id);
						st_param.put("CASE_ID",cs_id);
						int dbRlt2 = qmsDB.insert(
								"QMS_QUALITYCONTROL.STEP_C001", st_param);
					}
					
					
				}
			}

		} else if ("xlsx".equals(fileType)) {														//.xlsx 출력
			XSSFWorkbook workbook 		= new XSSFWorkbook(new FileInputStream(tmpFile));
			XSSFSheet sheet 			= null;
			XSSFRow row 				= null;
			XSSFCell cell 				= null;

			SimpleDateFormat formatter 	= new SimpleDateFormat("yyyy-MM-dd");
			int sheetNum 				= workbook.getNumberOfSheets();
			String sheetName 			= new String();
			String obj 					= null;
			String obj1 				= null;
			String obj2 				= null;

			boolean errTrue = false;
			for (int k = 0; k < sheetNum; k++) {
				String sc_id	  		= null;
				String cs_id	  		= null;
				sheet 					= workbook.getSheetAt(k);
				sheetName 				= sheet.getSheetName();
				int rows 				= sheet.getPhysicalNumberOfRows();
				for (int r = 2; r < rows; r++) {
					row 				= sheet.getRow(r);
					int cells 			= row.getPhysicalNumberOfCells();
					for (short c = 0; c < cells; c++) {
						cell 			= row.getCell(c);
						if (cell == null) {
							continue;
						}
						switch (cell.getCellType()) {
						case 0:
							// Date 형식일 경우 MM-dd형태로 포맷
							if (DateUtil.isCellDateFormatted(cell)) {
								Date date 	= cell.getDateCellValue();
								obj 		= formatter.format(date);
							} else {

							}
							break;
						case 1:
							obj = cell.getStringCellValue();
							break;
						default:
							obj = StringUtil.null2void(cell
									.getRawValue());
						}
						switch (c) {
						case 0:
							sc_param.put("SCENARIO_ID", obj);
							cs_param.put("SCENARIO_ID", obj);
							st_param.put("SCENARIO_ID", obj);
							break;
						case 1:
							sc_param.put("SCENARIO_NM", obj);
							break;
						case 3:
							cs_param.put("CASE_ID", obj);
							st_param.put("CASE_ID", obj);
							break;
						case 4:
							cs_param.put("CASE_NM", obj);
							break;
						case 5:
							sc_param.put("START_DATE", obj);
							cs_param.put("START_DATE", obj);
							st_param.put("START_DATE", obj);
							break;
						case 6:
							sc_param.put("END_DATE", obj);
							cs_param.put("END_DATE", obj);
							st_param.put("END_DATE", obj);
							break;
						case 8:
							st_param.put("STEP_ID", obj);
							break;
						case 9:
							st_param.put("EXPLAN", obj);
							break;
						case 10:
							st_param.put("STEP_NM",obj);
						case 14:
							st_param.put("DETAIL_PLAN", obj);
							break;
						}

					}
					
					sc_param.put("PROJECT_ID", project_id);
					sc_param.put("DEL_FLAG", "N");

					st_param.put("PROJECT_ID", project_id);
					st_param.put("DEL_FLAG", "N");

					cs_param.put("PROJECT_ID", project_id);
					cs_param.put("DEL_FLAG", "N");

					sc_param.put("TEST_ID", test_id);
					cs_param.put("TEST_ID", test_id);
					st_param.put("TEST_ID", test_id);
					
					if(sc_param.get("SCENARIO_ID")!=""){
						sc_id 		= sc_param.get("SCENARIO_ID");
						cs_id		=cs_param.get("CASE_ID");
						int dbRlt 	= qmsDB.insert("QMS_QUALITYCONTROL.SCENARIO_C001",sc_param);
						int dbRlt1 	= qmsDB.insert("QMS_QUALITYCONTROL.CIRCUMSTANCE_C001",cs_param);
						int dbRlt2 	= qmsDB.insert("QMS_QUALITYCONTROL.STEP_C001", st_param);
					}else if(sc_param.get("SCENARIO_ID")=="" && cs_param.get("CASE_ID")!=""){
						cs_id=cs_param.get("CASE_ID");
						cs_param.put("SCENARIO_ID",sc_id);
						st_param.put("SCENARIO_ID",sc_id);
						int dbRlt1 	= qmsDB.insert("QMS_QUALITYCONTROL.CIRCUMSTANCE_C001",cs_param);
						int dbRlt2 	= qmsDB.insert("QMS_QUALITYCONTROL.STEP_C001", st_param);
					}
					else if(sc_param.get("SCENARIO_ID")=="" && cs_param.get("CASE_ID")==""){
						st_param.put("SCENARIO_ID",sc_id);
						st_param.put("CASE_ID",cs_id);
						int dbRlt2 	= qmsDB.insert("QMS_QUALITYCONTROL.STEP_C001", st_param);
					}
					
				}
			}
		}

		File deFile = new File(tmpFile);

		/*String str = new String();
		str +="<script type='text/javascript'> ";
		str +="window.self.close();			";
		str +="opener.location.href='/QMS/jsp/view/qcl/qcl_test_regist_view.jsp?TEST_ID="+test_id+"';";
		str +="</script>";*/
		out.println("<script type='text/javascript'>");
		out.println("alert('정상 등록 되었습니다.');");
		out.println("window.self.close()");
		out.println("opener.location.href='/QMS/jsp/view/qcl/qcl_test_regist_view.jsp?TEST_ID="+test_id+"';");
		out.println("opener.location.reload();");
		out.println("</script>");
		
	} catch (Exception e) {
		e.printStackTrace();
		if (qmsDB != null)
			try {
				qmsDB.rollback();
			} catch (Exception e1) {
			}
	} finally {
		if (qmsDB != null)
			try {
				qmsDB.close();
			} catch (Exception e1) {
			}

	}
%>
<body>
<input type="hidden" id="sc_id" name="sc_id"/>
<input type="hidden" id="cs_id" name="cs_id"/>
</body>