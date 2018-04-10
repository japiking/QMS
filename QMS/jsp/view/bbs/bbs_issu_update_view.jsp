<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>

<%@ include file="/jsp/inc/inc_common.jsp"%>
<%@ include file="/jsp/inc/inc_header.jsp"%>
<%
String userID		= StringUtil.null2void(userSession.getUserID());
String projectID	= StringUtil.null2void(userSession.getProjectID());
String boardID 		= StringUtil.null2void(request.getParameter("BOARD_ID"));
String bbsID 		= StringUtil.null2void(request.getParameter("BBS_ID"));
String recUsers 	= StringUtil.null2void(request.getParameter("LBRECEIVER"));
String title 		= StringUtil.null2void(request.getParameter("TIT_AND_CONT"));
String pageNum		= StringUtil.null2void(request.getParameter("PAGE_NUM"));
String inqDate		= StringUtil.null2void(request.getParameter("COMPLETION_DATE"));
String gradeId		= StringUtil.null2void(request.getParameter("GRADE_ID"));
String recId		= StringUtil.null2void(request.getParameter("REC_ID"));
String procId		= StringUtil.null2void(request.getParameter("PROC_ID"));
String proNm		= StringUtil.null2void(request.getParameter("PRO_NM_LIST"));
String confirmId	= StringUtil.null2void(request.getParameter("CONFIRM_ID"));
String confirmNm	= StringUtil.null2void(request.getParameter("CONFIRM_NM"));



LogUtil.getInstance().debug("SAMGU-bbs_oneRowList_update_popup.jsp >> boardID:"+boardID+", bbsID:"+bbsID+",recUsers:"+recUsers+", title:"+title+", pageNum:"+pageNum);

StringBuffer sbSql						=	new StringBuffer();
Map<String,String> dataMap				=	null;
List<Map<String,String>> list			=	new ArrayList<Map<String,String>>();
List<String> aList						=	new ArrayList<String>();
List<Map<String,String>> ImpGradeMap	=	null;

Map<String,String> param		= new HashMap<String,String>();
List<Map<String,String>> list2	= new ArrayList();


try {
	Map<String,String> paramR001 = new HashMap<String,String>();
	paramR001.put("PROJECTID",	projectID);
	list = qmsDB.selectList("QMS_BBS_ONELOW.USERINFO_R001", paramR001);

	//확인자 조회 리스트
	param.put("PROJECTID", userSession.getProjectID());
	list2 = qmsDB.selectList("QMS_BBS_ISSU.USERINFO_R002", param);
	
	//등급값
	ImpGradeMap = qmsDB.selectList("QMS_BBS_ISSU.IMPORTANCE_GRADE");
		
} catch (Exception e) {
	if (qmsDB != null) try { qmsDB.close(); } catch (Exception e1) {}
}/*  finally {
	if (qmsDB != null) try { qmsDB.close(); } catch (Exception e1) {}
} */


%>
<script type="text/javascript">
var dat_list = [];
<%
Map<String,String> tempMap		= null;
if(null != list2 && !list2.isEmpty()){
	for(int i =0; i<list2.size(); i++){
		tempMap = list2.get(i);
		
%>
		var item = {};
		item.USERID 	= '<%=tempMap.get("USERID")%>';
		item.USERNAME 	= '<%=tempMap.get("USERNAME")%>';
		dat_list.push(item);
<%
	}
}
%>
$(document).ready(function(){
	$("#INQ_DATE1").datepicker({dateFormat : 'yy-mm-dd',showAnim: "slideDown"});//달력 이벤트
	$("#SEARCH_REC_ID").hide(); 												//참여자 검색 숨김
	$("#SEARCH_CON_ID").hide();													//확인자 검색 숨김
	$("#IMPGRADE").val('<%=gradeId%>');											//중요도
	$("#hiddenReceiver").val('<%=recId%>');										//참여자 ID
	$("#proc_userid").val('<%=procId%>');										//처리자 ID
	$("#CONFIRM_ID").val('<%=confirmId%>');										//확인자 ID
	
	//수정 이벤트
	$("#btnUpdate").click(function(){
		
		var form		= document.multiPartForm;
		var title		= $("#sendTitle").val();
		var receiver	= $("#lbReceiver").text();
		var procuserid	= $("#proc_userid").val();
		var hiddenReceiver	= $("#hiddenReceiver").val();
		var confirmid	= $("#CONFIRM_ID").val();
		
		if (title.trim() == "") {
			alert("메시지를 입력해 주세요");
			$("#sendTitle").focus();
			return false;
		} else if (hiddenReceiver.trim() == "") {
			alert("받는사람을 선택해 주세요");
			return false;
		} else if(procuserid ==""){
			alert("처리자를 선택해 주세요");
			return false;
		}else if(hiddenReceiver==""){
			alert("참여자를 선택해 주세요");
			return false;
		}else if(confirmid==""){
			alert("확인자를 선택해 주세요");
			return false;
		}else {
			form.TITLE	= title;
			form.target	= "_self";
			form.action	= "/QMS/jsp/proc/bbs/bbs_issu_update_do.jsp";
			form.submit();
		}
	});
	
	//전체 선택
	$("#allCheck").click(function(){
		if (this.checked) {
			$(".inputChoice").prop("checked", true);
		} else {
			$(".inputChoice").prop("checked", false);
		}
	});
	
	//참여자 검색
	$("#inqury").click(function(){
    	try {
  		
    		var user_id  = $("#ipSearch").val();
    		var ajax = jex.createAjaxUtil("onerow_do");	// 호출할 페이지

    		// 공통부         		
    		ajax.set("TASK_PACKAGE",    "bbs" );	 						// [필수]업무 package 호출할 페이지 패키
    		// 개별부
    		ajax.set("USER_ID",    		user_id);
    		
    		ajax.execute(function(dat) {
    			try{
    				var data = dat["_tran_res_data"][0];    				
    				var list = data.list;
    				var html = "";
    				
    				for(var i=0; i<list.length; i++){
    					var dat = list[i];
    					
    					html += "<tr>";
    					html += "	<td><input class='inputChoice' type='checkbox' name='checkBox' value='"+dat.USERID+"'/></td>";
    					html += "	<td><span>"+dat.USERNAME+"</span></td>";
    					html += "	<td><span>"+dat.USERID+"</span></td>";
    					html += "</tr>";
    				}

    				$("#user_list").html(html);
    				
    			} catch(e) {bizException(e, "onerow_do");}
    		});
    	} catch(e) {bizException(e, "onerow_do");}
    
	});
	
	// 확인자 검색시
	$("#btn_inqry").click(function() {
		var temp = [];
		var name = $("#ipSearch2").val();
		for(var i=0; i<dat_list.length; i++){
			var dat = dat_list[i];
			var str = dat.USERNAME;
			var dataId = dat.USERID;
			if(str.indexOf(name) > -1 || dataId.indexOf(name) > -1) {
				temp.push(dat);
			}
		}
		$("#tbody_area").empty();
		
		var html = "";
		for(var j=0; j<temp.length; j++){
			var html_dat = temp[j];
			html += "<tr>";
			html += "	<td style='text-align: center;'>";
			html += "   	<input type='radio' name='check_rdo'/>";
			html += "	</td>";
			html += "	<td style='text-align: center;'  id='user_id' >"+html_dat.USERID+"</td>";
			html += "	<td style='text-align: center;'  id='user_nm' >"+html_dat.USERNAME+"</td>";
			html += "</tr>";
		}
		
		$("input:radio[name='check_rdo']").each(function(e) {
			
			checkid=$(this).val();
			if(checkid.trim()==$("#CONFIRM_ID").val().trim()){
				$(this).prop("checked","checked");
			}
		});
		$("#tbody_area").html(html);
	});
	
	//참여자|처리자 선택 취소시
	$("#cancel").click(function (){
		$("#SEARCH_REC_ID").hide(); 	//참여자 검색 숨김
		$("#SEARCH_CON_ID").hide(); 	//확인자 검색 숨김					
		$("#ipSearch").val("");
		$("#inqury").click();
	});
	
	//확인자 선택 취소시
	$("#cancel2").click(function (){
		$("#SEARCH_REC_ID").hide(); 	//참여자 검색 숨김
		$("#SEARCH_CON_ID").hide(); 	//확인자 검색 숨김					
		$("#btn_inqry").val("");
		$("#btn_inqry").click();
	});
	
	//참여자 버튼 클릭시 이벤트
	$("#addReceiver").click(function() {
		$("#SEARCH_CON_ID").hide();
		$("input:checkbox[class='inputChoice']").removeAttr("checked");
		var recId = $("#hiddenReceiver").val();
		var arrRecid =  recId.split(",");
		var recid="";
		var checkid="";
		$("input:checkbox[class='inputChoice']").each(function(e) {
			checkid=$(this).val();
				for(var i =0; i<arrRecid.length; i++){
					recid=arrRecid[i].trim();
					if(checkid.trim()==recid.trim()){
						$(this).prop("checked","checked");
					}
				}
		});
		$("#SEARCH_REC_ID").show();
		$("#bSelect").hide();
		$("#aSelect").show();
		$("#POC").hide();
		$("#REC").show();
		$("#ipSearch").focus();
	});
	
	//처리자 버튼 클릭시 이벤트	
	$("#pocsearch").click(function(){
		$("#SEARCH_CON_ID").hide();
		$("input:checkbox[class='inputChoice']").removeAttr("checked");
		var procId = $("#proc_userid").val();
		var arrProcId =  procId.split(",");
		var procid="";
		var checkid="";
		
		$("input:checkbox[class='inputChoice']").each(function(e) {
			
			checkid=$(this).val();
			
				for(var i =0; i<arrProcId.length; i++){
					procid=arrProcId[i];
					if(checkid.trim()==procid.trim()){
						$(this).prop("checked","checked");
					}
				}
		});
		$("#SEARCH_REC_ID").show();
		$("#aSelect").hide();
		$("#bSelect").show();
		$("#REC").hide();
		$("#POC").show();
		$("#ipSearch").focus();
	});
	
	//확인자 버튼 클릭시 이벤트	
	$("#consearch").click(function(){
		$("#SEARCH_REC_ID").hide();
				
		$("input:radio[name='check_rdo']").each(function(e) {
			
			checkid=$(this).val();
			if(checkid.trim()==$("#CONFIRM_ID").val().trim()){
				$(this).prop("checked","checked");
			}
		});
		$("#SEARCH_CON_ID").show();
		$("#btnSearch").focus();
	});
	
	
});

//참여자 처리자 검색 후 선택
function uf_search(flag){
	var viewList  = [];
	var hidenList = [];
	if ($("input:checkbox[class='inputChoice']:checked").length==0) {
	    alert("사용자를 선택해 주세요.");
	    return;
	} else {
		$("input:checkbox[class='inputChoice']:checked").each(function() {
			if (this.checked == true) {
				hidenList.push($(this).parent().next().next().text());
				viewList.push($(this).parent().next().text());
			}
		});

		if('a'==flag){	//참여자
			$("#lbReceiver").text(viewList);
			$("#hiddenReceiver").val(hidenList);
		}else if('b'==flag){			//처리자
			$("#proc_usernm").text(viewList);
			$("#proc_userid").val(hidenList);
		}
		//window.close();
	}
	$("#ipSearch").val("");
	$("#inqury").click();	
	$("#SEARCH_REC_ID").hide();
}
	
//확인자 선택
function uf_sel(){
	var radioVal = $("input:radio[name='check_rdo']:checked").val();
	$("#CONFIRM_ID").val(radioVal);
	$("#CONFIRM_ID").text();
	$("#tbody_area tr").each(function() { 
       if( $("input:radio", this).is(":checked")) {
          $("#confirm_nm").text($(this).find("#user_nm").text()+"("+$(this).find("#user_id").text()+")");
       }
    }); 
	//검색
	$("#ipSearch").val("");
	$("#inqury").click();	
	$("#SEARCH_CON_ID").hide();
}

</script>
<form name="multiPartForm" method="post" enctype="multipart/form-data">
<input type="hidden" name="BOARD_ID" value="<%=boardID%>"/>
<input type="hidden" name="BBS_ID"	 value="<%=bbsID%>"/>
<input type="hidden" name="TITLE"    value="<%=title%>"/>
<input type="hidden" name="PAGE_NUM" value="<%=pageNum%>"/>
<input type="hidden" name="PROC_USERID" id="proc_userid"	/>
<input type="hidden" name="CONFIRM_ID" id="CONFIRM_ID"	/>
<input type="hidden" name="projectID" id="projectID" value="<%=projectID%>"	/>

	<div class="wrap">
		
		<div id="sendMsgArea">
			
			<div class="btnWrapl">
					<a href="#" class="btn" id='addReceiver'><span>참여자</span></a>
					<input id="hiddenReceiver" name="RECEIVER_LIST"  type="hidden" value=""/>
					<label id="lbReceiver" name="RECIPIENT_ID"><%=recUsers%></label>
					
				</div>
				<table>
					<colgroup>
						<col width="10%"/>
						<col width="90%"/>
					</colgroup>
					<tbody>
						<tr>
							<th>완료예정일</th>
							<td>
								<!--  시작일 -->
								<input readonly="readonly" id="INQ_DATE1" name="INQ_DATE1" value="<%=inqDate%>" style="width: 70px"  onclick="javascript:datepicker_view(frm.INQ_DATE1);" />
							</td>
						</tr>
						<tr>
							<th>중요도</th>
							<td>
								<select name="IMPGRADE" id="IMPGRADE">
								<%for(int i = 0; i<ImpGradeMap.size();i++){ %>
									<option value="<%=ImpGradeMap.get(i).get("IMPORTANCE_GRADE_ID")%>"><%=ImpGradeMap.get(i).get("KR_IMPORTANCE_GRADE")%></option>
								<%}%>
								</select>
							</td>
						</tr>
						<tr>
							<th>처리자</th>
							<td>
								<a href="#FIT" class="btn" id="pocsearch"><span>찾기</span></a>
								<span id="proc_usernm"><%=proNm%></span>
							</td>
						</tr>
						<tr>
							<th>확인자</th>
							<td>
								<a href="#FIT" class="btn" id="consearch"><span>찾기</span></a>
								<span id="confirm_nm"><%=confirmNm%>(<%=confirmId%>)</span>
							</td>
						</tr>
					</tbody>
				</table>
				<br/>
				<textarea rows="5" cols="50" id="sendTitle" name="TITLE" placeholder="함께 주고 받을 메시지를 입력하세요." maxlength="50" style="width:97%;"><%=title.replaceAll("<br/>", "\n") %></textarea>
				<div>
					<div class="btnWrapR">
						<!-- <a href="#" class="btn" id="fileAttach"><span>첨부파일</span></a> -->
						<a href="#" class="btn" id="btnUpdate"><span>수정</span></a>
						<a href="#" class="btn" onclick="javascript:window.close();"><span>취소</span></a>
					</div>
					<div class="btnWrapL">
						<div id="fileForm"></div>
					    <div id="fileList"></div>
						<!-- <div id="fileForm">
							<input type="file" value="" style="display:none;"/>
						</div> -->
					</div>
				</div>
		</div>
	</div>
	<!-- 참여자/처리자 검색  -->
	<div class="wrap" id="SEARCH_REC_ID">
	<span id="REC" >참여자 선택</span>
	<span id="POC" >처리자 선택</span>
		<div class="btnWrapl">
			<input type="text" id="ipSearch" placeholder="사용자검색"/>
			<a href="#FIT" class="btn" id="inqury"><span>검색</span></a>
			<a href="#FIT" class="btn" id="aSelect" onclick="javascript:uf_search('a');"><span>선택</span></a><!-- 참여자선택버튼 -->
			<a href="#FIT" class="btn" id="cSelect" onclick="javascript:uf_search('c');"><span>선택</span></a><!-- 확인자선택버튼 -->
			<a href="#FIT" class="btn" id="cancel"><span>취소</span></a>
		</div>
		<table id="tbl001" class="list">
			<colgroup>
				<col width="10%"/>
				<col width="45%"/>
				<col width="45%"/>
			</colgroup>
			<thead>
				<tr>
					<th scope="col"><input type="checkbox" name="checkBox" id="allCheck" /></th>
					<th scope="col">사용자이름</th>
					<th scope="col">사용자ID</th>
				</tr>
			</thead>
			<tbody id="user_list">
			<% if (list == null || list.size() == 0) { %>
				<tr>
					<td colspan="4">조회 데이터가 없습니다.</td>
				</tr>
			<% } else {
					for (int i=0; i<list.size(); i++) {
						dataMap	= list.get(i);
			%>
				<tr>
					<td><input id="asdf<%=i %>" class="inputChoice" type="checkbox" name="checkBox" value="<%=dataMap.get("USERID")%>"/></td>
					<td><span><%=dataMap.get("USERNAME")%></span></td>
					<td><span><%=dataMap.get("USERID")%></span></td>
				</tr>
			<%		}//end for
		  	   }// end else
		  	%>
			</tbody>
		</table>
	
</div>

<!-- 확인자 검색  -->
<div class="wrap" id="SEARCH_CON_ID">
	<span id="CON">확인자 선택</span>
	<div class="btnWrapl" >
		<input type="text" id="ipSearch2" placeholder="사용자명 검색"/>
		<a href="#FIT" class="btn" id="btn_inqry"><span>검색</span></a>
		<a href="#FIT" class="btn" onclick="javascript:uf_sel();"><span>선택</span></a>
		<a href="#FIT" class="btn" id="cancel2"><span>취소</span></a>
	</div>
	<br/>
	<table>
		<colgroup>
			<col width="5%"/>
			<col width="15%"/>
			<col width="15%"/>
		</colgroup>
		<thead>
			<th scope="row"></th>
			<th scope="row">ID</th>
			<th scope="row">이름</th>
			
		</thead>
		<tbody id="tbody_area">
		<%
			if(null != list2 && !list2.isEmpty()){
				for(int i =0; i<list2.size(); i++){
					dataMap = list2.get(i);
		%>
			<tr>
				<td style="text-align: center;">
					<input type="radio" name="check_rdo" id="rdo"<%=i%> value="<%=dataMap.get("USERID")%>"/>
				</td>
				<td style="text-align: center;" id="user_id"<%=i%>><%=dataMap.get("USERID")%></td>
				<td style="text-align: center;" id="user_nm"<%=i%>><%=dataMap.get("USERNAME")%></td>
			</tr>
		<%
				}
			}
		%>
		</tbody>
	</table>
</div>

</form>
<% if (qmsDB != null) try { qmsDB.close(); } catch (Exception e1) {} %>