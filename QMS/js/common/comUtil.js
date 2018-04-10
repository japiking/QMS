/**
 * Action Code ��━
 */

var _actionCode = function(){
	//����곕� ���(荑��愿��)
	this.M12_GET_ADDR		  	= "7000";			//二쇱�濡�媛���ㅺ린
	this.M12_PAYMENT	  		= "7001";			//寃곗�泥�━
	this.M12_LOGOUT		  		= "7002";			//����곕� 濡�렇���ㅽ���濡�렇��� ��理�����吏�� �대�
	this.M12_PAYMENT_INFO	  	= "7003";			//����곕� 濡�렇���ㅽ���濡�렇��� ��理�����吏�� �대�
	
	//IBK�뱀����ъ�
	this.LOADING_START			= "5887";			//濡��諛���� (吏�����濡�怨�� ���)
	this.LODING_END				= "5889";			//濡��諛�醫��
	this.LOADING_START_1MIN	  	= "5888";			//濡��諛���� (1遺��寃⑹�濡�泥댄���� 怨�� �����굅��醫�����)
	this.PUSH_ON				= "8001";			//�몄��ㅼ� ���濡����
	this.GO_BACK_VIEW			= "5001";			//������吏����硫��대� (webview->硫����㈃, 硫����㈃->home)
	this.GO_HOME_AFTER_LOGOUT	= "5101";			//濡�렇��� �����濡��대�
	this.GO_MENU_CHR			= "5201";			//ONE癒몃�梨��湲�硫��濡��대�
	this.MOVE_MENU				= "5005";			//�뱀� appMenu�대�
	this.GET_PHONENO		  	= "6101";			//����댁� �대��곕���
	
	//�댁�蹂닿�由�怨듭��몄���갹 �몄�
	this.CALL_CERT_CHR			= "2000";			//異⑹�怨���ㅼ� (肄�갚 _thisPage.mpg_01_002/signed_msg)
	this.CALL_CERT_AUTO			= "2001";			//���異⑹��ㅼ� (肄�갚 _thisPage.mpg_02_002/signed_msg)
	this.CALL_CERT_EX			= "2002";			//���怨���ㅼ� (肄�갚 _thisPage.mpg_03_002/signed_msg)

	//�댁�蹂닿�由���낫 �����몄�
	this.MYP_INFO				= "2003";			//�댁�蹂닿�由�異⑹�怨���ㅼ�,���怨���ㅼ�) �깅�,��� ���깆� ��낫 �대�以�
	this.MYP_EMAIL				= "2004";			//�댁�蹂닿�由��대��쇰�寃� �깅�,��� ���깆� ��낫 �대�以�
	
	//=========================================================
	
	this.GO_HOME			  = "5004";				//HOME�쇰� �대�
	this.CHANGE_MENU_TITLE	  = "5007";				//硫�� �����蹂�꼍
	this.CALL_CERTSIGN		  = "6008";				//�������몄�
	this.INQ_GO_LIFEDIARY_REG = "5008";				//�듭�蹂닿린 > �쇱�����댁�由��깅�
	this.INQ_GO_LIFEDIARY_INQ = "5009";				//�듭�蹂닿린 > �쇱�����댁�由�議고�
	this.TRN_GO_LIFEDIARY_REG = "5088";				//�댁껜寃곌낵 > �쇱�����댁�由��깅�
	this.TRN_GO_LIFEDIARY_INQ = "5099";				//�댁껜寃곌낵 > �쇱�����댁�由�議고�
	this.MOVE_MENU_MYINFO	  = "5200";				//遺�������移�뎄異���곕���낫 硫��濡��대�
	this.INQ_EXPORT			  = "5300";				//嫄곕��댁��대낫�닿린
	this.CALL_KAKAO			  = "5400";				//移�뎄異�� > 移댁뭅�ㅽ�
	this.CALL_MMS			  = "5500";				//移�뎄異�� > MMS
};

var ActionCode = new _actionCode();

var ExternPlugin = {
		calendar	: "JEX_MOBILE_CALENDAR",
        get : function($object, pluginId){
            var obj = jex.getJexObj($object, pluginId);

            if ( obj != null )           return obj;
            else                         return $object;
        }
};

var _LAYER_YN_ = "N";

/**
 * ComUtil ��━
 */
var _comUtil = function(){
};
_comUtil.instance = new _comUtil();
_comUtil.getInstance = function() {
	return _comUtil.instance;
};

/**
 * null �몄� �щ�
 * @param dat
 * @returns {Boolean}
 */
_comUtil.prototype.isNull = function(dat){
	var isNull = false;
	if(undefined == dat || null == dat ){
		isNull = true;
	}
	return isNull;
};

/**
 * ��� 釉���곗�瑜���린 ��� �⑥� MSIE/Chrome/Firefox/Mozilla/Opera/Safari/Mac
 *
 * @returns 釉���곗� �대� or ""
 * @��� ComUtil.getUserBrowser();
 */
_comUtil.prototype.getUserBrowser = function(){
    if(navigator.userAgent.indexOf("MSIE") != -1){
        return "MSIE";
    }else if(navigator.userAgent.indexOf("Chrome") != -1){
        return "Chrome";
    }else if(navigator.userAgent.indexOf("Firefox") != -1){
        return "Firefox";
    }else  if(navigator.userAgent.indexOf("Mozilla") != -1){
        return "Mozilla";
    }else if(navigator.userAgent.indexOf("Opera") != -1){
        return "Opera";
    }else if(navigator.userAgent.indexOf("Safari") != -1){
        return "Safari";
    }else if(navigator.userAgent.indexOf("Mac") != -1){
        return "Mac";
    }else{
        return "";
    }
};
/**
 * 諛깃렇�쇱�����
 */
_comUtil.prototype.showLocker = function (){
    var overlay = document.createElement('div');
    var browser = ComUtil.getUserBrowser();
    overlay.cssText         = "background:0;background-color:transparent;background-image:none;background-position:0;background-repeat:repeat;background-size:auto;box-shadow:none;box-sizing:border-box;clear:none;color:inherit;empty-cells:show;float:none;font:normal;font-family:inherit;font-size:12px;font-style:normal;font-variant:normal;font-weight:none;height:auto;left:auto;letter-spacing:normal;line-height:normal;list-style:none;list-style-image:none;list-style-position:none;list-style-type:none;margin:0;max-height:none;max-width:none;min-height:0;min-width:0;opacity:1;overflow:visible;padding:0;table-layout:auto;text-align:left;text-decoration:none;text-decoration-color:inherit;text-decoration-line:none;text-decoration-style:solid;text-shadow:none;vertical-align:middle;visibility:inherit;white-space:normal;widows:0;width:auto;word-spacing:normal;z-index:auto;position:static;";
    overlay.style.zIndex    = 999998;
    overlay.onclick         = null;
    overlay.style.position  = 'fixed';
    overlay.style.width     = '100%';
    overlay.style.height    = '100%';
    overlay.style.top       = '0';
    overlay.style.left      = '0';
    overlay.style.display   = 'block';
    overlay.id              = '_LOADING_LOCKER_';

    if (browser == "MSIE") {
        overlay.style.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(src='/img/common/gray.png', sizingMethod='scale')";
    } else if(browser == "Chrome") {
        overlay.style.background = '-webkit-radial-gradient(rgba(127, 127, 127, 0.5), rgba(127, 127, 127, 0.5) 35%, rgba(0, 0, 0, 0.7))';
    } else if(browser == "Firefox") {
        overlay.style.background = '-moz-radial-gradient(rgba(127, 127, 127, 0.5), rgba(127, 127, 127, 0.5) 35%, rgba(0, 0, 0, 0.7))';
    } else {
        overlay.style.backgroundColor = '#333333';
        overlay.style.opacity = '0.2';
    }
    $("body").append(overlay.outerHTML);
    $("#_LOADING_LOCKER_").focus();
};

/**
 *������몄�
 * @example ComUtil.showAppendLayer();
 */
_comUtil.prototype.showAppendLayer = function (info){
    var obj   = document.getElementById(info.id);
    var wd    = info.width;
    var dg    = jQuery.type(info.height) == "undefined" ? $(obj).height() : info.height;
    var _top  = "";
    var _left = "";

    if(_LAYER_YN_ != "Y") {
    	ComUtil.showLocker();
    }

    try {
        obj.style.width  = wd+'px';
        obj.style.height = dg+'px';
        obj.style.zIndex = 999999;

        if(obj != null && obj != undefined) {
            obj.style.visibility = "visible";
            obj.style.display    = "";

            if(_LAYER_YN_ == "Y") {
                _left = (  ($("body").width()  - $(obj).width())  / 2 );
                _top  = (  ($("body").height() - $(obj).height()) / 2 );
            } else {
                _left = ( $(window).scrollLeft() + ($(window).width()  - $(obj).width())  / 2 );
                _top  = ( $(window).scrollTop()  + ($(window).height() - $(obj).height()) / 2 );
            }
        }

        $(obj).offset({left : _left, top : _top});

        obj.style.visibility = "visible";
        obj.style.display    = "";
    } catch(e) {
    }
};

/**
 * 濡��諛����
 * @param fn : 肄�갚�⑥�
 * @example ComUtil.showloading();
 */
_comUtil.prototype.showloading = function (){
	try{$("#_LOADING_").find("img").attr("src", "/QMS/img/loading_img.jpg");}catch(e){}
	ComUtil.showAppendLayer({width:176, height:112, id:"_LOADING_"});
};
/**
 * 濡��諛���
 * @param fn : 肄�갚�⑥�
 * @example ComUtil.hideloading();
 */
_comUtil.prototype.hideloading = function (val){
	ComUtil.hideAppendLayer({id:"_LOADING_"});
	try{$("#_LOADING_").find("img").removeAttr("src"); }catch(e){}finally{$("#_LOADING_").hide();}
	
};

/**
 * 濡��諛���
 * @param fn : 肄�갚�⑥�
 * @example ComUtil.hideAppendLayer();
 */
_comUtil.prototype.hideAppendLayer = function (info){
 try {
        if(_LAYER_YN_ != "Y") ComUtil.hideLocker($("#_LOADING_LOCKER_"));

        var obj = document.getElementById(info.id);
        obj.style.width      = "0px";
        obj.style.height     = "0px";
        obj.style.visibility = "hidden";
        obj.style.display    = "none";

        if(jQuery.type(info) != "undefined" && jQuery.type(info.focusid) != "undefined") {
        	$("#" + info.focusid).focus();
        }
    } catch(e) {
    }
};
/**
 * 諛깃렇�쇱�������굅
 * @param aElement
 */
_comUtil.prototype.hideLocker = function (aElement){
	aElement.remove();
};

/**
 * 鍮���몄� �щ� check
 * @param val empthCheck瑜���� 媛�
 * @return isEmpty : true,false;
 */
_comUtil.prototype.isEmpty = function (val){
	var isEmpty = false;
	
	if(undefined == val || null == val || ("string" == typeof(val) && "" == $.trim(val))){
		isEmpty = true;
	}
	return isEmpty;
};

/**
 * target �������� 紐⑤� 媛�� 吏���� 
 * input - 媛�� 吏��
 * select - 泥ル�吏멸���default濡�蹂�꼍
 * @params $target
 */
_comUtil.prototype.clearVal = function ($target){
	$target.find("input").val("");
	$target.find("select").each(function(){
		$(this).find("option").removeAttr("selected");
		$(this).find("option:first").attr("selected","selected").trigger('change');
	});
	//$target.find("select").find("option:first").attr("selected","selected").trigger('change');
}; 

/**
 * �ㅽ���������濡���㈃���щ�以����
 */
_comUtil.prototype.moveScrollTop = function(){
	$("html,body").animate({
		scrollTop:0
	}, 100, function(){
		$("html,body").clearQueue();
	});
};

/**
 * 濡�렇���щ� return 
 * @return isLogin - true,false;
 */
_comUtil.prototype.isLogin = function(){
	var loginYn = "N"; 
	
	try {
		var ajax = jex.createAjaxUtil("SA1000_04");
		//怨듯�遺�         		
		ajax.set("TASK_PACKAGE", "com" );
		// [���]��Т package
		// 媛��遺�
		ajax.execute(function(dat) {
			try{
				loginYn = dat['_tran_res_data'][0]['LOGIN_YN'];
			} catch(e) {bizException(e, "ISLOGIN");}
		});
	} catch(e) {bizException(e, "ISLOGIN");}
	
	if("Y" == loginYn){
		return true;
	}
	
	return false;
};


/**
 * 濡����㈃ start - ajax �щ�踰��몄���媛��泥��濡�泥�━��꼍���ъ�
 */
_comUtil.prototype.startLoading = function(){
	_callAppAction(ActionCode.LOADING_START,false);	//loading ��� 
};


/**
 * 濡����㈃ end - ajax �щ�踰��몄���媛��泥��濡�泥�━��꼍���ъ�
 */
_comUtil.prototype.endLoading = function(){
	_callAppAction(ActionCode.LODING_END,false);	//loading ��
};


/**
 * Iphone �몄� �щ�瑜�return �댁���
 * @return true,false
 */
_comUtil.prototype.isIphone = function(){
	var userAgent = navigator.userAgent;
	var idx = userAgent.indexOf("nma-plf=");
	var plf = "";
	
	if(-1 != idx){
		plf = userAgent.substr(idx+8,3);
	}
	
	if("IOS" == plf){
		return true;
	}
	
	return false;
	/*if((navigator.userAgent.indexOf("iPhone") != -1) ||
			(navigator.userAgent.indexOf("iPod") != -1) ||
			(navigator.userAgent.indexOf("iPad") != -1)){
		return true;
	} else {
		return false;
	}*/
};

/**
 * Android phone�몄� �щ�瑜�return ���.
 * @return true,false
 */
_comUtil.prototype.isAndroid = function(){
	
	var userAgent = navigator.userAgent;
	var idx = userAgent.indexOf("nma-plf=");
	var plf = "";
	
	if(-1 != idx){
		plf = userAgent.substr(idx+8,3);
	}
	
	if("ADR" == plf){
		return true;
	}
	
	return false;
	
	/*if (navigator.userAgent.indexOf("Android") != -1){
		return true;
	} else {
		return false;
	}*/
};

/**
 * Iphone�몄� Android �몄� �щ�瑜�return ���.
 * @return A,I,X
 */
_comUtil.prototype.getPhoneType = function(){
	if(_comUtil.getInstance().isIphone()) return "I";
	if(_comUtil.getInstance().isAndroid()) return "A";
	return "X";
};

/**
 * Device ID 媛���ㅺ린 
 * @return 
 */
_comUtil.prototype.getDeviceid = function(){
	var _appDiviceid = ""; 
	
	var nAppDeviceid = navigator.userAgent.indexOf("nma-uid=");
	if (nAppDeviceid != -1) _appDeviceid = navigator.userAgent.substring(nAppDeviceid+8).split(";")[0];
    return _appDeviceid;
};

/**
 * Device Type 媛���ㅺ린 
 * @returns {String}
 */
_comUtil.prototype.getAppType = function(){
	var _appType = ""; 
	var nAppKindIdx = navigator.userAgent.indexOf("nma-app-type=");
	if (nAppKindIdx != -1) _appType = navigator.userAgent.substring(nAppKindIdx + 13).split(";")[0];
	
    return _appType;
};

/**
 * Device App Version 媛���ㅺ린 
 * @returns {String}
 */
_comUtil.prototype.getAppVersion = function(){
	var _appVer = ""; 
	var nAppVerIdx = navigator.userAgent.indexOf("nma-plf-ver=");
	if (nAppVerIdx != -1) _appVer = navigator.userAgent.substring(nAppVerIdx + 12).split(";")[0];
	
    return _appVer;
};

/**
 * [怨��由ъ��멸��몄�湲� 
 * 媛���Т��留�� String �몄�媛����
 * 諛�� : combo list data
 * @example
 * ComUtil.getAccountList("cust_no_list") 	: 怨��踰�� 媛���ㅺ린 
 * ComUtil.getAccountList("pay_acntno_list")	: 湲곗� 異��怨��
 * ComUtil.getAccountList("pay_acntno")		: 
 * ComUtil.getAccountList("listbox_acct_res")	: ��껜怨�� 媛���ㅺ린
 * �깅�.. (�몄�媛�����몃��대� �ㅻ���AS-IS瑜�李몄“)
 */
_comUtil.prototype.getAccountList = function(acctName, moneyYn){
	try {
		var money = "N";
		
		if( !_comUtil.getInstance().isNull(moneyYn) ){
			moeny = moneyYn;
		}
		
		var ajax = jex.createAjaxUtil("COMSES");	
	    ajax.setAsync(false);
        ajax.set("TASK_PACKAGE",        "com" );					//[���]��Т package  
        ajax.set("FUNC_NAME",         	"getAccountList" );		//[���]function name
        ajax.set("SESSION_NAME",        acctName);
        ajax.set("MONEY",        money);
        return ajax.execute(function(dat) {})["_tran_res_data"][0]["list"];
   
	} catch(e) {bizException(e, "ComUtil : getAccountList");}
};

/**
 * [怨��由ъ��멸��몄�湲�2] 
 * 媛���Т��留�� String �몄�媛����
 * 諛�� : combo list data
 * @example
 * comSpbsUtil.getComSessionUtil_2("listbox_acct_terminate", "01,02,03,04,06,07", "in")	: �댁�怨�� 媛���ㅺ린
 * �깅�.. (�몄�媛�����몃��대� �ㅻ���AS-IS瑜�李몄“)
 */
_comUtil.prototype.getAccountList2 = function(acctName, acntGm, inoutGb){
	try {
		var ajax = jex.createAjaxUtil("COMSES");	
	    ajax.setAsync(false);
	    //ajax.setErrTrx(false);
        ajax.set("TASK_PACKAGE",        "com" );					//[���]��Т package  
        ajax.set("FUNC_NAME",         	"getAccountList2" );	//[���]function name
        ajax.set("SESSION_NAME",        acctName);
        ajax.set("ACNT_GM",        		acntGm);					//���怨��援щ�肄��(ex. "93,96,97")-�����援щ���� �ㅼ���肄��瑜����媛��
        ajax.set("INOUT_GB",        	inoutGb);					//IN-OUT 援щ�肄��:in-�ы����醫� out-�ы�������怨��)
        return ajax.execute(function(dat) {})["_tran_res_data"][0];
    } catch(e) {bizException(e, "ComUtil : getAccountList2");}
};

/**
 * login setComUserSession Setting
 * 
 * [���]
 * comSpbsUtil.setComUserSession()
 * userId
 * email
 * juminNo
 * rpprRrno
 * brno
 * crno
 * userId
 * userIp
 * userName
 * hpNo
 * idcrDtlDscd	: 媛��踰�����援щ�肄��
 */
_comUtil.prototype.getUserSession = function(){
	try {
		var userSession = {};
		var ajax = jex.createAjaxUtil("COMUTIL");	
	    ajax.setAsync(false);
        ajax.set("TASK_PACKAGE",        "com" );						//[���]��Т package  
        ajax.set("FUNC_NAME",         	"userSession" );				//[���]function name
        ajax.execute(function(dat) {
        	try{
        		
        		userSession = dat["_tran_res_data"][0]["userSession"];	// JSON.parse() !!
        		
        		//comUserSession.js ���ъ���������
        		/*comUserSession_getContextName = resultDat["userId"];
        		comUserSession_getEmail = resultDat["email"];
        		comUserSession_getJuminNo = resultDat["juminNo"];
        		comUserSession_getLoginTime = resultDat["loginTime"];
        		comUserSession_getRpprRrno = resultDat["rpprRrno"];
        		comUserSession_getBrno = resultDat["brno"];
        		comUserSession_getCrno = resultDat["crno"];
        		comUserSession_getUserId = resultDat["userId"];
        		comUserSession_getUserIp = resultDat["userIp"];
        		comUserSession_getUserName = resultDat["userName"];
        		comUserSession_getHpNo = resultDat["hpNo"];
        		comUserSession_getIdcrDtlDscd = resultDat["idcrDtlDscd"];
        		
        		comUserSession_get = resultDat["hpNo"];
        		*/
        		
            } catch(e) {bizException(e, "ComUtil:getUserSession");}
        });	
        
        return userSession;
        
    } catch(e) {bizException(e, "ComUtil : getUserSession");}
};

/**
 * �몄�留ㅼ껜諛��援щ�(Y:蹂댁�移대�, O:OTP, N:誘몃�湲�
 * [���]
 * comSpbsUtil.getSIY()
 */
_comUtil.prototype.getSIY = function(){
	try {
		var ajax = jex.createAjaxUtil("COMUTIL");	
	    ajax.setAsync(false);
        ajax.set("TASK_PACKAGE",        "com" );		//[���]��Т package  
        ajax.set("FUNC_NAME",         	"SIY" );		//[���]function name
        return ajax.execute(function(dat) {})["_tran_res_data"][0]["SIY"];			//��������� KEY name : resultDat ���������
    } catch(e) {bizException(e, "ComUtil : getSIY");}
};

/**
 * MenuId瑜��깆� ��꺼二쇰㈃ 濡�렇�몃�踰⑥� 泥댄���� �대���� 濡�렇�명��댁�濡��대��� �깆����ㅼ� 肄�갚��諛�� 硫���대����뱀���泥�━���.
 * MobUtil.menuLink() 瑜��몄���� 硫���대���媛���⑸���
 * parameter��寃쎌� key��value留��ｌ�二쇰㈃ ����쇰� url ���濡�留���댁����. ex) ../fxg/fxg020101.html?crnc_cd=USD&inqy_base_day=2013-05-29
 * @param pages	ex)../fxg/fxg020101.html
 * @param options  
 * 		params			: link瑜��듯� ��만 data  ex) [{"key":"age","value":16},{"key":"name","value":"�뱀���}]	 
 *		menuId			: menuId
 *		changeTitle		: title 蹂�꼍 �щ� (default:Y)
 * @example 
 *     var option = [
 * 				{ key : "bank_cd",   value : dat.ECFN_BNCD	},
 * 				{ key : "drot_acno", value : dat.DROT_ACNO	},
 * 				{ key : "tran_amt",  value : dat.TRAM1		},
 * 				{ key : "mnrc_acno", value : dat.MNRC_ACNO	}
 * 	   ];
 *    ComUtil.menuLink("/jsp/view/fsc/fsc020101.jsp","AIB_MENU1_2", {"params":option});
 */
_comUtil.prototype.menuLink = function(pages,menuId,options){
	var strLink = pages;
	var params = "";
	var inputParams = undefined;
	var changeTitle = "Y";			//�����蹂�꼍�щ�
	if( undefined != options){
		inputParams = (undefined == options['params'])? undefined : options['params'];
		changeTitle = ("Y" == options['changeTitle'])? undefined : options['changeTitle'];
	}
	
	if(undefined != inputParams){
		strLink += "?";
		for(var i = 0; i < inputParams.length; i++){
			if(i == 0){
				params += inputParams[i]['key']+"="+inputParams[i]['value'];
			}else{
				params = params + "&"+inputParams[i]['key']+"="+inputParams[i]['value'];
			}
		}
		strLink +=  params;
	}
	if(_comUtil.getInstance().isIphone()){
		strLink = "/"+strLink.substring(strLink.indexOf("view"));
		window.location = "iwebactionneoibk:{\"_action_code\":\""+ActionCode.MOVE_MENU+"\",\"_menu_id\":\""+ menuId +"\",\"_action_url\":\""+ strLink +"\",\"_is_change_title\":\""+changeTitle+"\"}";
	} else if(_comUtil.getInstance().isAndroid()){
		//window.BrowserBridge.iwebaction("{\"_action_code\":\"5007\",\"_menu_id\":\""+ menuId +"\",\"_location_href\":\""+ strLink +"\",\"is_change_title\":\""+changeTitle+"\"}");
		window.BrowserBridge.iwebactionneoibk("{\"_action_code\":\""+ ActionCode.MOVE_MENU + "\",\"_menu_id\":\""+ menuId +"\",\"_location_href\":\""+ strLink +"\",\"_is_change_title\":\""+changeTitle+"\",\"_func_name\":\"callBackMenuLink\"}");
	}else {
		location.href = strLink + params;
	}
};

/**
 * �깆� 硫�� title��蹂�꼍�⑸���
 * @param menuId 
 */
_comUtil.prototype.changeMenuId = function(menuId){
	if(_comUtil.getInstance().isIphone()){
//		alert("act_5007?_menu_id:"+menuId);
	} else if(_comUtil.getInstance().isAndroid()){
//		alert("title android");
		window.BrowserBridge.iwebaction("{\"_action_code\":\""+ActionCode.CHANGE_MENU_TITLE+"\",\"_menu_id\":\""+ menuId +"\"}");
	}
};

/**
 * �ㅻ�硫��吏�異�� 
 * @param exection
 * @param funName
 * @return
 */
_comUtil.prototype.bizException = function(e, funName){
	ComPopup.showErrorPopup(e, funName);
};
var ComUtil = _comUtil.getInstance();

/**
 * menuLink �⑥� �몄���callback
 * @param data
 */
function callBackMenuLink(data){

	// ������寃�
	if("Y" == data['_is_change_title']){
		var menuId = data['_menu_id'];
		if(ComUtil.isIphone()){
//			alert("act_5007?_menu_id:"+menuId);
		} else if(ComUtil.isAndroid()){
			window.BrowserBridge.iwebaction("{\"_action_code\":\""+ActionCode.CHANGE_MENU_TITLE+"\",\"_menu_id\":\""+ menuId +"\"}");
		}
	}
	
	//���吏����
	location.href = data['_location_href'];
}

/**
 * �ㅻ�硫��吏�異�� 
 * @param exection
 * @param funName
 * @return
 */
function bizException(e, funName){
	ComPopup.showErrorPopup(e, funName);
};

/**
 * ��� �щĸ�� 
 * @param date���
 * @param funName
 * @return
 */
function _date (dat) {
	if(dat == "0") return "-";//gro020200
	if(dat.length > 8 ) dat = dat.replace("-","").substring(0,8); 
	dat = dat.substring(0,4)+"-"+dat.substring(4,6)+"-"+dat.substring(6,8);
	return dat;
}