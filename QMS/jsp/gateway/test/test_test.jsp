<%--
/******************************************************************************
* @ �� �� �� : test
* @ �������� : test
* @ �� �� �� : /gateway/test/test_test.jsp
* @ �� �� �� : webCash
* @ �� �� �� : 2015-01-20
************************** �� �� �� �� ****************************************
* ��ȣ  �� �� ��    ��  ��  ��                       ���泻��
*******************************************************************************
*  1  webCash	2015-01-20      ���� �ۼ�
******************************************************************************/
--%>
<%@ page language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%@ include file="/jsp/inc/inc_ActionHeader.jsp" %>

<%!

public class test_test implements SpbBiz {

    public boolean isNeedIDLogin() {
		// ID�α����� �ʿ� �����Ƿ� false����
        return false;
    }
    
    public boolean isNeedCertLogin() {
        // ������ �α����� �ʿ� �����Ƿ� false����
        return false;
    }

	public String ENC(String str) {
		return str;
	}

    public Map execute(HttpSession session, HttpServletRequest request, Map trmap) throws Exception{
    	String _tran_cd		= (String) trmap.get("_tran_cd");				 	// ����ID
        Map tranReqMap		= (Map)((List)trmap.get("_tran_req_data")).get(0);	// ���� ��û ������
        Map result       	= new HashMap();                                 	// ���信 ����� ��ü Map
        Map tranResOutMap   = new HashMap();                                 	// ���信 ����� ��ü Map
        List resultList 	= new ArrayList();								 	// ���信 ����� Data�� ��� List
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