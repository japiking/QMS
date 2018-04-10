package qms.session;

public class UserSession {

	private String UserID		= null;			// 사용자ID
	private String UserName		= null;			// 사용자명
	private String ManagementGrade = null;		// 관리등급
	private String UserIp = null;				// 사용자IP
	
	
	private String ProjectID		= null;			// 프로젝트ID
	private String ProjectName		= null;			// 프로젝트명
	private String ProjectManagerID	= null;			// 프로젝트관리자ID
	
	private String AuthorityGrade		= null;			// 프로젝트ID
	
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
