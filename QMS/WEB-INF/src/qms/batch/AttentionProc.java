package qms.batch;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import java.util.Random;

import org.apache.log4j.Logger;

import qms.db.DBSessionManager;
import qms.util.PropertyUtil;

/**
 * ����ٽð��� �ڵ����� �Է����ִ� ��ġ�Դϴ�.
 * properties�� ����� ����� ���̵� ������ �������̺� �����͸� �Է��մϴ�.
 * @author Administrator
 *
 */
public class AttentionProc implements Runnable{ 
	
	/**
	 * WAS �ʱ��۾� ����...
	 */
	static Logger    LOG = Logger.getLogger(AttentionProc.class);
	DBSessionManager QMSDB = null;
	
	@Override
	public void run() {
		// WAS �⵿�� �ʱ� �����۾��� �����Ѵ�.
		while(!Thread.currentThread().isInterrupted()){
			try {
				SimpleDateFormat formatter = new SimpleDateFormat("yyyy.MM.dd HH:mm:ss EEE", Locale.ENGLISH);
				Date currentTime = new Date();
				String dTime = formatter.format(currentTime);
				
				LOG.debug("LSJ----dTime>>"+dTime);
				
				/********************************************************
				 * �Ϲ�ġ�� �����ų �ð� (������ ~ ����� 08:25) *
				 *********************************************************/
				if (dTime.indexOf(" 08:25") != -1	&& dTime.indexOf(" Sun") == -1 && dTime.indexOf(" Sat") == -1) {
					System.out.println("Step-1. www.kiniwini.com Connect Resquest. : ��ɾ�.");
					attention_in();
				} else if (dTime.indexOf(" 22:30") != -1	&& dTime.indexOf(" Sun") == -1 && dTime.indexOf(" Sat") == -1) {
					attention_out();
				}
				
			}catch(Exception e){
				e.printStackTrace(System.out);
			}
			
			synchronized (this) {
				try {
					if (!Thread.currentThread().isInterrupted()) {
						this.wait(60000);
					}
				} catch (Throwable t) {
					 LOG.debug("##=============> AttentionManager Throwable t : " + t);
				}
			}
		}
	}
	/**
	 * ��ٽð�
	 */
	private void attention_in(){
		try{
			String []user_list = PropertyUtil.getInstance().getProperty("USER_LIST").split("\\|");
			int [] time = {10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29};
			int ran=0;    //�������� ���� ������ ����ϴ�.
			Random r = new Random();
			QMSDB = new DBSessionManager();
			Map<String,String> param = new HashMap<String,String>();
			
			for(int i=0; i<user_list.length; i++){
				ran = r.nextInt(19)+1;
				param.clear();
				
				param.put("USERID", 	user_list[i]);
				param.put("IN_TIME", 	"08:"+time[ran]+":35");
				
				Map<String,String> map = QMSDB.selectOne("QMS_SUPERUSER.ATTENTIONMANAGER_R001", param);
				
				// ���� ��ٱ���� ������쿡�� ��ٽð��� �Է��Ѵ�.
				if("0".equals(map.get("CNT"))){
					QMSDB.insert("QMS_SUPERUSER.ATTENTIONMANAGER_C001", param);
				}
			}
			
		}catch(Exception e){
			e.printStackTrace();
			if (QMSDB != null) try { QMSDB.rollback(); } catch (Exception e1) {}
		} finally{
			if (QMSDB != null) try { QMSDB.close(); } catch (Exception e1) {}
		}
	}
	/**
	 * ��ٽð�
	 */
	private void attention_out(){
		try{
			String []user_list = PropertyUtil.getInstance().getProperty("USER_LIST").split("\\|");
			int [] time = {10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29};
			int ran=0;    //�������� ���� ������ ����ϴ�.
			Random r 					= new Random();
			QMSDB 						= new DBSessionManager();
			Map<String,String> param 	= new HashMap<String,String>();
			
			for(int i=0; i<user_list.length; i++){
				ran = r.nextInt(19)+1;
				param.clear();
				
				param.put("USERID", 	user_list[i]);
				param.put("OUT_TIME", 	"23:"+time[ran]+":35");
				
				Map<String,String> map = QMSDB.selectOne("QMS_SUPERUSER.ATTENTIONMANAGER_R001", param);
				
				// ��ٱ���� ������� ��ٽð��� ������Ʈ�Ѵ�.
				if(!"0".equals(map.get("CNT"))){
					QMSDB.update("QMS_SUPERUSER.ATTENTIONMANAGER_U001", param);
				}
			}
			
		}catch(Exception e){
			e.printStackTrace();
			if (QMSDB != null) try { QMSDB.rollback(); } catch (Exception e1) {}
		} finally{
			if (QMSDB != null) try { QMSDB.close(); } catch (Exception e1) {}
		}
	}
}
