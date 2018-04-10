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
	 * �����ڵ带 ��ȯ�Ѵ�
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
	 * HTML �ڵ带 �����Ѵ�.
	 * @param str html �ڵ尡 ���Ե� ���ڿ�
	 * @return html �ڵ尡 ���ŵ� ���ڿ�
	 */
	public static String htmlClean(String str) {
		return str.replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
	}

	/**
	 * Ÿ�ٰ��¹�ȣ�� �־��� ���¸�� �迭�� ���Ե� �������� ���θ� �����Ѵ�.
	 * @param strArrTemp ���¸��
	 * @param strAcct Ÿ�ٰ��¹�ȣ
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
	 * User-Agent �� Locale ��ȯ
	 * @param request
	 * @return ���𵨸�
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
	 * �־��� ���ڿ� �迭�� Ÿ�ٹ��ڿ��� ���� ���ڿ��� ���ԵǾ� ���� ��� true �����Ѵ�.
	 * @param strArr 
	 * @param str Ÿ�ٹ��ڿ���
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
		//setLog("���䵥����", data); 
    
        try
        {
            out.clear();
        }
        catch(Exception e)
        {}

        if (data != null)
        {
            data = data.replace((char)0x00,(char)0x20);
            
            //URLEncode ���� 2013-03-16
            //data = URLEncoder.encode(data, "UTF-8");
        //    data = new String(data.getBytes("8859_1"), "UTF-8");  
		}
    	
//    	if (xservlet != null) {
//    	
//            try
//            {
//    	  		data = xservlet.csEncrypt(data);
//				//LogUtil.printLog("�����ȣȭ", data);
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
		//setLog("���䵥����", data); 
    
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
	 * �־��� ���̸�ŭ '0'�� ä���.
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
	 * �־��� ���̸�ŭ space�� �����ʿ� ä���.
	 * @param strVal
	 * @param nLength
	 * @return
	 */
	public static String fillSpace(String paramString, int paramInt) {
		return getPadString(paramString, paramInt, " ", 1);
	}
	/**
	 * ���ڿ� ������ ���ϴ� ���ڿ� replace �ϱ�
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
	 * �Էµ� String �� ���ϴ� ���̸�ŭ ä�� ���ڷ� ä���ش�<br>
	 * default �� ���ʿ� blank �� ä��
	 * @param str String ���� ������
	 * @param len int    ���� ������ ����
	 * @return String��ü
	 */
	public static String getPadString(String str, int len) {
	    return getPadString(str, len, " ", 0);
	}
	/**
	 * �Էµ� String �� ���ϴ� ���̸�ŭ ä�� ���ڷ� ä���ش�<br>
	 * default �� ���ʿ� ä��
	 * @param str String ���� ������
	 * @param len int    ���� ������ ����
	 * @param padstr String ä�� ���ڿ�
	 * @return String��ü
	 */
	public static String getPadString(String str, int len, String padstr) {
	    return getPadString(str, len, padstr, 0);
	}

	/**
	 * �Էµ� String �� ���ϴ� ���̸�ŭ ä�� ���ڷ� ä���ش�<br>
	 * �Էµ� lr �� ���� ���� �Ǵ� �����ʿ� ä���ش� default ����
	 * @param str String ���� ������
	 * @param len int    ���� ������ ����
	 * @param padstr String ä�� ���ڿ�, �ϳ��� ���ڷ� �ϴ°��� ����
	 * @param lr int ���ʿ� ä���� �����ʿ� ä���� ����, 0:left(default), 1:right
	 * @return String��ü
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
	 * �Էµ� String �� ���ϴ� ���̸�ŭ ä�� ���ڷ� ä���ش�<br>
	 * �Էµ� lr �� ���� ���� �Ǵ� �����ʿ� ä���ش� default ����
	 * @param str String ���� ������
	 * @param len int    ���� ������ ����
	 * @param padstr String ä�� ���ڿ�, �ϳ��� ���ڷ� �ϴ°��� ����
	 * @param lr int ���ʿ� ä���� �����ʿ� ä���� ����, 0:left(default), 1:right
	 * @return String��ü
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
	 * SqlException ó���ϱ����� �Լ�
	 * @param ex
	 * @return errorCode SqlException �ΰ���� sqlErrorCode
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
			//�ߺ�
			if(errorMsg.contains("SqlException") && errorMsg.contains("SQLCODE")){
				errorCode = errorMsg.substring(errorMsg.indexOf("SQLCODE"));
				errorCode = errorCode.substring(9,errorCode.indexOf(",")).trim();
			}
			//�ߺ�
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
