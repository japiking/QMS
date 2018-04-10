<%@page import="qms.util.LogUtil"%>
<%@page import="qms.db.DBConnectManager"%>
<%@page language="java" contentType="text/html; charset=EUC-KR"	pageEncoding="EUC-KR"%>
<%@page import="qms.util.PropertyUtil"%>
<%
try{
	PropertyUtil.getInstance().reload();
	out.println("프로퍼티 리로드가 완료되었습니다.<br/>");
	
}catch(Exception e){
	e.printStackTrace(System.out);
	out.println("프로퍼티 리로드가 실패되었습니다.");
}
try{
	DBConnectManager.getInstance().reload();
	out.println("DB SQL 리로드가 완료되었습니다.<br/>");
}catch(Exception e){
	e.printStackTrace(System.out);
	e.printStackTrace(System.err);
	LogUtil.getInstance().error(e);
	out.println("DB SQL 리로드가 실패되었습니다.<br/>");
}
%>