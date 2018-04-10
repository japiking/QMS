<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
    
<%@ include file="/jsp/inc/inc_common.jsp" %>
<%@ include file="/jsp/inc/inc_header.jsp" %>
<%
int menuLng=0;

String strProjectId 	=	StringUtil.null2void(request.getParameter("PROJECT_ID"));  //임시처리

List<Map<String,String>> statsListMap  = null;
List<Map<String,String>> statsListMap2 = null;
List<Map<String,String>> statsListMap3 = null;

try{
	//메뉴타입
	statsListMap = qmsDB.selectList("QMS_ADMIN.MENUTYPE_R001");
	
	//메뉴리스트
	Map<String,String> param = new HashMap<String,String>();
	param.put("PROJECT_ID", strProjectId);
	
	statsListMap2 = qmsDB.selectList("QMS_ADMIN.MENU_R001",param);
	
	//권한등급
	statsListMap3 = qmsDB.selectList("AUTHORITY_R001");
	
}catch(Exception e){
	e.printStackTrace(System.out);
	if (qmsDB != null){
        try { qmsDB.close(); } catch (Exception e1) {}
	}
}finally{
	if (qmsDB != null){
        try { qmsDB.close(); } catch (Exception e1) {}
	}
}
%>
<script type="text/javascript">
var count	 = <%=statsListMap.size()%>+1;
var rowCount	=	0;
function addManu(id,name,row){
	var contents 	= 	'';
	
	if($('#menumane'+row).val()==''){
		alert("메뉴명을 입력하세요.");
		$('#menumane'+row).foucs();
		return false;
	}
	
     contents += 	"<tr id='tr"+count+"'>";
     contents +=    "<td><input type='radio' id='chk"+count+"' name='rad' value='"+count+"'/></td>";
     contents +=    "<td><input type='text' name='typename"+count+"' value='"+name+"' readonly='readonly' />";
     contents +=    "<input type='hidden' name='typeid"+count+"' value='"+id+"' /></td>";
     contents +=    "<td><input type='text' name='menuname"+count+"' value='"+$("#menumane"+row).val()+"' size='50' maxlength='30' /></td>";
     contents +=	"<td>";
	 contents +=	"<select name='authval'>";
	 <%for(int j = 0; j<statsListMap3.size(); j++){ 
		String AuthGrade = statsListMap3.get(j).get("AUTHORITYGRADE");
		String AuthName = statsListMap3.get(j).get("AUTH_NAME");
	%>			
			
     	contents +=	"	<option value='<%=AuthGrade%>'><%=AuthName%></option>";
     	
     <%}%>
     contents +=	"</select>";
     contents +=	"</td>";
     contents +=    "<td><button class='del'>삭제</button></td>";
     contents += 	"</tr>";

     $('#AddOption').append(contents);
     count++;
     $('#menumane'+row).val('');
    
}
$(document).ready(function(){
	$('.del').click(function(){ // 삭제기능
	    $(this).parent().parent().remove(); 
	});
	
});
function moveRowUpDown(option) {
	  var num = $('input[name=rad]:checked').val();
	  if(num==undefined){
	   alert("선택해주세요.");
	   return false;
	  }
	  var element = $("#tr"+num);
	  if(option=="up"){
	   if( element.prev().html() != null  && element.prev().attr("id") != "header"){
	    element.insertBefore(element.prev());
	   }
	   
	  }else{
	         if( element.next().html() != null ){
	             element.insertAfter(element.next());
	         }
	  }
}

function uf_submit(){
	rowCount = $('#AddOption tr').length;
	if(confirm("변경된 사항을 저장하시겠습니까?")==true){
		for(var i = 0; i<rowCount; i++){
			
			$("#AddOption tr:eq('"+i+"')").attr('id',"tr"+i);
			$("#AddOption tr:eq('"+i+"') input[name^=typename]").attr("name","typename"+i);
			$("#AddOption tr:eq('"+i+"') input[name^=typeid]").attr("name","typeid"+i);
			$("#AddOption tr:eq('"+i+"') input[name^=board]").attr("name","board"+i);
			$("#AddOption tr:eq('"+i+"') input[name^=menuname]").attr("name","menuname"+i);
			$("#AddOption tr:eq('"+i+"') select[name^=authval]").attr("name","authval"+i);
		}
		
		var frm					= document.frm;
		frm.PROJECT_ID.value	='<%=strProjectId%>'; 
		frm.count.value			= rowCount;
		frm.target				= "_self";
		frm.action= "/QMS/jsp/proc/adm/adm_set_menu_do.jsp";
		frm.submit();
	}
}
	
</script>

<%@ include file="/jsp/inc/inc_topMenu.jsp" %>
<%@ include file="/jsp/inc/inc_leftMenu.jsp" %>
<form name="frm" method="post">

<input type="hidden" name="count" />
<input type="hidden" name="PROJECT_ID" />
	<div style="width: 100%;">
		<div>
			<span>사용 메뉴 선택</span>
			<table border="1">
				<colgroup>
					<col>
					<col>
					<col>
					<col>
				</colgroup>
				<tr>
					<th>메뉴type</th>
					<th>메뉴명</th>
					<th>추가</th>
				</tr>
				<%for(int i = 0; i< statsListMap.size(); i++){
					Map DataMap = statsListMap.get(i);
					
				%>
				<tr>
					<td>							
						<span id="<%=DataMap.get("MENU_TYPE_ID")%>"><%=DataMap.get("MENU_KR_NAME")%></span>
					</td>
					<td><input type="text" id="menumane<%=i%>" size="50" maxlength="30"/></td>
					<td><button onclick="javasciprt:addManu('<%=DataMap.get("MENU_TYPE_ID")%>','<%=DataMap.get("MENU_KR_NAME")%>','<%=i%>');return false;">추가</button></td>
				</tr>
				<%
						
				}//for %>
			</table>

		</div>
		<div></div>
		<span>등록메뉴</span>
		<div>
			<table border="1" >
				<colgroup>
					<col width="10%">
					<col width="20%">
					<col width="40%">
					<col width="20%">
					<col width="10%">
				</colgroup>
				<thead>
					<tr>
						<th>선택</th>
						<th>메뉴type</th>
						<th>메뉴명</th>
						<th>등급</th>
						<th>삭제여부</th>
					</tr>
				<thead>
				<tbody id="AddOption">
				<%
					for(int i = 0; i<statsListMap2.size(); i++){
					Map DataMap = statsListMap2.get(i);	
				%>
					<tr id="tr<%=i+1%>">
						<td>
							<input type='radio' name="rad" value="<%=i+1%>"/>
						</td>
						<td>
							<input type="hidden" name="typeid<%=i%>" value="<%=DataMap.get("MENU_TYPE_ID")%>" readonly="readonly" />
							<input type="hidden" name="board<%=i%>" value="<%=DataMap.get("BOARD_ID")%>" readonly="readonly" />
							<%for(int j = 0; j<statsListMap.size(); j++){
								if(DataMap.get("MENU_TYPE_ID").equals(statsListMap.get(j).get("MENU_TYPE_ID"))){%>
							<input type="text" name="typename<%=i%>" value='<%=statsListMap.get(j).get("MENU_KR_NAME")%>' readonly="readonly" />
							<%
								}//for
							}//for
							%>
						</td>
						<td>
							<input type="text" name="menuname<%=i%>" value="<%=DataMap.get("KOR_MENU_NAME")%>" size="50" maxlength="30" />
						</td>
						<td>
							<select name="authval<%=i%>">
								<%for(int j = 0; j<statsListMap3.size(); j++){ 
									String AuthGrade = statsListMap3.get(j).get("AUTHORITYGRADE");
									String AuthName = statsListMap3.get(j).get("AUTH_NAME");
								%>			
									<option value="<%=AuthGrade%>" <%=DataMap.get("AUTHORITYGRADE").equals(AuthGrade.trim()) ? "selected=selected":""%>><%=AuthName%></option>
								<%}%>
							</select>
						</td>
						<td>
								<button class='del'>삭제</button>
						</td>
					</tr>
				<%}%>
				</tbody>
			</table>
		</div>
		<div style="float: left;">
			<button onclick="uf_submit();return false;">등록</button>
			<button onclick="">취소</button>
		</div>
		<div style="float: right;height: 10px">
			<a href="#" onclick="javascript:moveRowUpDown('up');return false;"><img src="../../../img/object_08.png" /></a>
			<a href="#" onclick="javascript:moveRowUpDown('down');return false;"><img src="../../../img/object_09.png" /></a>
		</div>	
	</div>

</form>

<%@ include file="/jsp/inc/inc_bottom.jsp" %>
