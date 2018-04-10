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
	
	public static final String NO_DISPLAY_ERROR_CD_ERROR	= "100"; /* �����ڵ带 �������� �ʰ� �����޼����� �������·� ǥ��*/
    public static final String UNDEFINE_ERROR				= "600"; /* �˼� ���� ����      	*/
    public static final String BT_CONNECTION_ERROR			= "601"; /* BT Connection ���� 		*/
    public static final String UNDEFINE_CHANNEL				= "602"; /* ä������ ���� ����     	*/
    public static final String RECEIVE_DATA_FORMAT_ERROR	= "603"; /* ���� �ڷ� ���� ���� 	*/
    public static final String SEND_DATA_FORMAT_ERROR		= "604"; /* �۽� �ڷ� ���� ����  	*/
    public static final String DECRYPTION_FORMAT_ERROR		= "605"; /* ��ȣȭ        ����  	*/
    public static final String DB_ERROR						= "606"; /* DB ó�� ����			*/
    public static final String CERT_ERROR					= "607"; /* ������ ����				*/
    public static final String LDAP_ERROR					= "608"; /* RA ���� ����			*/
    public static final String SVRCHK_ERROR					= "609"; /* ���񽺽ð�üũ ����		*/
    public static final String LOGIN_ERROR					= "610"; /* �α������� ���������	*/
    public static final String MERGE_ERROR					= "621"; /* ���ٿ�� ������ merge ����	*/
    public static final String DATA_NOT_FOUND_ERROR			= "622"; /* �����Ͱ� ���� ����		*/
    public static final String SECURE_ACCESS_ERROR			= "999"; /* ���ȸ�� ����			*/
    public static final String ID_SMART_SESSION_ERROR		= "700"; /* ����� ���� ����(ID/PW �ʿ� �ŷ��̳� �α��� ���� �ʾ���)        */
    public static final String CERT_SMART_SESSION_ERROR		= "701"; /* ����� ���� ����(������ �ʿ� �ŷ��̳� �α��� ���� �ʾ���)       */
	public static final String SMART_DUPLE_LOGIN_ERROR		= "702"; /* ����� ���� ����(�ߺ��α���)       */
	
	// ���� �޼���-������ ������ ��µ� �޼��� 
    public static final String TIME_OVER_DISCONNECT_ERROR_MSG	= "��ð� ������� �ʾ� ������ ����Ǿ����ϴ�. �ٽ� �����Ͽ� �ֽñ� �ٶ��ϴ�."; 
    public static final String UNDEFINE_ERROR_MSG			    = "ó���� ������ �߻��Ͽ����ϴ�.����� �̿��Ͻñ� �ٶ��ϴ�."; 
    public static final String SMART_SESSION_ERROR_MSG		    = "��ð� ������� �ʾ� ������ ����Ǿ����ϴ�. �ٽ� �α����Ͽ� �ֽñ� �ٶ��ϴ�."; 
    public static final String ID_SMART_SESSION_ERROR_MSG		= "�� �ŷ��� ID, ��й�ȣ �α����� �ʿ��մϴ�. �α����Ͻñ� �ٶ��ϴ�."; 
    public static final String CERT_SMART_SESSION_ERROR_MSG		= "�� �ŷ��� ������ �α����� �ʿ��մϴ�. �α����Ͻñ� �ٶ��ϴ�."; 
	public static final String SMART_PROGRAM_ERROR_MSG		    = "���α׷��� ������ �߻��Ͽ����ϴ�.�缳ġ�Ͻñ� �ٶ��ϴ�."; 
	public static final String SMART_CERT_ERROR_MSG		        = "��ȿ�� �������� �ƴմϴ�. ���� �������� ������ �� ��ȿ�� �������� �ٽ� �����Ͽ� �ŷ��Ͻñ� �ٶ��ϴ�. Ÿ�� Ÿ��� �������� ��� �����ϱ����� ���ͳ� ��ŷ ���� ���������� Ÿ��Ÿ��� �������� ��� �Ͻñ� �ٶ��ϴ�.";
	public static final String SMART_DUPLE_LOGIN_MSG		    = "�����̿��ڷ� ����Ʈ����ŷ �Ǵ� ���ͳݹ�ŷ�� ������ �Ǿ� ������ �������� ��ȣ�� ���� �α׾ƿ� �Ǿ����ϴ�."; 
	public static final String SMART_LOGINTIME_ERROR_MSG	    = "�̿뿡 ������ ��� �˼��մϴ�. ��Ȱ�� ���񽺸� ���� �¶��� ��ȯ �� �ý��� �����۾����� ���񽺰� �Ͻ� ���� �ǿ��� ��� �� �̿��Ͽ� �ֽñ� �ٶ��ϴ�. �ý��� ��ȯ�Ͻ� : ���� 00�� 00�� ~ 00�� 10�� (�ý��� ������ ���� ���� �ð��� ���� �� �� �ֽ��ϴ�)"; 
	public static final String UNDEFINE_APP_ERROR_MSG		    = "�������� ���� �ƴմϴ�.";
	
	public static final String ACTION_NONE                  = "1000";   // ������ ����
}
