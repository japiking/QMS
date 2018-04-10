<%@ page language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%@ include file="/jsp/inc/inc_ActionHeader.jsp" %>

<%!

public class test_case_do implements SpbBiz {

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
    	List<Map<String,String>> result1		= null;												//TEST_MANAGEMENT��ϸ���Ʈ �ޱ�						
    	List<Map<String,String>> result2		= null;												//STEP_ACTION��ϸ���Ʈ �ޱ�
    	Map<String,String> stepId				= null;
    	Map<String,String> scenId				= null;
    	Map<String,String> caseId				= null;
    	String testId							= StringUtil.null2void((String)tranReqMap.get("TEST_ID"));
    	String scenarioId						= StringUtil.null2void((String)tranReqMap.get("SCENARIO_ID"));
    	String swrowId							= StringUtil.null2void((String)tranReqMap.get("SNROW_ID"));
    	try{
    		qmsDB = new DBSessionManager();
    		
    		try {
    			Map<String,String> param = new HashMap<String,String>();
    			Map<String,String> IdMap =null;
    			Map<String,String> exeMap =null;
    			
    			param.put("PROJECT_ID"	, 	userSession.getProjectID());
    			param.put("TESTER_ID"	, 	userSession.getUserID());
    			param.put("TEST_ID"		,	testId);
    			param.put("SCENARIO_ID"	,	scenarioId);
    			
    			result1 = qmsDB.selectList("QMS_QC_MANAGEMENT_LIST.CIRCUMSTANCE_R001", param);
    			//result2	= qmsDB.selectList("QMS_QC_MANAGEMENT_LIST.STEP_ACTION_R003", param);
    			
    			 for(int i=0;i<result1.size();i++){
    				result1.get(i).put("SNROW_ID", swrowId);
    			 }
    		} catch (Exception e) {
    			if (qmsDB != null) try { qmsDB.close(); } catch (Exception e1) {}
    			
    		} 
    		
    			dataMap.put("rows", result1);
    			
    			
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
	request.setAttribute(SpbBiz.class.getName(), new test_case_do());
%>