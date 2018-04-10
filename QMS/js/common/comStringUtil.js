var _comStringUtil = function(){
};
_comStringUtil.instance = new _comStringUtil();
_comStringUtil.getInstance = function() {
	return _comStringUtil.instance;
};

/**
	 * length 길이보다 strData가 작은경우, 왼쪽을 빈자리만큼 strPad로 채운다.
	 * @param strData : 원본 데이터
	 * @param length : strPad 붙힐 데이터 길이
	 * @param strPad :대상 데이터
	 * @returns : strPad 과 strData가 붙은 데이터
	 * @예제 : StringUtil.lPad("1234", 6 , "0") => "001234"
	 */
_comStringUtil.prototype.lPad = function(strData,length,strPad){
	var retStr = "";
	var padCnt = Number(length) - String(strData).length;
	var i = 0;
	for(i=0 ;i < padCnt;i++)
		retStr += String(strPad);
	return retStr+strData;
};

/**
	 * length 길이보다 strData가 작은경우, 오른쪽을 빈자리만큼 strPad로 채운다.
	 * @param strData : 원본 데이터
	 * @param length : strPad 붙힐 데이터 길이
	 * @param strPad :대상 데이터
	 * @returns : strPad 과 strData가 붙은 데이터
	 * @예제 : StringUtil.rPad("1234", 6 , "0") => "123400"
	 */
_comStringUtil.prototype.rPad = function(strData,length,strPad){
	var retStr = "";
	  var padCnt = Number(length) - String(strData).length;
	  for(var i=0 ;i < padCnt;i++) retStr += String(strPad);
	  return strData+retStr;
};

/**
	 * 데이터값 변경[정규식]
	 * @param {string} strData	 : 원본데이터
	 * @param {string} strValue1 : 변경 전 문자열
	 * @param {string} strValue2 : 변경 후 문자열
	 * @예제 : StringUtil.replaceAll("TESTAAA", "AAA", "BBB") = > "TESTBBB"
	 */
_comStringUtil.prototype.replaceAll = function(strData, strValue1, strValue2){
	  var strTemp = strData;
	    strTemp = strTemp.replace(new RegExp(strValue1, "g"), strValue2);
	    return strTemp;
};

/**
 * 한글 2byte, 영문 1byte로 계산하여 문자열의 byte길이를 return 한다.
 * @param value : 계산할 string Value
 * @return nbyte : byte 길이
 */
	 
_comStringUtil.prototype.getByte = function(strValue){
	  var nbytes = 0;

		    for (var i=0; i<strValue.length; i++) {
		        var ch = strValue.charAt(i);

		        if(escape(ch).length > 4) {
		            nbytes += 2;
		        } else if (ch == '\n') {
		            if (strValue.charAt(i-1) != '\r') {
		                nbytes += 1;
		            }
		        } else if (ch == '<' || ch == '>') {
		            nbytes += 4;
		        } else {
		            nbytes += 1;
		        }
		    }
		    return nbytes;
};
	 
/**
 * 문자열을 전각문자열로 변환 ( 문자열의 반각문자를 전각문자로 변환)
 * @param {string} halfString : 반각문자열
 * @return {string} x_2byteString : 전각문자열
 */
_comStringUtil.prototype.convert2ByteString = function(halfString){
// 숫자는 전각처리 제외
		/*		if(numfullchar == "false") {
	        if(this.isNotKor(halfStr)){
	            return halfString;
	        }
	    }*/
	    var x_2byteString = ""; /* 컨버트된 문자 */
	    var isBeforeSpace = false;
	    for(var i=0;i < halfString.length;i++) {
	        var c = halfString.charCodeAt(i);
	        if(32 <= c && c <= 126) { /* 전각으로 변환될수 있는 문자의 범위 */
	            if(c == 32) { /* 스페이스인경우 ascii 코드 32 */
	                /* 아래와 같이 변환시 깨짐. */
	                /* x_2byteString = x_2byteString + unescape("%uFFFC"); */
	                if(isBeforeSpace) { /*스페이스가 연속으로 2개 들어왔을경우 스페이스 하나로 처리하기 위함..*/
	                    x_2byteString = x_2byteString + "";
	                    isBeforeSpace = false;
	                } else {
	                    x_2byteString = x_2byteString + unescape("%u"+this.decToHex(12288));
	                    isBeforeSpace = true;
	                }
	            } else {
	                x_2byteString = x_2byteString + unescape("%u"+this.decToHex(c+65248));
	                isBeforeSpace = false;
	            }
	        }else{
	            x_2byteString = x_2byteString + halfString.charAt(i);
	            isBeforeSpace = false;
	        }
	    }
	    return  x_2byteString;
}; 

/**
 * 반각문자를 전각문자로 변환
 * @param x_char : 반각문자
 * @retrun x_2byteChar : 전각문자
 */
_comStringUtil.prototype.convert2ByteChar = function(x_char){
	var x_2byteChar = ""; /* 컨버트된 문자 */
	    var c = x_char.charCodeAt(0);
	    if(32 <= c && c <= 126) { /* 전각으로 변환될수 있는 문자의 범위 */
	        if(c == 32) { /* 스페이스인경우 ascii 코드 32 */
	            /* 아래와 같이 변환시 깨짐. */
	            /* x_2byteChar = unescape("%uFFFC"); */
	            x_2byteChar = unescape("%u"+this.decToHex(12288));
	        } else {
	            x_2byteChar = unescape("%u"+this.decToHex(c+65248));
	        }
	    }
	    return  x_2byteChar;
};

/**
 * 변수가 undefined 일 경우 대체
 * @param v : 원본값
 * @param r : 대체값
 * @example : ComStringUtil.null2void($("#aaa").val(), "");
 */
_comStringUtil.prototype.null2void = function(v, r){
    if(v == undefined || v == "undefined") {
        if(r == undefined || r == "undefined") {
            v = "";
        } else {
            v = r;
        }
    }   

    return v;
};
/**
 * 문자열 좌우 공백제거
 * @param str : 대상 데이터
 * @returns : 공백 제거된 데이터
 * @example : ComStringUtil.trim(str)
 */
_comStringUtil.prototype.trim = function(str){
    if(typeof str == "boolean") {
        return str;
    } else {
        if(null2void(str) == "") {
            return str;
        } else {
            return str.replace(/(^\s*)|(\s*$)/g, "");        
        }       
    }
};
/**
 * 문자열 컴마와 점 제거
 * @param val : 대상 데이터
 * @returns : 문자열 컴마와 점 제거된 데이터
 * @example : ComStringUtil.onlyMoney(val)
 */
_comStringUtil.prototype.orgMoney = function(val){
	var rtndata = val;

	if(rtndata != null && rtndata != undefined && rtndata != "") {
		if(typeof rtndata == "number") {
			rtndata = String(rtndata);
		}
		
		rtndata = rtndata.replaceAll(",", "").replaceAll(".", "");
		rtndata = Number(rtndata);
	}

	return rtndata;
};
_comStringUtil.prototype.decToHex = function(dec){
	return dec.toString(16);
};

var ComStringUtil = _comStringUtil.getInstance();