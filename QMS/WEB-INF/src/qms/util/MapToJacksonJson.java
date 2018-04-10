package qms.util;

/******************************************************************************
* @ 업 무 명    : 스마트 GATEWAY 
* @ 업무설명    : HashMap -> JSON
* @ 파 일 명    : /smart/gateway/ext/MapToJson.jsp
* @ 작 성 자    : WEBCASH.CO.KR
* @ 작 성 일    : 2010-01-01
************************** 변 경 이 력 ****************************************
* 번호  작 업 자    작  업  일                       변경내용
*******************************************************************************
*    1  WEBCASH		2010-01-01      최초 작성
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
     * Map을 분석하여 JSON 에 세팅
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
