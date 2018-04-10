package qms.util;

/******************************************************************************
* @ �� �� ��    : ����Ʈ GATEWAY
* @ ��������    : JSON -> HashMap
* @ �� �� ��    : /smart/gateway/ext/JsonToMap.jsp
* @ �� �� ��    : WEBCASH.CO.KR
* @ �� �� ��    : 2010-01-01
************************** �� �� �� �� ****************************************
* ��ȣ  �� �� ��    ��  ��  ��                       ���泻��
*******************************************************************************
*    1  WEBCASH		2010-01-01      ���� �ۼ�
******************************************************************************/


import java.util.*;

//import net.sf.json.*;

//import sun.misc.BASE64Decode;

import org.codehaus.jackson.map.ObjectMapper;
//import org.codehaus.jackson.type.TypeReference;

public class JacksonJsonToMap
{  
    //�м��� ���.
    private  Map        _parserHashMap;

    //JSON Node �� ���ڵ�Ÿ��
    public  String     _strEncoding;

    //�м��� �߻��� ���� ����
    public  Throwable  _throwable;

    //JSON���ڵ�
    public  String     _strJsonEnc;

    //String ������ ������ ����
    public  StringBuffer _sbCharBuffer;

    //TaskId
    public  String _strTaskId;

    //Target
    public  String _strTarget;

    public JacksonJsonToMap()
    {
        this("euc-kr");
    }
    public JacksonJsonToMap(String enc)
    {
        setJsonEnc(enc);
    }
    public  Map getMap()
    {
        return this._parserHashMap;
    }
   
    public  Map getReqData(){
        return this._parserHashMap;
    }

    /**
     * JSON �����͸� �м��Ͽ� HashMap �� ����
     * @param data
     * @return boolean
     **/
    public  boolean parser(String data)
    {
        try{
//          _parserHashMap = JSONObject.fromObject(data);
            ObjectMapper mapper = new ObjectMapper();
            
            this._parserHashMap = (Map)mapper.readValue(data, Map.class);

            if (!this._parserHashMap.containsKey("_tran_cd")) {
                //�ŷ��ڵ尡 ������ ���� �߻�
                throw new Exception("�ŷ��ڵ尡 �����Ǿ����ϴ�.");
            }
            else {
                // �ŷ��ڵ� �ֱ�
                _strTaskId = (String) this._parserHashMap.get("_tran_cd");
            }
        }
        catch(Exception e) {
            _throwable = e;
            e.printStackTrace(System.out);
            return false;
        }
    
        return true;
    }
 
    public Throwable getThrowable()
    {
        return _throwable;
    }

    public void setJsonEnc(String enc)
    {
        _strJsonEnc = enc;
    }

    public String getJsonEnc()
    {
        return _strJsonEnc;
    }
    /**
     * @return target�� �����մϴ�.
     */
    public String getTarget()
    {
        return _strTarget;
    }
    /**
     * @return taskId�� �����մϴ�.
     */
    public String getTaskId()
    {
        return _strTaskId;
    }
}
