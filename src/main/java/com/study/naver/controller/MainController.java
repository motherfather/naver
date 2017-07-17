package com.study.naver.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.study.naver.security.AccessRole;
import com.study.naver.security.AccessRole.Role;
import com.study.naver.security.LoginInfo;
import com.study.naver.vo.MemberVo;

@Controller
public class MainController {
	
	@RequestMapping("")
	public String main() {
		return "main/index";
	}

	// 권한테스트용!!
	@AccessRole(role=Role.ADMIN)
	@RequestMapping("/admin")
	public String mainAdmin(@LoginInfo MemberVo memberVo) {
		return "main/index";
	}

}
