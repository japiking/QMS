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

public class bbs_onerow_do implements SpbBiz {

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
    		UserSession userSession	= (UserSession) session.getAttribute(Const.QMS_SESSION_ID);
    		
    		String userId	= indata.getstr("USER_ID");

    		Map<String,String> param = new HashMap<String,String>();
    		Map<String,String> map	 = null;
    		param.put("USERID", 		userId);
    		param.put("PROJECTID", 		userSession.getProjectID());
    		
    		
    		List<Map<String,String>> userList	= qmsDB.selectList("QMS_BBS_ONELOW.USERINFO_R002", param);
    		
    		if(userList.size() == 0){
    			throw new Exception("�˻������� �������� �ʽ��ϴ�.");
    		}
    		
    		dataMap.put("list", userList);
    		
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
	request.setAttribute(SpbBiz.class.getName(), new bbs_onerow_do());
%>