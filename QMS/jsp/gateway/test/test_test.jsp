<%--
/******************************************************************************
* @ 업 무 명 : test
* @ 업무설명 : test
* @ 파 일 명 : /gateway/test/test_test.jsp
* @ 작 성 자 : webCash
* @ 작 성 일 : 2015-01-20
************************** 변 경 이 력 ****************************************
* 번호  작 업 자    작  업  일                       변경내용
*******************************************************************************
*  1  webCash	2015-01-20      최초 작성
******************************************************************************/
--%>
<%@ page language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%@ include file="/jsp/inc/inc_ActionHeader.jsp" %>

<%!

public class test_test implements SpbBiz {

    public boolean isNeedIDLogin() {
		// ID로그인이 필요 없으므로 false리턴
        return false;
    }
    
    public boolean isNeedCertLogin() {
        // 인증서 로그인이 필요 없으므로 false리턴
        return false;
    }

	public String ENC(String str) {
		return str;
	}

    public Map execute(HttpSession session, HttpServletRequest request, Map trmap) throws Exception{
    	String _tran_cd		= (String) trmap.get("_tran_cd");				 	// 서비스ID
        Map tranReqMap		= (Map)((List)trmap.get("_tran_req_data")).get(0);	// 전문 요청 개별부
        Map result       	= new HashMap();                                 	// 응답에 사용할 전체 Map
        Map tranResOutMap   = new HashMap();                                 	// 응답에 사용할 전체 Map
        List resultList 	= new ArrayList();								 	// 응답에 사용할 Data를 담는 List
        HashMap param 		= new HashMap();
        List selResult 		= new ArrayList();
        Map<String,String> dataMap = new HashMap<String,String>();
		
        LogUtil.getInstance().debug("LSJ===>>111");
        
    	try{
    		dataMap.put("TEST",  "123");
    		dataMap.put("TEST1", "456");
    		dataMap.put("TEST2", "789");
    		dataMap.put("TEST3", "000");

		} catch(Exception e) {
			e.printStackTrace(System.out);
			resultList.add(dataMap);
		}finally{			
		}
    	
    	resultList.add(dataMap);
    	
    	tranResOutMap.put("_tran_cd",       _tran_cd);
		tranResOutMap.put("_tran_res_data",  resultList);
        return tranResOutMap;
    }
}
%>
<%
	request.setAttribute(SpbBiz.class.getName(), new test_test());
%>