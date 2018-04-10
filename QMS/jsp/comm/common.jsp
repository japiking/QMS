<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
    <script language="javascript">
/**
* ���α׷� �� : spider �������� �ε��� �⺻ üũ ���
* �ϰ����� ���Ͽ� �⺻ ����Ǵ� �ɼǵ��� �ְ�, �߰����ִ� �κ��� db���� �߰� �ϰ� �Ǿ��ִ�. db������ ������ �ڵ����� �߰� �ϸ� ��.
* �ۼ��� : ������
* ���� �Ӽ� 
* 1. nullable =false �̸� �ʼ� ����� 
* 2. chartype  : �Է¹��� ���ڿ� �� 
* |���ڸ�	| ���	| �������	| �Ǽ� �ݾ�	 |���� �ݾ� |
* |onlynum	| Eng	    | engnum	| floatmoney | money   |
* 3. maskform #�� �����ڷ� �̷���� ����ũ. #�� �����̰� �����ڰ� �� ��ġ�� ���� �� 
* ex : 123456789 maskform="##-##,##.##/#"  ��� 12-34,56.78/9 
* ����� ����ũ�� ���� ���� �� ��� maskform="usermask"�� �����Ͽ� ����ũ�� �����ϸ� �����ӿ�ũ���� spidersubmit()�ÿ� ����,���� �̿��� ���ڸ� ������.
* 4. maximum  : �ִ밪 
* 5. minimum  : �ּҰ� 
* 6. disablecss  : inputâ�� Ȱ��ȭ,��Ȱ��ȭ �Ӽ� ���� 
* 7. maxbyte : �ִ� �Է� ����Ʈ ���� ���.
* 7. format  : deprecate �Լ� ȣ�� �������� �ٲ� ������ ��ũ�� �ִ� �Լ� ȣ��(�ֹι�ȣ,�̸���,����ڹ�ȣ. �Ӽ��� : psn,email,crn,date)
*/


<%
	String localeCode = "KO";

%>

/**
 * �ٱ��� alert() �޼����� ���
 * ex : i18nAlert('I18NUtil.getLabel(localeCode, "IBA00001","����1ȸ��ü�ѵ��ݾ��� �ʰ��Ͽ����ϴ�.")') (��ũ��Ʋ����.)
 * @param msg : �ٱ��� �޼��� 
 * @return : alert(msg) �޼���
 */
function i18nAlert(msg){
	var alertElem = document.createElement("<span>");
	alertElem.innerHTML = msg;
	alert(alertElem.outerText);
}



/**
 * �ٱ��� confirm() �޼����� ���
 * ex : i18nConfirm('I18NUtil.getLabel(localeCode, "COA00001","�����Ͻðڽ��ϱ�?")') (��ũ��Ʋ����.)
 * @param msg : �ٱ��� �޼��� 
 * @return : alert(msg) �޼���
 */
function i18nConfirm(msg){
	var confirmElem = document.createElement("<span>");
	confirmElem.innerHTML = msg;
	return confirm(confirmElem.outerText);
}

//----------------------------------- ������ initialize ���� �Լ� ���� ------------------------------------------------//

/**
 * html ������ �ε��� ���� �����ϴ� ��ũ��Ʈ.
 */
initializeHtmlPage();

/**
 * ���� �ε��� ������ �ʱ� ����
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
 * ȣ��� ������ �����ϱ�.
 * <br>initialize�� �����ϴ� ���� : �ʼ� ���(css),mask,letter type
*/ 
function initializeHtmlForm()
{
	//spiderSubmit �Ҵ�
	this.spiderSubmit = formSubmitValidation;
	this.submitstat = "false";

	for (var i = 0 ; i < this.elements.length ; i++)
	{
		if (this.elements[i].tagName.toString().toLowerCase() == "input")
		{
			//�ʼ� ����϶��� ��ǲâ ���� ���� �̹��� ����.
			if ( this.elements[i].nullable == "false")
				this.elements[i].className = "frameworkInitNullable";
		
			//mask�� ������� #�� ���� �ǹ���.
			if (this.elements[i].maskform != undefined && this.elements[i].maskform != "")
			{
				if(this.elements[i].maskform != "usermask")
					initSetMaskUp(this.elements[i]);//mask Ÿ��(ex : ####/##/## , ####-##-## , ######-####### , ###-##-##### , ...)
			}
			//���� Ÿ���� �������
			if (this.elements[i].chartype  != undefined)
				initSetLetterType(this.elements[i]);//���� ��(english,korean,english+number, number, floatmoney,int)Ÿ��
				
			//�Ӽ��� �������
			if ( this.elements[i].disablecss  != undefined)
				initSetAttribute(this.elements[i])	
			//maxlength�� �������
			if ( this.elements[i].maxLength  != undefined)
			{
				initSetMaxLength(this.elements[i]);	
			}
				
			//maxByte�� �������
			if ( this.elements[i].maxbyte  != undefined)
			{
				initSetMaxLength(this.elements[i]);	
			}
				
			//uppercase��  ���� ��� 	
			if (this.elements[i].uppercase  != undefined){
				if(this.elements[i].chartype  == undefined){
					initSetUpperLower(this.elements[i])	
				}
			}	
			//lowercase��  ���� ��� 	
			if (this.elements[i].lowercase  != undefined){
				if(this.elements[i].chartype  == undefined){
					initSetUpperLower(this.elements[i])	
				}
			}	
		}
	}
}

/**
 * ���ڿ��� Byte���̷� �߶��.
 * <br> ex : cutStringToByte(form1.name.value, bytelength)
 * @param strValue : ����Ʈ ���̷� �ڸ� ���ڿ� 
 * @param cutByte : ����Ʈ ����
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
 * uppercase, lowercase ������ keyPress�� �̺�Ʈ �߻�.
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
 * maxLength, maxbyte ������ keyUp�� �̺�Ʈ �߻�.
*/
function initSetMaxLength(elem) {
	if(elem.onkeyup == undefined){
		elem.onkeyup = setOverSetFocus;
	}
}

/**
 * �Ӽ��� ���� inputâ ���� ����.
 * <br> ex : initSetAttribute(form1.name)
 * @param elem : �̺�Ʈ�� ������ element
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
 * maxLength, maxbyte ������ �ִ밪���� �� �������� �ڵ� ��Ŀ�� �̵�.
 * <br> ex : setOverSetFocus()
*/
function setOverSetFocus() {
	//this ��ü�� ����  ���̸� ��������
	var thisFrm = eval(this.parentElement);
	while("form" != thisFrm.tagName.toString().toLowerCase()) 
	{
		thisFrm = eval(thisFrm.parentElement);		
	}
	
	var nextFocus = this;
	//���� ��Ŀ�� Ÿ�� ��������.
	for (var i = 0 ; i < thisFrm.elements.length ; i++)
	{
		if (thisFrm.elements[i].tagName.toString().toLowerCase() == "input") 
		{
			//���� this���� ���õ� elements�̸� �������� �̵��� ��Ŀ���� �������� ���� ��������.
			if(this == thisFrm.elements[i]) 
			{		
				//elements�� undefined �ɶ� ���� ������.
				while(thisFrm.elements[++i] != undefined) 
				{	
					//���� elements�� �θ����� �Ӽ��� display = none�̸� ���� ��Ŀ�� Ÿ���� �����´�.
					var targetCursor = eval(thisFrm.elements[i].parentElement);
					while("form" != targetCursor.tagName.toString().toLowerCase())	{
						if(targetCursor.parentElement.style.display == "none") break;
						targetCursor = eval(targetCursor.parentElement);	
						
					}
					if(targetCursor.parentElement.style.display == "none") continue;
				
					//elementsŸ���� input (text,radio,checkbox), textarea, select �ϰ�� ���� ��Ŀ�� obj����.
					//  /ibs/jsp/common/com_tranpwdreg_i.jsp���� ��ũ��Ʈ ī�� �Է��ϴ� �κп� display�� none�� ��� ���� (style = "tx h") 
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
	
	//��Ŀ�� �̵�. maxLength 2147483647�� maxLength�� ���� ���� �ʾ������ �⺻������ �ִ� �ִ밪.
	if(this.maxbyte != undefined && this.maxLength != 2147483647) {
	//1. maxbyte�� maxLength�� �Ѵ� ���� �Ͽ�����..
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
	//2. maxLength�� ����������..			
		//�ѱ��� ���Ե� chartype���� maxLength-2 ���� �ѱ��. 20080721 ����� �߰�. 
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
	//3. maxByte�� ����������..
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
 * ���ڿ� ����ũ �����
 * <br> ex : initSetMaskUp(form1.name)
 * @param elem : ����ũ�� ������ element
 */
function initSetMaskUp(elem)
{
	elem.onkeypress = setKeyInputNumberOnly;
	elem.onfocus = filterGetNumberOnly;
	elem.onblur = setInitMaskUp;
}


/**
 * �ֹ� ����� ��ȣ onkeyup�̺�Ʈ�� ����ũ �����
 * <br> ex : psnCrnMaskup(form1.name)
 * @param elem : ����ũ�� ������ element
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
 * ������ �ʱ�ȭ�ÿ� onfocus �̺�Ʈ�� �Ҵ�Ǹ� �� Elemnent�� ���ڿ��� ����("," , "/" , "-")�� focus�ÿ� ���ŵ�
 */
function filterGetNumberOnly()
{
	this.value = getOnlyNumberFormat(this.value);
	this.select();
}



/**
 * ���ڿ����� ���ڸ� ������ üũ ����
 * ex : getOnlyNumberFormat(form1.name.value)
 * @param sv : ��ȯ�� String ��
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
 * ������ �ʱ�ȭ�ÿ� ����ũ ��������� ��ȯ�ϱ�
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
 * ������ �ʱ�ȭ�� ���ڸ� �Է¹ޱ�
 */
function setKeyInputNumberOnly()
{
	if(event.shiftKey == true) event.returnValue = false;
	
	if ( event.keyCode >= 48 && event.keyCode <= 57 )//���� Ű�ڵ尪
	{
        return true;
    }
    else 
    {
		// enter, tab, backspace ����Ű(��,��)�� ����ó��
		if(event.keyCode == 8 || event.keyCode == 9 || event.keyCode == 37 || event.keyCode == 39)
		{
			return true;
		}
		event.returnValue = false;
	}
}



/**
 * ������ �ʱ�ȭ�ÿ� ��� �� ������ �Է� �� ǥ�� ó��.
 * @param elem : �̺�Ʈ�� ������ element
 */
function initSetLetterType(elem)
{
	elem.style.imeMode = "disabled";
	if (elem.chartype  == "eng")//���
	{
		elem.onkeypress = setLetterEnglishOnly;
			
	} else if (elem.chartype  == "engnum")//����+����
	{
		elem.style.imeMode = "disabled";
		
	} else if (elem.chartype  == "float")//�Ǽ���
	{
		elem.onkeypress = setLetterFloatOnly;
		
	} else if (elem.chartype  == "int")//������
	{
		elem.onkeypress = setLetterInteger;
		
	} else if (elem.chartype  == "onlynum")//���� ���ڸ�
	{
		elem.onkeypress = setKeyInputNumberOnly;
		
	} else if (elem.chartype  == "money")//�����θ� �� ���� �⺻���� �ݾ� ǥ��
	{
		elem.style.textAlign="right";
		elem.onkeydown = setKeydownMoney;//Ű�� ����������
		elem.onkeyup = setKeypressMoney;//Ű�� ������ ��������
	} else if (elem.chartype == "floatmoney")
	{
		elem.style.textAlign="right";
		elem.onkeydown = setKeydownFloatMoney;//Ű�� ����������
		elem.onkeyup = setFloatMoney;//Ű�� ������ ��������
	}
}


/**
 * ������ �ʱ�ȭ�� -,���� �Է¹ޱ�( - Ű�ڵ尪 189)
 */
function setKeydownMoney()
{
	if(event.shiftKey == true) event.returnValue = false;

	if ( (event.keyCode >= 48 && event.keyCode <= 57) || (event.keyCode >= 96 && event.keyCode <= 105) )//���� Ű�ڵ尪
	{
        return true;
    }
    else 
    {
		// enter, tab, backspace ����Ű(��,��),delete�� ����ó��
		if(event.keyCode == 8 || event.keyCode == 9 || event.keyCode == 37 || event.keyCode == 39 || event.keyCode == 189 || event.keyCode == 46)
		{
			return true;
		}
		event.returnValue = false;
	}
}


/**
 * ������ �ʱ�ȭ �ÿ� �ݾ� ������ ��� Ű �Է½� �ݾ� ���·� ��ȯ
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
 * ��Ʈ������ ������ �Ӵ� ���·� ��ȯ
 * <br> ex : changeIntMoneyType("1100000") ���ϵǴ� ����Ÿ : 1,100,000
 * @param data : ��ȯ�� String ����Ÿ
 * @return �ݾ� ���·� ��ȯ�� ��Ʈ��
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
 * �Ǽ��� �ݾ� �Է����� ��ũ��Ʈ. ���� , . , - ���� �Է¹���. �Ҽ��� ��° �ڸ������� �Էµ�
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

	if ( (event.keyCode >= 48 && event.keyCode <= 57) || (event.keyCode >= 96 && event.keyCode <= 105) )//���� Ű�ڵ尪
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
 * Ű �Է½� float Ÿ���� �ݾ� ���·� ��ȯ
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
 * Ű �Է½� ��� �Է¹ޱ�
 */
function setLetterEnglishOnly()
{ 
	 var pKey = String.fromCharCode(event.keyCode);
	 var eReg = /[a-zA-Z]/g;
	 
	 if(pKey!="\r" && !eReg.test(pKey)) //����Ű �� regkey�� �ƴҰ�� ����
		event.returnValue=false;
	 
	 delete eReg;
}


/**
 * Ű �Է½� ����,- ���� �Է¹���.
 */
function setLetterInteger()
{ 
	 var pKey = String.fromCharCode(event.keyCode);
	 var intReg = /[0-9\\-]/g;
	 
	 if(pKey!="\r" && !intReg.test(pKey)) //����Ű �� regkey�� �ƴҰ�� ����
		event.returnValue=false;
	 
	 delete intReg;
}


/**
 * Ű �Է½� ���� , . , - ���� �Է¹���.
 */
function setLetterFloatOnly()
{
	 var pKey = String.fromCharCode(event.keyCode);
	 var floatReg = /[0-9\\.\\-]/g;
	 
	 if(pKey!="\r" && !floatReg.test(pKey)) //����Ű �� regkey�� �ƴҰ�� ����
		event.returnValue=false;
	 
	 delete floatReg;
}

//-----------------------------------------------------------------------------------------------------------------//
//----------------------------------- ������ initialize ���� �Լ� �� ------------------------------------------------//

/**
 * �ּҰ� üũ ����
 * <br> ex : validationMinimum("100000","10000")
 * @param minV : ������ �ּ� value 
 * @param inV : �Էµ� Value
 * @return boolean
 */
function validationMinimum(minV,inV)
{	
	if (minV == "") 
	{
		alert("������ �ּҰ��� �����ϴ�.");
		return false;
	}
	
    if ( parseFloat(inV) < parseFloat(minV) )
    {
        return false;
    }
    
    return true;
}


/**
 * �ִ밪 üũ ����
 * <br> ex : validationMaximum("100000","10000")
 * @param maxV : ������ �ִ� value
 * @param inV : �Էµ� Value
 * @return boolean
 */
function validationMaximum(maxV,inV)
{	
	if (maxV == "") 
	{
		alert("������ �ִ밪�� �����ϴ�.");
		return false;
	}

	
    if ( parseFloat(maxV) < parseFloat(inV) )
    {
        return false;
    }        
    return true;
}


/**
 * �ִ� btye üũ ���� 
 * <br> ex : validationMaxByte(form1.inputname.value , 10)
 * @param textObj : üũ�� String value 
 * @param length_limit : �ִ� byte  
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
 * �ѱ� 2���� ���� 1���ڷ� ���� �����Ͽ� ���ڿ��� byte ���̸� �����Ѵ�.
 * @param üũ�� String value 
 * @return ������ �ش� ���� byte ����
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
 * get,put �� �Ǵ� hash table
 * <br> ex :  
 * <br>var temphash = new javascriptHashtable()
 * <br>temphash.put("key1","�����"); �� �ֱ�
 * <br>temphash.put("key2","�Ͽ���");
 * <br>temphash.get("key1"); �� ��������
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
 * ��ø�� css���� �ش� css�� ����
 * <br> removeCss(["input1","input2"],"input1")
 * @param cssArr : �����Ǿ� �ִ� class �迭. (����� css�� class="input1 input2" �̷������� �ߺ��ɼ� �ִ�.
 * @param reAtt : ������ css��
 * @return ������ css�� ���ŵ� ��Ʈ����
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
 * sider FrameWork�� form submit �Լ� 
 */
function formSubmitValidation()
{
	//���� ����� ���� 
	if(this.submitstat != "false")
	{
		alert("�̹� submit �Ǿ����ϴ�.");
		return;
	}
	else
	{
		this.submitstat = "validating";
		//�⺻ �븮���̼� üũ �Լ� ȣ��
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
 * validation check �Լ� 
 * @param checkForm : validation �˻縦 �� ��.
 * @return boolean
*/
function initBaseValidationCheck(checkForm)
{	
	for (var i = 0 ; i < checkForm.elements.length ; i++)
	{
		//mask�� ������ ����ũ �� ����
		if ( ( checkForm.elements[i].maskform != undefined && checkForm.elements[i].maskform != "") || checkForm.elements[i].chartype  == "money")
		{
			if(checkForm.elements[i].maskform == "usermask")
			{
				checkForm.elements[i].value = unMaskEngNum(checkForm.elements[i].value);//����� ����ũ ����� ����.
			} else
			{
				checkForm.elements[i].value = getOnlyNumberFormat(checkForm.elements[i].value);			
			}
		}
		
		//input Ÿ��
		if (checkForm.elements[i].tagName.toString().toLowerCase() == "input" )
		{
			//�ʼ� �� üũ
			if ( checkForm.elements[i].nullable == "false")
			{
				if(checkForm.elements[i].type.toString().toLowerCase() == "text" || checkForm.elements[i].type.toString().toLowerCase() == "password")
				{
					if( checkForm.elements[i].value == "" )
					{
						//colname ��Ʈ����Ʈ �߰��Ǹ鼭 ���ϴ� if�� �߰�.20080129
						if(checkForm.elements[i].collname != undefined) {
							alert("[" + checkForm.elements[i].collname  + "] "+"�ʼ� �Է� �����Դϴ�.");
							
						}else{ 
							alert("�ʼ� �Է� �����Դϴ�.");
							
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
					} else //�ѹ� validation���� css������ �Ǿ������ ���� �ϱ� ������.
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
						alert("�ʼ� �Է� �����Դϴ�.");
						checkForm.elements[i].focus();
						return false;
					}
				}
			} 
			
			if( checkForm.elements[i].value != "")
			{	
				//�ִ밪 üũ
				if ( checkForm.elements[i].maximum  != undefined && checkForm.elements[i].maximum != "")
				{
					if ( !validationMaximum(checkForm.elements[i].maximum  , checkForm.elements[i].value) )
					{
						alert("������ �ִ밪���� Ů�ϴ�.");
						checkForm.elements[i].select();
						return false;
					}	
				}


				//�ּҰ� üũ
				if ( checkForm.elements[i].minimum != undefined && checkForm.elements[i].minimum != "")
				{
					if ( !validationMinimum(checkForm.elements[i].minimum  , checkForm.elements[i].value) )
					{
						alert("������ �ּҰ����� �۽��ϴ�.");
						checkForm.elements[i].select();
						return false;
					}	
				}
				
				//�ִ� ����Ʈ üũ
				if ( checkForm.elements[i].maxbyte != undefined && checkForm.elements[i].maxbyte != "")
				{
					if ( !validationMaxByte(checkForm.elements[i].value , checkForm.elements[i].maxbyte) )
					{
						var kor_cnt = Math.floor(checkForm.elements[i].maxbyte/2);
						alert("�ѱ� "+ kor_cnt + "��, ���� " + checkForm.elements[i].maxbyte + "�ڸ� �ʰ��� �� �����ϴ�.");
						checkForm.elements[i].select();
						return false;
					}	
				}
			}
			
		//select Ÿ���� �ʼ��϶�	
		} else if (	checkForm.elements[i].tagName.toString().toLowerCase() == "select" )
		{
			if(checkForm.elements[i].disabled==true) checkForm.elements[i].disabled = false;
			
			if(checkForm.elements[i].nullable == "false" && checkForm.elements[i].value == "")
			{
				alert("�ʼ� �Է� �����Դϴ�.");
				checkForm.elements[i].focus();
				return false;
			}
		//textarea Ÿ���� �ʼ��϶�	
		}else if (	checkForm.elements[i].tagName.toString().toLowerCase() == "textarea" )
		{
						
			if(checkForm.elements[i].nullable == "false" && isWhitespace(checkForm.elements[i].value))
			{
				alert("�ʼ� �Է� �����Դϴ�.");
				checkForm.elements[i].value = '';
				checkForm.elements[i].focus();
				return false;
			}
		}

	}//for�� ��
	
	return true;
}

/**
 * MaskUp�� ����Ÿ���� ����ũ Delemeter �����ϰ� �� ����
 * <br> ex : unMaskUpData(form1.name)
 * @param element : ����ũ�� ��� name �Ǵ� �ش� ��ü ��ü.
 * @return �����ڸ� ������ ����Ÿ��
 */
function unMaskUpData(element)
{
	var unmaskData = "";
	//mask�� ������ ����ũ �� ����
	if ( ( element.maskform != undefined && element.maskform != "") || element.chartype  == "money")
	{
		unmaskData = getOnlyNumberFormat(element.value);//spcommon.js�� �ִ� ���ڸ� ������ ����
	} else unmaskData = element.value;
	
	return unmaskData;
}



/**
 * ����ڰ� ������ ����ũ�� ��Ÿ���� ����,���� ȥ���� ����Ÿ�� mask�� ���ﶧ ��� ����,���� �̿��� ���� ����
 * <br> ex : unMaskEngNum(String)
 * @param element : ����ũ�� �ִ� String 
 * @return �����ڸ� ������ String
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
 * ���� javascript ���
 */
 
 

/**
 * window.showModalDialog(arg1,arg2,arg3) �ɼ� �迭�� ������ ��Ȯ�� �־���� �մϴ�. ���� �ʿ� ������ '' �� �ֽ��ϴ�.
 * ex : openPopModal(a.html,"test",[����,����,center����,x��ǥ,y��ǥ,scroll����,resizable����]) 
 *      openPopModal(a.html,"test",['200','200','yes','200','200','yes','yes']) 
 * scroll�� default=yes�� , center�� yes�� �Ǿ��־ x,y��ǥ�� ������ ��ǥ�� ������.
 * @param url : �ּ�
 * @param arg : �Ѱ��� �Ķ����
 * @param option : â���� �ɼ�(�迭 ����)  
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

 //Xecure ����Ǹ� Ǯ���־�� ��
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
		arg = this;//�Ķ���Ͱ� ���� ��� ���� �θ�â�� �ѱ�.

	window.showModalDialog(url, arg, sFeatures); 

}


/**
 * window.showModelessDialog(arg1,arg2,arg3)  �ɼ� �迭�� ������ ��Ȯ�� �־���� �մϴ�. ���� �ʿ� ������ '' �� �ֽ��ϴ�.
 * ex : openPopModeless(a.html,"test",[����,����,center����,x��ǥ,y��ǥ,scroll����,resizable����]) 
 *      openPopModeless(a.html,"test",['200','200','yes','200','200','yes','yes']) 
 * scroll�� default=yes�� , center�� yes�� �Ǿ��־ x,y��ǥ�� ������ ��ǥ�� ������.
 * @param url : �ּ�
 * @param arg : �Ķ����
 * @param option : â���� �ɼ�(�迭����)  
 * @return : ���½�Ų window
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


 //Xecure ����Ǹ� Ǯ���־�� ��
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
		arg = this;//�Ķ���Ͱ� ���� ��� ���� �θ�â�� �ѱ�.

	var win = window.showModelessDialog(url, arg, sFeatures); 
	return win;
}


/**
 * window.open(arg1,arg2,arg3)  �ɼ� �迭�� ������ ��Ȯ�� �־���� �մϴ�. ���� �ʿ� ������ '' �� �ֽ��ϴ�.
 * ex : <br>
 * openWinPop(a.html,"��â��","form �̸�",[����,����,x��ǥ,y��ǥ,scroll����,resizable����,�ּ�â����,menu var ����,toolbar ����,���¹� ����]) <br>
 * openWinPop(act,"popupWin","form2") -> form ����Ÿ�� submit �ϸ鼭 �Ϲ����� â ũ��<br>
 * openWinPop("test.web","popupWin","form2",["500","600"]) -> form ����Ÿ�� submit �ϸ鼭 �˾� ����� 500,600 �� ��� ���<br>
 * openWinPop(act,"popupWin"); form ����Ÿ���� �Ϲ����� ũ���� �˾��� �����<br>
 * openWinPop("test.web?a=1","popupWin","",["500","600"]) -> form ����Ÿ���� �˾��� ��� ���<br>
 * scroll�� default=yes�� , center�� yes�� �Ǿ��־ x,y��ǥ�� ������ ��ǥ�� ������.<br>
 * @param url : �ּ�
 * @param popname : ������ �̸�
 * @param option : â���� �ɼ�(�迭 ����)   
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
 * onblur �̺�Ʈ�� ���Ǹ� ù��° ���ڿ� �ش� input �Ǵ� select ��ü���� �����ϸ� 
 * �Ѱ��̻��� ��ǲ,select â�� inable,disable ��Ű��
 * <br> ex: 
 * <br> ���� �������(���̸�:aForm) ex : onblur=orderDisableDiv('aaa',['aForm.dis1','aForm.dis2',...])
 * <br> ���� ������� ex : onblur=orderDisableDiv('aaa',['dis1','dis2',...])
 * @param divValue : disable ���ذ�
 * @param divName : disable ��ų ��ü�� name(�迭 1�� �̻�)
 */
function orderDisableDiv(divValue,divName)
{
	var eventValue = event.srcElement.value;

	if(eventValue == divValue) 
	{
		for(var i = 0 ; i < divName.length ; i++)
		{
			var eventTag = eval(divName[i]);
			
			//inputâ�϶�
			if ( eventTag.tagName.toString().toLowerCase() == "input" )
			{
				eventTag.readOnly = true;
				eventTag.disabled = true;
				eventTag.style.backgroundColor = "#cccccc";
			}

			//select box�϶�
			if ( eventTag.tagName.toString().toLowerCase() == "select")
				eventTag.disabled = true;
		}
	} else
	{
		for(var i = 0 ; i < divName.length ; i++)
		{
			var eventTag = eval(divName[i]);
			
			//inputâ�϶�
			if ( eventTag.tagName.toString().toLowerCase() == "input" )
			{
				eventTag.readOnly = false;
				eventTag.disabled = false;
				eventTag.style.backgroundColor = "";
			}

			//select box�϶�
			if ( eventTag.tagName.toString().toLowerCase() == "select")
				eventTag.disabled = false;
		}		
	}
}





/**
 * ��� ���� ����Ʈ �˾�. �̹� ��ϵǾ� �ִ� �˾�Action�� URL�� �˾����� ���õ� ���� �Էµ� parentâ�� name�� �ѱ�� 
 * �˾����� ���õ� ���� ���õ� �� �ΰ��� �����Ͽ� parentâ�� inputname, inputname_display�� ���õ�. 
 * <br> ex : openPopupUnit("popup.web","form1.name","500","600"){
 * @param targetUrl : �˾����� ��ϵǾ� �ִ� Action URL 
 * @param inputName : parentâ���� ������ ���� input name
 * @param width : �˾�â ����	
 * @param height : �˾�â ����
 */
function openPopupUnit(targetUrl,inputName,width,height){
	var url = targetUrl + "?inputName="+inputName;
	var popupWin = window.open(url,"popupWin","width="+width+",height="+height+",toolbar=no,resizable=yes");
}


/**
 * ���� , ����, �������,������� ��ư Ŭ������ ��ư enable �Լ�
 * <br> ex : displayBtnOrder( "doUpdateCancel" )
 * @param targetMethod : ����,���� �������,��������� ��ɰ�. /js/spider_common.js�� ��ϵǾ� ����.
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
 * üũ�ڽ� üũ Ǯ��
 * <br> ex : unCheckedCheckBoxState( "name" )
 * @param checkName : uncheck �� üũ �ڽ� �̸� 
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
 * �Ѱ� �̻��� üũ�ڽ��� ���� �����ϱ�
 * <br> ex : searchCheckBoxState( "name" )
 * @param ���¸� ������ üũ�ڽ� �̸�
 * @return array[0] üũ�ڽ��� üũ�� ����,array[1] üũ�� ���� ���������� üũ�� üũ�ڽ��� value 
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
 * ��ǲ â�� ���� ���� readOnly,color ���� ����
 * <br> changeReadOnlyState(["name1","name2"])
 * @param ���¸� ������ ��ǲ â �̸� �迭 
 */
function changeReadOnlyState(changeArray)
{	
	
	for(var i = 0 ; i < changeArray.length ; i++)
	{
		var eventTag = eval(changeArray[i]);
		
		//inputâ�϶�
		if ( eventTag.tagName.toString().toLowerCase() == "input" )
		{
			eventTag.readOnly = true;
			eventTag.style.color = "#777777";
		}

		//select box�϶�
		if ( eventTag.tagName.toString().toLowerCase() == "select")
			eventTag.disabled = true;
	}
}

/**
 * ��ǲ â�� ���� ���� Editable,color ���� ����
 * <br> changeEditableState(["name1","name2"]) 
 * @param ���¸� ������ ��ǲ â �̸� �迭 
 */
function changeEditableState(changeArray)
{
	for(var i = 0 ; i < changeArray.length ; i++)
	{
		var eventTag = eval(changeArray[i]);
		
		//inputâ�϶�
		if ( eventTag.tagName.toString().toLowerCase() == "input" )
		{
			eventTag.readOnly = false;
			eventTag.style.color = "";
		}

		//select box�϶�
		if ( eventTag.tagName.toString().toLowerCase() == "select")
			eventTag.disabled = false;
	}		
}




/**
 * ��ȸ���� ���� ��¥���� ū�� üũ
 * <br> ex : validateSearchDate("20060812", "20060812" )
 * @param startDate : üũ�� ��¥(yyyymmdd) , 
 * @param nowDate : ���� ��¥(yyyymmdd)
 * @return : boolean
 */
function validateSearchDate(startDate, nowDate )
{
	if(startDate.length > 8) 
	{
		alert("��ȸ���� �߸��Ǿ����ϴ�.");
		return false;	
	} 

	if( parseInt(startDate,10) > parseInt(nowDate,10) )
	{
		return false;
	}
	
	return true;
}

/**
 * ��ȸ�Ⱓ üũ
 * ex : validateSearchPeriodDate("20060613","20060714",3)
 * @param startDate : ��ȸ ������(yyyymmdd) 
 * @param nowDate : ���� ��(yyyymmdd)
 * @param period : ��ȸ �Ⱓ(int)
 * @return : boolean
 */
function validateSearchPeriodDate(startDate, nowDate , period)
{
	if(startDate.length > 8) 
	{
		alert("��ȸ���� �߸��Ǿ����ϴ�.");
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
		alert("��ȸ�Ⱓ�� ����� �������� "+period+"���� ���������� ��ȸ �����մϴ�.");
		return false;
	} else if(startToEnd == parseInt(period,10)) {
		if(dd >= 0) {
			alert("��ȸ�Ⱓ�� ����� ��������"+period+"���� ���������� ��ȸ �����մϴ�.");
			return false;
		} 
	}
	
	return true;
}

/**
 * ȭ�� ����Ʈ
 * ex : printPage()
 * @return : void
 */
function printPage(){
	window.print();
}

//���� ��Ʈ�� üũ
function isEmpty(s){
   return ((s == null) || (s.length == 0));
   }

var whitespace = " \t\n\r";

//���ڷ� �Ѿ�� ���ڿ��� �������� üũ
function isWhitespace(s){

      if (isEmpty(s)) return true;
      for (var i = 0; i < s.length; i++) {   
       var c = s.charAt(i);
       if (whitespace.indexOf(c) == -1) return false;
      }
  		return true;
}

/*
//���� �˾� ȣ��
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

//���� �˾� ȣ�� window open
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

//���� �˾� ȣ�� layer open
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