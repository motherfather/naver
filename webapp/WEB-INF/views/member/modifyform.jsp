<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page contentType="text/html;charset=UTF-8"%>
<!doctype html>
<html>
<head>
<title>회원정보수정</title>
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

<script type="text/javascript">
// 함수 바로 실행
$(function() {
	// 회원가입 페이지에서 부분적으로 수정해서 사용하면 됨!! 상당히 비슷하므로!!
	// 회원정보 수정페이지에서 회원가입 버튼 눌렀을 때 함수가 실행된다는 뜻
	$("#modify").submit(function() {
		
		// 1. 이름 체크
		if ($("#name").val() == "") {
			$("#dialog").text("이름은 필수 입력 항목입니다.");
			$("#dialog").dialog();
			$("#name").focus();
			return false;
		} else if ($("#name").val().length < 2 || $("#name").val().length > 10) {
			$("#dialog").text("이름은 2자 이상 10이하입니다");
			$("#dialog").dialog();
			$("#name").focus();
			return false;
		}
		
		// 2. 비밀번호 체크
		if ($("#password").val() == "") {
			$("#dialog").text("비밀번호는 필수 입력 항목입니다.");
			$("#dialog").dialog();
			$("#password").focus();
			return false;
		} else if ($("input[type='password']").val().length < 4) { // input중에서 type이 password인것을 찾음
			$("#dialog").text("비밀번호는 최소 4자리 이상입니다.");
			$("#dialog").dialog();
			$("#password").focus();
			return false;
		} else if (/[^a-zA-Z0-9_]+/.test($("#password").val())) { // 알파벳대소문자, 숫자, _(언더바)만 비밀번호로 가능!!
			$("#dialog").text("비밀번호에 특수문자는 허용되지 않습니다.");
			$("#dialog").dialog();
			$("#password").focus();
			return false;
		}
		
		// 3. 성별 체크
		if (!$("input[type=radio]").is(":checked")) { // 셀렉터 사용 이유 : https://okky.kr/article/223676
			$("#dialog").text("성별을 필수 선택 항목입니다.");
			$("#dialog").dialog();
			$("#gender").focus();
			return false;
		}
		// alert($("input[type=radio]:checked").val()); // 셀렉터 사용 이유 : https://okky.kr/article/223676
		
		return true;
	});
});
</script>
</head>
<body>
	<c:import url="/WEB-INF/views/includes/header.jsp" />
	<form:form action="${pageContext.request.contextPath }/member/modify"
		method="POST" modelAttribute="memberVo" id="modify">
	Email : ${memberVo.email }
	<!-- 스프링 form 태그는 알아서 데이터가 이름에 맞는 path에 자동으로 들어감 -->
	<!-- 패스워드는 타입이 패스워드라서 안들어감!! -->
	Password : <form:password path="password" />
		<p style="color: red">
			<form:errors path="password" />
		</p>
	Name :	<form:input path="name" />
		<p style="color: red">
			<form:errors path="name" />
		</p>
	<!-- 스프링 form이 아니라서 value를 적어야 데이터를 받아옴 -->
	Phone : <input name="phone" id="phone" value="${memberVo.phone }"/> <br><br>
	<form:radiobutton path="gender" value="male" label="남자" />
	<form:radiobutton path="gender" value="female" label="여자" />
	<!-- 스프링 form태그 안쓰고 하는 방법
	<fieldset>
		<legend>성별</legend>
		남자<input type="radio" name="gender" value="male" >
		여자<input type="radio" name="gender" value="female">
	</fieldset>
	 -->
	<p style="color: red">
		<form:errors path="gender"/>
	</p>
		<a href="javascript:history.back();">취소</a>
		<input type="submit" value="회원정보수정">
	</form:form>
	<div id="dialog" title="회원가입 유효성 검사창" style="display: none"></div>
</body>
</html>