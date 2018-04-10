package qms.util;


public class AppConst {
	static public final String _TEST_SRV_IP = "172.20.30.126";
	
	
	static public final String _IS_ERROR = "IS_ERROR";
	static public final String _ERROR_CODE = "ERROR_CODE";
	static public final String _ERROR_MESSAGE = "ERROR_MESSAGE";
	static public final String _ERROR_ACTION = "ERROR_ACTION";
	
	static public final String _RESPONSE_CODE = "RESPONSE_CODE";
	static public final String _RESPONSE_TITLE = "RESPONSE_TITLE";
	static public final String _RESPONSE_MESSAGE = "RESPONSE_MESSAGE";
	static public final String _RESPONSE_ACTION = "RESPONSE_ACTION";
	
	static public final String HOST_NORMAL_CODE = "000000";
	
	public static final String NO_DISPLAY_ERROR_CD_ERROR	= "100"; /* 오류코드를 보여주지 않고 오류메세지만 공지형태로 표시*/
    public static final String UNDEFINE_ERROR				= "600"; /* 알수 없는 오류      	*/
    public static final String BT_CONNECTION_ERROR			= "601"; /* BT Connection 오류 		*/
    public static final String UNDEFINE_CHANNEL				= "602"; /* 채널정보 미정 오류     	*/
    public static final String RECEIVE_DATA_FORMAT_ERROR	= "603"; /* 수신 자료 포멧 오류 	*/
    public static final String SEND_DATA_FORMAT_ERROR		= "604"; /* 송신 자료 포멧 오류  	*/
    public static final String DECRYPTION_FORMAT_ERROR		= "605"; /* 복호화        오류  	*/
    public static final String DB_ERROR						= "606"; /* DB 처리 오류			*/
    public static final String CERT_ERROR					= "607"; /* 인증서 오류				*/
    public static final String LDAP_ERROR					= "608"; /* RA 연결 오류			*/
    public static final String SVRCHK_ERROR					= "609"; /* 서비스시간체크 오류		*/
    public static final String LOGIN_ERROR					= "610"; /* 로그인하지 않은사용자	*/
    public static final String MERGE_ERROR					= "621"; /* 리바운드 데이터 merge 오류	*/
    public static final String DATA_NOT_FOUND_ERROR			= "622"; /* 데이터가 없음 오류		*/
    public static final String SECURE_ACCESS_ERROR			= "999"; /* 보안모듈 오류			*/
    public static final String ID_SMART_SESSION_ERROR		= "700"; /* 사용자 세션 오류(ID/PW 필요 거래이나 로그인 하지 않았음)        */
    public static final String CERT_SMART_SESSION_ERROR		= "701"; /* 사용자 세션 오류(인증서 필요 거래이나 로그인 하지 않았음)       */
	public static final String SMART_DUPLE_LOGIN_ERROR		= "702"; /* 사용자 세션 오류(중복로그인)       */
	
	// 공통 메세지-고객에게 실제로 출력될 메세지 
    public static final String TIME_OVER_DISCONNECT_ERROR_MSG	= "장시간 사용하지 않아 접속이 종료되었습니다. 다시 접속하여 주시기 바랍니다."; 
    public static final String UNDEFINE_ERROR_MSG			    = "처리중 오류가 발생하였습니다.잠시후 이용하시기 바랍니다."; 
    public static final String SMART_SESSION_ERROR_MSG		    = "장시간 사용하지 않아 접속이 종료되었습니다. 다시 로그인하여 주시기 바랍니다."; 
    public static final String ID_SMART_SESSION_ERROR_MSG		= "본 거래는 ID, 비밀번호 로그인이 필요합니다. 로그인하시기 바랍니다."; 
    public static final String CERT_SMART_SESSION_ERROR_MSG		= "본 거래는 인증서 로그인이 필요합니다. 로그인하시기 바랍니다."; 
	public static final String SMART_PROGRAM_ERROR_MSG		    = "프로그램에 오류가 발생하였습니다.재설치하시기 바랍니다."; 
	public static final String SMART_CERT_ERROR_MSG		        = "유효한 인증서가 아닙니다. 기존 인증서를 삭제한 후 유효한 인증서를 다시 복사하여 거래하시기 바랍니다. 타행 타기관 인증서인 경우 복사하기전에 인터넷 뱅킹 공인 인증센터의 타행타기관 인증서를 등록 하시기 바랍니다.";
	public static final String SMART_DUPLE_LOGIN_MSG		    = "동일이용자로 스마트폰뱅킹 또는 인터넷뱅킹에 접속이 되어 고객님의 개인정보 보호를 위해 로그아웃 되었습니다."; 
	public static final String SMART_LOGINTIME_ERROR_MSG	    = "이용에 불편을 드려 죄송합니다. 원활한 서비스를 위한 온라인 전환 및 시스템 조정작업으로 서비스가 일시 중지 되오니 잠시 후 이용하여 주시기 바랍니다. 시스템 전환일시 : 매일 00시 00분 ~ 00시 10분 (시스템 사정에 따라 중지 시간은 변경 될 수 있습니다)"; 
	public static final String UNDEFINE_APP_ERROR_MSG		    = "정상적인 앱이 아닙니다.";
	
	public static final String ACTION_NONE                  = "1000";   // 페이지 유지
}
