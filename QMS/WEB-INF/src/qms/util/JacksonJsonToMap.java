package qms.util;

/******************************************************************************
* @ 업 무 명    : 스마트 GATEWAY
* @ 업무설명    : JSON -> HashMap
* @ 파 일 명    : /smart/gateway/ext/JsonToMap.jsp
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
//import org.codehaus.jackson.type.TypeReference;

public class JacksonJsonToMap
{  
    //분석된 결과.
    private  Map        _parserHashMap;

    //JSON Node 의 인코딩타입
    public  String     _strEncoding;

    //분석중 발생한 오류 정보
    public  Throwable  _throwable;

    //JSON인코딩
    public  String     _strJsonEnc;

    //String 정보를 저장할 버퍼
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
     * JSON 데이터를 분석하여 HashMap 에 세팅
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
                //거래코드가 없으면 오류 발생
                throw new Exception("거래코드가 누락되었습니다.");
            }
            else {
                // 거래코드 넣기
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
     * @return target을 리턴합니다.
     */
    public String getTarget()
    {
        return _strTarget;
    }
    /**
     * @return taskId을 리턴합니다.
     */
    public String getTaskId()
    {
        return _strTaskId;
    }
}
