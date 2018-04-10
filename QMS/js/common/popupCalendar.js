 /*
 - 팝업창에서 카렌다를 쓸 경우 이용되는 javascript이다.
 - 변형없이 그대로 이용한다.
 - 사용례 http://localhost:7001/ngmWeb/pageflows/sample/calendar_popup/Calendar_popupController.jpf
 */

 var target;                        // 호출한 Object의 저장
 //var stime;
 document.write("<div id=minical oncontextmenu='return false' ondragstart='return false' onselectstart='return false' style=\"background:buttonface; margin:0; padding:0;margin-top:0;border-top:1 solid buttonshadow;border-left: 1 solid buttonshadow;border-right: 1 solid buttonshadow;border-bottom:1 solid buttonshadow;width:160;display:none;position: absolute; z-index: 99\"></div>");

 /**
  * 달력 띄우기
  * <br> ex : sp_calendar('aform.cal1')
  * @param : 리턴값이 들어갈 input의 name
  */
 function openCalendar(name)
 {
 	var targetDate = eval(name);
 	var tDateValue = getOnlyNumberFormat(targetDate.value);

 	if(tDateValue.length == 0 ) {
 		Calendar(targetDate);
 	} else if(validateDate8(tDateValue))
 	{
 		Calendar(targetDate);
 	} else {
 		targetDate.select();
 	}
 } 
 
function Calendar(obj) {            // jucke
	 var now = obj.value.split("-");
	 var x, y;
	 
	 target = obj;                      // Object 저장;
	 x = (document.layers) ? loc.pageX : event.clientX;
	 y = (document.layers) ? loc.pageY : event.clientY;
	
	 minical.style.pixelTop = y+5;
	 minical.style.pixelLeft = x-50;
	  
	 
	 if(minical.style.display == "block") { minical.style.display ="none";closeShim(minical); }else{ minical.style.display ="block";openShim(minical,null);}
	
	 if (now.length == 3) {             // 정확한지 검사
	  Show_cal(now[0],now[1],now[2]);   // 넘어온 값을 년월일로 분리
	 } else {
	  now = new Date();
	  Show_cal(now.getFullYear(), now.getMonth()+1, now.getDate());   // 현재 년/월/일을 설정하여 넘김.
	 }
	 
	  openShim(minical,null);
	  
	  Calendar.addEvent(document, "mousedown", closeCal);
	}
	
	Calendar.is_ie = ( (navigator.userAgent.toLowerCase().indexOf("msie") != -1) &&
			   (navigator.userAgent.toLowerCase().indexOf("opera") == -1) );
	
	Calendar.addEvent = function(el, evname, func) {
		if (Calendar.is_ie) {
			el.attachEvent("on" + evname, func);
		} else {
			el.addEventListener(evname, func, true);
		}
};

Calendar.removeEvent = function(el, evname, func) {
	if (Calendar.is_ie) {
		el.detachEvent("on" + evname, func);
	} else {
		el.removeEventListener(evname, func, true);
	}
};

Calendar.getElement = function(ev) {
	if (Calendar.is_ie) {
		return window.event.srcElement;
	} else {
		return ev.currentTarget;
	}
};

Calendar.getTargetElement = function(ev) {
	if (Calendar.is_ie) {
		return window.event.srcElement;
	} else {
		return ev.target;
	}
};

function closeCal(ev)
{
  var el = Calendar.is_ie ? Calendar.getElement(ev) : Calendar.getTargetElement(ev);
  for (; el != null; el = el.parentNode) {
    if (el.id == "minical") break;
  }
  if (el == null) {
    minical.style.display ="none";closeShim(minical);
    Calendar.removeEvent(document, "mousedown", closeCal);
  }
}
 
function doOver() {                 // 마우스가 칼렌다위에 있으면
 var el = window.event.srcElement;
 cal_Day = el.title;

 if (cal_Day.length > 7) {          // 날자 값이 있으면.
  el.style.borderTopColor = el.style.borderLeftColor = "buttonhighlight";
  el.style.borderRightColor = el.style.borderBottomColor = "buttonshadow";
 }
 //window.clearTimeout(stime);      // Clear
}

function doClick() {                // 날자를 선택하였을 경우
 cal_Day = window.event.srcElement.title;
 window.event.srcElement.style.borderColor = "red";       // 테두리 색을 빨간색으로

 if (cal_Day.length > 7) {          // 날자 값이있으면
  target.value=cal_Day              // 값 설정
 }
 minical.style.display='none';      // 화면에서 지움
 closeShim(minical);
}

function doOut() {
 var el = window.event.fromElement;
 cal_Day = el.title;

 if (cal_Day.length > 7) {
  el.style.borderColor = "white";
  
 }
 
 
 //stime=window.setTimeout("minical.style.display='none';", 200);
}

function day2(d) {                  // 2자리 숫자료 변경
 var str = new String();
 
 if (parseInt(d) < 10) {
  str = "0" + parseInt(d);
 } else {
  str = "" + parseInt(d);
 }
 return str;
}

function Show_cal(sYear, sMonth, sDay) {
 var Months_day = new Array(0,31,28,31,30,31,30,31,31,30,31,30,31)
 var Weekday_name = new Array("Sun", "Mon", "Tue", "Wed", "Thur", "Fri", "Sat");
 var intThisYear = new Number(), intThisMonth = new Number(), intThisDay = new Number();
 document.all.minical.innerHTML = "";
 datToday = new Date();             // 현재 날자 설정
 
 intThisYear = parseInt(sYear);
 intThisMonth = parseInt(sMonth);
 intThisDay = parseInt(sDay);
 
 if (intThisYear == 0) intThisYear = datToday.getFullYear();    // 값이 없을 경우
 if (intThisMonth == 0) intThisMonth = parseInt(datToday.getMonth())+1; // 월 값은 실제값 보다 -1 한 값이 돼돌려 진다.
 if (intThisDay == 0) intThisDay = datToday.getDate();
 
 switch(intThisMonth) {
  case 1:
    intPrevYear = intThisYear -1;
    intPrevMonth = 12;
    intNextYear = intThisYear;
    intNextMonth = 2;
    break;
  case 12:
    intPrevYear = intThisYear;
    intPrevMonth = 11;
    intNextYear = intThisYear + 1;
    intNextMonth = 1;
    break;
  default:
    intPrevYear = intThisYear;
    intPrevMonth = parseInt(intThisMonth) - 1;
    intNextYear = intThisYear;
    intNextMonth = parseInt(intThisMonth) + 1;
    break;
 }

 NowThisYear = datToday.getFullYear();          // 현재 년
 NowThisMonth = datToday.getMonth()+1;          // 현재 월
 NowThisDay = datToday.getDate();               // 현재 일
 
 datFirstDay = new Date(intThisYear, intThisMonth-1, 1);      // 현재 달의 1일로 날자 객체 생성(월은 0부터 11까지의 정수(1월부터 12월))
 intFirstWeekday = datFirstDay.getDay();        // 현재 달 1일의 요일을 구함 (0:일요일, 1:월요일)
 
 intSecondWeekday = intFirstWeekday;
 intThirdWeekday = intFirstWeekday;
 
 datThisDay = new Date(intThisYear, intThisMonth, intThisDay);    // 넘어온 값의 날자 생성
 intThisWeekday = datThisDay.getDay();              // 넘어온 날자의 주 요일

 varThisWeekday = Weekday_name[intThisWeekday];     // 현재 요일 저장
 
 intPrintDay = 1                // 달의 시작 일자
 secondPrintDay = 1
 thirdPrintDay = 1
 
 Stop_Flag = 0
 
 if ((intThisYear % 4)==0) {             // 4년마다 1번이면 (사로나누어 떨어지면)
  if ((intThisYear % 100) == 0) {
   if ((intThisYear % 400) == 0) {
    Months_day[2] = 29;
   }
  } else {
   Months_day[2] = 29;
  }
 }
 intLastDay = Months_day[intThisMonth];          // 마지막 일자 구함
 Stop_flag = 0
 
 Cal_HTML = "<TABLE WIDTH=100% BORDER=0 CELLPADDING=0 CELLSPACING=0 ONMOUSEOVER=doOver(); ONMOUSEOUT=doOut(); STYLE='font-size:8pt;font-family:Tahoma;'>"
   + "<TR ALIGN=CENTER height='25' valign='center'><TD COLSPAN=7 nowrap=nowrap ALIGN=CENTER><SPAN TITLE='이전달' STYLE=cursor:hand; onClick='Show_cal("+intPrevYear+","+intPrevMonth+",1);'><!--img src='/ngmWeb/images/ukey/popup/icon_calerro01.gif' border='0' align='absmiddle'-->◀</SPAN> "
   + get_Yearinfo(intThisYear,intThisMonth,intThisDay)+"&nbsp;&nbsp;"+get_Monthinfo(intThisYear,intThisMonth,intThisDay)+"&nbsp;<SPAN TITLE='다음달' STYLE=cursor:hand; onClick='Show_cal("+intNextYear+","+intNextMonth+",1);'><!--img src='/ngmWeb/images/ukey/popup/icon_calerro02.gif' border='0' align='absmiddle'-->▶</SPAN></TD></TR>"
   + "<TR ALIGN=CENTER  BGCOLOR=WHITE height='25' ><TD>일</TD><TD>월</TD><TD>화</TD><TD>수</TD><TD>목</TD><TD>금</TD><TD>토</TD></TR>";
   
 for (intLoopWeek=1; intLoopWeek < 7; intLoopWeek++) {      // 주단위 루프 시작, 최대 6주
  Cal_HTML += "<TR ALIGN=CENTER BGCOLOR=WHITE>"
  for (intLoopDay=1; intLoopDay <= 7; intLoopDay++) {       // 요일단위 루프 시작, 일요일 부터
   if (intThirdWeekday > 0) {           // 첫주 시작일이 1보다 크면
    Cal_HTML += "<TD onClick=doClick();>";
    intThirdWeekday--;
   } else {
    if (thirdPrintDay > intLastDay) {        // 입력 날짝 월말보다 크다면
     Cal_HTML += "<TD onClick=doClick();>";
    } else {              // 입력날짜가 현재월에 해당 되면
     Cal_HTML += "<TD onClick=doClick(); title="+intThisYear+"-"+day2(intThisMonth).toString()+"-"+day2(thirdPrintDay).toString()+" STYLE=\"cursor:Hand;border:1px solid white;";
     if (intThisYear == NowThisYear && intThisMonth==NowThisMonth && thirdPrintDay==intThisDay) {
      Cal_HTML += "background-color:#DCE4DE;";
     }
     
     switch(intLoopDay) {
      case 1:             // 일요일이면 빨간 색으로
       Cal_HTML += "color:red;"
       break;
      case 7:
       Cal_HTML += "color:blue;"
       break;
      default:
       Cal_HTML += "color:black;"
       break;
     }
     
     Cal_HTML += "\">"+thirdPrintDay;
     
    }
    thirdPrintDay++;
    
    if (thirdPrintDay > intLastDay) {        // 만약 날짜 값이 월말 값보다 크면 루프문 탈출
     Stop_Flag = 1;
    }
   }
   Cal_HTML += "</TD>";
  }
  Cal_HTML += "</TR>";
  if (Stop_Flag==1) break;
 }
 Cal_HTML += "</TABLE>";

 document.all.minical.innerHTML = Cal_HTML;

}

function get_Yearinfo(year,month,day) {           // 년 정보를 콤보 박스로 표시
 var min = parseInt(year) - 100;
 var max = parseInt(year) + 10;
 var i = new Number();
 var str = new String();
 
 str = "<SELECT onChange='Show_cal(this.value,"+month+","+day+");' ONMOUSEOVER=doOver(); style='font-size:8pt'>";
 for (i=min; i<=max; i++) {
  if (i == parseInt(year)) {
   str += "<OPTION VALUE="+i+" selected ONMOUSEOVER=doOver();>"+i+"</OPTION>";
  } else {
   str += "<OPTION VALUE="+i+" ONMOUSEOVER=doOver();>"+i+"</OPTION>";
  }
 }
 str += "</SELECT>";
 return str;
}


function get_Monthinfo(year,month,day) {          // 월 정보를 콤보 박스로 표시
 var i = new Number();
 var str = new String();
 
 str = "<SELECT onChange='Show_cal("+year+",this.value,"+day+");' ONMOUSEOVER=doOver(); style='font-size:8pt'>";
 for (i=1; i<=12; i++) {
  if (i == parseInt(month)) {
   str += "<OPTION VALUE="+i+" selected ONMOUSEOVER=doOver();>"+i+"</OPTION>";
  } else {
   str += "<OPTION VALUE="+i+" ONMOUSEOVER=doOver();>"+i+"</OPTION>";
  }
 }
 str += "</SELECT>";
 return str;
}


// Object 우선순위 문제로 div 가려지는 현상 debug를 위한 추가 소스

function openShim(menu,menuItem)
{
    if (menu==null) return;
    var shim = getShim(menu);
    if (shim==null) shim = createMenuShim(menu,getShimId(menu));
    
    //Change menu zIndex so shim can work with it
    menu.style.zIndex = 100;
    
    var width = menu.offsetWidth;
    var height;
    
    var height = menu.offsetHeight;
    
    shim.style.width = width;
    shim.style.height = height;
    shim.style.top = menu.style.top;
    shim.style.left = menu.style.left;
    shim.style.zIndex = menu.style.zIndex - 1;
    shim.style.position = "absolute";
    shim.style.display = "block";
}

//Closes the shim associated with the menu
function closeShim(menu)
{
    if (menu==null) return;
    var shim = getShim(menu);
    if (shim!=null) shim.style.display = "none";
}

//Creates a new shim for the menu
function createMenuShim(menu)
{
    if (menu==null) return null;
    var shim = document.createElement('iframe');
    shim.scrolling = 'no';
    shim.frameborder = '0';
    
    shim.style = 'position:absolute; top:0px;left:0px; display:none';
    //shim.setAttributeNode("","");
    //shim.setAttributeNode("","");
   // var shim = document.createElement("<iframe scrolling='no' frameborder='0'"+
    //                                  "style='position:absolute; top:0px;"+
    //                                  "left:0px; display:none'></iframe>"); 
    
    
    shim.name = getShimId(menu);
    shim.id = getShimId(menu);
    //Unremark this line if you need your menus to be transparent for some reason
    //shim.style.filter="progid:DXImageTransform.Microsoft.Alpha(style=0,opacity=0)";

    if (menu.offsetParent==null || menu.offsetParent.id=="") 
    {
        window.document.body.appendChild(shim);
    }
    else 
    {
        menu.offsetParent.appendChild(shim); 
    }

    return shim;
}

//Creates an id for the shim based on the menu id
function getShimId(menu)
{
    if (menu.id==null) return "__shim";
    return "__shim"+menu.id;
}

//Returns the shim for a specific menu
function getShim(menu)
{
    return document.getElementById(getShimId(menu));
}

function getMenuItemCount(menu)
{
    var count = 0;
    var child = menu.firstChild;

    while (child)
    {
        if (child.nodeName=="DIV") count = count + 1;
        child = child.nextSibling;
    }
    return count;    
}

//달력
function Calendar(obj, xtarget) {            // jucke
	 var now = obj.value.split("-");
	 var x, y;
	 
	 target = obj;                      // Object 저장;
	 x = (document.layers) ? loc.pageX : event.clientX;
	 y = (document.layers) ? loc.pageY : event.clientY;
	 
	 var xData = 50;
	 
	 if(xtarget != undefined) {
	   xData = new Number(xtarget);
	 }
	
	 minical.style.pixelTop = y+5;
	 minical.style.pixelLeft = x - xData;
	 
	 if(minical.style.display == "block") { minical.style.display ="none";closeShim(minical); }else{ minical.style.display ="block";openShim(minical,null);}
	
	 if (now.length == 3) {             // 정확한지 검사
	  Show_cal(now[0],now[1],now[2]);   // 넘어온 값을 년월일로 분리
	 } else {
	  now = new Date();
	  Show_cal(now.getFullYear(), now.getMonth()+1, now.getDate());   // 현재 년/월/일을 설정하여 넘김.
	 }
	 
	  openShim(minical,null);
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


