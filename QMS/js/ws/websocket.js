  var wSocket = new WebSocket("ws:yourdomain/demo");
  
  wSocket.onmessage = function(e){  alert(e.data);  }  

  wSocket.onopen = function(e){ alert("서버 연결 완료"); } 
  wSocket.onclose = function(e){ alert("서버 연결 종료"); }  

  function send(){ //서버로 데이터를 전송하는 메서드
    wSocket.send("Hello");
  }
