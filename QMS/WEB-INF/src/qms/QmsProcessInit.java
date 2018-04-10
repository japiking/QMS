package qms;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import qms.batch.AttentionProc;
import qms.db.DBConnectManager;
import qms.util.PropertyUtil;

/**
 * WAS 기동시 수행작업 
 * @author Administrator
 *
 */
public class QmsProcessInit  extends HttpServlet  implements Runnable{

	private static final long serialVersionUID = -5290807527525588891L;
	
	
	public void destroy() {
	}
	public void init() throws ServletException {
		try{
			start();
		}catch(Exception se){
			throw se;
		}
	}
	private void start(){
		// WAS 기동후 초기 수행작업을 진행한다.
		Thread _thread	= new Thread(this);
		_thread.start();
	}
	
	public void run() { 
		System.out.println("::::::::::::::: QmsProcessInit 서블릿 기동 시작 :::::::::::::::");
		initWork();
		System.out.println("::::::::::::::: QmsProcessInit 서블릿 기동 완료 :::::::::::::::");
	}
	
	/**
	 * WAS 초기작업 수행...
	 */
	private void initWork() {
		try{
			// 프로퍼티 정보 로드
			System.out.println("프로퍼티 정보 로드를 시작합니다.");
			PropertyUtil.getInstance().reload();
			System.out.println("프로퍼티 정보 로드가 완료되었습니다.");
			
			// MyBatis DB 커넥션 
			System.out.println("DB커넥션을 시작합니다.");
			DBConnectManager.getInstance().getDBSession();
			System.out.println("DB커넥션을 완료 되었습니다.");
	
			// 출퇴근시간 Auto 배치기동
			System.out.println("근태관리 배치가 시작합니다.");
			new Thread(new AttentionProc()).start();
			System.out.println("근태관리 배치 기동이 완료되었습니다.");

		} catch(Exception e){
			System.out.println("WAS 초기작업 시행중 오류가 발생하였습니다.");
			e.printStackTrace();
		}
	}
}
