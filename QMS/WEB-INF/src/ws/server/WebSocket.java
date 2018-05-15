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
     * 웹 소켓이 연결되면 호출되는 이벤트
     */
    @OnOpen
    public void handleOpen(){
    	LOG.debug("client is now connected...");
    }
    /**
     * 웹 소켓으로부터 메시지가 오면 호출되는 이벤트 
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
     * 웹 소켓이 닫히면 호출되는 이벤트
     */
    @OnClose
    public void handleClose(){
    	LOG.debug("client is now disconnected...");
    }
    /**
     * 웹 소켓이 에러가 나면 호출되는 이벤트
     * @param t
     */
    @OnError
    public void handleError(Throwable t){
        t.printStackTrace();
        LOG.debug(t.getMessage());
    }
}
