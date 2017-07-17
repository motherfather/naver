<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%> 
<%@ page contentType="text/html;charset=UTF-8" %>
<!doctype html>
<html>
<head>
<title>갤러리</title>
<meta http-equiv="content-type" content="text/html; charset=utf-8">
<link type="text/css" rel="stylesheet"
	href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">

<script type="text/javascript"
	src="https://code.jquery.com/jquery-1.12.4.js"
	integrity="sha256-Qw82+bXyGq6MydymqBxNPYTaUXXq7c8v3CwiYwLLNXU="
	crossorigin="anonymous"></script>

<script type="text/javascript"
	src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"
	integrity="sha256-T0Vest3yCU7pafRw9r+settMBX6JkKN06dqBnpQ8d30="
	crossorigin="anonymous"></script>

<script>
$(document).on("click", "#gallery img", function() {
	// 팝업 구현은 http://demun.tistory.com/2440 참고!!
})
</script>
</head>
<body>
	<c:import url="/WEB-INF/views/includes/header.jsp" />
	<a href="${pageContext.request.contextPath }/gallery/uploadform">사진올리기</a><br>
	<div id="gallery">
	<c:forEach items="${list }" var="gallery">
		<li id="${gallery.no }" style="display: inline-block; border-left: 5px solid pink; background: rgba(255, 255, 0, 0.2)"> <!-- #xxxxxx 대신 rgba사용 red, green, blue, alpha(투명도) -->
			<img src="${pageContext.request.contextPath }/gallery/image/${gallery.image }" style="width: 100px; border-color: red; border-style: solid; border-radius: 5px;">
			<p>${gallery.title }</p>
		</li>
	</c:forEach>
	</div>
</body>
</html>