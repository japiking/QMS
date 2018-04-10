<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%@ include file="/jsp/inc/inc_common.jsp" %>
<%@ include file="/jsp/inc/inc_header.jsp" %>


<%
String board_id		= StringUtil.null2void(request.getParameter("BOARD_ID"));
String channel_nm	= StringUtil.null2void(request.getParameter("CHANEL_TYPE"));
String task_nm		= StringUtil.null2void(request.getParameter("task_nm"));  		// Task��
String inq_type		= StringUtil.null2void(request.getParameter("inq_type"), "A");  		// ��ȸŸ��
String strTodaty	= DateTime.getInstance().getDate("yyyy-mm-dd");

String pageNum		= StringUtil.null2void(request.getParameter("PAGE_NUM"),   "1");
String pageCount	= StringUtil.null2void(request.getParameter("PAGE_COUNT"), "10");  
int pageNumberCount = 10;
int start_rowId		= 1;
int end_rowId		= 0;
int page_num		= 1;
int page_count		= 0;
int tot_page_count	= 0;

//����¡����
int req_cnt  = Integer.parseInt("".equals(pageNum) ? "10" : pageCount);	// ��û�Ǽ�
int req_page = Integer.parseInt("".equals(pageNum) ? "1"  : pageNum);	// ��û������
int fromcnt = ((req_page-1)*req_cnt)+1;		// ���۹�ȣ
int tocnt	= (req_page*req_cnt);			// �����ȣ

// �Ķ���� ����
Map<String,Object> param = new HashMap<String,Object>();
param.put("BOARD_ID", 	board_id);
param.put("FROM_SEQ", 	fromcnt);
param.put("TO_SEQ", 	tocnt);
param.put("TODAY", 		strTodaty);

// ä�θ� �˻�
if(!"".equals(channel_nm) && "C".equals(inq_type)){
	param.put("CHANEL_NAME", 	channel_nm);
}

// Task�� �˻�(Ÿ��Ʋ)
if(!"".equals(task_nm) && "T".equals(inq_type)){
	param.put("TITLE", 	task_nm);
}

List<Map<String,String>> list	= qmsDB.selectList("QMS_BBS_LIST.BOARD_R001",	param);

String today = DateTime.getInstance().getDate("yyyy-mm-dd");
int intToday = Integer.parseInt(DateTime.getInstance().getDate("yyyymmdd"));
String date  = new String();
String state = new String();
String new_yn = "N";

int startpage = 0;
int endpage	=0;
int maxpage	=0;

// �Ǽ���ȸ SQL
Map<String,String> countMap	=qmsDB.selectOne("QMS_BBS_LIST.BOARD_R002", param);
int totCount		= StringUtil.null2zero(StringUtil.null2void(countMap.get("COUNT"), "0"));

page_num			= StringUtil.null2zero(pageNum);
page_count			= StringUtil.null2zero(pageCount);
tot_page_count		= totCount / page_count;

if( (totCount % page_count) > 0 ) tot_page_count++;
		
maxpage= tot_page_count; 

startpage = (((int) ((double)page_num / 10 + 0.9)) - 1) * 10 + 1;
endpage = maxpage; 
 
if (endpage>startpage+10-1) endpage=startpage+10-1;

// ���ó������ ����
Map<String,String> statsMap	= new HashMap<String,String>();
int sta1					= 0;			//������
int sta2					= 0; 			//�Ϸ�
int sta3					= 0;			//����
int sta4					= 0;			//�ϷΌ��
double tot_rate 			= 0.0; 
double exp_rate 			= 0.0; 
try{
	statsMap	= qmsDB.selectOne("QMS_BBS_LIST.BOARD_R003", param);
	sta1				= StringUtil.null2zero(statsMap.get("STA1"));
	sta2				= StringUtil.null2zero(statsMap.get("STA2"));
	sta3				= StringUtil.null2zero(statsMap.get("STA3"));
	sta4				= StringUtil.null2zero(statsMap.get("STA4"));
	//tot_rate = (sta2*100)/(sta1+sta2);
	if(totCount == 0 ){
		tot_rate = 0;
	}else{
		tot_rate = 	(double)(sta2 + sta3) / (double)totCount * 100;
	}
	if(sta4 == 0){
		exp_rate =100;
	}else{
		exp_rate = 	(double)(sta2 + sta3) /(double)sta4 * 100;
	}
}catch(Exception e){
	e.printStackTrace();
	sta1				= 0;
	sta2				= 0; 
	sta3				= 0;
	tot_rate			= 0;
}

//�˻� select�ڽ� ������
List<Map<String,String>> opt_list = null;
try{
	opt_list = qmsDB.selectList("QMS_BBS_LIST.BOARD_R004", param);
}catch(Exception e){
	LogUtil.getInstance().debug(e);
}


%>
<script type="text/javascript">
	var frm;
	var brd;
	$(document).ready(function(){
		frm = document.form1;
		brd_id = '<%=board_id%>'
		$("#CHANEL_NAME").val('<%=channel_nm%>');
		$("#inq_type").val('<%=inq_type%>');
		
		var menu_nm = $("#"+brd_id).text();
		$("h3").text(menu_nm);
		
		var tp = '<%=inq_type%>';
		if("A" == tp){
			$("#CHANEL_NAME").hide();
			$("#task_nm").hide();
		} else if("T" == tp){
			$("#CHANEL_NAME").hide();
			$("#task_nm").show();
		} else if("C" == tp){
			$("#CHANEL_NAME").show();
			$("#task_nm").hide();
		}
		
		
		// �˻������� �ٲ��� Ÿ�� �Լ�
		$("#inq_type" ).change(function() {
			var type = $("#inq_type").val();
			if("A" == type){
				$("#CHANEL_NAME").hide();
				$("#task_nm").hide();
			} else if("T" == type){
				$("#CHANEL_NAME").hide();
				$("#task_nm").show();
			} else if("C" == type){
				$("#CHANEL_NAME").show();
				$("#task_nm").hide();
			}
		});
	});
	function uf_inq(pagenum) {                        // �Ķ���� : ��ȸ ������
		var frm				= document.frm;
		if(pagenum == 0){
			pagenum = '1';
		}
		frm.PAGE_NUM.value	= pagenum;
		frm.BOARD_ID.value	= brd_id;
				
		frm.target			= "_self";
		frm.action			= "/QMS/jsp/view/bbs/bbs_list_view.jsp";
		frm.submit();
	}
	
	function uf_search(param) {                        // �Ķ���� : ��ȸ ������
		var frm				= document.frm;
		var nm = $("#CHANEL_NAME").val();
		var type = $("#inq_type").val();
		
		if("A" == type){
			frm.CHANEL_TYPE.value = '';
			frm.task_nm.value = '';
		} else if("T" == type){
			frm.CHANEL_TYPE.value = '';
		} else if("C" == type){
			frm.CHANEL_TYPE.value = nm;
			frm.task_nm.value = '';
		}
		
		frm.CHANEL_TYPE.value = nm;
		frm.BOARD_ID.value	= brd_id;
				
		frm.target			= "_self";
		frm.action			= "/QMS/jsp/view/bbs/bbs_list_view.jsp";
		frm.submit();
	}
	
	
	function uf_cancel(rowid) {
				return;
	}
	
	function uf_FileDownLoad(fnm) {		
		//alert(fnm);
		location.href = "/QMS/jsp/comm/FileDown.jsp?filename=" + encodeURI(fnm);
	}
	
	function uf_detail(rowid, seq, depth) {
		var frm				= document.frm;	
		frm.BBS_ID.value	= rowid;
		frm.BOARD_ID.value	= brd_id;
		frm.SEQ.value		= seq;
		frm.DEPTH.value		= depth;
		frm.target			= "_self";
		frm.action			= "/QMS/jsp/view/bbs/bbs_detail_view.jsp";
		frm.submit();
	}
	
	function uf_modify(param, seq, depth) { 
		var frm				= document.frm;
		if(param == 1) frm.BBS_ID.value	= "";
		else frm.BBS_ID.value	= param;
		
		frm.BOARD_ID.value			= brd_id;
		frm.SEQ.value				= seq;
		frm.DEPTH.value				= depth;
		frm.DETAIL_STATE.value		= "U";
		frm.target					= "_self";
		frm.action			= "/QMS/jsp/view/bbs/bbs_write_view.jsp";
		frm.submit();
	}
	
	function uf_reg() { 
		var frm				= document.frm;
		frm.BBS_ID.value	= "";
		frm.BOARD_ID.value			= brd_id;
		frm.target					= "_self";
		frm.action			= "/QMS/jsp/view/bbs/bbs_write_view.jsp";
		frm.submit();
	}
	// Excel���� ���ε� �˾�
	function uf_upload() {
		var frm				= document.frm;
		window.open('', 'EXCEL', 'scrollbars=no,toolbar=yes,resizable=no,width=400,height=180,left=0,top=0');
		frm.target			= "EXCEL";
		frm.BOARD_ID.value	= brd_id;
		frm.action			= "/QMS/jsp/view/bbs/bbs_popup_view.jsp";
		frm.submit();
	}
	/**
	* ������� ����
	**/
	function uf_stateUpdate(bbsId, stat, seq, b_stat) {
		var frm				= document.frm;
		frm.BOARD_ID.value	= brd_id;
		frm.BBS_ID.value	= bbsId;
		frm.STAT.value		= stat; // C:�Ϸ� D:����, E:����
		frm.BEFORE_STAT.value = b_stat; // ���� ���°�
		frm.SEQ.value		= seq;
		frm.BOARD_ID.value	= brd_id;
		
        var nm = $("#CHANEL_NAME").val();
		var type = $("#inq_type").val();
		
		if("A" == type){
			frm.CHANEL_TYPE.value = '';
			frm.task_nm.value = '';
		} else if("T" == type){
			frm.CHANEL_TYPE.value = '';
		} else if("C" == type){
			frm.CHANEL_TYPE.value = nm;
			frm.task_nm.value = '';
		}
		
		frm.CHANEL_TYPE.value = nm;
		frm.target			= '_self';
// 		frm.target			= "HiddenFrame";
		frm.action			= "/QMS/jsp/view/bbs/bbs_list_do.jsp";
		frm.submit();
	}
	
</script>
<%@ include file="/jsp/inc/inc_topMenu.jsp" %>
<%@ include file="/jsp/inc/inc_leftMenu.jsp" %>
<form name="frm" method="post">
	<input type="hidden" name="PAGE_NUM"	value="<%=pageNum%>" 	/>
	<input type="hidden" name="CHANEL_TYPE"	value="" 	/>
  	<input type="hidden" name="PAGE_COUNT"	value="<%=pageCount %>" 	/>
  	<input type="hidden" name="BOARD_ID"	value="<%=board_id %>"	/>
  	<input type="hidden" name="BBS_ID"		value="" 	/>
  	<input type="hidden" name="SEQ"			value="" 	/>
  	<input type="hidden" name="STAT"		value="" 	/>
  	<input type="hidden" name="BEFORE_STAT"	value="" 	/>
	<input type="hidden" name="DEPTH"		value="" 	/>
	<input type="hidden" name="DETAIL_STATE" 	value="" 	/>
	<div class="wrap">
		<h3></h3>
		<%-- <table>
			<colgroup>
				<col width="20%"/>
				<col width="20%"/>
				<col width="20%"/>
				<col width="20%"/>
				<col width="20%"/>
			</colgroup>
			<tbody>
				<tr>
					<th scope="row" style="text-align: center;">�Ѻ���</th>
					<th scope="row" style="text-align: center;">������</th>
					<th scope="row" style="text-align: center;">�Ϸ�</th>
					<th scope="row" style="text-align: center;">����</th>
					<th scope="row" style="text-align: center;">�Ϸ���</th>
				</tr>
				<tr>
					<td scope="row" style="text-align: center;"><%=totCount %></td>
					<td scope="row" style="text-align: center;"><%=sta1 %></td>
					<td scope="row" style="text-align: center;"><%=sta2 %></td>
					<td scope="row" style="text-align: center;"><%=sta3 %></td>
					<td scope="row" style="text-align: center;"><%=tot_rate %>%</td>
				</tr>
			</tbody>
		</table> 
		<br/>
		<br/>	--%>	
		<table>
		<colgroup>
				<col width="12%"/>
				<col width="12%"/>
				<col width="12%"/>
				<col width="12%"/>
				<col width="12%"/>
				<col width="12%"/>
				<col width="12%"/>
				<col width="12%"/>
			</colgroup>
			<tbody>
			<tr>
				<th scope="row" style="text-align: center;">ä�α���</th>
				<th scope="row" style="text-align: center;">�Ѻ���</th>
				<th scope="row" style="text-align: center;">������</th>
				<th scope="row" style="text-align: center;">�ϷΌ��</th>
				<th scope="row" style="text-align: center;">�Ϸ�</th>
				<th scope="row" style="text-align: center;">����</th>
				<th scope="row" style="text-align: center;">�Ϸ���</th>
				<th scope="row" style="text-align: center;">��ȹ�����ô��</th>
			</tr>
	<%	
	//��ü���
	
	%>
	
		<tr>
			<td scope="row" style="text-align: center;">��ü</td>
			<td scope="row" style="text-align: center;"><%=totCount %></td>
			<td scope="row" style="text-align: center;"><%=sta1 %></td>
			<td scope="row" style="text-align: center;"><%=sta4 %></td>
			<td scope="row" style="text-align: center;"><%=sta2 %></td>
			<td scope="row" style="text-align: center;"><%=sta3 %></td>
			<td scope="row" style="text-align: center;"><%=String.format("%.2f",tot_rate)  %>%</td>
			<td scope="row" style="text-align: center;"><%=String.format("%.2f",exp_rate)  %>%</td>
		</tr>
	<%
	//ü�κ����
for(int i=0; i < opt_list.size();i++){
	// �Ǽ���ȸ SQL
	String strChanel_name = opt_list.get(i).get("CHANEL_NAME");
	Map<String,Object> param_ch = new HashMap<String,Object>();
	param_ch.put("TODAY", 		strTodaty);
	param_ch.put("BOARD_ID", 	board_id);
	param_ch.put("CHANEL_NAME", strChanel_name);
	Map<String,String> countMap_ch	=qmsDB.selectOne("QMS_BBS_LIST.BOARD_R002", param_ch);
	int totCount_ch		= StringUtil.null2zero(StringUtil.null2void(countMap_ch.get("COUNT"), "0"));
	Map<String,String> statsMap_ch	= new HashMap<String,String>();
	int sta1_ch					= 0;			//������
	int sta2_ch					= 0; 			//�Ϸ�
	int sta3_ch					= 0;			//����
	int sta4_ch					= 0;			//�ϷΌ��
	double tot_rate_ch			= 0.0; 
	double exp_rate_ch			= 0.0; 
	try{
		statsMap	= qmsDB.selectOne("QMS_BBS_LIST.BOARD_R003", param_ch);
		sta1_ch				= StringUtil.null2zero(statsMap.get("STA1"));	//������ 
		sta2_ch				= StringUtil.null2zero(statsMap.get("STA2"));	//�Ϸ�  
		sta3_ch				= StringUtil.null2zero(statsMap.get("STA3"));	//����  
		sta4_ch				= StringUtil.null2zero(statsMap.get("STA4"));	//�ϷΌ��
		if(totCount_ch == 0 ){
			tot_rate_ch = 0;
		}else{
			tot_rate_ch = 	(double)(sta2_ch + sta3_ch) / (double)totCount_ch * 100;
		}
		if(sta4_ch == 0){
			exp_rate_ch =100;
		}else{
			exp_rate_ch = 	(double)(sta2_ch + sta3_ch) /(double)sta4_ch * 100;
		}
		%>
				<tr>
					<td scope="row" style="text-align: center;"><%=strChanel_name %></td>
					<td scope="row" style="text-align: center;"><%=totCount_ch %></td>
					<td scope="row" style="text-align: center;"><%=sta1_ch %></td>
					<td scope="row" style="text-align: center;"><%=sta4_ch %></td>
					<td scope="row" style="text-align: center;"><%=sta2_ch %></td>
					<td scope="row" style="text-align: center;"><%=sta3_ch %></td>
					<td scope="row" style="text-align: center;"><%=String.format("%.2f",tot_rate_ch)  %>%</td>
					<td scope="row" style="text-align: center;"><%=String.format("%.2f",exp_rate_ch)  %>%</td>
				</tr>
			
		<%
	}catch(Exception e){
		e.printStackTrace();
		sta1_ch				= 0;
		sta2_ch				= 0; 
		sta3_ch				= 0;
		tot_rate_ch 		= 0;
		exp_rate_ch			= 0;
	}
}
 %>
 			</tbody>
		</table>
		<br/><br/>
		<div class="btnWrapR">
			<a href="#" class="btn" onclick="javascript:uf_reg(1);"><span>�۾���</span></a>
			<a href="#" class="btn" onclick="javascript:uf_upload();"><span>Excel ���� ���</span></a>
			&nbsp;&nbsp;&nbsp;
			<select name="inq_type" id="inq_type">
				<option value="A">��ü</option>
				<option value="T">Task��</option>
				<option value="C">ä��</option>
			</select>
			<select name="CHANEL_NAME" id="CHANEL_NAME" style="display: none;">
				<option value="">��ü</option>
				<%
				if(null != opt_list && !opt_list.isEmpty()){
					for(int k=0; k<opt_list.size(); k++){
						Map<String,String> tmp = opt_list.get(k);
				%>
				<option value="<%=StringUtil.null2void(tmp.get("CHANEL_NAME")) %>"><%=StringUtil.null2void(tmp.get("CHANEL_NAME")) %></option>
				<%
					}
				}
				%>
			</select>
			<input type="text" id="task_nm" name="task_nm" value="<%=task_nm %>" style="display: none;" />
			<a href="#FIT" class="btn" onclick="javascript:uf_search();"><span>�˻�</span></a>
		</div>
		<table class="list">
			<colgroup>
				<col width="3%"/>
				<col width="30%"/>
				<col width="5%"/>
				<col width="6%"/>
				<col width="20%"/>
				<col width="8%"/>
				<col width="8%"/>
				<col width="8%"/>
				<col width="8%"/>
				<col width="*"/>			
			</colgroup>
			<thead>
				<tr>
					<th scope="col" style="text-align: center;">No</th>
					<th scope="col" style="text-align: center;">Task��</th>
					<th scope="col" style="text-align: center;">ä��</th>
					<th scope="col" style="text-align: center;">�������</th>
					<th scope="col" style="text-align: center;">��ô</th>
					<th scope="col" style="text-align: center;">�����</th>				
					<th scope="col" style="text-align: center;">����Ͻ�</th>
					<th scope="col" style="text-align: center;">�ϷΌ����</th>					
					<th scope="col" style="text-align: center;">�Ϸ�����</th>				
<!-- 					<th scope="col" style="text-align: center;">�Ϸ�ð�</th> -->
					<th scope="col" style="text-align: center;">÷��</th>
				</tr>
			</thead>
			<tbody>
				<% if( list == null || list.size() == 0 ) { %>
				<tr>
					<td colspan="9">��ȸ �����Ͱ� �����ϴ�.</td>
				</tr>
				<% } else {
					Map<String,String> dataMap	= null;
					String state_nm = new String();
					for( int i = 0; i < list.size(); i++ ) {
						dataMap	= list.get(i);
						state_nm = "";
						String cmptDate = StringUtil.null2void(dataMap.get("COMPLETION_DATE"), "1999-12-31");
						cmptDate		= cmptDate.replaceAll("-", "");
						
						// ���°� üũ
						state =  StringUtil.null2void(dataMap.get("STATE"));
						if(intToday > Integer.parseInt(cmptDate) && !"111".equals(state) && !"999".equals(state)){
							state_nm = "����";
						}else{
							if("000".equals(state)) state_nm = "����";
							else if("111".equals(state)) state_nm = "�Ϸ�";
							else if("222".equals(state)) state_nm = "���";
							else if("333".equals(state)) state_nm = "�Ϸ��û";
							else if("444".equals(state)) state_nm = "���ܿ�û";
							else if("555".equals(state)) state_nm = "������û";
							else if("999".equals(state)) state_nm = "����";
						}
						// ���� ���� üũ
						new_yn = "N";
						date = dataMap.get("BBS_REG_DATE");
						if(today.equals(date)) new_yn = "Y";
						
						LogUtil.getInstance().debug("LSJ----CONFIRM_USER>>"+dataMap.get("CONFIRM_USER"));
				%>
				<tr height="45px">
					<td><%=dataMap.get("ROW_SEQ")%></td>
					<%if(dataMap.get("DEPTH").equals("1")){
					%>
					<td class="alL">
						<a href="#" onclick="javascript:uf_detail('<%=dataMap.get("BBS_ID")%>','<%=dataMap.get("SEQ")%>','<%=dataMap.get("DEPTH")%>');"><%=dataMap.get("TITLE")%><%if(new_yn.equals("Y")) out.print("<img src='/QMS/img/new.jpg'>");%></a>
					</td>
					<td><%=dataMap.get("CHANEL_NAME")%></td>
					<td><%=state_nm%></td>
					<td>
						<%
						// �Ϸᳪ ���ο�û�� ���
						if(!"333".equals(state) && !"444".equals(state) && !"555".equals(state)){
							if(intToday > Integer.parseInt(cmptDate) && !"111".equals(state) && !"999".equals(state)){ %>
								<%if(userSession.getUserID().equals(dataMap.get("BBS_USER")) || "00".equals(userSession.getAuthorityGrade())){%>
									<a href="#FIT" class="btn" onclick="javascript:uf_stateUpdate('<%=dataMap.get("BBS_ID")%>', 'C','<%=dataMap.get("SEQ")%>');" ><span>�Ϸ�</span></a>
									<a href="#FIT" class="btn" onclick="javascript:uf_stateUpdate('<%=dataMap.get("BBS_ID")%>', 'E','<%=dataMap.get("SEQ")%>');" ><span>����</span></a>
									<a href="#FIT" class="btn" onclick="javascript:uf_stateUpdate('<%=dataMap.get("BBS_ID")%>', 'D','<%=dataMap.get("SEQ")%>');" ><span>����</span></a>
								<%}%>
							<%}else{ %>
								<%if(userSession.getUserID().equals(dataMap.get("BBS_USER")) || "00".equals(userSession.getAuthorityGrade())){%>
									<%if("222".equals(state)) {%>
										<a href="#FIT" class="btn" onclick="javascript:uf_stateUpdate('<%=dataMap.get("BBS_ID")%>', 'S','<%=dataMap.get("SEQ")%>');" ><span>����</span></a>
										<a href="#FIT" class="btn" onclick="javascript:uf_stateUpdate('<%=dataMap.get("BBS_ID")%>', 'C','<%=dataMap.get("SEQ")%>');" ><span>�Ϸ�</span></a>
										<a href="#FIT" class="btn" onclick="javascript:uf_stateUpdate('<%=dataMap.get("BBS_ID")%>', 'E','<%=dataMap.get("SEQ")%>');" ><span>����</span></a>
										<a href="#FIT" class="btn" onclick="javascript:uf_stateUpdate('<%=dataMap.get("BBS_ID")%>', 'D','<%=dataMap.get("SEQ")%>');" ><span>����</span></a>
									<%} else if("000".equals(state)) {%>
										<a href="#FIT" class="btn" onclick="javascript:uf_stateUpdate('<%=dataMap.get("BBS_ID")%>', 'C','<%=dataMap.get("SEQ")%>');" ><span>�Ϸ�</span></a>
										<a href="#FIT" class="btn" onclick="javascript:uf_stateUpdate('<%=dataMap.get("BBS_ID")%>', 'E','<%=dataMap.get("SEQ")%>');" ><span>����</span></a>
										<a href="#FIT" class="btn" onclick="javascript:uf_stateUpdate('<%=dataMap.get("BBS_ID")%>', 'D','<%=dataMap.get("SEQ")%>');" ><span>����</span></a>
									<%} else {%>
										<a href="#FIT" class="btn" onclick="javascript:uf_modify('<%=dataMap.get("BBS_ID")%>','<%=dataMap.get("SEQ")%>','<%=dataMap.get("DEPTH")%>');"				><span>����</span></a>
	<%-- 									<a href="#FIT" class="btn" onclick="javascript:uf_stateUpdate('<%=dataMap.get("BBS_ID")%>', 'D','<%=dataMap.get("SEQ")%>');" ><span>����</span></a> --%>
									<%}%>
								<%}%>
							<%}
						} else { 
							if(userSession.getUserID().equals(dataMap.get("CONFIRM_USER")) && "01".equals(userSession.getAuthorityGrade())){
						%>
						
							<a href="#FIT" class="btn" onclick="javascript:uf_stateUpdate('<%=dataMap.get("BBS_ID")%>', 'A','<%=dataMap.get("SEQ")%>','<%=state%>');" ><span>����</span></a>
							<a href="#FIT" class="btn" onclick="javascript:uf_stateUpdate('<%=dataMap.get("BBS_ID")%>', 'R','<%=dataMap.get("SEQ")%>','<%=state%>');" ><span>�ź�</span></a>
						<%
							}
						} 
						%>
					</td>
					<%} else { %> 
					<td class="alL">
						���亯:<a href="#FIT" onclick="javascript:uf_detail('<%=dataMap.get("BBS_ID")%>', '<%=dataMap.get("SEQ")%>', '<%=dataMap.get("DEPTH")%>');"><%=dataMap.get("TITLE")%></a>
					</td>
					<td><%=dataMap.get("CHANEL_NAME")%></td>
					<td>-</td>
					<td>-</td>
					<%}//end else %>
					<td><%=dataMap.get("USERNAME")%>(<%=dataMap.get("BBS_USER")%>)</td>
					<td><%=dataMap.get("BBS_REG_DATE")%></td>
					<td><%=dataMap.get("COMPLETION_DATE")%></td>
					<td><%=StringUtil.null2void(dataMap.get("COMPLETE_DATE"))%></td>
<%-- 					<td><%=StringUtil.null2void(dataMap.get("COMPLETE_TIME"))%></td> --%>
					<td>
					<%	
							List<Map<String,String>> ar	= null;
							try {
								Map<String,String> paramR004 = new HashMap<String,String>();
								paramR004.put("BBS_ID", dataMap.get("BBS_ID"));
								ar	= qmsDB.selectList("QMS_BBS_ONELOW.BBS_ATTACHMENT_R004", paramR004);
							} catch (Exception e) {
								if (qmsDB != null) try { qmsDB.close(); } catch (Exception e1) {}
							}
							
							if(null != ar && ar.size() > 0){
								for (int k=0; k<ar.size(); k++) {
					%>
								<a href="#FIT" class="sBtn" onclick="javascript:uf_FileDownLoad('<%=ar.get(k).get("FILE_INFO")%>');"><span><b>÷��<%=k+1 %></b></span></a><br/>
					<%
								}
							}
					%>
					</td>								
				</tr>
				<%
					}
			  	 } // end else
			  	%>
			</tbody>
		</table>
		<div class="paging">
			<ul>
				<li class="bt"><a href="javascript:uf_inq('1')">[First]</a></li>
				<li class="bt"><a href="javascript:uf_inq('<%=page_num - 1%>')">[Prev]</a></li>
	<%		for( int a = startpage; a <= endpage; a++ ) { %>
				<li><a href="#FIT" onclick='javascript:uf_inq(<%=a%>);'>
				<%
					if(a == page_num){ 
						out.print("<B>" + a + "</B>");
					} else { 
						out.print(a);
					} 
				%></a></li>
	<%		}  %>
				<li class="bt"><a href="javascript:uf_inq('<%=page_num + 1%>')">[Next]</a></li>
				<li class="bt"><a href="javascript:uf_inq('<%=tot_page_count%>')">[Last]</a></li>
			</ul>
		</div>
	</div>
 
</form>

<%@ include file="/jsp/inc/inc_bottom.jsp" %>
