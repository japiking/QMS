<!DOCTYPE html> 
<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR" isErrorPage="true" %>
<html><head>
	<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
	<title>WebCash-FIT QMS</title>
	<!-- 
	<script src="/QMS/js/jquery-1.7.1.min.js"></script>
	<script src="/QMS/js/guide.js"></script>
	<script src="/QMS/js/common.js"></script>
	<script src="/QMS/js/popupCalendar.js"></script>
	 -->
	 
	 
	<!-- lib -->
	<script src="/QMS/js/common/lib/cordova-ios.js"></script>
	<script src="/QMS/js/common/lib/jfm-1.0.0.js"></script>
	<script src="/QMS/js/common/lib/json2.js"></script>
	<script src="/QMS/js/common/lib/jquery-1.11.1.min.js"></script>
	<!-- <script src="/QMS/js/common/jquery.js"></script> -->
	<script src="/QMS/js/common/jquery-ui.js"></script>
    <script src="/QMS/js/common/jquery.jqGrid.min.js"></script>
    <script src="/QMS/js/common/i18n/grid.locale-kr.js"></script> 
    
	<!-- jexPlugin -->
	<script src="/QMS/js/common/jex/jex.core.js"></script>
	<script src="/QMS/js/common/jexPlugin/jex.mobile.calendar.js"></script>
	<script src="/QMS/js/common/jexPlugin/jex.mobile.msg.js"></script>
	<script src="/QMS/js/common/jexPlugin/jex.mobile.secretform.js"></script>
	<script src="/QMS/js/common/jexPlugin/jex.mobile.tbl.js"></script>
	<script src="/QMS/js/common/jex/jex.min.js"></script>
	 
	<!-- common -->
	<script src="/QMS/js/common/swiper.js"></script>
	<script src="/QMS/js/common/guide.js"></script>
	<script src="/QMS/js/common/ibk_prototype.js"></script>
	<script src="/QMS/js/common/ibk.js"></script>
	<script src="/QMS/js/common/common.js"></script>
	<script src="/QMS/js/common/iscroll.js"></script>
<!-- 	<script src="/QMS/js/common/popupCalendar.js"></script> -->
	<script src="/QMS/js/common/publishing.js"></script>
	<script src="/QMS/js/common/comUtil.js"></script>
	<script src="/QMS/js/common/comStep.js"></script>
	<script src="/QMS/js/common/comStringUtil.js"></script>
	<script src="/QMS/js/common/comDateUtil.js"></script>
	<script src="/QMS/js/common/comFormatter.js"></script>
	<!-- <script src="/QMS/js/common/comLoading.js"></script> -->
	<script src="/QMS/js/common/comMobAcctMgr.js"></script>
	<script src="/QMS/js/common/comPopup.js"></script>
	<script src="/QMS/js/common/comValidation.js"></script>
	<script src="/QMS/js/common/front-ui.js"></script>
	<script src="/QMS/jsp/comm/ckeditor/ckeditor.js"></script><style>.cke{visibility:hidden;}</style>
	
	<link href="/QMS/css/guide.css" rel="stylesheet">
	<link href="/QMS/css/guide_qms.css" rel="stylesheet">
	<link href="/QMS/css/ui.jqgrid.css" rel="stylesheet">
    <link href="/QMS/css/jquery-ui.css" rel="stylesheet">
</head>
<body>
	<div id="_LOADING_">
		<img alt="" src="">
	</div>



<script type="text/javascript">
function uf_inq(pagenum) {                        // �Ķ���� : ��ȸ ������
	var frm				= document.frm;
	if(null == pagenum || pagenum == 0){
		pagenum = '1';
	}
	frm.PAGE_NUM.value	= pagenum;
			
	frm.target			= "_self";
	frm.action			= "/QMS/jsp/view/bbs/bbs_attention_view.jsp";
	frm.submit();
}
$(document).ready(function() {
	var menu_nm = $("#"+'BRD_0000000786').text();
	$("h3").text(menu_nm);
});
</script>
<form name="frm" method="post">
<table style="width: 100%;" cellspacing="0" cellpadding="0">
	<colgroup>
			<col width="15%">
		<col width="*">
	</colgroup>
	<tbody>
		<tr>
			<td colspan="2">


    <table class="noline">
		<colgroup>
			<col width="15%">
			<col width="*">
			<col width="18%">
		</colgroup>
		<tbody>
			<tr>
				<td><a onclick="location.href='/QMS/jsp/view/bbs/bbs_index.jsp'; return false;" href="#FIT"><img src="/QMS/img/img_logo.png"></a></td>
				<td><b style="font-size: 30px;">test</b></td>
				<td style="text-align: right;">
					<b>bgh</b>�� ȯ���մϴ�.
					<a class="btn" onclick="javascript:uf_LogOut();" href="#FIT"><span>�α׾ƿ�</span></a>
				</td>
			</tr>
		</tbody>
	</table>

<script type="text/javascript">
function uf_LogOut(){
	frm.target			= "_self";
	frm.action			= "/QMS/jsp/proc/lgn/lgn_logout_do.jsp";
	frm.submit();
}
</script>
	<tr>
		<td valign="top">



<input name="PROJECT_ID" type="hidden" value="PRJ_0000000005">
<input name="BOARD_ID" id="left_brdId" type="hidden">
<input name="BOARD_TYPE" id="BOARD_TYPE" type="hidden">
<div class="guideLnb">
	<div class="lnb">
	
	
		<h2>���� �޴�</h2>
		<ul>
			<li><a onclick="javascript:uf_link4('adm_set_menu_view');" href="#FIT">�޴�����</a></li>
			<li><a onclick="javascript:uf_link4('adm_set_user_auth_view');" href="#FIT">����ڰ���</a></li>
			<li><a onclick="javascript:uf_link2();" href="#FIT">����� ���</a></li>
		</ul>
	
		
	
			<h2>����� �޴�</h2>	
			<ul>
	
			<li><a id="BRD_0000000786" onclick="javascript:uf_link0('bbs_attention_view','BRD_0000000786','005');" href="#FIT">����</a></li>
	
			<li><a id="BRD_0000000782" onclick="javascript:uf_link0('bbs_oneRowList_view','BRD_0000000782','002');" href="#FIT">����</a></li>
	
			<li><a id="BRD_0000000783" onclick="javascript:uf_link0('bbs_noticeList_view','BRD_0000000783','003');" href="#FIT">����</a></li>
	
			<li><a id="BRD_0000000784" onclick="javascript:uf_link0('bbs_mealTicket_view','BRD_0000000784','004');" href="#FIT">�ı�</a></li>
	
			<li><a id="BRD_0000000785" onclick="javascript:uf_link0('bbs_wbs_view','BRD_0000000785','007');" href="#FIT">wbs</a></li>
	
			<li><a id="BRD_0000000787" onclick="javascript:uf_link0('bbs_issu_view','BRD_0000000787','006');" href="#FIT">�̽�</a></li>
	
			<li><a id="BRD_0000000781" onclick="javascript:uf_link0('bbs_list_view','BRD_0000000781','001');" href="#FIT">��ô</a></li>
	
		</ul>
	
		<h2>QUALITY CONTROL �޴�</h2>
		<ul>
		
			 
				<li><a onclick="javascript:uf_link6('qcl_test_mng_view');" href="#FIT">�׽�Ʈ����</a></li>
				<li><a onclick="javascript:uf_link6('qcl_test_list.view');" href="#FIT">�׽�Ʈ���</a></li>
			
				<li><a onclick="javascript:uf_link6('qcl_test_execute_view');" href="#FIT">�׽�Ʈ �������</a></li>
				<li><a onclick="javascript:uf_link6('qcl_defect_mng_view');" href="#FIT">���԰���</a></li>
		</ul>
		</div>
	</div>
			</td>
	<td style="text-align: left;"><!--������ ��������-->

		<script>
		var frm;
		$(document).ready(function(){
			frm = document.frm;
		});
			// ������Ʈ ���
			function uf_link5() {
		   		frm.target = "_self";
		   		frm.action = "/QMS/jsp/view/index.jsp";
		   		frm.submit();
			}
		
			// ������Ʈ ���
			function uf_link1() {
		   		frm.target = "_self";
		   		frm.action = "/QMS/jsp/view/mng/mng_projectReg_view.jsp";
		   		frm.submit();
			}
			
			// ����� ���
			function uf_link2() {
		   		frm.target = "_self";
		   		frm.action = "/QMS/jsp/view/mng/mng_projectUserReg_view.jsp";
		   		frm.submit();
			}
			
			// ������Ʈ ����
			function uf_link3() {
		   		frm.target = "_self";
		   		frm.action = "/QMS/jsp/view/mng/mng_projectMng_view.jsp";
		   		frm.submit();
			}
						
			// �޴���ũ
			function uf_link0(param, param2, param3) {
				var pkg = param.substring(0,param.indexOf("_")); 
		   		frm.BOARD_ID.value	= param2;
		   		frm.BOARD_TYPE.value	= param3;
		   		frm.target = "_self";
		   		frm.action = "/QMS/jsp/view/"+pkg+"/"+param+".jsp?BOARD_ID="+param2;
		   		frm.submit();
			}
			 
			//admin �޴���ũ 
			function uf_link4(param){
				frm.target = "_self";
		   		frm.action = "/QMS/jsp/view/adm/"+param+".jsp";
		   		frm.submit();
			}
		
			//QC�޴���ũ
			function uf_link6(param){
				frm.target = "_self";
		   		frm.action = "/QMS/jsp/view/qcl/"+param+".jsp";
		   		frm.submit();
			}
			
		</script>

	<input name="PAGE_NUM" type="hidden" value="1">
  	<input name="PAGE_COUNT" type="hidden" value="20">
	<div class="wrap">
		<h3>����</h3>
		<div class="btnWrapR">
			<input name="INQ_DATE" id="INQ_DATE" style="width: 70px;" onclick="javascript:openCalendar(frm.INQ_DATE);" readonly="readonly" value="2015-04-06"><!--  ������ -->
			<a onclick="javascript:openCalendar(frm.INQ_DATE);" href="#FIT"><img class="bt_i" alt="�޷�" src="/QMS/img/btn_s_cal.gif"></a>
			<a class="btn" onclick="javascript:uf_inq();" href="#FIT"><span>��ȸ</span></a>
		</div>
		<table class="list">
			<colgroup>
				<col width="20%">
				<col width="20%">
				<col width="20%">
				<col width="20%">
				<col width="*">			
			</colgroup>
			<thead>
				<tr>
					<th style="text-align: center;" scope="col">����ڸ�</th>
					<th style="text-align: center;" scope="col">�����ID</th>
					<th style="text-align: center;" scope="col">��¥</th>
					<th style="text-align: center;" scope="col">���ʷα��νð�</th>				
					<th style="text-align: center;" scope="col">�����α��νð�</th>				
				</tr>
			</thead>
			<tbody>
				
				<tr>
					<td>bgh</td>
					<td>bgh</td>
					<td>2015-04-06</td>
					<td>08:09:22  </td>
					<td>11:27:03  </td>
				</tr>
				
				<tr>
					<td>�̻��</td>
					<td>samgu</td>
					<td>2015-04-06</td>
					<td>08:09:06  </td>
					<td>          </td>
				</tr>
				
			</tbody>
		</table>
		<div class="paging">
			<ul>
				<li class="bt"><a href="javascript:uf_inq('1')">[First]</a></li>
				<li class="bt"><a href="javascript:uf_inq('0')">[Prev]</a></li>
	
				<li><a onclick="javascript:uf_inq(1);" href="#">
				<b>1</b></a></li>
	
				<li class="bt"><a href="javascript:uf_inq('2')">[Next]</a></li>
				<li class="bt"><a href="javascript:uf_inq('1')">[Last]</a></li>
			</ul>
		</div>
	</div>





<!-- //wrap -->

    <table class="noline">
		<colgroup>
<!-- 			<col width="250px"/> -->
<!-- 			<col width="500px"/> -->
			<col width="*">
		</colgroup>
		<tbody>
			<tr>
<!-- 				<td>&nbsp;</td> -->
				<td style="text-align: center;"><img height="20" src="/QMS/img/img_logo02.png"></td>
<!-- 				<td>&nbsp;</td> -->
			</tr>
			<tr>
<!-- 				<td>&nbsp;</td> -->
				<td style="text-align: center;">Copyright(c) WEBCASHFIT. All rights reserved</td>
<!-- 				<td>&nbsp;</td> -->
			</tr>
		</tbody>
	</table>



</tr></tbody></table></form></body></html>