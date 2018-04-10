package qms.util;

import java.io.IOException;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.JspWriter;
import org.apache.log4j.Logger;

public class BizUtil {
	static Logger LOG = Logger.getLogger(BizUtil.class);
	public static void putAllDataMap(DataMap destMap, Map srcMap) {
		if (destMap != null && srcMap != null) {
			Iterator keySet = srcMap.keySet().iterator();
			Iterator values = srcMap.values().iterator();
			
			while (keySet.hasNext()) {
				destMap.put(keySet.next(), values.next());
			}
		}
	}
	/**
	 * 공통코드를 반환한다
	 * @param dataSet
	 * @return
	 */
	public List getCdList(String code){
		List list = new ArrayList();

		Map map = new HashMap();
		map.put("cd_group"   , "");
		map.put("cd_group_nm" , "");
		map.put("cd_group_eng_nm", "");
		map.put("cd", "");
		map.put("cd_nm", "");
		map.put("cd_eng_nm", "");
		map.put("use_yn", "");
	
		list.add(map);

		return list;
	}	
	/**
	 * HTML 코드를 제거한다.
	 * @param str html 코드가 포함된 문자열
	 * @return html 코드가 제거된 문자열
	 */
	public static String htmlClean(String str) {
		return str.replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
	}

	/**
	 * 타겟계좌번호가 주어진 계좌목록 배열에 포함된 계좌인지 여부를 리턴한다.
	 * @param strArrTemp 계좌목록
	 * @param strAcct 타겟계좌번호
	 */
   	
	public static boolean containsAccount(String[][] strArrTemp, String strAcct) {
		boolean bFound = false;

		if (strArrTemp == null) return bFound;
		if (strAcct == null)	return bFound;
	
		for (int i = 0; i < strArrTemp.length && !bFound ; i++) {
			if (strAcct.equals(strArrTemp[i][0]))		bFound = true;
		}
		return bFound;
	}
	/**
	 * User-Agent 로 Locale 반환
	 * @param request
	 * @return 기기모델명
	 */
	public static String getLocaleCode(HttpServletRequest request) {
		String userAgent = StringUtil.null2void(request.getHeader("User-Agent"));
		String strLocalCode   = "KO";
		int nAppVerIdx = userAgent.indexOf("nma-app-lang=");
		if ( nAppVerIdx != -1 ) {
			userAgent  = userAgent.substring(nAppVerIdx + 13, userAgent.length());
			strLocalCode = userAgent.split(";")[0];
		}
		return strLocalCode;
	}
	/**
	 * 주어진 문자열 배열에 타겟문자열과 같은 문자열이 포함되어 있을 경우 true 리턴한다.
	 * @param strArr 
	 * @param str 타겟문자열과
	 * @return
	 */
	public static boolean containsString(String[] strArr, String str) {

		boolean isContains = false;

		if (strArr == null || strArr.length == 0 || str == null || "".equals(str) ) {
			return isContains;
		}

		for (int i = 0; i < strArr.length; i++) {
			if ( strArr[i].equals(str) ) {
				isContains = true;
				break;
			}
		}

		return isContains;
	}
	public static void sendMatrixData(JspWriter out, String data) throws IOException
    {
        sendMatrixData(out, data, null);
    }

    public static void sendMatrixData(JspWriter out, String data, String xservlet) throws IOException
    {
		//setLog("응답데이터", data); 
    
        try
        {
            out.clear();
        }
        catch(Exception e)
        {}

        if (data != null)
        {
            data = data.replace((char)0x00,(char)0x20);
            
            //URLEncode 제거 2013-03-16
            //data = URLEncoder.encode(data, "UTF-8");
        //    data = new String(data.getBytes("8859_1"), "UTF-8");  
		}
    	
//    	if (xservlet != null) {
//    	
//            try
//            {
//    	  		data = xservlet.csEncrypt(data);
//				//LogUtil.printLog("응답암호화", data);
//            }
//            catch(Exception e)
//            {
//            	LogUtil.printLog("ERROR", "xservlet.csEncrypt error");
//            	e.printStackTrace(System.err);
//            }
//        }  
        out.println(data);
    }
    
    public static void sendMatrixData(JspWriter out, String data, String strLocale, String xservlet) throws IOException
    {
		//setLog("응답데이터", data); 
    
        try
        {
            out.clear();
        }
        catch(Exception e)
        {}

        if (data != null)
        {
        	if("KO".equals(strLocale))
        		data = data.replace((char)0x00,(char)0x20);
            else
            	data = new String(data.getBytes("8859_1"), "UTF-8");
		}

        out.println(data);
    }
    
    /**
	 * 주어진 길이만큼 '0'을 채운다.
	 * @param nVal
	 * @param length
	 * @return
	 */
	public static String fillZero(double paramDouble, int paramInt) {
		String str1 = "";
		String str2 = "";
		for (int i = 0; i < paramInt; i++) {
			str1 = str1 + "0";
		}

		if (str1 != null) {
			str2 = new DecimalFormat(str1).format(paramDouble);
		}

		return str2;
	}
	/**
	 * 주어진 길이만큼 space를 오른쪽에 채운다.
	 * @param strVal
	 * @param nLength
	 * @return
	 */
	public static String fillSpace(String paramString, int paramInt) {
		return getPadString(paramString, paramInt, " ", 1);
	}
	/**
	 * 문자열 내에서 원하는 문자열 replace 하기
	 * @param oldString
	 * @param from
	 * @param to
	 * @return
	 */
	public static String replace(String paramString1, String paramString2,
			String paramString3) {
		String str = paramString1;
		int i = 0;
		while ((i = str.indexOf(paramString2, i)) > -1) {
			StringBuffer localStringBuffer = new StringBuffer(str.substring(0,
					i));
			localStringBuffer.append(paramString3);
			localStringBuffer.append(str.substring(i + paramString2.length()));
			str = localStringBuffer.toString();
			i++;
		}

		return str;
	}
	/**
	 * 입력된 String 을 원하는 길이만큼 채울 문자로 채워준다<br>
	 * default 로 왼쪽에 blank 로 채움
	 * @param str String 원본 데이터
	 * @param len int    최종 데이터 길이
	 * @return String객체
	 */
	public static String getPadString(String str, int len) {
	    return getPadString(str, len, " ", 0);
	}
	/**
	 * 입력된 String 을 원하는 길이만큼 채울 문자로 채워준다<br>
	 * default 로 왼쪽에 채움
	 * @param str String 원본 데이터
	 * @param len int    최종 데이터 길이
	 * @param padstr String 채울 문자열
	 * @return String객체
	 */
	public static String getPadString(String str, int len, String padstr) {
	    return getPadString(str, len, padstr, 0);
	}

	/**
	 * 입력된 String 을 원하는 길이만큼 채울 문자로 채워준다<br>
	 * 입력된 lr 에 따라 왼쪽 또는 오른쪽에 채워준다 default 왼쪽
	 * @param str String 원본 데이터
	 * @param len int    최종 데이터 길이
	 * @param padstr String 채울 문자열, 하나의 문자로 하는것을 권장
	 * @param lr int 왼쪽에 채울지 오른쪽에 채울지 지정, 0:left(default), 1:right
	 * @return String객체
	 */
	public static String getPadString2(String str, int len, String padstr, int lr) {
		try {
			int totlength = 0;
			for(int i = 0; i < str.length(); i++) {
				if( str.substring(i, i+1).getBytes().length > 1 )
					totlength += 2;
				else
					totlength += 1;
			}

			while( totlength < len ) {
				if(lr == 0) {
					str = padstr + str;
				} else {
					str = str + padstr;
				}

				totlength++;
			}

		} catch(Exception e) {
			e.printStackTrace();
		}

		return str;
	}

	/**
	 * 입력된 String 을 원하는 길이만큼 채울 문자로 채워준다<br>
	 * 입력된 lr 에 따라 왼쪽 또는 오른쪽에 채워준다 default 왼쪽
	 * @param str String 원본 데이터
	 * @param len int    최종 데이터 길이
	 * @param padstr String 채울 문자열, 하나의 문자로 하는것을 권장
	 * @param lr int 왼쪽에 채울지 오른쪽에 채울지 지정, 0:left(default), 1:right
	 * @return String객체
	 */
	public static String getPadString(String str, int len, String padstr, int lr) {
	    String rtnstr = "";
	    str = StringUtil.null2void(str);
	    if(str.length() >= len) {
	        return str;
	    } else {
	        if(lr == 1) {
	            rtnstr = str + padstr;
	        } else {
	            rtnstr = padstr + str;
	        }

	        if(rtnstr.length() < len) {
	            return getPadString(rtnstr, len, padstr, lr);
	        } else {
	            return rtnstr;
	        }
	    }
	}
	
	/**
	 * SqlException 처리하기위한 함수
	 * @param ex
	 * @return errorCode SqlException 인경우의 sqlErrorCode
	 */
	public static String processSqlException(Throwable ex){
		
		String[] persisExMsgArray = ex.getMessage().split("###");
		String errorCode = new String("");
		String errorMsg = new String("");
		
		LOG.error(""+ex.getClass());
		LOG.error(""+ex.getMessage());
		
		for(int i=0; i < persisExMsgArray.length; i++){
			if(persisExMsgArray[i].contains("Cause")){
				errorMsg = persisExMsgArray[i];
			}
		}
		
		if( 0 !=  errorMsg.length()){
			//중복
			if(errorMsg.contains("SqlException") && errorMsg.contains("SQLCODE")){
				errorCode = errorMsg.substring(errorMsg.indexOf("SQLCODE"));
				errorCode = errorCode.substring(9,errorCode.indexOf(",")).trim();
			}
			//중복
			else if(errorMsg.contains("DuplicateKeyException")){
				errorCode = "-803";
			}
			// Connect Exception
			else if(errorMsg.contains("ConnectException")){
				errorCode = "-4499";
			}
		}
		
		return errorCode;
	}
}
