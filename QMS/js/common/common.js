var listMethod = "doList";/* ����Ʈ Action */
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
 * �˾�â ���� �κ� �����Լ�.
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
	/* �˾�â�� ���� ... */
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
 * �˾��� ����.
 * @param url �˾��� ��� URL
 * @param title �˾��� Ÿ��Ʋ
 * @param width �˾��� WIDTH
 * @param height �˾��� HEIGHT
 * @param scroll ��ũ�ѹ� ��뿩��
 */
function _popup(url, title, width, height, scroll)
{
	var xPos = (window.screen.availWidth - width)/2;
	var yPos = (window.screen.availHeight - height)/2;

	win = window.open(url,title,'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars='+scroll+',toolbar=no,resizable=no,copyhistory=no,width='+width+',height='+height+',left='+ xPos +',top='+ yPos+'\'');
	win.focus();
}

/**
 * �˾��� ����.
 * @param url �˾��� ��� URL
 * @param title �˾��� Ÿ��Ʋ
 * @param width �˾��� WIDTH
 * @param height �˾��� HEIGHT
 * @param scroll ��ũ�ѹ� ��뿩��
 */
function popupAllAttr(url, title, width, height, scroll)
{
	var xPos = (window.screen.availWidth - width)/2;
	var yPos = (window.screen.availHeight - height)/2;

	win = window.open(url,title,'toolbar=yes,location=yes,directories=no,status=yes,menubar=yes,scrollbars='+scroll+',resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+ xPos +',top='+ yPos+'\'');
	win.focus();
}

/**
 * �������� ������ �˾��� ����.
 * @param url �˾��� ��� URL
 * @param title �˾��� Ÿ��Ʋ
 * @param width �˾��� WIDTH
 * @param height �˾��� HEIGHT
 * @param scroll ��ũ�ѹ� ��뿩��
 */
function popupResizable(url, title, width, height, scroll)
{
	var xPos = (window.screen.availWidth - width)/2;
	var yPos = (window.screen.availHeight - height)/2;

	win = window.open(url,title,'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars='+scroll+',toolbar=no,resizable=yes,copyhistory=no,width='+width+',height='+height+',left='+ xPos +',top='+ yPos+'\'');
 	win.focus();
}

/**
 * ���� �������� �˾��̸� ȭ���߾ӿ� ���������� �ٽñ׷��ش�.
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
 * �¿� ���� ���� trim()
 */
String.prototype.trim = function()
{
    return this.replace(/(^\s*)|(\s*$)/g, "");
};



/*
------------------------------- ��¥ ���� script ------------------------------------------

 ����� : <input name="dd"  size="10" maxlength="8" style="ime-mode:disabled"  onKeyPress="return onlyNum()" onFocus="removeDate()" onBlur="formatDate()">

  onkeypress="return onlyNum()" onfocus="removeDate()" onblur="formatDate()"
  style="ime-mode:disabled"     <-- �ѱ��϶� OnkeyPress �̺�Ʈ�� ��ũ��Ʈ ���׷� ������ ���ϱ⶧����
  ��Ÿ�Ϸ� ��õ������ �����մϴ�.
  input box���ٰ� ���� �̹�Ʈ�� �����صθ� �̺�Ʈ �Ͼ ��ü�� ������ �ϱ⶧���� ��ü�� ���� ���õ˴ϴ�.

---------------------------------------------------------------------------------------------
*/

/**
 * �Է��� ���� �������� Ȯ���Ѵ�.
 * @return ����:true, ���ڰ� �ƴҰ��:false
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
 * ��¥���� �Էµ� �ʵ忡 �̺�Ʈ�� �߻��Ұ��  �ʵ忡�� '-' ���� �������� �ش� �ʵ忡 ��Ŀ���� �����.
 * ex> 2008-08-25 �� 20080825
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
 * ��¥�ʵ��� YYYYMMDD�� ��¥�� YYYY-MM-DD�� �ٲ� �����Ѵ�.
 * onblur �̺�Ʈ�� �����.
 * isHour �Ӽ��� �ο��Ͽ� �ð����� ǥ�� �����ϵ��� ������
 */
function formatDate() {
  var field = event.srcElement;

  var value = rmDate(field.value);

  if (value == "") {
    return;
  }

  if (field.isMonth == "Y") {
    if (value.length != 6) { /*  �ڸ��� üũ(���)  */
      i18nExtAlert("��¥�� �߸� �ԷµǾ����ϴ�. �ٽ� �Է��ϼ���. (��: 200308)");
      field.value = "";
      setFocus(field);
      return;
    }

    if (!checkDate2(value)) { /*  ��¥ validation  */
      i18nExtAlert("�������� �ʴ� ��¥�Դϴ�. Ȯ�� �� �ٽ� �Է��ϼ���.");
      field.value = "";
      setFocus(field);
      return;
    }

    field.value = plusDate2(value);
  }
  else if (field.isHour == "Y") {
    if (value.length != 10) { /*  �ڸ��� üũ(����Ͻ�)  */
      i18nExtAlert("��¥�� �߸� �ԷµǾ����ϴ�. �ٽ� �Է��ϼ���. (��: 2003080411)");
      field.value = "";
      setFocus(field);
      return;
    }

    if (!checkDate2(value.substring(0,8))) {
      i18nExtAlert("�������� �ʴ� ��¥�Դϴ�. Ȯ�� �� �ٽ� �Է��ϼ���.");
      field.value = "";
      setFocus(field);
      return;
    }

    var tmpTime = new Number(value.substring(8,10));
    if (tmpTime >= 24) {
      i18nExtAlert("�ð��� 23�ñ����� �Է��� �� �ֽ��ϴ�. Ȯ�� �� �ٽ� �Է��ϼ���.");
      field.value = "";
      setFocus(field);
      return;
    }

    field.value = plusDate(value) + " " + value.substring(8,10);
  }
  else {
    if (value.length != 8) { /*  �ڸ��� üũ  */
      i18nExtAlert("��¥�� �߸� �ԷµǾ����ϴ�. �ٽ� �Է��ϼ���. (��: 20030809)");
      field.value = "";
      setFocus(field);
      return;
    }

    if (!checkDate(value)) { /*  ��¥ validation  */
      i18nExtAlert("�������� �ʴ� ��¥�Դϴ�. Ȯ�� �� �ٽ� �Է��ϼ���.");
      field.value = "";
      setFocus(field);
      return;
    }

    field.value = plusDate(value);
  }

}

/**
 * YYYYMMDD�� ��¥�� YYYY-MM-DD�� �ٲ� �� �����Ѵ�.
 * @param value - 8�ڸ� ��¥
 * @return format �� 10�ڸ� ��¥
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
 * YYYY-MM-DD ������ ��¥�� validation.
 * @param value - ��¥
 * @return boolean - �ùٸ� ��¥�� true, �ƴϸ� false
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
 * YYYY-MM-DD�� ��¥�� YYYYMMDD�� �ٲ� �� �����Ѵ�.
 * isHour �Ӽ��� �ο��Ͽ� �ð����� ǥ�� �����ϵ��� ������
 * @param value - 10�ڸ� ��¥
 * @return format�� ���ŵ� 8�ڸ� ��¥
 */
function rmDate(value) {
  return (value.replace(dateGuBun2,"")).replace(" ","");
}

/**
 * �Է¹��� �ʵ�� ��Ŀ���� �ű��.
 * @param field - �ʵ尴ü
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
 * �ùٸ� �̸������� üũ�Ѵ�.
 * @param src - üũ�� �̸��� ��Ʈ��
 * @return true / false
 */
function checkIsValidEmail(field) {
	if (field.value.search(/(\S+)@(\S+)\.(\S+)/) == -1 ) {
		return false;
	}

	return true;
}

/**
  * ���� Object�� �迭������ �����Ѵ�.
  * @param obj - üũ�� Object
  * @return boolean �迭�ΰ�� true, �ƴϸ� false�� ��ȯ�Ѵ�.
  */
function isArray(obj) {
	return(typeof(obj.length)=="undefined") ? false : true;
}


/**
 * ��ü�� ���ڷ� �޾� ���ڰ� ���� array �̸� �״�� �����ϰ�, �ƴϸ� ũ�Ⱑ 1�� array�� ����� �����Ѵ�.
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
 * �ѱ� 2���� ���� 1���ڷ� ���� �����Ͽ� �ִ� ���� �̻��̸� alert�� ���� �߶󳽴�.
 * @param textObj ����üũ���� ��ü
 * @param length_limit ������ �ִ� ����
 */
function checkStrLength(textObj, length_limit)
{
	var comment = textObj;
	var length = calculate_msglen(comment.value);
	var kor_cnt = Math.floor(length_limit/2);
	if (length > length_limit) {
		i18nExtAlert("�ѱ� "+ kor_cnt + "��, ���� " +length_limit + "�ڸ� �ʰ��� �� �����ϴ�.");
		comment.value = comment.value.replace(/\r\n$/, "");
		comment.value = assert_msglen(comment.value, length_limit);
		comment.focus();
	}
}

/**
 * ���ڿ��� byte ���̸� �����Ѵ�.
 * @param message ���ڿ�
 * @return ���ڿ��� byte����
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
 * �ش� ����(byte)��ŭ ���ڿ��� �߶� �� �����Ѵ�.
 * @param message �ڸ� ���ڿ�
 * @param maximum �߶��� ���ڿ� ����
 * @return �ش� ���� ��ŭ �߶��� ���ڿ�
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
 * ���� ��Ʈ�� üũ
 * @param üũ�� ���ڿ�
 */
function isEmpty(s){
	return ((s == null) || (s.length == 0));
}

var whitespace = " \t\n\r";
/**
 * ���ڷ� �Ѿ�� ���ڿ��� �������� üũ
 * @param s üũ�� ���ڿ�
 * @return ����:true, ����ƴ�:false
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
 * üũ�ڽ��� ���õǾ����� Ȯ���Ѵ�.
 * @return ����:true , �̼���:false
 */
function isChecked_All() {
    var form = arguments[0]; /* form object */
    var msg  = arguments[1]; /* message */

    if(msg==null) msg = "üũ�ڽ��� ������ �ּ���";
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
 * üũ�ڽ� ��ü ����
 * @param flagName ��ü���� checkbox ��(�Ϲ�html)
 * @param formName �� tagId (netui)
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
 * ���õ� ������ư�� ���� ��´�.
 * @param chkObj ������ư ��ü
 * @return ���õ� ������ư ��
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
 * ������ư�� ���õǾ����� Ȯ���Ѵ�.
 * @param chkObj ������ư ��ü
 * @param ���� ��ư�� �ϳ��� üũ�Ǿ������� true , �ϳ��� üũ �ȵ������� false
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
 * ���,����,������ ���� �Լ�
 */
function submitCommand( targetMethod )
{
	form1.targetMethod.value=targetMethod;
	ValidateForm();
}

/**
 * ��ȸ�� ���� submit
 */
function xSubmit(form) {
	/*		XecureSubmit(form1);*/

		document.form1.submit(); 
}

/**
 * ����¡���� ��ȸ�� �ϱ� ���� �Լ�
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
 * ���� ���
 * <br>ex : goReport("test.rep")
 * @param fileName : ���� ��
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
 * ���� ���
 * <br>ex : goReport("test.csv")
 * @param fileName : ���� ��
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
 * ��ȯ���� ���� ��ȣ ����ũ �����.
 * <br>ex : onkeyup="javascript:formatKebAct(this)"
 * @param elem : mask �� ��ü
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

	/* ��������¹�ȣ  */
	if(acNo.substr(0, 1) == "6" || acNo.substr(0, 1) == "7" || acNo.substr(0, 1) == "8" || acNo.substr(0, 1) == "9") {
		if ((acNoLength >= 4) && (acNoLength < 10)) {
			elem.value = acNo.substr(0,3)+"-"+acNo.substring(3);
		}
		else if ( acNoLength >= 10 ) {
			elem.value = acNo.substr(0,3)+"-"+acNo.substr(3,6)+"-"+acNo.substring(9);
		} else elem.value = acNo;

	/* ��������¹�ȣ */
	} else {

		if (acNoLength == 4) {
			elem.value = acNo.substr(0,3)+"-"+acNo.substring(3);
		} else if (acNoLength == 5) {
			elem.value = acNo.substr(0,3)+"-"+acNo.substring(3)+"-";
		} else if (acNoLength >= 6)	{

			/* 4,5,6 ��° ���� ��� ���ڰ� �ƴϸ� ��ȭ ���·� ��� */
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

			} else /* ��ȭ���� */
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
 * ���̾ ���� ���� �Լ�
 * @param url : iframe�� src�� ���ϴ� url
 * @param divOjb : ���̾ ��� div��ü ("layerDiv" div �ȿ� ���� div���� �Ѵ�.)
 * @param width : iframe�� width
 * @param height : iframe�� height
 * @param xpos : Ư����ġ�� ���� ������� x-position
 * @param ypos : Ư����ġ�� ���� ������� y-position
 */
var div_left; /* ���̾� �˾��� ���ΰ�� */
var div_top; /* ���̾� �˾��� ���ΰ�� */
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
		/* ���� ���μ��� ���̾� �ϰ��� ��� ����. */
			div_left = (sw / 2) - 232/2 + document.documentElement.scrollLeft;/* obj.offsetWidth/2; */
            div_top  = (sh / 2) - 100/2 + document.documentElement.scrollTop;/* obj.offsetHeight/2; */
		}else {
		/* ���������̳� �ý��۰����� ���� ������� ���� ����. */
			div_left = (div_left == undefined ? 0:div_left) + document.documentElement.scrollLeft;
			div_top = (div_top == undefined ? 0:div_top) + document.documentElement.scrollTop;

			/* ������ ������ ���� �˾��� �߰����� ������ ����� ������� */
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
 * iframe�� �ƴ� ������� HTML ������ �׷��ش�.
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
        	width = 232; /*  ó�����Դϴ� �̹����� ����ũ�� */
        }
        if(height == undefined) {
        	height = 100; /*  ó�����Դϴ� �̹����� ����ũ�� */
        }
        if(xpos != undefined || ypos != undefined){
            div_left = (xpos == undefined ? ((div_left == undefined) ? 0:div_left):xpos) + __scrollLeft;
            div_top  = (ypos == undefined ? ((div_top == undefined)  ? 0:div_top):ypos) + __scrollTop;
            
        }else if(divObj == "layerDiv_process" || divObj == "layerDiv_emergency" || divObj == "layerDiv_errPop" || divObj == "layerDiv_system") {
        	/* ���� ���μ��� ���̾ ��ް��� , ���� �˾� �ϰ��� ��� ����. */
            div_left = (sw / 2) - width/2 + __scrollLeft;/* obj.offsetWidth/2; */
            div_top  = (sh / 2) - height/2 + __scrollTop;/* obj.offsetHeight/2; */            
            if(divObj == "layerDiv_errPop") hideAllLayer();
        }else if(divObj == "layerDiv_msg_confirm") {
        	/* alert��üâ�� ���  ��� ����. */
            div_left = (sw / 2) - width/2 + __scrollLeft;/* obj.offsetWidth/2; */
            div_top  =  (sh / 2) - height/2 + __scrollTop;/* obj.offsetHeight/2; */
            if(divObj == "layerDiv_errPop") hideAllLayer();
        }else {
       		/* ���������̳� �ý��۰����� ���� ������� ���� ����. */
            div_left = (div_left == undefined ? 0:div_left) + __scrollLeft;
            div_top = (div_top == undefined ? 0:div_top) + __scrollTop;
            /* ������ ������ ���� �˾��� �߰����� ������ ����� ������� */
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
 *	���� �˾� ���̾ �����ϰ� display = none ��Ų��.
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
 *	�������Դϴ� ���̾ ����
 * @param localeCode : ����ڵ�
 * @param useYn : ������� (N�ϰ�쿡�� �ȶ��. �⺻�� ���.)
 * @param modalYn : Modal ����
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
	var month = today.getMonth(); /* ���� ���ϱ� ���ؼ��� �ݵ�� +1�� �� ��� �Ѵ�. */
	var day = today.getDate(); /* ���� ���Ѵ�. */

	var oDate; /*  ������ ��¥ ��ü ���� */

	day = day*1 - pDay*1; /*  ��¥ ��� */

	oDate = new Date(year, month, day); /*  ���� ��¥ ��ü ���� (��ü���� �ڵ� ���) */

	year = oDate.getFullYear(); /*  ���� �⵵ �Ҵ� */

	month = oDate.getMonth()+1; /*  ���� �� �Ҵ� */

	day = oDate.getDate(); /*  ���� ���� �Ҵ� */

	if(month < 10)	month = "0" + month;
		if(day < 10)	day = "0" + day;

	targetId.value = year+"" +month+ "" + day;
}

function minusMonth(targetId, pMonth){
	var today = new Date();

	var year = today.getFullYear();
	var month = today.getMonth()+1; /* ���� ���ϱ� ���ؼ��� �ݵ�� +1�� �� ��� �Ѵ�. */
	var day = today.getDate(); /* ���� ���Ѵ�. */

	var cDate; /*  ��꿡 ����� ��¥ ��ü ���� */

	var oDate; /*  ������ ��¥ ��ü ���� */

	var cYear, cMonth, cDay; /*  ���� ��¥���� �Ҵ�� ���� */

	month = (month*1)-1 - ((pMonth*1)); /*  ���� 0~11 �̹Ƿ� �ϳ� ���ش� */

	cDate = new Date(year, month, day); /*  ���� ��¥ ��ü ���� (��ü���� �ڵ� ���) */

	cYear = cDate.getFullYear(); /*  ���� �⵵ �Ҵ� */

	cMonth = cDate.getMonth(); /*  ���� �� �Ҵ� */

	cDay = cDate.getDate(); /*  ���� ���� �Ҵ� */

	oDate = (day == cDay) ? cDate : new Date(cYear, cMonth, 0); /*  �Ѿ ���� ù¶�� ���� �Ϸ縦 �� ��¥ ��ü�� �����Ѵ�. */


	cYear = cDate.getFullYear();
	cMonth = cDate.getMonth()+1;
	cDay = cDate.getDate();

	if(cMonth < 10)	cMonth = "0" + cMonth;
		if(cDay < 10)	cDay = "0" + cDay;

	targetId.value = cYear+"" +cMonth+ "" + cDay;
}

///**
//*  �ٱ��� alert() �޼����� ��� (ExtJs��)
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
	
	//2013-02-27 ����˾��� alert���� �ȶ߸� �����ټ� �ɻ翡 �ɸ��ٰ� ��. �ͽ��÷η��� alert���� ����.
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
 * HTML TAG���� <BR> , <br />, <br> �ױ׵��� \n���� replace��.
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
	//2013-02-27 ����˾��� alert���� �ȶ߸� �����ټ� �ɻ翡 �ɸ��ٰ� ��. �ͽ��÷η��� alert���� ����.
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
	//2013-02-27 ����˾��� alert���� �ȶ߸� �����ټ� �ɻ翡 �ɸ��ٰ� ��. �ͽ��÷η��� alert���� ����.
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
// * ext ���̾ �̵�  ��ũ��Ʈ
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
 * ��Ű �������� �޼ҵ�
 * @param name :��Ű �̸�.
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
* extExceptionAlertâ�� Ajax���� �߻���  ���� ��ũ��Ʈ
* @param dataMap : ���������� ����ִ� dataMap
*/
function ajaxExceptionAlert(dataMap) {
	var schIDGubun = "";
		// ajax������ �����˾� ȣ��
		var errMsg = dataMap.RESPONSE_MESSAGE;
		var errorCode = dataMap.ERROR_CODE;
		var title = dataMap.ERROR_TITLE;
		var errorLevel = "1";						//�Ѿ���� ���������� ���� ���̽��̹Ƿ� ����Ʈ ���� 1�� ��
		var modal = "N";							// ajax������ ����̾�� ��
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



var listMethod = "doList";//����Ʈ Action
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
 * ���,����,������ ���� �Լ�
 */
function submitCommand( targetMethod )
{	
	if( targetMethod == deleteMethod )
	{
		if (!confirm("���� �Ͻðڽ��ϱ�?")) {
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
 * ��ȸ�� ���� submit
 */
function xSubmit(form) {
//		XecureSubmit(form);
		form.submit();
}

/**
 * ����¡���� ��ȸ�� �ϱ� ���� �Լ�
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
 * �޷� ��,��,�� ����Ʈ �ڽ� ����� ������Ʈ. �� �Լ��� ȣ���� �ڸ��� �����ȴ�.  
 * <br>ex : makeDateSelectBox("20060822","yyyy","mm","dd")
 * @param now : ���� ��¥
 * @param year : �⵵ ����Ʈ �ڽ��� name
 * @param month : �� ����Ʈ �ڽ���  name
 * @param date : �� ����Ʈ �ڽ���  name
 */
function makeDateSelectBox(now,year,month,date)
{

	var nYear = now.substring(0,4);
	var sYear = parseInt(nYear,10) - 4;
	var eYear = parseInt(nYear,10) + 4;
	var nMonth = now.substring(4,6);
	var nDate = now.substr(6);

	document.write(makeSelectBoxString(year,"onChangeLeapDate(form1."+year+",form1."+month+",form1."+date+")","select1",sYear,eYear,nYear));
	document.write("��");
	document.write(makeSelectBoxString(month,"onChangeLeapDate(form1."+year+",form1."+month+",form1."+date+")","select1",1,12,nMonth));
	document.write("��");
	document.write(makeSelectBoxString(date,"","select1",1,findLeapEndDate(nYear, nMonth),nDate));
	document.write("��");
}

/**
 * �޷� ��,��,�� ����Ʈ �ڽ� ����� ������Ʈ. �� �Լ��� ȣ���� �ڸ��� �����ȴ�.  
 * <br>ex : makeDateSelectBox("20060822","yyyy","mm","dd")
 * @param now : ���� ��¥
 * @param year : �⵵ ����Ʈ �ڽ��� name
 * @param month : �� ����Ʈ �ڽ���  name
 * @param date : �� ����Ʈ �ڽ���  name
 */
function makeDateSelectBox2(now,year,month)
{

	var nYear = now.substring(0,4);
	var sYear = parseInt(nYear,10) - 4;
	var eYear = parseInt(nYear,10) + 4;
	var nMonth = now.substring(4,6);


	document.write(makeSelectBoxString(year,"","select1",sYear,eYear,nYear));
	document.write("��");
	document.write(makeSelectBoxString(month,"","select1",1,12,nMonth));
	document.write("��");

}


/**
 * �ش� ��,���� �´� ���� ����Ʈ �ڽ��� �ɼ� ����.
 * <br>ex : onChangeLeapDate(form1.year,form1.month,form1.date)
 * @param year : �⵵ ������ ������ �ִ� ��ü�� form�̸�.��ü�̸�
 * @param month : �� ������ ������ �ִ� ��ü�� form�̸�.��ü�̸�
 * @param date : �� ������ ������ �ִ� ��ü�� form�̸�.��ü�̸�
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
 * ����Ʈ �ڽ� �����. �־��� ������ ������ ����Ʈ �ڽ� ����. �ַ� ��¥�� ���õǼ� ���ǰ�, ���ڿ��� ��� ������. ���� �ܴ̿� �Ұ�.
 * <br>ex : makeSelectBoxString("YYYY","onChangeLeapDate(form1.year,form1.month,form1.date)","select1",1,12,8)
 * @param name : ������ ����Ʈ �ڽ��� ��ü�̸�
 * @param onchange : onChange �̺�Ʈ�� �Ҵ��� �̺�Ʈ ��Ʈ�� �ڹ� ��ũ��Ʈ �Լ�
 * @param classname : ����Ʈ �ڽ��� ������ css class��
 * @param startNo : ���� ��.
 * @param endNo : ���� ��
 * @param selectedValue : ����Ʈ ��
 * @return ������� ����Ʈ �ڽ� ��Ʈ��
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
 * �ش� ��,���� ������ �޴� �ش� ����� ������ ��¥ ã��
 * <br>ex : findLeapEndDate("2006", "2")
 * @param year : �⵵ ��
 * @param month : �� ��
 * @return �ش� ����� ������ ��¥
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
 * ���� ���
 * <br>ex : goReport("test.rep")
 * @param fileName : ���� ��
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
 * ���� ���
 * <br>ex : goReport("test.csv")
 * @param fileName : ���� ��
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
 * ��ȯ���� ���� ��ȣ ����ũ �����.
 * <br>ex : onkeyup="javascript:formatKebAct(this)"
 * @param elem : mask �� ��ü
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
	
	//��������¹�ȣ
	if(acNo.substr(0, 1) == "6" || acNo.substr(0, 1) == "7" || acNo.substr(0, 1) == "8" || acNo.substr(0, 1) == "9") {
		if ((acNoLength >= 4) && (acNoLength < 10)) {
			elem.value = acNo.substr(0,3)+"-"+acNo.substring(3);
		}
		else if ( acNoLength >= 10 ) {
			elem.value = acNo.substr(0,3)+"-"+acNo.substr(3,6)+"-"+acNo.substring(9);
		} else elem.value = acNo;

	//��������¹�ȣ
	} else {
		
		if (acNoLength == 4) {
			elem.value = acNo.substr(0,3)+"-"+acNo.substring(3);
		} else if (acNoLength == 5) {
			elem.value = acNo.substr(0,3)+"-"+acNo.substring(3)+"-";
		} else if (acNoLength >= 6)	{

			//4,5,6 ��° ���� ��� ���ڰ� �ƴϸ� ��ȭ ���·� ���
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
				
			} else //��ȭ����
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
 * �Ⱓ ��ȸ�� �������� ~ �������� Ÿ�Կ��� �Ⱓ�� ���ؼ� ����Ҷ� ���
 * <br>ex : setSearchDate('form1.��������','form1.��������',-7) -> form1.��������.value=��������+ -7���� ����, 'form1.��������'.value=���� ����
 * @param before : ����° �Ķ���ͷ� ���� ���� �� ��¥�� ������ ��ü
 * @param after : ���� ��¥�� ������ ��ü
 * @param day : ���ϰ��� �Ⱓ. 0�� ��� ���� ��ȸ�� before,after��ü�� ��¥�� ����. 
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

//���� ���� �ϼ� ���
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
 * 8�ڸ� ��¥ üũ ����
 * <br> ex : validateDate8("20050822")
 * @param cDate : 8�ڸ� ��¥ ��Ʈ��
 * @return boolean
 */
function validateDate8(cDate)
{
	if(cDate.length != 8) 
	{
		alert("��¥�� ���̰� �߸� �Է� �Ǿ����ϴ�.");
		return false;
	}
	var yyyy = cDate.substring(0, 4);
	var mm = cDate.substring(4, 6) - 1;//12���� ��� ��¥ �����ؼ� ���� getMonth()�� ���� 0���� ���ϵǹǷ� 1�� ���ش�.
	var dd = cDate.substring(6);
	var checkDate = new Date(yyyy, mm, dd);

	if ( checkDate.getFullYear() != yyyy ||	checkDate.getMonth() != mm || checkDate.getDate() != dd) 
	{
		delete checkDate;
		alert("��¥ ������ ��ȿ���� �ʽ��ϴ�.");
		return false;
	}
	delete checkDate;
	return true;

} 
