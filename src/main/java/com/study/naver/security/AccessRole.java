package com.study.naver.security;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface AccessRole {
	Role role() default Role.MEMBER; // 디폴트가 멤버! 로그인은 해야 @AccessRole이 붙은 메서드에 접근이 가능하다는 것!!
	
	public enum Role {
		ADMIN, MEMBER
	}
}