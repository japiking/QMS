/**
 * 날짜 포맷팅
 * ex) yyyymmdd => yyyy-mm-dd
 *     20120801 => 2012-08-01
 */

var _formatter = function(){
	
	/**
	* 정규식 3자리마다 , 를 붙임
	* @param dat
	* @param [option] defData 값이없는 경우 처리할 default값 ex) 공백 or 숫자0 등등..
	* @param [option] addData 값에 추가하여 return 할 값 ex) "원"
	* @example mobFormatter.number(1000000);
	* 	 	   mobFormatter.number("1000000",{"defData":0});
	* 		   mobFormatter.number(1000000,{"defData":0,"addData":"원"});
	*/
	var _this = this;
	
	this.number = function(dat, args) {
		
		var defData = args?args['defData']:undefined;
		var addData = args?args['addData']:undefined;
		
		if( ComUtil.isNull(dat) || "" == dat){
			if(ComUtil.isNull(defData)){
				return "";
			}else{
				if(ComUtil.isNull(addData)){
					return defData;
				}else{
					return defData+addData;
				}
			}
		}
		
		if(typeof dat == "string"){ 
			dat = dat.replace(/[^0-9.-]/g,"");
			if(0 == dat.indexOf("-")){
				dat = dat.replace(/[-]/g,"");
				dat = "-"+dat;
			}else{
				dat = dat.replace(/[-]/g,"");
			}
			dat = String(Number(dat));
		}else if(typeof dat == "number"){
			dat = String(dat);
		}
		
		var reg = /(^[+-]?\d+)(\d{3})/;    				// 정규식(3자리마다 ,를 붙임)
		dat += ''; 										// ,를 찍기 위해 숫자를 문자열로 변환
		while (reg.test(dat)) 							// dat값의 첫째자리부터 마지막자리까지
			dat = dat.replace(reg, '$1' + ',' + '$2');	// 인자로 받은 dat 값을 ,가 찍힌 값으로 변환시킴
		
		if(!ComUtil.isNull(addData)){
			return dat + addData;
		}
		return dat; 									// 바뀐 dat 값을 반환.
	};
	
	/**
	* 정규식 3자리마다 , 를 붙임 - 값이 없는 경우 " " 공백을 return
	* @param dat
	* @param [option] defData 값이없는 경우 처리할 default값 ex) 공백 or 숫자0 등등..
	* @param [option] addData 값에 추가하여 return 할 값 ex) "원"
	* @example mobFormatter.number(1000000);
	* 	 	   mobFormatter.number("1000000",{"defData":0});
	* 		   mobFormatter.number(1000000,{"defData":0,"addData":"원"});
	*/
	this.numberSpace = function(dat) {
		return _this.number(dat,{"defData":" "}); 
	};
	
	/**
	 * 날짜 포멧팅
	 * @param dat
	 * @example mobFormatter.date(20040101);  =>2004-01-01
	 * 
	 */
	this.date = function(dat) {
		if(ComUtil.isNull(dat)) return "";
		if(dat.length != 8) return dat;
		dat = dat.substring(0,4)+"-"+dat.substring(4,6)+"-"+dat.substring(6,8);
		return dat;
	};
	/**
	 * 시간 포맷팅
	 * @param dat
	 * @param opt 옵션
	 * @example 	mobFormatter.time(123035)  => 12:30:35
	 * 				mobFormatter.time(093035,{"ampm":true}) => 오전 09:30:35
	 * 				hhmmdd => hh:mm:dd
	 *     			123035 => 12:30:35, 1230 => 12:30
	 */
	this.time = function(dat, opt) {
		var ampm = opt?opt['ampm']:undefined;
		
		if(ComUtil.isNull(dat)) return "";
		dat = dat.replace(/[^0-9]/g, "");
		if(dat.length == 6 || dat.length == 9){	
			dat = dat.substring(0,2)+":"+dat.substring(2,4)+":"+dat.substring(4,6);
		}else if(dat.length == 4){
			dat = dat.substring(0, 2)+":"+dat.substring(2, 4);
		}
		
		if(ampm){
			if(12 > parseInt(dat.substring(0, 2))){
				dat = "오전 "+ dat; 	//오전
			}else{
				dat = "오후 "+ dat;	//오후
			}
		}
		
		return dat;
	};
	/**
	 * 날짜+시간 포맷팅
	 * @param date
	 * @param opt 옵션
	 * @example mobFormatter.dateTime("20120114153100",{"format":"yyyy-mm-dd hh24:mi:ss"}) =>  2012-01-14 15:31:00
	 */
	
	this.dateTime = function(date, opt) {
		var format = opt?opt['format']:undefined;
		
		if(!format){
			alert("날짜 포맷을 입력해주세요");	//날짜 포맷을 입력해주세요
			return false;
		}
		
		if(!date)	return "";
	
		//이미 포맷팅 되어있는값을 삭제한다.
		date = date.replace(/[^0-9]/g,"");
		
		//입력된 날짜의 길이가 포맷팅되어야 하는 길이보다 작으면 뒤에 0을 붙인다.
		var formatLength = format.replace(/[^a-z]/g, "").length;
		var dateLength = date.length;
		for(var i=0 ; i<formatLength-dateLength ; i++){
			date += '0';
		}
		
		if(format.replace(/[^a-z]/g, "")=="hhmiss" && date.length==6)
		{
			date = "00000000"+date;
		}
		
		var idx = format.indexOf("yyyy");
		if( idx > -1 ){
			format = format.replace("yyyy", date.substring(0,4));
		}
		idx = format.indexOf("yy");
		if( idx > -1 ){
			format = format.replace("yy", date.substring(2,4));
		}
		idx = format.indexOf("mm");
		if( idx > -1 ){
			format = format.replace("mm", date.substring(4,6));
		}
		idx = format.indexOf("dd");
		if( idx > -1 ){
			format = format.replace("dd", date.substring(6,8));
		}
		idx = format.indexOf("hh24");
		if( idx > -1 ){
			format = format.replace("hh24", date.substring(8,10));
		}
		idx = format.indexOf("hh");
		if( idx > -1 ){
			var hours = date.substring(8,10);
			hours = parseInt(hours,10)<=12?hours:"0"+String(parseInt(hours,10)-12);
			format = format.replace("hh", hours);
		}
		idx = format.indexOf("mi");
		if( idx > -1 ){
			format = format.replace("mi", date.substring(10, 12));
		}
		idx = format.indexOf("ss");
		if( idx > -1 ){
			format = format.replace("ss", date.substring(12));
		}
		idx = format.indexOf("EEE");
		if( idx > -1 ){
			var weekstr='일월화수목금토'; // 요일 스트링
			
			var day = weekstr.substr(new Date(date.substring(0,4), new Number(date.substring(4,6))-1, date.substring(6,8)).getDay(), 1);
			format = format.replace("EEE", day);
		}
		return format;
	};
	
	/**
	 * 시간 포멧팅
	 * @param date
	 * @example mobFormatter.time2("013032")
	 */
	this.time2 = function(dat) { 
		if(ComUtil.isNull(dat)) return "";
		
		dat = dat.replace(/:/g, "");
		
		if(dat.length == 6) {
			var tmGb	= "오후";
			var temphh	= dat.substring(0,2);
			
			if(Number(temphh) < 12) {
				tmGb	= "오전";
			}else {
				if(temphh != "12") {
					temphh = (Number(temphh) - 12)+"";
					if(Number(temphh) < 10) {
						temphh = "0"+temphh;
					}
				}
			}
			dat = tmGb+" "+temphh+"시 "+dat.substring(2,4)+"분 "+dat.substring(4,6)+"초";
		}else {
			return dat;
		} 
		return dat;
	};
	/**
	 *  카드번호 마스크 포맷팅 - 가온데 8자리 '*' 처리
	 */
	this.cardMask = function(dat) {
		if(ComUtil.isNull(dat)) return "";
		if(dat.length != 16) return dat;
		
		dat = dat.substring(0,4)+"-"+"****"+"-"+"****"+"-"+dat.substring(12,16);
		return dat;
	};
	/**
	 * 카드번호 포맷팅
	 */
	this.card = function(dat) {
		if(ComUtil.isNull(dat)) return "";
		dat = $.trim(dat);
		if(dat.length != 16) return dat;
		
		dat = dat.substring(0,4)+"-"+dat.substring(4,8)+"-"+dat.substring(8,12)+"-"+dat.substring(12,16);
		return dat;
	};
	/** 
	 * 주민번호/사업자번호 뒷자리 * 처리한 포멧팅
	 */
	this.rrnBrnMask = function(dat) {
		if(ComUtil.isNull(dat)) return "";
		if(dat.length == 10) return dat = dat.substring(0,3)+"-"+dat.substring(3,5)+"-*****";
		if(dat.length == 13) return dat = dat.substring(0,6)+"-*******";
		if(dat == "0000000000") return "";
		
		return dat;
	};
	/** 
	 * 주민번호/사업자번호 포멧팅
	 */
	this.rrnBrn = function(dat) {
		dat = $.trim(dat);
		if(ComUtil.isNull(dat)) return "";
		if(dat.length == 10) return dat = dat.substring(0,3)+"-"+dat.substring(3,5)+"-"+dat.substring(5,10);
		if(dat.length == 13) return dat = dat.substring(0,6)+"-"+dat.substring(6,13);
		if(dat == "0000000000") return "";
		
		return dat;
	};
	
	/**
	 * 우편번호 포맷팅
	 */
	this.zipCode = function(dat) {
		if(ComUtil.isNull(dat)) return "";
		if(dat.length != 6) return dat;
		
		dat = dat.substring(0,3)+"-"+dat.substring(3,6);
		return dat;
	};
	/**
	 * 계좌번호 포맷팅
	 * 이미 포매팅 되어있을경우 제거후 다시 포맷팅함
	 * @param dat : 계좌번호
	 * @param opt : 옵션
	 * 				format : Array형식의 계좌번호 자리수를 입력한다. 해당 자리수별로 파싱해서 포맷팅함
	 * @example mobFormatter.account( "01234567890001" ) => 012-345678-90-001
	 * 			mobFormatter.account( "0123456789000100" ) => 012-345678-90-00100
	 * 			mobFormatter.account( "0123456789" ,  [3,3,4]) ==>결과 : "012-345-6789"
	 *		    mobFormatter.account( "01234567890" , [3,3,4]) ==>결과 : "012-345-6789-0"
     *		    mobFormatter.account( "0123456" , [3,3,4]) ==>결과 : "012-345-6"
	 */
	this.account = function(dat, opt) {
		var format = opt?opt['format']:undefined;
		
		if(!dat) return dat;

		dat = $.trim(dat);
		if(typeof dat == "number")	dat = String(dat);

		//이미 포매팅되어있을경우 제거한다.
		else if(/[^0-9]/g.test(dat))
		{
			dat = dat.replace(/[^0-9]/g, "");
		}
		
		//format가 없을때 기본포맷을 설정하고자 할 경우, 여기에서 format에 기본포맷을 할당하면됨
		//예)if(!format||!format.length) format=[3,3,4];
		//if(!format||!format.length) return dat;
		if(dat.length==13){
			format = 	[2,1,2,8];
		}else if(dat.length==14){
			format = 	[3,6,2,3];
		}else if(dat.length==15){
			format = 	[5,3,2,5];
		}else if(dat.length==16){
			format = [3,6,2,5];
		}else{
			return dat;
		}

		var rArr = [];
		var startIdx = 0;
		for(var i=0 ; i<format.length ; i++)
		{
			if( !!dat.substr(startIdx, format[i]) )
				rArr.push(dat.substr(startIdx, format[i]));

			startIdx += format[i];
		}
		if( !!dat.substr(startIdx) )
		{
			rArr.push( dat.substr(startIdx) );
		}

		var result = "";
		for(var i=0 ; i<rArr.length ; i++)
		{
			if(i==0)
				result = rArr[i];
			else
				result += "-"+rArr[i];
		}
		return result;
	};
	/**
	* 계좌번호 인덱싱 Mask(123-123456-12-***) (신용카드 결제계좌번호)
	*/
	this.accountMask = function(dat) {
		if(ComUtil.isNull(dat)) return "";
		dat = dat.replace(/-/g, "");
		dat = $.trim(dat);
		if(dat.length == 16) {		
			dat = dat.substring(0,3)+"-"+dat.substring(3,9)+"-"+ dat.substring(9,11)+"-*****";
		}
		else if(dat.length == 14) {		
			dat = dat.substring(0,3)+"-"+dat.substring(3,9)+"-"+ dat.substring(9,11)+"-***";
		}
		return dat;
	};
	/**
	* 계좌번호 인덱싱 (123-123456-**-123) (신용카드 결제계좌번호) 2012.12.17
	*/
	this.accountMaskMid = function(dat) {
		if(ComUtil.isNull(dat)) return "";		
		if(dat.length != 14) return dat;		
		dat = dat.substring(0,3)+"-"+dat.substring(3,9)+"-"+ "**" +"-"+dat.substring(11,14);
		return dat;
	};
	
	/**
	 * 전화번호 포맷팅
	 */
	this.phone = function(dat){
		if(!dat) return dat;

		if(typeof dat == "number"){
			dat = String(dat);
		}
		else if(/[^0-9]/g.test(dat)){
			dat = dat.replace(/[^0-9]/g, "");
		}
		dat = dat.replace(/(^02.{0}|^01.{1}|[0-9]{3})([0-9]+)([0-9]{4})/, "$1-$2-$3");
		return dat;
	};
	
	/**
	 * 전화번호 포맷팅
	 */
	this.phoneMask = function(dat){
		if(!dat) return dat;

		if(typeof dat == "number"){
			dat = String(dat);
		}
		else if(/[^0-9]/g.test(dat)){
			dat = dat.replace(/[^0-9]/g, "");
		}
		dat = dat.replace(/(^02.{0}|^01.{1}|[0-9]{3})([0-9]+)([0-9]{4})/, "$1-$2-****");
		return dat;
	};
	
	/**
	* 정규식 3자리마다 ,를 붙임
	* @param dat
	* @param opt 옵션
	*		 [option] decimal 소수점자릿수
	* 		 [option] decimalZero 지정한 소숫점자릿수보다 작을경우 소수점자리수만큼 0으로표시할지 여부 : true,false
	* 		 [option] addData return시 덧붙치고 싶은 문자열 ex) %
	* @example mobFormatter.decimal(1000000.123,{"decimal":2,"decimalZero":true});
	*/
	this.decimal = function(dat, args ) {

		var decimal = args?args['decimal']:undefined;
		var decimalZero = args?args['decimalZero']:undefined;
		var addData = args?args['addData']:undefined;
		var result = "";
		
		if(ComUtil.isNull(dat) || "" == dat) return "";
		
		if("number" == typeof(dat)){ 
			dat = String(dat);
		}else if("string" == typeof(dat)){ 
			if(-1 < dat.indexOf("-.")) dat.replace("-.","-0.");
			dat = dat.replace(/[^0-9.-]/g,"");
			// '-'가 중간에 들어가있는 경우 제거 
			if(0 == dat.indexOf("-")){
				dat = dat.replace(/[-]/g,"");
				dat = "-"+dat;
			}else{
				dat = dat.replace(/[-]/g,"");
			}
			
			//'.'이 여러개인경우 앞의 하나만 남기고 제거
			if(-1 != dat.indexOf(".")){
				var tmpNums = new Array();
				tmpNums[0] = dat.substring(0, dat.indexOf("."));
				tmpNums[1] = dat.substring(dat.indexOf("."));
				tmpNums[1] = tmpNums[1].replace(/[.]/g,"");
				dat = tmpNums[0]+"."+tmpNums[1];
			}
			
			dat = String(Number(dat));
		}
			
		if(dat.indexOf(',')>0) return dat;
		
		if(ComUtil.isNull(decimalZero)){
			decimalZero = false;
		}
		
		var nums = dat.split('.');
		/*if(typeof nums[0] == "string") nums[0] = String(Number(nums[0]));
		else if(typeof nums[0] == "number")	nums[0] = String(nums[0]);*/
		nums[0] += ''; 											// ,를 찍기 위해 숫자를 문자열로 변환
		
		var reg = /(^[+-]?\d+)(\d{3})/;    						// 정규식(3자리마다 ,를 붙임)
		while (reg.test(nums[0])) 								// nums[0]값의 첫째자리부터 마지막자리까지
			nums[0] = nums[0].replace(reg, '$1' + ',' + '$2');	// 인자로 받은 nums[0] 값을 ,가 찍힌 값으로 변환시킴
		
		if(null == nums[1]){									// 정수인경우
			if(decimalZero){
				var zero = "";
				for(var i=0; i < decimal; i++){
					zero +="0";
				}
				result = nums[0]+"."+zero;
			}else{
				result =  nums[0];
			}
		}else if(decimal > nums[1].length){						// 실수인데 지정한 소숫점자리보다 적은경우
			if(decimalZero){
				for(var i=nums[1].length; i < decimal; i++){	// 지정한 소숫점자릿수보다 작을 경우 나머지 소숫자릿 수만큼 '0'을 붙임
					nums[1] +="0";
				}
			}
			result = nums[0]+"."+nums[1];
		}else{													// 실수인경우
			result =  nums[0]+"."+nums[1].substring(0,decimal); 	// 바뀐 dat 값을 반환.
		}
		
		
		if(!ComUtil.isNull(addData)){
			return result+addData;
		}
		return result;
	};
	
	/**
	* 소수점 이하 제거 + 정규식 3자리마다 ,를 붙임
	*/
	this.decimalPoint0 = function(dat) {

		if(ComUtil.isNull(dat)) return "";
		if("number" == typeof(dat)) dat = String(dat);
		if(dat.indexOf(',')>0) return dat;
		var nums = dat.split('.');
		/*if(typeof nums[0] == "string") nums[0] = String(Number(nums[0]));
		else if(typeof nums[0] == "number")	nums[0] = String(nums[0]);*/
		
		var reg = /(^[+-]?\d+)(\d{3})/;    						// 정규식(3자리마다 ,를 붙임)
		nums[0] += ''; 											// ,를 찍기 위해 숫자를 문자열로 변환
		while (reg.test(nums[0])) 								// nums[0]값의 첫째자리부터 마지막자리까지
			nums[0] = nums[0].replace(reg, '$1' + ',' + '$2');	// 인자로 받은 nums[0] 값을 ,가 찍힌 값으로 변환시킴
		
		return nums[0]; 				// 바뀐 dat 값을 반환.
	},
	
	/**
	* 소수점 2자리 표시 + 정규식 3자리마다 ,를 붙임
	*/
	this.decimalPoint2 = function(dat) {

		if(ComUtil.isNull(dat)) return "";
		if("number" == typeof(dat)){
			dat = String(dat);
		}
		if(dat.indexOf(',')>0) return dat;
		var sign = (dat.substring(0,1)=="-")?"-":"";
		dat = dat.replace(/-/g, "");
		var nums = dat.split('.');
		if (nums[0] == null || nums[0] == undefined) nums[0] = "0";
		if(typeof nums[0] == "string") nums[0] = String(Number(nums[0]));
		else if(typeof nums[0] == "number")	nums[0] = String(nums[0]);
		if (Number(nums[0]) < 0) {
			sign = "";
		}
		
		var reg = /(^[+-]?\d+)(\d{3})/;    									// 정규식(3자리마다 ,를 붙임)
		nums[0] += ''; 														// ,를 찍기 위해 숫자를 문자열로 변환
		while (reg.test(nums[0])) 											// nums[0]값의 첫째자리부터 마지막자리까지
			nums[0] = nums[0].replace(reg, '$1' + ',' + '$2');				// 인자로 받은 nums[0] 값을 ,가 찍힌 값으로 변환시킴
		if(nums[1]==null) return sign + nums[0]+"."+"00";					// 소수점이 없을경우 강제로 '0'을 붙임
			else return sign + nums[0]+"."+nums[1].substring(0,2); 			// 바뀐 dat 값을 반환.
	}
	
	/**
	* 실수형 formatter
	* @param dat
	* @param opt 옵션
	*		 [option] decimal 소수점자릿수
	* 		 [option] decimalZero 지정한 소숫점자릿수보다 작을경우 소수점자리수만큼 0으로표시할지 여부 : true,false
	* 		 [option] addData return시 덧붙치고 싶은 문자열 ex) %
	* @example mobFormatter.decimal(1000000.123,{"decimal":2,"decimalZero":true});
	*/
	this.float = function(dat, args ) {
		var decimal = args?args['decimal']:undefined;
		var decimalZero = args?args['decimalZero']:undefined;
		var addData = args?args['addData']:undefined;
		var result = "";
		
		if(ComUtil.isNull(dat) || "" == dat) return "";
		
		if("number" == typeof(dat)){ 
			dat = String(dat);
		}else if("string" == typeof(dat)){ 
			if(-1 < dat.indexOf("-.")) dat.replace("-.","-0.");
			dat = dat.replace(/[^0-9.-]/g,"");
			// '-'가 중간에 들어가있는 경우 제거 
			if(0 == dat.indexOf("-")){
				dat = dat.replace(/[-]/g,"");
				dat = "-"+dat;
			}else{
				dat = dat.replace(/[-]/g,"");
			}
			
			//'.'이 여러개인경우 앞의 하나만 남기고 제거
			if(-1 != dat.indexOf(".")){
				var tmpNums = new Array();
				tmpNums[0] = dat.substring(0, dat.indexOf("."));
				tmpNums[1] = dat.substring(dat.indexOf("."));
				tmpNums[1] = tmpNums[1].replace(/[.]/g,"");
				dat = tmpNums[0]+"."+tmpNums[1];
			}
			
			dat = String(Number(dat));
		}
			
		if(dat.indexOf(',')>0) return dat;
		
		if(ComUtil.isNull(decimalZero)){
			decimalZero = false;
		}
		
		var nums = dat.split('.');
		/*if(typeof nums[0] == "string") nums[0] = String(Number(nums[0]));
		else if(typeof nums[0] == "number")	nums[0] = String(nums[0]);*/
		nums[0] += ''; 											// ,를 찍기 위해 숫자를 문자열로 변환
		
		if(null == nums[1]){									// 정수인경우
			if(decimalZero){
				var zero = "";
				for(var i=0; i < decimal; i++){
					zero +="0";
				}
				result = nums[0]+"."+zero;
			}else{
				result =  nums[0];
			}
		}else if(decimal > nums[1].length){						// 실수인데 지정한 소숫점자리보다 적은경우
			if(decimalZero){
				for(var i=nums[1].length; i < decimal; i++){	// 지정한 소숫점자릿수보다 작을 경우 나머지 소숫자릿 수만큼 '0'을 붙임
					nums[1] +="0";
				}
			}
			result = nums[0]+"."+nums[1];
		}else{													// 실수인경우
			result =  nums[0]+"."+nums[1].substring(0,decimal); 	// 바뀐 dat 값을 반환.
		}
		
		
		if(!ComUtil.isNull(addData)){
			return result+addData;
		}
		return result;
	};
	
	/**
	 * 숫자형 - 숫자외의 값은 모두 제거
	 */
	this.getOnlyNum = function(val){
		
		if(ComUtil.isNull(val)) return "";
		if("number" == typeof(val)) val = String(val);
	
		val = val.replace(/[^0-9]/g, "");
		
		return val;
	};
};	

var ComFormatter = new _formatter();
