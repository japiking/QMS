<%--
/******************************************************************************
* @ 업 무 명 : login_do.jsp
* @ 업무설명 : login_do.jsp
* @ 파 일 명 : /jsp/proc/bbs/lgn_login_do.jsp
* @ 작 성 자 : webCash
* @ 작 성 일 : 2015-01-26
************************** 변 경 이 력 ****************************************
* 번호  작 업 자    작  업  일                       변경내용
*******************************************************************************
*  1  webCash	2015-01-26      최초 작성
******************************************************************************/
--%>
<%@ page language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%@ include file="/jsp/inc/inc_ActionHeader.jsp" %>

<%!

public class bbs_onerow_do implements SpbBiz {

    public boolean isNeedIDLogin() {
		// ID로그인이 필요 없으므로 false리턴
        return false;
    }
    
    public Map execute(HttpSession session, HttpServletRequest request, Map trmap) throws Exception{
    	String _tran_cd		= (String) trmap.get("_tran_cd");				 	// 서비스ID
        Map tranReqMap		= (Map)((List)trmap.get("_tran_req_data")).get(0);	// 전문 요청 개별부
        Map tranResOutMap   = new HashMap();                                 	// 응답에 사용할 전체 Map
        List resultList 	= new ArrayList();								 	// 응답에 사용할 Data를 담는 List
        DataMap dataMap		= new DataMap();
        DataMap indata		= new DataMap();
        DBSessionManager qmsDB = null;
    	try{
    		qmsDB = new DBSessionManager();
    		BizUtil.putAllDataMap(indata, tranReqMap);
    		UserSession userSession	= (UserSession) session.getAttribute(Const.QMS_SESSION_ID);
    		
    		String userId	= indata.getstr("USER_ID");

    		Map<String,String> param = new HashMap<String,String>();
    		Map<String,String> map	 = null;
    		param.put("USERID", 		userId);
    		param.put("PROJECTID", 		userSession.getProjectID());
    		
    		
    		List<Map<String,String>> userList	= qmsDB.selectList("QMS_BBS_ONELOW.USERINFO_R002", param);
    		
    		if(userList.size() == 0){
    			throw new Exception("검색내용이 존재하지 않습니다.");
    		}
    		
    		dataMap.put("list", userList);
    		
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
	request.setAttribute(SpbBiz.class.getName(), new bbs_onerow_do());
%>