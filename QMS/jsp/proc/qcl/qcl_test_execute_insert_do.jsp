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

public class test_execute_insert_do implements SpbBiz {

    public boolean isNeedIDLogin() {
		// ID로그인이 필요 없으므로 false리턴
        return true;
    }
    
    public Map execute(HttpSession session, HttpServletRequest request, Map trmap) throws Exception{
    	String _tran_cd								= (String) trmap.get("_tran_cd");				 			// 서비스ID
        Map tranReqMap								= (Map)((List)trmap.get("_tran_req_data")).get(0);			// 전문 요청 개별부
        UserSession userSession						= (UserSession) session.getAttribute(Const.QMS_SESSION_ID);
        Map tranResOutMap   						= new HashMap();                                 			// 응답에 사용할 전체 Map
        List resultList 							= new ArrayList();								 			// 응답에 사용할 Data를 담는 List
        DataMap dataMap								= new DataMap();
        DBSessionManager qmsDB 						= null;
    	List<Map<String,String>> result				= null;														//목록리스트 받기						
		int flag 									= 0;
    	ArrayList<Map<String,String>> scDataList	= (ArrayList)tranReqMap.get("SCDATA_LIST");
    	ArrayList<Map<String,String>> caDataList	= (ArrayList)tranReqMap.get("CADATA_LIST");
    	
    	try{
    		qmsDB = new DBSessionManager();
    		
    		try {
    			
    			Map<String,String> param1 = new HashMap<String,String>();
    			Map<String,String> getData = new HashMap<String,String>();
    			//시나리오
    			if(null!=scDataList && 0<scDataList.size()){
					for(int i = 0; i<scDataList.size(); i++){
						getData = scDataList.get(i);	
						param1.put("PROJECT_ID"		,userSession.getProjectID()						);
						param1.put("TESTER_ID"		,userSession.getUserID()						);
						param1.put("SCENARIO_ID"	,getData.get("SCENARIO_ID")						);
						param1.put("TEST_ID"		,getData.get("TEST_ID")							);
						List<Map<String,String>> insertList = qmsDB.selectList("QMS_QC_MANAGEMENT_LIST.STEP_R001",param1);
						Map<String,String> insertMap 		= new HashMap<String,String>();
						Map<String,String> param2 			= new HashMap<String,String>();	
					
					
						for(int j = 0; j<insertList.size(); j++){
							
							Map<String,String> map 	= qmsDB.selectOne("QMS_QC_MANAGEMENT_LIST.ACTION_SEQ_R001");
							
							String seq				= StringUtil.null2void(map.get("ACTION_SEQ")).trim();
							String actionId			= "ACT_"+ BizUtil.getPadString(seq, 10, "0");
							
							insertMap = insertList.get(j);
							
							param2.put("ACTION_ID"	,	actionId									);
							param2.put("PROJECT_ID"	,	userSession.getProjectID()					);
							param2.put("TEST_ID"	, 	insertMap.get("TEST_ID")					);
							param2.put("SCENARIO_ID", 	insertMap.get("SCENARIO_ID")				);
							param2.put("CASE_ID"	, 	insertMap.get("CASE_ID")					);
							param2.put("STEP_ID"	, 	insertMap.get("STEP_ID")					);
							param2.put("ACTION_SEQ"	, 	seq											);
							param2.put("TESTER_ID"	,	userSession.getUserID()						);
							param2.put("START_DATE"	, 	DateTime.getInstance().getDate("yyyy-mm-dd hh:mm:ss"));
							
							flag = qmsDB.insert("QMS_QC_MANAGEMENT_LIST.STEP_ACTION_C001",param2);
						}//end for
					
					}//end for
    			}//end if
				
				//케이스
    			if(null!=caDataList && 0<caDataList.size()){
					for(int i = 0; i<caDataList.size(); i++){
						getData = caDataList.get(i);	
						param1.put("PROJECT_ID"		,userSession.getProjectID()						);
						param1.put("TESTER_ID"		,userSession.getUserID()						);
						param1.put("SCENARIO_ID"	,getData.get("SCENARIO_ID")						);
						param1.put("TEST_ID"		,getData.get("TEST_ID")							);
						param1.put("CASE_ID"		,getData.get("CASE_ID")							);
						List<Map<String,String>> insertList = qmsDB.selectList("QMS_QC_MANAGEMENT_LIST.STEP_R002",param1);
						Map<String,String> insertMap = new HashMap<String,String>();
						Map<String,String> param2 = new HashMap<String,String>();	
					
					
						for(int j = 0; j<insertList.size(); j++){
							
							Map<String,String> map = qmsDB.selectOne("QMS_QC_MANAGEMENT_LIST.ACTION_SEQ_R001");
							
							String seq	= StringUtil.null2void(map.get("ACTION_SEQ")).trim();
							String actionId	= "ACT_"+ BizUtil.getPadString(seq, 10, "0");
							
							insertMap = insertList.get(j);
							
							param2.put("ACTION_ID"	,	actionId									);
							param2.put("PROJECT_ID"	,	userSession.getProjectID()					);
							param2.put("TEST_ID"	, 	insertMap.get("TEST_ID")					);
							param2.put("SCENARIO_ID", 	insertMap.get("SCENARIO_ID")				);
							param2.put("CASE_ID"	, 	insertMap.get("CASE_ID")					);
							param2.put("STEP_ID"	, 	insertMap.get("STEP_ID")					);
							param2.put("ACTION_SEQ"	, 	seq											);
							param2.put("TESTER_ID"	,	userSession.getUserID()						);
							param2.put("START_DATE"	, 	DateTime.getInstance().getDate("yyyy-mm-dd hh:mm:ss"));
							
							flag = qmsDB.insert("QMS_QC_MANAGEMENT_LIST.STEP_ACTION_C001",param2);
						}//end for
					
					}//end for
    			}
    		} catch (Exception e) {
    			if (qmsDB != null) try { qmsDB.rollback(); } catch (Exception e1) {}
    			LogUtil.getInstance().info("query error : " + e.toString()); 
    		} 

    		dataMap.put("result",flag);
    		
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
	request.setAttribute(SpbBiz.class.getName(), new test_execute_insert_do());
%>