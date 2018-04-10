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

public class bbs_Q00101_do implements SpbBiz {

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
    		String prj_id = indata.getstr("PROJECT_ID");						//������ƮID
    		String prj_nm = indata.getstr("PROJECT_NAME");						//������ƮNM
    		String prj_pm = indata.getstr("PROJECT_MANAGER");						//������ƮNM
    		
    		// ��������� ���ǻ���
    		UserSession user	= (UserSession) session.getAttribute(Const.QMS_SESSION_ID);
    		
    		// ������Ʈ ����� ��� ��ȸ
    		Map<String,String> param = new HashMap<String,String>();
    		param.put("PROJECT_ID", prj_id);
    		param.put("USERID", 	user.getUserID());
    		Map<String,String> temp = qmsDB.selectOne("QMS_LOGIN.PROJECTUSERINFO_R001", param);
    		
    		// �޴����� �ε�
			List<Map<String,String>> menu_info = qmsDB.selectList("QMS_LOGIN.MENU_R001", param);
			session.setAttribute(Const.QMS_SESSION_MENU, menu_info);		// ���ǿ� �޴������� �ִ´�.
    		
    		// ������Ʈ ���� ��������� ���� ����
    		UserSession prjUserSession	= new UserSession();
    		prjUserSession.setUserId(user.getUserID());
    		prjUserSession.setUserName(user.getUserName());
    		prjUserSession.setManagementGrade(user.getManagementGrade());
    		prjUserSession.setUserIp(user.getUserIp());
    		prjUserSession.setProjectID(prj_id);												// ������ƮID
    		prjUserSession.setProjectName(prj_nm);												// PM �̸�
    		prjUserSession.setProjectManagerID(prj_pm);											// PM ���̵�
    		prjUserSession.setAuthorityGrade(StringUtil.null2void(temp.get("AUTHORITYGRADE")));	// ������Ʈ ����� ���
    		session.setAttribute(Const.QMS_SESSION_ID, prjUserSession);

		} catch(Exception e) {
			e.printStackTrace(System.out);
			dataMap.put("ERROR_CODE", this.getClass().getName()+"���� ������ �߻��Ͽ����ϴ�.");
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