package qms.exception;


import java.io.PrintStream;
import java.io.PrintWriter;

import qms.util.DataMap;

public class BizException extends Exception
{
  private static final long serialVersionUID = 4062279525686791278L;
  private String targetURL;
  private DataMap dataMap;
  private String errorCode;
  private String userMessage;
  private Throwable cause;

  public DataMap getDataMap()
  {
    return this.dataMap;
  }

  public BizException()
  {
  }

  public BizException(String errorCode)
  {
	  this(errorCode, "BizException");
  }

  public BizException(String errorCode, String msg)
  {
	  super(msg);
	  this.errorCode = errorCode;
	  this.userMessage = msg;
  }

  public BizException(String errorCode, String msg, Throwable cause)
  {
	  this(errorCode, msg);
	  setCause(cause);
  }

  public BizException(String errorCode, String msg, String targetURL)
  {
	  this(errorCode, msg);
	  this.targetURL = targetURL;
	  if (targetURL == null) this.targetURL = "";
  }

  public BizException(Throwable ex)
  {
	  this.cause = ex;
	  if ((ex instanceof BizException)) {
		  this.errorCode = ((BizException)ex).getErrorCode();
		  this.userMessage = ((BizException)ex).getMessage();
	  }
  }

  public BizException(String errorCode, DataMap dataMap)
  {
    this(errorCode, "BizException");
    this.dataMap = dataMap;
  }

  public BizException(String errorCode, String msg, DataMap dataMap)
  {
    this(errorCode, msg);
    this.dataMap = dataMap;
  }

  public BizException(String errorCode, String msg, DataMap dataMap, Throwable ex)
  {
    this(errorCode, msg);
    this.dataMap = dataMap;
    setCause(ex);
  }

  public BizException(String errorCode, String msg, String targetURL, DataMap dataMap)
  {
    this(errorCode, msg, targetURL);
    this.dataMap = dataMap;
  }

  public BizException(Throwable ex, DataMap dataMap)
  {
    this(ex);
    this.dataMap = dataMap;
  }

  public String getTargetURL() {
    return this.targetURL;
  }
  
  public String getErrorCode() {
	    return this.errorCode;
  }

  public String getMessage() {
	    return this.userMessage;
  }
  
  public Throwable getCause()
  {
    return this.cause == this ? null : this.cause;
  }
  
  public String getTrace() {
    if (this.cause != null) {
      return ExceptionTracer.getTraceString(this.cause);
    }
    return ExceptionTracer.getTraceString(this);
  }

  public void printStackTrace()
  {
    if (this.cause != null)
      System.err.println(getTrace());
    else
      super.printStackTrace();
  }

  public void printStackTrace(PrintWriter pw)
  {
    if (this.cause != null)
      pw.println(getTrace());
    else
      super.printStackTrace(pw);
  }

  public void printStackTrace(PrintStream pw)
  {
    if (this.cause != null)
      pw.println(getTrace());
    else
      super.printStackTrace(pw);
  }

  public void setCause(Throwable cause)
  {
    this.cause = cause;
  }
  
}