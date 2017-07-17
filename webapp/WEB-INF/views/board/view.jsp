<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%> 
<%@ page contentType="text/html;charset=UTF-8" %>
<%
	// 줄바꾸기는 3개중 뭐가 정확한지... 운영체제마다 다르고 그런듯...
	pageContext.setAttribute("cr", "\r"); // 줄바꾸기
	pageContext.setAttribute("cn", "\n"); // 줄바꾸기
	pageContext.setAttribute("crcn", "\r\n"); // 줄바꾸기
	pageContext.setAttribute("sp", "&nbsp;"); // 스페이스
	pageContext.setAttribute("br", "<br/>"); // 개행태그
%> 
<!doctype html>
<html>
<head>
<title>${board.title }</title>
<meta http-equiv="content-type" content="text/html; charset=utf-8">
</head>
<body>
	<c:import url="/WEB-INF/views/includes/header.jsp" />
	<table>
		<tr>
			<th>제목</th>
			<td>${board.title }</td>
			<th>조회수</th>
			<td>${board.hit }</td>
		</tr>
		<tr>
			<th>작성자</th>
			<td>${board.name }</td>
			<th>작성일</th>
			<td>${board.reg_date }</td>
		</tr>
		<tr>
			<td>
				<!-- 게시물 내용의 개행과 띄어쓰기 처리 (하지않으면 한줄로 쭉나옴)-->
				${fn:replace(fn:replace(board.content, crcn, br), ' ', sp) }
			</td>
		</tr>
	</table>
	<a href="" onclick="history.back();">뒤로가기</a> <!-- 자바스크립트 이용 뒤로가기 -->
	<!-- <a href="javascript:history.back()">뒤로가기</a> 이렇게 해도 됨... ☆★☆★☆★☆★☆★☆★☆★ 이 방법이 더 좋은듯 주소가 안떠서!! -->
	<!-- history.back()은 history.go(-1)과 같음!! go에 1을 쓰면 앞으로! 2는 두페이지 앞으로! -2는 두페이지 뒤로!-->
	
	<!-- 글 작성자일 경우 삭제버튼이 보임-->
	<c:if test="${loginInfo.no == board.mem_no }">
		<button type="button" onclick="deleteDialog();">삭제</button> <!-- 삭제버튼 누르면 자바스크립트의 deleteDialog()함수 작동 -->
		<a href="${pageContext.request.contextPath }/board/modifyform?no=${board.no }">수정</a> <!-- 수정버튼 (a태그로 구현) -->
		<input type="hidden" id="board_no" value="${board.no }"> <!-- 게시물no값을 자바스크립트에서 바로 받을수 없어서 넘기려면 이렇게 해야한다고 함! -->
		<script>
			function deleteDialog() { // 삭제버튼 누르면 실행되는 confirm 메시지박스
				var deleteBox = confirm("삭제하시겠습니까?");
				if (deleteBox == true) { // 확인누르면 true로
					var board_no = document.getElementById("board_no").getAttribute("value"); // 순수자바스크립트(Jquery X)
					location.href="${pageContext.request.contextPath }/board/delete?no=" + board_no;
					return false;
				} else { // 취소누르면 false로 
					return false;
				}
			}
		</script>
	</c:if>
</body>
</html>