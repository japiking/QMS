<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>

<%@ include file="/jsp/inc/inc_common.jsp"%>
<%@ include file="/jsp/inc/inc_header.jsp"%>
<%
	// BBS_ID
	String board_id = StringUtil.null2void(request.getParameter("BOARD_ID"));
%>
<script type="text/javascript">

	$(document).ready(function(){
		$("#uploadBtn").click(function(){
			if(!confirm("이대로 올리시겠습니까?"))
				return;
			
			var filePath = document.frm.uploadFile.value;
			var fileLen = filePath.length;
			var fileFormat = filePath.substring(fileLen - 4);
			fileFormatfileFormat = fileFormat.toLowerCase();
			
			// 파일 형식에 따라 처리하는 라이브러리가 다르다.
			if (fileFormat == ".xls") {
				document.frm.action = "bbs_excelupload_insert2.jsp"
			} else if (fileFormat == "xlsx") {
				document.frm.action = "bbs_excelupload_xlsx_insert.jsp"
			}
			
			$("#frm").submit();
		})
	})

</script>
<div id="_LOADING_">
	<img alt="" src="" />
</div> 
<!-- <form  id="frm" name="frm" action="bbs_excelupload_insert2.jsp" method="post"  enctype="multipart/form-data" > -->
<form  id="frm" name="frm" method="post"  enctype="multipart/form-data" >
	<input type="hidden" name="BOARD_ID"	value="<%=board_id%>" />
	<input type="hidden" name="EXCEL_FILE"	value="" 	/>
	<br />
	<table class="mgT10">
		<colgroup>
			<col width="15%" />
			<col width="*" />
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">Excel 파일</th>
				<td>
					<input type="file" name="uploadFile" style="width: 250px;">
				</td>
			</tr>
		</tbody>
	</table>

	<div class="btnWrapC">
		<a href="#FIT" class="btn" id="uploadBtn"><span>등록</span></a>
		<a href="#FIT" class="btn" onclick="javascript:window.close();"><span>취소</span></a>
	</div>
</form>