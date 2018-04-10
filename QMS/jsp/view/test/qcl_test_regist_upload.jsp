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


<%
	String savePath = "C:\\";
	int sizeLimit = 30 * 1024 * 1024;
	Workbook workBook	=  null;
	try{
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		DBSeqUtil DButil = new DBSeqUtil();
		MultipartRequest multi = new MultipartRequest(request, savePath, sizeLimit, "euc-kr", new DefaultFileRenamePolicy());
		

		Enumeration<?> fileNames=multi.getFileNames();
		String fileName = multi.getFilesystemName(fileNames.nextElement().toString());
		
		if(fileName==null){
			out.print("입력되지 않았음");
			return;
		}
		String tmpFile= savePath + '/' + fileName;
		
		workBook			=  WorkbookFactory.create(new File(tmpFile));
		
		Sheet sheet			=  null;
		Row row				=  null;
		Cell cell			=  null;
		
		int sheetNum     =  workBook.getNumberOfSheets();
		
		String sheetName = new String();
		Object  obj		 = null;
		
		int idx = 0;
		boolean errTrue = false;
		
	    if(errTrue) {
			out.println("<script type='text/javascript'>");
			out.println("alert('처리중 오류가 발생하였습니다.');");
			out.println("location.reload();");
			out.println("</script>");
		}else {
			out.println("<script type='text/javascript'>");
			out.println("alert('정상 등록 되었습니다.');");
			out.println("window.self.close()");
			out.println("opener.location.href='/QMS/jsp/view/qcl/qcl_test_regist_view.jsp';");
			out.println("</script>");
		}
	}catch (Exception e) {
		e.printStackTrace();
		
	}finally{
		if(workBook != null) workBook.close();
	
	}

%>
<html>

<head>

<script type="text/javascript">
function delfile() {

	
document.frm.action='qcl_test_regist_view.jsp'

document.frm.submit();

}
</script>
