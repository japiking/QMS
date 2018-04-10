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
<%@ page language="java" contentType="text/html; charset=euc-kr"
	pageEncoding="euc-kr"%>
<%@ include file="/jsp/inc/inc_ActionHeader.jsp"%>

<%!public class qcl_execut_stat_update_do implements SpbBiz {

		public boolean isNeedIDLogin() {
			// ID로그인이 필요 없으므로 false리턴
			return true;
		}

		public Map execute(HttpSession session, HttpServletRequest request,Map trmap) throws Exception {
			String _tran_cd							= (String) trmap.get("_tran_cd");				 	// 서비스ID
	        Map tranReqMap							= (Map)((List)trmap.get("_tran_req_data")).get(0);	// 전문 요청 개별부
	        UserSession userSession					= (UserSession) session.getAttribute(Const.QMS_SESSION_ID);
	        Map tranResOutMap   					= new HashMap();                                 	// 응답에 사용할 전체 Map
	        List resultList 						= new ArrayList();								 	// 응답에 사용할 Data를 담는 List
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
				//상태level에 대한 상태값
		    	if("2".equals(statusLevel)){
		    		stepStatus	=	"실행중";
		    	}else if("3".equals(statusLevel)){
		    		stepStatus	=	"실패";
		    	} else if("4".equals(statusLevel)){
		    		stepStatus	=	"성공";
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
				dataMap.put("ERROR_CODE", this.getClass().getName()+ "에서 에러가 발생하였습니다.");
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