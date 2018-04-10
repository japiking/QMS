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

public class defect_delete_do implements SpbBiz {

    public boolean isNeedIDLogin() {
		// ID�α����� �ʿ� �����Ƿ� false����
        return true;
    }
    
    public Map execute(HttpSession session, HttpServletRequest request, Map trmap) throws Exception{
    	String _tran_cd							= (String) trmap.get("_tran_cd");				 			// ����ID
        Map tranReqMap							= (Map)((List)trmap.get("_tran_req_data")).get(0);			// ���� ��û ������
        UserSession userSession					= (UserSession) session.getAttribute(Const.QMS_SESSION_ID);
        Map tranResOutMap   					= new HashMap();                                 			// ���信 ����� ��ü Map
        List resultList 						= new ArrayList();								 			// ���信 ����� Data�� ��� List
        DataMap dataMap							= new DataMap();
        DBSessionManager qmsDB 					= null;
    	List<Map<String,String>> result			= null;														//��ϸ���Ʈ �ޱ�						
		int flag = 0;
		String code								= StringUtil.null2void(tranReqMap.get("CODE"));				//�ڵ�type
		String testId							= StringUtil.null2void(tranReqMap.get("TEST_ID"));			//�ڵ�type
		String scenarioId						= StringUtil.null2void(tranReqMap.get("SCENARIO_ID"));		//�ڵ�type
		String caseId							= StringUtil.null2void(tranReqMap.get("CASE_ID"));			//�ڵ�type
		
    	
    	try{
    		qmsDB = new DBSessionManager();
    		
    		try {
    			
    			Map<String,String> param = new HashMap<String,String>();
				param.put("PROJECT_ID",userSession.getProjectID());
				param.put("TESTER_ID",userSession.getUserID());
    			
    			if("1".equals(code)){						//test_id
    				result = qmsDB.selectList("QMS_CODELIST.STEP_ACTION_R001", param);		//test����Ʈ
    			}else if("2".equals(code)){					//scenario_id
    				if(!"".equals(testId)){
    					param.put("TEST_ID",testId);
    				}
    				result = qmsDB.selectList("QMS_CODELIST.STEP_ACTION_R002", param);		//�ó���������Ʈ
    			}else if("3".equals(code)){					//case_id
    				if(!"".equals(testId)){
	    				param.put("TEST_ID",testId);
	    				param.put("SCENARIO_ID",scenarioId);
    				}
    				result = qmsDB.selectList("QMS_CODELIST.STEP_ACTION_R003", param);		//���̽�����Ʈ
    			}else if("4".equals(code)){					//step_id
    				if(!"".equals(testId)){
	    				param.put("TEST_ID",testId);
	    				param.put("SCENARIO_ID",scenarioId);
	    				param.put("CASE_ID",caseId);
    				}
    				result = qmsDB.selectList("QMS_CODELIST.STEP_ACTION_R004", param);		//step����Ʈ
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
			dataMap.put("ERROR_CODE", this.getClass().getName()+"���� ������ �߻��Ͽ����ϴ�.");
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