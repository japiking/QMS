<%@page language="java" contentType="text/html; charset=EUC-KR"	pageEncoding="EUC-KR"%>
<%@page import="java.io.File"%>
<%@page import="javax.xml.transform.stream.StreamResult"%>
<%@page import="javax.xml.transform.dom.DOMSource"%>
<%@page import="javax.xml.transform.Transformer"%>
<%@page import="javax.xml.transform.TransformerFactory"%>
<%@page import="org.w3c.dom.*"%>
<%@page import="javax.xml.parsers.*"%>
<%@ include file="/jsp/inc/inc_common.jsp" %>
<%
try{
	DocumentBuilderFactory docFactory 	= DocumentBuilderFactory.newInstance();
	DocumentBuilder docBuilder 			= docFactory.newDocumentBuilder();
	
	// root elements
	Document doc = docBuilder.newDocument();
	Element rootElement = doc.createElement("QMS");
	doc.appendChild(rootElement);
	
	List<Map<String,Object>> list = qmsDB.selectList("TEST_QUERY.TEST_USERINFO");

	// 조회된 데이터가있을 경우
	if(null != list && list.size() > 0){
		Map<String, Object> map = new HashMap<String, Object>();
		for(int i=0; i<list.size(); i++){
			map = list.get(i);
			
			// user elements
			Element user = doc.createElement("USER_INFO");
			rootElement.appendChild(user);
			user.setAttribute("SEQ", String.valueOf(i+1));
			
			// UserName elements
			Element userid = doc.createElement("USERID");
			userid.appendChild(doc.createTextNode(StringUtil.null2void(map.get("USERID"))));
			user.appendChild(userid);
			
			// UserName elements
			Element username = doc.createElement("USERNAME");
			username.appendChild(doc.createTextNode(StringUtil.null2void(map.get("USERNAME"))));
			user.appendChild(username);
			
			// UserPwd elements
			Element userpwd = doc.createElement("USERPASSWORD");
			userpwd.appendChild(doc.createTextNode(StringUtil.null2void(map.get("USERPASSWORD"))));
			user.appendChild(userpwd);
			
			// UserPwd elements
			Element user_birth = doc.createElement("BIRTHDAY");
			user_birth.appendChild(doc.createTextNode(StringUtil.null2void(map.get("BIRTHDATE"))));
			user.appendChild(user_birth);
			
			// UserManagementGrade elements
			Element user_grade = doc.createElement("GRADE");
			user_grade.appendChild(doc.createTextNode(StringUtil.null2void(map.get("MANAGEMENTGRADE"))));
			user.appendChild(user_grade);
		}
	}
	
	TransformerFactory transformerFactory = TransformerFactory.newInstance();
	Transformer transformer = transformerFactory.newTransformer();
	DOMSource source = new DOMSource(doc);
	StreamResult result = new StreamResult(new File("/home/qms/WebContent/uploadfile/test.xml"));
	transformer.transform(source, result);
	
	System.out.println("XML파일 작성 완료!");
}catch (Exception e) {
	e.printStackTrace();
	if (qmsDB != null) try { qmsDB.rollback(); } catch (Exception e1) {}
}finally{
	if (qmsDB != null) try { qmsDB.close(); } catch (Exception e1) {}
}

%>