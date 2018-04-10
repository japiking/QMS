<%@page import="org.apache.log4j.helpers.UtilLoggingLevel"%>
<%@page import="javax.swing.DebugGraphics"%>
<%@ page language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%@ include file="/jsp/inc/inc_ActionHeader.jsp" %>

<%!

public class test_execute_do implements SpbBiz {

    public boolean isNeedIDLogin() {
		// ID로그인이 필요 없으므로 false리턴
        return true;
    }
    
    public Map execute(HttpSession session, HttpServletRequest request, Map trmap) throws Exception{
    	String _tran_cd							= (String) trmap.get("_tran_cd");				 	// 서비스ID
        Map tranReqMap							= (Map)((List)trmap.get("_tran_req_data")).get(0);	// 전문 요청 개별부
        UserSession userSession					= (UserSession) session.getAttribute(Const.QMS_SESSION_ID);
        Map tranResOutMap   					= new HashMap();                                 	// 응답에 사용할 전체 Map
        List resultList 						= new ArrayList();								 	// 응답에 사용할 Data를 담는 List
        DataMap dataMap							= new DataMap();
        DBSessionManager qmsDB 					= null;
        String userId							= (String)tranReqMap.get("USERID");
    	List<Map<String,String>> result			= null;	//목록리스트 받기
    	List<Map<String,String>> result_action 	= null;
    	Map<String,String> stepId				= null;
    	Map<String,String> scenId				= null;
    	Map<String,String> caseId				= null;
    	
    	
    	try{
    		qmsDB = new DBSessionManager();
    		
    		try {
    			Map<String,String> param = new HashMap<String,String>();
    			Map<String,String> IdMap =new HashMap<String,String>();
    			Map<String,String> IoMap =new HashMap<String,String>();
    			ArrayList<String> list = new ArrayList();
    			
    			param.put("PROJECT_ID", 		userSession.getProjectID());
    			param.put("TESTER_ID",			userSession.getUserID());
    			
    			result = qmsDB.selectList("QMS_QUALITYCONTROL.TEST_MANAGEMENT_R005", param); //테스트ID가져옴
    			 				
    			for(int i=0;i<result.size();i++){
    				IdMap = result.get(i);
    				IdMap.put("PROJECT_ID", userSession.getProjectID());
    				IdMap.put("TESTER_ID" , result.get(i).get("TESTER_ID"));
    				IdMap.put("TEST_ID"	  , result.get(i).get("TEST_ID"));
    				
    				scenId=qmsDB.selectOne("QMS_QUALITYCONTROL.STEP_ACTION_R002",IdMap);
    				caseId=qmsDB.selectOne("QMS_QUALITYCONTROL.STEP_ACTION_R003",IdMap);
    				stepId=qmsDB.selectOne("QMS_QUALITYCONTROL.STEP_ACTION_R004",IdMap);
    				
    				result.get(i).put("SCENARIO_CNT",scenId.get("CNT"));
    				result.get(i).put("CASE_CNT",caseId.get("CNT"));
    				result.get(i).put("STEP_CNT",stepId.get("CNT"));
    			}
    			
    		} catch (Exception e) {
    			if (qmsDB != null) try { qmsDB.rollback(); } catch (Exception e1) {}
    		} 
    		
    		dataMap.put("rows", result);
    			

		} catch(Exception e) {
			e.printStackTrace(System.out);
			dataMap.put("ERROR_CODE", this.getClass().getName()+"에서 에러가 발생하였습니다.");
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
	request.setAttribute(SpbBiz.class.getName(), new test_execute_do());
%>