<%@ page language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%@ include file="/jsp/inc/inc_ActionHeader.jsp" %>

<%!

public class test_list_do implements SpbBiz {

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
    	List<Map<String,String>> result			= null;												//목록리스트 받기						
    	Map<String,String> stepId				= null;
    	Map<String,String> scenId				= null;
    	Map<String,String> caseId				= null;
    	
    	
    	try{
    		qmsDB = new DBSessionManager();
    		
    		try {
    			Map<String,String> param = new HashMap<String,String>();
    			Map<String,String> IdMap =null;
    			
    			param.put("PROJECT_ID", 		userSession.getProjectID());
    			param.put("DEL_FLAG",								"N");
    			result = qmsDB.selectList("QMS_QUALITYCONTROL.TEST_MANAGEMENT_R001", param);
    			
    			for(int i=0;i<result.size();i++){
    				IdMap = result.get(i);
    				IdMap.put("PROJECT_ID", userSession.getProjectID());
    				scenId=qmsDB.selectOne("QMS_QUALITYCONTROL.SCENARIO_R001",IdMap);			//시나리오 수
    				caseId=qmsDB.selectOne("QMS_QUALITYCONTROL.CIRCUMSTANCE_R001",IdMap);		//케이스 수
    				stepId=qmsDB.selectOne("QMS_QUALITYCONTROL.STEP_R001",IdMap);				//스텝 수
    				
    			result.get(i).put("SCENARIO_CNT",scenId.get("CNT"));
    			result.get(i).put("CASE_CNT",caseId.get("CNT"));
    			result.get(i).put("STEP_CNT",stepId.get("CNT"));
    			}
    		} catch (Exception e) {
    			if (qmsDB != null) try { qmsDB.close(); } catch (Exception e1) {}
    			
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
	request.setAttribute(SpbBiz.class.getName(), new test_list_do());
%>