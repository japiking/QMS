<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
    

<link rel="stylesheet" href="/QMS/css/guide.css" />
<link rel="stylesheet" href="/QMS/css/guide_qms.css" />
<script src="/QMS/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="/admin/FCKeditor2.2/fckeditor.js"></script>
<script type="text/javascript">
$(document).ready(function() {
	$("#btn1").click(function() {
		var a=prompt('webtest', '');
		alert('�Է��ϽŰ� : '+a);
	});
	$("#btn2").click(function() {
		var a=prompt('�Է����ּ���', '');
		alert('�Է��ϽŰ� : '+a);
	});
});
</script>
<form name="frm" method="post">
	<a class="btn" id="btn1" ><span>btn1</span></a>
	<a class="btn" id="btn2" ><span>btn2</span></a>
	
	<div id="contents">
		<script>
			// ������ ��ü ����
			var fck = new FCKeditor("contents");
			// ��������
			fck.ToolbarSet="Normal";
			// �� �����ÿ� fck.Value�� �����Է�
			fck.Value = document.getElementById("contents_data").value;
			// ȭ�鿡 �Ѹ�
			fck.Create();
		</script>
		<input type="hidden" value="" id="pmCmd" name="pmCmd">
		<input type="button" onClick="openImg();" value="�̹��� �ֱ�" style="border:1">
		<DIV ID = "DIVChkID" name="DIVChkID" style="visibility:hidden;position:absolute;z-index:1;top:-0;left:0;">
	  			<iframe width="330" height="100" Name="IFrmChkID" id="IFrmChkID" frameborder="1"></iframe>
		</DIV>
	</div>
</form>
<%@ include file="/jsp/inc/inc_bottom.jsp" %>
