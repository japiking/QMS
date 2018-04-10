
<%@page import="java.util.Date"%>
<%@page language="java" contentType="text/html; charset=EUC-KR"	pageEncoding="EUC-KR"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="qms.util.StringUtil"%>
<%@page import="java.nio.Buffer"%>
<%@page import="java.util.*,java.io.*"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="jxl.*"%>
<%@ page import="java.sql.*"%>
<%@ include file="/jsp/inc/inc_common.jsp" %>
<%@ include file="/jsp/inc/inc_header.jsp"%>
<%
	String projectId = userSession.getProjectID();
	String savePath = PropertyUtil.getInstance().getProperty("FilePath")+"/project_upload/"+projectId+"/WBS"; // 저장할 디렉토리   
	
	int sizeLimit = 30 * 1024 * 1024; // 용량제한   
	String formName = "";
	String fileName = "";
	Vector vFileName = new Vector();
	Vector vFileSize = new Vector();
	String[] aFileName = null;
	String[] aFileSize = null;
	long fileSize = 0;
	
	File dir = new File(savePath);
	
	if(!dir.exists()){		//디렉토리 존재여부 확인
		//디렉토리 생성
		dir.mkdirs(); 
	}
	
	MultipartRequest multi = new MultipartRequest(request, savePath, sizeLimit, "euc-kr", new DefaultFileRenamePolicy());

	Enumeration formNames = multi.getFileNames();

	while (formNames.hasMoreElements()) {

		formName = (String) formNames.nextElement();
		fileName = multi.getFilesystemName(formName);

		if (fileName != null) { // 파일이 업로드 되면   

			fileSize = multi.getFile(formName).length();
			vFileName.addElement(fileName);
			vFileSize.addElement(String.valueOf(fileSize));
		}
	}

	aFileName = (String[]) vFileName.toArray(new String[vFileName.size()]);
	aFileSize = (String[]) vFileSize.toArray(new String[vFileSize	.size()]);
%>

<%
	File tmpFile = new File(savePath +"/" + fileName);
		
	
	Workbook workbook = Workbook.getWorkbook(tmpFile);
	Sheet sheet = workbook.getSheet(2);
	int col = sheet.getColumns(); // 시트의 컬럼의 수를 반환한다.    
	int row = sheet.getRows(); // 시트의 열의 수를 반환한다.
%>
<html>
<head>
<!-- <title>Excel Document Reader</TITLE> -->
</head>
<body>
	<table border="1">
		<%
		try {
			boolean errTrue = false;
			SimpleDateFormat formatter = new SimpleDateFormat("YYYY-MM-dd");
			Map<String,Object> param = new HashMap<String,Object>();
			param.put("PROJECT_ID", 	userSession.getProjectID());
			
			// 데이터를 입력전 모두 삭제한다.
			int updateCount2	= qmsDB.insert("QMS_EXCEL_PROC.WBS_D001", param);
			
			int idx = 0;
			Object obj = null;
			for (int i = 13; i < row; i++) {	// 13 라인부터 들어갈 데이터
				for (int j = 1; j < 20; j++) {
					idx = j-1;
					obj = sheet.getCell(j, i).getContents();
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
						case 18 :
							param.put("CONFIRM_USER", obj);
							break;
					}
					
					// Date형식으로 된 셀의 데이터를 날짜형식으로 바꿔서 DB에 입력한다.
					if(!"".equals(StringUtil.null2void(obj))){
						if(idx == 7){
							DateCell tempCell = (DateCell)sheet.getCell(j, i);
							java.util.Date date = tempCell.getDate();
							param.put("PLAN_STTG_DATE", formatter.format(date));
						}else if(idx == 8 ){
							DateCell tempCell = (DateCell)sheet.getCell(j, i);
							java.util.Date date = tempCell.getDate();
							param.put("PLAN_ENDG_DATE", formatter.format(date));
						}else if(idx == 11 ){
							DateCell tempCell = (DateCell)sheet.getCell(j, i);
							java.util.Date date = tempCell.getDate();
							param.put("REAL_STTG_DATE", formatter.format(date));
						}else if(idx == 12 ){
							DateCell tempCell = (DateCell)sheet.getCell(j, i);
							java.util.Date date = tempCell.getDate();
							param.put("REAL_ENDG_DATE", formatter.format(date));
						}else if(idx == 16 ){
							DateCell tempCell = (DateCell)sheet.getCell(j, i);
							java.util.Date date = tempCell.getDate();
							param.put("PROGRESS_DATE", formatter.format(date));
						}
					}

					LogUtil.getInstance().debug("param["+idx+"]::::"+obj.toString());
				}
				
				int updateCount	= qmsDB.insert("QMS_EXCEL_PROC.WBS_C001", param);
				
				if(updateCount == 0){
					errTrue = true;
				}else{
					errTrue = false;
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
			
			if(tmpFile.exists()) {
				tmpFile.delete();
			}
		%>
		<%
		}catch (Exception e) {
			e.printStackTrace();
			if (qmsDB != null) try { qmsDB.rollback(); } catch (Exception e1) {}
		}finally{
			if (qmsDB != null) try { qmsDB.close(); } catch (Exception e1) {}
		}
		%>
	</table>
</body>
</html>
<%@ include file="/jsp/inc/inc_bottom.jsp"%>