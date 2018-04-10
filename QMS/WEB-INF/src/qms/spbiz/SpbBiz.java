package qms.spbiz;

/******************************************************************************
* @ �� �� ��    : Browser Control / Gateway Service 
* @ ��������    : Control / Gateway ���� ó��
* @ �� �� ��    : /smart/gateway/ext/SpbBiz.jsp
* @ �� �� ��    : WEBCASH.CO.KR
* @ �� �� ��    : 2010-01-01
************************** �� �� �� �� ****************************************
* ��ȣ  �� �� ��    ��  ��  ��                       ���泻��
*******************************************************************************
*    1  WEBCASH		2010-01-01      ���� �ۼ�
******************************************************************************/

import java.util.*;
import javax.servlet.http.*;
//import net.sf.json.*;

public interface SpbBiz {
    /**
     * ID/PASSWORD �α����� �ʿ������� �����Ѵ�.
     * @return true/false
     */
    public boolean isNeedIDLogin();

    /**
     * �ŷ� ������ ó���ϰ� ����� �����Ѵ�.
     * @param request gateway.jsp ���� �Ѱ��� request
     * @param map gateway.jsp�� �Ķ���ͷ� �Ѱ��� json �����͸� map���·� ��ȯ�� ��.
     * @return App�� �ѱ� map ������
     * @throws Exception
     */
    //public Map execute(HttpServletRequest request, Map map) throws Exception;
	public Map execute(HttpSession session, HttpServletRequest request, Map map) throws Exception;

}
