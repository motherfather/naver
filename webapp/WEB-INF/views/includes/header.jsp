<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ page contentType="text/html;charset=UTF-8"%>
<!-- header CSS -->
<style>
#header {
	width: 800px;
	height: 100px;
	background-color: gray;
}
</style>

<div id="header">
	<a href="${pageContext.request.contextPath }">홈</a> 
	<a href="${pageContext.request.contextPath }/guestbook">방명록</a> 
	<a href="${pageContext.request.contextPath }/guestbook/ajax">방명록(ajax)</a>
	<a href="${pageContext.request.contextPath }/board">게시판</a>
	<a href="${pageContext.request.contextPath }/gallery">갤러리</a>
	<c:choose>
		<c:when test="${empty sessionLoginInfo }">
			<a href="${pageContext.request.contextPath }/member/loginform">로그인</a>
			<a href="${pageContext.request.contextPath }/member/joinform">회원가입</a>
		</c:when>
		<c:otherwise>
			<a
				href="${pageContext.request.contextPath }/member/modifyform">회원정보수정</a>
			<a href="${pageContext.request.contextPath }/member/logout">로그아웃</a>
		${sessionLoginInfo.name }님 로그인
	</c:otherwise>
	</c:choose>
</div>