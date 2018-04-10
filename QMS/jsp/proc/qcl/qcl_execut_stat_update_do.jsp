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

<%!public class qcl_execut_stat_update_do implements SpbBiz {

		public boolean isNeedIDLogin() {
			// ID�α����� �ʿ� �����Ƿ� false����
			return true;
		}

		public Map execute(HttpSession session, HttpServletRequest request,Map trmap) throws Exception {
			String _tran_cd							= (String) trmap.get("_tran_cd");				 	// ����ID
	        Map tranReqMap							= (Map)((List)trmap.get("_tran_req_data")).get(0);	// ���� ��û ������
	        UserSession userSession					= (UserSession) session.getAttribute(Const.QMS_SESSION_ID);
	        Map tranResOutMap   					= new HashMap();                                 	// ���信 ����� ��ü Map
	        List resultList 						= new ArrayList();								 	// ���信 ����� Data�� ��� List
	        DataMap dataMap							= new DataMap();
	        DBSessionManager qmsDB 					= null;
	    	List<Map<String,String>> result			= null;
	    	String endDate 							= DateTime.getInstance().getDate("yyyy-MM-dd hh:mm:ss");
	    	Map<String,String> rowData				= (Map)tranReqMap.get("data");
	    	String testId							= StringUtil.null2void((String)rowData.get("TEST_ID"));
	    	String scenarioId						= StringUtil.null2void((String)rowData.get("SCENARIO_ID"));
	    	String caseId							= StringUtil.null2void((String)rowData.get("CASE_ID"));
	    	String stepId							= StringUtil.null2void((String)rowData.get("STEP_ID"));
	    	String actionSeq							= StringUtil.null2void((String)rowData.get("ACTION_SEQ"));
	    	String statusLevel						= StringUtil.null2void((String)tranReqMap.get("STATUS_LEVEL")).trim();
	    	String stepStatus						="";
			int	flag								=0;
			try {
				//����level�� ���� ���°�
		    	if("2".equals(statusLevel)){
		    		stepStatus	=	"������";
		    	}else if("3".equals(statusLevel)){
		    		stepStatus	=	"����";
		    	} else if("4".equals(statusLevel)){
		    		stepStatus	=	"����";
		    	}
		    	
				qmsDB = new DBSessionManager();

				try {

					Map<String, String> param = new HashMap<String, String>();
					param.put("PROJECT_ID",userSession.getProjectID());
					param.put("TESTER_ID",userSession.getUserID());
					param.put("TEST_ID",testId);
					param.put("SCENARIO_ID",scenarioId);
					param.put("CASE_ID",caseId);
					param.put("STEP_ID",stepId);
					param.put("ACTION_SEQ",actionSeq);
					param.put("STATUS_LEVEL",statusLevel);
					param.put("STEP_STATUS",stepStatus);
					param.put("END_DATE",endDate);
					
					flag = qmsDB.update("QMS_QUALITYCONTROL.STEP_ACTION_U001", param);
					
				} catch (Exception e) {
					if (qmsDB != null)
						try {
							qmsDB.close();
						} catch (Exception e1) {
						}
				}
				dataMap.put("RESULT", flag);
			} catch (Exception e) {
				e.printStackTrace(System.out);
				dataMap.put("ERROR_CODE", this.getClass().getName()+ "���� ������ �߻��Ͽ����ϴ�.");
				dataMap.put("RESPONSE_GUIDE_MESSAGE", e.getMessage());
				resultList.add(dataMap);
				if (qmsDB != null) try {qmsDB.rollback();} catch (Exception e1) {}
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
	request.setAttribute(SpbBiz.class.getName(),new qcl_execut_stat_update_do());
%>