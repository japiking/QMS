<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<%@ include file="/jsp/inc/inc_header.jsp" %>	

<form name="frm" method="post">
<h3>개발관련사이트</h3>
	<div class="wrap">
		<table id="tbl001" class="list">
			<colgroup>
				<col width="20%" />
				<col width="20%" />
				<col width="50%" />
			</colgroup>
			<thead>
				<tr>
					<th scope="col">구분</th>
					<th scope="col">업무</th>
					<th scope="col">접속URL</th>
				</tr>
			</thead>
			<tbody id="user_list">
				<tr>
					<td>기존개발</td>
					<td>개인개발(1)</td>
					<td><a href="javascript:window.open('http://dev1.hanabank.com:8100');">http://dev1.hanabank.com:8100</a></td>
				</tr>
				<tr>
					<td></td>
					<td>개인개발(2)</td>
					<td><a href="javascript:window.open('http://dev2.hanabank.com:8100');">http://dev2.hanabank.com:8100</a></td>
				</tr>
				<tr>
					<td></td>
					<td>개인개발(3)</td>
					<td><a href="javascript:window.open('http://dev3.hanabank.com:8100');">http://dev3.hanabank.com:8100</a></td>
				</tr>
				<tr>
					<td></td>
					<td>오픈개발(1)</td>
					<td><a href="javascript:window.open('http://dev1.open.hanabank.com:8107');">http://dev1.open.hanabank.com:8107</a></td>
				</tr>
				<tr>
					<td></td>
					<td>오픈개발(2)</td>
					<td><a href="javascript:window.open('http://dev2.open.hanabank.com:8107');">http://dev2.open.hanabank.com:8107</a></td>
				</tr>
				<tr>
					<td></td>
					<td>CBS개발(1)</td>
					<td><a href="javascript:window.open('http://dev1.cbs.hanabank.com:8300');">http://dev1.cbs.hanabank.com:8300</a></td>
				</tr>
				<tr>
					<td></td>
					<td>CBS개발(2)</td>
					<td><a href="javascript:window.open('http://dev2.cbs.hanabank.com:8300');">http://dev2.cbs.hanabank.com:8300</a></td>
				</tr>
				<tr>
					<td></td>
					<td>BT 개발 테스터</td>
					<td><a href="javascript:window.open('http://111.60.3.65:7101/tester/');">http://111.60.3.65:7101/tester/</a></td>
				</tr>
				<tr>
					<td>기존테스트</td>
					<td>BT 개발 테스터</td>
					<td><a href="javascript:window.open('http://111.60.3.70:7101/tester/');">http://111.60.3.70:7101/tester/</a></td>
				</tr>
				<tr>
					<td></td>
					<td>개인뱅킹</td>
					<td><a href="javascript:window.open('http://111.60.3.31:8180');">http://111.60.3.31:8180</a></td>
				</tr>
				<tr>
					<td></td>
					<td>오픈뱅킹</td>
					<td><a href="javascript:window.open('http://stg.open.hanabank.com:8107');">http://stg.open.hanabank.com:8107</a></td>
				</tr>
				<tr>
					<td></td>
					<td>CBS</td>
					<td><a href="javascript:window.open('http://111.60.3.31:8282/common/main.do');">http://111.60.3.31:8282/common/main.do</a></td>
				</tr>
				<tr>
					<td>운영</td>
					<td>개인뱅킹</td>
					<td><a href="javascript:window.open('http://www.hanabank.com');">http://www.hanabank.com</a></td>
				</tr>
				<tr>
					<td></td>
					<td>오픈뱅킹</td>
					<td><a href="javascript:window.open('http://open.hanabank.com');">http://open.hanabank.com</a></td>
				</tr>
				<tr>
					<td></td>
					<td>CBS</td>
					<td><a href="javascript:window.open('http://www.hanacbs.com/common/main.do');">http://www.hanacbs.com/common/main.do</a></td>
				</tr>
				<tr>
					<td>신규개발</td>
					<td>오픈개발</td>
					<td><a href="javascript:window.open('http://dev3.open.hanabank.com:8107');">http://dev3.open.hanabank.com:8107</a></td>
				</tr>
				<tr>
					<td></td>
					<td>CBS개발(3)</td>
					<td><a href="javascript:window.open('http://dev3.cbs.hanabank.com:8300');">http://dev3.cbs.hanabank.com:8300</a></td>
				</tr>
				<tr>
					<td></td>
					<td>QMS</td>
					<td><a href="javascript:window.open('http://111.60.3.41:29091/QMS/jsp/main.jsp');">http://111.60.3.41:29091/QMS/jsp/main.jsp</a></td>
				</tr>
				<tr>
					<td>텔넷접속</td>
					<td>오픈/CBS</td>
					<td><a href=111.60.3.43>111.60.3.43</a></td>
				</tr>
				
			</tbody>
		</table>
	</div>
</form>		