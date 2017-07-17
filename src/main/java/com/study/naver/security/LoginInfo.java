package com.study.naver.security;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Target(ElementType.PARAMETER)
@Retention(RetentionPolicy.RUNTIME)
public @interface LoginInfo { // 세션에서 매번 로그인 정보를 가져오기 번거로우므로 @LoginInfo가 달렸으면 HandlerMethodArgumentResolver를 통해 파라미터를 가져온다
}
