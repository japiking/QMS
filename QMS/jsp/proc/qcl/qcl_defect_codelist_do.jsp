<%--
/******************************************************************************
* @ 업 무 명 : Q00101_do.jsp
* @ 업무설명 : Q00101_do.jsp
* @ 파 일 명 : /jsp/proc/bbs/bbs_Q00101_do.jsp
* @ 작 성 자 : webCash
* @ 작 성 일 : 2015-01-23
************************** 변 경 이 력 ****************************************
* 번호  작 업 자    작  업  일                       변경내용
*******************************************************************************
*  1  webCash	2015-01-23      최초 작성
******************************************************************************/
--%>
<%@ page language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%@ include file="/jsp/inc/inc_ActionHeader.jsp" %>

<%!

public class defect_delete_do implements SpbBiz {

    public boolean isNeedIDLogin() {
		// ID로그인이 필요 없으므로 false리턴
        return true;
    }
    
    public Map execute(HttpSession session, HttpServletRequest request, Map trmap) throws Exception{
    	String _tran_cd							= (String) trmap.get("_tran_cd");				 			// 서비스ID
        Map tranReqMap							= (Map)((List)trmap.get("_tran_req_data")).get(0);			// 전문 요청 개별부
        UserSession userSession					= (UserSession) session.getAttribute(Const.QMS_SESSION_ID);
        Map tranResOutMap   					= new HashMap();                                 			// 응답에 사용할 전체 Map
        List resultList 						= new ArrayList();								 			// 응답에 사용할 Data를 담는 List
        DataMap dataMap							= new DataMap();
        DBSessionManager qmsDB 					= null;
    	List<Map<String,String>> result			= null;														//목록리스트 받기						
		int flag = 0;
		String code								= StringUtil.null2void(tranReqMap.get("CODE"));				//코드type
		String testId							= StringUtil.null2void(tranReqMap.get("TEST_ID"));			//코드type
		String scenarioId						= StringUtil.null2void(tranReqMap.get("SCENARIO_ID"));		//코드type
		String caseId							= StringUtil.null2void(tranReqMap.get("CASE_ID"));			//코드type
		
    	
    	try{
    		qmsDB = new DBSessionManager();
    		
    		try {
    			
    			Map<String,String> param = new HashMap<String,String>();
				param.put("PROJECT_ID",userSession.getProjectID());
				param.put("TESTER_ID",userSession.getUserID());
    			
    			if("1".equals(code)){						//test_id
    				result = qmsDB.selectList("QMS_CODELIST.STEP_ACTION_R001", param);		//test리스트
    			}else if("2".equals(code)){					//scenario_id
    				if(!"".equals(testId)){
    					param.put("TEST_ID",testId);
    				}
    				result = qmsDB.selectList("QMS_CODELIST.STEP_ACTION_R002", param);		//시나리오리스트
    			}else if("3".equals(code)){					//case_id
    				if(!"".equals(testId)){
	    				param.put("TEST_ID",testId);
	    				param.put("SCENARIO_ID",scenarioId);
    				}
    				result = qmsDB.selectList("QMS_CODELIST.STEP_ACTION_R003", param);		//케이스리스트
    			}else if("4".equals(code)){					//step_id
    				if(!"".equals(testId)){
	    				param.put("TEST_ID",testId);
	    				param.put("SCENARIO_ID",scenarioId);
	    				param.put("CASE_ID",caseId);
    				}
    				result = qmsDB.selectList("QMS_CODELIST.STEP_ACTION_R004", param);		//step리스트
    			}else if("5".equals(code)){					//status
    				result = qmsDB.selectList("QMS_CODELIST.DEFECT_STATUS_R001", param);
    			}else if("6".equals(code)){					//developer_id
    				result = qmsDB.selectList("QMS_CODELIST.PROJECTUSERINFO_R001", param);
    			}
    			
    		} catch (Exception e) {
    			if (qmsDB != null) try { qmsDB.close(); } catch (Exception e1) {}
    			LogUtil.getInstance().info("query error : " + e.toString()); 
    		} 
    		
    		String StringResult="";
    		Map<String,String> resultMap = null;
    		
    		for(int i = 0; i<result.size(); i++){
    			resultMap = result.get(i);
    			if("5".equals(code)){
        			StringResult+=resultMap.get("ID")+":"+resultMap.get("NM");
    			}else{
    				
    				StringResult+=resultMap.get("ID")+":"+resultMap.get("NM");
    			}
    			
    			if(i<(result.size()-1)){
    				StringResult +=";";
    			}
    			
    		}
    		
    		dataMap.put("result",StringResult);
    		dataMap.put("result2",result);
		} catch(Exception e) {
			e.printStackTrace(System.out);
			dataMap.put("ERROR_CODE", this.getClass().getName()+"에서 에러가 발생하였습니다.");
			dataMap.put("RESPONSE_GUIDE_MESSAGE", e.getMessage());
			resultList.add(result);
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
	request.setAttribute(SpbBiz.class.getName(), new defect_delete_do());
%>