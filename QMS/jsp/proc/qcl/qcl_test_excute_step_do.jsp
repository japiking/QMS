<%@ page language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%@ include file="/jsp/inc/inc_ActionHeader.jsp" %>

<%!

public class test_excute_step_do implements SpbBiz {

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
    	List<Map<String,String>> result			= null;
    	String testId							= (String)tranReqMap.get("TEST_ID");
    	String scenarioId						= (String)tranReqMap.get("SCENARIO_ID");
    	String caseId							= (String)tranReqMap.get("CASE_ID");
    	String stepId							= (String)tranReqMap.get("STEP_ID");
    	Map<String,String> countMap				=null;
    	String count							="";
    	try{
    			qmsDB = new DBSessionManager();
    		
    		try {
    			Map<String,String> param = new HashMap<String,String>();
    			
    			param.put("PROJECT_ID"	,	userSession.getProjectID());
    			param.put("TESTER_ID"	,	userSession.getUserID());
    			param.put("TEST_ID"		,   testId);
    			param.put("SCENARIO_ID"	,	scenarioId);
    			param.put("CASE_ID"		,   caseId);
    			param.put("STEP_ID"		,	stepId);
    			result 		=	qmsDB.selectList("QMS_QUALITYCONTROL.HISTORY_R003", param);
    			countMap	=	qmsDB.selectOne("QMS_QUALITYCONTROL.TEST_MANAGEMENT_R006",param);
    			count		=	countMap.get("CNT");
    		} catch (Exception e) {
    			if (qmsDB != null) try { qmsDB.rollback(); } catch (Exception e1) {}
    			
    		}
    			dataMap.put("rows", result);
    			dataMap.put("count", count);
    			
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
	request.setAttribute(SpbBiz.class.getName(), new test_excute_step_do());
%>