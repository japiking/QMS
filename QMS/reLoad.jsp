<%@page import="qms.util.LogUtil"%>
<%@page import="qms.db.DBConnectManager"%>
<%@page language="java" contentType="text/html; charset=EUC-KR"	pageEncoding="EUC-KR"%>
<%@page import="qms.util.PropertyUtil"%>
<%
try{
	PropertyUtil.getInstance().reload();
	out.println("������Ƽ ���ε尡 �Ϸ�Ǿ����ϴ�.<br/>");
	
}catch(Exception e){
	e.printStackTrace(System.out);
	out.println("������Ƽ ���ε尡 ���еǾ����ϴ�.");
}
try{
	DBConnectManager.getInstance().reload();
	out.println("DB SQL ���ε尡 �Ϸ�Ǿ����ϴ�.<br/>");
}catch(Exception e){
	e.printStackTrace(System.out);
	e.printStackTrace(System.err);
	LogUtil.getInstance().error(e);
	out.println("DB SQL ���ε尡 ���еǾ����ϴ�.<br/>");
}
%>