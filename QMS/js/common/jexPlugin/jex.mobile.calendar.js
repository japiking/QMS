jQuery.fn.extend({
	jexCalendar: function(cmd, opt) {
		var $r = $(this);											
		var calendar_attr = {
			calendarId	 	: "data-jx-calendar"					// 그리드가 표시될 위치
			,target 		: "data-jx-calendar-target"				// 값이 들어갈 영역
			,completeMethod : "data-jx-calendar-method-complete"	// 앱의 완료버튼을 눌렀을 경우 호출해줄 함수이름 
			,format	 	 	: "data-jx-calendar-format"				// [option] 날짜 형식 (def:"yyyy-mm-dd MMM") ex) 2013-05-10 금요일
			,targetTime	 	: "data-jx-calendar-target-time"		// [option] 시간이 들어갈 영역
			,formatTime	 	: "data-jx-calendar-format-time"	    // [option] 시간 형식 (def:"apmhh12") ex)오전08
			,option		 	: "data-jx-calendar-option"				// [option] 달력 옵션
			//,defDate  	: "data-jx-calendar-target-defDate"		// default 날짜
			//,isShow    	: "data-jx-calendar-show"				// default show 영역
			//,afterFunc	: "data-jx-calendar-afterFunc"			// 날짜 선택시 function
		};
		
		var class_name = {
				today 			: "today"				//오늘
				,saturday   	: ""					//토요일
				,sunday			: "sun"					//일요일
				,holiday 		: "sun"					//휴일
				,term 			: "term"				//기간
				,preSunday  	: "off sun pre"			//전달 일요일
				,preMonth 		: "off pre"				//전달
				,nextSaturday 	: "off next"			//다음달 토요일
				,nextSunday		: "off next"			//다음달 일요일
				,nextMonth		: "off next"			//다음달
				,disableSunday  : "future sun"			//비활성화된 일요일
				,disableSaturday: "future"				//비활성화된 토요일
				,disableDay		: "future"				//비활성화된 평일		//disable
		};
		
		var baseDt = {
				year : 0000,
				mon : 1,
				dt : 1,
				week : 5
		}; // 기준일자 0000월 1월 1일은 토요일 이었음. (기준일을 변경하면 정상 작동하지 않을수 있음.--로직변경이 필요)
		
		var getMonLen = [ 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 ];
		var getWeek = [ "일", "월", "화", "수", "목", "금", "토" ];
		var getAvaliableTime = [8, 9, 10, 11, 12, 13, 14, 16, 19];
		var getCurAvaliableTime = [8, 9, 10, 11, 12, 13, 14, 16, 19];
		
		var jexCalFn={
			// 실행 전 데이터로드
			load : function(attr, $jq) {
				this.$calendarObj 	= $('[com-step-id="'+$r.attr(calendar_attr.calendarId)+'"]');
				this.calendarStep 	= $r.attr(calendar_attr.calendarId).replace("#","");
				this.option = this.parseOption($r.attr(calendar_attr.option));
				this.completeMethod = !$r.attr(calendar_attr.completeMethod)?"uf_calendar_complete":$r.attr(calendar_attr.completeMethod);
				
				//날짜
				//this.$targetObj   	= $($r.attr(calendar_attr.target));
				this.targetObjs   	= this.parseTargetObjList($r.attr(calendar_attr.target));

				var tagnm = $(this.targetObjs[0]).get(0).tagName;
				if(tagnm == "INPUT") this.target = $(this.targetObjs[0]).val();
				else if(tagnm == "TEXT") this.target = $(this.targetObjs[0]).text();
				else this.target = $(this.targetObjs[0]).html();
				
				this.format 	  	= !$r.attr(calendar_attr.format)?"yyyy-mm-dd":$r.attr(calendar_attr.format);
				this.curDate 	  	= this.getParseDate(this.target, this.format);
				this.curSelectedDate = this.getParseDate(this.target, this.format);
				this.fixDay			= this.curDate.day;
				
				//시간
				this.targetTimeObjs =  this.parseTargetObjList($r.attr(calendar_attr.targetTime));
				if("undefined" != typeof(this.targetTimeObjs[0])){
					this.targetTime 	= $(this.targetTimeObjs[0]).text(); 
					this.formatTime   	= !$r.attr(calendar_attr.formatTime)?"apmhh12":$r.attr(calendar_attr.formatTime);
					this.curTime	  	= this.getParseTime(this.targetTime, this.formatTime);
				}
				
				this.term = this.getTerm(this.option);
				this.calendarTag = this.getCalendarTag();
				
				//예약이체시간인경우 data setting
				if(this.option.checkTransferDate){
					this.setDateTimeTarget();
				}
				//	!$r.attr(calendar_attr.defDate)?MobCalendar.getToday():$jq.attr(calendar_attr.defDate);
				//this.draw(this.curDate);
				//this.execute();
			},
			// 달력실행
			execute : function(){
				this.option = this.parseOption($r.attr(calendar_attr.option));
				
				var tagnm = $(this.targetObjs[0]).get(0).tagName;
				if(tagnm == "INPUT") this.target = $(this.targetObjs[0]).val();
				else if(tagnm == "TEXT") this.target = $(this.targetObjs[0]).text();
				else this.target = $(this.targetObjs[0]).html();
				
				this.format 	  	= !$r.attr(calendar_attr.format)?"yyyy-mm-dd":$r.attr(calendar_attr.format);
				this.curDate 	  	= this.getParseDate(this.target, this.format);
				this.curSelectedDate = this.getParseDate(this.target, this.format);
				this.fixDay			= this.curDate.day;
				
				//시간
				this.targetTimeObjs =  this.parseTargetObjList($r.attr(calendar_attr.targetTime));
				if("undefined" != typeof(this.targetTimeObjs[0])){
					this.targetTime 	= $(this.targetTimeObjs[0]).text(); 
					this.formatTime   	= !$r.attr(calendar_attr.formatTime)?"apmhh12":$r.attr(calendar_attr.formatTime);
					this.curTime	  	= this.getParseTime(this.targetTime, this.formatTime);
				}
				
				this.term = this.getTerm(this.option);
				this.calendarTag = this.getCalendarTag();
				
				this.drawCalendar(this.curDate);
				this.show();
			},
			/* calendar를 보여줌 */
			show : function(){
				this.preStep = ComStep.curStep;
				ComStep.showStep(this.calendarStep);
			},
			/* calendar를 숨김 */
			hide : function(){
				ComStep.showStep(this.preStep);
			},
			/* 시간옵션 그려줌 */
			drawTime : function(curTime){
				var strTime = MobCalendar.getFormatTime(curTime, "apm:hh12");
				strTime = strTime.split(":");
				this.$calendarObj.find("#apm").text(strTime[0]);
				this.$calendarObj.find("#hour").text(strTime[1]);
			},
			drawCalendar : function(newCurDate){
				this.curDate = newCurDate;
				var _this = this;
				
				if(this.notCalendar()){
					this.$calendarObj.append(this.calendarTag);
					//this.$calendarObj.css("z-index","3000");
				}
				
				// 년도 와 월 셋팅.
				this.$calendarObj.find("#year").html(parseInt(this.curDate.year));
				this.$calendarObj.find("#mon").html(parseFloat(this.curDate.mon));
				
				this.$calendarObj.find("table").find("tbody").find("tr").remove();
				
				var fDt = this.getFirstDay({
					year: this.curDate.year,
					mon : this.curDate.mon
				});
				
				var eDt = this.getMonEndDate({
					year : this.curDate.year,
					mon : this.curDate.mon
				});
	
				var preEDt = this.getMonEndDate(MobCalendar.getPreMonth(this.curDate));	//전달 종료일
				var preSDt = preEDt - (fDt - 1);									//전달 시작일
				var nextSDt = 1;													//다음달 시작일
				
				var tr = $("<tr></tr>");
				var dd = 0; // 일자를 보관
				var cw = 0; // 요일을 보관
	
				var cs = 5 * 7; // 1달이 5주
				if (fDt + eDt > cs)
					cs = 6 * 7; // 1달이 6주
				
				var tmpFixDay = -1;
				if(this.option.fixDay){
					tmpFixDay = this.getCalculatorFixDay(this.curDate,this.fixDay);					//고정일
					this.curDate.day = tmpFixDay;
				}
				var compareDate = {};
				compareDate.year = this.curDate.year;
				compareDate.mon = this.curDate.mon;
				compareDate.day = this.curDate.day;
				var strCompareDate = undefined;														//그려지고있는 년월일
				var strToday =  MobCalendar.getFormatDate(MobCalendar.getToday(),"yyyymmdd");		//오늘날짜
				var strSelectedDate = MobCalendar.getFormatDate(this.curSelectedDate, "yyyymmdd");	//최종선택되었던 날짜
				var curTime = MobCalendar.getTime();
				
				for ( var i = 0; i < cs; i++) {
					var td = $("<td></td>");
					if (i >= fDt){
						dd++;
					}
					//그려지고 있는 달력의 년월일
					compareDate.day = dd;
					strCompareDate = MobCalendar.getFormatDate(compareDate,"yyyymmdd");
					
					if (cw == 0 || cw == 6){
						//모든날짜 비활성화 시키도록 한경우 or 주말 비활성화하도록 옵션처리한 경우 or 비활성화기간옵션을 지정한경우에만 비활성화 or 년월이 변경되어도 일자는 변경되지 않아야 하는경우
						if(this.option.disableAll || this.option.disableHoliday || 
								strCompareDate < this.option.availableDateStart || strCompareDate > this.option.availableDateEnd ||
								(this.option.fixDay && tmpFixDay != compareDate.day)
						){
							switch(cw){
							case 0:td.attr("class", class_name.disableSunday);break;
							case 6:td.attr("class", class_name.disableSaturday);break;
							}
						}else{
							if(cw ==0) td.attr("class", class_name.sunday);
							else if(cw ==6) td.attr("class", class_name.saturday);
						}
						td.html('<em class="blind">휴일</em>');
					}
					if (dd <= 0 ){
						td.attr("class", class_name.preMonth);
						td.html('<em class="blind">이전달</em>'+ preSDt++);
					}
					if(dd > eDt){
						
						td.attr("class", class_name.nextMonth);
						
						td.html('<em class="blind">다음달</em>'+ nextSDt++);
					}
					if ( strSelectedDate == strCompareDate){ //this.curDate.day == dd ||
						td.attr("class", class_name.today);
						td.html('<em class="blind">오늘</em>');
					}
					if (dd > 0 && dd <= eDt){
						//모두 비활성화 처리한경우 비활성화기간 선택되어있는 경우 또는 오늘 예약이체가능한 시간이 없을 경우
						//년월이 변경되어도 일자는 변경되지 않아야 하는경우
						if(this.option.disableAll || strCompareDate < this.option.availableDateStart || strCompareDate > this.option.availableDateEnd
								|| (this.option.checkTransferDate && strCompareDate == strToday && 18 < (curTime.hour+1) )
								|| (this.option.fixDay && tmpFixDay != compareDate.day)){
							td.addClass(class_name.disableDay);
						}
						//시작일, 종료일이 함께 사용하는 달력만 기간 표시
						if("undefined" != typeof(this.option.type)){
							if(strCompareDate >= this.term.start && strCompareDate <= this.term.end ){
								td.addClass(class_name.term);
							}
							//td.html(td.html()+dd+"<span></span>");
							td.html(td.html()+dd+"<span></span>");
						}else{
							td.html(td.html()+dd);
						}
					}
					tr.append(td);
					if (cw == 6) {
						tr.clone(true).appendTo(this.$calendarObj.find("table").find("tbody"));
						tr = $("<tr></tr>");
						cw = 0;
						continue;
					}
					cw++;
				}
				
				/* 이전달 토요일, 다음달 토요일,일요일 css 처리 */
				var preFirstSunObj  = this.$calendarObj.find("table tbody").find("td:first");
				var nextLastSatObj	= this.$calendarObj.find("table tbody").find("td:last");
				var nextFirstSunObj = this.$calendarObj.find("table tbody tr").eq(4).find("td:first");
				if(preFirstSunObj.is('[class="'+class_name.preMonth+'"]')){
					preFirstSunObj.removeClass(class_name.sunday);
					preFirstSunObj.addClass(class_name.preSunday);
				}
				if(nextLastSatObj.is('[class="'+class_name.nextMonth+'"]')){
					nextLastSatObj.removeClass(class_name.nextMonth);
					nextLastSatObj.addClass(class_name.nextSaturday);
				}
				if(nextFirstSunObj.is('[class="'+class_name.nextMonth+'"]')){
					nextFirstSunObj.removeClass(class_name.nextMonth);
					nextFirstSunObj.addClass(class_name.nextSunday);
				}
	
				//시간이 없는 일반 달력일경우
				if("undefined" == typeof(this.targetTimeObjs[0])){
					this.$calendarObj.find("#timeArea").remove();
				}//시간이 포함된 달력인경우 default 시간 셋팅
				else{
					//예약이체시간 체크하는 경우만 수행
					if(this.option.checkTransferDate){
						this.drawTimeList(this.curDate);
						this.curTime.hour = getCurAvaliableTime[0];
					}
					this.drawTime(this.curTime);
				}
				
				/* 일달력에서 일자 클릭시 */
				this.$calendarObj.find("table").find("tbody").find("tr").find("td").unbind('click');
				this.$calendarObj.find("table").find("tbody").find("tr").find("td").click(function() {
					//disable 되어있지 않은 요일만 일자클릭시 동작하도록 함
					if(!$(this).is('[class~="'+class_name.disableSunday+'"]') && 
							!$(this).is('[class~="'+class_name.disableSaturday+'"]') &&
							!$(this).is('[class~="'+class_name.disableDay+'"]')
					){
						//today 클래스 제거후 추가
						_this.$calendarObj.find("table").find("tbody").find('td[class~="'+class_name.today+'"]').removeClass(class_name.today);
						$(this).addClass(class_name.today);
						
						//현재 클릭한 날짜 저장
						var year = parseInt(_this.$calendarObj.find("#year").html(),10);
						var mon = parseFloat(_this.$calendarObj.find("#mon").html(),10);
						$(this).find("em").remove();
						var day = parseFloat($(this).html(), 10);
						_this.curDate = { 	"year" : year
											,"mon" : mon
											,"day" : day
										};
						_this.curSelectedDate = _this.curDate;
						//예약이체시간 체크하는 경우만 수행
						if(_this.option.checkTransferDate){
							_this.drawTimeList(_this.curSelectedDate);
							_this.curTime.hour = getCurAvaliableTime[0];
							_this.drawTime(_this.curTime);
						} else {
							if(_this.option.setDateOneClick){
								_this.clickBtnComplate();
							}
						}
						
					}
				});
				
				/* 일달력에서 전달의 날짜 클릭시 */
				this.$calendarObj.find("table").find("tbody").find("tr").find("td.pre").unbind('click');
				this.$calendarObj.find("table").find("tbody").find("tr").find("td.pre").click(function() {
					var preDate = MobCalendar.getPreMonth(_this.curDate);
					_this.drawCalendar({ year:preDate.year,
									    mon: preDate.mon,
									    day : -1
					});
				});
				
				/* 일달력에서 다음달의 날짜 클릭시 */
				this.$calendarObj.find("table").find("tbody").find("tr").find("td.next").unbind('click');
				this.$calendarObj.find("table").find("tbody").find("tr").find("td.next").click(function() {
					var nextDate = MobCalendar.getNextMonth(_this.curDate);
					_this.drawCalendar({ year:nextDate.year,
									    mon: nextDate.mon,
									    day : -1
					});
				});
				
				/* 일달력에서 이전달버튼 클릭시 이전달로 이동 */
				this.$calendarObj.find("#preMon").unbind('click');
				this.$calendarObj.find("#preMon").click(function(){
					var preDate = MobCalendar.getPreMonth(_this.curDate);
					var day = -1;
					_this.drawCalendar({ year:preDate.year,
									    mon: preDate.mon,
									    day : day
					});
				});
				
				/* 일달력에서 다음달버튼 클릭시 다음달로 이동 */
				this.$calendarObj.find("#nextMon").unbind('click');
				this.$calendarObj.find("#nextMon").click(function(){
					var nextDate = MobCalendar.getNextMonth(_this.curDate);
					var day = -1;
					_this.drawCalendar({ year:nextDate.year,
									    mon: nextDate.mon,
									    day : day
					});
				});
				
				/* 일달력에서 전년도 버튼 클릭시 전년으로 이동 */
				this.$calendarObj.find("#preYear").unbind('click');
				this.$calendarObj.find("#preYear").click(function(){
					var day = -1;
					_this.drawCalendar({ year:_this.curDate.year-1,
									    mon: _this.curDate.mon,
									    day : day
					});
				});
				
				/* 일달력에서 다음년도 버튼 클릭시 다음년으로 이동 */
				this.$calendarObj.find("#nextYear").unbind('click');
				this.$calendarObj.find("#nextYear").click(function(){
					var day = -1;
					_this.drawCalendar({ year:_this.curDate.year+1,
										mon: _this.curDate.mon,
										day : day
					});
				});
				
				/* 예약이체달력 적용버튼 클릭 */
				this.$calendarObj.find("#apply_btn").unbind('click');
				this.$calendarObj.find("#apply_btn").click(function(){
					$("#comTab").show();
					_this.clickBtnComplate();
				});
				
				/* 예약이체달력 이전버튼 클릭 */
				this.$calendarObj.find("#prev_btn").unbind('click');
				this.$calendarObj.find("#prev_btn").click(function(){
					$("#comTab").show();
					_this.hide();
				});
				
				/* 이전시간으로 이동 */
				this.$calendarObj.find("#btnPreHour").unbind('click');
				this.$calendarObj.find("#btnPreHour").click(function(){
					_this.curTime = _this.getPreTime(_this.curTime);
					_this.drawTime(_this.curTime);
				});
				
				/* 다음시간으로 이동 */
				this.$calendarObj.find("#btnNextHour").unbind('click');
				this.$calendarObj.find("#btnNextHour").click(function(){
					_this.curTime = _this.getNextTime(_this.curTime);
					_this.drawTime(_this.curTime);
				});
			},
			
			/* 달력의 완료버튼 클릭 */
			clickBtnComplate : function(){
				//사용자함수가 있는 경우에 함수 호출
				if("undefined" != typeof(this.option.execute)){
					var executeFunc = this.option.execute;
					executeFunc = executeFunc.substring(0,executeFunc.indexOf("(")) +"("+'{"date":this.curSelectedDate,"time":this.curTime}'+")";
					eval(executeFunc);
				}
				
				//모든 날짜 disable 인경우는 완료버튼 클릭시 값이 들어가도록 설정
				if(this.option.disableAll){
					//현재 클릭한 날짜 저장
					var year = parseInt(this.$calendarObj.find("#year").html(),10);
					var mon = parseFloat(this.$calendarObj.find("#mon").html(),10);
					var day = this.curSelectedDate.day;
					
					this.curDate = { 	"year" : year
										,"mon" : mon
										,"day" : day
									};
					
					this.curSelectedDate = this.curDate;
				}
				//target에 날짜시간 data 넣음
				this.setDateTimeTarget();
				
				this.hide();
			},
			/* calendar data set*/
			setDateTimeTarget : function(){
				var formattedDate = MobCalendar.getFormatDate(this.curSelectedDate,this.format);
				
				for(var i=0; i < this.targetObjs.length; i++){
					var tagnm = $(this.targetObjs[i]).get(0).tagName;
					if(tagnm == "INPUT") $(this.targetObjs[i]).val(formattedDate);
					else if(tagnm == "TEXT") $(this.targetObjs[i]).text(formattedDate);
					else $(this.targetObjs[i]).html(formattedDate);
				}
				
				//시간이있는 경우만 시간셋팅
				if(this.targetTimeObjs[0]){
					var formattedTime = MobCalendar.getFormatTime(this.curTime,this.formatTime);
					for(var i=0; i < this.targetTimeObjs.length; i++){
						var tagnm = $(this.targetTimeObjs[i]).get(0).tagName;
						if(tagnm == "INPUT") $(this.targetTimeObjs[i]).val(formattedTime);
						else if(tagnm == "TEXT") $(this.targetTimeObjs[i]).text(formattedTime);
						else $(this.targetTimeObjs[i]).html(formattedTime);
					}
					//this.$targetTimeObj.html(formattedTime);
				}
			},
			/* calendar 디자인 */
			getCalendarTag : function(){
				var calendarTag =
//				"<div class='brd_wrap'>"		여백제거
				"<div class='inquiry_wrap'>"	
					+"<div class='calendar_wrap calendar_ct'>"
					
					
						+"<div class='calendar_header'>"
							+"<div class='date'>"
								+"<a class='prev selected' id='preYear'>"
									+"<span>이전 년도</span>"
								+"</a>"
								+"<span class='year selected' id='year'>2013</span>"
								+"<a class='next selected' id='nextYear'>"
									+"<span>다음 년도</span>"
								+"</a>"
							+"</div>"
						+"<div class='date'>"
							+"<a class='prev selected' id='preMon'>"
								+"<span>이전 달</span>"
							+"</a>"
							+"<span class='year' id='mon'>9월</span>"
							+"<a class='next selected' id='nextMon'>"
								+"<span>다음 달</span>"
							+"</a>"
							+"</div>"
						+"</div>"
						
						+"<table class='calendar'>"
							+"<thead>"
								+"<tr>"
									+"<th scope='col' class='holiday'>일</th>"
									+"<th scope='col'>월</th>"
									+"<th scope='col'>화</th>"
									+"<th scope='col'>수</th>"
									+"<th scope='col'>목</th>"
									+"<th scope='col'>금</th>"
									+"<th scope='col'>토</th>"
								+"</tr>"
							+"</thead>"
							+"<tbody>"
								+"<tr>"
					            	+"<td></td>"
					            	+"<td></td>"
					            	+"<td></td>"
					            	+"<td></td>"
					            	+"<td></td>"
					            	+"<td> </td>"/* 휴일 */
					            	+"<td></td>"
				            	+"</tr>"
				            	+"<tr>"
					            	+"<td></td>"
					            	+"<td></td>"
					            	+"<td></td>"
					            	+"<td></td>"
					            	+"<td></td>" /*오늘*/ 
					            	+"<td></td>" /*기간선택*/
					            	+"<td></td>"
				            	+"</tr>"
				            	+"<tr>"
					            	+"<td></td>"
					            	+"<td></td>"
					            	+"<td></td>"
					            	+"<td></td>"
					            	+"<td></td>"
					            	+"<td></td>"
					            	+"<td></td>"
				            	+"</tr>"
				            	+"<tr>"
					            	+"<td></td>"
					            	+"<td></td>"
					            	+"<td></td>"
					            	+"<td></td>"
					            	+"<td></td>"
					            	+"<td></td>"
					            	+"<td></td>"
				            	+"</tr>"
				            	+"<tr>"
					            	+"<td></td>"
					            	+"<td></td>"
					            	+"<td></td>"
					            	+"<td></td>"
					            	+"<td></td>"
					            	+"<td></td>"
					            	+"<td></td>"
					            +"</tr>"
				            +"</tbody>"
			            +"</table>"
		            +"</div>"
		            
					+"<div class='time_setting' id='timeArea'>"
						+"<ul>"
							+"<li><em id='apm' >오전</em> <em id='hour' >08</em>시</li>"
						+"</ul>"
						+"<div class='turn_over'>"
							+"<a href='#ibk' class='prev' id='btnPreHour'>이전</a>"
							+"<a href='#ibk' class='next' id='btnNextHour'>다음</a>"
						+"</div>"
						+"<div class=\"btn_ct\">"
							+"<a href=\"#ibk\" class=\"btn first\" id=\"prev_btn\">"
								+"<span class=\"btn_prev\"><img src=\"/img/img_prevarrow.png\"/>이전</span>"
							+"</a>"
							+"<a href=\"#ibk\" class=\"btn dep\" id=\"apply_btn\">"
								+"<span>적 용</span>"
							+"</a>"
						+"</div>"
					+"</div>"
				+"</div>";
				return calendarTag;
			},
			/* calendar가 그려져있는지 여부 return */
			notCalendar: function(){
				var notCalendar = true;
				if(0 < this.$calendarObj.find("table.calendar").size()){
					notCalendar = false;
				}
				return notCalendar;
			},
			/* 이전시간*/
			getPreTime : function(curTime) {
				var result = {};
				var index = getCurAvaliableTime.indexOf(curTime.hour);
				if(0 == index){
					index = getCurAvaliableTime.length-1;
				}else{
					index = index-1;
				}
				result.hour = getCurAvaliableTime[index];
				return result;
			},
			/* 다음시간*/
			getNextTime : function(curTime) {
				var result = {};
				var index = getCurAvaliableTime.indexOf(curTime.hour);
				if((getCurAvaliableTime.length-1) == index){
					index = 0;
				}else{
					index = index+1;
				}
				result.hour = getCurAvaliableTime[index];
				return result;
			},
			/* 날짜를 파싱하여 return  */
			getParseDate : function(curDate, inFormat) {
				var result = {};
				var strDate = curDate;
				var format = inFormat;
				
				//날짜가 없는 경우 defulat는 today
				if("" == strDate){
					return MobCalendar.getToday();
				}
				
				strDate = strDate.replace(/[^0-9]/g, "");
				format = format.replace(/[^a-z]/g, "");
				format = format.replace("EEE", "");
	
				if(-1 < format.indexOf("yyyy")){
					result.year = parseInt(strDate.substr(format.indexOf("yyyy"),4));
				}
				if(-1 < format.indexOf("mm")){
					result.mon = parseFloat(strDate.substr(format.indexOf("mm"),2));
				}
				if(-1 < format.indexOf("dd")){
					result.day = parseFloat(strDate.substr(format.indexOf("dd"),2));
				}
				
				return result;
			},
			/* 시간을 파싱하여 return */
			getParseTime : function(curTime, inFormat){
				var result = {};
				var strTime = curTime;
				var format = inFormat;
	
				
				//예약이체시간체크하는 경우만 수행
				if(this.option.checkTransferDate){
					var transDate = this.getTransferDate(this.curSelectedDate);
					this.curSelectedDate.year = transDate.year;
					this.curSelectedDate.mon = transDate.mon;
					this.curSelectedDate.day = transDate.day;
					/*
					var idx = curTime.indexOf("오전");
					var idx2 = curTime.indexOf("오후");

					if(idx > -1) result.hour = String(Number(curTime.substring(idx+2, idx+4)));
					else if( idx2 > -1) result.hour = String(Number(curTime.substring(idx2+2, idx2+4)));
					else result.hour = transDate.hour;
					*/					
					result.hour = transDate.hour;
					return result;
				}
				
				//시간이 지정되어있지 않은 경우 default 는 오전 8시
				if("" == strTime){
					result.hour = getCurAvaliableTime[0];
					return result;
				}
				
				var hour = parseFloat(strTime.replace(/[^0-9]/g, ""));
				format = format.replace(/[^hh24|hh12]/g, "");
	
				if("hh24" == format){
					result.hour = hour;
				}else if("hh12" == format){
					if(-1 < strTime.indexOf("오후") || -1 < strTime.toLocaleLowerCase().indexOf("pm")){
						hour = hour+12;
					}
					result.hour = hour;
				}
				return result;
			},
			/* 월의 말일 구하기 */
			getMonEndDate : function(curDate) {
				if (curDate.mon == 2
						&& (curDate.year % 4 == 0 && (curDate.year % 100 != 0 || curDate.year % 400 == 0)))
					return 29;
				else
					return getMonLen[curDate.mon - 1];
			},
			/* 월의 시작요일구하기 */
			getFirstDay : function(curDate) {
				var yearlen = curDate.year - baseDt.year;
				var yun_yearlen = parseInt((curDate.year - 1) / 4, 10)
						- parseInt((curDate.year - 1) / 100, 10)
						+ parseInt((curDate.year - 1) / 400, 10);
				var dt_cnt = yearlen + yun_yearlen + 1;
	
				for ( var i = 0; i < curDate.mon - 1; i++) {
					dt_cnt = dt_cnt +this.getMonEndDate({
						"year" : curDate.year,
						"mon" : i + 1
					});
				}
				var week = (baseDt.week + dt_cnt + 1) % 7;
	
				return week;
			},
			parseOption: function(uOption){
				var userOption = uOption;
				var option = {
						execute 			: undefined		// 달력값이 셋팅전에 개별 처리해주기위해 사용하는 함수
						,checkTransferDate 	: false			// 가장가까운 이체가능날짜 및 시간으로 설정할지 여부
						,disableHoliday 	: false			// 휴일을 disable 시킬지 여부, disable된 날짜 클릭시 아무 동작 안함
						,disableAll			: false			// 모든 날짜 disable 여부
						,availableDateStart : "00000101"	// 선택가능한 날짜 시작
						,availableDateEnd	: "99991231"	// 선택가능한 날짜 끝
						,targetStep			: undefined		// 되돌아갈 step 지정.
						,fixDay				: false			// 해당일만 고정. 년월이 변경되어도 일은 해당일만 선택가능. 2월달인경우는 다른달 31일경우는 말일선택,그외에 2월달에 없는 일인경우에는 1일선택함.
						,setDateOneClick	: true			// 날짜클릭시 값이 들어가도록 설정.
						,hide				: true			// 달력을 닫을지여부
				};
				
				if("undefined" == typeof(userOption)){
					return option;
				}else{
					userOption = JSON.parse(userOption);
				}
				
				if("undefined" != typeof(userOption.execute)){option.execute = userOption.execute;}
				if(true == userOption.checkTransferDate){option.checkTransferDate = true;}
				if(true == userOption.disableHoliday){option.disableHoliday = true;}
				if(true == userOption.disableAll){option.disableAll = true;}
				if("undefined" != typeof(userOption.availableDateStart)){option.availableDateStart = this.getAvaliableDateAboutOption(userOption.availableDateStart);}
				if("undefined" != typeof(userOption.availableDateEnd)){option.availableDateEnd = this.getAvaliableDateAboutOption(userOption.availableDateEnd);;}
				if("undefined" != typeof(userOption.targetStep)){option.targetStep = userOption.targetStep;}
				if(true == userOption.fixDay){option.fixDay = true;}
				if(true == userOption.setDateOneClick){option.setDateOneClick = true;}
				if(false == userOption.hide){option.hide = false;}
				return option;
			},
			/* target을 List형태로 parsing */
			parseTargetObjList : function(strTarget){
				var targetList = [];
				if("undefined" == typeof(strTarget)){
					targetList[0] = undefined;
				}else{
					strTarget = strTarget.split(",");
					for(var i=0; i < strTarget.length; i++){
						targetList[i] = strTarget[i];
					}
				}
				return targetList;
			},
			/* 오늘을 기준으로 입력받은 parameter에 대한 날짜구함 */
			getAvaliableDateAboutOption: function(uOptionDate){
				var params = uOptionDate.split(",");
				var strDate = undefined;
				
				//날짜를 직접 입력받은경우
				if( 1 == params.length){
					strDate = params[0];
				}// 오늘을 기준으로 상대값을 입력받은 경우
				else if( 3 == params.length){
					//일이 end인경우 항상 해당월의 마지막 일자로 표시
					if("end" == $.trim(params[2])){
						strDate = ComDateUtil.getBoundDate(params[0], params[1], "0");
						var year =  strDate.substring(0,4);
						var mon = strDate.substring(4,6);
						var day = MobDate.getLastDay(year, mon, "01");
						strDate = year + mon +day.toString();
					}else{
						strDate = ComDateUtil.getBoundDate(params[0], params[1], params[2]);
					}
				}// 년만 상대값, 월일은 정해져있는 경우
				else if(2 == params.length){
					var tmpDate = ComDateUtil.getBoundDate(params[0], "0", "0");
					strDate = tmpDate.substring(0,4)+params[1];
				}
				return strDate;
			},
			getTerm: function(option){
				var term = {};
				if("start" == option.type){
					var endDate = this.getParseDate($(this.option.coupleTarget).text(), this.format);
					term.start = MobCalendar.getFormatDate(this.curSelectedDate, "yyyymmdd");
					term.end = MobCalendar.getFormatDate(endDate, "yyyymmdd");
				}else if("end" == option.type){
					var startDate = this.getParseDate($(this.option.coupleTarget).text(), this.format);
					term.start = MobCalendar.getFormatDate(startDate, "yyyymmdd");
					term.end = MobCalendar.getFormatDate(this.curSelectedDate, "yyyymmdd");
				}
				return term;
			},
			/* 가장가까운 이체가능한 날짜 및 시간 가져오는 함수 */
			getTransferDate: function(curDate){
	
				var today =  MobCalendar.getFormatDate(MobCalendar.getToday(),"yyyymmdd");
				var curTime = MobCalendar.getTime();
				
				var transferDate = MobCalendar.getFormatDate(curDate, "yyyymmdd");
				curDate.hour = getCurAvaliableTime[0];	//미래일이면 선택한날짜와 예약가능한 첫시간
				
				//이체실행일이 오늘인경우
				if(transferDate == today){	//미래일시 가 오늘인경우, 
					//PM 18시 이후는 다음날 가능하도록 처리
					if(18 < (curTime.hour+1)){
						curDate = MobCalendar.getNextDate(curDate);
						curDate.hour = getCurAvaliableTime[0];
					}//현재시간 +1 이후의 시간가져옴
					else{
						for(var i = 0; i < getCurAvaliableTime.length; i++){
							if( (curTime.hour+1) < getCurAvaliableTime[i]){
								curDate.hour = getCurAvaliableTime[i];
								break;
							}
						}
					}
				}
				
				//휴일아닌날짜 가장 최근날짜 가져옴.
				while(this.isHoliday(curDate)){
					curDate = MobCalendar.getNextDate(curDate);
					curDate.hour = getCurAvaliableTime[0];
				}
				
				return curDate;
			},
			/* 휴일여부 체크 */
			isHoliday : function(curDate){
				var week = getWeek[new Date(curDate.year, new Number(curDate.mon)-1, new Number(curDate.day)).getDay()];
				if("토" == week || "일" == week){
					return true;
				}
				return false;
			},
			/* 특정날짜에 대한 예약가능한 시간 리스트 셋팅 */
			drawTimeList : function(curDate){
				var today =  MobCalendar.getFormatDate(MobCalendar.getToday(),"yyyymmdd");
				var curTime = MobCalendar.getTime();
				var strCurDate = MobCalendar.getFormatDate(curDate, "yyyymmdd");
				var j = 0;
				
				if(today == strCurDate){
					for(var i = 0; i < getAvaliableTime.length; i++){
						if( (curTime.hour+1) < getAvaliableTime[i]){
							getCurAvaliableTime[j++] = getAvaliableTime[i];
						}
					}
				}else{
					getCurAvaliableTime = getAvaliableTime;
				}
			},
			
			/* 날짜(일)가 고정되어있는 경우 말일관련 처리 */
			getCalculatorFixDay :  function(iCurDate,ifixDay){
				var curDate = {};
				curDate = iCurDate;
				curDate.day = 1;
				var fixDay = -1;
				var endDay = MobCalendar.getMonEndDate(curDate); 
				//fixDay가 31일 경우에는 다른달로 이동시 해당 말일 선택
				if(31 == Number(ifixDay)){
					fixDay = endDay;
				}
				else{
					if(ifixDay > endDay){
						fixDay =  1;
					}else{
						fixDay = this.fixDay;
					}
				}
				return fixDay;
			}
		};
		$r.click(function() {
//            opt = jexCalFn['getInputFn']()();
            jexCalFn['execute'](opt);
        });
		jexCalFn['load'](opt);
	}
//	jex.plugin.add("JEX_MOBILE_CALENDAR", jexMobileCalendar ,calendar_attr.calendarId);
});



var _mobCalendar = function(){
	/* 오늘 */
	this.getToday = function() {
		var result = {};
			
		var strDate = ComDateUtil.getTodayTime("yyyymmdd");
		result.year = parseInt(strDate.substring(0,4));
		result.mon = parseFloat(strDate.substring(4,6));
		result.day = parseFloat(strDate.substring(6,8));
		
		return result;
	},
	/* 현재시간 */
	this.getTime = function(){
		var result = {};
		var strTime = ComDateUtil.getTodayTime("hh24");
		result.hour = parseFloat(strTime);
		
		return result;
	},
	/* 이전달 */
	this.getPreMonth = function(curDate) {
		var result = {};
		if (curDate.mon == 1) {
			result.year = curDate.year - 1;
			result.mon = 12;
		} else {
			result.year = curDate.year;
			result.mon = curDate.mon - 1;
		}
		return result;
	},
	/* 다음달 */
	this.getNextMonth = function(curDate) {
		var result = {};
		if (curDate.mon == 12) {
			result.year = curDate.year + 1;
			result.mon = 1;
		} else {
			result.year = curDate.year;
			result.mon = curDate.mon + 1;
		}
		return result;
	},
	/* 다음날 구하기 */
	this.getNextDate = function(curDate){
		var newDate  = new Date();
		var nextDate = new Date();
		var result = {};
		newDate.setFullYear(curDate.year);
		newDate.setMonth(curDate.mon - 1);
		newDate.setDate(curDate.day);
		
		nextDate = newDate;
		nextDate.setDate(nextDate.getDate()+1);
		
		result.year = Number(nextDate.getFullYear());
		result.mon =  Number(nextDate.getMonth() + 1);
		result.day = Number(nextDate.getDate());
		return result;
	},
	/* 설정한 format 대로 날짜를 셋팅 합니다.*/
	
	this.getFormatDate = function(curDate,format){
		var getWeek = [ "일", "월", "화", "수", "목", "금", "토" ];
		var strDate = format;
		var year = curDate.year;
		var mon = (1==curDate.mon.toString().length)?"0"+curDate.mon:curDate.mon;
		var day = (1==curDate.day.toString().length)?"0"+curDate.day:curDate.day;
		var week = getWeek[new Date(year, new Number(mon)-1, new Number(day)).getDay()];
		
		strDate = strDate.replace("yyyy",year);
		strDate = strDate.replace("mm",mon);
		strDate = strDate.replace("dd",day);
		strDate = strDate.replace("EEE",week);
		return strDate;
	},
	/** 설정한 format 대로 시간을 셋팅 합니다.
	 * @example MobCalendar.getFormatTime({"hour":1,"apm":"오후"},"hh24") => 13;
	 * 			MobCalendar.getFormatTime({"hour":13},"apmhh12") => 오후01
	 */
	this.getFormatTime = function(curDate,format){
		var strTime = format;
		var hour = curDate.hour;
		
		var apm  = ("undefined" == typeof(curDate.apm))?"오전":curDate.apm;
		
		if(-1 < format.indexOf("hh24")){
			if("undefined" != typeof(curDate.apm)){
				if("오후" == curDate.apm){
					hour = hour+12;
				}
			}
			hour = (1==hour.toString().length)?"0"+hour:hour;
			strTime = strTime.replace("hh24",hour);
		}else if(-1 < format.indexOf("hh12")){
			if(12 == curDate.hour){
				apm = "오후";
			} else if(12 < curDate.hour){
				hour = hour-12;
				apm = "오후";
			} 
			hour = (1==hour.toString().length)?"0"+hour:hour;
			strTime = strTime.replace("hh12",hour);
			strTime = strTime.replace("apm",apm);
		}
		return strTime;
	},
	
	/**
	 * 월의 끝날짜 구해줌
	 */
	this.getMonEndDate = function(curDate) {
		var getMonLen = [ 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 ];
		if (curDate.mon == 2
				&& (curDate.year % 4 == 0 && (curDate.year % 100 != 0 || curDate.year % 400 == 0)))
			return 29;
		else
			return getMonLen[curDate.mon - 1];
	};
};

var MobCalendar = new _mobCalendar();
