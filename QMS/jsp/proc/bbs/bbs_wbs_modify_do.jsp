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

public class bbs_wbs_modify_do implements SpbBiz {

    public boolean isNeedIDLogin() {
        return true;
    }
    
    public Map execute(HttpSession session, HttpServletRequest request, Map trmap) throws Exception{
    	String _tran_cd					= (String) trmap.get("_tran_cd");				 	// 서비스ID
        Map tranReqMap					= (Map)((List)trmap.get("_tran_req_data")).get(0);	// 전문 요청 개별부
        Map tranResOutMap	   			= new HashMap();                                 	// 응답에 사용할 전체 Map
        List resultList 				= new ArrayList();								 	// 응답에 사용할 Data를 담는 List
        DataMap dataMap					= new DataMap();
        UserSession userSession			= (UserSession) session.getAttribute(Const.QMS_SESSION_ID);
        String userId					= StringUtil.null2void(userSession.getUserID());	
    	String contents 				= StringUtil.null2void((String)tranReqMap.get("CONTENTS"));
    	
        DBSessionManager qmsDB = null;
    	int result = 0;
    	try{
    		qmsDB = new DBSessionManager();
    		try {
    			Map<String,String> paramC001 = new HashMap<String,String>();
    			paramC001.put("PROJECT_ID",	userSession.getProjectID());
    			paramC001.put("TASK_TITLE",	StringUtil.null2void((String)tranReqMap.get("TASK_TITLE")));
    			paramC001.put("TASK_DOCUMENT",	StringUtil.null2void((String)tranReqMap.get("TASK_DOCUMENT")));
    			paramC001.put("TASK_RNR",	StringUtil.null2void((String)tranReqMap.get("TASK_RNR")));
    			paramC001.put("PLAN_STTG_DATE",	StringUtil.null2void((String)tranReqMap.get("PLAN_STTG_DATE")));
    			paramC001.put("PLAN_ENDG_DATE",	StringUtil.null2void((String)tranReqMap.get("PLAN_ENDG_DATE")));
    			paramC001.put("PLAN_TERM",		StringUtil.null2void((String)tranReqMap.get("PLAN_TERM")));
    			paramC001.put("REAL_STTG_DATE",	StringUtil.null2void((String)tranReqMap.get("REAL_STTG_DATE")));
    			paramC001.put("REAL_ENDG_DATE",	StringUtil.null2void((String)tranReqMap.get("REAL_ENDG_DATE")));
    			paramC001.put("REAL_TERM",	StringUtil.null2void((String)tranReqMap.get("REAL_TERM")));
    			paramC001.put("SEQ",	StringUtil.null2void((String)tranReqMap.get("SEQ")));
    			result = qmsDB.update("QMS_BBS_LIST.WBS_U002", paramC001);
    		} catch (Exception e) {
    			if (qmsDB != null) try { qmsDB.close(); } catch (Exception e1) {}
    		} 
    		dataMap.put("RESULT", "Y");
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
	request.setAttribute(SpbBiz.class.getName(), new bbs_wbs_modify_do());
%>