/*******************************************************************************
 * Jex Script Framework
 * 
 * 현재 Jex 개발은 김학길에 의해 주도적으로 이루어지고 있으며, 해당 script의 변경에 의한
 * 기술 지원 및 문의는 받지 않습니다.
 * 
 * jex.core.js 의 경우 아직까지는 협업에 대한 고려가 되어 있지 않아.
 * 
 * 김학길 외에 수정시에는 요청(연락) 부탁드립니다.
 * 
 * 
 * @author - 김학길 (ellin@coji.net)
 *******************************************************************************/
/**
 * 할일 : String 확장 / JSON 확장 / Array 확장 / DateUtil 구현 / Exception 구현, 처리 --
 * dataType를 json으로 바꾸자
 */

/*
 * Simple JavaScript Inheritance By John Resig http://ejohn.org/ MIT Licensed.
 */
var pageJobs2 = undefined;

var _jex = function() {
	this.version = 0.1;
	this.type = "jex";
	this.locale = "DF";
	this.ajaxSetup = {
		dataType : "text",
		beforeSend : function() {
		},
		complete : function() {
		},
		async : true,
		cache : true,
		error : function() {
		}
	};
	this.ajaxBeforeSend = []; // AJAX쏘기전 API
	this.ajaxBeforeData; // AJAX쏘기전에 Input값 데이터 처리를 해준다.
	this.ajaxComplete = []; // AJAX쏜 이후 API
	this.ajaxCompleteData; // AJAX쏜 이후에 Output값 데이터를 처리 해준다.
	this.ajaxExt = ".jsp"; // .jct
	this.ajaxURL = "";
	this.ajaxErrFn = undefined;
	this.ajaxHeader = {
		"charset"	: "utf-8"
/*		"cache-control" : "no-cache",
		"pragma" : "no-cache"*/
	};
	this.debuggerId = "jexDebugger";
	this.messageId = "jexMessage";
	this.debug = true;
	this.errorHandler = [];
	this.debugHeader = [ {
		id : "type",
		style : "width:30px"
	}, {
		id : "code",
		style : "width:50px"
	}, {
		id : "msg",
		style : "width:200px"
	}, {
		id : "detail",
		style : "width:250px"
	}, {
		id : "time",
		style : "50px"
	} ];
	this.debuggerObj;
	this.msgObj;
	this.msgId = "jexMessage";
	this.cache = {};
	this.pageLoader = [];
	this.msgFn = function(code) {
		return code;
	};
	this.isJSONExp = /(^{[^}]+})|^\[[^\]]+\]/;
	this.height = 0;
	this.rootDom = undefined;
	this.rootDomIncPrnt = undefined;
	this.jobManager = undefined;
	this.afterOnload = [];
	this.beforeOnload = [];
	this.onload = false;
	this.deviceGroup = {};
	this.globalSetAllFormatter = {};
	this.globalGetAllFormatter = {};
};
_jex.instance = new _jex();
_jex.getInstance = function() {
	return _jex.instance;
};
_jex.prototype.createAjaxUtil = function(svc, ext, url) {
	return new _jexAjaxUtil(svc, (jex.isNull(ext)) ? this.ajaxExt : ext, (jex
			.isNull(url) ? this.ajaxURL : url));
};
_jex.prototype.isNull = function(dat) {
	return dat == undefined || typeof (dat) == undefined || dat == null
			|| (typeof (dat) == "string" && $.trim(dat) == "");
};
_jex.prototype.null2Void = function(dat) {
	return _jex.getInstance().isNull(dat) ? "" : dat;
};
_jex.prototype.null2Str = function(dat, str) {
	return _jex.getInstance().isNull(dat) ? str : dat;
};
_jex.prototype.null2Array = function(dat) {
	return _jex.getInstance().isNull(dat) ? [] : dat;
};
_jex.prototype.isError = function(dat) {
	return dat["_tran_res_data"][0]["IS_ERROR"] == "true" ? true : false;
};
_jex.prototype.hasSubError = function(dat) {
	return dat['COMMON_HEAD']['SUB_ERROR'].length > 0 ? true : false;
};
_jex.prototype.getSubError = function(dat) {
	return dat['COMMON_HEAD']['SUB_ERROR'].length > 0 ? dat['COMMON_HEAD']['SUB_ERROR']
			: [];
};
_jex.prototype.setJobManager = function(jm) {
	this.jobManager = jm;
};
_jex.prototype.getJobManager = function() {
	return this.jobManager;
};
_jex.prototype.setAjaxErrFn = function(fn) {
	this.ajaxErrFn = fn;
};
_jex.prototype.getAjaxErrFn = function() {
	return this.ajaxErrFn;
};
_jex.prototype.setAjaxExt = function(s) {
	this.ajaxExt = s;
};
_jex.prototype.setAjaxURL = function(s) {
	this.ajaxURL = s;
};
_jex.prototype.addErrorHandler = function(type, fn) {
	this.errorHandler.push({
		"type" : type,
		"fn" : fn
	});
}; // Error처리관련 Type은 오류코드 앞 2자리로 하자.
_jex.prototype.setDebugger = function(obj) {
	this.debuggerObj = obj;
};
_jex.prototype.getDebugger = function() {
	return this.debuggerObj;
};
_jex.prototype.getDebuggerId = function() {
	return this.debuggerId;
};
_jex.prototype.getMicroTime = function() {
	return new Date().getTime();
};
_jex.prototype.printDebug = function(msg) {
	if (!_jex.getInstance().isNull(this.debuggerObj))
		this.debuggerObj.printDebug(msg);
};
_jex.prototype.printInfo = function(code, msg) {
	if (!_jex.getInstance().isNull(this.debuggerObj))
		this.debuggerObj.printInfo(code, msg);
	if (!_jex.getInstance().isNull(this.msgObj))
		this.msgObj.printInfo(code, msg);
};
_jex.prototype.printError = function(code, msg) {
	if (!_jex.getInstance().isNull(this.debuggerObj))
		this.debuggerObj.printError(code, msg);
	if (!_jex.getInstance().isNull(this.msgObj))
		this.msgObj.printError(code, msg);
};
_jex.prototype.isRootDom = function() {
	return (parent.window == window);
};
_jex.prototype.getAll = function(selector) {
	return $(selector).getAll();
};
/*
 * _jex.prototype.setAll = function(selector,dat,formatter,useJexObj){ return
 * $(selector).setAll(dat,formatter,useJexObj); };
 */
_jex.prototype.setAll = function(selector, dat, formatter, useJexObj, fnName) {
	return $(selector).setAll(dat, formatter, useJexObj, fnName);
};
_jex.prototype.checkException = function(e) {
	if (e && e.onError && typeof (e.onError) == "function") {
		e.onError();
	} else
		throw e;
};
_jex.prototype.checkException = function(e) {
	if (e && e.onError && typeof (e.onError) == "function") {
		e.onError();
	} else
		throw e;
};
_jex.prototype.addSetAllFormatter = function(key, fn) {
	this.globalSetAllFormatter[key] = fn;
};
_jex.prototype.getSetAllFormatter = function() {
	return this.globalSetAllFormatter;
};
_jex.prototype.addGetAllFormatter = function(key, fn) {
	this.globalGetAllFormatter[key] = fn;
};
_jex.prototype.getGetAllFormatter = function() {
	return this.globalGetAllFormatter;
};
_jex.prototype.addAjaxHeader = function(key, val) {
	this.ajaxHeader[key] = val;
};
_jex.prototype.getAjaxHeader = function() {
	return this.ajaxHeader;
};
_jex.prototype.confirm = function(code, msg) {
	var fullMsg = _jex.getInstance().getMsg(code);
	var re = /%[0-9]+%/g;
	var arr = [];
	var temp;
	first_loop: while ((temp = re.exec(fullMsg)) != null) {
		for ( var i = 0; i < arr.length; i++) {
			if (arr[i].key == temp[0])
				continue first_loop;
		}

		var msgidx = /[0-9]+/g.exec(temp[0])[0];
		var replaceVal = _jex.getInstance().null2Void(arguments[msgidx]);

		arr.push({
			key : temp[0],
			val : replaceVal
		});
	}

	for ( var i = 0; i < arr.length; i++) {
		var _re = new RegExp(arr[i].key, 'g');
		fullMsg = fullMsg.replace(_re, arr[i].val);
	}

	return confirm(fullMsg);
};
_jex.prototype.isJSON = function(dat) {
	return this.isJSONExp.test(dat);
};
_jex.prototype.set = function(key, data) {
	this.cache[key] = data;
};
_jex.prototype.get = function(key) {
	return this.cache[key];
};
_jex.prototype.toStr = function(dat) {
	if (typeof (JSON.stringify) != "function")
		throw new JexSysException("json2.js가 inculde가 되어 있지 않습니다.");
	return JSON.stringify(dat);
};
_jex.prototype.parse = function(dat) {
	if (dat == undefined || $.trim(dat) == "")
		return undefined;
	if (typeof (JSON.parse) != "function")
		throw new JexSysException("json2.js가 inculde가 되어 있지 않습니다.");
	return JSON.parse(dat);
};
_jex.prototype.getMsg = function() {
	return this.msgFn(arguments);
};
_jex.prototype.getMsgId = function(dat) {
	return this.msgId;
};
_jex.prototype.setMsgFn = function(dat) {
	this.msgFn = dat;
};
_jex.prototype.lang = function() {
	return this.locale;
};
_jex.prototype.setLang = function(dat) {
	this.locale = dat;
};
_jex.prototype.hide = function(attr) {
	return $.each($("[" + attr + "]"), function() {
		$(this).hide();
	});
};
_jex.prototype.show = function(attr) {
	return $.each($("[" + attr + "]"), function() {
		$(this).show();
	});
};
_jex.prototype.getOpener = function() {
	return (!opener) ? parent : opener;
};
_jex.prototype.isDebug = function() {
	return this.debug;
};
_jex.prototype.setMsgObj = function(obj) {
	this.msgObj = obj;
};
_jex.prototype.getMsgObj = function() {
	return this.msgObj;
};
_jex.prototype.getMsgId = function() {
	return this.messageId;
};

//20130625 수정
/*_jex.prototype.setJexObj = function($range) {
	var attributes = jex.plugin.getAttributes();
	for (key in attributes) {
		var attr = jex.plugin.getAttribute(key);
		var $jq = $range.find("[" + attr + "]");
		var rAttr = $range.attr(attr); // 20130507 - table tr 태그에도 executer
										// 플러그인 가능하도록 수정
		if ("undefined" != typeof (rAttr)) { // 20130509 수정
			$jq.push($range);
		}
		// 20130507 end
		for ( var i = 0; i < $jq.length; i++) {
			var plugin = jex.plugin.get(key);
			if (typeof (plugin) == "function")
				plugin = jex.plugin.newInstance(key);
			plugin._setJexAttrName(key);
			var $obj = $($jq.get(i));
			var jex_obj_list = $obj.data("_jex_obj");
			if (!jex_obj_list)
				jex_obj_list = [];
			jex_obj_list.push(plugin);
			$obj.data("_jex_obj", jex_obj_list);
			plugin.load(attr, $obj);
		}
	}
};*/

//20130625 from 본사 
/*_jex.prototype.setJexObj				= function($range) 		{ 			
	var attributes = jex.plugin.getAttributes();
	for (key in attributes) {
		var attr		= jex.plugin.getAttribute(key);
		var $jq 		= $range.find("["+attr+"]");
		var rAttr = $range.attr(attr);	 	 // 20130507 - table tr 태그에도 executer
											 // 플러그인 가능하도록 수정
		if ("undefined" != typeof (rAttr)) { // 20130509 수정
			$jq.push($range);
		}
		
		for (var i=0; i<$jq.length; i++) {
			var $obj					= 	$($jq.get(i));
			var jex_obj_list 	= $obj.data("_jex_obj");
			
			if (!jex_obj_list) {
				jex_obj_list = [];
			} else {
				var isContinue = false;
				for (var jj=0; jj<jex_obj_list.length; jj++) {
					if (jex_obj_list[jj]._getJexAttrName() == key) {
						isContinue = true;
						break;
					}
				}
				if (isContinue) continue;
			}
			
			var plugin		= jex.plugin.get(key);
			if (typeof(plugin) == "function") plugin = jex.plugin.newInstance(key);
			plugin._setJexAttrName(key);
			
			jex_obj_list.push(plugin);
			$obj.data("_jex_obj", jex_obj_list);
			plugin.load(attr, $obj);
		}
	}
};*/

//20130625 from kiup
_jex.prototype.setJexObj				= function($range) 		{ 			
	var attributes = jex.plugin.getAttributes();
	for (key in attributes) {
		var attr		= jex.plugin.getAttribute(key);
		var $jq 		= $range.find("["+attr+"]");
		var rAttr = $range.attr(attr);	 	 // 20130507 - table tr 태그에도 executer 플러그인 가능하도록 수정
		var havePlugin = false;				 // 20130625 - 플러그인 가지고 있는 경우에는 load 함수만 수행되도록 변경
		if ("undefined" != typeof (rAttr)) { // 20130509 수정
			$jq.push($range);
		}
		for (var i=0; i<$jq.length; i++) {
			var $obj					= 	$($jq.get(i));
			var jex_obj_list 	= $obj.data("_jex_obj");
			havePlugin = false;				//초기화
			if (!jex_obj_list) {
				jex_obj_list = [];
			} else {
				//var isContinue = true;
				for (var jj=0; jj<jex_obj_list.length; jj++) {
					if (jex_obj_list[jj]._getJexAttrName() == key) {
						//isContinue = true;
						havePlugin = true;
						break;
					}
				}
			//	if (isContinue) continue;
			}
			var plugin		= jex.plugin.get(key);
			if (typeof(plugin) == "function") plugin = jex.plugin.newInstance(key);
			if(!havePlugin){				// 20130625 - 플러그인 가지고 있는 경우에는 load 함수만 수행되도록 변경
				plugin._setJexAttrName(key);
				jex_obj_list.push(plugin);
				$obj.data("_jex_obj", jex_obj_list);
			}
			plugin.load(attr, $obj);
		}
	}
};

_jex.prototype.getJexObj = function($jq, attr) {
	if (typeof ($jq) == 'string')
		$jq = $($jq);
	var jexObj = $jq.data("_jex_obj");
	// if (!attr && null == jexObj) return jexObj;

	if (null == attr || "" === attr || null == jexObj)
		return jexObj;

	for ( var i = 0; i < jexObj.length; i++) {
		var attrName = jexObj[i]._getJexAttrName();
		if (attrName == attr)
			return jexObj[i];
	}
	return undefined;
};

_jex.prototype.rmJexObj = function($jq, attr) {
    if (typeof $jq === "string")    $jq = $($jq);

    var jexObj = $jq.data("_jex_obj");

    if (!attr || !jexObj)      return;

    for (var i = 0; i < jexObj.length; i++) {
        if (jexObj[i]._getJexAttrName() === attr) {
            jexObj.splice(i, 1);
        }
    }
}

_jex.prototype.checkDevice = function(grp) {
	var agent = navigator.userAgent;
	var checkList = this.deviceGroup[grp];

	var tester = jex.getQString()['tester'];
	if (tester)
		agent = tester + "00";

	if ("all" == grp)
		return true;
	if (!checkList)
		return false;

	for ( var ii = 0; ii < checkList.length; ii++) {
		var checker = new RegExp(checkList[ii]);
		if (checker.test(agent))
			return true;
		;
	}
	return false;
};

_jex.prototype.addDeviceGroup = function(grp, agent) {
	if (!this.deviceGroup[grp])
		this.deviceGroup[grp] = [];
	this.deviceGroup[grp].push(agent);
};

_jex.prototype.getDocHeight = function() {
	var D = document;
	try {
		this.height = Math.max(Math.max(D.body.scrollHeight,
				D.documentElement.scrollHeight), Math.max(D.body.offsetHeight,
				D.documentElement.offsetHeight), Math.max(D.body.clientHeight,
				D.documentElement.clientHeight));
	} catch (e) {
		;
	}
	return this.height;
};
_jex.prototype.getWindowHeight = function() {
	var winH = 460;
	if (document.body && document.body.offsetWidth)
		winH = document.body.offsetHeight;
	if (document.compatMode == 'CSS1Compat' && document.documentElement
			&& document.documentElement.offsetWidth)
		winH = document.documentElement.offsetHeight;
	if (window.innerWidth && window.innerHeight)
		winH = window.innerHeight;
	return winH;
};

_jex.prototype.getWindowWidth = function() {
	var winW = 630;
	if (document.body && document.body.offsetWidth)
		winW = document.body.offsetWidth;

	if (document.compatMode == 'CSS1Compat' && document.documentElement
			&& document.documentElement.offsetWidth)
		winW = document.documentElement.offsetWidth;
	if (window.innerWidth && window.innerHeight)
		winW = window.innerWidth;
	return winW;
};

_jex.prototype.getRootDom = function(p, bp) {
	if (!_jex.getInstance().isNull(this.rootDom))
		return this.rootDom;
	if (_jex.getInstance().isNull(p)) {
		// p = (jex.isNull(opener))?parent:opener;
		p = parent;
		bp = window;
	}
	if (p === bp)
		this.rootDom = bp;
	else
		this.rootDom = this.getRootDom(p.parent, p);

	if (!bp.jex)
		this.rootDom = bp;

	return this.rootDom;
};
_jex.prototype.getRootDomIncPrnt = function(p, bp) {
	if (!_jex.getInstance().isNull(this.rootDomIncPrnt))
		return this.rootDomIncPrnt;
	if (_jex.getInstance().isNull(p)) {
		p = (_jex.getInstance().isNull(opener)) ? parent : opener;
		bp = window;
	}
	if (p === bp)
		this.rootDomIncPrnt = bp;
	else
		this.rootDomIncPrnt = this.getRootDomIncPrnt((_jex.getInstance()
				.isNull(p.opener)) ? p.parent : p.opener, p);

	if (!bp.jex)
		this.rootDomIncPrnt = bp;

	return this.rootDomIncPrnt;
};
_jex.prototype.addAfterOnload = function(fn) {
	if (!this.onload) {
		this.afterOnload.push(fn);
	} else {
		fn();
	}
};
_jex.prototype.addBeforeOnload = function(fn) {
	if (!this.onload) {
		this.beforeOnload.push(fn);
	} else {
		fn();
	}
};
_jex.prototype.getAfterOnload = function(fn) {
	return this.afterOnload;
};
_jex.prototype.getBeforeOnload = function(fn) {
	return this.beforeOnload;
};
_jex.prototype.isOnload = function(b) {
	if (b != undefined) {
		this.onload = b;
	}
	return b;
};

_jex.prototype.cloneJSON = function(o, filter) {
	var rslt = {};
	for ( var item in o) {
		if (filter == undefined || filter(item))
			rslt[item] = o[item];
	}
	return rslt;
};
_jex.prototype.cloneArray = function(o, filter) {
	var rslt = [];
	for ( var item in o) {
		if (filter == undefined || filter(item))
			rslt[item] = o[item];
	}
	return rslt;
};

/**
 * Executer를 바인딩 해준다.
 * 
 * @param _this
 */
_jex.prototype.bindExecuter = function(_executer, action, $jq) {
	if (!_executer)
		return;

	var svcExtAtt = ".html";

	if (typeof (_executer) == 'string') {
		executeList = _executer.split(",");

		for ( var jj = 0; jj < executeList.length; jj++) {
			var exec = executeList[jj];
			var execs;

			if (exec.indexOf("@") > -1) {
				execs = exec.split("@");
				if (execs.length > 1) {
					if (execs[0] == "SVC") {
						jex.printDebug("EXECUTER 수행 ==> 페이지 전환 [ " + execs[1]
								+ "]");
						location.href = execs[1] + svcExtAtt;
					} else if (execs[0] == "FUNC") {
						if (execs[1]) {
							var func = execs[1].replace(/__/, ",");
							eval(func);
						}
					} else if (execs[0] == "DEV") {
						jex.printDebug("Device 명령 수행 ==> 명령 [ " + execs[1]
								+ "]");

						if (!window.Cordova) {
							jex.printError("WE0096", "모바일 디바이스에서만 제공되는 기능입니다.");
						} else {

							/**
							 * API별 수행하는 함수를 정의 -- 차후에 demo.custom.js나
							 * jex.device.js로 정의하자.
							 */
							this.options = {
								camera : navigator.camera.getPicture,
								qrcode : window.plugins.QrCode.scan,
								higs : window.plugins.JfmStorage.HIGCall
							};

							var atr = (execs[1]) ? execs[1].toLowerCase() : "";
							if (!this.options[atr]) {
								jex.printError("WE0097", "현재 미지원 기능입니다.");
							} else {
								this.options[atr](function(success) {
									;
								}, function(error) {
									;
								}, {});
							}
						}

					} else {
						// var tar = $(execs[1]); 20130513 "this" 가능하도록 수정
						var tar = execs[1] == "this" ? $jq : $(execs[1]);
						var jex_obj = tar.data("_jex_obj");
						if (jex_obj) {
							for ( var ii = 0; ii < jex_obj.length; ii++) {
								// MODIFY from kiup - params 가 있는 경우의 함수도
								// 처리가능하도록 수정
								var param = "";
								var funcName = "";
								if (-1 < execs[0].indexOf("(")) {
									param = execs[0].substring(execs[0]
											.indexOf("(") + 1, execs[0]
											.indexOf(")"));
									funcName = execs[0].substring(0, execs[0]
											.indexOf("("));
								}else{
									funcName = execs[0];
								}
								if (jex_obj[ii] && jex_obj[ii][funcName]) {
									jex.printDebug("JEX EXECUTER 수행 [ "
											+ execs[1] + "/" + execs[0] + "]");
									jex_obj[ii][funcName](param);
								}
								// END
							}
						}
					}
				}
			} else {
				// var tar = $(executeList[jj]); 20130513 "this" 가능하도록 수정
				var tar = executeList[jj] == "this" ? $jq : $(executeList[jj]);
				var jex_obj = tar.data("_jex_obj");
				if (jex_obj) {
					for ( var i = 0; i < jex_obj.length; i++) {
						var obj = jex_obj[i];
						if (typeof (obj.execute) == "function") {
							jex.printDebug("JEX EXECUTER 수행 [ execute ]");
							obj.execute(action, $jq);
						}
					}
				}
			}
		}
	} else if (_executer.jquery) {
		var jex_obj = _executer.data("_jex_obj");
		if (jex_obj) {
			for ( var i = 0; i < jex_obj.length; i++) {
				var obj = jex_obj[i];
				if (typeof (obj.execute) == "function") {
					jex.printDebug("JEX EXECUTER 수행 [ execute / this");
					obj.execute(action, $jq);
				}
			}
		}
	}

};

/**
 * 초성 처리를 위한 API...작업중임.
 * 
 * @param str
 * @returns
 */
_jex.prototype.splitKorean = function(str) {
	var korean_srt = parseInt(escape("가").replace(/\%u/g, ''), 16); // '가'의 코드
																	// -- 전역변수로
																	// 가지고 있도록
																	// 하자.(매번
																	// 연산하지 않도록)
	var korean_end = parseInt(escape("힣").replace(/\%u/g, ''), 16); // '힝'의 코드

	/**
	 * 초성/중성/종성에 나올수 있는 글자들.
	 */
	var initial = [ 'ㄱ', 'ㄲ', 'ㄴ', 'ㄷ', 'ㄸ', 'ㄹ', 'ㅁ', 'ㅂ', 'ㅃ', 'ㅅ', 'ㅆ', 'ㅇ',
			'ㅈ', 'ㅉ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ' ];
	var neuter = [ 'ㅏ', 'ㅐ', 'ㅑ', 'ㅒ', 'ㅓ', 'ㅔ', 'ㅕ', 'ㅖ', 'ㅗ', 'ㅘ', 'ㅙ', 'ㅚ',
			'ㅛ', 'ㅜ', 'ㅝ', 'ㅞ', 'ㅟ', 'ㅠ', 'ㅡ', 'ㅢ', 'ㅣ' ];
	var finall = [ '', 'ㄱ', 'ㄲ', 'ㄳ', 'ㄴ', 'ㄵ', 'ㄶ', 'ㄷ', 'ㄹ', 'ㄺ', 'ㄻ', 'ㄼ',
			'ㄽ', 'ㄾ', 'ㄿ', 'ㅀ', 'ㅁ', 'ㅂ', 'ㅄ', 'ㅅ', 'ㅆ', 'ㅇ', 'ㅈ', 'ㅊ', 'ㅋ',
			'ㅌ', 'ㅍ', 'ㅎ' ];

	if (str.length > 2)
		str = str.charAt(0);

	var escapeStr = escape(str);
	if (escapeStr.length < 4) {
		_jex.getInstance().printError("JEXS0001", "한글이 아닌 문자 입력");
		return false;
	}
	var strCode = parseInt(escapeStr.replace(/\%u/g, ''), 16);

	if (strCode < korean_srt || strCode > korean_end) {
		_jex.getInstance().printError("JEXS0001", "한글이 아닌 문자 입력");
		return false;
	}
	var srcCode2 = strCode - korean_str;
	var arr_1st_v = Math.floor(uninum2 / 588);
	uninum2 = uninum2 % 588;
	var arr_2nd_v = (Math.floor(uninum2 / 28));
	uninum2 = (uninum2 % 28);
	var arr_3th_v = uninum2;
	// alert(arr_1st_v); alert(arr_2nd_v); alert(arr_3th_v);
	var return_arr = new Array(arr_1st[arr_1st_v], arr_2nd[arr_2nd_v],
			arr_3th[arr_3th_v]);
	// alert(return_arr);
	return return_arr;
};

/**
 * PageLoader에 Append하기위해서는 JexPlugin형태로 구현되어 있어야 한다. 실제 구현체는 천천히 하자.
 * 
 * @param attr
 */
_jex.prototype.addPageLoader = function(attr) {
	this.pageLoader.push(attr);
};

/**
 * Plugin처리
 */
_jex_plugin = function() {
	this.plugIn = {};
	this.pAttributes = {};
};
_jex_plugin.prototype.addAttribute = function(key, attr) {
	this.pAttributes[key] = attr;
};
_jex_plugin.prototype.getAttribute = function(key) {
	return this.pAttributes[key];
};
_jex_plugin.prototype.getAttributes = function() {
	return this.pAttributes;
};
_jex_plugin.prototype.add = function(key, obj, attr) {
	this.plugIn[key] = obj;
	if (attr)
		this.pAttributes[key] = attr;
};
_jex_plugin.prototype.get = function(key) {
	return this.plugIn[key];
};
_jex_plugin.prototype.newInstance = function(key, opt) {
	return new this.plugIn[key](opt);
};
_jex.prototype.plugin = new _jex_plugin();

/**
 * 이건 임시로 만들어서 사용하고 차후에 jexTbl로 재구현하거나, SimpleJexTbl을 만들어서 사용하자.
 * 
 * @param dat
 * @param $t
 */
_jex.prototype.makeTbl = function(dat, $t) {
	$t.find("table").remove();
	var $tbl = $("<table></table>");
	$.each(dat, function(i, v) {
		var $tr = $("<tr></tr>");
		$.each(v, function(i, v) {
			$td = $("<td></td>");
			$td.html(v);
			$td.appendTo($tr);
		});
		$tr.appendTo($tbl);
	});
	$tbl.appendTo($t);
	alert($t.html());
};
/**
 * 도메인의 GET TYPE변수를 return
 */
_jex.prototype.getQString = function() {
	var url = document.URL;
	var qst = url.split("?")[1];
	if (!qst)
		return {};
	if (qst.indexOf("#") > -1) {
		qst = qst.split("#")[0];
	}
	if (qst != undefined) {
		var rslt = {};
		var qar = qst.split("&");
		for ( var i = 0; i < qar.length; i++) {
			var rs = qar[i].split("=");
			rslt[decodeURIComponent(rs[0])] = decodeURIComponent(rs[1]);
		}
		return rslt;
	}
	return "";
};
/**
 * 도메인의 GET TYPE변수를 return
 */
_jex.prototype.getHString = function() {
	var url = document.URL;
	var hst = url.split("#")[1];
	if (hst != undefined) {
		var rslt = {};
		var har = hst.split("&");
		for ( var i = 0; i < har.length; i++) {
			var rs = har[i].split("=");
			rslt[decodeURIComponent(rs[0])] = decodeURIComponent(rs[1]);
		}
		return rslt;
	}
	return "";
};
/**
 * 도메인의 GET TYPE변수를 return
 */
_jex.prototype.setHString = function(json) {
	var hash = "";
	for (key in json) {
		if (hash != "")
			hash += "&";
		hash += encodeURIComponent(key);
		hash += "=";
		hash += encodeURIComponent(json[key]);
	}
	location.hash = hash;
};
/**
 * 현재 URL return
 */
_jex.prototype.getUrl = function() {
	return document.URL;
};
/**
 * AJAX관련 설정-Method Start
 */
_jex.prototype.addAjaxBefore = function(fn) {
	this.addAjaxBefore = fn;
	/*
	this.ajaxBeforeSend.push(fn);
	_jex.getInstance().setAjaxBefore();
	*/
};

/**
 * AJAX관련 설정-Method Start
 */
_jex.prototype.setAjaxBeforeData = function(fn) {
	this.ajaxBeforeData = fn;
};

/**
 * AJAX관련 설정-Method Start
 */
_jex.prototype.getAjaxBeforeData = function() {
	return this.ajaxBeforeData;
};

/**
 * AJAX실행전에 처리할것.
 */
_jex.prototype.setAjaxBefore = function() {
	var _this = this;
	fn = function(xhr, setting) {
		$.each(_this.ajaxBeforeSend, function(i, v) {
			v(xhr, setting);
		});
	};
	this.ajaxSetup['beforeSend'] = fn;
	jQuery.ajaxSetup(this.ajaxSetup);
};
/**
 * AJAX실행후에 처리할것.
 */
_jex.prototype.addAjaxComplete = function(fn) {
	this.ajaxComplete.push(fn);
	_jex.getInstance().setAjaxComplete();
};
/**
 * AJAX실행후에 처리할것.
 */
_jex.prototype.setAjaxCompleteData = function(fn) {
	this.ajaxCompleteData = fn;
};
/**
 * AJAX실행후에 처리할것.
 */
_jex.prototype.getAjaxCompleteData = function() {
	return this.ajaxCompleteData;
};
/**
 * AJAX종료후 처리
 */
_jex.prototype.setAjaxComplete = function() {
	var _this = this;
	fn = function(xhr, textStatus) {
		$.each(_this.ajaxComplete, function(i, v) {
			v(xhr, textStatus);
		});
	};
	this.ajaxSetup['complete'] = fn;
	jQuery.ajaxSetup(this.ajaxSetup);
};
/**
 * 시간관련 Fn
 */
_jex.prototype.time = function() {
	return {
		getMicroTime : function(get_as_float) {
			var now = new Date().getTime() / 1000;
			var s = parseInt(now, 10);
			return get_as_float ? now : Math.round(((now - s) * 1000) / 1000)
					+ ' ' + s;
		}
	};
};
/**
 * DATE UTIL :: JEX_STUDIO이후에는 새로 구현예정 -- 하위 호환성을 위해 삭제는 하지말자.(작동하게 정리만 하는정도...)
 * 
 * @returns {___anonymous9415_9510}
 */
_jex.prototype.date = function() {
	var mongthLen = [ 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 ];
	var baseDt = {
		year : 0000,
		mon : 1,
		week : 5
	};

	function getToday() {
		var _date = new Date();
		var d = _date.getDate();
		var day = (d < 10) ? '0' + d : d;
		var m = _date.getMonth() + 1;
		var month = (m < 10) ? '0' + m : m;
		var yy = _date.getYear();
		var year = (yy < 1000) ? yy + 1900 : yy;

		var hh0 = _date.getHours();
		var hh = (hh0 < 10) ? '0' + hh0 : hh0;
		var mi0 = _date.getMinutes();
		var mi = (mi0 < 10) ? '0' + mi0 : mi0;
		var ss0 = _date.getSeconds();
		var ss = (ss0 < 10) ? '0' + ss0 : ss0;

		var ms0 = _date.getMilliseconds();
		var ms = (ms0 < 10) ? '000' + ms0 : (ms0 < 100) ? '00' + ms0
				: (ms0 < 100) ? '0' + ms0 : ms0;

		return year + "" + month + "" + day + "" + hh + "" + mi + "" + ss + ""
				+ ms;
	}
	;
	function getDate(a, b) {
		var date;
		var pattern;
		if (a == undefined) {
			date = getToday();
			pattern = 'yyyymmdd';
		} else if (b == undefined) {
			date = getToday();
			pattern = a;
		} else {
			date = a;
			pattern = b;
		}

		var yyyy, mm, dd, hh, mi, ss, ms;
		if (date.length < 8) {
			return "잘못된 입력";
		}
		yyyy = date.substr(0, 4);
		mm = date.substr(4, 2);
		dd = date.substr(6, 2);
		if (date.length >= 14) {
			try {
				hh = date.substr(8, 2);
				mi = date.substr(10, 2);
				ss = date.substr(12, 2);
				ms = date.substr(14, 3);
			} catch (e) {
				hh = (_jex.getInstance().isNull(hh)) ? "" : hh;
				mi = (_jex.getInstance().isNull(mi)) ? "" : mi;
				ss = (_jex.getInstance().isNull(ss)) ? "" : ss;
				ms = (_jex.getInstance().isNull(ms)) ? "" : ms;
			}
		} else {
			hh = mi = ss = ms = "";
		}
		return pattern.replace(/yyyy/, yyyy).replace(/mm/, mm)
				.replace(/dd/, dd).replace(/hh/, hh).replace(/mi/, mi).replace(
						/ss/, ss).replace(/ms/, ms);
	}
	;
	function getDayBetween(fromDate, toDate) {
		return "아직 미구현";
	}
	;
	function getEndDate(yyyy, mm) {
		return "아직 미구현";
	}
	;
	return {
		getDate : getDate,
		getDayBetween : getDayBetween,
		getDayBetween : getDayBetween
	};
};
/**
 * AJAX관련 설정-Method End
 */
/**
 * 기본 핸들러 등록 -- Debugger연동
 */
_jex.getInstance().addErrorHandler("default", function() {
	alert("Error!");
});
/**
 * 외부에서 JEX를 선언하지 않도록 미리 정의
 */
var jex = _jex.getInstance();
/**
 * JSON 확장
 */
/**
 * String 확장
 */
String.prototype.startsWith = function(str) {
	return (this.match("^" + str) == str);
};
String.prototype.endsWith = function(str) {
	return (this.match(str + "$") == str);
};
String.prototype.isJSON = function(str) {
	return _jex.getInstance().isJSON(str);
};

/**
 * Array 확장 -- XecureWeb과의 충돌예상
 */
/*
 * Array.prototype.remove = function(from, to) { var rest = this.slice((to ||
 * from) + 1 || this.length); this.length = from < 0 ? this.length + from :
 * from; return this.push.apply(this, rest); };
 */
/**
 * 에러발생시 처리 로직 -- 여기서 Exception Handler를 어찌 받아오지? 한동안 주석처리
 */
/*
 * window.onerror = function(msg,file_loc,line_num) { jex.printError("","!!!!! " +
 * msg); jex.printError("","Message : " + msg + " file loc : " + file_loc + "
 * line_num : " + line_num); jex.printError("",JSON.stringify(this.stack));
 * jex.printError("",JSON.stringify(this.full_stack)); return false; };
 */
/**
 * jquery plug-in형태로 setAll/getAll 구현 Start 차후 JEX PLUG-IN형태로 재 구현 할것임. -- 하위
 * 호환성을 위해 삭제는 하지말고....정리만 하자.
 */
(function($) {
	$.fn.setTagValue = function(dat) {
		var tag = $(this).get(0).tagName;
		var type = $(this).attr("type");
		switch (tag.toLowerCase()) {
		case "textarea":
		case "input":
			if (type == "radio" && !_jex.getInstance().isNull(dat)) {
				if ($(this).val() == dat)
					$(this).attr("checked", true);
			} else if (type == "checkbox" && !_jex.getInstance().isNull(dat)) {
			} else
				$(this).val(dat);
			break;
		case "select":
			$(this).val(dat);
			break;
		case "img":
			if (!_jex.getInstance().isNull(dat))
				$(this).attr("src", dat);
			else if (_jex.getInstance().isNull($(this).attr("src")))
				$(this).remove();
			break;
		default:
			$(this).html(dat);
			break;
		}
		;
	};
	$.fn.getTagValue = function() {
		var tag = $(this).get(0).tagName;
		var type = $(this).attr("type");
		var rslt = "";
		switch (tag.toLowerCase()) {
		case "input":
			if (type == "radio") {
				if ($(this).attr("checked"))
					rslt = $(this).val();
			} else if (type == "checkbox") {
			} else
				rslt = $(this).val();
			break;
		case "select":
		case "textarea":
			rslt = $(this).val();
			break;
		case "img":
			rslt = $(this).attr("src");
			break;
		default:
			if ($(this).val())
				rslt = $(this).val();
			else
				rslt = $(this).html();
			break;
		}
		;
		return rslt;
	};
	$.fn.setAll = function(dat, _formatter, useJexObj, fnName) {

	//	console.log("jyjy :: jex.core.js  :: setAll ==> dat:" + dat
	//			+ ", _formatter:" + _formatter + ", useJexObj:" + useJexObj);
	//	console.log("jin core setAll dat:" + JSON.stringify(dat));

		_formatter = (_jex.getInstance().isNull(_formatter)) ? _jex
				.getInstance().getSetAllFormatter() : _formatter;
		useJexObj = (useJexObj == undefined) ? true : useJexObj;
		fnName = (fnName) ? fnName : "setAll";

		var jexObj001 = $(this).data("_jex_obj");
		var id_this = $(this).attr("id");

		if (useJexObj && id_this && jexObj001 && jexObj001.length > 0) {
			for ( var ii = 0; ii < jexObj001.length; ii++) {
				/*
				 * if (typeof(jexObj001[ii].setAll) == "function")
				 * jexObj001[ii].setAll(dat[id_this]);
				 */
				if (typeof (jexObj001[ii][fnName]) == "function")
					jexObj001[ii][fnName](dat[id_this]);
			}
		} else if (id_this) {
			$(this).setTagValue(dat[id_this]);
		}

		$.each($(this).find("[id]"), function() {
			var o = $(this).attr("id");
			if (_jex.getInstance().isNull(o))
				return true;
			var d = dat[o];
			var f = _formatter[o];
			if (!_jex.getInstance().isNull(f) && typeof (f) == "function")
				d = f(d, dat);
			if (d != undefined) {
				var jexObj = $(this).data("_jex_obj");

				if (jexObj && jexObj.length > 0) {
					for ( var ii = 0; ii < jexObj.length; ii++) {
						if (typeof (jexObj[ii][fnName]) == "function")
							jexObj[ii][fnName](d);
					}
				} else {
					$(this).setTagValue(d);
				}
			}
		});
		return this;
	};
	/*
	 * $.fn.getAll = function(_formatter) { var rslt={}; _formatter =
	 * (_jex.getInstance().isNull(_formatter))?{}:_formatter;
	 * 
	 * $.each($(this).find("[id]"),function() { var o = $(this).attr("id"); if
	 * (_jex.getInstance().isNull(o)) return true; var f = _formatter[o]; var d =
	 * $(this).getTagValue(); d=(typeof(f)=="function")?f(d):d; if
	 * (_jex.getInstance().isNull(d)) return true; rslt[o] = d; });
	 * 
	 * return rslt; };
	 */
	$.fn.getAll = function(_formatter, useJexObj, fnName) {
		var rslt = {};

		_formatter = (_jex.getInstance().isNull(_formatter)) ? _jex
				.getInstance().getGetAllFormatter() : _formatter;
		useJexObj = (useJexObj == undefined) ? true : useJexObj;
		fnName = (fnName) ? fnName : "getAll";

		var jexObj001 = $(this).data("_jex_obj");
		var id_this = $(this).attr("id");

		if (useJexObj && id_this && jexObj001 && jexObj001.length > 0) {
			for ( var ii = 0; ii < jexObj001.length; ii++) {
				if (typeof (jexObj001[ii][fnName]) == "function")
					rslt = jexObj001[ii][fnName]();
			}
			return rslt;
		} else if ($(this).data("_JEX_GETALL_DATA_")) {
			rslt = $(this).data("_JEX_GETALL_DATA_");
			return rslt;
		} else if (id_this) {
			rslt[id_this] = $(this).getTagValue();
		}

		$.each($(this).find("[id]"), function() {
			var o = $(this).attr("id");
			var d = undefined;
			if (_jex.getInstance().isNull(o))
				return true;

			var jexObj = $(this).data("_jex_obj");
			if (jexObj && jexObj.length > 0) {
				for ( var ii = 0; ii < jexObj.length; ii++) {
					if (typeof (jexObj[ii][fnName]) == "function")
						d = jexObj[ii][fnName]();
				}
			} else if ($(this).data("_JEX_GETALL_DATA_")) {
				d = $(this).data("_JEX_GETALL_DATA_");
			} /*else {
				d = $(this).getTagValue();
			}*/

			if (typeof(d) == "undefined" ) {
				d = $(this).getTagValue();
			}
			
			var f = _formatter[o];
			d = (typeof (f) == "function") ? f(d) : d;

			if (_jex.getInstance().isNull(d))
				return true;
			rslt[o] = d;
		});
		return rslt;
	};

	
	$.fn.JexSimpleTblHandler = function(cmd, opt) {
		$r = $(this);
		function addRow(dat) {
			var $tr = $("<tr></tr>");
			$.each(dat, function(i, v) {
				$td = $("<td>" + v + "</td>");
				$td.appendTo($tr);
			});
			$r.find("tbody");
		} // 한 Row를 추가한다.
		function make(opt) {
			$r.JexSimpleTblHandler('makeTblHeader', opt);
		}
		function addRows(dat) {
			$.each(dat, function(i, v) {
				$r.JexSimpleTblHandler('addRow', v);
			});
		} // 여러Row를 추가한다.
		function rowDef(opt) {
			$r.data("rowDef", opt);
		} // Row를 정의한다.
		function delRow(idx) {
			$r.find("tbody").find("tr:eq(" + idx + ")").remove();
		} // 한Row를 지운다.
		function makeTblHeader(dat) {
			var $tr = $("<tr></tr>");
			$.each(dat, function(i, v) {
				$td = $("<td>" + v + "</td>");
				$td.appendTo($tr);
			});
			$r.find("thead");
		} // TableHeader를 생성한다.
		/**
		 * Plug의 명령정의
		 */
		switch (cmd) {
		case make:
			return make(opt);
		case addRows:
			return addRows(opt);
		case addRow:
			return addRow(opt);
		case rowDef:
			return rowDef(opt);
		case delRow:
			return delRow(opt);
		}
	};
})(jQuery);
/**
 * jquery plug-in형태로 setAll/getAll 구현 End
 */
/**
 * AJAX처리를 위한 Util Class
 */
/**
 * Smart Phone AJAX대응 -- 재구현
 */
var _jexAjaxUtil = function(svc, ext, url) {
	this.svcId = (svc != undefined) ? svc : "";
	this.url = url;
	this.ext = ext;
	this.async = true;
	this.errorTrx = true;
	this.error = false;
	this.errFn = function(xhr, textStatus, errorThrown) {
		if (this.jm)
			this.jm.stop(); /*
							 * alert(_jex.getInstance().isNull(xhr.statusText)?"":(xhr.statusText+" ::
							 * ")+_jex.getInstance().toStr(errorThrown));
							 */
	};
	this.cache = false;
	this.fn = function() {
	};
	this.input = {};
	this.option = {};
	this.jobManager = undefined;
	this.header = _jex.getInstance().getAjaxHeader();

	this.executeFn = function(msg, _this, jm) {
		try {
			ComUtil.hideloading();
			var input = msg;
			//input = unescape(decodeURI(msg)); // ADD
			input = unescape(msg); 
			if (typeof (_jex.getInstance().getAjaxCompleteData()) == "function") {
				var imsi = _jex.getInstance().getAjaxCompleteData()(msg,
						_this.option);
				msg = (_jex.getInstance().isNull(imsi)) ? msg : imsi;
			}
			if (typeof (msg) == "string"){
				input = JSON.parse(input); // input = JSON.parse(msg);
			}else
				input = msg;
			var p_time = _jex.getInstance().getMicroTime() - _this.str_time;
			if (!_jex.getInstance().isNull(_jex.getInstance().getDebugger()))
				_jex.getInstance().getDebugger().addMsg(
						{
							"TYPE" : "AJAX",
							"CODE" : "OUTPUT",
							"MSG" : "AJAX처리완료 [" + _this.svcId
									+ "], Process Time :: [" + p_time + "ms]",
							"PTM" : p_time + "ms"
						});
			if (!_this.errorTrx || !_jex.getInstance().isError(input)) {
				_this.fn(input);
			} else {
				if (!_jex.getInstance().isNull(
						_jex.getInstance().getAjaxErrFn()))
					_jex.getInstance().getAjaxErrFn()(input);
				// else
				// _jex.getInstance().printError(input['COMMON_HEAD']['CODE'],input['COMMON_HEAD']['MESSAGE']);
				else {
					if (window.pageJobs2) {
						window.pageJobs2.stop();
						window.pageJobs2.clear();
						window.pageJobs2 = undefined;
					}
					_jex.getInstance().printError(
							input["_tran_res_data"][0]["ERROR_CODE"],
							input["_tran_res_data"][0]["ERROR_MSG"]);
				}
			}
			if (!_this.async)
				return input;
		} catch (e) {
			_jex.getInstance().checkException(e);
		} finally {
			if (typeof (jm.stop) == 'function') {
				jm.stop();
			}
		}
		;
	};
};
_jexAjaxUtil.prototype.setSvc = function(s) {
	this.svcId = s;
};
_jexAjaxUtil.prototype.setExt = function(s) {
	this.ext = s;
};
_jexAjaxUtil.prototype.setAsync = function(b) {
	this.async = b;
};
_jexAjaxUtil.prototype.setErr = function(b) {
	this.error = b;
};
_jexAjaxUtil.prototype.setErrFn = function(f) {
	this.errFn = f;
};
_jexAjaxUtil.prototype.setErrTrx = function(b) {
	this.errorTrx = b;
};
_jexAjaxUtil.prototype.setFn = function(f) {
	this.fn = f;
};
_jexAjaxUtil.prototype.setJm = function(jm) {
	this.jobManager = jm;
};
_jexAjaxUtil.prototype.setCache = function(b) {
	this.cache = b;
};
_jexAjaxUtil.prototype.addHeader = function(key, val) {
	this.header[key] = val;
};
_jexAjaxUtil.prototype.get = function(key) {
	if (key == undefined)
		return this.input;
	else
		return this.input[key];
};
_jexAjaxUtil.prototype.addOption = function(key, value) {
	this.option[key] = value;
};
_jexAjaxUtil.prototype.set = function(key, value) {
	var rthis = this;
	if (_jex.getInstance().isNull(key))
		return;
	if (_jex.getInstance().isNull(value)) {
		if (typeof (key) != "string") {
			$.each(key, function(i, v) {
				rthis.input[i] = v;
			});
		}
	}
	this.input[key] = value;
};

_jexAjaxUtil.prototype.execute = function(fn) {
	this.str_time = _jex.getInstance().getMicroTime();
	if (typeof (fn) == "function")
		this.fn = fn;
	var rslt;
	var _this = this;
	
    var _SERVER_HOST = "";
    
    if(location.protocol == "file:") {
    	_SERVER_HOST = _HOST_NAME;
    	//alert("_HOST_NAME:"+_HOST_NAME);
    } else {
    	_SERVER_HOST = "";
    }

   // alert("_SERVER_HOST:"+_SERVER_HOST);
    
	var ajaxExecute = function() {
		if (_this.jm)
			this.start();
		var JSONData = {
			"_tran_cd" : _this.svcId,
			"_tran_req_data" : [ _this.input ]
		}; //ADD
		
		var tranData = "JSONData="+ escape(encodeURIComponent(JSON.stringify(JSONData))); // ADD

		ComUtil.showloading(); // 로딩바
		
		if (typeof (_jex.getInstance().getAjaxBeforeData()) == "function") {
			// var imsi =
			// _jex.getInstance().getAjaxBeforeData()(_this.input,_this.option);
			// tranData = (_jex.getInstance().isNull(imsi))?tranData:imsi;
		}
		if (!_jex.getInstance().isNull(_jex.getInstance().getDebugger()))
			_jex.getInstance().getDebugger().addMsg({
				"TYPE" : "AJAX",
				"CODE" : "INPUT",
				"MSG" : "AJAX처리시작 [" + _this.svcId + "]"
			});

		if (window.Cordova && false) {
			var params = {
				SERVICEID : _this.svcId,
				JSONData : tranData['_JSON_']
			};
			window.plugins.HttpRequest.execute(params, function(msg) {
				_this.executeFn(msg, _this, this);
			}, _this.errFn);

		} else { 
			var loc_path = $(location).attr("pathname");
		    loc_path = loc_path.substring(loc_path.indexOf("/jsp"));
		    _this.header['referer_url'] = loc_path;
			jQuery.ajax({ 
				type    : "POST",
				url     : "/QMS/jsp/gateway/gateway.jsp",
				data    : tranData,
				cache   : _this.cache,
				async   : _this.async,
				error   : _this.errFn,
				headers : _this.header,
				success : function(msg) {
					rslt = _this.executeFn(msg, _this, this);
				}
			});
		}
	};

	if (_this.jm) {
		_this.jm.add(ajaxExecute);
	} else {
		ajaxExecute();
	}

	return rslt;
};

(function() {
	var initializing = false, fnTest = /xyz/.test(function() {
		xyz;
	}) ? /\b_super\b/ : /.*/;
	// The base Class implementation (does nothing)
	this.Class = function() {
	};

	// Create a new Class that inherits from this class
	Class.extend = function(prop) {
		var _super = this.prototype;

		// Instantiate a base class (but only create the instance,
		// don't run the init constructor)
		initializing = true;
		var prototype = new this();
		initializing = false;

		// Copy the properties over onto the new prototype
		for ( var name in prop) {
			// Check if we're overwriting an existing function
			prototype[name] = typeof prop[name] == "function"
					&& typeof _super[name] == "function"
					&& fnTest.test(prop[name]) ? (function(name, fn) {
				return function() {
					var tmp = this._super;

					// Add a new ._super() method that is the same method
					// but on the super-class
					this._super = _super[name];

					// The method only need to be bound temporarily, so we
					// remove it when we're done executing
					var ret = fn.apply(this, arguments);
					this._super = tmp;

					return ret;
				};
			})(name, prop[name]) : prop[name];
		}

		// The dummy class constructor
		function Class() {
			// All construction is actually done in the init method
			if (!initializing && this.init)
				this.init.apply(this, arguments);
		}

		// Populate our constructed prototype object
		Class.prototype = prototype;

		// Enforce the constructor to be what we expect
		Class.constructor = Class;

		// And make this class extendable
		Class.extend = arguments.callee;

		return Class;
	};
})();

/**
 * Job을 관리하는 Manager정의
 */
_JexJobManager = Class.extend({
	init : function() {
		this.jobList = [];
		this.bIsRun = false; // 현재 돌고 있는지
		this.trans = false; // 트렌젝션 처리중인지.
		this.dTime = 100; // 0.05초당 한번씩 실행하도록.
		this.onfinally	= [];
		this.jobIdx		= 0;
		this.runFin		= -2;
	}, clear : function() {
		this.jobIdx		= 0;
		this.runFin		= -2;
		this.jobList = [];
	}, onFinally	: function(fn) {
		this.onfinally = [];
		this.onfinally.push(fn);
		//console.log("procedure register onFinally");
	}, addFinally : function(fn) {
		this.onfinally.push(fn);
	}, add : function(job) {
		this.jobList.push(job);
		if (!this.isRun()) {
			this.runJob();
		}
	},
	start : function() {
		//console.log("procedure start runFin:"+this.runFin+" jobIdx:"+this.jobIdx );
		this.trans = true;
	},
	stop : function() {
		this.trans = false;
		var _this = this;
		//console.log("procedure stop runFin:"+_this.runFin+" jobIdx:"+_this.jobIdx);
		
		//if (_this.runFin != (_this.jobIdx-1)) {  20130822 수정
		if (_this.runFin != (_this.jobIdx)) {
			_this.runFin = _this.jobIdx;
    		for (var ii=0; ii<_this.onfinally.length; ii++) { 
    			//console.log("procedure stop finally");
    			_this.onfinally[ii](); 
    		}
        }
		
		if (!this.isRun()) this.runJob();
	},
	runJob : function() {
		//console.log("procedure runJob jobManager");
		if (this.isRun())
			return;
		var _this = this;
		this.isRun(true);
		/**
		 * iPhone 대응. iPhone의 경우 App과 통신을 위하여 location.href=xxx 형태를 사용한다. 이와 동시에
		 * Ajax등의 통신이 불가능해지기 때문에 App과 통신하는 시점에는 JobManager를 활용하여 해결한다.
		 */
		if (document.readyState != 'loaded'
				&& document.readyState != 'complete') {
			//console.log("procedure runJob loaded or complete jobManager");
			setTimeout(function() {
				_this.isRun(false);
				_this.runJob();
			}, this.dTime);
		} else {
			//console.log("procedure runJob !(loaded or complete) jobManager");
			
			setTimeout(function() {
				
				if (!_this.trans && _this.jobList.length > 0) {
					var job = _this.jobList.shift();
					_this.jobIdx++;
					job.apply(_this);
					//console.log("procedure runJob runFin:"+_this.runFin+" jobIdx:"+_this.jobIdx);
					//_this.jobIdx++;	20130822 수정
					//if (!_this.trans && _this.runFin != _this.jobIdx) {
					if (!_this.trans)  {
						_this.runFin = _this.jobIdx;
						for (var ii=0; ii<_this.onfinally.length; ii++) { 
							//console.log("procedure onfinally execute length:"+_this.onfinally.length);
							_this.onfinally[ii](); 
						}
					}
					
					_this.runJob();
				}
				_this.isRun(false);
			}, this.dTime);
		}
	},
	isRun : function(b) {
		if (typeof (b) != undefined)
			return this.bIsRun;
		else
			this.bIsRun = b;
	}
});

_jex.getInstance().setJobManager(new _JexJobManager());

/**
 * JEXPLUG-IN 인터페이스. (여기서는 차후 무언가 기본 처리가 추가될 수 있다.)
 */
var JexPlugin = Class.extend({
	init : function() {
		this._jexAttrName = undefined;
	},
	_setJexAttrName : function(s) {
		this._jexAttrName = s;
	},
	_getJexAttrName : function() {
		return this._jexAttrName;
	}
});

/**
 * Custom코딩 영역
 */
var JexCustom = Class.extend({
	init : function() {
		this.addFnList = {};
	},
	addFunction : function(key, fn) {
		this.addFnList[key] = fn;
	},
	getFnList : function() {
		return this.addFnList;
	}
});

/**
 * JEX DBUGGER 인터페이스. (여기서는 차후 무언가 기본 처리가 추가될 수 있다.)
 */
var JexDebugger = Class.extend({
	init : function() {
	},
	printDebug : function(msg) {
	},
	printInfo : function(code, msg) {
	},
	printError : function(code, msg) {
	}
});
/**
 * JEX MSG 인터페이스. (여기서는 차후 무언가 기본 처리가 추가될 수 있다.)
 */
var JexMsg = Class.extend({
	init : function() {
	},
	printInfo : function(code, msg) {
	},
	printError : function(code, msg) {
	},
	alert : function(code, msg) {
	},
	confirm : function(code, msg, callback) {
	}
});

/**
 * Page에서 실행해야할 Job을 줄세우기 위해 사용한다.
 */
var pageJobs = _jex.getInstance().getJobManager();

/**
 * AJAX처리를 위한 Util Class END
 */
/**
 * Jex정의 --차후 처리할 내역 : printStackTrace() 로 메시지 출력 --blur, focus, focusin,
 * focusout, load, resize, scroll, unload, click, dblclick, mousedown, mouseup,
 * mousemove, mouseover, mouseout, mouseenter, mouseleave, change, select,
 * submit, keydown, keypress, keyup, error
 */
var Jex = Class.extend({
	init : function() {
		var _r = this;
		try {
			if (this.beforeOnload)
				this.beforeOnload();
		} catch (e) {
			_jex.getInstance().checkException(e);
		}
		$(function() {
			_r._executeOnload();
		});
	},
	beforeOnload : function() {
	},
	_executeOnload : function() {
		var _r = this;
		try {
			this.onload0();
			this.onload1();
			this.onload2();
			var beforeonload = _jex.getInstance().getBeforeOnload();
			for ( var i = 0; i < beforeonload.length; i++) {
				beforeonload[i]();
			}
			pageJobs.add(function() {
				if (_r.event)
					_r.event();
				if (_r.onload)
					_r.onload();
				_jex.getInstance().isOnload(true);
			});
			var afteronload = _jex.getInstance().getAfterOnload();
			for ( var i = 0; i < afteronload.length; i++) {
				var fn = afteronload[i];
				pageJobs.add(function() {
					fn();
				});
			}
		} catch (e) {
			_jex.getInstance().checkException(e);
		}
		;
	},
	addEvent : function(selector, eventid, fn) {
		$(selector).bind(eventid, function() {
			try {
				fn.apply(this, arguments);
			} catch (e) {
				_jex.getInstance().checkException(e);
			}
			;
		});
	},
	onload0 : function() {
	},
	onload1 : function() {
	},
	onload2 : function() {
	},
	onload : function() {
	},
	event : function() {
	}
});
/**
 * Exception 정의
 */
var Exception = Class.extend({
	init : function(code, msg) {
		this.prototype = Error;
		this.name = "JexException";
		this.code = code;
		this.msg = msg;
		try {
			throw new Error("");
		} catch (e) {
			// alert("Exception :: stack + "+e.stack);
		}
	},
	getCode : function() {
		return this.code;
	},
	getMessage : function() {
		return this.msg;
	},
	printStackTrace : function() {
		alert("stack track");
	},
	getMessage : function() {
		return this.msg;
	},
	onError : function() {
		alert(this.msg);
	}
});
var JexWebException = Exception.extend({
	init : function(code, msg) {
		this._super(code, msg);
	},
	printStackTrace : function() {
		this._super();
	},
	getMessage : function() {
		this._super();
	}
});
var JexSysException = Exception.extend({
	init : function(code, msg) {
		this._super(code, msg);
	},
	printStackTrace : function() {
		this._super();
	},
	getMessage : function() {
		this._super();
	}
});
var JexException = Exception.extend({
	init : function(code, msg) {
		this._super(code, msg);
		this.code = code;
		this.msg = msg;
	},
	printStackTrace : function() {
		this._super();
	},
	getMessage : function() {
		this._super();
	},
	onError : function() {
		jex.printError(this.code, this.msg);
	}
});

/**
 * DOM에서 DATA-JX붙은거를 뽑자. 일단 Jquery스타일
 */
$(function() {
	jex.setJexObj($(document.body));
});