var _comDateUtil = function(){
};
_comDateUtil.instance = new _comDateUtil();
_comDateUtil.getInstance = function() {
	return _comDateUtil.instance;
};

/**
 * 오늘로 부터 입력된 년월일을 계산하여 "yyyymmdd"로 리턴
 * 
 * @param Number :년
 * @param Number :월
 * @param Number :일
 * @param setday :기준년월일
 * @returns : yyyymmdd
 * @example : ComDateUtil.getBoundDate( 1, 0, 0); // 1년후
 * @example : ComDateUtil.getBoundDate(-1, 0, 0); // 1년전
 * @example : ComDateUtil.getBoundDate( 0, 1, 0); // 1달후
 * @example : ComDateUtil.getBoundDate( 0, -1, 0); // 1달전
 * @example : ComDateUtil.getBoundDate( 0, 0, 1); // 1일후
 * @example : ComDateUtil.getBoundDate( 0, 0, -1,); // 1일전
 */
_comDateUtil.prototype.getBoundDate = function(yy, mm, dd, setday){
	
	var today = this.getTodayTime("yyyymmdd");	//TODO 서버에서 오늘날짜 가져오기
	
	if(setday!=null && setday!=undefined && setday!=""){
		today = setday;
	}
	
    var date = new Date(today.substring(0,4),Number(today.substring(4,6))-1,today.substring(6,8));
    
    t_yy = ComStringUtil.lPad(new String(date.getFullYear()),4,'0');
    t_mm = ComStringUtil.lPad(new String(date.getMonth()+1),2,'0');
    t_dd = ComStringUtil.lPad(new String(date.getDate()),2,'0');

    yy = Number(yy);
    mm = Number(mm);
    dd = Number(dd);
    if ( yy != 0 ){
        from=date.getFullYear()+yy;
        date.setYear(from);

        /* 기존 소스는 일에 +1일 해주었음 */
        // from=date.getDate()+1;
        // date.setDate(from);
    }
    if ( mm != 0 ){
        var lastDate = "";
        var day = new Date(date.getFullYear(), date.getMonth(), date.getDate());
        for(var i=0; i<12; i++){
            day.setMonth(i, 1);// modified on 2009.10.26
            if(date.getMonth()==day.getMonth()){
                lastDate = this.getLastDay(day.getFullYear(), (day.getMonth() + 1), day.getDate());
            }
        }
        if(date.getDate() ==lastDate){
            t_yy = date.getFullYear();
            t_mm = (date.getMonth());
            t_dd = date.getDate();

            t_mm = t_mm+mm;

            if(t_mm>12){
                t_yy = t_yy+1;
                t_mm = t_mm-12;
            }else if(t_mm<0){
                t_yy = t_yy-1;
                t_mm = t_mm+12;
            }else{
                t_yy = t_yy;
            }
            var lastDate2 = "";

            var day2 = new Date(t_yy,t_mm, 1);
            for(var i=0; i<12; i++){
              day2.setMonth(i, 1);// modified on 2009.10.26
                if(i==(t_mm)){
                    lastDate2 = this.getLastDay(day2.getFullYear(), (day2.getMonth() + 1), day2.getDate());
                }
            }
            t_dd = lastDate2;
            date = new Date(t_yy, t_mm, lastDate2);

        }else{
            from=date.getMonth()+mm;
            date.setMonth(from);
        }
        /* 기존 소스는 일에 +1일 해주었음 */
        // from=date.getDate()+1;
        // date.setDate(from);
    }
    if ( dd != 0 ){
        from=date.getDate()+dd;
        date.setDate(from);
    }
    return ComStringUtil.lPad(new String(date.getFullYear()),4,'0') + ComStringUtil.lPad(new String(date.getMonth()+1),2,'0') + ComStringUtil.lPad(new String(date.getDate()),2,'0');
};



/**
 * 유효하는(존재하는) Date 인지 체크
 * @param strDate :검증할 string형식의 날짜(날짜형식"20090101") yyyymmdd
 * @returns : true, false
 * @example : if (!MobDate.isValidDate(strDate)) alert("올바른 날짜가 아닙니다.");
 */
	 
_comDateUtil.prototype.isValidDate = function (strDate){
	var year = "";
	var month = "";
	var day = "";
	if(strDate == "") return true;
	if(strDate.length == 8){
	    year  = strDate.substring(0,4);
	    month = strDate.substring(4,6);
	    day   = strDate.substring(6,8);
	    if (parseInt(year,10) >= 1900  && this.isValidMonth(month) && this.isValidDay(year,month,day) ) {
	        return true;
	    }
	}else if(strDate.length == 6){
		 year  = strDate.substring(0,4);
		 month = strDate.substring(4,6);
		 if (parseInt(year,10) >= 1900  && this.isValidMonth(month)) {
		        return true;
		 }
	}
  return false;
};

/**
 * 유효한(존재하는) 월(月)인지 체크
 * @param mm :검증할 월(형식"01" ~ "12")
 * @returns : true, false
 * @example : MobDate.isValidMonth(mm)
 */
	 
_comDateUtil.prototype.isValidMonth = function (mm){
    var m = parseInt(mm,10);
    return (m >= 1 && m <= 12);
};

/**
 * 유효한(존재하는) 일(日)인지 체크
 * 
 * @param yyyy :검증할 년(형식"2009")
 * @param mm :검증할 월(형식"01" ~ "12")
 * @param dd :검증할 일(형식"01" ~ "31")
 * @returns : true, false
 * @example : MobDate.isValidDay(yyyy, mm, dd)
 */
	 
_comDateUtil.prototype.isValidDay = function(yyyy, mm, dd){
	var m = parseInt(mm,10) - 1;
	var d = parseInt(dd,10);
	var end = new Array(31,28,31,30,31,30,31,31,30,31,30,31);
	if ((yyyy % 4 == 0 && yyyy % 100 != 0) || yyyy % 400 == 0) {
		end[1] = 29;
	}
	return (d >= 1 && d <= end[m]);
};

/**
 * 입력받은 날에 해당하는 달의 말일이 몇일인지 알려줌. 아래의 예제를 실행하면 1월이 31일까지 있기 때문에 31을 return
 * 
 * @param yy : 년
 * @param mm : 월
 * @param dd : 일
 * @returns : 해당월의 마지막 날짜
 * @example : MobDate.getLastDay("2012","01","27");
 */
_comDateUtil.prototype.getLastDay = function(yy,mm,dd){
	      var lastDay = new Date(yy,mm-1,dd);
	      lastDay.setMonth(lastDay.getMonth() + 1, 0);
	      return lastDay.getDate();
};

/**
 * 현재날짜를 가져옵니다.
 * @returns 현재날짜 ex)20130719
 */
_comDateUtil.prototype.getToday = function(){
	return this.getTodayTime("yyyymmdd");
};

/**
 * 현재시간을 가져옵니다.
 * @returns 현재시간 ex)131516
 */
_comDateUtil.prototype.getTime = function(){
	
	return this.getTodayTime("hh24miss");
};
/**
 * DateTime 스트링을 자바스크립트 Date 객체로 변환
 * @param strDateTime : 검증할 (형식"200102310000") yyyymmddhhmi
 * @returns : true, false
 * @example : if(!ComDateUtil.toDateObject(strDateTime)) alert("올바른 날짜/시간 형식이 아닙니다.")
 */
_comDateUtil.prototype.toDateObject = function(strDateTime){
	var year  = strDateTime.substring( 0,  4);
    var month = strDateTime.substring( 4,  6) - 1; // 1월=0,12월=11
    var day   = strDateTime.substring( 6,  8);
    var hour  = strDateTime.substring( 8, 10);
    var min   = strDateTime.substring(10, 12);

    return new Date(year, month, day, hour, min);
};
/**
 * 특정날짜의 요일을 구한다.
 * @param strDate : 요일을 구할 날짜(형식"20010231")
 * @returns : 요일명 (월,화,수,목,금,토)
 * @example : ComDateUtil.getDayOfWeek(strDate)
 */
_comDateUtil.prototype.getDayOfWeek = function(strDate){
	
	var now  = this.toDateObject(strDate);
    var day  = now.getDay(); // 일요일=0, 월요일=1, ..., 토요일=6
    var week = new Array("일", "월", "화", "수", "목", "금", "토");

    return week[day];
};
/**
 * 두 날짜사이의 일 수를 계산해 준다.
 * @param fromDay : 시작날짜 (형식"20010101")
 * @param toDay : 종료날(형식"20011231")
 * @returns : 날짜차이 수치
 * @example : ComDateUtil.numberOfDays(fromDay, toDay)
 */
_comDateUtil.prototype.numberOfDays = function(fromDay, toDay){
	var fromD = new Date(fromDay.substring(0,4),fromDay.substring(4,6)-1,fromDay.substring(6,8));
    var toD   = new Date(toDay.substring(0,4),toDay.substring(4,6)-1,toDay.substring(6,8));
    var totD  = toD.getTime() - fromD.getTime();
    totD = totD / 1000 / 60 / 60 / 24+1;

    return totD;
};
/**
 * 현재날짜시간을 지정한 format으로 가져옵니다.
 * @param format ex) yyyy-mm-dd hh24:mi:ss
 * @param isServer true/false (default:true)
 * @returns 현재날짜시간 ex)131516
 */
_comDateUtil.prototype.getTodayTime = function(format, isServer){
	
	var today 	= new Date();
	var year 	= today.getFullYear();
	var month 	= today.getMonth()+1;
	var day 	= today.getDate();
	var hour 	= today.getHours();		
	var minute 	= today.getMinutes();
	var second 	= today.getSeconds();
	
	var curDate = "";
	var result = "";
	
	if(ComUtil.isNull(isServer)){
		isServer = true;
	}
	
	//서버시간
	if(isServer){
		curDate = getServerTime();
	}
	else{
		if(month < 10) {month = "0"+month;}
		if(day < 10) {day = "0"+day;}
		if(hour < 10) {hour = "0"+hour;}
		if(minute < 10) {minute = "0"+minute;}
		if(second < 10) {second = "0"+second;}
		curDate = ""+year + month + day + hour + minute + second;
	}
	
	if(ComUtil.isNull(format)){
		result = curDate;
	}else{
		result = format;
		result = result.replace("yyyy",curDate.substring(0,4));
		result = result.replace("mm",curDate.substring(4,6));
		result = result.replace("dd",curDate.substring(6,8));
		result = result.replace("hh24",curDate.substring(8,10));
		result = result.replace("mi",curDate.substring(10,12));
		result = result.replace("ss",curDate.substring(12,14));
	}
	
	return result;
};


/**
 * 영업휴일이면 : true 반환
 * 필요한 String 인자값  : "" 혹은 20130321 를 인자로 넘김 (yyyymmdd 형태)
 * 
 * [예시]
 * comSpbsUtil.getIsHoliday();				오늘날짜
 * comSpbsUtil.getIsHoliday("");			오늘날짜
 * comSpbsUtil.getIsHoliday("20130321");	원하는 날짜
 */
_comDateUtil.prototype.getIsHoliday = function(date){
	var isHoliday = false;
	var strIsHoliday = "";
	try {
		var ajax = jex.createAjaxUtil("COMUTIL");	
	    ajax.setAsync(false);
        ajax.set("TASK_PACKAGE",        "com" );			//[필수]업무 package  
        ajax.set("FUNC_NAME",         	"isHoliday" );	//[필수]function name
        ajax.set("DATE",         		date!=undefined?date:"");
        strIsHoliday =  ajax.execute(function(dat) {})["_tran_res_data"][0]["isHoliday"];				//★★★★★★ KEY name : resultDat ★★★★★★
        if("true" == strIsHoliday){
        	isHoliday = true;
        }else{
        	isHoliday = false;
        }
        return isHoliday;
    } catch(e) {bizException(e, "ComDateUtil : getIsHoliday");}
};

var ComDateUtil = _comDateUtil.getInstance();

