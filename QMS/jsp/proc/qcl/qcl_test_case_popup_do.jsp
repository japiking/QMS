<%@ page language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%@ include file="/jsp/inc/inc_ActionHeader.jsp" %>

<%!

public class test_case_popup_do implements SpbBiz {

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
    	List<Map<String,String>> result			= null;	//목록리스트 받기
    	List<Map<String,String>> statResult		= null;						
    	String testId							= (String)tranReqMap.get("TEST_ID");
    	String scenarioId						= (String)tranReqMap.get("SCENARIO_ID");
    	String caseId							= (String)tranReqMap.get("CASE_ID");
    	
    	try{
    		qmsDB = new DBSessionManager();
    		
    		try {
    			Map<String,String> param = new HashMap<String,String>();
    			Map<String,String> statMap = new HashMap<String,String>();
    			
    			param.put("PROJECT_ID"	,	userSession.getProjectID());
    			param.put("TEST_ID"		,                       testId);
    			param.put("SCENARIO_ID"	,					scenarioId);
    			param.put("CASE_ID"		,                       caseId);
    			param.put("TESTER_ID"	,		userSession.getUserID());
    			
    			result = qmsDB.selectList("QMS_QUALITYCONTROL.STEP_R002", param);
    			
    			for(int i = 0; i<result.size(); i++){
    				param.put("STEP_ID"	,	result.get(i).get("STEP_ID"));
    				statResult = qmsDB.selectList("QMS_QUALITYCONTROL.STEP_ACTION_R005", param);
    				if(null != statResult){
    					
    					int statcnt = 0;
						String strStat ="";
						
						for(int j = 0; j<statResult.size(); j++){
	    					
							statMap	= statResult.get(j);
	    					int level = Integer.parseInt(statMap.get("STATUS_LEVEL"));
	    					
	    					if(statcnt<level){
	    						statcnt = level;
	    						strStat = statMap.get("STEP_STATUS").trim();	
	    					}//end if
							
	    				}//end for
    				result.get(i).put("STEP_STATUS", strStat);
	    						
    				}//end if
    			}//end for
    			
    			
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
	request.setAttribute(SpbBiz.class.getName(), new test_case_popup_do());
%>