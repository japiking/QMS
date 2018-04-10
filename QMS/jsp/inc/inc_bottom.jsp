<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR" isErrorPage="true" %>

<!-- //wrap -->
<%	
	out.println("	</td>");
	//out.println("			<td>여백</td>	");		
// 	out.println("	</tr>");
	//out.println("	</tr>");
	out.println("	</table>");
%>
    <table class="noline">
		<colgroup>
<!-- 			<col width="250px"/> -->
<!-- 			<col width="500px"/> -->
			<col width="*"/>
		</colgroup>
		<tbody>
			<tr>
<!-- 				<td>&nbsp;</td> -->
				<td  style="text-align:center"><img height="20" src="/QMS/img/img_logo02.png"/></td>
<!-- 				<td>&nbsp;</td> -->
			</tr>
			<tr>
<!-- 				<td>&nbsp;</td> -->
				<td  style="text-align:center">Copyright(c) WEBCASHFIT. All rights reserved</td>
<!-- 				<td>&nbsp;</td> -->
			</tr>
		</tbody>
	</table>
<%

	//out.println("			<td>여백</td>	");		
	//out.println("	</tr>");
	
	
	if (qmsDB != null) try { qmsDB.close(); } catch (Exception e1) {}
%>
</body>
</html>