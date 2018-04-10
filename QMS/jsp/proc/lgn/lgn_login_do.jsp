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

public class lgn_login_do implements SpbBiz {

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
    		
    		String userId	= indata.getstr("USER_ID");
    		String userPw	= indata.getstr("USER_PASSWORD");

    		Map<String,String> param = new HashMap<String,String>();
    		param.put("USER_ID", 		userId);
    		param.put("USERID", 		userId);
    		param.put("USER_PASSWORD", 	userPw);
    		
    		List<Map<String,String>> userList	= qmsDB.selectList("QMS_LOGIN.USERINFO_R001", param);
    		
    		// 회원가입 화면으로 이동
    		if( userList.size() == 0 ) {
    			throw new Exception("등록된 사용자가 아니거나, 패스워드가 일치 하지 않습니다.");
    		}
    		
    		Map<String,String> userMap			= userList.get(0);
    		String requestIp					= StringUtil.null2void(request.getRemoteAddr());
    		String Ip							= userMap.get("USERIP");
    		/* 
    		if( requestIp != null) {
    			if( !"".equals(Ip) && !"".equals(requestIp) && !requestIp.equals(Ip) ) {
    				throw new Exception("등록되지 않은 PC에서 접속하셨습니다. [허용된IP : " + Ip + "]");
    			}
    		}
    		 */
    		 
    		// 프로젝트 정보조회 쿼리
    		List<Map<String,String>> prjrList	= qmsDB.selectList("QMS_LOGIN.PROJECTINFO_R001", param);
    		
    		// 출석정보 조회
    		Map<String,String> temp = qmsDB.selectOne("QMS_LOGIN.ATTENTIONMANAGER_R001", param);
    		
   			String qry_nm = "";
   			Map<String,String> param2 = new HashMap<String,String>();
   			param2.put("USER_ID", 	userId);
   			param2.put("LGN_TIME", 	DateTime.getInstance().getDate("hh24:mi:ss"));
    		if("0".equals(temp.get("CNT"))){
    			// 최초 로그인
        		int updateCnt	= qmsDB.update("QMS_LOGIN.ATTENTIONMANAGER_C001", param2);
    		} else {
    			// 최종 로그인
    			int updateCnt	= qmsDB.update("QMS_LOGIN.ATTENTIONMANAGER_U001", param2);
    		}
    		
    		
    		// 사용자정보 세션생성
    		UserSession userSession	= (UserSession) session.getAttribute(Const.QMS_SESSION_ID);
    		userSession	= new UserSession();
    		userSession.setUserId(StringUtil.null2void(userMap.get("USERID")).trim());
    		userSession.setUserName(StringUtil.null2void(userMap.get("USERNAME")).trim());
    		userSession.setManagementGrade(StringUtil.null2void(userMap.get("MANAGEMENTGRADE")).trim());
    		userSession.setUserIp(StringUtil.null2void(userMap.get("USERIP")).trim());
			
    		System.out.println("LSJ----------------userID>>"+userSession.getUserID());
    		
    		if(prjrList.size() == 1){
    			// 가입된 프로젝트가 하나일 경우
    			Map<String,String> map = prjrList.get(0);
    			userSession.setProjectID(StringUtil.null2void(map.get("PROJECTID")).trim());
    			userSession.setProjectName(StringUtil.null2void(map.get("PROJECTNAME")).trim());
    			userSession.setProjectManagerID(StringUtil.null2void(map.get("PROJECTMANAGERID")).trim());
    			userSession.setAuthorityGrade(StringUtil.null2void(map.get("AUTHORITYGRADE")).trim());
    			
        		// 메뉴정보 로드
    			param.put("PROJECT_ID", 	StringUtil.null2void(map.get("PROJECTID")).trim());
    			List<Map<String,String>> menu_info = qmsDB.selectList("QMS_LOGIN.MENU_R001", param);
    			session.setAttribute(Const.QMS_SESSION_MENU, menu_info);		// 메뉴정보를 세션에 저장한다.
    			
    			dataMap.put("PAGE_GBN", 	"S");	// 프로젝트 메인페이지로 이동
    		} else {
    			dataMap.put("PAGE_GBN", 	"M");	// 프로젝트 선택페이지로 이동    			
    		}
    		
    		if("0".equals(userMap.get("MANAGEMENTGRADE"))){
    			dataMap.put("PAGE_GBN", 	"P");	// 프로젝트 관리페이지 이동
    		}
    		
    		session.setAttribute(Const.QMS_SESSION_ID, userSession);

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
	request.setAttribute(SpbBiz.class.getName(), new lgn_login_do());
%>