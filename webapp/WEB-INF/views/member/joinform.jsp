<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page contentType="text/html;charset=UTF-8"%>
<!doctype html>
<html>
<head>
<title>회원가입</title>
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
	// 회원가입페이지에서 회원가입 버튼 눌렀을 때 함수가 실행된다는 뜻
	$("#join").submit(function() {
		
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
		
		// 3. 이메일 체크
		if (/\s/gi.test($("#email").val())) { // 공백문자 금지
			$("#dialog").text("이메일에 공백은 안됩니다.");
			$("#dialog").dialog();
			$("#email").focus();
			return false;
		} else if ($("#email").val() == "") {
			$("#dialog").text("이메일은 필수 입력 항목입니다.");
			$("#dialog").dialog();
			$("#email").focus();
			return false;
		} else if (!/^[0-9a-zA-Z_]+@[0-9a-zA-Z_]+\.[a-zA-Z]+$/.test($("#email").val())) { // 이메일 형식
			$("#dialog").text("이메일 형식이 아닙니다.");
			$("#dialog").dialog();
			$("#email").focus();
			return false;
		}
		
		// 4. 성별 체크
		if (!$("input[type=radio]").is(":checked")) { // 셀렉터 사용 이유 : https://okky.kr/article/223676
			$("#dialog").text("성별을 필수 선택 항목입니다.");
			$("#dialog").dialog();
			$("#gender").focus();
			return false;
		}
		// alert($("input[type=radio]:checked").val()); // 셀렉터 사용 이유 : https://okky.kr/article/223676
		
		// 5. 이메일 중복체크
		if (!$("#emailCheck").is(":disabled")) {
			$("#dialog").text("이메일 중복체크를 하세요.");
			$("#dialog").dialog();
			$("#emailCheck").focus();
			return false;			
		}
		return true;
	});
	
	// 이메일 변경시 다시 중복체크하게 하는 버튼 변경
	$("#email").change(function() {
		$("#emailCheck").attr('disabled', false); // 버튼 활성화
		$("#emailCheck").attr('value', '이메일 중복체크'); // 텍스트 변경
	});
	
	$("#emailCheck").click(function() {
		var email = $("#email").val();

		if (email == "") { // 이메일이 공백일경우
			return false;
		} else if (!/^[0-9a-zA-Z_]+@[0-9a-zA-Z_]+\.[a-zA-Z]+$/.test(email)) { // 이메일 형식이 아닐경우
			$("#dialog").text("이메일 형식이 아닙니다.");
			$("#dialog").dialog();
			$("#email").focus();
			return false;
		}
		
		// 이메일 중복체크용 ajax
		$.ajax({ 
			url:"${pageContext.request.contextPath }/member/emailcheck",
			type:"post",
			dataType:"text", // 컨트롤러에서 넘어오는 데이터의 타입
			data:"email=" + email,
			success:function(response) {
				if (response == "true") {
					$("#dialog").text("이메일이 이미 존재합니다.");
					$("#dialog").dialog();
					$("#email").focus();
					return false;
				} else {
					$("#emailCheck").attr('disabled', true); // 버튼 비활성화
					$("#emailCheck").attr('value', '사용가능한 이메일'); // 텍스트 변경
					return true;					
				}
			},
			error:function(jqXHR, status, e) {
				console.error(status + ":" + e);
			}
		});
	});
});
</script>
</head>
<body>
	<c:import url="/WEB-INF/views/includes/header.jsp" />
	<form:form action="${pageContext.request.contextPath }/member/join"
		method="POST" modelAttribute="memberVo" id="join">
		<!-- 스프링 form태그의 path는 id와 name을 합친것 같음 -->
	Email : <form:input path="email" />
	<input type="button" id="emailCheck" value="이메일 중복체크"/>
		<p style="color: red">
			<!-- 유효성 검사 결과를 클라이언트에서 보여줄려면 form:errors를 사용해야함!!!! -->
			<form:errors path="email" />
		</p>
	Password : <form:password path="password" />
		<p style="color: red">
			<form:errors path="password" />
		</p>
	Name :	<form:input path="name" />
		<p style="color: red">
			<form:errors path="name" />
		</p>
	Phone : <input name="phone" id="phone" /> <br><br>
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
		<input type="submit" value="회원가입">
	</form:form>
	<div id="dialog" title="회원가입 유효성 검사창" style="display: none"></div>
</body>
</html>