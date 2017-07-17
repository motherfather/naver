<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ page contentType="text/html;charset=UTF-8"%>
<!doctype html>
<html>
<head>
<title>글수정</title>
<meta http-equiv="content-type" content="text/html; charset=utf-8">
</head>
<body>
	<c:import url="/WEB-INF/views/includes/header.jsp" />
	<form action="${pageContext.request.contextPath }/board/modify" method="post">

		<!-- 수정할 글의 번호도 알아야 하므로 -->
		<input type="hidden" value="${board.no }" name="no">
		<table border="1" style="border-style: dotted;">
			<tr>
				<!-- 제목을 누르면 id값이 title에 포커스! -->
				<th><label for="title">제목</label></th>
				<td><input type="text" id="title" name="title" value="${board.title }"></td>
			</tr>
			<tr>
				<th><label for="content">내용</label></th>
				<td><textarea rows="5" cols="50" id="content" name="content"
						placeholder="내용">${board.content }</textarea></td>
			</tr>
		</table>
		<a href="javascript:history.back()">취소</a> 
		<input type="submit" value="글수정">
	</form>
</body>
</html>