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
			if(!confirm("�̴�� �ø��ðڽ��ϱ�?"))
				return;
			$("#frm").submit();
		})
	})

	/* 
	function checkForm() {
		alert($("input[name=file1]").val())
		if ($("input[name=file1]").val() == "") {
			alert("������ �����Ͽ� �ֽʽÿ�.");
			return;
		} else if (!checkFileType($("input[name=file1]").val())) {
			alert("�������ϸ� ���ε� ���ּ���.");
			return false;
		} else {
			ComUtil.showloading();
			document.excelUpload.EXCEL_FILE.value = $("input[name=file1]").val();
			document.excelUpload.submit();
			window.close();
		}
	}
	
	function checkFileType(filePath) {
		var fileLen = filePath.length;
		var fileFormat = filePath.substring(fileLen - 4);
		fileFormatfileFormat = fileFormat.toLowerCase();
		
// 		if (fileFormat == ".xls" || fileFormat == "xlsx") {
		if (fileFormat == ".xls") {
			alert("xls Ȯ���ڸ� ���� �մϴ�.");
			return true;
		} else {
			return false;
		}
	}
	 */
</script>
<div id="_LOADING_">
	<img alt="" src="" />
</div>
<form  id="frm" name="frm" action="bbs_excelupload_insert.jsp" method="post"  enctype="multipart/form-data" >
	<input type="hidden" name="BOARD_ID"	value="<%=board_id%>" 	/>
	<input type="hidden" name="EXCEL_FILE"	value="" 	/>
	<br />
	<table class="mgT10">
		<colgroup>
			<col width="15%" />
			<col width="*" />
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">Excel ����</th>
				<td>
					<input type="file" name="uploadFile" style="width: 250px;">
				</td>
			</tr>
		</tbody>
	</table>

	<div class="btnWrapC">
		<a href="#FIT" class="btn" id="uploadBtn"><span>���</span></a>
		<a href="#FIT" class="btn" onclick="javascript:window.close();"><span>���</span></a>
	</div>
</form>