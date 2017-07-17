<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%> 
<%@ page contentType="text/html;charset=UTF-8" %>
<!doctype html>
<html>
<head>
<title>로그인</title>
<meta http-equiv="content-type" content="text/html; charset=utf-8">
</head>
<body>
	<c:import url="/WEB-INF/views/includes/header.jsp" />
	<form action="${pageContext.request.contextPath }/member/login" method="post">
		<input type="email" name="email" placeholder="Email">
		<input type="password" name="password" placeholder="PASSWORD">
		<c:if test="${param.loginresult == 'loginfail' }">
			<p>실패</p>
		</c:if>
		<input type="submit" value="로그인">
	</form>
</body>
</html>