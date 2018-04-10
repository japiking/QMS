<%--
/******************************************************************************
* @ �� �� �� : login_do.jsp
* @ �������� : login_do.jsp
* @ �� �� �� : /jsp/proc/bbs/lgn_login_do.jsp
* @ �� �� �� : webCash
* @ �� �� �� : 2015-01-26
************************** �� �� �� �� ****************************************
* ��ȣ  �� �� ��    ��  ��  ��                       ���泻��
*******************************************************************************
*  1  webCash	2015-01-26      ���� �ۼ�
******************************************************************************/
--%>
<%@ page language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%@ include file="/jsp/inc/inc_ActionHeader.jsp" %>

<%!

public class lgn_login_do implements SpbBiz {

    public boolean isNeedIDLogin() {
		// ID�α����� �ʿ� �����Ƿ� false����
        return false;
    }
    
    public Map execute(HttpSession session, HttpServletRequest request, Map trmap) throws Exception{
    	String _tran_cd		= (String) trmap.get("_tran_cd");				 	// ����ID
        Map tranReqMap		= (Map)((List)trmap.get("_tran_req_data")).get(0);	// ���� ��û ������
        Map tranResOutMap   = new HashMap();                                 	// ���信 ����� ��ü Map
        List resultList 	= new ArrayList();								 	// ���信 ����� Data�� ��� List
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
    		
    		// ȸ������ ȭ������ �̵�
    		if( userList.size() == 0 ) {
    			throw new Exception("��ϵ� ����ڰ� �ƴϰų�, �н����尡 ��ġ ���� �ʽ��ϴ�.");
    		}
    		
    		Map<String,String> userMap			= userList.get(0);
    		String requestIp					= StringUtil.null2void(request.getRemoteAddr());
    		String Ip							= userMap.get("USERIP");
    		/* 
    		if( requestIp != null) {
    			if( !"".equals(Ip) && !"".equals(requestIp) && !requestIp.equals(Ip) ) {
    				throw new Exception("��ϵ��� ���� PC���� �����ϼ̽��ϴ�. [����IP : " + Ip + "]");
    			}
    		}
    		 */
    		 
    		// ������Ʈ ������ȸ ����
    		List<Map<String,String>> prjrList	= qmsDB.selectList("QMS_LOGIN.PROJECTINFO_R001", param);
    		
    		// �⼮���� ��ȸ
    		Map<String,String> temp = qmsDB.selectOne("QMS_LOGIN.ATTENTIONMANAGER_R001", param);
    		
   			String qry_nm = "";
   			Map<String,String> param2 = new HashMap<String,String>();
   			param2.put("USER_ID", 	userId);
   			param2.put("LGN_TIME", 	DateTime.getInstance().getDate("hh24:mi:ss"));
    		if("0".equals(temp.get("CNT"))){
    			// ���� �α���
        		int updateCnt	= qmsDB.update("QMS_LOGIN.ATTENTIONMANAGER_C001", param2);
    		} else {
    			// ���� �α���
    			int updateCnt	= qmsDB.update("QMS_LOGIN.ATTENTIONMANAGER_U001", param2);
    		}
    		
    		
    		// ��������� ���ǻ���
    		UserSession userSession	= (UserSession) session.getAttribute(Const.QMS_SESSION_ID);
    		userSession	= new UserSession();
    		userSession.setUserId(StringUtil.null2void(userMap.get("USERID")).trim());
    		userSession.setUserName(StringUtil.null2void(userMap.get("USERNAME")).trim());
    		userSession.setManagementGrade(StringUtil.null2void(userMap.get("MANAGEMENTGRADE")).trim());
    		userSession.setUserIp(StringUtil.null2void(userMap.get("USERIP")).trim());
			
    		System.out.println("LSJ----------------userID>>"+userSession.getUserID());
    		
    		if(prjrList.size() == 1){
    			// ���Ե� ������Ʈ�� �ϳ��� ���
    			Map<String,String> map = prjrList.get(0);
    			userSession.setProjectID(StringUtil.null2void(map.get("PROJECTID")).trim());
    			userSession.setProjectName(StringUtil.null2void(map.get("PROJECTNAME")).trim());
    			userSession.setProjectManagerID(StringUtil.null2void(map.get("PROJECTMANAGERID")).trim());
    			userSession.setAuthorityGrade(StringUtil.null2void(map.get("AUTHORITYGRADE")).trim());
    			
        		// �޴����� �ε�
    			param.put("PROJECT_ID", 	StringUtil.null2void(map.get("PROJECTID")).trim());
    			List<Map<String,String>> menu_info = qmsDB.selectList("QMS_LOGIN.MENU_R001", param);
    			session.setAttribute(Const.QMS_SESSION_MENU, menu_info);		// �޴������� ���ǿ� �����Ѵ�.
    			
    			dataMap.put("PAGE_GBN", 	"S");	// ������Ʈ ������������ �̵�
    		} else {
    			dataMap.put("PAGE_GBN", 	"M");	// ������Ʈ ������������ �̵�    			
    		}
    		
    		if("0".equals(userMap.get("MANAGEMENTGRADE"))){
    			dataMap.put("PAGE_GBN", 	"P");	// ������Ʈ ���������� �̵�
    		}
    		
    		session.setAttribute(Const.QMS_SESSION_ID, userSession);

		} catch(Exception e) {
			e.printStackTrace(System.out);
			dataMap.put("ERROR_CODE", this.getClass().getName()+"���� ������ �߻��Ͽ����ϴ�.");
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