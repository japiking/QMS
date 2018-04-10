<%@page import="qms.util.PropertyUtil"%>
<%@page language="java" contentType="text/html; charset=EUC-KR"	pageEncoding="EUC-KR"%>

<%@ page import="java.util.*"%>
<%@page import="java.io.*"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="org.apache.poi.xssf.usermodel.XSSFCell"%>
<%@page import="org.apache.poi.xssf.usermodel.XSSFRow"%>
<%@page import="org.apache.poi.xssf.usermodel.XSSFSheet"%>
<%@page import="org.apache.poi.xssf.usermodel.XSSFWorkbook"%>
<%@page import="java.util.Enumeration"%>

<%

	try{
		
		String savePath = "C:/dev"; // 저장할 디렉토리
		
		MultipartRequest mr = new MultipartRequest(request, savePath, 30 * 1024 * 1024, "euc-kr", new DefaultFileRenamePolicy());
		File s_file = mr.getFile("s_file");
		String o_name = mr.getOriginalFileName("s_file");
		
		Enumeration<?> fileNames=mr.getFileNames(); 
		String fileName = mr.getFilesystemName(fileNames.nextElement().toString());
		
		// 파일이 업로드 되지 않았을때
		if(fileName == null) {
			out.print("파일 업로드 되지 않았음");
			return;
		}
		
		File tmpFile = new File(savePath + "/" + fileName);
		System.out.println(" > filePath > "+savePath + "/" + fileName);
		
		/** xlsx 파일 읽기 **************************/
//		FileInputStream file = new FileInputStream(new File("D:\\test\\Book1.xlsx"));
//		XSSFWorkbook workbook = new XSSFWorkbook(file);
		
		System.out.println(" > 11 > ");
		XSSFSheet sheet			=  null;
		XSSFRow row				=  null;
		XSSFCell cell			=  null;
		
		System.out.println(" > 2 > ");
		XSSFWorkbook workBook	=  new XSSFWorkbook(new FileInputStream(tmpFile));

		System.out.println(" > 3 > ");

//		XSSFSheet sheet = workbook.getSheetAt(0);
//		XSSFRow row				=  null;
//		XSSFCell cell			=  null;
		
		/** xlsx 파일 읽기 **************************/
//		int sheetNum     =  workBook.getNumberOfSheets();
//		String sheetName = new String();
//		Object  obj		 = null;
		
		
//		FileInputStream excelFIS = new FileInputStream("D:\\Book1.xlsx");
//		XSSFWorkbook excelWB = new XSSFWorkbook(excelFIS);
//		XSSFSheet topSheet = excelWB.getSheetAt(0); 
		   
//		FileInputStream inputStream=new FileInputStream("D:\\Book1.xlsx");
//		XSSFWorkbook workbook = new XSSFWorkbook(inputStream);
//		XSSFWorkbook workBook = new XSSFWorkbook(new FileInputStream("D:\\Book1.xlsx"));
//		XSSFWorkbook work = new XSSFWorkbook(new FileInputStream(new File(excelFile)));
		
		
//		XSSFWorkbook workBook = new XSSFWorkbook(file);
		
		
//		System.out.println("sheet수 : " + sheetCn);
		
		
	} catch(Exception e) {
		e.printStackTrace(System.out);
	}

%>