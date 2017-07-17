<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page contentType="text/html;charset=UTF-8"%>
<%
	pageContext.setAttribute("newLine", "\n");
%>
<!doctype html>
<html>
<head>
<title>방명록</title>
<meta http-equiv="content-type" content="text/html; charset=utf-8">
</head>
<body>
	<c:import url="/WEB-INF/views/includes/header.jsp" />
	<form:form action="${pageContext.request.contextPath }/guestbook/write"
		method="POST" modelAttribute="guestbookVo" id="write">
		작성자 : <form:input path="name" />
		비밀번호 : <form:password path="password" />
		내용 : <form:textarea path="content"/>
		<input type="submit" value="작성" />
	</form:form>
	<c:forEach items="${list }" var="guestbook">
		${guestbook.name }
		${guestbook.reg_date }<br>
		${fn:replace(guestbook.content, newLine, "<br>")}<br>
	</c:forEach>
</body>
</html>