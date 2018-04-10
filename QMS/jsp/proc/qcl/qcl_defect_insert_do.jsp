<%--
/******************************************************************************
* @ �� �� �� : Q00101_do.jsp
* @ �������� : Q00101_do.jsp
* @ �� �� �� : /jsp/proc/bbs/bbs_Q00101_do.jsp
* @ �� �� �� : webCash
* @ �� �� �� : 2015-01-23
************************** �� �� �� �� ****************************************
* ��ȣ  �� �� ��    ��  ��  ��                       ���泻��
*******************************************************************************
*  1  webCash	2015-01-23      ���� �ۼ�
******************************************************************************/
--%>
<%@ page language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%@ include file="/jsp/inc/inc_ActionHeader.jsp" %>

<%!

public class defect_insert_do implements SpbBiz {

    public boolean isNeedIDLogin() {
		// ID�α����� �ʿ� �����Ƿ� false����
        return true;
    }
    
    public Map execute(HttpSession session, HttpServletRequest request, Map trmap) throws Exception{
    	String _tran_cd							= (String) trmap.get("_tran_cd");				 	// ����ID
        Map tranReqMap							= (Map)((List)trmap.get("_tran_req_data")).get(0);	// ���� ��û ������
        UserSession userSession					= (UserSession) session.getAttribute(Const.QMS_SESSION_ID);
        Map tranResOutMap   					= new HashMap();                                 	// ���信 ����� ��ü Map
        List resultList 						= new ArrayList();								 	// ���信 ����� Data�� ��� List
        DataMap dataMap							= new DataMap();
        DBSessionManager qmsDB 					= null;
    	List<Map<String,String>> result			= null;												//��ϸ���Ʈ �ޱ�						
		int flag = 0;
		Map<String,String> dataM				= (Map)tranReqMap.get("data");
		String strDefectCnts					= StringUtil.null2void(tranReqMap.get("DEFECT_CNTS"));
    	
    	try{
    		qmsDB = new DBSessionManager();
    		
    		try {
    			Map<String,String> getSeq=null;
    			getSeq	=	qmsDB.selectOne("QMS_DEFECT.DEFECT_SEQ_R001");
    			String id			= "DEFECT_"+ BizUtil.getPadString(getSeq.get("DEFECT_SEQ"), 10, "0");
    			
    			Map<String,String> param = new HashMap<String,String>();
    			param.put("DEFECT_CNTS", 			strDefectCnts);
    			param.put("DEFECT_SEQ", 			dataM.get("DEFECT_SEQ"));
    			param.put("DEVELOPER_ID", 			dataM.get("DEVELOPER_ID"));
    			param.put("DEFECT_STATUS", 			dataM.get("DEFECT_STATUS"));
    			param.put("MESSENGER", 				dataM.get("MESSENGER"));
    			param.put("TESTER_ID", 				userSession.getUserID());
    			param.put("TEST_ID", 				dataM.get("TEST_ID"));
    			param.put("SCENARIO_ID", 			dataM.get("SCENARIO_ID"));
    			param.put("CASE_ID", 				dataM.get("CASE_ID"));
    			param.put("STEP_ID", 				dataM.get("STEP_ID"));
    			param.put("PROJECT_ID", 			userSession.getProjectID());
    			param.put("IMPORTANCE", 			dataM.get("IMPORTANCE"));
    			param.put("DEFECT_ID", 				id);
    			param.put("DEFECT_SEQ", 			getSeq.get("DEFECT_SEQ"));
    			param.put("DEL_FLAG", 				"N");
    			param.put("DEFECT_START_DATE", 		dataM.get("DEFECT_START_DATE"));
    			param.put("DEFECT_TITLE", 			dataM.get("DEFECT_TITLE"));
    			
    			flag = qmsDB.insert("QMS_DEFECT.DEFECT_MANAGEMENT_C001", param);
    			
    		} catch (Exception e) {
    			if (qmsDB != null) try { qmsDB.close(); } catch (Exception e1) {}
    			LogUtil.getInstance().info("query error : " + e.toString()); 
    		} 
    		
    			dataMap.put("RESULT", flag);
    			
		} catch(Exception e) {
			e.printStackTrace(System.out);
			dataMap.put("ERROR_CODE", this.getClass().getName()+"���� ������ �߻��Ͽ����ϴ�.");
			dataMap.put("RESPONSE_GUIDE_MESSAGE", e.getMessage());
			resultList.add(dataMap);
			if (qmsDB != null) try { qmsDB.rollback(); } catch (Exception e1) {}
		}finally{			
			if (qmsDB != null) try { qmsDB.close(); } catch (Exception e1) {}
		}
    	
    	resultList.add(dataMap);
    	tranResOutMap.put("_tran_cd",       _tran_cd);
		tranResOutMap.put("_tran_res_data",  resultList);
        return tranResOutMap;
    }
}
%>
<%
	request.setAttribute(SpbBiz.class.getName(), new defect_insert_do());
%>