<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR" isErrorPage="true" %>
<%@page import="qms.Const"%>
<%@page import="qms.util.StringUtil"%>
<%@page import="java.io.*" %>
<%
	String returnURL	= StringUtil.null2void(request.getAttribute(Const.ERROR_RETURN_URL));
exception.printStackTrace();
%>

 <html>
  <head>
    <title>에러페이지</title>
    <script type="text/javascript">
    	function uf_return() {
    		// 에러출력후 이동할 화면
    		if( "<%=returnURL%>" == "POPUP" ) {
    			window.close();
    		} else if( "<%=returnURL%>" != "" ) {    			
    			top.location.href = "<%=returnURL%>";
    		} else {
    			// 인트로 화면
    			top.location.href = "<%=Const.URL_VIEW_INTRO%>";
    		}
    	}
    </script>
    <link rel="stylesheet" href="/QMS/css/guide.css" />
	<link rel="stylesheet" href="/QMS/css/guide_qms.css" />
  </head>
  <body>
  	<table style="width:500px; margin:20px auto;  margin-top:20px;">
  		<tr>
  			<td style="text-align:center;font-weight: bold;">에러 메세지</td>
  		</tr>
  		<tr>
  			<td><%=exception.toString()%></td>
  		</tr>
  		<tr>
  			<td><%=exception.getClass()%><br /><%=exception.getMessage()%></td>
  		</tr>
  		<tr>
  			<td style="text-align:center">
				<div class="btnWrapC">
					<a href="#" class="btn" onclick="javascript:uf_return();"><span id="">확인</span></a>
				</div>
			</td>
  		</tr>
  	</table>

  </body>
</html>