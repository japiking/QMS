package qms.util;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.Locale;
import java.util.Map;
import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.ConcurrentHashMap;

//import jex.JexConst;

public class DateTime {
	private static Map<Locale, DateTime> _instance = new ConcurrentHashMap();

	private Map<String, BlockingQueue<DateFormat>> _format = new ConcurrentHashMap();

	private Locale _locale = null;

	private int _nYear = -1;
	private int _nMonth = -1;
	private int _nDay = -1;
	
	/** Default 날짜 포맷  : yyyy-MM-dd */
	public final static String DFT_FORMAT = "yyyy-MM-dd";
	
	private boolean _bUserTransDate = false;

	public static final DateTime getInstance() {
		return getInstance(Locale.getDefault());
	}

	public static final DateTime getInstance(Locale locale) {
		DateTime result = (DateTime) _instance.get(locale);
		if (result == null) {
			synchronized (DateTime.class) {
				result = new DateTime(locale);
				_instance.put(locale, result);
			}
		}
		return result;
	}

	public Calendar getCalendar(String input) throws IllegalArgumentException {
		if (input == null) {
			throw new IllegalArgumentException(input);
		}

		String strInput = input.trim();
		Calendar calendar = Calendar.getInstance();
		switch (strInput.length()) {
		case 8:
			calendar.set(Integer.parseInt(strInput.substring(0, 4)),
					Integer.parseInt(strInput.substring(4, 6)) - 1,
					Integer.parseInt(strInput.substring(6)));
			break;
		case 14:
			calendar.set(Integer.parseInt(strInput.substring(0, 4)),
					Integer.parseInt(strInput.substring(4, 6)) - 1,
					Integer.parseInt(strInput.substring(6, 8)),
					Integer.parseInt(strInput.substring(8, 10)),
					Integer.parseInt(strInput.substring(10, 12)),
					Integer.parseInt(strInput.substring(12)));
			break;
		case 6:
			String strTmp = getDate("yyyymmdd") + strInput;
			calendar.set(Integer.parseInt(strTmp.substring(0, 4)),
					Integer.parseInt(strTmp.substring(4, 6)) - 1,
					Integer.parseInt(strTmp.substring(6, 8)),
					Integer.parseInt(strTmp.substring(8, 10)),
					Integer.parseInt(strTmp.substring(10, 12)),
					Integer.parseInt(strTmp.substring(12)));
			break;
		default:
			throw new IllegalArgumentException(input);
		}

		return calendar;
	}

	protected DateTime(Locale l) {
		this._locale = l;
		String strTransationDate = null;
		if (strTransationDate != null) {
			if (strTransationDate.length() == 8) {
				this._nYear = Integer.parseInt(strTransationDate
						.substring(0, 4));
				this._nMonth = (Integer.parseInt(strTransationDate.substring(4,
						6)) - 1);
				this._nDay = Integer.parseInt(strTransationDate.substring(6));

				this._bUserTransDate = ((this._nYear >= 0)
						&& (this._nMonth >= 0) && (this._nDay >= 0));
			}
		}
	}

	private Locale _getLocale() {
		return this._locale;
	}

	private String _getDateFormatString(String pattern) {
		String strFormat = pattern.toLowerCase();
		int i;
		if ((i = strFormat.indexOf("mmm")) != -1) {
			strFormat = strFormat.substring(0, i).concat("MMM")
					.concat(strFormat.substring(i + 3));
		}
		if ((i = strFormat.indexOf("eee")) != -1) {
			strFormat = strFormat.substring(0, i).concat("EEE")
					.concat(strFormat.substring(i + 3));
		}
		if ((i = strFormat.indexOf("g")) != -1) {
			strFormat = strFormat.substring(0, i).concat("G")
					.concat(strFormat.substring(i + 1));
		}
		if ((i = strFormat.indexOf("hh24")) != -1) {
			strFormat = strFormat.substring(0, i).concat("HH")
					.concat(strFormat.substring(i + 4));
		}
		if ((i = strFormat.indexOf("ms")) != -1) {
			strFormat = strFormat.substring(0, i).concat("SSS")
					.concat(strFormat.substring(i + 2));
		}
		if ((i = strFormat.indexOf("mm")) != -1) {
			strFormat = strFormat.substring(0, i).concat("MM")
					.concat(strFormat.substring(i + 2));
		}
		if ((i = strFormat.indexOf("mi")) != -1) {
			strFormat = strFormat.substring(0, i).concat("mm")
					.concat(strFormat.substring(i + 2));
		}
		if ((i = strFormat.indexOf("ttt")) != -1) {
			strFormat = strFormat.substring(0, i).concat("SSS")
					.concat(strFormat.substring(i + 3));
		}
		return strFormat;
	}

	private DateFormat _getDateFormat(String key, String pattern) {
		if (pattern == null)
			return null;

		BlockingQueue queue = (BlockingQueue) this._format.get(key);

		if (queue == null) {
			queue = new ArrayBlockingQueue(1000);
			this._format.put(key, queue);
		}

		DateFormat result = (DateFormat) queue.poll();

		if (result == null) {
			result = new SimpleDateFormat(_getDateFormatString(pattern),
					_getLocale());
		}
		return result;
	}

	private void _addDateFormat(String key, DateFormat format) {
		BlockingQueue queue = (BlockingQueue) this._format.get(key);

		if (queue == null) {
			queue = new ArrayBlockingQueue(1000);
			this._format.put(key, queue);
		}
		try {
			queue.add(format);
		} catch (Exception localException) {
		}
	}

	public Calendar getTransactionDay() {
		Calendar calendar = Calendar.getInstance();
		if (this._bUserTransDate) {
			calendar.set(this._nYear, this._nMonth, this._nDay);
		}
		return calendar;
	}

	public String getSysDate(String format) {
		return getDate(Calendar.getInstance().getTime(), format);
	}

	public String getSysDate(String format, char c, int i) {
		return getDate(Calendar.getInstance().getTime(), format, c, i);
	}

	public String getDate(String format) {
		return getDate(getTransactionDay().getTime(), format);
	}

	public String getDate(String format, char c, int i) {
		return getDate(getTransactionDay().getTime(), format, c, i);
	}

	public String getDate(String inputDate, String format) {
		try {
			return getDate(getCalendar(inputDate).getTime(), format);
		} catch (IllegalArgumentException ie) {
		}
		return "";
	}

	public String getDate(long date, String format) {
		return getDate(new Date(date), format);
	}

	public String getDate(String inputDate, String format, char c, int i) {
		try {
			return getDate(getCalendar(inputDate).getTime(), format, c, i);
		} catch (IllegalArgumentException ie) {
		}
		return "";
	}

	public String getDate(long date, String format, char c, int i) {
		Calendar calendar = Calendar.getInstance();
		calendar.setTimeInMillis(date);
		switch (c) {
		case 'Y':
			calendar.add(1, i);
			break;
		case 'M':
			calendar.add(2, i);
			break;
		case 'W':
			calendar.add(4, i);
			break;
		case 'D':
			calendar.add(5, i);
			break;
		case 'H':
			calendar.add(10, i);
			break;
		case 'I':
			calendar.add(12, i);
			break;
		case 'S':
			calendar.add(13, i);
		}

		return getDate(calendar.getTime(), format);
	}

	public long getDate(long date, char c, int i) {
		Calendar calendar = Calendar.getInstance();
		calendar.setTimeInMillis(date);
		switch (c) {
		case 'Y':
			calendar.add(1, i);
			break;
		case 'M':
			calendar.add(2, i);
			break;
		case 'W':
			calendar.add(4, i);
			break;
		case 'D':
			calendar.add(5, i);
			break;
		case 'H':
			calendar.add(10, i);
			break;
		case 'I':
			calendar.add(12, i);
			break;
		case 'S':
			calendar.add(13, i);
		}

		return calendar.getTime().getTime();
	}

	public String getDate(Date date, String format, char c, int i) {
		return getDate(date.getTime(), format, c, i);
	}

	public int getDayBetween(String fromDate, String toDate) {
		return getDayBetween(getCalendar(fromDate).getTime(),
				getCalendar(toDate).getTime());
	}

	public int getDayBetween(Date fromDate, Date toDate) {
		Calendar fromCal = Calendar.getInstance();
		Calendar toCal = Calendar.getInstance();
		fromCal.setTime(fromDate);
		toCal.setTime(toDate);
		return getDayBetween(fromCal, toCal);
	}

	public int getDayBetween(Calendar fromDate, Calendar toDate) {
		Calendar tmpCal = Calendar.getInstance();
		int nFromYear = fromDate.get(1);
		int nToYear = toDate.get(1);
		int nFromDate = fromDate.get(6);
		int nToDate = toDate.get(6);
		int nCheckDate = 0;

		if (nFromYear < nToYear) {
			for (int i = nFromYear; i < nToYear; i++) {
				tmpCal.set(i, 11, 31);
				nCheckDate += tmpCal.get(6);
			}
			return nCheckDate + nToDate - nFromDate;
		}

		for (int i = nToYear; i < nFromYear; i++) {
			tmpCal.set(i, 11, 31);
			nCheckDate += tmpCal.get(6);
		}
		return (nCheckDate + nFromDate - nToDate) * -1;
	}

	public int getTimeBetween(String hhmmss1, String hhmmss2) {
		int ss = getSecondBetween(hhmmss1, hhmmss2);

		int mm = ss / 60;
		ss %= 60;

		int hh = mm / 60;
		mm %= 60;

		return hh + mm + ss;
	}

	public int getSecondBetween(String hhmmss1, String hhmmss2) {
		return Math.abs(toSecond(hhmmss2) - toSecond(hhmmss1));
	}

	private int toSecond(String hhmmss) {
		try {
			int hh = Integer.parseInt(hhmmss.substring(0, 2));
			int mm = Integer.parseInt(hhmmss.substring(2, 4));
			int ss = Integer.parseInt(hhmmss.substring(4, 6));

			return (hh * 60 + mm) * 60 + ss;
		} catch (Exception e) {
			e.printStackTrace(System.out);
		}
		return -1;
	}

	public String getDate(Date date, String format) {
		String strKey = format.toLowerCase();
		DateFormat dateFromat = _getDateFormat(strKey, format);
		String strResult = dateFromat != null ? dateFromat.format(date) : "";
		_addDateFormat(strKey, dateFromat);
		return strResult;
	}

	public boolean isLastDay(String format) {
		return isLastDay(getCalendar(format).getTimeInMillis());
	}

	public boolean isLastDay(Date date) {
		return isLastDay(date.getTime());
	}

	public boolean isLastDay(long date) {
		String strMM = getDate(date, "MM");
		String strMM2 = getDate(date, "MM", 'D', 1);

		return !strMM.equals(strMM2);
	}

	/**
	 * 현재 시간이 시작 시간과 종료시간 사이에 있는지 확인
	 * 
	 * @param startDateTime
	 *            (HHmmss)
	 * @param endDateTime
	 *            (HHmmss)
	 * @return
	 */
	public static boolean checkNowTimeBetweenStoE(String startDateTime,
			String endDateTime) {
		boolean checkFlag = false;

		Calendar nowTime = getCalInstance();

		if (nowTime.after(getCalInstance(startDateTime))
				&& nowTime.before(getCalInstance(endDateTime))) {
			checkFlag = true;
		}

		return checkFlag;
	}

	/**
	 * 현재 시간의 캘린더 인스턴스 생성
	 * 
	 * @return
	 */
	private static Calendar getCalInstance() {
		return getCalInstance("");
	}

	/**
	 * 캘린더 인스턴스 생성
	 * 
	 * dateTime(HHmmss)
	 * 
	 * @param dateTime
	 * @return
	 */
	private static Calendar getCalInstance(String dateTime) {
		Calendar cal = Calendar.getInstance();

		if (dateTime != null && dateTime != "") {
			int hour = Integer.parseInt(dateTime.substring(0, 2));
			int min = Integer.parseInt(dateTime.substring(2, 4));
			int sec = Integer.parseInt(dateTime.substring(4, 6));

			cal.set(Calendar.HOUR_OF_DAY, hour);
			cal.set(Calendar.MINUTE, min);
			cal.set(Calendar.SECOND, sec);
			cal.set(Calendar.MILLISECOND, 0);
		}

		return cal;
	}
	
	/**
	   * 현재시간으로부터 지정된 날수 이전/이후의 시간을 표현방식대로 반환
	   *
	   * @param   format   표현하고자 하는 형식을 지정
	   * @param   data   지정일자 (yyyyMMdd)
	   * @param   yearCount   현재일로 부터의 지정된 월수 (+/-)
	   * @return   표현형식에 따른 일자/시간
	   */
	  public static String getCurDateFormatFromTime(int timeCount) {
		  return getCurDateFormatFromTime(null, timeCount);
      }
	/**
	   * 현재시간으로부터 지정된 날수 이전/이후의 시간을 표현방식대로 반환
	   *
	   * @param   format   표현하고자 하는 형식을 지정
	   * @param   data   지정일자 (yyyyMMdd)
	   * @param   yearCount   현재일로 부터의 지정된 월수 (+/-)
	   * @return   표현형식에 따른 일자/시간
	   */
	  public static String getCurDateFormatFromTime(String format, int timeCount) {
	    try {
	    	
	    	if(format == null) format = "yyyy-MM-dd HH:mm:ss";
	    	
	        Calendar cdate = Calendar.getInstance();
	        cdate.add(Calendar.HOUR_OF_DAY, timeCount);
	        Date date = cdate.getTime();

	        SimpleDateFormat sdf = new SimpleDateFormat(format);
	        return sdf.format(date);

	      } catch(Exception ex) {
	        return "00000000";
	      }
     }
	
	  /**
	   * 현재시간으로부터 지정된 날수 이전/이후의 일자를 표현방식대로 반환
	   *
	   * @param   format   표현하고자 하는 형식을 지정
	   * @param   data   지정일자 (yyyyMMdd)
	   * @param   yearCount   현재일로 부터의 지정된 월수 (+/-)
	   * @return   표현형식에 따른 일자/시간
	   */
	  public static String getCurDateFormatFromDay(int dCount) {
		  return getCurDateFormatFromDay(null, dCount);
      }
	/**
	   * 현재시간으로부터 지정된 날수 이전/이후의 일자 표현방식대로 반환
	   *
	   * @param   format   표현하고자 하는 형식을 지정
	   * @param   data   지정일자 (yyyyMMdd)
	   * @param   yearCount   현재일로 부터의 지정된 월수 (+/-)
	   * @return   표현형식에 따른 일자/시간
	   */
	  public static String getCurDateFormatFromDay(String format, int dCount) {
	    try {
	    	
	    	if(format == null) format =  "yyyy-MM-dd HH:mm:ss";
	    	
	        Calendar cdate = Calendar.getInstance();
	        cdate.add(Calendar.DAY_OF_MONTH, dCount);
	        Date date = cdate.getTime();

	        SimpleDateFormat sdf = new SimpleDateFormat(format);
	        return sdf.format(date);

	      } catch(Exception ex) {
	        return "00000000";
	      }
     }
	  /**
	   * 현재시간으로부터 지정된 달수 이전/이후의 일자를 표현방식대로 반환
	   *
	   * @param   format   표현하고자 하는 형식을 지정
	   * @param   data   지정일자 (yyyyMMdd)
	   * @param   yearCount   현재일로 부터의 지정된 월수 (+/-)
	   * @return   표현형식에 따른 일자/시간
	   */
	  public static String getCurDateFormatFromMonth(int dCount) {
		  return getCurDateFormatFromMonth(null, dCount);
      }
	/**
	   * 현재시간으로부터 지정된 달수 이전/이후의 일자 표현방식대로 반환
	   *
	   * @param   format   표현하고자 하는 형식을 지정
	   * @param   data   지정일자 (yyyyMMdd)
	   * @param   yearCount   현재일로 부터의 지정된 월수 (+/-)
	   * @return   표현형식에 따른 일자/시간
	   */
	  public static String getCurDateFormatFromMonth(String format, int dCount) {
	    try {
	    	
	    	if(format == null) format =  "yyyy-MM-dd HH:mm:ss";
	    	
	        Calendar cdate = Calendar.getInstance();
	        cdate.add(Calendar.MONTH, dCount);
	        Date date = cdate.getTime();

	        SimpleDateFormat sdf = new SimpleDateFormat(format);
	        return sdf.format(date);

	      } catch(Exception ex) {
	        return "00000000";
	      }
     }
	/**
	   * 특정일자의 지정된 날수 이전/이후의 일자/시간을 표현형식대로 반환
	   *
	   * @param   format   표현하고자 하는 형식을 지정
	   * @param   data   지정일자 (yyyyMMdd)
	   * @param   dayCount   현재일로 부터의 지정된 날수 (+/-)
	   * @return   표현형식에 따른 일자/시간
	   */
	  public static String getDateFormatFrom(String format, String data, int dayCount) {

	    try {

	      int year = 0;
	      int month = 0;
	      int day = 0;

	      if(data == null || data.length() < 8) return "00000000";

	      try {
	        year = Integer.parseInt(data.substring(0, 4));
	        month = Integer.parseInt(data.substring(4, 6)) - 1;
	        day = Integer.parseInt(data.substring(6, 8));
	      } catch(NumberFormatException nfe) {
	        return "00000000";
	      }

	      Calendar cdate = new GregorianCalendar(year, month, day);
	      cdate.add(Calendar.DATE, dayCount);
	      Date date = cdate.getTime();

	      SimpleDateFormat sdf = new SimpleDateFormat(format);
	      return sdf.format(date);

	    } catch(Exception ex) {
	      return "00000000";
	    }
	  }
	  /**
	   * 특정일자의 지정된 날수 이전/이후의 시간을 yyyyMMddHHmmss 으로 반환
	   *
	   * @param   data   지정일자 (yyyyMMdd)
	   * @param   monCount   현재일로 부터의 지정된 시간 (+/-)
	   * @return  Default 표현형식에 따른 일자/시간
	   */
	  public static String getDateFormatFromTime(String data, int monCount) {
	    return getDateFormatFromTime(null, data, monCount);
	  }
	  /**
	   * 특정일자의 지정된 날수 이전/이후의 일자/시간을 표현형식대로 반환
	   *
	   * @param   format   표현하고자 하는 형식을 지정
	   * @param   data   지정일자 (yyyyMMdd)
	   * @param   monCount   현재일로 부터의 지정된 시간 (+/-)
	   * @return   표현형식에 따른 일자/시간
	   */
	  public static String getDateFormatFromTime(String format, String data, int monCount) {

	    try {

	      int year  = 0;
	      int month = 0;
	      int day   = 0;
	      int hour  = 0;
	      int minute= 0;
	      int secound = 0;

	      if(format == null) format =  "yyyyMMddHHmmss";
	      if(data == null || data.length() < 14) return "00000000000000";

	      try {
	        year = Integer.parseInt(data.substring(0, 4));
	        month = Integer.parseInt(data.substring(4, 6)) - 1;
	        day = Integer.parseInt(data.substring(6, 8));
	        hour = Integer.parseInt(data.substring(8, 10));
	        minute = Integer.parseInt(data.substring(10, 12));
	        secound = Integer.parseInt(data.substring(10, 12));
	      } catch(NumberFormatException nfe) {
	        return "00000000000000";
	      } 

	      Calendar cdate = new GregorianCalendar(year, month, day, hour, minute, secound);
	      cdate.add(Calendar.HOUR_OF_DAY, monCount);
	      Date date = cdate.getTime();

	      SimpleDateFormat sdf = new SimpleDateFormat(format);
	      return sdf.format(date);

	    } catch(Exception ex) {
	      return "00000000000000";
	    }
	  }
	  /**
	   * 특정일자의 지정된 날수 이전/이후의 일자/시간을 Default Fromat 으로 반환
	   *
	   * @param   data   지정일자 (yyyyMMdd)
	   * @param   monCount   현재일로 부터의 지정된 월수 (+/-)
	   * @return  Default 표현형식에 따른 일자/시간
	   */
	  public static String getDateFormatFromMonth(String data, int monCount) {
	    return getDateFormatFromMonth(DFT_FORMAT, data, monCount);
	  }
	  /**
	   * 특정일자의 지정된 날수 이전/이후의 일자/시간을 표현형식대로 반환
	   *
	   * @param   format   표현하고자 하는 형식을 지정
	   * @param   data   지정일자 (yyyyMMdd)
	   * @param   monCount   현재일로 부터의 지정된 월수 (+/-)
	   * @return   표현형식에 따른 일자/시간
	   */
	  public static String getDateFormatFromMonth(String format, String data, int monCount) {

	    try {

	      int year  = 0;
	      int month = 0;
	      int day   = 0;

	      if(data == null || data.length() < 8) return "00000000";

	      try {
	        year = Integer.parseInt(data.substring(0, 4));
	        month = Integer.parseInt(data.substring(4, 6)) - 1;
	        day = Integer.parseInt(data.substring(6, 8));
	      } catch(NumberFormatException nfe) {
	        return "00000000";
	      }

	      Calendar cdate = new GregorianCalendar(year, month, day);
	      cdate.add(Calendar.MONTH, monCount);
	      Date date = cdate.getTime();

	      SimpleDateFormat sdf = new SimpleDateFormat(format);
	      return sdf.format(date);

	    } catch(Exception ex) {
	      return "00000000";
	    }
	  }

	  /**
	   * 특정일자의 지정된 날수 이전/이후의 일자/시간을 Default Fromat 으로 반환
	   * 
	   * @param   data   지정일자 (yyyyMMdd)
	   * @param   yearCount   현재일로 부터의 지정된 월수 (+/-)
	   * @return  Default 표현형식에 따른 일자/시간
	   */
	  public static String getDateFormatFromYear(String data, int yearCount) {
	    return getDateFormatFromYear(DFT_FORMAT, data, yearCount);
	  }

	  /**
	   * 특정일자의 지정된 날수 이전/이후의 일자/시간을 표현형식대로 반환
	   *
	   * @param   format   표현하고자 하는 형식을 지정
	   * @param   data   지정일자 (yyyyMMdd)
	   * @param   yearCount   현재일로 부터의 지정된 월수 (+/-)
	   * @return   표현형식에 따른 일자/시간
	   */
	  public static String getDateFormatFromYear(String format, String data, int yearCount) {

	    try {

	      int year = 0;
	      int month = 0;
	      int day = 0;

	      if(data == null || data.length() < 8) return "00000000";

	      try {
	        year = Integer.parseInt(data.substring(0, 4));
	        month = Integer.parseInt(data.substring(4, 6)) - 1;
	        day = Integer.parseInt(data.substring(6, 8));
	      } catch(NumberFormatException nfe) {
	        return "00000000";
	      }

	      Calendar cdate = new GregorianCalendar(year, month, day);
	      cdate.add(Calendar.YEAR, yearCount);
	      Date date = cdate.getTime();

	      SimpleDateFormat sdf = new SimpleDateFormat(format);
	      return sdf.format(date);

	    } catch(Exception ex) {
	      return "00000000";
	    }
	  }
	  /**
	   * 해당월의 말일을 return 함,
	   * @param yyyy String yyyy 형식의 년
	   * @param mm String 월
	   * @return 말일의 날짜 , String
	   */
	    public static String getLastDay(String yyyy, String mm) {
	      try{
	        GregorianCalendar gcal = new GregorianCalendar(Integer.parseInt(yyyy), Integer.parseInt(mm)-1, 1);
	        int lday = gcal.getActualMaximum(gcal.DAY_OF_MONTH);
	        if(lday < 10){
	          return "0" + lday;
	        } else {
	          return "" + lday;
	        }
	      } catch (NumberFormatException ne){
	        return "잘못된 날짜입니다.";
	      }

	    }
	    
	    /**
	     * 입력날짜의 요일 구하기
	     * @param date
	     * 		- String 20130101
	     * @return
	     */
	    public static String getWeek(String date) {
	    	if (date == null || String.valueOf(Long.parseLong(date.replaceAll("-", ""))).length() != 8) {
	    		return date;
	    	}
	    	date = String.valueOf(Long.parseLong(date.replaceAll("-", "")));
	    	return getWeek(Integer.parseInt(date.substring(0, 4)), Integer.parseInt(date.substring(4, 6)), Integer.parseInt(date.substring(6, 8)));
	    }
	    /**
	     * 오늘날짜의 요일 구하기
	     * @param date
	     * @return
	     */
	    public static String getWeek() {
	    	String date = getInstance().getDate("yyyymmdd");
	    	return getWeek(Integer.parseInt(date.substring(0, 4)), Integer.parseInt(date.substring(4, 6)), Integer.parseInt(date.substring(6, 8)));
	    }
	    public static String getWeek (int year, int month, int day) {
	    	String week_day = "";
	    	
	    	if (month == 1 || month == 2) year--;
	    	month = (month + 9) % 12 + 1;
	    	int y = year % 100;
	    	int century =  year / 100;
	    	int week = ((13 * month - 1) / 5 + day + y + y / 4 + century / 4 - 2 * century) % 7;
	    	if (week < 0) week = (week + 7) % 7;
	    	
	    	switch (week) {
	    		case 0:
	    			week_day = "일";
	    			break;
	    		case 1:
	    			week_day = "월";
	    			break;
	    		case 2:
	    			week_day = "화";
	    			break;
	    		case 3:
	    			week_day = "수";
	    			break;
	    		case 4:
	    			week_day = "목";
	    			break;
	    		case 5:
	    			week_day = "금";
	    			break;
	    		case 6:
	    			week_day = "토";
	    			break;
	    	}
	    	
	    	return week_day;
	    }
	    
	    
}