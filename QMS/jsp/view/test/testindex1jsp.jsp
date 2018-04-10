<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
    <%@ include file="/jsp/inc/inc_common.jsp"%>
	<%@ include file="/jsp/inc/inc_header.jsp"%>

<script type="text/javascript">
function checkForm(){
	if(upload.file1.value=""){
		alert("파일 업로드");
	}else(!checkFileType(upload.file1.value)){
		alert("엑셀 파일만");
		return false;
	}
	document.upload.submit();
}
function checkFileType(){
	 var fileLen = filePath.length;   
	 var fileFormat = filePath.substring(fileLen - 4);   
	 fileFormatfileFormat = fileFormat.toLowerCase();   

	 if (fileFormat == ".xls"){ 
		 return true;    
	 }   else{return false;}   
   
}

</script>

<form action=excel.jsp name="upload1" method="POST" enctype="multipart/form-data">
<td><input type="file" name="file_up1" /></td>
<td><a onclick="checkForm();">전송</a>
</form>