var listMethod = "doList";/* 리스트 Action */
var updateMethod = "doUpdate";/* Update Action */
var deleteMethod = "doDelete";/* Delete Action & Event */
var createMethod = "doCreate";/* Create Action */
var detailFormMethod = "doDetail";/* Detail Action */
var updateFormMethod = "doUpdateForm";/* Update Event */
var createFormMethod = "doCreateForm";/* Create Action */
var updateCancel = "doUpdateCancel";/* Update Cancel Event */
var deleteCancel = "doDeleteCancel";/* Delete Cancel Event */

var EXT_ALERT = "alert";
var EXT_ERROR = "error";
var EXT_INFO = "info";
var EXT_WARNING = "warning";



/*
 * 팝업창 띄우는 부분 공통함수.
 * @param length  :
 * @param menuUrl :
 * @param clientFlag :
 * @param localeCode :
 * @param pageGuideSeq :
 * @param commonFlag :
 */
function popupCookie(length, menuUrl, clientFlag, localeCode, pageGuideSeq, commonFlag){
	var index  = length;
	var widthX;
	var cookieName = menuUrl + clientFlag + localeCode + pageGuideSeq;
	var noticeCookie = getPopupCookie(cookieName);

	if(commonFlag != null){
		eval('document.all.notice_cform'+index).cookieName.value = cookieName;/* noticeCookie */
	}else{
		eval('document.all.notice_form'+index).cookieName.value = cookieName;/* noticeCookie */
	}

	widthX = 30+(360*index);

	var _popupCookie = 'pop'+index;
	/* 팝업창을 띄운다 ... */
	if(noticeCookie != "no"){
		if(commonFlag != null){
			_popupCookie = window.open('','noticeCPop'+index,"width=350,height=300,top=460,left="+widthX+",scrollbars=yes,resizeble=no");
			_popupCookie.opener = self;
			eval('document.notice_cform'+index).submit();
		}else{
			_popupCookie = window.open('','noticeIPop'+index,"width=350,height=300,top=130,left="+widthX+",scrollbars=yes,resizeble=no");
			_popupCookie.opener = self;
			eval('document.notice_form'+index).submit();
		}
	}
}



/**
 * 팝업을 띄운다.
 * @param url 팝업을 띄울 URL
 * @param title 팝업의 타이틀
 * @param width 팝업의 WIDTH
 * @param height 팝업의 HEIGHT
 * @param scroll 스크롤바 사용여부
 */
function _popup(url, title, width, height, scroll)
{
	var xPos = (window.screen.availWidth - width)/2;
	var yPos = (window.screen.availHeight - height)/2;

	win = window.open(url,title,'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars='+scroll+',toolbar=no,resizable=no,copyhistory=no,width='+width+',height='+height+',left='+ xPos +',top='+ yPos+'\'');
	win.focus();
}

/**
 * 팝업을 띄운다.
 * @param url 팝업을 띄울 URL
 * @param title 팝업의 타이틀
 * @param width 팝업의 WIDTH
 * @param height 팝업의 HEIGHT
 * @param scroll 스크롤바 사용여부
 */
function popupAllAttr(url, title, width, height, scroll)
{
	var xPos = (window.screen.availWidth - width)/2;
	var yPos = (window.screen.availHeight - height)/2;

	win = window.open(url,title,'toolbar=yes,location=yes,directories=no,status=yes,menubar=yes,scrollbars='+scroll+',resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+ xPos +',top='+ yPos+'\'');
	win.focus();
}

/**
 * 리사이즈 가능한 팝업을 띄운다.
 * @param url 팝업을 띄울 URL
 * @param title 팝업의 타이틀
 * @param width 팝업의 WIDTH
 * @param height 팝업의 HEIGHT
 * @param scroll 스크롤바 사용여부
 */
function popupResizable(url, title, width, height, scroll)
{
	var xPos = (window.screen.availWidth - width)/2;
	var yPos = (window.screen.availHeight - height)/2;

	win = window.open(url,title,'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars='+scroll+',toolbar=no,resizable=yes,copyhistory=no,width='+width+',height='+height+',left='+ xPos +',top='+ yPos+'\'');
 	win.focus();
}

/**
 * 현재 브라우저가 팝업이면 화면중앙에 리사이즈후 다시그려준다.
 */
function isPopChk() {
	if(opener != undefined) {
		var popWidth = document.body.scrollWidth + 10;
		var popHeight = document.body.scrollHeight + 100;

		self.moveTo(screen.width/2-(popWidth/2),screen.height/2-(popHeight/2));
		self.resizeTo(popWidth , popHeight);
	}
}

function getObj( form, obj )
{
    return document[getNetuiTagName(form)][getNetuiTagName(obj)];
}

function getValue( form, obj )
{
    return getObj(form, obj).value;
}

function setValue( form, obj, val )
{
    document[getNetuiTagName(form)][getNetuiTagName(obj)].value = val;
}

function ckNull( name, i )
{
    /* var oO = eval( document.all[name][i] );  */
    var oO = ckNullOo( name, i );

    if( oO !=null&&oO.value != "undefined")
    {
        return oO.value;
    }
    else
    {
        return document.all[name].value;
    }
}

function ckNullOo( name, i)
{
    var oOb = eval( document.all[name] );

    if( oOb!=null ) {

        var oO = oOb[i];

        if( oO !=null&&oO.value != "undefined")
        {
            return oO;
        }
        else
        {
            return document.all[name];
        }
    }
}


function clipText(str, len) {
    if (str == null || str == '') return '';

    if (str.length <= len) return str;

    var rValue;
	var nLength;

	nLength = 0.00;
	rValue = '';

	var tmpCode;
	var tmpStr;
	var tmpLen = 0;
	for (var i=0; i < str.length; i++) {
		tmpCode = str.charCodeAt(i);
		tmpStr = str.charAt(i);
		if (tmpCode >= 65 && tmpCode <= 90) { /* Big English  */
			tmpLen += 0.71;
			rValue += tmpStr;
		}
		else if (tmpCode >= 97 && tmpCode <= 122) { /* Small English  */
			tmpLen += 0.5;
			rValue += tmpStr;
		}
		else if (tmpCode > 128) { /* Korean */
			tmpLen += 1;
			rValue += tmpStr;
		}
		else { /* Etc Symbol  */
			tmpLen += 0.42;
			rValue += tmpStr;
		}

		if (tmpLen >= len) {
			break;
		}
	}
    if (tmpLen > (len - 1)) {
        rValue += '...';
    }

	return rValue;

/*
	var len = parseInt(length);
	if (text.length <= len) {
		return text;
	}
	else {
		return text.substring(0, len) + '...';
	}*/
}


/**
 * 좌우 공백 제거 trim()
 */
String.prototype.trim = function()
{
    return this.replace(/(^\s*)|(\s*$)/g, "");
};



/*
------------------------------- 날짜 관련 script ------------------------------------------

 사용방법 : <input name="dd"  size="10" maxlength="8" style="ime-mode:disabled"  onKeyPress="return onlyNum()" onFocus="removeDate()" onBlur="formatDate()">

  onkeypress="return onlyNum()" onfocus="removeDate()" onblur="formatDate()"
  style="ime-mode:disabled"     <-- 한글일때 OnkeyPress 이벤트가 스크립트 버그로 반응을 안하기때문에
  스타일로 원천적으로 봉쇄합니다.
  input box에다가 위의 이밴트만 설정해두면 이벤트 일어난 객체를 가지고 하기때문에 객체에 값이 셋팅됩니다.

---------------------------------------------------------------------------------------------
*/

/**
 * 입력한 값이 숫자인지 확인한다.
 * @return 숫자:true, 숫자가 아닐경우:false
 */
function onlyNum() {
  var keycode = event.keyCode;

  /*  48->0  57->9  */
  if (keycode >= 48 && keycode <=57) {
    return true;
  }

   return false;
}

/**
 * 날짜값이 입력된 필드에 이벤트가 발생할경우  필드에서 '-' 값을 제거한후 해당 필드에 포커스를 맞춘다.
 * ex> 2008-08-25 ☞ 20080825
 */
var dateGuBun = '-';
var dateGuBun2 = /\-/g;
function removeDate() {
  var field = event.srcElement;

  var value = field.value;

  if (value == "") {
    return;
  }

  field.value = (value.replace(dateGuBun2,"")).replace(" ","");
  setFocus(field);
}

/**
 * 날짜필드의 YYYYMMDD의 날짜를 YYYY-MM-DD로 바꿔 세팅한다.
 * onblur 이벤트에 사용함.
 * isHour 속성을 부여하여 시간까지 표현 가능하도록 수정함
 */
function formatDate() {
  var field = event.srcElement;

  var value = rmDate(field.value);

  if (value == "") {
    return;
  }

  if (field.isMonth == "Y") {
    if (value.length != 6) { /*  자리수 체크(년월)  */
      i18nExtAlert("날짜가 잘못 입력되었습니다. 다시 입력하세요. (예: 200308)");
      field.value = "";
      setFocus(field);
      return;
    }

    if (!checkDate2(value)) { /*  날짜 validation  */
      i18nExtAlert("존재하지 않는 날짜입니다. 확인 후 다시 입력하세요.");
      field.value = "";
      setFocus(field);
      return;
    }

    field.value = plusDate2(value);
  }
  else if (field.isHour == "Y") {
    if (value.length != 10) { /*  자리수 체크(년월일시)  */
      i18nExtAlert("날짜가 잘못 입력되었습니다. 다시 입력하세요. (예: 2003080411)");
      field.value = "";
      setFocus(field);
      return;
    }

    if (!checkDate2(value.substring(0,8))) {
      i18nExtAlert("존재하지 않는 날짜입니다. 확인 후 다시 입력하세요.");
      field.value = "";
      setFocus(field);
      return;
    }

    var tmpTime = new Number(value.substring(8,10));
    if (tmpTime >= 24) {
      i18nExtAlert("시간은 23시까지만 입력할 수 있습니다. 확인 후 다시 입력하세요.");
      field.value = "";
      setFocus(field);
      return;
    }

    field.value = plusDate(value) + " " + value.substring(8,10);
  }
  else {
    if (value.length != 8) { /*  자리수 체크  */
      i18nExtAlert("날짜가 잘못 입력되었습니다. 다시 입력하세요. (예: 20030809)");
      field.value = "";
      setFocus(field);
      return;
    }

    if (!checkDate(value)) { /*  날짜 validation  */
      i18nExtAlert("존재하지 않는 날짜입니다. 확인 후 다시 입력하세요.");
      field.value = "";
      setFocus(field);
      return;
    }

    field.value = plusDate(value);
  }

}

/**
 * YYYYMMDD의 날짜를 YYYY-MM-DD로 바꾼 후 리턴한다.
 * @param value - 8자리 날짜
 * @return format 된 10자리 날짜
 */
function plusDate(value) {
  if (value == "") {
    return value;
  }

  var yyyy = value.substring(0, 4);
  var   mm = value.substring(4, 6);
  var   dd = value.substring(6, 8);

  return yyyy + dateGuBun + mm + dateGuBun + dd;
}


/**
 * YYYY-MM-DD 형식의 날짜의 validation.
 * @param value - 날짜
 * @return boolean - 올바른 날짜면 true, 아니면 false
 */
function checkDate(value) {
  if(value.length != 8) {
    return false;
  }
  var yyyy = eval(value.substring(0, 4));
  var   mm = eval(value.substring(4, 6));
  var   dd = eval(value.substring(6, 8));

  var date = new Date(yyyy, mm-1, dd);

  if (yyyy != date.getFullYear() ||
        mm != (date.getMonth()+1) ||
        dd != date.getDate()) {
    return false;
  }

  return true;
}

/**
 * YYYY-MM-DD의 날짜를 YYYYMMDD로 바꾼 후 리턴한다.
 * isHour 속성을 부여하여 시간까지 표현 가능하도록 수정함
 * @param value - 10자리 날짜
 * @return format이 제거된 8자리 날짜
 */
function rmDate(value) {
  return (value.replace(dateGuBun2,"")).replace(" ","");
}

/**
 * 입력받은 필드로 포커스를 옮긴다.
 * @param field - 필드객체
 */
function setFocus(field) {
  try {
    if (field.type == "text") {
      if (field.value != '') {
        field.select();
      }
      else {
        field.focus();
      }
    }
    else {
      field.focus();
    }
  } catch (e) { }
}

/* ----------------------------------------- End =-------------------------------------------------------------------*/


/**
 * 올바른 이메일인지 체크한다.
 * @param src - 체크할 이메일 스트링
 * @return true / false
 */
function checkIsValidEmail(field) {
	if (field.value.search(/(\S+)@(\S+)\.(\S+)/) == -1 ) {
		return false;
	}

	return true;
}

/**
  * 들어온 Object가 배열인지를 구별한다.
  * @param obj - 체크할 Object
  * @return boolean 배열인경우 true, 아니면 false를 반환한다.
  */
function isArray(obj) {
	return(typeof(obj.length)=="undefined") ? false : true;
}


/**
 * 객체를 인자로 받아 인자가 원래 array 이면 그대로 리턴하고, 아니면 크기가 1인 array로 만들어 리턴한다.
 * @param oneOrArray
 */
function getObjArray(oneOrArray){

	if(oneOrArray==null) return null;
	else if(oneOrArray.length >= 1){
		return oneOrArray;
	}else{
		var newArray = new Array(1);
	    newArray[0]  = oneOrArray;
		return newArray;
	}

}



/**
 * 한글 2글자 영문 1글자로 길이 측정하여 최대 길이 이상이면 alert를 띄우고 잘라낸다.
 * @param textObj 길이체크를할 객체
 * @param length_limit 지정한 최대 길이
 */
function checkStrLength(textObj, length_limit)
{
	var comment = textObj;
	var length = calculate_msglen(comment.value);
	var kor_cnt = Math.floor(length_limit/2);
	if (length > length_limit) {
		i18nExtAlert("한글 "+ kor_cnt + "자, 영문 " +length_limit + "자를 초과할 수 없습니다.");
		comment.value = comment.value.replace(/\r\n$/, "");
		comment.value = assert_msglen(comment.value, length_limit);
		comment.focus();
	}
}

/**
 * 문자열의 byte 길이를 리턴한다.
 * @param message 문자열
 * @return 문자열의 byte길이
 */
function calculate_msglen(message)
{
	var nbytes = 0;

	for (var i=0; i<message.length; i++) {
		var ch = message.charAt(i);
		if(escape(ch).length > 4) {
			nbytes += 2;
		} else if (ch == '\n') {
			if (message.charAt(i-1) != '\r') {
				nbytes += 1;
			}
		} else if (ch == '<' || ch == '>') {
			nbytes += 4;
		} else {
			nbytes += 1;
		}
	}

	return nbytes;
}

/**
 * 해당 길이(byte)만큼 문자열을 잘라낸 후 리턴한다.
 * @param message 자를 문자열
 * @param maximum 잘라질 문자열 길이
 * @return 해당 길이 만큼 잘라진 문자열
 */
function assert_msglen(message, maximum)
{
	var inc = 0;
	var nbytes = 0;
	var msg = "";
	var msglen = message.length;

	for (var i=0; i<msglen; i++) {
		var ch = message.charAt(i);
		if (escape(ch).length > 4) {
			inc = 2;
		} else if (ch == '\n') {
			if (message.charAt(i-1) != '\r') {
				inc = 1;
			}
		} else if (ch == '<' || ch == '>') {
			inc = 4;
		} else {
			inc = 1;
		}
		if ((nbytes + inc) > maximum) {
			break;
		}
		nbytes += inc;
		msg += ch;
	}
	return msg;
}

/**
 * 공백 스트링 체크
 * @param 체크할 문자열
 */
function isEmpty(s){
	return ((s == null) || (s.length == 0));
}

var whitespace = " \t\n\r";
/**
 * 인자로 넘어온 문자열이 공백인지 체크
 * @param s 체크할 문자열
 * @return 공백:true, 공백아님:false
 */
function isWhitespace(s){
      if (isEmpty(s)) return true;
      for (var i = 0; i < s.length; i++) {
       var c = s.charAt(i);
       if (whitespace.indexOf(c) == -1) return false;
      }
  		return true;
}




/**
 * 체크박스가 선택되었는지 확인한다.
 * @return 선택:true , 미선택:false
 */
function isChecked_All() {
    var form = arguments[0]; /* form object */
    var msg  = arguments[1]; /* message */

    if(msg==null) msg = "체크박스를 선택해 주세요";
    var chk = 0;

    for(var i = 0; i < form.elements.length ; i++) {
       if ((form.elements[i].type == "checkbox") && (form.elements[i].checked == true)) {
           chk++;break;
       }
    }

    if (chk == 0 ) {
    	i18nExtAlert(msg);
    	return false;
    } else {
    	return true;
    }
}


/**
 * 체크박스 전체 선택
 * @param flagName 전체선택 checkbox 명(일반html)
 * @param formName 폼 tagId (netui)
 * @param chekboxName checkbox tagId (netui)
 */
function checkAllSel(flagName, formName, chekboxName)
{
    var flag = eval("document.all."+flagName+".checked");
    var checkbx = document[getNetuiTagName(formName)][getNetuiTagName(chekboxName)];

    if(checkbx == null) return;

    if(checkbx.length == null)
    {
        checkbx.checked = flag;
    }
    else
    {
        for(var i = 0; i < checkbx.length; i++)
        {
            checkbx[i].checked = flag;
        }
    }
}



/**
 * 선택된 라디오버튼의 값을 얻는다.
 * @param chkObj 라디오버튼 객체
 * @return 선택된 라디오버튼 값
 */
function getCheckedValue(chkObj){

    var radio = getObjArray(chkObj);
    var val = "";
    for(var i=0; i<radio.length; i++){
        if(radio[i].checked){
            val = radio[i].value;
            break;
        }
    }

    return val;
}

/**
 * 라디오버튼이 선택되었는지 확인한다.
 * @param chkObj 라디오버튼 객체
 * @param 라디오 버튼이 하나라도 체크되어있으면 true , 하나도 체크 안되있으면 false
 */
function isRadioChecked(chkObj){
	var radio = getObjArray(chkObj);
	for(var i=0; i<radio.length; i++){
		if(radio[i].checked){
			return true;
		}
	}

	return false;
}



/**
 * 등록,삭제,수정을 위한 함수
 */
function submitCommand( targetMethod )
{
	form1.targetMethod.value=targetMethod;
	ValidateForm();
}

/**
 * 조회를 위한 submit
 */
function xSubmit(form) {
	/*		XecureSubmit(form1);*/

		document.form1.submit(); 
}

/**
 * 페이징에서 조회를 하기 위한 함수
 */
function goSearch( command,_page ) {
	with ( document.form1 ) {
		reset();
		if( _page != null && _page !="" ) {
			page.value=_page;
		}
		action = command; /* "packageName.ClassName.exe"; */
/* 		targetMethod.value=listMethod; */

		/*		XecureSubmit(form1);*/

		if(typeof(beforeGoSearchAtDbPaging) == 'function'){
			beforeGoSearchAtDbPaging();
		}
 		document.form1.submit(); 
	}
}


/**
 * 보고서 출력
 * <br>ex : goReport("test.rep")
 * @param fileName : 파일 명
 */
function goReport(fileName) {
	var oldTarget = document.form1.target;
	with (form1) {
		setSendValue("cmd=report&reportFileName=" + fileName);
		target = "Hidden";
		formSubmit();
		target = oldTarget;
		setSendValue("cmd= &reportFileName= ");
	}
}

/**
 * 엑셀 출력
 * <br>ex : goReport("test.csv")
 * @param fileName : 파일 명
 */
function goExcel(fileName) {
	var oldTarget = document.form1.target;
	with (form1) {
		setSendValue("cmd=excel&excelFileName=" + fileName);
		method = "GET";
		target = "Hidden";
		formSubmit();
		target = oldTarget;
		method = "POST";
		setSendValue("cmd= &excelFileName= ");
	}
}


/*
 * pdf export
 */
function goPdf()
{
        var oldTarget = document.form1.target;

        var cmd = document.createElement("input");
        cmd.type = "hidden";
        cmd.name = "cmd";
        cmd.value = "pdf";

        with (form1) {
                appendChild(cmd);
                target = "Hidden";
                formSubmit();
                target = oldTarget;
                method = "POST";
                removeChild(cmd);
                submitstat = "false";
        }
}

/**
 * 외환은행 계좌 번호 마스크 씌우기.
 * <br>ex : onkeyup="javascript:formatKebAct(this)"
 * @param elem : mask 할 객체
 */
function formatKebAct(elem){

	if ( event.keyCode < 32 ) return elem;

	if( (event.shiftKey == false && event.keyCode > 47 && event.keyCode < 58 ) || (event.keyCode > 64 && event.keyCode < 90 ) || (event.keyCode > 96 && event.keyCode < 123 ))
	{
	} else {
		if(event.keyCode == 37 || event.keyCode == 38 || event.keyCode == 39 || event.keyCode == 40 || event.keyCode == 229)
		{}else{
			elem.value = elem.value.substring(0,elem.value.length-1);
		}
	}

	var acNo=elem.value.replace(/-|\//g,"");
	var acNoLength=acNo.length;


	if (acNoLength <= 3) {
		return;
	}

	/* 차세대계좌번호  */
	if(acNo.substr(0, 1) == "6" || acNo.substr(0, 1) == "7" || acNo.substr(0, 1) == "8" || acNo.substr(0, 1) == "9") {
		if ((acNoLength >= 4) && (acNoLength < 10)) {
			elem.value = acNo.substr(0,3)+"-"+acNo.substring(3);
		}
		else if ( acNoLength >= 10 ) {
			elem.value = acNo.substr(0,3)+"-"+acNo.substr(3,6)+"-"+acNo.substring(9);
		} else elem.value = acNo;

	/* 현세대계좌번호 */
	} else {

		if (acNoLength == 4) {
			elem.value = acNo.substr(0,3)+"-"+acNo.substring(3);
		} else if (acNoLength == 5) {
			elem.value = acNo.substr(0,3)+"-"+acNo.substring(3)+"-";
		} else if (acNoLength >= 6)	{

			/* 4,5,6 번째 값이 모두 숫자가 아니면 외화 계좌로 취급 */
			if( (acNo.substr(3,1) <= 9) || (acNo.substr(4,1) <= 9) || (acNo.substr(5,1) <= 9) )
			{
				if ((acNoLength >= 6) && (acNoLength <= 10)) {
					elem.value = acNo.substr(0,3)+"-"+acNo.substr(3,2)+"-"+acNo.substring(5);
				}
				else if (acNoLength == 11) {
					elem.value = acNo.substr(0,3)+"-"+acNo.substr(3,2)+"-"+acNo.substr(5,5)+"-"+acNo.substring(10);
				}
				else if (acNoLength > 11) {
					elem.value = acNo.substr(0,3)+"-"+acNo.substr(3,2)+"-"+acNo.substr(5,7)+"-"+acNo.substring(12);
				} else return acNo;

			} else /* 외화계좌 */
			{
				if ((acNoLength >= 6) && (acNoLength <= 11)) {
					elem.value = acNo.substr(0,3)+"-"+acNo.substr(3,3)+"-"+acNo.substring(6);
				}
				else if (acNoLength == 12) {
					elem.value = acNo.substr(0,3)+"-"+acNo.substr(3,3)+"-"+acNo.substr(6,5)+"-"+acNo.substring(11);
				}
				else if( acNoLength >= 13) {
					elem.value = acNo.substr(0,3)+"-"+acNo.substr(3,3)+"-"+acNo.substr(6,6)+"-"+acNo.substring(12);
				} else return acNo;
			}
		}
	}
}


/**
 * 레이어를 띄우기 위한 함수
 * @param url : iframe의 src에 속하는 url
 * @param divOjb : 레이어를 띄울 div객체 ("layerDiv" div 안에 속한 div여야 한다.)
 * @param width : iframe의 width
 * @param height : iframe의 height
 * @param xpos : 특정위치에 띄우고 싶을경우 x-position
 * @param ypos : 특정위치에 띄우고 싶을경우 y-position
 */
var div_left; /* 레이어 팝업의 가로경로 */
var div_top; /* 레이어 팝업의 세로경로 */
function open_layer(url, divObj, width, height, xpos, ypos) {	/* 375,360 */
	var obj = document.getElementById(divObj);
	//var inner_iframe_txt = '<iframe name="'+ divObj+"_frame"+'" src="' + url + '" width="' + width + '" height="'+ height +'" border="0" frameBorder="0" marginneight="0" marginwidth="0" frameSpacing="0" scrolling="no" onload="this.style.height=this.contentWindow.document.body.scrollHeight">';
	var inner_iframe_txt = '<iframe name="'+ divObj+"_frame"+'" src="' + url + '" width="' + width + '" height="'+ height +'" border="0" frameBorder="0" marginneight="0" marginwidth="0" frameSpacing="0" scrolling="no">';	
	inner_iframe_txt += '</iframe>';

	if(obj != null && obj != undefined) {
		obj.innerHTML = inner_iframe_txt;
		obj.style.display = "block";

		sw=document.documentElement.clientWidth;
		sh=document.documentElement.clientHeight;

		if(xpos != undefined || ypos != undefined){
			div_left = (xpos == undefined ? ((div_left == undefined) ? 0:div_left):xpos) + document.documentElement.scrollLeft;
			div_top  = (ypos == undefined ? ((div_top == undefined)  ? 0:div_top):ypos) + document.documentElement.scrollLeft;
		}else if(divObj == "layerDiv_process") {
		/* 진행 프로세스 레이어 일경우는 가운데 띄운다. */
			div_left = (sw / 2) - 232/2 + document.documentElement.scrollLeft;/* obj.offsetWidth/2; */
            div_top  = (sh / 2) - 100/2 + document.documentElement.scrollTop;/* obj.offsetHeight/2; */
		}else {
		/* 공지사항이나 시스템공지일 경우는 좌측상단 부터 띄운다. */
			div_left = (div_left == undefined ? 0:div_left) + document.documentElement.scrollLeft;
			div_top = (div_top == undefined ? 0:div_top) + document.documentElement.scrollTop;

			/* 브라우저 사이즈 보다 팝업의 추가된후 브라우저 사이즈가 넘을경우 */
			if(sw == 0 ) {
				div_top = 0;
			}else if(sw < (div_left + width)*1) {
				div_left = 0;
				div_top = div_top + height;
			}
		}
		obj.style.left = div_left;
		obj.style.top = div_top;
		obj.style.display = "block";
	}
}

function close_layer(divObj) {
	var obj = document.getElementById(divObj);
	document.getElementById('layerDiv_background').style.display = "none";
	obj.style.display = "none";
}

/**
 * iframe이 아닌 만들어진 HTML 형식을 그려준다.
 */
function open_layer_html(txt, divObj, width, height, xpos, ypos) {
	var div_left,div_top;
    var inner_html_txt = txt;
    var $obj = $("#" + divObj);

    if($obj != null && $obj != undefined) {
    	$obj.empty();
    	$obj.append(inner_html_txt);

        var __scrollLeft = $(window).scrollLeft();
        var __scrollTop = $(window).scrollTop();
        var sw = $(document).width();
        var sh =  $(document).height();

        if(width == undefined) {
        	width = 232; /*  처리중입니다 이미지의 가로크기 */
        }
        if(height == undefined) {
        	height = 100; /*  처리중입니다 이미지의 세로크기 */
        }
        if(xpos != undefined || ypos != undefined){
            div_left = (xpos == undefined ? ((div_left == undefined) ? 0:div_left):xpos) + __scrollLeft;
            div_top  = (ypos == undefined ? ((div_top == undefined)  ? 0:div_top):ypos) + __scrollTop;
            
        }else if(divObj == "layerDiv_process" || divObj == "layerDiv_emergency" || divObj == "layerDiv_errPop" || divObj == "layerDiv_system") {
        	/* 진행 프로세스 레이어나 긴급공지 , 에러 팝업 일경우는 가운데 띄운다. */
            div_left = (sw / 2) - width/2 + __scrollLeft;/* obj.offsetWidth/2; */
            div_top  = (sh / 2) - height/2 + __scrollTop;/* obj.offsetHeight/2; */            
            if(divObj == "layerDiv_errPop") hideAllLayer();
        }else if(divObj == "layerDiv_msg_confirm") {
        	/* alert대체창일 경우  가운데 띄운다. */
            div_left = (sw / 2) - width/2 + __scrollLeft;/* obj.offsetWidth/2; */
            div_top  =  (sh / 2) - height/2 + __scrollTop;/* obj.offsetHeight/2; */
            if(divObj == "layerDiv_errPop") hideAllLayer();
        }else {
       		/* 공지사항이나 시스템공지일 경우는 좌측상단 부터 띄운다. */
            div_left = (div_left == undefined ? 0:div_left) + __scrollLeft;
            div_top = (div_top == undefined ? 0:div_top) + __scrollTop;
            /* 브라우저 사이즈 보다 팝업의 추가된후 브라우저 사이즈가 넘을경우 */
            if(sw < div_left + width) {
            div_left = 0;
            div_top = div_top + height;
        	}
        }

        if(divObj == "layerDiv_errPop") {
			$('#layerDiv_iframe').show();
			$('#layerDiv_iframe').css("display","block");
        }

        if(divObj == "layerDiv_msg_confirm") {
            $obj.css("width", 350 + "px");
            $obj.css("height", 400 + "px");
        }
        $obj.css("width", width + "px");
        $obj.css("height", height + "px");
        
        $obj.css("left", div_left + "px");
        $obj.css("top", div_top + "px");
        $obj.show();
    }
}

/**
 *	에러 팝업 레이어를 제외하고 display = none 시킨다.
 */
function hideAllLayer() {
	var parentLayer = document.getElementById("layerDiv");
	if(parentLayer != undefined) {
		$("#layerDiv_notice0").hide();
		$("#layerDiv_notice1").hide();
		$("#layerDiv_notice2").hide();
		$("#layerDiv_notice3").hide();
		$("#layerDiv_system").hide();
		$("#layerDiv_emergency").hide();
		$("#layerDiv_process").hide();
		$('#layerDiv_background').hide();
	}
}

/**
 *	진행중입니다 레이어를 띄운다
 * @param localeCode : 언어코드
 * @param useYn : 사용유무 (N일경우에는 안띄움. 기본값 띄움.)
 * @param modalYn : Modal 구분
 */
function openProcessLayer(localeCode,useYn,modalYn) {
	if(useYn != "N") {
//		if(modalYn == "Y") {
			$('#layerDiv_background').show();
			$('#layerDiv_background').css("left", "0px");
			$('#layerDiv_background').css("top", "0px");
			$('#layerDiv_background').css("width",  $(document).width() + "px");
			$('#layerDiv_background').css("height", $(document).height() + "px");
			$('#iframe_processLayer').show();
			$('#iframe_processLayer').css("width",  $(document).width() + "px");
			$('#iframe_processLayer').css("height", $(document).height() + "px");
//		}
		open_layer_html(makeProcessText(localeCode),"layerDiv_process");
	}
}

function makeProcessText(localeCode) {
//	var subfix = "";
//    if(localeCode == "EN") subfix = "_EN";
//	var htmlText = "<table width=\"232\" height=\"100\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\" >" +
//				   "<tr><td align=\"center\" style=\"padding: 0 0 0 0\">" +
//				   "<object classid=\"clsid:D27CDB6E-AE6D-11cf-96B8-444553540000\" codebase=\"http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,19,0\" width=\"232\" height=\"100\" title=\"processbar\">" +
//				   "<param name=\"movie\" value=\"/swf/processbar"+subfix+".swf\" />" +
//				   "<param name=\"quality\" value=\"high\" />" +
//				   "<embed src=\"/swf/processbar"+subfix+".swf\" quality=\"high\" pluginspage=\"http://www.macromedia.com/go/getflashplayer\" type=\"application/x-shockwave-flash\" width=\"232\" height=\"100\"></embed>" +
//				   "</object></td></tr></table>";
//	var htmlText = "<div class=\"boxGraySkinny loading\">" +
//					"<div><img src=\"/images/all/loading.gif\" alt=\"" + _loadingI18n01 + "\" /></div>" +
//					//"<div><img src=\"/images/all/loading.gif\" alt=\"" + <%= %>+ "\" /></div>" +
//					"<p class=\"mT20\">" + _loadingI18n01 + _loadingI18n02 + "</p></div>";	
	if(localeCode == "" || localeCode == "undefined"){
		localeCode = "EN";
	}else if(localeCode.toUpperCase() == "JP"){
		localeCode = "JA";
	}
	
	var __imgFolder = localeCode.toLowerCase();

	var htmlText = "<div class=\"loading\">" + 
	               "<img src=\"/images/" + __imgFolder + "/loading.gif\" alt=" + _loadingI18n03 + _loadingI18n04 + _loadingI18n05 + " />" +
	               "</div>";

	return htmlText;
}

function makeProcessLayerMsg(localeCode) {
	var subfix = "";
    if(localeCode == "EN") subfix = "_EN";
    var htmlText = "<h1 class='x-window-header'></h1>" +
        		   "<div class='x-window-body'>" +
            	   "	<div class='pop_content' style='width:232px;'>" +
                   "	<object classid='clsid:D27CDB6E-AE6D-11cf-96B8-444553540000' codebase='http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,19,0' width='232' height='100' title='processbar'>" +
                   "		<param name='movie' value='../swf/processbar2"+subfix+".swf' />" +
                   "		<param name='quality' value='high' />" +
                   "		<embed src='/swf/processbar2"+subfix+".swf' quality='high' pluginspage='http://www.macromedia.com/go/getflashplayer' type='application/x-shockwave-flash' width='232' height='100'></embed>" +
                   "	</object>" +
            	   "	</div>" +
        		   "</div>";

    return htmlText;
}

function closeProcessLayer() {
	close_layer("layerDiv_process");
}


function minusDay(targetId, pDay){
	var today = new Date();

	var year = today.getFullYear();
	var month = today.getMonth(); /* 월을 구하기 위해서는 반드시 +1을 해 줘야 한다. */
	var day = today.getDate(); /* 일을 구한다. */

	var oDate; /*  리턴할 날짜 객체 선언 */

	day = day*1 - pDay*1; /*  날짜 계산 */

	oDate = new Date(year, month, day); /*  계산된 날짜 객체 생성 (객체에서 자동 계산) */

	year = oDate.getFullYear(); /*  계산된 년도 할당 */

	month = oDate.getMonth()+1; /*  계산된 월 할당 */

	day = oDate.getDate(); /*  계산된 일자 할당 */

	if(month < 10)	month = "0" + month;
		if(day < 10)	day = "0" + day;

	targetId.value = year+"" +month+ "" + day;
}

function minusMonth(targetId, pMonth){
	var today = new Date();

	var year = today.getFullYear();
	var month = today.getMonth()+1; /* 월을 구하기 위해서는 반드시 +1을 해 줘야 한다. */
	var day = today.getDate(); /* 일을 구한다. */

	var cDate; /*  계산에 사용할 날짜 객체 선언 */

	var oDate; /*  리턴할 날짜 객체 선언 */

	var cYear, cMonth, cDay; /*  계산된 날짜값이 할당될 변수 */

	month = (month*1)-1 - ((pMonth*1)); /*  월은 0~11 이므로 하나 빼준다 */

	cDate = new Date(year, month, day); /*  계산된 날짜 객체 생성 (객체에서 자동 계산) */

	cYear = cDate.getFullYear(); /*  계산된 년도 할당 */

	cMonth = cDate.getMonth(); /*  계산된 월 할당 */

	cDay = cDate.getDate(); /*  계산된 일자 할당 */

	oDate = (day == cDay) ? cDate : new Date(cYear, cMonth, 0); /*  넘어간 월의 첫쨋날 에서 하루를 뺀 날짜 객체를 생성한다. */


	cYear = cDate.getFullYear();
	cMonth = cDate.getMonth()+1;
	cDay = cDate.getDate();

	if(cMonth < 10)	cMonth = "0" + cMonth;
		if(cDay < 10)	cDay = "0" + cDay;

	targetId.value = cYear+"" +cMonth+ "" + cDay;
}

///**
//*  다국어 alert() 메세지를 출력 (ExtJs용)
//*   ex : i18nExtAlert(msg,'I18NUtil.getLabel(localeCode, "IBA00001")',EXT_INFO,'EN',null)
//* @param {} msg
//* @param {} title
//* @param {} icon
//* @param {} localeCode
//* @param {} elementObj
//*/
function i18nExtAlert(msg, title, icon, localeCode, elementObj, modal, width, height){
	//Layer version..
	/** /
	if(elementObj != undefined && !elementObj.disabled){
		i18nMsgAlert(title, msg, null, (modal || 'Y'),elementObj, width, height);
	} else {
		i18nMsgAlert(title, msg, null, 'Y', null, width,height);
	}
	/**/
	
	/* modal(explore) + alert(etc) version..*/
	var pWidth  = (width ||"400") + "px";
	var pHeight = (height||"250") + "px";
	
	var msgObj = {
			"TITLE": title,
			"MESSAGE": msg,
			"TYPE": "alert",
			"WIDTH": pWidth,
			"HEIGHT": pHeight
	}
	
	//2013-02-27 경고팝업이 alert으로 안뜨면 웹접근성 심사에 걸린다고 함. 익스플로러도 alert으로 변경.
	//if($.browser.msie) {
	if(false) {
		var result = window.showModalDialog("/jsp/common/modal_alert.jsp" , msgObj, 'status:no;help:no;dialogHeight:' + pHeight + ';dialogWidth:' + pWidth + ';Resizable:no;'); 
		if(result && elementObj) {
			$(elementObj).focus();
		}
	}else{
		alert(replaceHtmlTagBR(msg));
		if(elementObj) {
			if($.browser.msie) {
				$(elementObj).focus();
			}else{
				setTimeout(function() {
					$(elementObj).focus();
				}, 1);
			}
		}
	}
	/**/
}

/**
 * HTML TAG에서 <BR> , <br />, <br> 테그등을 \n으로 replace함.
 * @param tag
 */
function replaceHtmlTagBR(tag) {
	return tag.replace(/<\s*(BR|br)\s*\/?>/gi, "\n");
}
function i18nExtConfirm(msg, title, fn, localeCode, elementObj, modal, width, height) {
	//Layer version..
	/** /
	if(elementObj != undefined && !elementObj.disabled){
		i18nMsgAlert(title, msg, fn, (modal || 'Y'),elementObj, width, height, "confirm");
	} else {
		i18nMsgAlert(title, msg, fn, 'Y', null, width,height, "confirm");
	}
	/**/
	
	/* modal(explore) + alert(etc) version.. */
	var pWidth  = (width ||"400") + "px";
	var pHeight = (height||"250") + "px";
	
	var result = false;
	var msgObj = {
			"TITLE": title,
			"MESSAGE": msg,
			"TYPE": "confirm",
			"WIDTH": pWidth,
			"HEIGHT": pHeight
	}
	//2013-02-27 경고팝업이 alert으로 안뜨면 웹접근성 심사에 걸린다고 함. 익스플로러도 alert으로 변경.
	//if($.browser.msie) {
	if(false) {
		result = window.showModalDialog("/jsp/common/modal_alert.jsp" , msgObj, 'status:no;help:no;dialogHeight:' + pHeight + ';dialogWidth:' + pWidth + ';Resizable:no;'); 
	}else{
		result = confirm(replaceHtmlTagBR(msg));
		result = (result) ? "yes":"no"; 
	}
	
	if(result && fn) {
		eval(fn + "('" +result +"')");
		//eval(fn);
	}
	
	if(elementObj) {
		if($.browser.msie) {
			$(elementObj).focus();
		}else{
			setTimeout(function() {
				$(elementObj).focus();
			}, 1);
		}
	}
	/**/
}

function i18nExtAlertFn(msg, title, fn, icon, localeCode, elementObj, modal, width, height){
	//Layer version..
	/** /
	if(elementObj != undefined && !elementObj.disabled){
		i18nMsgAlert(title, msg, fn, (modal || 'Y'),elementObj, width, height, "alertFn");
	} else {
		i18nMsgAlert(title, msg, fn, 'Y', null, width,height, "alertFn");
	}
	/**/
	
	/* modal(explore) + alert(etc) version.. */
	var pWidth  = (width ||"400") + "px";
	var pHeight = (height||"250") + "px";
	
	var msgObj = {
			"TITLE": title,
			"MESSAGE": msg,
			"TYPE": "alertFn",
			"WIDTH": pWidth,
			"HEIGHT": pHeight
	}
	//2013-02-27 경고팝업이 alert으로 안뜨면 웹접근성 심사에 걸린다고 함. 익스플로러도 alert으로 변경.
	//if($.browser.msie) {
	if(false) {
		var result = window.showModalDialog("/jsp/common/modal_alert.jsp" , msgObj, 'status:no;help:no;dialogHeight:' + pHeight + ';dialogWidth:' + pWidth + ';Resizable:no;'); 
	}else{
		alert(replaceHtmlTagBR(msg));
		result = true;
	}
	
	if(result && fn) {
		eval(fn + "('" +result +"')");
	}
	
	if(elementObj) {
		if($.browser.msie) {
			$(elementObj).focus();
		}else{
			setTimeout(function() {
				$(elementObj).focus();
			}, 1);
		}
	}
	/**/
}	

function i18nAlert(title, msg, icon, localeCode, elementObj) {
	alert(msg);
}

///**
// * ext 레이어를 이동  스크립트
// */
//function extWinMove(url){
//	location.href = url;
//}
function extExceptionAlert(dataMap) {
	var title = dataMap.ERROR_TITLE;
	var errMsg = dataMap.RESPONSE_MESSAGE;
	//i18nMsgAlert(title, errMsg, '', 'Y');
	alert(errMsg);
}

/*
 * 쿠키 가져오는 메소드
 * @param name :쿠키 이름.
 */
function getPopupCookie(name) {
	var Found = false;
	var start, end;
	var i = 0;

	while(i <= document.cookie.length) {
		start = i;
		end = start + name.length;

		if(document.cookie.substring(start, end) == name) {
			Found = true;
			break;
		}
		i++;
	}

	if(Found == true) {
		start = end + 1;
		end = document.cookie.indexOf(";", start);
	if(end < start)
		end = document.cookie.length;
		return document.cookie.substring(start, end);
	}
	return "";
}

/*
jsload = function (src) {
	var src = src;
	var script = document.createElement("script");
	script.type = "text/javascript";
	script.src = src;
	document.getElementsByTagName("head")[0].appendChild(script);
}
*/

function addLoadEvent(func) {
	var oldonload = window.onload;
	if (typeof window.onload != 'function') {
	  window.onload = func;
	} else {
		window.onload = function() {
		  oldonload();
		  func();
		}
	}
}

/**
* extExceptionAlert창을 Ajax에러 발생시  띄우는 스크립트
* @param dataMap : 오류정보가 들어있는 dataMap
*/
function ajaxExceptionAlert(dataMap) {
	var schIDGubun = "";
		// ajax에러시 에러팝업 호출
		var errMsg = dataMap.RESPONSE_MESSAGE;
		var errorCode = dataMap.ERROR_CODE;
		var title = dataMap.ERROR_TITLE;
		var errorLevel = "1";						//넘어오는 에러레벨이 없는 케이스이므로 디폴트 값을 1로 둠
		var modal = "N";							// ajax에러시 모달이어야 함
		var errBtnNameArr = dataMap.BTN_NAME_ARRY;
		var errBtnUrlArr= dataMap.BTN_URL_ARRY;
		var errTempBottom = "N";
		var btnCloseYn = "";
		var elementID;
		var nextUrl = dataMap.NEXT_URL;

		if(dataMap.Modal != undefined || dataMap.Modal != ""){
			modal = dataMap.Modal ;
		}

		if(dataMap.BTN_CLOSE_YN != undefined || dataMap.BTN_CLOSE_YN != ""){
			btnCloseYn = dataMap.BTN_CLOSE_YN ;
		}

		if(dataMap.FOCUS_TARGET != undefined || dataMap.FOCUS_TARGET != ""){
			elementID = dataMap.FOCUS_TARGET ;
		}

		var errObject = {
			errMsg : errMsg
			, errorCode : errorCode
			, errorLevel : errorLevel
			, title : title
			, modal : modal
			, errBtnNameArr : errBtnNameArr
			, errBtnUrlArr : errBtnUrlArr
			, errTempBottom : errTempBottom
			, btnCloseYn : btnCloseYn
			, elementID : elementID
			, guideMessage : null
			, nextUrl : nextUrl
		};

		if(dataMap.RESPONSE_GUIDE_MESSAGE != undefined || dataMap.RESPONSE_GUIDE_MESSAGE != ""){
			errObject.guideMessage = dataMap.RESPONSE_GUIDE_MESSAGE ;
		}
		showErrorLayerPop(errObject);
}

function onlyNum(value){
	if(isNaN(value)){
		return false;
	}else {
		return true;
	}
}



var listMethod = "doList";//리스트 Action
var updateMethod = "doUpdate";//Update Action
var deleteMethod = "doDelete";//Delete Action & Event
var createMethod = "doCreate";//Create Action
var detailFormMethod = "doDetail";//Detail Action
var updateFormMethod = "doUpdateForm";//Update Event
var createFormMethod = "doCreateForm";//Create Action
var updateCancel = "doUpdateCancel";//Update Cancel Event
var deleteCancel = "doDeleteCancel";//Delete Cancel Event
var popupMethod = "doPopup";//Popup Action

window.history.back=null;
window.history.go=null;
window.history.previous=null;

//document.oncontextmenu = function(){return false}



/**
 * 등록,삭제,수정을 위한 함수
 */
function submitCommand( targetMethod )
{	
	if( targetMethod == deleteMethod )
	{
		if (!confirm("삭제 하시겠습니까?")) {
			return false;
		}
	}
	form1.targetMethod.value=targetMethod;
	ValidateForm();
}

function serviceCommand( _action )
{	 
	document.form1.action = _action;
	ValidateForm();
}


/**
 * 조회를 위한 submit
 */
function xSubmit(form) {
//		XecureSubmit(form);
		form.submit();
}

/**
 * 페이징에서 조회를 하기 위한 함수
 */
function goSearch( command,_page ) {
	with ( form1 ) {
		reset();
		if( _page != null && _page !="" ) {
			page.value=_page;
		}
		action = command; //"packageName.ClassName.exe";
		targetMethod.value=listMethod;
//		XecureSubmit(form1);
		document.form1.submit();
	}
}

/**
 * 달력 년,월,일 셀렉트 박스 만들기 컴포넌트. 이 함수를 호출한 자리에 생성된다.  
 * <br>ex : makeDateSelectBox("20060822","yyyy","mm","dd")
 * @param now : 오늘 날짜
 * @param year : 년도 셀렉트 박스의 name
 * @param month : 월 셀렉트 박스의  name
 * @param date : 일 셀렉트 박스의  name
 */
function makeDateSelectBox(now,year,month,date)
{

	var nYear = now.substring(0,4);
	var sYear = parseInt(nYear,10) - 4;
	var eYear = parseInt(nYear,10) + 4;
	var nMonth = now.substring(4,6);
	var nDate = now.substr(6);

	document.write(makeSelectBoxString(year,"onChangeLeapDate(form1."+year+",form1."+month+",form1."+date+")","select1",sYear,eYear,nYear));
	document.write("년");
	document.write(makeSelectBoxString(month,"onChangeLeapDate(form1."+year+",form1."+month+",form1."+date+")","select1",1,12,nMonth));
	document.write("월");
	document.write(makeSelectBoxString(date,"","select1",1,findLeapEndDate(nYear, nMonth),nDate));
	document.write("일");
}

/**
 * 달력 년,월,일 셀렉트 박스 만들기 컴포넌트. 이 함수를 호출한 자리에 생성된다.  
 * <br>ex : makeDateSelectBox("20060822","yyyy","mm","dd")
 * @param now : 오늘 날짜
 * @param year : 년도 셀렉트 박스의 name
 * @param month : 월 셀렉트 박스의  name
 * @param date : 일 셀렉트 박스의  name
 */
function makeDateSelectBox2(now,year,month)
{

	var nYear = now.substring(0,4);
	var sYear = parseInt(nYear,10) - 4;
	var eYear = parseInt(nYear,10) + 4;
	var nMonth = now.substring(4,6);


	document.write(makeSelectBoxString(year,"","select1",sYear,eYear,nYear));
	document.write("년");
	document.write(makeSelectBoxString(month,"","select1",1,12,nMonth));
	document.write("월");

}


/**
 * 해당 년,월에 맞는 일자 셀렉트 박스의 옵션 생성.
 * <br>ex : onChangeLeapDate(form1.year,form1.month,form1.date)
 * @param year : 년도 정보를 가지고 있는 객체의 form이름.객체이름
 * @param month : 월 정보를 가지고 있는 객체의 form이름.객체이름
 * @param date : 일 정보를 가지고 있는 객체의 form이름.객체이름
 */
function onChangeLeapDate(year,month,date) {

	var i = 1;
	var k = 1;
	date.length = findLeapEndDate(year.value, month.value);
  	var total_days = date.length;
	for (i=1 ;i <= total_days;i++) {
		k = i;
		if(i < 10) k = '0' + k;
		date.options[i-1].text=k;
		date.options[i-1].value=k;
	}

}  


/**
 * 셀렉트 박스 만들기. 주어진 정보를 가지고 셀렉트 박스 만듬. 주로 날짜에 관련되서 사용되고, 숫자에도 사용 가능함. 숫자 이외는 불가.
 * <br>ex : makeSelectBoxString("YYYY","onChangeLeapDate(form1.year,form1.month,form1.date)","select1",1,12,8)
 * @param name : 생성될 셀렉트 박스의 객체이름
 * @param onchange : onChange 이벤트에 할당할 이벤트 컨트롤 자바 스크립트 함수
 * @param classname : 셀렉트 박스에 적용할 css class명
 * @param startNo : 시작 값.
 * @param endNo : 종료 값
 * @param selectedValue : 디폴트 값
 * @return 만들어진 셀렉트 박스 스트링
 */
function makeSelectBoxString(name,onchange,classname,startNo,endNo,selectedValue)
{
	if(!onchange == "")
	{
		onchange = 'onChange="'+onchange+'"';
	}
	if(!classname == "")
	{
		classname = 'class="'+classname+'"';
	}
	var str = '<select '+classname+' name="'+name+'"'+ onchange+'>';
	for(;startNo <= endNo ; startNo++)
	{
		if(startNo == selectedValue)
		{
			if(startNo < 10) {startNo = '0'+startNo;}
			str += '<option value="'+startNo+'" selected>'+startNo;
		} else
		{
			if(startNo < 10) {startNo = '0' + startNo;}
			str += '<option value="'+startNo+'">'+startNo;		
		}
	}
	str += '</select>';
	return str;

}


/**
 * 해당 년,월에 영향을 받는 해당 년월의 마지막 날짜 찾기
 * <br>ex : findLeapEndDate("2006", "2")
 * @param year : 년도 값
 * @param month : 월 값
 * @return 해당 년월의 마지막 날짜
 */
function findLeapEndDate(year, month) {
  	year  = parseInt(year,10);
	month = parseInt(month,10);
	
  	var endDay=31;
	if(month == 2) {
		if(( (year % 4 == 0) && (year % 100 != 0) ) || ( year % 400 == 0 ) ) {
			endDay = 29;
		}
		else {
			endDay = 28;
		}
	}
	else if( (month == 4) || (month == 6) || (month == 9) || (month == 11) ) {
		endDay = 30;
	}
	else {
		endDay = 31;
	}
  	return endDay;
}

/**
 * 보고서 출력
 * <br>ex : goReport("test.rep")
 * @param fileName : 파일 명
 */
function goReport(fileName) {
/*
	var oldTarget = document.form1.target;
	with (form1) {
		setSendValue("cmd=report&reportFileName=" + fileName)
		target = "Hidden";
		formSubmit();
		target = oldTarget;
		setSendValue("cmd= &reportFileName= ");
	}*/
	var oldTarget = document.form1.target;
	
	var cmd = document.createElement("input");
	cmd.type = "hidden";
	cmd.name = "cmd";
	cmd.value = "report";
	
	var reportFileName = document.createElement("input");
	reportFileName.type = "hidden";
	reportFileName.name = "reportFileName";
	reportFileName.value = fileName;
	
	with (form1) {
		appendChild(cmd);
		appendChild(reportFileName);
		target = "Hidden";
		spiderSubmit();
		target = oldTarget;
		removeChild(cmd);
		removeChild(reportFileName);
		submitstat = "false";
	}	
}


/*
 * pdf export
 */
function goPdf()
{
	var oldTarget = document.form1.target;
	
	var cmd = document.createElement("input");
	cmd.type = "hidden";
	cmd.name = "cmd";
	cmd.value = "pdf";
	
	with (form1) {
	    appendChild(cmd);
	    target = "Hidden";
	    spiderSubmit();
	    target = oldTarget;
	    method = "POST";                
	    removeChild(cmd);
	    submitstat = "false";
	}
}


/**
 * 엑셀 출력
 * <br>ex : goReport("test.csv")
 * @param fileName : 파일 명
 */
function goExcel(fileName) {
/*
	var oldTarget = document.form1.target;
	with (form1) {
		setSendValue("cmd=excel&excelFileName=" + fileName)
		method = "GET";
		target = "Hidden";
		formSubmit();
		target = oldTarget;
		method = "POST";
		setSendValue("cmd= &excelFileName= ");
	}
	*/
	
	var oldTarget = document.form1.target;
	
	var cmd = document.createElement("input");
	cmd.type = "hidden";
	cmd.name = "cmd";
	cmd.value = "excel";
	/*
	var excelFileName = document.createElement("input");
	excelFileName.type = "hidden";
	excelFileName.name = "excelFileName";
	excelFileName.value = fileName;
	*/
	with (form1) {
		appendChild(cmd);
//		appendChild(excelFileName);
		method = "GET";
		target = "Hidden";
		spiderSubmit();
		target = oldTarget;
		method = "POST";
		removeChild(cmd);
//		removeChild(excelFileName);
		submitstat = "false";
	}	
}


/**
 * 외환은행 계좌 번호 마스크 씌우기.
 * <br>ex : onkeyup="javascript:formatKebAct(this)"
 * @param elem : mask 할 객체
 */
function formatKebAct(elem){

	if ( event.keyCode < 32 ) return elem;

	if( (event.shiftKey == false && event.keyCode > 47 && event.keyCode < 58 ) || (event.keyCode > 64 && event.keyCode < 90 ) || (event.keyCode > 96 && event.keyCode < 123 ))
	{
	} else {
		if(event.keyCode == 37 || event.keyCode == 38 || event.keyCode == 39 || event.keyCode == 40 || event.keyCode == 229)
		{}else{ 
			elem.value = elem.value.substring(0,elem.value.length-1);
		}
	}

	var acNo=elem.value.replace(/-|\//g,"");
	var acNoLength=acNo.length;


	if (acNoLength <= 3) {
		return;
	} 
	
	//차세대계좌번호
	if(acNo.substr(0, 1) == "6" || acNo.substr(0, 1) == "7" || acNo.substr(0, 1) == "8" || acNo.substr(0, 1) == "9") {
		if ((acNoLength >= 4) && (acNoLength < 10)) {
			elem.value = acNo.substr(0,3)+"-"+acNo.substring(3);
		}
		else if ( acNoLength >= 10 ) {
			elem.value = acNo.substr(0,3)+"-"+acNo.substr(3,6)+"-"+acNo.substring(9);
		} else elem.value = acNo;

	//현세대계좌번호
	} else {
		
		if (acNoLength == 4) {
			elem.value = acNo.substr(0,3)+"-"+acNo.substring(3);
		} else if (acNoLength == 5) {
			elem.value = acNo.substr(0,3)+"-"+acNo.substring(3)+"-";
		} else if (acNoLength >= 6)	{

			//4,5,6 번째 값이 모두 숫자가 아니면 외화 계좌로 취급
			if( (acNo.substr(3,1) <= 9) || (acNo.substr(4,1) <= 9) || (acNo.substr(5,1) <= 9) )
			{
				if ((acNoLength >= 6) && (acNoLength <= 10)) {
					elem.value = acNo.substr(0,3)+"-"+acNo.substr(3,2)+"-"+acNo.substring(5);
				}
				else if (acNoLength == 11) {
					elem.value = acNo.substr(0,3)+"-"+acNo.substr(3,2)+"-"+acNo.substr(5,5)+"-"+acNo.substring(10);
				}
				else if (acNoLength > 11) {
					elem.value = acNo.substr(0,3)+"-"+acNo.substr(3,2)+"-"+acNo.substr(5,7)+"-"+acNo.substring(12);
				} else return acNo;
				
			} else //외화계좌
			{
				if ((acNoLength >= 6) && (acNoLength <= 11)) {
					elem.value = acNo.substr(0,3)+"-"+acNo.substr(3,3)+"-"+acNo.substring(6);
				}
				else if (acNoLength == 12) {
					elem.value = acNo.substr(0,3)+"-"+acNo.substr(3,3)+"-"+acNo.substr(6,5)+"-"+acNo.substring(11);
				}
				else if( acNoLength >= 13) {
					elem.value = acNo.substr(0,3)+"-"+acNo.substr(3,3)+"-"+acNo.substr(6,6)+"-"+acNo.substring(12);
				} else return acNo;			
			}
		}
	}
}



/**
 * 기간 조회시 시작일자 ~ 종료일자 타입에서 기간을 정해서 사용할때 사용
 * <br>ex : setSearchDate('form1.시작일자','form1.종료일자',-7) -> form1.시작일자.value=오늘일자+ -7일전 날자, 'form1.종료일자'.value=오늘 일자
 * @param before : 세번째 파라미터로 받은 몇일 후 날짜를 셋팅할 객체
 * @param after : 오늘 날짜를 셋팅할 객체
 * @param day : 몇일간의 기간. 0일 경우 당일 조회로 before,after객체의 날짜는 같다. 
 */
function setSearchDate(before,after,day) {
	var beforeDate = eval(before);
	var afterDate = eval(after);

	var nowDate = new Date();
	var nextDate = new Date();
	nextDate.setDate(nowDate.getDate()+day); 
	
	var yyyy = nowDate.getYear();
	var mm = nowDate.getMonth()+1;
	var dd = nowDate.getDate();
	if(mm < 10) mm = "0"+mm;
	if(dd < 10) dd = "0"+dd;
	
	afterDate.value = yyyy+"-"+mm+"-"+dd;

	yyyy = nextDate.getYear();
	mm = nextDate.getMonth()+1;
	dd = nextDate.getDate();
	if(mm < 10) mm = "0"+mm;
	if(dd < 10) dd = "0"+dd;

	beforeDate.value = yyyy+"-"+mm+"-"+dd;	
}

//현재 월의 일수 계산
function getNowDate(){

	var nowDate = new Date();
	var yyyy = nowDate.getYear();
	var mm = nowDate.getMonth()+1;

	return findLeapEndDate(yyyy,mm);
}

function goReload(command, gubun) {
	form1.action = command+"?gubun="+gubun;
	form1.submit();
}


// Number and '-' key input agree
function setKeyDateType(e)
{
    if(event.keyCode < 48 || event.keyCode > 57)  // this is not number type
    {
        // enter, tab, backspace... 
        if(event.keyCode == 8 || event.keyCode == 9 
            || event.keyCode == 37 || event.keyCode == 39)  // || event.keyCode == 45)  // '-'
        {
                return true;
        }
        event.returnValue = false;
    }
    else  // this is number type (YYYY-MM-DD)
    {
        var dateValue = e.srcElement.value;
        
        if(dateValue != "" && dateValue != null)
        {
            if(dateValue.length == 4)
            {
                e.srcElement.value = dateValue + "-";
            }
            else if(dateValue.length == 7)
            {
                e.srcElement.value = dateValue + "-";
            }
            else if(dateValue.length == 6)
            {
                var monthPrefix = dateValue.substring(5, 6);
                if(monthPrefix != "0" && monthPrefix != "1")
                {
                    e.srcElement.value = dateValue.substring(0, 5) + "0" 
                        + dateValue.substring(5, 6) + "-" + dateValue.substring(6);
                }
            }
        }
    }
} 



function isAllNumeric(SrcStr)
{

    var str = "1234567890";

    for (ki=0; ki < SrcStr.length; ki++)
    {
        sstr = SrcStr.charAt(ki);

        if(str.indexOf(sstr) == -1) return false;
    }
    return true;
}

function isAllNumericOrPointOrHipon(SrcStr)
{

    var str = "-1234567890.";

    for (ki=0; ki < SrcStr.length; ki++)
    {
        sstr = SrcStr.charAt(ki);

        if(str.indexOf(sstr) == -1) return false;
    }
    return true;
}

function isAllNumericOrPoint(SrcStr)
{

    var str = "1234567890.";

    for (ki=0; ki < SrcStr.length; ki++)
    {
        sstr = SrcStr.charAt(ki);

        if(str.indexOf(sstr) == -1) return false;
    }
    return true;
}

function isAllNumericOrHiPon(num)
{

    var str = "-1234567890 ";

    for (ki=0; ki < num.length; ki++)
    {
        sstr = num.charAt(ki);
        if(str.indexOf(sstr) == -1) return false;
    }
    return true;
}

function int_check(str)
{
    if(str.charAt(0) >= 0 && str.charAt(0) < 9)
    {
        return false;
    }

    return true;
}


function eng_check(str)
{
    var tmp;

    for(i=0; i < str.length; i++)
    {
        tmp = str.charAt(i);
        if(tmp >=  "a"  && tmp <= "z"  || tmp >=  "A"  && tmp <= "Z"  || tmp >=  "0"  && tmp <= "9"  || tmp == "," || tmp == "." || tmp == " ")
        {
            continue;
        }
        else
        {
            return false;
        }
    }

    return true;
}


function eng_check1(str)
{
    var tmp;
    for(i=0; i < str.length; i++)
    {
        tmp = str.charAt(i);

        if(tmp >=  "a"  && tmp <= "z"  || tmp >=  "A"  && tmp <= "Z"  || tmp >=  "0"  && tmp <= "9"  || tmp == "," || tmp == " " || tmp.indexOf("@")!=-1 || tmp.indexOf(".")!=-1 || tmp.indexOf("_")!=-1 || tmp.indexOf("-")!=-1)
        {
            continue;
        }
        else
        {
            return false;
        }
    }

    return true;
}


/**
 * 8자리 날짜 체크 로직
 * <br> ex : validateDate8("20050822")
 * @param cDate : 8자리 날짜 스트링
 * @return boolean
 */
function validateDate8(cDate)
{
	if(cDate.length != 8) 
	{
		alert("날짜의 길이가 잘못 입력 되었습니다.");
		return false;
	}
	var yyyy = cDate.substring(0, 4);
	var mm = cDate.substring(4, 6) - 1;//12월일 경우 날짜 생성해서 보면 getMonth()로 보면 0으로 리턴되므로 1을 빼준다.
	var dd = cDate.substring(6);
	var checkDate = new Date(yyyy, mm, dd);

	if ( checkDate.getFullYear() != yyyy ||	checkDate.getMonth() != mm || checkDate.getDate() != dd) 
	{
		delete checkDate;
		alert("날짜 형식이 유효하지 않습니다.");
		return false;
	}
	delete checkDate;
	return true;

} 
