package qms.session;

public class UserSession {

	private String UserID		= null;			// �����ID
	private String UserName		= null;			// ����ڸ�
	private String ManagementGrade = null;		// �������
	private String UserIp = null;				// �����IP
	
	
	private String ProjectID		= null;			// ������ƮID
	private String ProjectName		= null;			// ������Ʈ��
	private String ProjectManagerID	= null;			// ������Ʈ������ID
	
	private String AuthorityGrade		= null;			// ������ƮID
	
	public UserSession() {
	}
	
	public String getUserID() {
		return UserID;
	}
	
	public String getUserName() {
		return UserName;
	}
	
	public String getManagementGrade() {
		return ManagementGrade;
	}
	
	public String getUserIp() {
		return UserIp;
	}
	
	public String getProjectID() {
		return ProjectID;
	}
	
	public String getProjectName() {
		return ProjectName;
	}
	
	public String getProjectManagerID() {
		return ProjectManagerID;
	}
	
	public String getAuthorityGrade() {
		return AuthorityGrade;
	}

	
	public void setUserId(String user_id) {
		this.UserID	= user_id;
	}
	
	public void setUserName(String UserName) {
		this.UserName	= UserName;
	}
	
	public void setManagementGrade(String ManagementGrade) {
		this.ManagementGrade	= ManagementGrade;
	}
	
	public void setUserIp(String UserIp) {
		this.UserIp	= UserIp;
	}
	
	public void setProjectID(String ProjectID) {
		this.ProjectID	= ProjectID;
	}
	
	public void setProjectName(String ProjectName) {
		this.ProjectName	= ProjectName;
	}
	
	public void setProjectManagerID(String ProjectManagerID) {
		this.ProjectManagerID	= ProjectManagerID;
	}
	
	public void setAuthorityGrade(String AuthorityGrade) {
		this.AuthorityGrade	= AuthorityGrade;
	}
	
}
