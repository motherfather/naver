<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ page contentType="text/html;charset=UTF-8"%>
<!doctype html>
<html>
<head>
<title>글쓰기</title>
<meta http-equiv="content-type" content="text/html; charset=utf-8">
</head>
<body>
	<c:import url="/WEB-INF/views/includes/header.jsp" />
	<form action="${pageContext.request.contextPath }/board/write" method="post">
		<table border="1" style="border-style: dotted;">
			<tr>
				<!-- 제목을 누르면 id값이 title에 포커스! -->
				<th><label for="title">제목</label></th>
				<td><input type="text" id="title" name="title" placeholder="제목"></td>
			</tr>
			<tr>
				<th><label for="content">내용</label></th>
				<td><textarea rows="5" cols="50" id="content" name="content"
						placeholder="내용"></textarea></td>
			</tr>
		</table>
		<a href="${pageContext.request.contextPath }/board">취소</a>
		<input type="submit" value="글쓰기">
	</form>
</body>
</html>