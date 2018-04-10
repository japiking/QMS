package qms.util;

import java.io.FileInputStream;
import java.io.IOException;
import java.util.Properties;

import org.apache.log4j.Logger;

public class PropertyUtil {
	
	private static PropertyUtil propertyUtil = new PropertyUtil();
	private static Properties moimProp = null;
	static Logger LOG = Logger.getLogger(PropertyUtil.class);
	
	private PropertyUtil(){
		
	}
	
	public static PropertyUtil getInstance(){
		if(null == propertyUtil){
			propertyUtil = new PropertyUtil();
		}
		return propertyUtil;
	}
	
	public Properties readProperties(){
		
		moimProp = new Properties();
		
		FileInputStream fis = null;
		try {
			fis = new FileInputStream(getRootPath()+"/properties/qms.properties");
			moimProp.load(new java.io.BufferedInputStream(fis));
			
			LOG.debug("================================================");
			LOG.debug("ROAD PropertyUtil                        -------");
			LOG.debug("================================================");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			LOG.debug("==================================================");
			LOG.debug("PropertyUtil Exception");
			LOG.debug(e.getMessage());
			LOG.debug("==================================================");
			e.printStackTrace();
		}finally{
			try {
				fis.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
		return moimProp;
	}
	
	public String getProperty(String propertyId){
		String strProp = new String();
		
		if(null == moimProp){
			moimProp = readProperties();
		}
		
		try {
			strProp = new String(moimProp.getProperty(propertyId).getBytes("ISO-8859-1"));
			if(strProp == "") strProp = new String(moimProp.getProperty("DEFAULT").getBytes("ISO-8859-1"));
			
		} catch (Exception e) {
			LOG.debug("======================================================");
			LOG.debug("getProperty Exception");
			LOG.debug(e.getMessage());
			LOG.debug("======================================================");
			try{
				strProp = new String(moimProp.getProperty("DEFAULT").getBytes("ISO-8859-1"), "UTF-8");				
			}catch(Exception ex){
				strProp = "";
				ex.getMessage();
			}
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return strProp;
	}
	
	public void reload(){
		if(null == propertyUtil){
			propertyUtil = new PropertyUtil();
		}
		readProperties();
	}
	
	public String getRootPath(){
		int index = this.getClass().getResource("").getPath().indexOf("classes/");
		return PropertyUtil.class.getResource("").getPath().substring(0, index);
	}
}
