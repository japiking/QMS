package qms.util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import qms.Const;
import qms.session.UserSession;

import sun.misc.BASE64Decoder;
import sun.misc.BASE64Encoder;

public class StringUtil {

	public static String[] noSessionService	= {	"lnb.jsp",
												"Q00101.jsp",
												"Q00102.jsp",
												"Q00101_proc.jsp"
	};
	
	public static String null2void(Object str) {
		if( str == null ) {
			return "";
		}
		
		return (String)str;
	}
	
	public static String null2void(Object str, String def) {
		if( str == null ) {
			return def;
		}
		
		return String.valueOf(str);
	}
	
	public static int null2zero(Object str) {
		if( str == null || "".equals(str) ) {
			return 0;
		}
		
		return Integer.parseInt((String) str);
	}
	
	public static String getBase64Decode(String str) throws Exception {
		BASE64Decoder decoder	= new BASE64Decoder();
		byte[] deBytes			= decoder.decodeBuffer(str);
		return new String(deBytes);
	}
	
	public static String getBase64Encode(String str) throws Exception {
		BASE64Encoder encoder	= new BASE64Encoder();
		return encoder.encode(str.getBytes());
	}
	
	public static boolean isService(HttpServletRequest request) {
		HttpSession session		= request.getSession();
		UserSession userSession	= (UserSession) session.getAttribute(Const.QMS_SESSION_ID);
		if( userSession != null ) {
			return true;
		}
		
		String uri	= request.getRequestURI();
		String jsp  = uri.substring(uri.lastIndexOf("/")+1);
		for( int i = 0; i < noSessionService.length; i++ ) {
			if( noSessionService[i].equals(jsp) ) {
				return true;
			}
		}
		
		return false;
	}
	
}
