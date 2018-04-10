<%--
/******************************************************************************
* @ �� �� ��    : QMS Gateway
* @ ��������    : JSON ���� ������ �ۼ���
* @ �� �� ��    : /jsp/gateway/gateway.jsp
* @ �� �� ��    : WEBCASH.CO.KR
* @ �� �� ��    : 2015-01-20
************************** �� �� �� �� ****************************************
* ��ȣ  �� �� ��    ��  ��  ��                       ���泻��
*******************************************************************************
*    1  WEBCASH     2015-01-20      ���� �ۼ�
******************************************************************************/
--%>  
  
<%@page import="qms.Const"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="java.util.Map"%>
<%@ page contentType="text/html; charset=euc-kr" %>
<%@page import="qms.spbiz.SpbBiz"%>
<%@page import="qms.util.*"%>
<%@ page import="org.codehaus.jackson.map.ObjectMapper"%>
<%@ page import="java.text.SimpleDateFormat" %>

<%!  
    /**
     * strWEBMode           : WEB Mode (PC �������� ���� ������:Y)
     *                        WEB Mode-IE���� �����Ҷ� ���ȸ�� ���� �׽�Ʈ �ؾ� ������ �����ڸ���ΰ��� ����
     *                        request parameter�� "WEBMode"�� �Ķ���͸����� �Ͽ� "Y"�� �����ϸ� �����ڸ���ΰ��� ���Ѵ�.
     * strTaskId            : ����ID(�����ڵ�)
     *                        �Ϲݾ���(������ȸ, ��ü)�� ���õ� ������ "ap"+4�ڸ����� ���·� �����ȴ�.
     *                        �������(�α���, �α׾ƿ�...)�� "cm"+4�ڸ����� ���·� �����ȴ�.
     *                        iPod�� ���� ��ȭ��ȣ�� �����Ƿ� MAC Address�� ���۵ȴ�.
     * strJSONData          : JSON Data-Client�� ���� ���� ���� JSONData request parameter ��
     **/
%> 
<%
	LogUtil.getInstance().info("========================== <Gateway Start> ==========================");

    String strTaskId                = "";  
    String strJSONData              = "";
    String strLOG_USERID			= "GUEST";
    String strLOG_LOGIN_UUID		= "";
    String strLOG_UUID				= "";
    String strUSER_IP				= StringUtil.null2void(request.getRemoteAddr());
    String strRES_CD				= "000000";
//     String strDev_TYPE				= "";
//     String strTRAN_AMT				= "0";
//     String strTRAN_CNT				= "0";
	String hid_key_data = "";
	String hid_enc_data = "";
    		

    request.setAttribute("STR_TASK_ID", " GATEWAY ");
    
    /**
     *	JSON INPUT DATA
     */
    strJSONData = StringUtil.null2void(request.getParameter("JSONData"));
    hid_key_data = StringUtil.null2void(request.getParameter("hid_key_data"));
    hid_enc_data = StringUtil.null2void(request.getParameter("hid_enc_data"));
    strJSONData = URLDecoder.decode(strJSONData, "UTF-8");
    LogUtil.getInstance().debug("strJSONData  :::::::::::::::::>\n"+strJSONData);
    //LogUtil.getInstance().debug("hid_key_data  :::::::::::::::::>\n"+hid_key_data);
    //LogUtil.getInstance().debug("hid_enc_data  :::::::::::::::::>\n"+hid_enc_data);
	
     //JSONData ���� üũ
    if ("".equals(strJSONData)) {
        // ����ó�� ����(�ɼ�)
        LogUtil.getInstance().error("JSONData �Ķ���Ͱ� �����Ǿ����ϴ�.");
        return;
    }
	
  	ObjectMapper mapper = new ObjectMapper();					//JacksonJson
  	Map svcIn = (Map)mapper.readValue(strJSONData, Map.class);	//JacksonJson
	Map reqMap   = (Map)((List)svcIn.get("_tran_req_data")).get(0); // ���� ��û ������
	
	LogUtil.getInstance().info("TASK_PACKAGE :::::::::::::::::>"+reqMap.get("TASK_PACKAGE"));
    
	
    // ��� 1
    long fTime = System.currentTimeMillis();
    long lTime = System.currentTimeMillis();
    int logSeq = (new java.util.Random().nextInt(1000));
    LogUtil.getInstance().info("[gateway] JSP Start time : " + new java.util.Date());

    // ĳ�� ����
    response.setHeader("Cache-Control", "no-store"); 	// HTTP 1.1
    response.setHeader("Pragma", "no-cache"); 			// HTTP 1.0
    response.setDateHeader("Expires", 0);

    boolean isSecureError = false; 	// ���ȸ�� ��������
    String strSecureErrorMsg = ""; 	// ���ȸ�� �����޼���

    // ���� ������
    byte[] recMessage = null; 		// Ŭ���̾�Ʈ�� ���۵� ������

	//JacksonJson 
    JacksonJsonToMap toMap = null; 	// Ŭ���̾�Ʈ���� ���� json �����͸� Map���� ��ȯ�ϴµ� ���Ǵ� Ŭ����
    MapToJacksonJson toJson = null; // Ŭ���̾�Ʈ�� ������ map�����͸� json �����ͷ� ��ȭ�ϴµ� ���Ǵ� Ŭ����

    /**
     * ���� : ��� http header �� ���
     * ��� : �ɼ�
     * ��� : ����
     **/
    try {
       
    	/**
         * ���� : ���� ������ Ȯ��
         **/
        toMap = new JacksonJsonToMap("utf-8");	//JacksonJson
        toJson = new MapToJacksonJson("utf-8");	//JacksonJson
       
        /**
         * ���� : JSON �����͸� HashMap���� ��ȯ
         **/
        if (!toMap.parser(strJSONData)) {
            // ���� Data��ȯ ����..
            LogUtil.getInstance().fatal("�۽��� �������� JSON��ȯ �� ������ �߻��Ͽ����ϴ�.");
            return;
        }
   
        /** 
         * ���� : ����ID Ȯ��
         * ��� : �ʼ�
         * ��� : ����
         **/
        strTaskId = StringUtil.null2void(toMap.getTaskId());

//         strTaskId = strTaskId.toUpperCase();
        request.setAttribute("STR_TASK_ID", strTaskId);
        
        LogUtil.getInstance().info("����������������������������������");
        LogUtil.getInstance().info("�� ����ID ��  " + strTaskId + "         ��");
        LogUtil.getInstance().info("����������������������������������");
        
     	// ���������� �����ϴ� ����(�α��μ���)
     	LogUtil.getInstance().debug(">>>> Session Manager MaxInactiveInterval [" + request.getSession().getMaxInactiveInterval() + "]");
     	 
        // ������ �ۼ����ϴ� �������� ����ð� üũ
        lTime = System.currentTimeMillis();

        // Ŭ���̾�Ʈ�� ������ ������
        Map responseMap;

        // ==================================================================

        try {

            // ��� �ŷ��� �Ʒ� SpbBiz �������̽��� ����(implement)�ؾ� �Ѵ�.
            SpbBiz biz = null;
            /**
             * ���� : Browser Control Service
             * ���� : ����Ʈ��� �����ý��ۿ� ��ϵ� ���� ���� ���� �� ȭ�� UI��Ҹ�
             * �޸𸮿� �ε��Ͽ� ������������� �����Ѵ�.
             * ��� : �ʼ�
             * ��� : ����
             **/
			try {
				LogUtil.getInstance().debug("TASK_PACKAGE  ::::::::::::::::>["+reqMap.get("TASK_PACKAGE")+"]");
				String strTask = reqMap.get("TASK_PACKAGE").toString();	 //���� ���  
				LogUtil.getInstance().debug(strTaskId +".jsp");
				String strPage = "/jsp/proc/"+strTask+"/"+strTask+"_"+strTaskId +".jsp";
				
				LogUtil.getInstance().debug("URL==========>"+strPage);
%>
				<jsp:include page='<%=strPage%>' />
<%
				biz = (SpbBiz)request.getAttribute(SpbBiz.class.getName());	
				LogUtil.getInstance().debug("isNeedIDLogin  ::::::::::::::>" + biz.isNeedIDLogin());
				
			} catch(Exception t) {
				t.printStackTrace(System.err);
			  	LogUtil.getInstance().error(t.toString());
			  	LogUtil.getInstance().error("##################################");
				LogUtil.getInstance().error("ȣ��� " + strTaskId + " AP �� ������ �߻��߰ų� Ȥ�� �������� ���� JSP �Դϴ�!!!");
				LogUtil.getInstance().error("##################################");
				throw new ClassNotFoundException("");
			}

            // �α��� üũ
			if (biz.isNeedIDLogin()) {
            	//���� ����� �α����������� �̵���Ŵ
				if( !StringUtil.isService(request) ) {
					LogUtil.getInstance().error("##################################");
					LogUtil.getInstance().error("ȣ��� " + strTaskId + " AP �� �α����� �ʼ� �Դϴ�!!!");
					LogUtil.getInstance().error("##################################");
					session.invalidate();
					response.sendRedirect(Const.URL_VIEW_LOGIN + "?return_url=" + request.getRequestURI());
                }
            }

            LogUtil.getInstance().debug("Begin SpbBiz Execute");
            LogUtil.getInstance().debug("getReqData :::> "+toMap.getReqData());

            responseMap = biz.execute(session, request, toMap.getReqData());
            
            LogUtil.getInstance().debug("End SpbBiz Execute");
            LogUtil.getInstance().debug("responseMap :::> "+responseMap.toString());

        } catch (ClassNotFoundException e1) { // Ŭ������ ã�������� ��쿡 ���� ���ܻ���
            throw new Exception("[" + strTaskId + "]�� ������ �߻��߰ų� �ش��ϴ� �ŷ��� ã�� �� �����ϴ�.");
        }

        // �����޽��� ó��
        Map dataMap = (Map) ((List) responseMap.get("_tran_res_data")).get(0);
        if (dataMap.get("ERROR_CODE") != null || dataMap.get("ERROR_TITLE") != null) {
        	
        	LogUtil.getInstance().debug("ERROR EXIST :::::::::::::::::");
            
        	String errorCd     = (String) dataMap.get("ERROR_CODE");
            String errorTitle  = (String) dataMap.get("RESPONSE_GUIDE_MESSAGE");
            String errorAction = (String) dataMap.get("ERROR_ACTION");
            String secuErrYn   = "N";
            
            strRES_CD = errorCd;
            
            // errorAction �� �������� �ʾ��� ��� ACTION_NONE �Ҵ�
            if (  "".equals(StringUtil.null2void(errorAction))) {
                errorAction = "1000";
            }
            
            // errorTitle �� html �±� ���� - 2010.10.04 ���Խ� ��� ����޼���� ��ü
            errorTitle = BizUtil.htmlClean(errorTitle);
            
            dataMap.put(AppConst._IS_ERROR 	 	, "true"	);
            dataMap.put(AppConst._ERROR_CODE    , errorCd	);
            dataMap.put(AppConst._ERROR_MESSAGE	, errorTitle );
            dataMap.put(AppConst._ERROR_ACTION  , errorAction);
            dataMap.put("ERROR_MSG"   			, errorTitle );
            dataMap.put("SMART_SECU_ERROR_YN"	, secuErrYn  );
            
            LogUtil.getInstance().debug(dataMap);
        }
        //����޼��� ó�� default ó��
        else{
        	
        	LogUtil.getInstance().info("����ó�� :::::::::::::::::");
        	
        	dataMap.put(AppConst._IS_ERROR 	 , "false"  );
        	
        	if ( "".equals(StringUtil.null2void(dataMap.get(AppConst._RESPONSE_CODE)))) {
        		dataMap.put(AppConst._RESPONSE_CODE    , AppConst.HOST_NORMAL_CODE );
            }
        	if ( "".equals(StringUtil.null2void(dataMap.get(AppConst._RESPONSE_TITLE)))) {
        		dataMap.put(AppConst._RESPONSE_TITLE    , "" );
            }
        	if ( "".equals(StringUtil.null2void(dataMap.get(AppConst._RESPONSE_MESSAGE)))) {
        		dataMap.put(AppConst._RESPONSE_MESSAGE    , "" );
            }
        	if ( "".equals(StringUtil.null2void(dataMap.get(AppConst._RESPONSE_ACTION)))) {
        		dataMap.put(AppConst._RESPONSE_ACTION    , AppConst.ACTION_NONE );
            }
        }
		
        
        LogUtil.getInstance().debug("BEFORE MESSAGE :::::::::::::::::");
        recMessage = toJson.parser(responseMap); 
        LogUtil.getInstance().debug("AFTER MESSAGE :::::::::::::::::");

        // ������ ����
        if (recMessage != null) {

        	BizUtil.sendMatrixData(out, new String(recMessage), BizUtil.getLocaleCode(request), null);
            LogUtil.getInstance().debug("strRES_CD  :::::::::::::::::>" + strRES_CD);
            
            LogUtil.getInstance().debug("*********************************");
        }
    } catch (Error e) {
        LogUtil.getInstance().error("Error ::: " + e.getMessage());
  
        // ERROR JSON Error Begin
        HashMap map = new HashMap();
        map.put(AppConst._IS_ERROR , "true" );
        map.put(AppConst._ERROR_CODE      		, AppConst.UNDEFINE_ERROR      );
        map.put(AppConst._ERROR_MESSAGE   		, AppConst.UNDEFINE_ERROR_MSG  );
        map.put(AppConst._ERROR_ACTION  		, AppConst.ACTION_NONE         );
        map.put("ERROR_MSG"   					, AppConst.UNDEFINE_ERROR_MSG  );

        List list = new ArrayList();
        list.add(map);

        HashMap responseMap = new HashMap();
        responseMap.put("_tran_cd",       "ERROR");
        responseMap.put("_tran_res_data" , list);
        
        ObjectMapper mapper2 = new ObjectMapper();					//JacksonJson
        String jsonOut = mapper2.writeValueAsString(responseMap);	//JacksonJson

        // ERROR JSON Error End
        e.printStackTrace(System.out);
     
    } catch (Exception e) {
    	e.printStackTrace(System.err);
        LogUtil.getInstance().error("Exception getMessage ::: "+e.getMessage());
        LogUtil.getInstance().error("Exception toString ::: "+e.toString());
        LogUtil.getInstance().error("Exception e ::: "+ e);

        // ERROR JSON Error Begin
        HashMap map = new HashMap();
        map.put(AppConst._IS_ERROR		, "true"      );  
        map.put(AppConst._ERROR_CODE    , AppConst.UNDEFINE_ERROR      );
        map.put(AppConst._ERROR_MESSAGE	, AppConst.UNDEFINE_ERROR_MSG  );
        map.put(AppConst._ERROR_ACTION  , AppConst.ACTION_NONE         );
        map.put("ERROR_MSG"   			, AppConst.UNDEFINE_ERROR_MSG  );

        
        List list = new ArrayList();
        list.add(map);

        HashMap responseMap = new HashMap();
        responseMap.put("_tran_cd"		,	"ERROR");  
        responseMap.put("_tran_res_data",	list);
        
        ObjectMapper mapper3 = new ObjectMapper();					//JacksonJson
        String jsonOut = mapper3.writeValueAsString(responseMap);	//JacksonJson

        e.printStackTrace(System.out);
    } finally {
        LogUtil.getInstance().info("========================== <Gateway End> ==========================");
    }

    LogUtil.getInstance().debug("[TR " + strTaskId + " Time\t : " + (System.currentTimeMillis() - lTime) + " ms]");
    LogUtil.getInstance().debug("[JSP Millis Time\t : " + (System.currentTimeMillis() - fTime) + " ms]");
    LogUtil.getInstance().debug("[JSP Total Time\t : " + (System.currentTimeMillis() - fTime) / 1000 + " sec]");
    LogUtil.getInstance().debug("[JSP End Time : " + new java.util.Date() + "]");
%>