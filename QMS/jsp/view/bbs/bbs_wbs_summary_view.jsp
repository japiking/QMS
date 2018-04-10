<%@page import="java.util.Vector"%>
<%@page import="qms.wbs.WBSNode"%>
<%@page import="qms.wbs.WBSUtil"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
    
<%@ include file="/jsp/inc/inc_common.jsp" %>
<%@ include file="/jsp/inc/inc_header.jsp" %>

<%
	String board_id =  StringUtil.null2void(request.getParameter("BOARD_ID"));
	Map<String,String> param = new HashMap<String,String>();
	WBSNode rootNode =  WBSUtil.makeWBSTree(userSession.getProjectID());
%>
<script type="text/javascript">
$(document).ready(function() {
	var menu_nm = $("#"+'<%=board_id%>').text();
	$("h3").text(menu_nm);
	uf_bgColor();
});


function uf_appendChild(input_task_code){
	var imgSrc = $("a[task_code='"+input_task_code+"'] img").attr("src");
	//더하기일때
	if(imgSrc.indexOf("plus")>0){
		var ajax = jex.createAjaxUtil("wbs_summary_do");	// 호출할 페이지
		// 공통부         		
		ajax.set("TASK_PACKAGE",    "bbs" );	 						// [필수]업무 package 호출할 페이지 패키
	 	var task_code = input_task_code;
		// 개별부 
		ajax.set("TASK_CODE", task_code);
		ajax.execute(function(dat) {
			try{
				var data = dat["_tran_res_data"][0];
				var children = data.CHILDREN;
				var makeHTML = "";
				for(var i = 0; i < children.length; i++){
					var child = children[i];
					
					var task_code = child.TASK_CODE.replace(/\./gi,"a"); 
					makeHTML+="<tr id=\""+task_code+"\" task_level=\""+child.TASK_LEVEL+"\"><td style=\"text-align: left;\">";
					if(child.LEAF_NODE=="N"){
						makeHTML+="<a href=\"#\" task_code=\""+task_code+"\" onclick=\"uf_appendChild('"+task_code+"')\"><img src=\"../../../img/plus.png\" /></a>";
					}
					makeHTML+= child.TASK_CODE+"</td>";
					makeHTML+="<td>"+child.TASK_TITLE+"</td>";
					makeHTML+="<td>"+child.TOTAL_COUNT+"</td>";
					makeHTML+="<td>"+child.IN_PROGRESSING+"</td>";
					makeHTML+="<td>"+child.EXPECTED+"</td>";
					makeHTML+="<td>"+child.COMPLETE+"</td>";
					makeHTML+="<td>"+child.EXCEPTED+"</td>";
					makeHTML+="<td>"+child.PROGRESS_RATE_TOTAL+"</td>";
					makeHTML+="<td>"+child.PROGRESS_RATE_PLAN+"</td></tr>";
				}
				
				$("tr[id="+input_task_code+"]").after(makeHTML);
				var imgMinus = $("a[task_code='"+input_task_code+"'] img").attr("src").replace("plus","minus");
				$("a[task_code='"+input_task_code+"'] img").attr("src",imgMinus);
				uf_bgColor();
				
			} catch(e) {bizException(e, "login");}
		});
	}else{//빼기
		$("tr[id^="+input_task_code+"][id!="+input_task_code+"]").remove();
		var imgPlus = $("a[task_code='"+input_task_code+"'] img").attr("src").replace("minus","plus");
		$("a[task_code='"+input_task_code+"'] img").attr("src",imgPlus);
	}
}

function uf_bgColor(){
	$(".list tr[task_level]").each(function(index,value){
		var level = $(this).attr("task_level");
		if( level == "1"){
			$(this).css("background","#004646");
			$(this).css("color","#ffffff");
			
		}else if( level == "2"){
			$(this).css("background","#007777");
			$(this).css("color","#ffffff");
		}else if( level == "3"){
			$(this).css("background","#009f9f");
			$(this).css("color","#ffffff");
		}
		var rate = Number($(this).find("td:eq(8)").html());
		if( rate < 95){
			$(this).find("td:eq(8)").css("background","#ff0000");
		}
	});
}
</script>
<%@ include file="/jsp/inc/inc_topMenu.jsp" %>
<%@ include file="/jsp/inc/inc_leftMenu.jsp" %>
<form name="frm" method="post">
	<div>
		<h3></h3>
		<table class="list">
			<colgroup>
				<col width="10%"/>
				<col width="20%"/>
				<col width="10%"/>
				<col width="10%"/>
				<col width="10%"/>
				<col width="10%"/>
				<col width="10%"/>
				<col width="10%"/>
				<col width="*"/>
			</colgroup>
			<thead>
				<tr>
					<th scope="col" style="text-align: center;">Code of Account</th>
					<th scope="col" style="text-align: center;">Title</th>
					<th scope="col" style="text-align: center;">총갯수</th>
					<th scope="col" style="text-align: center;">진행중</th>
					<th scope="col" style="text-align: center;">현재시점완료예상</th>
					<th scope="col" style="text-align: center;">완료</th>
					<th scope="col" style="text-align: center;">제외</th>
					<th scope="col" style="text-align: center;">진행률</th>				
					<th scope="col" style="text-align: center;">계획대비진척률</th>
				</tr>
			</thead>
			<tbody>
			<%
				Vector<WBSNode> children = rootNode.getChildren();
				for(int i = 0; i < children.size(); i ++){
					WBSNode tempNode = children.get(i);
					boolean bLeafNode = tempNode.isLeafNode();
					String strTaskCode = tempNode.getTaskCode();
					String strTaskTitle = tempNode.getAttribute("TASK_TITLE");
					String strTaskLevel = tempNode.getAttribute("TASK_LEVEL");
					int nLeafCount = tempNode.getLeafCount();//총갯수
					int nExpected = tempNode.getSumValueDate("PLAN_ENDG_DATE"); //현시점 예상완료갯수
					int nIng = tempNode.getSumValue("NOW_STAT", "222"); //진행중
					int nEd = tempNode.getSumValue("NOW_STAT", "111"); //완료
					int nEx = tempNode.getSumValue("NOW_STAT", "999"); //제외
					double progressRateTotal = (double)(nEd+nEx)/(double)nLeafCount*100;// 진행율
					double progressRateByPlan = (double)(nEd+nEx)/(double)nExpected*100; //계획대비진척률
					if( nExpected == 0){
						progressRateByPlan = 100;
					}
					String repTaskCode = strTaskCode.replaceAll("\\.","a");
			%>
			<tr id="<%=strTaskCode %>" task_level="<%=strTaskLevel %>">
				<td style="text-align: left;">
					<%=bLeafNode ? "":"<a href=\"#\" task_code=\""+repTaskCode+"\" onclick=\"uf_appendChild('"+repTaskCode +"')\"><img src=\"../../../img/plus.png\" /></a>"%><%=strTaskCode %>
				</td>
				<td><%=strTaskTitle%></td>
				<td><%=nLeafCount %></td>
				<td><%=String.valueOf(nIng) %></td>
				<td><%=String.valueOf(nExpected) %></td>
				<td><%=String.valueOf(nEd) %></td>
				<td><%=String.valueOf(nEx)%></td>
				<td><%=String.format("%.2f" , progressRateTotal) %></td>
				<td><%=String.format("%.2f" , progressRateByPlan) %></td>
			</tr>
			<%} %>
			</tbody>
		</table>
	</div>
</form>

<%@ include file="/jsp/inc/inc_bottom.jsp" %>
