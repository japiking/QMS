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
<%@ page language="java" contentType="text/html; charset=euc-kr"
	pageEncoding="euc-kr"%>
<%@ include file="/jsp/inc/inc_ActionHeader.jsp"%>

<%!public class test_regist_update_do implements SpbBiz {

		public boolean isNeedIDLogin() {
			// ID�α����� �ʿ� �����Ƿ� false����
			return true;
		}

		public Map execute(HttpSession session, HttpServletRequest request,Map trmap) throws Exception {
			String _tran_cd 					= (String) trmap.get("_tran_cd"); // ����ID
			Map tranReqMap 						= (Map) ((List) trmap.get("_tran_req_data")).get(0); // ���� ��û ������
			UserSession userSession 			= (UserSession) session.getAttribute(Const.QMS_SESSION_ID);
			Map tranResOutMap 					= new HashMap(); // ���信 ����� ��ü Map
			List resultList 					= new ArrayList(); // ���信 ����� Data�� ��� List
			DataMap dataMap 					= new DataMap();
			DBSessionManager qmsDB 				= null;
			List<Map<String, String>> result 	= null; //��ϸ���Ʈ �ޱ�						
			int flag 							= 0;
			Map<String, String> dataM 			= (Map) tranReqMap.get("data");
			Map<String,String> checkMap 		= null;
			
			try {
					qmsDB = new DBSessionManager();
					
				try {

					Map<String, String> param = new HashMap<String, String>();
					param.put("TEST_ID",		dataM.get("TEST_ID"));
					param.put("PROJECT_ID",		userSession.getProjectID());
					param.put("SCENARIO_ID",	dataM.get("SCENARIO_ID"));
					param.put("SCENARIO_NM",	dataM.get("SCENARIO_NM"));
					param.put("START_DATE",		dataM.get("START_DATE"));
					param.put("END_DATE",		dataM.get("END_DATE"));
					param.put("DEL_FLAG",		dataM.get("DEL_FLAG"));
					param.put("TESTER_ID",		userSession.getUserID());
					
					
					checkMap = qmsDB.selectOne("QMS_QUALITYCONTROL.SCENARIO_R002", param);
					
					String checkFlag = 	StringUtil.null2void(checkMap.get("DEL_FLAG"));
					String del_flag	 =  StringUtil.null2void(dataM.get("DEL_FLAG"));
					
					flag = qmsDB.update("QMS_QUALITYCONTROL.SCENARIO_U001",param);
					
					if(!checkFlag.equals(del_flag)){
						
						flag = qmsDB.update("QMS_QUALITYCONTROL.CASE_U001",param);
						flag = qmsDB.update("QMS_QUALITYCONTROL.STEP_U001",param);					//���� ���� update
						flag = qmsDB.update("QMS_QUALITYCONTROL.STEP_ACTION_D002",param);
						
					}
					
				} catch (Exception e) {
					if (qmsDB != null)
						try {
							qmsDB.rollback();
						} catch (Exception e1) {
						}
				}

				dataMap.put("RESULT", flag);

			} catch (Exception e) {
				e.printStackTrace(System.out);
				dataMap.put("ERROR_CODE", this.getClass().getName()
						+ "���� ������ �߻��Ͽ����ϴ�.");
				dataMap.put("RESPONSE_GUIDE_MESSAGE", e.getMessage());
				resultList.add(dataMap);
				if (qmsDB != null)
					try {
						qmsDB.rollback();
					} catch (Exception e1) {
					}
			} finally {
				if (qmsDB != null)
					try {
						qmsDB.close();
					} catch (Exception e1) {
					}
			}

			resultList.add(dataMap);
			tranResOutMap.put("_tran_cd", _tran_cd);
			tranResOutMap.put("_tran_res_data", resultList);
			return tranResOutMap;
		}
	}%>
<%
	request.setAttribute(SpbBiz.class.getName(),
			new test_regist_update_do());
%>