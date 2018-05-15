package ws.server;
import java.io.IOException;

import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.server.ServerEndpoint;
import javax.websocket.Session;
import org.apache.log4j.Logger;

@ServerEndpoint("/websocket")
public class WebSocket {
	static Logger LOG = Logger.getLogger(WebSocket.class);
    /***
     * �� ������ ����Ǹ� ȣ��Ǵ� �̺�Ʈ
     */
    @OnOpen
    public void handleOpen(){
    	LOG.debug("client is now connected...");
    }
    /**
     * �� �������κ��� �޽����� ���� ȣ��Ǵ� �̺�Ʈ 
     * @param message
     * @return
     */
    @OnMessage
    public String handleMessage(String message, Session userSession) throws IOException{
    	LOG.debug("receive from client : "+message);
        String replymessage = "echo "+message;
        LOG.debug("send to client : "+replymessage);
        
        userSession.getUserProperties().put("NAME", "SANGJIN");
        userSession.getUserProperties().get("NAME");
        
        userSession.getBasicRemote().sendText("LSJ----------->>>111");
        
        return replymessage;
    }
    /**
     * �� ������ ������ ȣ��Ǵ� �̺�Ʈ
     */
    @OnClose
    public void handleClose(){
    	LOG.debug("client is now disconnected...");
    }
    /**
     * �� ������ ������ ���� ȣ��Ǵ� �̺�Ʈ
     * @param t
     */
    @OnError
    public void handleError(Throwable t){
        t.printStackTrace();
        LOG.debug(t.getMessage());
    }
}
