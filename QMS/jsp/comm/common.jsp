<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
    <script language="javascript">
/**
* 프로그램 명 : spider 웹페이지 로딩시 기본 체크 모듈
* 일관성을 위하여 기본 적용되는 옵션들이 있고, 추가해주는 부분은 db에서 추가 하게 되어있다. db셋팅이 없으면 코딩으로 추가 하면 됨.
* 작성자 : 오재훈
* 사용된 속성 
* 1. nullable =false 이면 필수 요소임 
* 2. chartype  : 입력받을 문자열 셋 
* |숫자만	| 영어만	| 영어숫자	| 실수 금액	 |정수 금액 |
* |onlynum	| Eng	    | engnum	| floatmoney | money   |
* 3. maskform #과 구분자로 이루어진 마스크. #은 값들이고 구분자가 각 위치에 들어가게 됨 
* ex : 123456789 maskform="##-##,##.##/#"  결과 12-34,56.78/9 
* 사용자 마스크를 따로 적용 할 경우 maskform="usermask"로 셋팅하여 마스크를 적용하면 프레임워크에서 spidersubmit()시에 숫자,영어 이외의 문자를 삭제함.
* 4. maximum  : 최대값 
* 5. minimum  : 최소값 
* 6. disablecss  : input창의 활성화,비활성화 속성 정의 
* 7. maxbyte : 최대 입력 바이트 길이 계산.
* 7. format  : deprecate 함수 호출 형식으로 바뀜 프레임 워크에 있는 함수 호출(주민번호,이메일,사업자번호. 속성값 : psn,email,crn,date)
*/


<%
	String localeCode = "KO";

%>

/**
 * 다국어 alert() 메세지를 출력
 * ex : i18nAlert('I18NUtil.getLabel(localeCode, "IBA00001","개별1회이체한도금액이 초과하였습니다.")') (스크립틀릿임.)
 * @param msg : 다국어 메세지 
 * @return : alert(msg) 메세지
 */
function i18nAlert(msg){
	var alertElem = document.createElement("<span>");
	alertElem.innerHTML = msg;
	alert(alertElem.outerText);
}



/**
 * 다국어 confirm() 메세지를 출력
 * ex : i18nConfirm('I18NUtil.getLabel(localeCode, "COA00001","수정하시겠습니까?")') (스크립틀릿임.)
 * @param msg : 다국어 메세지 
 * @return : alert(msg) 메세지
 */
function i18nConfirm(msg){
	var confirmElem = document.createElement("<span>");
	confirmElem.innerHTML = msg;
	return confirm(confirmElem.outerText);
}

//----------------------------------- 페이지 initialize 관련 함수 시작 ------------------------------------------------//

/**
 * html 페이지 로딩후 최초 실행하는 스크립트.
 */
initializeHtmlPage();

/**
 * 최초 로딩시 페이지 초기 설정
*/
function initializeHtmlPage()
{
	for ( var i = 0 ; i < document.forms.length ; i++) 
	{ 
		document.forms[i].initialize = initializeHtmlForm;
		document.forms[i].initialize();
	}
}


/**
 * 호출된 폼마다 셋팅하기.
 * <br>initialize시 셋팅하는 정보 : 필수 요소(css),mask,letter type
*/ 
function initializeHtmlForm()
{
	//spiderSubmit 할당
	this.spiderSubmit = formSubmitValidation;
	this.submitstat = "false";

	for (var i = 0 ; i < this.elements.length ; i++)
	{
		if (this.elements[i].tagName.toString().toLowerCase() == "input")
		{
			//필수 요소일때는 인풋창 왼쪽 위에 이미지 설정.
			if ( this.elements[i].nullable == "false")
				this.elements[i].className = "frameworkInitNullable";
		
			//mask가 있을경우 #은 값을 의미함.
			if (this.elements[i].maskform != undefined && this.elements[i].maskform != "")
			{
				if(this.elements[i].maskform != "usermask")
					initSetMaskUp(this.elements[i]);//mask 타입(ex : ####/##/## , ####-##-## , ######-####### , ###-##-##### , ...)
			}
			//문자 타입이 있을경우
			if (this.elements[i].chartype  != undefined)
				initSetLetterType(this.elements[i]);//문자 셋(english,korean,english+number, number, floatmoney,int)타입
				
			//속성이 있을경우
			if ( this.elements[i].disablecss  != undefined)
				initSetAttribute(this.elements[i])	
			//maxlength가 있을경우
			if ( this.elements[i].maxLength  != undefined)
			{
				initSetMaxLength(this.elements[i]);	
			}
				
			//maxByte가 있을경우
			if ( this.elements[i].maxbyte  != undefined)
			{
				initSetMaxLength(this.elements[i]);	
			}
				
			//uppercase가  있을 경우 	
			if (this.elements[i].uppercase  != undefined){
				if(this.elements[i].chartype  == undefined){
					initSetUpperLower(this.elements[i])	
				}
			}	
			//lowercase가  있을 경우 	
			if (this.elements[i].lowercase  != undefined){
				if(this.elements[i].chartype  == undefined){
					initSetUpperLower(this.elements[i])	
				}
			}	
		}
	}
}

/**
 * 문자열을 Byte길이로 잘라옴.
 * <br> ex : cutStringToByte(form1.name.value, bytelength)
 * @param strValue : 바이트 길이로 자를 문자열 
 * @param cutByte : 바이트 길이
*/
function cutStringToByte(strValue,cutByte)
{
	var sumLength = 0;
 	var resultStr = "";
 	for(var i= 0;i < strValue.length; i++)
 	{	
		if( escape(strValue.charAt(i)).length > 3 ) { strLength = 2; }
	  		else if (strValue.charAt(i) == '<' || strValue.charAt(i) == '>') { strLength = 4; }
	  		else { strLength = 1 ; }
	  	if ( cutByte < (sumLength + strLength) ) { break; }
	  		sumLength += strLength;
	  		resultStr += strValue.charAt(i);
	}
 	return resultStr;
}



/** 
 * uppercase, lowercase 설정시 keyPress시 이벤트 발생.
*/
function initSetUpperLower(elem) {
	if(elem.onkeypress == undefined){
		elem.onkeypress = setUpperLowerCase;
	}
}

function setUpperLowerCase() {
	 var pKey = String.fromCharCode(event.keyCode);
	 if( event.srcElement.uppercase != undefined) {
	 	if(event.keyCode >= 97 && event.keyCode <= 122){
			event.srcElement.value = (event.srcElement.value + pKey).toUpperCase();
			event.returnValue=false;
		}
	 }
	 if( event.srcElement.lowercase != undefined) {
	 	if(event.keyCode >= 65 && event.keyCode <= 90){
			event.srcElement.value = (event.srcElement.value + pKey).toLowerCase();
			event.returnValue=false;
		}
	 }	 

}

/** 
 * maxLength, maxbyte 설정시 keyUp시 이벤트 발생.
*/
function initSetMaxLength(elem) {
	if(elem.onkeyup == undefined){
		elem.onkeyup = setOverSetFocus;
	}
}

/**
 * 속성에 따른 input창 상태 셋팅.
 * <br> ex : initSetAttribute(form1.name)
 * @param elem : 이벤트를 셋팅할 element
 */
function initSetAttribute(elem)
{
	if (elem.disablecss  == "true")
	{
		elem.disabled = true;
		elem.className = "frameworkDisabled";
	} 
}

/** 
 * maxLength, maxbyte 설정시 최대값보다 더 들어왔을시 자동 포커스 이동.
 * <br> ex : setOverSetFocus()
*/
function setOverSetFocus() {
	//this 개체가 속한  폼이름 가져오기
	var thisFrm = eval(this.parentElement);
	while("form" != thisFrm.tagName.toString().toLowerCase()) 
	{
		thisFrm = eval(thisFrm.parentElement);		
	}
	
	var nextFocus = this;
	//다음 포커스 타겟 가져오기.
	for (var i = 0 ; i < thisFrm.elements.length ; i++)
	{
		if (thisFrm.elements[i].tagName.toString().toLowerCase() == "input") 
		{
			//현재 this값이 선택된 elements이면 다음으로 이동될 포커스를 가져오기 위한 로직수행.
			if(this == thisFrm.elements[i]) 
			{		
				//elements가 undefined 될때 까지 수행함.
				while(thisFrm.elements[++i] != undefined) 
				{	
					//현재 elements의 부모중의 속성이 display = none이면 다음 포커스 타겟을 가져온다.
					var targetCursor = eval(thisFrm.elements[i].parentElement);
					while("form" != targetCursor.tagName.toString().toLowerCase())	{
						if(targetCursor.parentElement.style.display == "none") break;
						targetCursor = eval(targetCursor.parentElement);	
						
					}
					if(targetCursor.parentElement.style.display == "none") continue;
				
					//elements타입이 input (text,radio,checkbox), textarea, select 일경우 다음 포커스 obj저장.
					//  /ibs/jsp/common/com_tranpwdreg_i.jsp에서 시크릿트 카드 입력하는 부분에 display가 none인 경우 제외 (style = "tx h") 
					if(thisFrm.elements[i].tagName.toString().toLowerCase() == "input" && 
						((thisFrm.elements[i].type == "text" &&  thisFrm.elements[i].className != "tx h" )|| ( thisFrm.elements[i].type == "password" &&  thisFrm.elements[i].className != "tx h" ) || 
							(thisFrm.elements[i].type == "radio" &&  thisFrm.elements[i].className != "tx h" )|| (thisFrm.elements[i].type == "checkbox" &&  thisFrm.elements[i].className != "tx h" )) || 
								(thisFrm.elements[i].tagName.toString().toLowerCase() == "textarea" &&  thisFrm.elements[i].className != "tx h" )|| 
									(thisFrm.elements[i].tagName.toString().toLowerCase() == "select" &&  thisFrm.elements[i].className != "tx h" )) 
					{
						nextFocus = thisFrm.elements[i];
						break;
					}
				}				
			}
		}
	}
	
	//포커스 이동. maxLength 2147483647은 maxLength의 값을 주지 않았을경우 기본적으로 주는 최대값.
	if(this.maxbyte != undefined && this.maxLength != 2147483647) {
	//1. maxbyte와 maxLength를 둘다 선택 하였을때..
		if((this.maxLength <= this.value.length) || (this.maxbyte < calculate_msglen(this.value))) 
		{	
			this.blur();
			if(nextFocus.tagName.toString().toLowerCase() == "select") {
				nextFocus.focus();
			}else {
				nextFocus.select();
			}	
			this.value = cutStringToByte(this.value, this.maxbyte);	
		}
	}else if(this.maxbyte == undefined && this.maxLength != 2147483647) {
	//2. maxLength만 설정했을때..			
		//한글이 포함된 chartype경우는 maxLength-2 값을 넘긴다. 20080721 김재범 추가. 
		if((this.chartype == "kor" || this.chartype == "kornum" || this.chartype == "koreng" || this.chartype == "korengnum") && 
				(this.maxLength-2) < (this.value.length*2) ) 
		{
			this.blur();
			if(nextFocus.tagName.toString().toLowerCase() == "select") {
				nextFocus.focus();
			}else {
				nextFocus.select();
			}
		    this.value = this.value.substring(0,(this.maxLength/2)-1);      	  
		} else if(this.maxLength <= this.value.length) 
		{		
			this.blur();
			if(nextFocus.tagName.toString().toLowerCase() == "select") {
				nextFocus.focus();
			}else {
				nextFocus.select();
			}
			this.value = cutStringToByte(this.value, this.maxLength);   
		}
	}else if(this.maxbyte != undefined && this.maxLength == 2147483647) {	
	//3. maxByte만 설정했을때..
		if(this.maxbyte < calculate_msglen(this.value) ) 
		{	 
			this.blur();
		   if(nextFocus.tagName.toString().toLowerCase() == "select") {
				nextFocus.focus();
			}else {
				nextFocus.select();
			}
		   this.value = cutStringToByte(this.value, this.maxbyte);	      	      
		}
	}
}


/**
 * 숫자열 마스크 씌우기
 * <br> ex : initSetMaskUp(form1.name)
 * @param elem : 마스크를 셋팅할 element
 */
function initSetMaskUp(elem)
{
	elem.onkeypress = setKeyInputNumberOnly;
	elem.onfocus = filterGetNumberOnly;
	elem.onblur = setInitMaskUp;
}


/**
 * 주민 사업자 번호 onkeyup이벤트시 마스크 씌우기
 * <br> ex : psnCrnMaskup(form1.name)
 * @param elem : 마스크를 셋팅할 element
 */
function psnCrnMaskup(elem)
{
	var data = getOnlyNumberFormat(elem.value);
	
	if(data.length <= 3) 
	{
		return;
	}
	else if(data.length > 3 && data.length <= 5)
	{
		elem.value = data.substr(0,3) + "-" + data.substring(3);
	}else if (data.length > 5 && data.length <= 10)
	{
		elem.value = data.substr(0,3) + "-" + data.substr(3,2) + "-" + data.substring(5);
	} else if (data.length > 10 && data.length <= 13)
	{
		elem.value = data.substr(0,6) + "-" + data.substring(6);
	} else if(data.length > 13) {
		elem.value = data.substr(0,6) + "-" + data.substr(6,7);
	}
}


/**
 * 페이지 초기화시에 onfocus 이벤트에 할당되면 이 Elemnent에 숫자외의 문자("," , "/" , "-")는 focus시에 제거됨
 */
function filterGetNumberOnly()
{
	this.value = getOnlyNumberFormat(this.value);
	this.select();
}



/**
 * 문자열에서 숫자만 빼오기 체크 로직
 * ex : getOnlyNumberFormat(form1.name.value)
 * @param sv : 변환할 String 값
 */
function getOnlyNumberFormat(sv)
{
	if(sv == null) return;
	var temp="";
	var ret = "";
	
	for(var index = 0 ; index < sv.length ; index++)
	{
		temp = parseInt(sv.charAt(index), 10);
		if( temp >= 0 || temp <= 9) 
		{
			ret +=temp;
		}
	}
	return ret;

}
/**
 * 페이지 초기화시에 마스크 설정값대로 변환하기
 */
function setInitMaskUp()
{
	var mask = this.maskform;
	if(this.value == "")
		return;
		
	var inputV = getOnlyNumberFormat(this.value);
	
	for ( var i = 0 ; i < mask.length ; i++)
	{
		if ( mask.substring(i,i+1) != "#" )
			inputV = inputV.substring(0,i) + mask.substring(i,i+1) + inputV.substring(i);
	}

	this.value = inputV;
}


/**
 * 페이지 초기화시 숫자만 입력받기
 */
function setKeyInputNumberOnly()
{
	if(event.shiftKey == true) event.returnValue = false;
	
	if ( event.keyCode >= 48 && event.keyCode <= 57 )//숫자 키코드값
	{
        return true;
    }
    else 
    {
		// enter, tab, backspace 방향키(앞,뒤)는 예외처리
		if(event.keyCode == 8 || event.keyCode == 9 || event.keyCode == 37 || event.keyCode == 39)
		{
			return true;
		}
		event.returnValue = false;
	}
}



/**
 * 페이지 초기화시에 언어 및 숫자형 입력 및 표현 처리.
 * @param elem : 이벤트를 셋팅할 element
 */
function initSetLetterType(elem)
{
	elem.style.imeMode = "disabled";
	if (elem.chartype  == "eng")//영어만
	{
		elem.onkeypress = setLetterEnglishOnly;
			
	} else if (elem.chartype  == "engnum")//영어+숫자
	{
		elem.style.imeMode = "disabled";
		
	} else if (elem.chartype  == "float")//실수형
	{
		elem.onkeypress = setLetterFloatOnly;
		
	} else if (elem.chartype  == "int")//정수형
	{
		elem.onkeypress = setLetterInteger;
		
	} else if (elem.chartype  == "onlynum")//오직 숫자만
	{
		elem.onkeypress = setKeyInputNumberOnly;
		
	} else if (elem.chartype  == "money")//정수로만 된 아주 기본적인 금액 표시
	{
		elem.style.textAlign="right";
		elem.onkeydown = setKeydownMoney;//키가 눌러졌을때
		elem.onkeyup = setKeypressMoney;//키를 눌렀다 놓았을때
	} else if (elem.chartype == "floatmoney")
	{
		elem.style.textAlign="right";
		elem.onkeydown = setKeydownFloatMoney;//키가 눌러졌을때
		elem.onkeyup = setFloatMoney;//키를 눌렀다 놓았을때
	}
}


/**
 * 페이지 초기화시 -,숫자 입력받기( - 키코드값 189)
 */
function setKeydownMoney()
{
	if(event.shiftKey == true) event.returnValue = false;

	if ( (event.keyCode >= 48 && event.keyCode <= 57) || (event.keyCode >= 96 && event.keyCode <= 105) )//숫자 키코드값
	{
        return true;
    }
    else 
    {
		// enter, tab, backspace 방향키(앞,뒤),delete는 예외처리
		if(event.keyCode == 8 || event.keyCode == 9 || event.keyCode == 37 || event.keyCode == 39 || event.keyCode == 189 || event.keyCode == 46)
		{
			return true;
		}
		event.returnValue = false;
	}
}


/**
 * 페이지 초기화 시에 금액 형태일 경우 키 입력시 금액 형태로 전환
 */
function setKeypressMoney()
{
	var ev = event.srcElement;

	var tempV = ev.value;

	if(tempV.length > 0){
		var stat = true;
		while(stat)
		{
			if(tempV.length > 0 && tempV.substring(0,1)==0)
			{
				tempV = tempV.substr(1);
			} else {
				stat = false;
			}
		}
	}

	var moneyReg = new RegExp('(-?[0-9]+)([0-9]{3})'); 
	tempV = tempV.replace(/\,/g, "");
	while(moneyReg.test(tempV)) 
	{ 
		tempV = tempV.replace(moneyReg, '$1,$2'); 
	} 

	ev.value = tempV;
	if(event.keyCode == 9){ev.select();}
	
}

/**
 * 스트링값을 정수형 머니 형태로 변환
 * <br> ex : changeIntMoneyType("1100000") 리턴되는 데이타 : 1,100,000
 * @param data : 변환할 String 데이타
 * @return 금액 형태로 변환된 스트링
 */
function changeIntMoneyType(data)
{
	var tempV = data;

	var moneyReg = new RegExp('(-?[0-9]+)([0-9]{3})'); 
	tempV = tempV.replace(/\,/g, "");
	while(moneyReg.test(tempV)) 
	{ 
		tempV = tempV.replace(moneyReg, '$1,$2'); 
	}
	return tempV;
}

/**
 * 실수형 금액 입력제어 스크립트. 숫자 , . , - 값만 입력받음. 소수점 두째 자리까지만 입력됨
 */
function setKeydownFloatMoney()
{
	if(event.shiftKey == true) event.returnValue = false;
	
	var floatindex = event.srcElement.value.indexOf(".");

	if(floatindex != -1)
	{
		var floatNum = event.srcElement.value.substring(floatindex+1);
		if (event.keyCode == 8 )
			return;
		else if (floatNum.length > 1 )
			event.returnValue = false;
	}

	if ( (event.keyCode >= 48 && event.keyCode <= 57) || (event.keyCode >= 96 && event.keyCode <= 105) )//숫자 키코드값
	{
        return true;
    }
    else 
    {
		if( event.keyCode == 8 || event.keyCode == 9 || event.keyCode == 37 || event.keyCode == 39 || event.keyCode == 189)
		{
			return;
		} else if( event.keyCode == 190 && floatindex == -1 )
		{
			return
		}

		event.returnValue = false;
	}
}


/**
 * 키 입력시 float 타입의 금액 형태로 전환
 */
function setFloatMoney()
{
	var ev = event.srcElement;

	var tempV = ev.value;
	var floatnum = ""

	if(tempV.indexOf(".") != -1)
	{
		floatnum = tempV.substring(tempV.indexOf("."));
		tempV = tempV.substring(0,tempV.indexOf("."));
	}	

	var moneyReg = new RegExp('(-?[0-9]+)([0-9]{3})'); 
	tempV = tempV.replace(/\,/g, "");
	while(moneyReg.test(tempV)) 
	{ 
		tempV = tempV.replace(moneyReg, '$1,$2'); 
	} 

	ev.value = tempV+floatnum;
	if(event.keyCode == 9){ev.select();}
}

/**
 * 키 입력시 영어만 입력받기
 */
function setLetterEnglishOnly()
{ 
	 var pKey = String.fromCharCode(event.keyCode);
	 var eReg = /[a-zA-Z]/g;
	 
	 if(pKey!="\r" && !eReg.test(pKey)) //엔터키 및 regkey가 아닐경우 리턴
		event.returnValue=false;
	 
	 delete eReg;
}


/**
 * 키 입력시 숫자,- 값만 입력받음.
 */
function setLetterInteger()
{ 
	 var pKey = String.fromCharCode(event.keyCode);
	 var intReg = /[0-9\\-]/g;
	 
	 if(pKey!="\r" && !intReg.test(pKey)) //엔터키 및 regkey가 아닐경우 리턴
		event.returnValue=false;
	 
	 delete intReg;
}


/**
 * 키 입력시 숫자 , . , - 값만 입력받음.
 */
function setLetterFloatOnly()
{
	 var pKey = String.fromCharCode(event.keyCode);
	 var floatReg = /[0-9\\.\\-]/g;
	 
	 if(pKey!="\r" && !floatReg.test(pKey)) //엔터키 및 regkey가 아닐경우 리턴
		event.returnValue=false;
	 
	 delete floatReg;
}

//-----------------------------------------------------------------------------------------------------------------//
//----------------------------------- 페이지 initialize 관련 함수 끝 ------------------------------------------------//

/**
 * 최소값 체크 로직
 * <br> ex : validationMinimum("100000","10000")
 * @param minV : 지정된 최소 value 
 * @param inV : 입력된 Value
 * @return boolean
 */
function validationMinimum(minV,inV)
{	
	if (minV == "") 
	{
		alert("정해진 최소값이 없습니다.");
		return false;
	}
	
    if ( parseFloat(inV) < parseFloat(minV) )
    {
        return false;
    }
    
    return true;
}


/**
 * 최대값 체크 로직
 * <br> ex : validationMaximum("100000","10000")
 * @param maxV : 지정된 최대 value
 * @param inV : 입력된 Value
 * @return boolean
 */
function validationMaximum(maxV,inV)
{	
	if (maxV == "") 
	{
		alert("정해진 최대값이 없습니다.");
		return false;
	}

	
    if ( parseFloat(maxV) < parseFloat(inV) )
    {
        return false;
    }        
    return true;
}


/**
 * 최대 btye 체크 로직 
 * <br> ex : validationMaxByte(form1.inputname.value , 10)
 * @param textObj : 체크할 String value 
 * @param length_limit : 최대 byte  
 * @return boolean
 */
function validationMaxByte(textObj, length_limit)
{
	var length = calculate_msglen(textObj);
	var kor_cnt = Math.floor(length_limit/2);
	if (length > length_limit) {
        return false;
	}
    return true;	
}

/**
 * 한글 2글자 영문 1글자로 길이 측정하여 문자열의 byte 길이를 리턴한다.
 * @param 체크할 String value 
 * @return 측정한 해당 값의 byte 길이
 */
function calculate_msglen(message)
{
	var nbytes = 0;

	for (i=0; i<message.length; i++) {
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
 * get,put 만 되는 hash table
 * <br> ex :  
 * <br>var temphash = new javascriptHashtable()
 * <br>temphash.put("key1","토요일"); 값 넣기
 * <br>temphash.put("key2","일요일");
 * <br>temphash.get("key1"); 값 가져오기
 * @constructor var temp = new javascriptHashtable();
 */
function javascriptHashtable(){
	this.hash = new Array();
}
javascriptHashtable.prototype.get = function (key)
{
	if(this.hash[key] == undefined)
		return "null";
	else		
		return this.hash[key];
}
javascriptHashtable.prototype.put = function (key, value)
{
	if (key == null || value == null)
		return i18nAlert("key and value do not permit null or blank");

	if (this.hash[key] != null)
		return i18nAlert("already exist value");

	this.hash[key] = value;
}



/**
 * 중첩된 css에서 해당 css만 제거
 * <br> removeCss(["input1","input2"],"input1")
 * @param cssArr : 설정되어 있는 class 배열. (참고로 css는 class="input1 input2" 이런식으로 중복될수 있다.
 * @param reAtt : 제거할 css명
 * @return 제거할 css가 제거된 스트링값
 */
function removeCss(cssArr,reAtt)
{
	var retCss="";
	for( var i = 0 ; i < cssArr.length ; i++)
	{
		if(reAtt != cssArr[i] )
			retCss += cssArr[i] + " ";
	}
	
	return retCss;
}



/**
 * sider FrameWork의 form submit 함수 
 */
function formSubmitValidation()
{
	//이중 서브밑 방지 
	if(this.submitstat != "false")
	{
		alert("이미 submit 되었습니다.");
		return;
	}
	else
	{
		this.submitstat = "validating";
		//기본 밸리데이션 체크 함수 호출
		if(initBaseValidationCheck(this))
		{
			this.submitstat = "true";
		var tokenValue = "";
<%
String tokenValue = (String)session.getAttribute("org.apache.struts.action.TOKEN");
if(tokenValue != null) {
%>
			tokenValue = "<%=tokenValue%>";
<%}%>
			if(tokenValue != "")
			{
				var spiderSubmitState = document.createElement('<INPUT TYPE="HIDDEN" NAME="org.apache.struts.taglib.html.TOKEN" VALUE="'+tokenValue+'">');
				this.appendChild(spiderSubmitState);
			}
		 	this.submit();
		}
		else 
		{
			this.submitstat = "false";
			return;
		}
	}
}


/**
 * validation check 함수 
 * @param checkForm : validation 검사를 할 폼.
 * @return boolean
*/
function initBaseValidationCheck(checkForm)
{	
	for (var i = 0 ; i < checkForm.elements.length ; i++)
	{
		//mask한 값에서 마스크 값 삭제
		if ( ( checkForm.elements[i].maskform != undefined && checkForm.elements[i].maskform != "") || checkForm.elements[i].chartype  == "money")
		{
			if(checkForm.elements[i].maskform == "usermask")
			{
				checkForm.elements[i].value = unMaskEngNum(checkForm.elements[i].value);//사용자 마스크 지우기 로직.
			} else
			{
				checkForm.elements[i].value = getOnlyNumberFormat(checkForm.elements[i].value);			
			}
		}
		
		//input 타입
		if (checkForm.elements[i].tagName.toString().toLowerCase() == "input" )
		{
			//필수 값 체크
			if ( checkForm.elements[i].nullable == "false")
			{
				if(checkForm.elements[i].type.toString().toLowerCase() == "text" || checkForm.elements[i].type.toString().toLowerCase() == "password")
				{
					if( checkForm.elements[i].value == "" )
					{
						//colname 어트리뷰트 추가되면서 비교하는 if문 추가.20080129
						if(checkForm.elements[i].collname != undefined) {
							alert("[" + checkForm.elements[i].collname  + "] "+"필수 입력 사항입니다.");
							
						}else{ 
							alert("필수 입력 사항입니다.");
							
						}
						
						if ( !checkForm.elements[i].className != "" )
						{
							checkForm.elements[i].className = "frameworkNullable";
						} else 
						{
							checkForm.elements[i].className = checkForm.elements[i].className + " " + "frameworkNullable";
						}
						
						checkForm.elements[i].select();
						return false;
					} else //한번 validation에서 css설정이 되었을경우 빼야 하기 때문에.
					{
						var classArr = checkForm.elements[i].getAttribute("className").split(" ");
						checkForm.elements[i].className = removeCss(classArr,"frameworkNullable");
					
					}

				} else if(checkForm.elements[i].type.toString().toLowerCase() == "checkbox" || checkForm.elements[i].type.toString().toLowerCase() == "radio")
				{
					var checkState = false;
					var elementArray = eval("checkForm."+checkForm.elements[i].name);

					for(var ct = 0 ; ct < elementArray.length ; ct++)
					{
						if(elementArray[ct].checked == true)
						{
							checkState = true;
							break;
						}
					}
					if (checkState == false) 
					{
						alert("필수 입력 사항입니다.");
						checkForm.elements[i].focus();
						return false;
					}
				}
			} 
			
			if( checkForm.elements[i].value != "")
			{	
				//최대값 체크
				if ( checkForm.elements[i].maximum  != undefined && checkForm.elements[i].maximum != "")
				{
					if ( !validationMaximum(checkForm.elements[i].maximum  , checkForm.elements[i].value) )
					{
						alert("정해진 최대값보다 큽니다.");
						checkForm.elements[i].select();
						return false;
					}	
				}


				//최소값 체크
				if ( checkForm.elements[i].minimum != undefined && checkForm.elements[i].minimum != "")
				{
					if ( !validationMinimum(checkForm.elements[i].minimum  , checkForm.elements[i].value) )
					{
						alert("정해진 최소값보다 작습니다.");
						checkForm.elements[i].select();
						return false;
					}	
				}
				
				//최대 바이트 체크
				if ( checkForm.elements[i].maxbyte != undefined && checkForm.elements[i].maxbyte != "")
				{
					if ( !validationMaxByte(checkForm.elements[i].value , checkForm.elements[i].maxbyte) )
					{
						var kor_cnt = Math.floor(checkForm.elements[i].maxbyte/2);
						alert("한글 "+ kor_cnt + "자, 영문 " + checkForm.elements[i].maxbyte + "자를 초과할 수 없습니다.");
						checkForm.elements[i].select();
						return false;
					}	
				}
			}
			
		//select 타입이 필수일때	
		} else if (	checkForm.elements[i].tagName.toString().toLowerCase() == "select" )
		{
			if(checkForm.elements[i].disabled==true) checkForm.elements[i].disabled = false;
			
			if(checkForm.elements[i].nullable == "false" && checkForm.elements[i].value == "")
			{
				alert("필수 입력 사항입니다.");
				checkForm.elements[i].focus();
				return false;
			}
		//textarea 타입이 필수일때	
		}else if (	checkForm.elements[i].tagName.toString().toLowerCase() == "textarea" )
		{
						
			if(checkForm.elements[i].nullable == "false" && isWhitespace(checkForm.elements[i].value))
			{
				alert("필수 입력 사항입니다.");
				checkForm.elements[i].value = '';
				checkForm.elements[i].focus();
				return false;
			}
		}

	}//for문 끝
	
	return true;
}

/**
 * MaskUp된 데이타에서 마스크 Delemeter 제외하고 값 리턴
 * <br> ex : unMaskUpData(form1.name)
 * @param element : 마스크한 요소 name 또는 해당 객체 자체.
 * @return 구분자를 제외한 데이타값
 */
function unMaskUpData(element)
{
	var unmaskData = "";
	//mask한 값에서 마스크 값 삭제
	if ( ( element.maskform != undefined && element.maskform != "") || element.chartype  == "money")
	{
		unmaskData = getOnlyNumberFormat(element.value);//spcommon.js에 있는 숫자만 빼오기 로직
	} else unmaskData = element.value;
	
	return unmaskData;
}



/**
 * 사용자가 지정한 마스크업 스타일중 영어,숫자 혼합인 데이타의 mask를 지울때 사용 영어,숫자 이외의 문자 제거
 * <br> ex : unMaskEngNum(String)
 * @param element : 마스크가 있는 String 
 * @return 구분자를 제외한 String
 */
function unMaskEngNum(data) {

	var accReg = new RegExp('([a-zA-Z0-9])'); 	
	
	var temp = "";
	for(var i = 0 ; i < data.length ; i++) 
	{ 
		if(accReg.test(data.substr(i,1)))
		{
			temp += data.substr(i,1);
		}
	}
	return temp;
}


/**
 * 공통 javascript 모듈
 */
 
 

/**
 * window.showModalDialog(arg1,arg2,arg3) 옵션 배열의 갯수를 정확히 넣어줘야 합니다. 값이 필요 없으면 '' 을 넣습니다.
 * ex : openPopModal(a.html,"test",[넓이,높이,center여부,x좌표,y좌표,scroll여부,resizable여부]) 
 *      openPopModal(a.html,"test",['200','200','yes','200','200','yes','yes']) 
 * scroll은 default=yes임 , center가 yes로 되어있어도 x,y좌표가 있으면 좌표에 따른다.
 * @param url : 주소
 * @param arg : 넘겨줄 파라미터
 * @param option : 창관련 옵션(배열 형식)  
 */
function openPopModal(url, arg, option)
{	
	var sFeatures = "";

	if(option != undefined) {
		var popWidth = option[0];
		var popHeight = option[1];
		var popCenter = option[2] == "" ? "yes" : option[2];
		var popXpos = option[3];
		var popYpos = option[4];
		var popScroll = option[5] == "" ? "yes" : option[5];
	    var popResize = option[6] == "" ? "no" : option[6];
	
		sFeatures = "dialogWidth:"+popWidth+"px";
		sFeatures += ";dialogHeight:"+popHeight+"px";
		sFeatures += ";center:"+popCenter;
		sFeatures += ";dialogLeft:"+popXpos+"px";
		sFeatures += ";dialogTop:"+popYpos+"px";
		sFeatures += ";scroll:"+popScroll;
		sFeatures += ";resizable:"+popResize;
	}

 //Xecure 적용되면 풀어주어야 함
	var qs ;
	var path = "/";
	var cipher;
	var xecure_url;

	// get path info & query string & hash from url
	qs_begin_index = url.indexOf('?');
	path = getPath(url)
	// get query string action url
	if ( qs_begin_index < 0 ) {
		qs = "";
	}
	else {
		qs = url.substring(qs_begin_index + 1, url.length );
	}
	
	if( gIsContinue == 0 ) {
		gIsContinue = 1;
		if( IsNetscape60() )		// Netscape 6.0
			cipher = document.XecureWeb.nsIXecurePluginInstance.BlockEnc(xgate_addr, path, XecureEscape(qs), "GET");
		else 
			cipher = document.XecureWeb.BlockEnc(xgate_addr, path, XecureEscape(qs),"GET");
		gIsContinue = 0;
	}
	else {
		i18nAlert(busy_info);
		return false;
	}
			
	if( cipher == "" )	return XecureWebError();
	
	xecure_url = path + "?q=" + escape_url(cipher);
	// adding character set information
	if(usePageCharset)
		xecure_url += "&charset=" + document.charset;

	url = xecure_url;


	if(arg == "")
		arg = this;//파라미터가 없을 경우 현재 부모창을 넘김.

	window.showModalDialog(url, arg, sFeatures); 

}


/**
 * window.showModelessDialog(arg1,arg2,arg3)  옵션 배열의 갯수를 정확히 넣어줘야 합니다. 값이 필요 없으면 '' 을 넣습니다.
 * ex : openPopModeless(a.html,"test",[넓이,높이,center여부,x좌표,y좌표,scroll여부,resizable여부]) 
 *      openPopModeless(a.html,"test",['200','200','yes','200','200','yes','yes']) 
 * scroll은 default=yes임 , center가 yes로 되어있어도 x,y좌표가 있으면 좌표에 따른다.
 * @param url : 주소
 * @param arg : 파라미터
 * @param option : 창관련 옵션(배열형식)  
 * @return : 오픈시킨 window
 */
function openPopModeless(url, arg, option)
{
	var sFeatures = "";
	
	if(option != undefined) {
		var popWidth =  option[0];
		var popHeight =  option[1];
		var popCenter =  option[2] == "" ? "yes" : option[2];
		var popXpos =  option[3];
		var popYpos =  option[4];
		var popScroll =  option[5] == "" ? "yes" : option[5];
		var popResize =  option[6] == "" ? "yes" : option[6];
	
	
		var sFeatures = "dialogWidth:"+popWidth+"px";
		sFeatures += ";dialogHeight:"+popHeight+"px";
		sFeatures += ";center:"+popCenter;
		sFeatures += ";dialogLeft:"+popXpos+"px";
		sFeatures += ";dialogTop:"+popYpos+"px";
		sFeatures += ";scroll:"+popScroll;
		sFeatures += ";resizable:"+popResize;
	}


 //Xecure 적용되면 풀어주어야 함
	var qs ;
	var path = "/";
	var cipher;
	var xecure_url;

	// get path info & query string & hash from url
	qs_begin_index = url.indexOf('?');
	path = getPath(url)
	// get query string action url
	if ( qs_begin_index < 0 ) {
		qs = "";
	}
	else {
		qs = url.substring(qs_begin_index + 1, url.length );
	}
	
	if( gIsContinue == 0 ) {
		gIsContinue = 1;
		if( IsNetscape60() )		// Netscape 6.0
			cipher = document.XecureWeb.nsIXecurePluginInstance.BlockEnc(xgate_addr, path, XecureEscape(qs), "GET");
		else 
			cipher = document.XecureWeb.BlockEnc(xgate_addr, path, XecureEscape(qs),"GET");
		gIsContinue = 0;
	}
	else {
		i18nAlert(busy_info);
		return false;
	}
			
	if( cipher == "" )	return XecureWebError();
	
	xecure_url = path + "?q=" + escape_url(cipher);
	// adding character set information
	if(usePageCharset)
		xecure_url += "&charset=" + document.charset;

	url = xecure_url;


	if(arg == "")
		arg = this;//파라미터가 없을 경우 현재 부모창을 넘김.

	var win = window.showModelessDialog(url, arg, sFeatures); 
	return win;
}


/**
 * window.open(arg1,arg2,arg3)  옵션 배열의 갯수를 정확히 넣어줘야 합니다. 값이 필요 없으면 '' 을 넣습니다.
 * ex : <br>
 * openWinPop(a.html,"새창임","form 이름",[넓이,높이,x좌표,y좌표,scroll여부,resizable여부,주소창여부,menu var 여부,toolbar 여부,상태바 여부]) <br>
 * openWinPop(act,"popupWin","form2") -> form 데이타를 submit 하면서 일반적인 창 크기<br>
 * openWinPop("test.web","popupWin","form2",["500","600"]) -> form 데이타를 submit 하면서 팝업 사이즈가 500,600 을 띄울 경우<br>
 * openWinPop(act,"popupWin"); form 데이타없이 일반적인 크기의 팝업을 띄울경우<br>
 * openWinPop("test.web?a=1","popupWin","",["500","600"]) -> form 데이타없이 팝업을 띄울 경우<br>
 * scroll은 default=yes임 , center가 yes로 되어있어도 x,y좌표가 있으면 좌표에 따른다.<br>
 * @param url : 주소
 * @param popname : 윈도우 이름
 * @param option : 창관련 옵션(배열 형식)   
 */
function openWinPop(url, popname , formName , option)
{
	var sFeatures ="";
	if(option != undefined){
		var popWidth = option[0] == "" ? "600" : option[0];
		var popHeight = option[1] == "" ? "450" : option[1];
		var popLeft = option[2] == "" ? 0 : option[2];
		var popTop = option[3] == "" ? 0 : option[3];
		var popScroll = option[4] == "" ? "no" : option[4];
		var popResize = option[5] == "" ? "yes" : option[5];
		var popLocation = option[6] == "" ? "no" : option[6];
		var popMenubar = option[7] == "" ? "no" : option[7];
		var popToolbar = option[8] == "" ? "no" : option[8];
		var popStatus = option[9] == "" ? "no" : option[9];

		sFeatures = "width="+popWidth;
		sFeatures += ",height="+popHeight;
		sFeatures += ",left="+popLeft;
		sFeatures += ",top="+popTop;
		sFeatures += ",scrollbars="+popScroll;
		sFeatures += ",resizable="+popResize;
		sFeatures += ",location="+popLocation;
		sFeatures += ",menubar="+popMenubar;
		sFeatures += ",toolbar="+popToolbar;
		sFeatures += ",status="+popStatus;

	}
	
	if(formName != undefined && formName != "") {
		var newWin = window.open('', popname, sFeatures);
	
		var submitform = eval("document."+formName);
	
		submitform.action=url;
		submitform.target=popname; 
		submitform.submit();
//		XecureSubmit(submitform);	
		
	} else {
		var newWin = window.open(url, popname, sFeatures);
		newWin.focus();
		return newWin;

//		var newWin = XecureNavigate(url, popname, sFeatures);
	}

}
 
 


/**
 * onblur 이벤트에 사용되며 첫번째 인자와 해당 input 또는 select 객체값이 동일하면 
 * 한개이상의 인풋,select 창을 inable,disable 시키기
 * <br> ex: 
 * <br> 폼이 있을경우(폼이름:aForm) ex : onblur=orderDisableDiv('aaa',['aForm.dis1','aForm.dis2',...])
 * <br> 폼이 없을경우 ex : onblur=orderDisableDiv('aaa',['dis1','dis2',...])
 * @param divValue : disable 기준값
 * @param divName : disable 시킬 개체의 name(배열 1개 이상)
 */
function orderDisableDiv(divValue,divName)
{
	var eventValue = event.srcElement.value;

	if(eventValue == divValue) 
	{
		for(var i = 0 ; i < divName.length ; i++)
		{
			var eventTag = eval(divName[i]);
			
			//input창일때
			if ( eventTag.tagName.toString().toLowerCase() == "input" )
			{
				eventTag.readOnly = true;
				eventTag.disabled = true;
				eventTag.style.backgroundColor = "#cccccc";
			}

			//select box일때
			if ( eventTag.tagName.toString().toLowerCase() == "select")
				eventTag.disabled = true;
		}
	} else
	{
		for(var i = 0 ; i < divName.length ; i++)
		{
			var eventTag = eval(divName[i]);
			
			//input창일때
			if ( eventTag.tagName.toString().toLowerCase() == "input" )
			{
				eventTag.readOnly = false;
				eventTag.disabled = false;
				eventTag.style.backgroundColor = "";
			}

			//select box일때
			if ( eventTag.tagName.toString().toLowerCase() == "select")
				eventTag.disabled = false;
		}		
	}
}





/**
 * 디비 쿼리 리스트 팝업. 이미 등록되어 있는 팝업Action의 URL과 팝업에서 선택된 값이 입력될 parent창의 name을 넘기면 
 * 팝업에서 선택된 값이 셋팅됨 값 두개를 셋팅하여 parent창에 inputname, inputname_display에 셋팅됨. 
 * <br> ex : openPopupUnit("popup.web","form1.name","500","600"){
 * @param targetUrl : 팝업으로 등록되어 있는 Action URL 
 * @param inputName : parent창에서 값으로 사용될 input name
 * @param width : 팝업창 넓이	
 * @param height : 팝업창 높이
 */
function openPopupUnit(targetUrl,inputName,width,height){
	var url = targetUrl + "?inputName="+inputName;
	var popupWin = window.open(url,"popupWin","width="+width+",height="+height+",toolbar=no,resizable=yes");
}


/**
 * 수정 , 삭제, 수정취소,삭제취소 버튼 클릭시의 버튼 enable 함수
 * <br> ex : displayBtnOrder( "doUpdateCancel" )
 * @param targetMethod : 수정,삭제 수정취소,삭제취소의 명령값. /js/spider_common.js에 등록되어 있음.
 */
function displayBtnOrder( targetMethod )
{
	if ( targetMethod == updateMethod )
	{	
		registeTD.style.display="none";
		updateConfirmTD.style.display="inline";
		updateCancelTD.style.display="inline";
		deleteConfirmTD.style.display="none";
		deleteCancelTD.style.display="none";
	} else if( targetMethod == deleteMethod )
	{
		registeTD.style.display="none";
		updateConfirmTD.style.display="none";
		updateCancelTD.style.display="none";
		deleteConfirmTD.style.display="inline";
		deleteCancelTD.style.display="inline";	
	} else
	{
		registeTD.style.display="inline";
		updateConfirmTD.style.display="none";
		updateCancelTD.style.display="none";
		deleteConfirmTD.style.display="none";
		deleteCancelTD.style.display="none";	
	}

}

/**
 * 체크박스 체크 풀기
 * <br> ex : unCheckedCheckBoxState( "name" )
 * @param checkName : uncheck 할 체크 박스 이름 
 */
function unCheckedCheckBoxState( checkName )
{
	var checkingBox = eval( "form1."+checkName );
	
	if(checkingBox.length == undefined)
	{
		checkingBox.checked = false;
	} else
	{	
		for(var i = 0 ; i < checkingBox.length ; i++)
		{
			if(checkingBox[i].checked == true)
			{
				checkingBox[i].checked = false;
			}
		}
	}
}

/**
 * 한개 이상의 체크박스의 상태 점검하기
 * <br> ex : searchCheckBoxState( "name" )
 * @param 상태를 점검할 체크박스 이름
 * @return array[0] 체크박스중 체크된 갯수,array[1] 체크된 것중 마지막으로 체크된 체크박스의 value 
 */
function searchCheckBoxState( checkName )
{
	var checkCnt = 0;
	var checkedLine = 0;
	var checkingBox = eval( "form1."+checkName );
	if(checkingBox.length == undefined)
	{
		if(checkingBox.checked == true)
			return [1,0];
		else return [0,0];	
	}

	for(var i = 0 ; i < checkingBox.length ; i++)
	{
		if(checkingBox[i].checked == true)
		{
			checkCnt++;
			checkedLine = checkingBox[i].value;
		}
	}
	return [checkCnt,checkedLine];
}

/**
 * 인풋 창의 상태 변경 readOnly,color 색상 변경
 * <br> changeReadOnlyState(["name1","name2"])
 * @param 상태를 변경할 인풋 창 이름 배열 
 */
function changeReadOnlyState(changeArray)
{	
	
	for(var i = 0 ; i < changeArray.length ; i++)
	{
		var eventTag = eval(changeArray[i]);
		
		//input창일때
		if ( eventTag.tagName.toString().toLowerCase() == "input" )
		{
			eventTag.readOnly = true;
			eventTag.style.color = "#777777";
		}

		//select box일때
		if ( eventTag.tagName.toString().toLowerCase() == "select")
			eventTag.disabled = true;
	}
}

/**
 * 인풋 창의 상태 변경 Editable,color 색상 변경
 * <br> changeEditableState(["name1","name2"]) 
 * @param 상태를 변경할 인풋 창 이름 배열 
 */
function changeEditableState(changeArray)
{
	for(var i = 0 ; i < changeArray.length ; i++)
	{
		var eventTag = eval(changeArray[i]);
		
		//input창일때
		if ( eventTag.tagName.toString().toLowerCase() == "input" )
		{
			eventTag.readOnly = false;
			eventTag.style.color = "";
		}

		//select box일때
		if ( eventTag.tagName.toString().toLowerCase() == "select")
			eventTag.disabled = false;
	}		
}




/**
 * 조회일이 오늘 날짜보다 큰지 체크
 * <br> ex : validateSearchDate("20060812", "20060812" )
 * @param startDate : 체크할 날짜(yyyymmdd) , 
 * @param nowDate : 기준 날짜(yyyymmdd)
 * @return : boolean
 */
function validateSearchDate(startDate, nowDate )
{
	if(startDate.length > 8) 
	{
		alert("조회일이 잘못되었습니다.");
		return false;	
	} 

	if( parseInt(startDate,10) > parseInt(nowDate,10) )
	{
		return false;
	}
	
	return true;
}

/**
 * 조회기간 체크
 * ex : validateSearchPeriodDate("20060613","20060714",3)
 * @param startDate : 조회 시작일(yyyymmdd) 
 * @param nowDate : 기준 일(yyyymmdd)
 * @param period : 조회 기간(int)
 * @return : boolean
 */
function validateSearchPeriodDate(startDate, nowDate , period)
{
	if(startDate.length > 8) 
	{
		alert("조회일이 잘못되었습니다.");
		return false;	
	} 

	var startYY =  parseInt(startDate.substring(0,4),10);
	var endYY =  parseInt(nowDate.substring(0,4),10);
	var startMM =  parseInt(startDate.substring(4,6),10);
	var endMM =  parseInt(nowDate.substring(4,6),10);
	var startDD =  parseInt(startDate.substring(6),10);
	var endDD =  parseInt(nowDate.substring(6),10);
	var dd = endDD - startDD;
	
	var startToEnd = ( ( endYY - startYY ) * 12) + endMM - startMM;
	if( startToEnd > parseInt(period,10) )
	{
		alert("조회기간은 현재월 기준으로 "+period+"개월 이전까지만 조회 가능합니다.");
		return false;
	} else if(startToEnd == parseInt(period,10)) {
		if(dd >= 0) {
			alert("조회기간은 현재월 기준으로"+period+"개월 이전까지만 조회 가능합니다.");
			return false;
		} 
	}
	
	return true;
}

/**
 * 화면 프린트
 * ex : printPage()
 * @return : void
 */
function printPage(){
	window.print();
}

//공백 스트링 체크
function isEmpty(s){
   return ((s == null) || (s.length == 0));
   }

var whitespace = " \t\n\r";

//인자로 넘어온 문자열이 공백인지 체크
function isWhitespace(s){

      if (isEmpty(s)) return true;
      for (var i = 0; i < s.length; i++) {   
       var c = s.charAt(i);
       if (whitespace.indexOf(c) == -1) return false;
      }
  		return true;
}

/*
//공통 팝업 호출
function openCommPop(query, search, selectFunction) {
	var url = "/QMS/jsp/common/commonPopupLayer.jsp?query="+query;
	var searchValue  = search.split("||");
	for(i=0;i < searchValue.length;i++) {
		url += "&_search_" + searchValue[i]+"=";
	}
	url += "&selectFunction="+selectFunction; 
	//var selectValue  = select.split("||");
	//for(i=0;i < selectValue.length;i++) {
	//	url += "&_select_" + selectValue[i]+"=";
	//}
	//window.open(url,'','width=800,height=700,toolbar=yes,menubar=yes');
	var frm = document.form1;
	uf_ifr_submit(frm, url,600,800,"");
}
*/

//공통 팝업 호출 window open
function openCommPop(query, search, selectFunction, width, height) {
	var url = "/QMS/jsp/common/commonPopup.jsp?query="+query;
	var searchValue  = search.split("||");
	for(i=0;i < searchValue.length;i++) {
		url += "&_search_" + searchValue[i]+"=";
	}
	url += "&selectFunction="+selectFunction; 
	
	//window.open(url,'','width=width,height=height,toolbar=no,menubar=no,,scrollbars=yes');
	window.open(url,'','width='+width+',height='+height+',toolbar=no,menubar=no,resizable=yes,scrollbars=yes');
	var frm = document.form1;
}

//공통 팝업 호출 layer open
function openCommPoplayer(query, search, selectFunction, width, height) {
	var url = "/QMS/jsp/common/commonPopupLayer.jsp?query="+query;
	var searchValue  = search.split("||");
	for(i=0;i < searchValue.length;i++) {
		url += "&_search_" + searchValue[i]+"=";
	}
	url += "&selectFunction="+selectFunction; 
	
	if ( width == null || width == "" ) width = 551;
	
	//window.open(url,'','width=800,height=700,toolbar=no,menubar=no,,scrollbars=yes');
	var frm = document.form1;
	uf_ifr_submit(frm, url, width, height, "");
}
</script>