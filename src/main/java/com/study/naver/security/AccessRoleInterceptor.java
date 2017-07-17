package com.study.naver.security;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.study.naver.vo.MemberVo;

public class AccessRoleInterceptor extends HandlerInterceptorAdapter {

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		
		// 1. handler 종류
		if (handler instanceof HandlerMethod == false) { // handler가 HandlerMethod타입이 아닌경우
			return true;
		}
		
		// 2. @AccessRole이 붙어 있는지 아닌지 (접근권한 메서드 확인)
		AccessRole accessRole = ((HandlerMethod)handler).getMethodAnnotation(AccessRole.class);
		if (accessRole == null) { // @AccessRole이 안붙은 메서드 접근하면 null인데 그 메서드는 권한없이 접근가능하다는 것!
			return true;
		} else if (accessRole.role() == AccessRole.Role.ADMIN) {
			// ADMIN이 걸린곳에 접근 하기 위한 조건을 쓰면 됨!!
		}
		
		// 3. 접근 제어
		HttpSession httpSession = request.getSession(); // getSession(true)와 같음
		if (httpSession == null) { // 세션이 없는 경우 로그인페이지로 간다 (getSession(false)로 하고 session을 삭제할 경우에만 잠깐 null이 되는듯... 거의 이런 경우는 없다고 보는게 나음)
			response.sendRedirect(request.getContextPath() + "/member/loginform");
			return false; // return이 false면 해당 주소로 접근불가
		}
		MemberVo memberVo = (MemberVo)httpSession.getAttribute("sessionLoginInfo"); // 세션에서 로그인 정보롤 가져옴
		if (memberVo == null) { // 로그인 정보가 null인 경우
			response.sendRedirect(request.getContextPath() + "/member/loginform");
			return false; // return이 false면 해당 주소로 접근불가
		}

		// 4. 접근권한을 가진 사용자 (로그인 정보를 가지고 있는 경우)
		return true;
	}
	
}
