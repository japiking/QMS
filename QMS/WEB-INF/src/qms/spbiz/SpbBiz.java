package qms.spbiz;

/******************************************************************************
* @ 업 무 명    : Browser Control / Gateway Service 
* @ 업무설명    : Control / Gateway 로직 처리
* @ 파 일 명    : /smart/gateway/ext/SpbBiz.jsp
* @ 작 성 자    : WEBCASH.CO.KR
* @ 작 성 일    : 2010-01-01
************************** 변 경 이 력 ****************************************
* 번호  작 업 자    작  업  일                       변경내용
*******************************************************************************
*    1  WEBCASH		2010-01-01      최초 작성
******************************************************************************/

import java.util.*;
import javax.servlet.http.*;
//import net.sf.json.*;

public interface SpbBiz {
    /**
     * ID/PASSWORD 로그인이 필요한지를 리턴한다.
     * @return true/false
     */
    public boolean isNeedIDLogin();

    /**
     * 거래 로직을 처리하고 결과를 리턴한다.
     * @param request gateway.jsp 에서 넘겨진 request
     * @param map gateway.jsp의 파라미터로 넘겨진 json 데이터를 map형태로 변환한 것.
     * @return App에 넘길 map 데이터
     * @throws Exception
     */
    //public Map execute(HttpServletRequest request, Map map) throws Exception;
	public Map execute(HttpSession session, HttpServletRequest request, Map map) throws Exception;

}
