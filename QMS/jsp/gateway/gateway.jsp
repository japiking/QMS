<%--
/******************************************************************************
* @ 업 무 명    : QMS Gateway
* @ 업무설명    : JSON 전문 데이터 송수신
* @ 파 일 명    : /jsp/gateway/gateway.jsp
* @ 작 성 자    : WEBCASH.CO.KR
* @ 작 성 일    : 2015-01-20
************************** 변 경 이 력 ****************************************
* 번호  작 업 자    작  업  일                       변경내용
*******************************************************************************
*    1  WEBCASH     2015-01-20      최초 작성
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
     * strWEBMode           : WEB Mode (PC 브라우저를 통한 개발자:Y)
     *                        WEB Mode-IE에서 개발할때 보안모듈 없이 테스트 해야 함으로 개발자모드인것을 정의
     *                        request parameter에 "WEBMode"를 파라미터명으로 하여 "Y"로 설정하면 개발자모드인것을 뜻한다.
     * strTaskId            : 전문ID(전문코드)
     *                        일반업무(계좌조회, 이체)와 관련된 전문은 "ap"+4자리숫자 형태로 생성된다.
     *                        공통업무(로그인, 로그아웃...)는 "cm"+4자리숫자 형태로 생성된다.
     *                        iPod일 경우는 전화번호가 없으므로 MAC Address가 전송된다.
     * strJSONData          : JSON Data-Client로 부터 전송 받은 JSONData request parameter 값
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
	
     //JSONData 오류 체크
    if ("".equals(strJSONData)) {
        // 응답처리 유무(옵션)
        LogUtil.getInstance().error("JSONData 파라미터가 누락되었습니다.");
        return;
    }
	
  	ObjectMapper mapper = new ObjectMapper();					//JacksonJson
  	Map svcIn = (Map)mapper.readValue(strJSONData, Map.class);	//JacksonJson
	Map reqMap   = (Map)((List)svcIn.get("_tran_req_data")).get(0); // 전문 요청 개별부
	
	LogUtil.getInstance().info("TASK_PACKAGE :::::::::::::::::>"+reqMap.get("TASK_PACKAGE"));
    
	
    // 방법 1
    long fTime = System.currentTimeMillis();
    long lTime = System.currentTimeMillis();
    int logSeq = (new java.util.Random().nextInt(1000));
    LogUtil.getInstance().info("[gateway] JSP Start time : " + new java.util.Date());

    // 캐시 삭제
    response.setHeader("Cache-Control", "no-store"); 	// HTTP 1.1
    response.setHeader("Pragma", "no-cache"); 			// HTTP 1.0
    response.setDateHeader("Expires", 0);

    boolean isSecureError = false; 	// 보안모듈 오류여부
    String strSecureErrorMsg = ""; 	// 보안모듈 에러메세지

    // 응답 데이터
    byte[] recMessage = null; 		// 클라이언트에 전송될 데이터

	//JacksonJson 
    JacksonJsonToMap toMap = null; 	// 클라이언트에서 받은 json 데이터를 Map으로 변환하는데 사용되는 클래스
    MapToJacksonJson toJson = null; // 클라이언트에 전송할 map데이터를 json 데이터로 변화하는데 사용되는 클래스

    /**
     * 내용 : 모든 http header 값 출력
     * 사용 : 옵션
     * 방법 : 유지
     **/
    try {
       
    	/**
         * 내용 : 수신 데이터 확인
         **/
        toMap = new JacksonJsonToMap("utf-8");	//JacksonJson
        toJson = new MapToJacksonJson("utf-8");	//JacksonJson
       
        /**
         * 내용 : JSON 데이터를 HashMap으로 변환
         **/
        if (!toMap.parser(strJSONData)) {
            // 수신 Data변환 오류..
            LogUtil.getInstance().fatal("송신한 데이터의 JSON변환 중 오류가 발생하였습니다.");
            return;
        }
   
        /** 
         * 내용 : 전문ID 확인
         * 사용 : 필수
         * 방법 : 유지
         **/
        strTaskId = StringUtil.null2void(toMap.getTaskId());

//         strTaskId = strTaskId.toUpperCase();
        request.setAttribute("STR_TASK_ID", strTaskId);
        
        LogUtil.getInstance().info("┏━━━━┳━━━━━━━━━━┓");
        LogUtil.getInstance().info("┃ 전문ID ┃  " + strTaskId + "         ┃");
        LogUtil.getInstance().info("┗━━━━┻━━━━━━━━━━┛");
        
     	// 유저정보를 저장하는 세션(로그인세션)
     	LogUtil.getInstance().debug(">>>> Session Manager MaxInactiveInterval [" + request.getSession().getMaxInactiveInterval() + "]");
     	 
        // 전문을 송수신하는 과정에서 수행시간 체크
        lTime = System.currentTimeMillis();

        // 클라이언트에 전송할 데이터
        Map responseMap;

        // ==================================================================

        try {

            // 모든 거래는 아래 SpbBiz 인터페이스를 구현(implement)해야 한다.
            SpbBiz biz = null;
            /**
             * 내용 : Browser Control Service
             * 설명 : 스마트기기 관리시스템에 등록된 서비스 제어 정보 및 화면 UI요소를
             * 메모리에 로드하여 전용브라우저에게 전달한다.
             * 사용 : 필수
             * 방법 : 유지
             **/
			try {
				LogUtil.getInstance().debug("TASK_PACKAGE  ::::::::::::::::>["+reqMap.get("TASK_PACKAGE")+"]");
				String strTask = reqMap.get("TASK_PACKAGE").toString();	 //업무 경로  
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
				LogUtil.getInstance().error("호출된 " + strTaskId + " AP 는 오류가 발생했거나 혹은 구현되지 않은 JSP 입니다!!!");
				LogUtil.getInstance().error("##################################");
				throw new ClassNotFoundException("");
			}

            // 로그인 체크
			if (biz.isNeedIDLogin()) {
            	//세션 끊기면 로그인페이지로 이동시킴
				if( !StringUtil.isService(request) ) {
					LogUtil.getInstance().error("##################################");
					LogUtil.getInstance().error("호출된 " + strTaskId + " AP 는 로그인이 필수 입니다!!!");
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

        } catch (ClassNotFoundException e1) { // 클래스를 찾지못했을 경우에 대한 예외사항
            throw new Exception("[" + strTaskId + "]에 오류가 발생했거나 해당하는 거래를 찾을 수 없습니다.");
        }

        // 에러메시지 처리
        Map dataMap = (Map) ((List) responseMap.get("_tran_res_data")).get(0);
        if (dataMap.get("ERROR_CODE") != null || dataMap.get("ERROR_TITLE") != null) {
        	
        	LogUtil.getInstance().debug("ERROR EXIST :::::::::::::::::");
            
        	String errorCd     = (String) dataMap.get("ERROR_CODE");
            String errorTitle  = (String) dataMap.get("RESPONSE_GUIDE_MESSAGE");
            String errorAction = (String) dataMap.get("ERROR_ACTION");
            String secuErrYn   = "N";
            
            strRES_CD = errorCd;
            
            // errorAction 이 정해지지 않았을 경우 ACTION_NONE 할당
            if (  "".equals(StringUtil.null2void(errorAction))) {
                errorAction = "1000";
            }
            
            // errorTitle 의 html 태그 제거 - 2010.10.04 정규식 사용 공통메서드로 대체
            errorTitle = BizUtil.htmlClean(errorTitle);
            
            dataMap.put(AppConst._IS_ERROR 	 	, "true"	);
            dataMap.put(AppConst._ERROR_CODE    , errorCd	);
            dataMap.put(AppConst._ERROR_MESSAGE	, errorTitle );
            dataMap.put(AppConst._ERROR_ACTION  , errorAction);
            dataMap.put("ERROR_MSG"   			, errorTitle );
            dataMap.put("SMART_SECU_ERROR_YN"	, secuErrYn  );
            
            LogUtil.getInstance().debug(dataMap);
        }
        //정상메세지 처리 default 처리
        else{
        	
        	LogUtil.getInstance().info("정상처리 :::::::::::::::::");
        	
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

        // 데이터 전송
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