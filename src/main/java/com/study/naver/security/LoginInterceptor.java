package com.study.naver.security;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.context.ApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.study.naver.service.MemberService;
import com.study.naver.vo.MemberVo;

public class LoginInterceptor extends HandlerInterceptorAdapter {

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {

		// 네이버나 다음도 로그인하고나서도 로그인창으로 갈 수가 있더라...
		// HttpSession session = request.getSession();
		//
		// if (session.getAttribute("info") != null) {
		// response.sendRedirect(request.getContextPath());
		// return false;
		// }
		
		String email = request.getParameter("email");
		String password = request.getParameter("password");

		// JSP에서나 일반 자바에서 스프링 빈객체를 얻기 위해서 (http://cofs.tistory.com/86)
		// 스프링 컨테이너가 관리하는 객체가 아니라서 Autowired가 사용이 안되므로
		// 1. Web Applicaion Context 접근하기
		ApplicationContext ac = WebApplicationContextUtils.getWebApplicationContext(request.getServletContext());

		// 2. 접근후 Container 안에 있는 UserService Bean(객체) 받아오기
		MemberService memberService = ac.getBean(MemberService.class);

		// 데이터베이스에서 해당 MemberVo 받아오기(로그인)
		MemberVo memberVo = memberService.login(email, password);

		// 이메일과 패스워드가 일치하지 않는 경우 로그인창으로 되돌아가고 로그인 실패 띄우기
		if (memberVo == null) {
			response.sendRedirect(request.getContextPath() + "/member/loginform?loginresult=loginfail");
			return false;
		}

		// 인증처리 (http://mungchung.com/xe/spring/21229)
		HttpSession session = request.getSession(true); // true 일경우 HttpSession이 없을 경우 새로 생성
		
		// 세션에 로그인정보를 담고 메인페이지로 이동
		session.setAttribute("sessionLoginInfo", memberVo);
		response.sendRedirect(request.getContextPath());

		return false; // true면 컨트롤러에 해당 메서드로 넘어간다
	}

}
