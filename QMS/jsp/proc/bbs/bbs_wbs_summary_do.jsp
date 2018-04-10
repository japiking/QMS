<%--
/******************************************************************************
* @ �� �� �� : wbs_summary_do.jsp
* @ �������� : wbs_summary_do.jsp
* @ �� �� �� : /jsp/proc/bbs/bbs_wbs_summary_do.jsp.jsp
* @ �� �� �� : webCash
* @ �� �� �� : 2015-01-26
************************** �� �� �� �� ****************************************
* ��ȣ  �� �� ��    ��  ��  ��                       ���泻��
*******************************************************************************
*  1  webCash	2015-01-26      ���� �ۼ�
******************************************************************************/
--%>
<%@page import="qms.wbs.WBSUtil"%>
<%@page import="qms.wbs.WBSNode"%>
<%@ page language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%@ include file="/jsp/inc/inc_ActionHeader.jsp" %>

<%!

public class bbs_wbs_summary_do implements SpbBiz {

    public boolean isNeedIDLogin() {
		// ID�α����� �ʿ� �����Ƿ� false����
        return true;
    }
    
    public Map execute(HttpSession session, HttpServletRequest request, Map trmap) throws Exception{
    	UserSession userSession	= (UserSession) session.getAttribute(Const.QMS_SESSION_ID);
    	Map<String,String> param = new HashMap<String,String>();
    	String _tran_cd		= (String) trmap.get("_tran_cd");				 	// ����ID
        Map tranReqMap		= (Map)((List)trmap.get("_tran_req_data")).get(0);	// ���� ��û ������
	 	// ���信 ����� Data�� ��� List
		DataMap dataMap		= new DataMap();
		DataMap indata		= new DataMap();
		BizUtil.putAllDataMap(indata, tranReqMap);
    	String strInputTaskCode	= indata.getstr("TASK_CODE");
    	strInputTaskCode= strInputTaskCode.replaceAll("a",".");
    	WBSNode rootNode =  WBSUtil.makeWBSTree(userSession.getProjectID());
    	WBSNode inputNode = WBSUtil.findNode(rootNode, strInputTaskCode);
    	
    	Vector<WBSNode> children = inputNode.getChildren();
    	List resultList1 	= new ArrayList();	
		for(int i = 0; i < children.size(); i ++){
			WBSNode tempNode = children.get(i);
			boolean bLeafNode = tempNode.isLeafNode();//������忩��
			String strTaskCode = tempNode.getTaskCode();//�׽�ũ�ڵ�
			String strTaskTitle = tempNode.getAttribute("TASK_TITLE");//�½�ũŸ��Ʋ
			String strTaskLevel = tempNode.getAttribute("TASK_LEVEL"); //����
			int nLeafCount = tempNode.getLeafCount();//�Ѱ���
			int nExpected = tempNode.getSumValueDate("PLAN_ENDG_DATE"); //������ ����Ϸ᰹��
			int nIng = tempNode.getSumValue("NOW_STAT", "222"); //������
			int nEd = tempNode.getSumValue("NOW_STAT", "111"); //�Ϸ�
			int nEx = tempNode.getSumValue("NOW_STAT", "999"); //����
			double progressRateTotal = (double)(nEd+nEx)/(double)nLeafCount*100;// ������
			double progressRateByPlan = (double)(nEd+nEx)/(double)nExpected*100; //��ȹ�����ô��
			if(nExpected == 0){
				progressRateByPlan = 100;
			}
			
			DataMap dataMap1		= new DataMap();
			dataMap1.put("LEAF_NODE",bLeafNode?"Y":"N");
			dataMap1.put("TASK_CODE",strTaskCode);
			dataMap1.put("TASK_TITLE",strTaskTitle);
			dataMap1.put("TOTAL_COUNT",nLeafCount);
			dataMap1.put("EXPECTED",String.valueOf(nExpected));
			dataMap1.put("IN_PROGRESSING",String.valueOf(nIng));
			dataMap1.put("COMPLETE",String.valueOf(nEd));
			dataMap1.put("EXCEPTED",String.valueOf(nEx));
			dataMap1.put("PROGRESS_RATE_TOTAL",String.format("%.2f" , progressRateTotal));
			dataMap1.put("PROGRESS_RATE_PLAN",String.format("%.2f" , progressRateByPlan));
			dataMap1.put("TASK_LEVEL",strTaskLevel);
			resultList1.add(dataMap1);
		}
		dataMap.put("CHILDREN",resultList1);
 		Map tranResOutMap   = new HashMap();                                 	// ���信 ����� ��ü Map
        List resultList 	= new ArrayList();	
    	resultList.add(dataMap);
    	tranResOutMap.put("_tran_cd",       _tran_cd);
		tranResOutMap.put("_tran_res_data",  resultList);
        return tranResOutMap;
    }
}
%>
<%
	request.setAttribute(SpbBiz.class.getName(), new bbs_wbs_summary_do());
%>