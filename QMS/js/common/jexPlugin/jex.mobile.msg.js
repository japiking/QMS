(function() {
	/**
	 * Message 정의
	 */
	var _JexMessage = JexMsg.extend({
		init:function() {
		},printInfo	:function(code,msg){
			var m = {};
			m['TYPE'] = "INFO";
			m['CODE'] = code;
			m['MSG' ] = (msg)?msg:jex.getMsg(code);
			this.addMsg(m);
		},printError:function(code,msg){
			//ADD 2013.11.12 from 앱통장
			ComPopup.showErrorPopup(code, msg);
			return;
			//END
			/*var m = {};
			m['TYPE'] = "ERROR";
			m['CODE'] = code;
			m['MSG' ] = (msg)?msg:jex.getMsg(code);
			this.addMsg(m);*/
		},addMsg:function(m) {
			alert(m['MSG']);
		}
	});
	jex.setMsgObj(new _JexMessage());	
})();