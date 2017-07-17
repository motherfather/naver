<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%> 
<%@ page contentType="text/html;charset=UTF-8" %>
<!doctype html>
<html>
<head>
<title>사진올리기</title>
<meta http-equiv="content-type" content="text/html; charset=utf-8">
</head>
<body>
	<c:import url="/WEB-INF/views/includes/header.jsp" />
	
	<!-- 파일 업로드시 필수 !! enctype="multipart/form-data" -->
	<!-- 안쓰면 웹 서버로 데이터를 넘길때 파일의 경로명만 전송되고 파일 내용이 전송되지 않음 -->
	<form action="${pageContext.request.contextPath }/gallery/upload" method="post" enctype="multipart/form-data">
		<table border="1" style="border-color: red;">
			<tr>
				<th>제목</th>
				<td><input type="text" name="title"></td>
			</tr>
			<tr>
				<td colspan="2"><textarea rows="5" cols="" name="content" placeholder="내용"></textarea></td>
			</tr>
		</table>
		<input type="file" name="file">
		<input type="submit" value="이미지 올리기">
	</form>
</body>
</html>