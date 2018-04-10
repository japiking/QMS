/**
 * Jex Tbl정의
 * 기능 요건
 *	01.	mobile append타입 지원
 *	02.	PAGING지원
 *	03.	확장성.
 *	04.	TABLE정의는 HTML에 정의되어 있는 것을 사용한다.
 *  
 *	05.	Table Data Set (tds)정의하자.
 *	06.	다중레이아웃지원
 */
(function() {
var JexTblException = Exception.extend({
	init:function(code, msg) {
		this._super(code, msg);
	},
	onError:function() {
		alert(this.getMessage());
	}
});

var tbl_attrs = {
		"id"		: "data-jx-table"						//table 플러그인 임을 선언
		,"onclick" 	: "data-jx-table-onclick"
		,"params"	: "data-jx-table-params"
	};

var PLUGIN_JEXTBL	= JexPlugin.extend({
	init : function(tbl) {
		this.dat 			= []; 
		this.obj 			= $(tbl);
		this.svrPageNo		= 1;
		this.drawCnt 		= -1;			// 해당 건수만큼 tbl을 그려준다.
		this.paging			= false;		// 페이징 사용여부
		this.tbody			= this.obj.find("tbody");
		this.thead			= this.obj.find("thead");
		this.tfoot			= this.obj.find("tfoot");
		this.pageCntPrefix	= "<span>◀</span>";
		this.pageCntPostfix	= "<span>▶</span>";
		this.pageIdxOff		= "%PAGE_NO%";
		this.pageIdxSP		= "|";
		this.pageIdxOn		= "<b>%PAGE_NO%</b>";
		this.layout			= {};
		this.formatter		= jex.getSetAllFormatter();
		this.dfltStr			= "DEFAULT";
		this.emptyStr          = "EMPTY";
		this.rowNumStr		= "data-rowNum";
		this.pageHrefPrefix	= "<a href=\"#currentPage=%PAGE_NO_ORI%&svrPage=%SVR_PAGE_NO%\">";
		this.pageHrefpostfix	= "</a>";
		this.eventList		= {};
		this.onclick			= {};
		this.totalPage		= 0;
		this.currentPage		= 1;
		this.drawRowCnt		= 1;
		this.jm				= jex.getJobManager();
		this.onBeforeChange	= function() {};
		this.maxPage;
		this.maxData;
		this.pageDiv;
		this.pageEvent		= false;
		this.hashCheckDely	= 500;		// Hash체크 시간(IE7이하 버젼용 :: 차후 필요시 외부에서 세팅하도록 인터페이스를 제공해주자.)
		this.setSvrPageSize(100);
		//this.getLayout();
		//this.setPageEvent();
		
		/* new */
		this.params = {};
		
		//from add앱통장
		this.load(tbl_attrs.id,this.obj);
	}, 
	load : function(attr, $jq){
		this.obj 			= $jq;
		//MODIFY 20130422
		//this.jexService		= this.obj.attr(attr);
		this.key = this.obj.attr(attr);
		//END
		this.tbody			= this.obj.find("tbody");
		this.thead			= this.obj.find("thead");
		this.tfoot			= this.obj.find("tfoot");
		
		this.parseParams(this.obj.attr(tbl_attrs.params));
		if(undefined != this.obj.attr(tbl_attrs.onclick)){
			this.parseOnclick(this.obj.attr(tbl_attrs.onclick));
		}

		this.getLayout();
		this.setPageEvent();
	},
	//ADD 20130625 tr html이 변경되는경우로 인해 reload 함수 추가
	reload : function(){
		this.tbody			= this.obj.find("tbody");
	}, 
	parseParams : function(inputParams){
		if(!inputParams || inputParams.length == 0)		return;
		
		var keyValueListOfInputParams = inputParams.split(";");
		
		for(var i = 0, length = keyValueListOfInputParams.length; i < length; i++){
			var keyValueString = keyValueListOfInputParams[i];
			
			if(!keyValueString || keyValueString.length == 0)		continue;
			
			var keyValue = keyValueString.split(":");
			if(!keyValue || keyValue.length != 2)		continue;
						
			var key = $.trim(keyValue[0]);
			var value = $.trim(keyValue[1]);
			
			if(!key || key.length == 0 || !value || value.length == 0)		continue;
			
			this.params[key] = value;
		}
	},
	parseOnclick : function(userInput){
		var onclickList = userInput.split(";");

		for (var i = 0, length = onclickList.length; i < length; i++) {
			var keyValue = onclickList[i].split(":");

			var objectId = undefined;
			var method = undefined;

			if (keyValue.length == 1) {
				method = keyValue[0].trim();
			} else if (keyValue.length == 2) {
				objectId = keyValue[0].trim();
				objectId = (objectId.startsWith("#"))? objectId.substring(1) : objectId;
				method = keyValue[1].trim();
			}

			var pageMethods = method.split(".");
			method = window[pageMethods[0]];

			if (typeof(method) != "object" && typeof(method) != "function")		continue;

			for (var indexOfPageMethods = 1, lengthOfPageMethods = pageMethods.length; indexOfPageMethods < lengthOfPageMethods; indexOfPageMethods++) {
				method = method[pageMethods[indexOfPageMethods]];

				if (typeof(method) == "object")			continue;
				if (typeof(method) == "function")		break;
			}


			if (typeof(method) == "function") {
				if (objectId != undefined) {
					this.onClick(objectId, method);
				} else {
					this.onClick(method);
				}
			}
		}
	},
	draw : function() {
		if (!location.hash) {
			var hash = {};
			hash['currentPage']	=	(this.currentPage)?this.currentPage.toString():"1";
			hash['svrPage']		=	(this.svrPageNo)?this.svrPageNo.toString():"1";
			jex.setHString(hash);
		}  else {
			this.onPageChange();
		}
	}, prependData : function(data) {
		this.dat = data.concat(this.dat);
	}, getData : function(idx) {
		return this.dat[idx];
	}, getEvent : function(key) {
		var fn = this.eventList[key];
		if (typeof(fn) == "function") return fn;
		return function(){};
	}, addEvent : function(key, fn) {
		this.eventList[key] = fn;
	}, setDrawRowCnt	: function(n) {
		this.drawRowCnt = n;
	}, setPageCntPrefix	: function(s) {
		this.pageCntPrefix	= s;
	}, setPageCntPostfix : function(s) {
		this.pageCntPostfix	= s;
	}, hasNextSvrPage : function() {
		if (this.dat.length > this.maxData)	return true;
		else										return false;
	}, hasBeforeSvrPage : function() {
		if (this.svrPageNo <= 1)			return false;
		else									return true;
	}, getSvrPageSize : function() {
		return this.maxData;
	}, setSvrPageSize : function(i) {
		this.maxData = i;
		this.maxPage = parseInt((i-1) / this.drawCnt,10)+1;
	}, setSvrPageNo : function(i) {
		this.svrPageNo = i;
	}, getSvrPageNo : function() {
		return this.svrPageNo;
	}, setPageEvent : function() {
		if (!this.pageEvent) {
			var  _tblthis = this;
			if (window.addEventListener ) {
				window.addEventListener('hashchange', function() {
					_tblthis.onPageChange();
				},false);
			} else if (window.attachEvent) {
				this.beforeHash = location.hash;
				setInterval(function() {
					if (_tblthis.beforeHash==location.hash) return;
					_tblthis.onPageChange();
					_tblthis.beforeHash = location.hash;
				},this.hashCheckDely);
			}
			this.pageEvent = true;
		}
	}, beforePageChange : function(fn) {
		this.onBeforeChange = fn;
	}, onPageChange : function() {
		var  _tblthis = this;
		this.jm.add(function() { _tblthis.onBeforeChange(this); });
		this.jm.add(function() { _tblthis._onPageChange(); });
	}, _onPageChange : function() {
		var  _tblthis = this;
		var hString = jex.getHString();
		_tblthis.currentPage		= parseInt(hString['currentPage'],	10);
		if (_tblthis.svrPageNo	!= parseInt(hString['svrPage'],	10) || this.dat.length == 0) {
			_tblthis.onSvrPageChange(parseInt(hString['svrPage'],	10));
		}
		_tblthis.clearTbl(true);
		_tblthis.drawTbl();
	}, onSvrPageChange : function(svrPage) {
		this.svrPageNo = svrPage;
		this.getEvent("onSvrPageChange")(svrPage);
	}, drawPageIdx : function() {
		_tblThis = this;
		if (!this.pageDiv||this.pageDiv.length == 0) throw new JexTblException("TBL0004","Page Div가 지정되지 않았습니다.");
		var totalPage = this.getTotalPage(); 
		totalPage = (totalPage > this.maxPage)?this.maxPage:totalPage;
		var svrPageNo = this.getSvrPageNo();
		this.pageDiv.html("");
	
		var prefix = $(this.pageCntPrefix);
		if (_tblThis.hasBeforeSvrPage()) prefix.appendTo(this.pageDiv);

		for (var i=0;i<totalPage;i++) {
			if ((i+1)==this.getCurrentPage())	this.pageDiv.append(this.pageIdxOn.replace(/%PAGE_NO%/g,((svrPageNo-1)*10)+i+1).replace(/%PAGE_NO_ORI/,i+1).replace(/%SVR_PAGE_NO%/,this.svrPageNo));
			else									this.pageDiv.append((this.pageHrefPrefix+this.pageIdxOff+this.pageHrefpostfix).replace(/%PAGE_NO%/g,((svrPageNo-1)*10)+i+1).replace(/%PAGE_NO_ORI%/,i+1).replace(/%SVR_PAGE_NO%/,this.svrPageNo));
			if (i!=totalPage-1)					this.pageDiv.append(this.pageIdxSP);
		}
		var postfix = $(this.pageCntPostfix);
		if (_tblThis.hasNextSvrPage()) postfix.appendTo(this.pageDiv);
		
		prefix.css("cursor","pointer");
		postfix.css("cursor","pointer");
	
		if (this.eventList["onSvrPageChange"]) {
			prefix.click(function() {
				var hash = {};
				hash['currentPage']	=	"1";
				hash['svrPage']		=	(_tblThis.svrPageNo)?(_tblThis.svrPageNo-1).toString():"1";
				if (_tblThis.hasBeforeSvrPage()) jex.setHString(hash);
			});
			postfix.click(function() {
				var hash = {};
				hash['currentPage']	=	"1";
				hash['svrPage']		=	(_tblThis.svrPageNo)?(_tblThis.svrPageNo+1).toString():"1";
				if (_tblThis.hasNextSvrPage()) jex.setHString(hash); jex.setHString(hash);
			});
		}

		if (!location.hash) {
			var hash = {};
			hash['currentPage']	=	(this.currentPage)?this.currentPage.toString():"1";
			hash['svrPage']		=	(this.svrPageNo)?this.svrPageNo.toString():"1";
			jex.setHString(hash);
			//location.hash = this.currentPage.toString();
		} 
	}, getCurrentPage : function() {
		if (!this.paging)	 throw new JexTblException("TBL0002", "페이징 처리시에만 지원되는 기능입니다.");
		return this.currentPage;
	}, getTotalPage : function() {
		if (!this.paging)	 throw new JexTblException("TBL0002", "페이징 처리시에만 지원되는 기능입니다.");
		this.totalPage = parseInt(((this.dat.length-1) / this.drawCnt),10)+1;
		return this.totalPage;
	}, setPageIdx : function(on,off,sp) {
		this.pageIdxOn	= on;
		this.pageIdxOff = off;
		this.pageIdxSP	= sp;
	}, setPageDiv : function(div) {
		this.pageDiv = $(div);
	}, clearTbl : function(b) {
		if (!b) this.dat = [];
		this.tbody.find("tr").remove();
	}, addFormatter : function(key, fn) {
		this.formatter[key] = fn;
	}, onClick : function() {
		if (arguments.length == 1)	this.onclick[this.dfltStr]	= arguments[0];
		else							this.onclick[arguments[0]]	= arguments[1];
	}, addLayOut : function(key, str) {
		this.layout[key] = str;
	}, getLayout : function() {
		var trlist = this.tbody.find("tr");
		trlist.hide();
		if (trlist.length == 0) return;
	
		for (var i=0; i<trlist.length; i++) {
			var trid	= $(trlist[i]).attr("id");
			var rowstr	=  $('<p>').append($(trlist[i]).eq(0).clone()).html();
		
			if (!trid || trid =="") {
				if (!this.layout[this.dfltStr]) this.addLayOut(this.dfltStr, rowstr);
			} else {
				if (!this.layout[trid]) {
					this.addLayOut(trid, rowstr);
				} else {
					this.addLayOut(trid, this.layout[trid]+rowstr);
				} }
		}
		
		trlist.remove();
	}, setDrawCnt : function(cnt) {
		this.drawCnt = cnt;
	},
	setAll : function(data,layout) {
		this.clearTbl();

		//MODIFY 20130514 from kiup 
        if (data && 0 != data.length) {
        //MODIFY END 20130514 
        	if (data[this.key] != null) {
                this.dat = data[this.key];
            } else {
                this.dat = data;
            }

            this.drawTbl(layout);
        } else {
            if (this.layout[this.emptyStr]) {
                this.addRow({}, 0, this.emptyStr);
            }
        }
	},
	//REMOVE 20130514
	/*setAll : function(data,layout) {
		this.clearTbl();
		if (!data) return;
		
		if (data[this.key] != null) {
			this.dat = data[this.key];
		} else {
			this.dat = data;
		}
		//END
		this.drawTbl(layout);
	},*/ 
	append : function(data) {
		this.dat.concat(data);
		this.drawTbl();
	}, getRowNum : function(r) {		// ROWNUM을 return
		return $(this.getParentTr(r)).attr(this.rowNumStr);
	}, getParentTr : function(r) {		// 자신의 상위 TR을 찾아줌.
		while ($(r).get(0).tagName.toUpperCase() != "TR") r = $(r).parent().get(0);
		return r;
	}, update : function(rowNum, dat) {	// 자신의 상위 TR을 찾아줌.
		this.dat[rowNum] = dat;
		this.tbody.find("["+this.rowNumStr+"="+rowNum+"]").setAll(dat,this.formatter);
	}, addNRow : function(data) {
		jex.printDebug("추가할 Row :: "+data.length);
		for (var i=0; i<data.length; i++) {
			this.addRow(data[i]);
		}
	}, addRow : function(data,i,layout) {
		var lo			= (layout)?layout:this.dfltStr;
		/*if (data['JEX_LAYOUT']) lo = data['JEX_LAYOUT'];*/
		//MODIFY START 20130514
		if (typeof data === "object" && data['JEX_LAYOUT']) lo = data['JEX_LAYOUT'];
		//MODIFY END 20130514
		if (!this.layout[lo]) lo = this.dfltStr;
			
		var nRow		= $(this.layout[lo]);
		
		var _tblthis	= this;
		if (i == undefined) {
			if (this.paging)  throw new JexTblException("TBL0003", "페이징 처리시 지원되지 않는 기능입니다.");
			i = this.dat.length;
			this.dat.push(data);
		}
		
		jex.setJexObj(nRow);		//20130507
		nRow.setAll(data,this.formatter);
		nRow.show();
		nRow = nRow.appendTo(this.tbody);
		nRow.attr(this.rowNumStr,i);
		nRow.data("_JEX_GETALL_DATA_",data);
		
		for (var kkey in this.onclick) {
			var evtObj;
			if (kkey==this.dfltStr) evtObj = nRow;
			else					evtObj = nRow.find("#"+kkey);
			evtObj.css("cursor","pointer");
			evtObj.click(function(e) {
				//ADD 20130516 from kiup 이벤트 중복방지
				var eventRef = (typeof e !== "undefined")? e: event;
				if (eventRef.stopPropagation){
					e.stopPropagation();
				}
				else {
					eventRef.cancelBubble = true;
				}
				//END 
				_tblthis.onclick[jex.isNull($(this).attr("id"))?_tblthis.dfltStr:$(this).attr("id")].apply(this, [_tblthis.dat[$(_tblthis.getParentTr(this)).attr(_tblthis.rowNumStr)]]); 
			}); 
		}
	}, deleteRow : function(rowNum) {
		if (this.paging)  throw new JexTblException("TBL0003", "페이징 처리시 지원되지 않는 기능입니다.");
		this.dat[rowNum] = {};
		this.tbody.find("["+this.rowNumStr+"="+rowNum+"]").remove();
	}, page : function(b) {
		this.paging = b;
	}, isEmptyJSON : function(obj) {
		for(var i in obj) { return false; }
		return true;
	}, getAll : function() {
		var rslt = [];
		for (var i=0; i<this.dat.length; i++) if (!this.isEmptyJSON(this.dat[i])) rslt.push(this.dat[i]);
		return rslt;
	}, drawTbl: function(layout) {
		var strIdx = 0;
		var endIdx = this.dat.length;
	
		if (this.paging) {
			strIdx = (this.currentPage*this.drawCnt)-this.drawCnt;
			endIdx = (endIdx > (strIdx+this.drawCnt))?(strIdx+this.drawCnt):endIdx;
		} else {
			if (this.drawCnt > 0) endIdx = this.drawCnt;
		}
		
		
		for (var i=strIdx; i<endIdx; i++){
			this.addRow(this.dat[i],i,layout);
		}
		
		//START 20130514 table이 null인경우 id='layoutNull" 인 tr을 한번 그려줌
/*		if(0 == endIdx){
			this.addRow({"JEX_LAYOUT":"layoutNull"},0,"layoutNull");
		}*/
		//END 20130514
		
		if (this.paging) this.drawPageIdx();
	}
});

jex.plugin.add("JEX_MOBILE_TBL", PLUGIN_JEXTBL, "data-jx-table");

function formatterNumberToMoney(col, row){
	if(col == null)			return "";

	var number = col.trim();
	var newNumber = "";
	
	while(number.length > 3){
		var length = number.length;
		var token = ",";
		
		var tmp = number.substring(length - 3, length);
		
		newNumber = token + tmp + newNumber;
		number = number.substring(0, length - 3);
	}
	
	return number + newNumber + " 원";
}

})();