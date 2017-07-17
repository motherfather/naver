<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%> 
<%@ page contentType="text/html;charset=UTF-8" %>
<!doctype html>
<html>
<head>
<title>방명록(ajax)</title>
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
var page = 0; // 스크롤 내릴떄마다 게스트북을 ajax로 더 가져오는 걸 구분
var isEnd = false; // 게스트북 마지막인지 확인

var renderGuestbook = function(vo, mode) { // ajax를 통해 가져온 게스트북을 화면에 띄우기  
																	// vo는 가져온 게스트북, mode는 가져온 게스트북을 앞 or 뒤 붙이는 위치
	
	var content = vo.content.replace(/\n/gi, '<br>').replace(/\s/gi, '&nbsp'); // 자바스크립트에서 개행을 처리 할려면 이렇게 해야하나보다... 기존방식이 안된다 ㅠㅠ
																											   // 띄어쓰기도 추가했다...
	
	// 이게 동적으로 태그를 만드는 거임!!!
	var htmls = "<li id='guestbook-" + vo.no + "'><br>작성자 " + vo.name + "<br>작성일 " + vo.reg_date + "<br>" 
					+ content + "<br><a href='' guestbook-no='" + vo.no + "'>삭제</a><br><br></li>"; // 이게 게스트북 틀을 만듬
						
	if (mode) { // true이면 새로 작성한 게스트북으로써 맨위에 출력
		$("#guestbook").prepend(htmls);
	} else { // false이면 DB에서 가져온 게스트북으로써 최신게스트북이 위에 출력
		$("#guestbook").append(htmls);
	}
}

var loadGuestbook = function() {
	if (isEnd) { // 게스트북 마지막까지 다 불러왔을 경우 불러오기 종료
		return false;
	}
	++page; // 수를 늘려서 다음 게스트북을 불러온다
	$.ajax({
		url:"${pageContext.request.contextPath }/guestbook/ajax/loadguestbook",
		type:"post",
		dataType:"json",
		data:"page=" + page,
		success:function(response) { // 게시판의 page처럼 ajax에서 스크롤할때마다 다음 페이지 게스트북을 가져오듯이 하는데
			if (response.loadGuestbook == "") { // 더이상 가져올 게스트북이 없을경우 response.loadGuestbook은 비였으므로 불러오기를 종료한다
				isEnd = true;
				console.log(isEnd);
				return false;
			}

			// 아직 가져올 게스트북이 남아 있으므로 가져와서 화면에 띄우기 위해서 renderGuestbook 함수 사용
			$(response.loadGuestbook).each(function(index, guestbookVo) { // 가져온 게스트북을 for문을 돌림 each(function(index, element) {...} index 써줘야 함!!)
				renderGuestbook(guestbookVo, false); // 화면에 띄우기 위해서 renderGuestbook함수 사용
			});
			if (response.loadGuestbook.length < 3) { // 게스트북을 한번 불러올때 10개씩 불러오고 
				isEnd = true;						// 10개 미만이면 마지막 게스트북까지 다 불러왔으므로 마지막이라는 표시로 true!
			}
		},
		error:function(jqXHR, status, error) { // ajax 에러일경우 콘솔로 에러 출력
			console.log(status + " : " + error);
		}
	});
}

var cautionBox = function(title, message, callback) { // 유효성 체크 경고창을 함수로 만들어서 사용함
	$("#caution").prop("title", title); // 경고창의 title을 내가 입력한 title로 변경
	$("#caution").text(message); // 경고창의 text를 내가 입력한 message로 변경
	$("#caution").dialog({ // 경고창을 dialog로 띄우고 dialog의 옵션을 변경 
		modal:true, // dialog에 modal 기능 작동(다이얼로그 제외한 배경 반투명 어둡게 하는게 modal)
		close:callback || function(){} // callback에 null값이 들어오면 오류!!
													// 그래서 null이 들어오면 function()이 일어나게 하려고 || 을 쓴다
	});
}

//게스트북 삭제
$(document).on("click", "#guestbook a", function(event) { // 동적 태그의 이벤트는 on을 쓴다!!! (참고사이트:http://roqkffhwk.tistory.com/45)
	event.preventDefault();
	$("#delete-no").prop("value", $(this).attr("guestbook-no"));
	$("#delete-dialog").dialog({
		modal:true,
		buttons:{
			"삭제":function() {
				$.ajax({
					url:"${pageContext.request.contextPath }/guestbook/delete-ajax",
					type:"post",
					dataType:"json",
					data:$("#delete").serialize(), // form태그의 모든 input 데이터를 한번에 보냄 (type="file"인 것은 보내지 않는다고 함!!)
					 											// 힘들게 "no=" + $("#no") + "&password=" + $("#password") 안해도 됨
					success:function(response) {
						if (response.result == true) { // 비밀번호가 맞을 경우
							$("#guestbook-" + response.no).remove(); // 해당 게스트북을 삭제
							$("#delete-dialog").dialog("close"); // 다이얼로그를 닫는다
							$("#delete")[0].reset(); // delete 폼에 작성했던 데이터 지우기
						} else {
							$("#normal").hide(); // 평상시 텍스트 숨기기
							$("#error").show(); // 비밀번호 틀렸을때 텍스트 보이기
							$("#delete")[0].reset(); // delete 폼에 작성했던 데이터 지우기
							return false;
						}
					},
					error:function(jqXHR, status, error) {
						console.log(status + " : " + error);
					}
				});
			},
			"취소":function() {
				$(this).dialog("close");
			}
		},
		close:function() {
			$("#normal").show();
			$("#error").hide();
			$("#delete")[0].reset(); // delete 폼에 작성했던 데이터 지우기
		}
	});
});

$(function() { // jsp가 켜지자마자 이 function이 작동한다

	$("#name").focus(); // 방명록(ajax) 페이지에 들어오면 바로 작성자에 포커스됨
	
	loadGuestbook(); // 처음에 게스트북을 불러와야하니깐
	
	// 스크롤이 제일 밑으로 내려오면 게스트북이 더 있는지 확인하고 불러온다
	$(window).scroll(function() {
		var scrollTop = $(window).scrollTop(); // 스크롤바 현재 위치
		var windowHeight = $(window).height(); // 윈도우창 크기()
		var documentHeight = $(document).height(); // 도큐먼트 크기(높이)
		
		// 스크롤바가 맨 밑에서 10px 위 도착 했을때 게스트북을 더 불러오기
		if (scrollTop + windowHeight + 10 > documentHeight) {
			loadGuestbook();
		}
	});
	
	// 게스트북 등록
	$("#write").submit(function(event) { // 작성 버튼 눌렀을때 작동
		event.preventDefault(); // submit 기능을 중단 (function()에 파라미터로 event를 써야함)
										// submit 기능을 중단시키고 자바스크립트에서 따로 submit 기능을 다시 구현할려고!!!
										
		if ($("#name").val() == "" || /\s/gi.test($("#name").val())) { // 작성자가 빈칸이거나 공백이 들어갈 경우
			$("#caution").prop("title", "작성자 입력 오류"); // 다이얼로그 타이틀을 변경
			$("#caution").text("작성자를 입력하시오."); // 다이얼로그 내용을 변경
			$("#caution").dialog({ // 다이얼로그 띄우기, {}중괄호는 다이얼로그 옵션 수정
				modal:true, // modal 기능 작동
				close:function() { // close버튼 눌렀을때 작동하는 옵션 수정
					$("#name").focus(); // 작성자로 포커스 이동
				}
			});
			return false; // submit기능 작동 취소, true면 submit 기능이 작동해서 데이터를 컨트롤러로 보냄
		} else if ($("#password").val() == "") { // 비밀번호가 빈칸일 경우
			cautionBox("비밀번호 입력 오류", "비밀번호를 입력하시오.", function() { // 위에서 만든 cautionBox 함수 사용
					$("#password").focus(); // 비밀번호로 포커스 이동
			});
			return false;
		} else if ($("#content").val() == "") { // 내용이 빈칸일 경우
			cautionBox("내용 입력 오류", "내용을 입력하시오.", function() { 
					$("#content").focus(); // 내용으로 포커스 이동
			});
			return false;
		};

		$.ajax({ // 위에서 event.preventDefault()로 막은 submit 기능을 ajax로 구현!!
			url:"${pageContext.request.contextPath }/guestbook/write-ajax",
			type:"post",
			dataType:"json",
			data:$("#write").serialize(), // form태그의 모든 input 데이터를 한번에 보냄 (type="file"인 것은 보내지 않는다고 함!!)
													 // 힘들게 "name=" + $("#name") + "&password=" + $("#password") + "&content=" + $("#content") 안해도 됨
			success:function(response) {
				renderGuestbook(response, true); // 새로고침 없이 게스트북vo를 추가한다
				
				$("#write")[0].reset(); // write 폼에 작성했던 데이터 지우기
			},
			error:function(jqXHR, status, error) { // 에러 발생시
				console.error(status + " : " + error);
			}
		});
	});
})
</script>
</head>
<body>
	<c:import url="/WEB-INF/views/includes/header.jsp" />
	
	<!-- 게스트북 작성 -->
	<form action="" id="write" method="post">
		작성자 <input title="작성자" type="text" id="name" name="name">
		비밀번호 <input title="비밀번호" type="password" id="password" name="password">
		내용 <textarea title="내용" id="content" name="content"></textarea>
		<input type="submit" value="작성">
	</form>
	
	<!-- 게스트북 띄울 곳 -->
	<div id="guestbook"></div>
	
	<!-- 방명록 삭제용 다이얼로그 -->
	<div id="delete-dialog" title="방명록 삭제" style="display:none">
		<p id="normal">비밀번호를 입력하시오</p> <!-- 평상시 뜨는 텍스트 -->
		<p id="error" style="display: none">비밀번호가 틀립니다</p> <!-- 비밀번호가 틀랄때 뜨는 텍스트 -->
		<form id="delete" method="post">
			<input type="password" id="delete-password" name="password">
			<input type="hidden" id="delete-no" name="no">
			<!-- submit 버튼 안보이게하기 -->
			<input type="submit" tabindex="-1" style="position: absolute; top: -1000px">
		</form>
	</div>
	
	<!-- 안내용 다이얼로그 -->
	<div id="caution" title="" style="display:none;">
		<p></p>
	</div>
</body>
</html>