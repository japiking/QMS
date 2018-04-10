<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>    
<%@ include file="/jsp/inc/inc_common.jsp" %>
<%@ include file="/jsp/inc/inc_header.jsp" %>

<%
	String strDUE_DATE	= StringUtil.null2void(request.getParameter("DUE_DATE"));
	String prj_gbn		= StringUtil.null2void(request.getParameter("PROC_GBN"));
	String prj_id		= StringUtil.null2void(request.getParameter("PROJECT_ID"));
	String sql			= "";
	String prj_nm		= "";
	String prjStartDate	= "";
	String prjEndDate	= "";
	String pm_id		= "";
	String bigo			= "";
	String btn_nm		= "";
	
	Map<String, String> to_dateMap = null;
	if(!"U".equals(prj_gbn)){
		// 프로젝트 등록
		strDUE_DATE  = DateTime.getInstance().getDate("yyyy-MM-dd");
		prjStartDate = strDUE_DATE;
		prjEndDate   = prjStartDate;
		btn_nm		 = "등록";
	} else {
		try{
			// 프로젝트 수정
			Map<String,String> param1		= new HashMap<String,String>();
			param1.put("PROJECTID", prj_id);
			to_dateMap	= qmsDB.selectOne("QMS_SUPERUSER.PROJECTINFO_R003", param1);
	
			prj_nm		= StringUtil.null2void(to_dateMap.get("PROJECTNAME"));
			prjStartDate= StringUtil.null2void(to_dateMap.get("PROJECTSTARTDATE"));
			prjEndDate	= StringUtil.null2void(to_dateMap.get("PROJECTENDDATE"));
			pm_id		= StringUtil.null2void(to_dateMap.get("PROJECTMANAGERID"));
			bigo		= StringUtil.null2void(to_dateMap.get("BIGO"));
			btn_nm		 = "수정";
		}catch(Exception e){
			e.printStackTrace(System.out);
			if (qmsDB != null)
				try { qmsDB.close(); } catch (Exception e1) {}
		}
	}
	
%>

<script type="text/javascript">
	function uf_regedit() {
		if(frm.PROJECTNAME.value == "") {
			alert("프로젝트명은 필수 입력사항입니다.");
			return;
		}
		
		if(frm.PROJECTMANAGERID.value == "") {
			alert("PM ID는 필수 입력사항입니다.");
			return;
		}
		
		if(frm.BIGO.value == "") {
			alert("비고는 필수 입력사항입니다.");
			return;
		}
		
		frm.target			= '_self';
		frm.action			= "/QMS/jsp/proc/mng/mng_projectReg_do.jsp";
		frm.submit();

	}
	// PM id 찾기
	function uf_search(){
		var cw=screen.availWidth;     //화면 넓이
		var ch=screen.availHeight;    //화면 높이
		
		sw=800;    //띄울 창의 넓이
		sh=400;    //띄울 창의 높이
		ml=(cw-sw)/2;        //가운데 띄우기위한 창의 x위치
		mt=(ch-sh)/2;         //가운데 띄우기위한 창의 y위치
		window.open('','EXCEL','width='+sw+',height='+sh+',top='+mt+',left='+ml+',resizable=no,scrollbars=yes');
		//[출처] 자바스크립트 팝업 가운데 띄우기 팝업 가운데 띄우기|작성자 루나
		
		//window.open('', 'EXCEL', 'scrollbars=no,toolbar=yes,resizable=no,width=400,height=180,left=350,top=200');
		frm.target			= "EXCEL";
		frm.action			= "/QMS/jsp/view/mng/mng_userSearch_popup_view.jsp";
		frm.submit();
	}
	
	$(document).ready(function() {
		$("#PROJECTSTARTDATE").datepicker();
		$("#PROJECTENDDATE").datepicker();
	});
	
</script> 
 

<%@ include file="/jsp/inc/inc_topMenu.jsp" %>
<%@ include file="/jsp/inc/inc_leftMenu.jsp" %>
 
<form name="frm" method="post">
<input type="hidden" name="PROC_GBN"   value="<%=prj_gbn%>"/>
<input type="hidden" name="PROJECT_ID" value="<%=prj_id%>" />
<!-- <div  style="width:750px;"> -->

<div class="wrap">
	<h3>시스템관리자 &gt; 프로젝트 등록</h3>
	<table>
		<colgroup>
			<col width="150px"/>
			<col width="250px"/>
			<col width="100px"/>
			<col width="*"/>
		</colgroup>
		<tbody>
			<tr>				
				<th>프로젝트명</th>
				<td colspan="3">
					<input type="text" name="PROJECTNAME" style="width:200px" value="<%=prj_nm%>"/>		
				</td>			
			</tr>
			<tr>				
				<th>프로젝트 기간</th>
				<td colspan="3">
					<input readonly="readonly" id="PROJECTSTARTDATE" name="PROJECTSTARTDATE" value="<%=prjStartDate%>" style="width: 70px"  /><!--  시작일 -->
					 &nbsp ~ &nbsp
					<input readonly="readonly" id="PROJECTENDDATE" name="PROJECTENDDATE" value="<%=prjEndDate%>"  style="width: 70px" /><!--  종료일 -->
				</td>			
			</tr>
			<tr>				
				<th>PM ID</th>
				<td colspan="3">
					<input type="text" id="PROJECTMANAGERID" name="PROJECTMANAGERID" value="<%=pm_id%>"  style="width:120px" value=""/>
					<a href="#FIT" class="btn" onclick="javascript:uf_search();"><span>찾기</span></a>		
				</td>		
			</tr>	
			<tr>				
				<th>비고(참고사항)</th>
				<td colspan="3">
					<textarea id="BIGO" name="BIGO" cols="50" rows="4"><%=bigo%></textarea>	
				</td>		
			</tr>		
		</tbody>
	</table>


	<div class="btnWrapR">
		<a href="#FIT" class="btn" onclick="javascript:uf_regedit();"><span><%=btn_nm%></span></a>
	</div>

</div>
<!-- //wrap -->
</form>
<IFRAME SRC="" frameborder="0" id="HiddenFrame" name="HiddenFrame" width="0" height="0" marginwidth="0" marginheight="0" scrolling="no" allowtransparency="true"></IFRAME>



<%@ include file="/jsp/inc/inc_bottom.jsp" %>