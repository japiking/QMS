<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
    
<%@ include file="/jsp/inc/inc_header.jsp" %>

<%
	
	
	
%>
<script type="text/javascript">

</script>
<center><h3>등록된 시나리오/케이스</h3></center>
<form name="ff1" method="post">
<table>
<div class="btnWrapL">
		<a href="#FIT" class="btn" onclick="javascript:ff_regist();"><span>등록</span></a>
		<a href="#FIT" class="btn" onclick="javascript:ff_update();"><span>수정</span></a>
		<a href="#FIT" class="btn" onclick="javascript:ff_delete();"><span>삭제</span></a>
		<a href="#FIT" class="btn" onclick="javascript:ff_select();"><span>선택완료</span></a>
		<a href="#FIT" class="btn" onclick="javascript:ff_mylist();"><span>내목록</span></a>
	</div>
<div class="wrap">
	<table>
		<colgroup>
			<col width="5%"/>
			<col width="5%"/>
			<col width="15%"/>
			<col width="15%"/>
		</colgroup>
		<tbody>
				<tr>
					<th scope="row" style="text-align: center;">선택</th>
					<th scope="row" style="text-align: center;">순서</th>
					<th scope="row" style="text-align: center;">시나리오 명</th>
					<th scope="row" style="text-align: center;">실행일</th>
				</tr>
				
				<tr>
					<td scope="row" style="checkbox-align:center;"></td>
					<td scope="row" style="text-align:center;"></td>
					<td scope="row" style="text-align:center;"></td>
					<td scope="row" style="text-align:center;"></td>
					
				</tr>
		</tbody>
	</table>	
</div>	
<form="ff2" method="post">
<div class="wrap">
	<table>
		<colgroup>
			<col width="5%"/>
			<col width="5%"/>
			<col width="15%"/>
			<col width="15%"/>
		</colgroup>
		<tbody>
				<tr>
					<th scope="row" style="text-align: center;">선택</th>
					<th scope="row" style="text-align: center;">테스트 목록</th>
					<th scope="row" style="text-align: center;">시나리오 건수</th>
					<th scope="row" style="text-align: center;">케이스 건수</th>
				</tr>
				
			<tr>
					<td scope="row" style="checkbox-align:center;"></td>
					<td scope="row" style="text-align:center;"></td>
					<td scope="row" style="text-align:center;">건</td>
					<td scope="row" style="text-align:center;">건</td>
			</tr>	
		</tbody>
	</table>	
</div>	
</form>