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

public class  test_mng_delete_do implements SpbBiz {

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
		int flag 								= 0;
		Map<String,String> dataM				= (Map)tranReqMap.get("data");
    	
    	try{
    		qmsDB = new DBSessionManager();
    		
    		try {
    			
    			Map<String,String> param = new HashMap<String,String>();
    			
    			param.put("TEST_ID", 				dataM.get("TEST_ID"));
    			param.put("PROJECT_ID", 			userSession.getProjectID());
    			
    			flag = qmsDB.update("QMS_QUALITYCONTROL.TEST_MANAGEMENT_U002", param);
    			
    		} catch (Exception e) {
    			if (qmsDB != null) try { qmsDB.close(); } catch (Exception e1) {}
    			LogUtil.getInstance().info("query error : " + e.toString()); 
    		} 
    		
    			dataMap.put("rows",result);
    			
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
	request.setAttribute(SpbBiz.class.getName(), new test_mng_delete_do());
%>