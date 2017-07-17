<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%> 
<%@ page contentType="text/html;charset=UTF-8" %>
<!doctype html>
<html>
<head>
<title>게시판</title>
<meta http-equiv="content-type" content="text/html; charset=utf-8">
</head>
<body>
	<c:import url="/WEB-INF/views/includes/header.jsp" />
	<table border="1" style="border-color: pink; border-style: double;">
		<thead>
			<tr>
				<td>NO</td>
				<td>제목</td>
				<td>작성자</td>
				<td>조회수</td>
			</tr>
		</thead>
		<c:forEach items="${list }" var="board">
			<!-- 클릭시 게시물로 이동 -->
			<!-- PathVariable 방식으로!! -->
			<tr>
				<td>${board.no }</td>
				<td><a href="${pageContext.request.contextPath }/board/${board.no }">${board.title }</a></td>
				<td>${board.name }</td>
				<td>${board.hit }</td>
			</tr>
		</c:forEach>
	</table>
	<a href="${pageContext.request.contextPath }/board/writeform">글쓰기</a>
	
	<!-- a태그로 구현 -->
	<c:if test="${previousPage != -1}"><a href="${pageContext.request.contextPath }/board?page=${previousPage }">◀</a></c:if>
	
	<!-- begin부터 end까지 for문을 돌린다 -->
	<c:forEach begin="${pageBlockFirstPage }" end="${pageBlockLastPage }" varStatus="page">
		<!-- begin의 값부터 시작해서 1씩 더해서 end까지 도달한다 -->
		<a href="${pageContext.request.contextPath }/board?page=${page.index }">${page.index }</a>
	</c:forEach>
	
	<!-- 버튼으로 구현 -->
	<c:if test="${nextPage != -1 }"><input type="button" value="▶" onclick="location.href='${pageContext.request.contextPath }/board?page=${nextPage }'"></c:if>
</body>
</html>