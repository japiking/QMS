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

public class bbs_Q00101_do implements SpbBiz {

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
    		String prj_id = indata.getstr("PROJECT_ID");						//프로젝트ID
    		String prj_nm = indata.getstr("PROJECT_NAME");						//프로젝트NM
    		String prj_pm = indata.getstr("PROJECT_MANAGER");						//프로젝트NM
    		
    		// 사용자정보 세션생성
    		UserSession user	= (UserSession) session.getAttribute(Const.QMS_SESSION_ID);
    		
    		// 프로젝트 사용자 등급 조회
    		Map<String,String> param = new HashMap<String,String>();
    		param.put("PROJECT_ID", prj_id);
    		param.put("USERID", 	user.getUserID());
    		Map<String,String> temp = qmsDB.selectOne("QMS_LOGIN.PROJECTUSERINFO_R001", param);
    		
    		// 메뉴정보 로드
			List<Map<String,String>> menu_info = qmsDB.selectList("QMS_LOGIN.MENU_R001", param);
			session.setAttribute(Const.QMS_SESSION_MENU, menu_info);		// 세션에 메뉴정보를 넣는다.
    		
    		// 프로젝트 유저 사용자정보 세션 생성
    		UserSession prjUserSession	= new UserSession();
    		prjUserSession.setUserId(user.getUserID());
    		prjUserSession.setUserName(user.getUserName());
    		prjUserSession.setManagementGrade(user.getManagementGrade());
    		prjUserSession.setUserIp(user.getUserIp());
    		prjUserSession.setProjectID(prj_id);												// 프로젝트ID
    		prjUserSession.setProjectName(prj_nm);												// PM 이름
    		prjUserSession.setProjectManagerID(prj_pm);											// PM 아이디
    		prjUserSession.setAuthorityGrade(StringUtil.null2void(temp.get("AUTHORITYGRADE")));	// 프로젝트 사용자 등급
    		session.setAttribute(Const.QMS_SESSION_ID, prjUserSession);

		} catch(Exception e) {
			e.printStackTrace(System.out);
			dataMap.put("ERROR_CODE", this.getClass().getName()+"에서 에러가 발생하였습니다.");
// 			dataMap.put("ERROR_CODE", "ERROR");
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
	request.setAttribute(SpbBiz.class.getName(), new bbs_Q00101_do());
%>