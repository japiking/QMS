package qms.db;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;

import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;
import org.apache.log4j.Logger;

import qms.util.PropertyUtil;

/**
 * MyBatis DB연결을 위한 SqlSessionFactory 생성
 * @author jin
 *
 */
public class DBConnectManager {
	
	private static DBConnectManager dbConnectManager = new DBConnectManager();
	private static SqlSessionFactory dbSession = null;
	private static final String _PATH = PropertyUtil.getInstance().getProperty("rootPath");	// /home/qms/WebContent/
	private static final String _MYBATIS_CONFIG = "/WEB-INF/config/myBatisConfig.xml";
	
	static Logger LOG = Logger.getLogger(DBConnectManager.class);
	 
	private DBConnectManager(){
		
	}
	
	/**
	 * DBConnectManager 인스턴스 리턴
	 * @return
	 */
	public static DBConnectManager getInstance(){
		if(null == dbConnectManager){
			dbConnectManager = new DBConnectManager();
		}
		return dbConnectManager;
	}
	
	/**
	 * DB Connection 
	 */
	private void connDBSession(){
		LOG.info("================================================");
		LOG.info("ROAD DBConnectManager                    -------");
		LOG.info("================================================");
		try{
			InputStream inputStream = new FileInputStream(_PATH  + _MYBATIS_CONFIG);
			dbSession = new SqlSessionFactoryBuilder().build(inputStream);
			
			if(dbSession == null) {
				LOG.debug("dbSession is Null");
			}
		}catch(IOException e){
			dbSession = null;
			e.printStackTrace();
		}
	}
	
	public SqlSessionFactory getDBSession(){
		synchronized(this){ 
			if(null == dbSession){	
				connDBSession();
			}
		}
		return dbSession;
	}
	/**
	 * Connection 다시 연결
	 */
	public void reload(){
		if(null == dbConnectManager){
			dbConnectManager = new DBConnectManager();
		}
		connDBSession();
	}
	
}
