<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ include file="/jsp/inc/inc_common.jsp" %>
<%@ include file="/jsp/inc/inc_header.jsp" %>
<%@ page language="java" contentType="application/vnd.ms-excel;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page contentType="text/html; charset=euc-kr" language="java" errorPage=""%>  
<%@page import="java.util.*,java.io.*" %>
<%@page import="com.oreilly.servlet.MultipartRequest" %>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@page import="jxl.*" %>  
<%@ page import="java.sql.*" %>
<%
	String filePath=request.getRealPath("/")+"upload/tmp";
	int sizeLimit = 30 * 1024 * 1024 ; // 용량제한   
	String formName = "";   
	String fileName = "";   
	Vector vFileName = new Vector();   
	Vector vFileSize = new Vector();   
	String[] aFileName = null;   
	String[] aFileSize = null;   
	long fileSize = 0;
	
	MultipartRequest multi = new MultipartRequest(request, filePath, sizeLimit, "euc-kr", new DefaultFileRenamePolicy());   
	Enumeration formNames = multi.getFileNames();    
	
	while (formNames.hasMoreElements()) 
	 {    
	  formName = (String)formNames.nextElement();    
	  fileName = multi.getFilesystemName(formName); 
	  if(fileName != null){
		  fileSize = multi.getFile(formName).length();   
		  vFileName.addElement(fileName);   
	      vFileSize.addElement(String.valueOf(fileSize));    
	  }
	 
	 }	 
	 aFileName = (String[])vFileName.toArray(new String[vFileName.size()]);   
	 aFileSize = (String[])vFileSize.toArray(new String[vFileSize.size()]); 
	 
	 Workbook workbook = Workbook.getWorkbook(new File(filePath + "/" + fileName));    
	 Sheet sheet = workbook.getSheet(0);  
	
	 int col = sheet.getColumns();
	 int row = sheet.getRows();
%>

 

<script type="text/javascript">

</script>
<tbody>
<%
	String project_id		= userSession.getProjectID();
	int Exceldb=0;
	Map<String,String> param=new HashMap<String,String>();
	param.put("PROJECT_ID",project_id);
	String [][] content = new String[row][col];
	for(int i=2; i<row; i++){
		for(int j=1; j<col; j++){
			content[i][j]=sheet.getCell(j,i).getContents();
			param.put("SCENARIO_ID",content[i][1]);
			param.put("SCENARIO_NM",content[i][2]);
			param.put("START_DATE",content[i][3]);
			param.put("END_DATE",content[i][4]);
		}
	}
	Exceldb = qmsDB.insert("QMS_QUALITYCONTROL.SCENARIO_R005",param);	
	
	
	

%>
</tbody>
</form>
<%@ include file="/jsp/inc/inc_bottom.jsp" %>