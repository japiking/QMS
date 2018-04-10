package qms.util;

import org.apache.log4j.Logger;
import org.apache.log4j.PropertyConfigurator;

public class LogUtil {
	private static LogUtil LOG = new LogUtil();
	static Logger logger = Logger.getLogger(LogUtil.class);
	
	private LogUtil(){
		PropertyConfigurator.configure(PropertyUtil.getInstance().getRootPath()+"/properties/qms.properties");
	}
	/**
	 * LogUtil 리턴
	 * @return
	 */
	public static LogUtil getInstance(){
		if(null == LOG){
			LOG = new LogUtil();
		}
		return LOG;
	}
	/**
	 * 서버 경로 가져오기
	 * @return
	 */
	public String getPath(){
		int index = this.getClass().getResource(".").getPath().indexOf("classes/");
		return this.getClass().getResource(".").getPath().substring(0, index);
	}
	
	/**
	 * Debug레벨 로그
	 * @param obj
	 */
	public void debug(Object obj){
		logger.debug(obj);
	}
	/**
	 * Debug레벨 로그
	 * @param obj
	 */
	public void debug(Object obj, Object obj2){
		logger.debug(obj+"::["+obj2+"]");
	}
	/**
	 * Info레벨 로그
	 * @param obj
	 */
	public void info(Object obj){
		logger.info(obj);
	}
	/**
	 * Info레벨 로그
	 * @param obj
	 */
	public void info(Object obj, Object obj2){
		logger.info(obj+"::["+obj2+"]");
	}
	
	/**
	 * warn레벨 로그
	 * @param obj
	 */
	public void warn(Object obj){
		logger.warn(obj);
	}
	/**
	 * warn레벨 로그
	 * @param obj
	 */
	public void warn(Object obj, Object obj2){
		logger.warn(obj+"::["+obj2+"]");
	}
	/**
	 * error레벨 로그
	 * @param obj
	 */
	public void error(Object obj){
		logger.error(obj);
	}
	/**
	 * error레벨 로그
	 * @param obj
	 */
	public void error(Object obj, Object obj2){
		logger.error(obj+"::["+obj2+"]");
	}
	/**
	 * fatal레벨 로그
	 * @param obj
	 */
	public void fatal(Object obj){
		logger.fatal(obj);
	}
	/**
	 * fatal레벨 로그
	 * @param obj
	 */
	public void fatal(Object obj, Object obj2){
		logger.fatal(obj+"::["+obj2+"]");
	}
}
