package com.study.naver.security;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.core.MethodParameter;
import org.springframework.web.bind.support.WebArgumentResolver;
import org.springframework.web.bind.support.WebDataBinderFactory;
import org.springframework.web.context.request.NativeWebRequest;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.method.support.ModelAndViewContainer;

import com.study.naver.vo.MemberVo;

public class LoginInfoHandlerMethodArgumentResolver implements HandlerMethodArgumentResolver {

	// 참고사이트 http://addio3305.tistory.com/75
	// 2. resolverArgument 메서드는 파라미터와 기타 정보를 받아서 실제 객체를 반환
	// supportsParameter에서 true일 경우 resolveArgument로 파라미터가 넘어온다!!
	@Override
	public Object resolveArgument(MethodParameter parameter, ModelAndViewContainer mavContainer, NativeWebRequest webRequest,
			WebDataBinderFactory binderFactory) throws Exception { 
		
		HttpServletRequest request = webRequest.getNativeRequest(HttpServletRequest.class);
		HttpSession session = request.getSession();
		if (session == null) { // 세션이 null일 경우 Object를 리턴함
			return WebArgumentResolver.UNRESOLVED; // WebArgumentResolver.UNRESOLVED는 new Object()임!!
		}
		return session.getAttribute("sessionLoginInfo"); // 세션에 있는 로그인정보를 리턴한다
	}

	 // 1. supportsParameter 메서드는 Resolver가 적용 가능한지 검사하는 역할
	@Override
	public boolean supportsParameter(MethodParameter parameter) {
		LoginInfo loginInfo = parameter.getParameterAnnotation(LoginInfo.class);
		
		// @LoginInfo가 안붙어있을 경우
		if (loginInfo == null) {
			return false;
		}
		
		// parameter의 타입이 MemberVo가 아닌경우
		if (parameter.getParameterType() != MemberVo.class) {
			return false;
		}
		
		return true;
	}

	
}
