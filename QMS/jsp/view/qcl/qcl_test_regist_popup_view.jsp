<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<%@ include file="/jsp/inc/inc_common.jsp"%>
<%@ include file="/jsp/inc/inc_header.jsp"%>
<%
	String test_id				= StringUtil.null2void(request.getParameter("TEST_ID"));
	Map<String,String> param2	= new HashMap<String,String>();
	param2.put("TEST_ID",test_id);
%>
<script type="text/javascript">
	function ts_submit() {
		var frm = document.frm1;
		var filePath = frm.regist_btn.value;
		var test_id = frm.TEST_ID.value;
		if ($("input[name=regist_btn]").val() == "") {
			alert("파일을 선택하여 주십시요.");
			return;
		}

		frm.target = '_self';
		frm.action = "/QMS/jsp/proc/qcl/qcl_test_excel_insert_do.jsp";
		frm.submit();
	}
</script>

<form name="frm1" method="post" enctype="multipart/form-data">
	<input type="hidden" id="TEST_ID" name="TEST_ID"
		value="<%=param2.get("TEST_ID")%>" /> <input type="file"
		id="regist_btn" name="regist_btn" value="선택"> <input
		type="button" id="submit_btn" name="submit_btn" value="등록"
		onclick="javascript:ts_submit();" />

</form>
</body>
</html>
