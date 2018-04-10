package qms;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import qms.batch.AttentionProc;
import qms.db.DBConnectManager;
import qms.util.PropertyUtil;

/**
 * WAS �⵿�� �����۾� 
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
		// WAS �⵿�� �ʱ� �����۾��� �����Ѵ�.
		Thread _thread	= new Thread(this);
		_thread.start();
	}
	
	public void run() { 
		System.out.println("::::::::::::::: QmsProcessInit ���� �⵿ ���� :::::::::::::::");
		initWork();
		System.out.println("::::::::::::::: QmsProcessInit ���� �⵿ �Ϸ� :::::::::::::::");
	}
	
	/**
	 * WAS �ʱ��۾� ����...
	 */
	private void initWork() {
		try{
			// ������Ƽ ���� �ε�
			System.out.println("������Ƽ ���� �ε带 �����մϴ�.");
			PropertyUtil.getInstance().reload();
			System.out.println("������Ƽ ���� �ε尡 �Ϸ�Ǿ����ϴ�.");
			
			// MyBatis DB Ŀ�ؼ� 
			System.out.println("DBĿ�ؼ��� �����մϴ�.");
			DBConnectManager.getInstance().getDBSession();
			System.out.println("DBĿ�ؼ��� �Ϸ� �Ǿ����ϴ�.");
	
			// ����ٽð� Auto ��ġ�⵿
			System.out.println("���°��� ��ġ�� �����մϴ�.");
			new Thread(new AttentionProc()).start();
			System.out.println("���°��� ��ġ �⵿�� �Ϸ�Ǿ����ϴ�.");

		} catch(Exception e){
			System.out.println("WAS �ʱ��۾� ������ ������ �߻��Ͽ����ϴ�.");
			e.printStackTrace();
		}
	}
}
