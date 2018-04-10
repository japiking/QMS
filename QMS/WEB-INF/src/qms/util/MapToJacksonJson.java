package qms.util;

/******************************************************************************
* @ �� �� ��    : ����Ʈ GATEWAY 
* @ ��������    : HashMap -> JSON
* @ �� �� ��    : /smart/gateway/ext/MapToJson.jsp
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

public class MapToJacksonJson
{
    public static final String TOKEN_COLUMN = " " + ((char) 1) + " ";
    public static final String TOKEN_ROW = "" + ((char) 2);

    public String _strJsonEnc;

    public boolean _bCompress = false;

    public String _strTaskId;

    public String _strSubTaskId;

    public MapToJacksonJson(String enc) {
        this(enc, false);
    }

    public MapToJacksonJson(boolean comp) {
        this("euc-kr", comp);
    }

    public MapToJacksonJson(String enc, boolean comp) {
        this(enc, TOKEN_ROW, TOKEN_COLUMN, comp);
    }

    public MapToJacksonJson(String enc, String row, String col, boolean comp) {
        setJsonEnc(enc);
        this._bCompress = comp;
    }

    public String getTaskId() {
        return this._strTaskId;
    }

    public boolean isCompressMode() {
        return this._bCompress;
    }

    /**
     * Map�� �м��Ͽ� JSON �� ����
     * @param map
     * @return byte[]
     **/
    public byte[] parser(Map map) {
    	
//      JSONObject jsonOut = null;
        String jsonOut = "";
        
        try {
//        	jsonOut = JSONObject.fromObject(map);
        	
        	ObjectMapper mapper = new ObjectMapper();
        	jsonOut = mapper.writeValueAsString(map);
        	
        } catch (Exception e) {
        	e.printStackTrace();
        }
        return jsonOut.toString().getBytes();
    }

    public void setJsonEnc(String enc) {
    	this._strJsonEnc = enc;
    }

    public String getJsonEnc() {
        return this._strJsonEnc;
    }
}
