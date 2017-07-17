package com.study.naver.controller;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.study.naver.security.AccessRole;
import com.study.naver.security.LoginInfo;
import com.study.naver.service.MemberService;
import com.study.naver.vo.MemberVo;

@Controller
@RequestMapping("/member")
public class MemberController {
	
	@Autowired MemberService memberService;

	@RequestMapping("/joinform")
	public String joinForm(@ModelAttribute MemberVo vo) { // form:form을 이용하므로 @ModelAttribute를 써줘야함...
		return "member/joinform";
	}
	
	@RequestMapping("/join")
	public String join(@ModelAttribute @Valid MemberVo vo, BindingResult result) { 
		// @Valid는 유효성 검사하고 그 결과를 BindingResult로 보낸다!!!
	
		System.out.println("회원가입 컨트롤러 : " + vo);
		if (result.hasErrors()) {
			return "member/joinform";
		}
		memberService.join(vo);
		return "redirect:/member/joinsuccess";
	}
	
	@ResponseBody // json으로 데이터를 돌려줘야 하므로...
	@RequestMapping("/emailcheck")
	public boolean emailCheck(@RequestParam(value="email") String email) {
		return memberService.emailCheck(email); // DB에 이메일이 존재하면 true 존재하지않으면 false 리턴
	}
	
	@RequestMapping("/joinsuccess")
	public String joinSuccess() {
		return "member/joinsuccess";
	}
	
	@RequestMapping("/loginform")
	public String loginForm(HttpServletRequest request) {
		return "member/loginform";
	}
	
	// 회원정보수정 페이지로 이동
	@AccessRole
	@RequestMapping("/modifyform")
	public String modifyForm(@LoginInfo MemberVo loginInfo, Model model) { // 여기서는 모델에 MemberVo를 보내므로 join메서드처럼 파라미터에 @ModelAttribute 안써줘도 됨!!
		MemberVo memberVo = memberService.modifyForm(loginInfo.getNo()); // 회원정보를 수정할려면 세션에 있는 멤버 no를 통해서 일단 회원정보를 가져와야함
		model.addAttribute("memberVo", memberVo); 
		return "member/modifyform";
	}
	
	// 회원정보 수정 (웹 → DB)
	@AccessRole
	@RequestMapping("/modify")
	public String modify(@LoginInfo MemberVo loginInfo, @ModelAttribute MemberVo memberVo, HttpServletRequest request) {
		memberVo.setNo(loginInfo.getNo()); // 누구의 정보를 바꾸는지 알기 위해서 loginInfo에 저장된 no 값을 memberVo에 넣어줌!! 세션을 덜 쓰기 위해서 @LoginInfo사용
		memberService.modify(memberVo);
		loginInfo.setName(memberVo.getName()); // 회원정보 수정으로 바뀐 name을 loginInfo에 새로 넣어준다!!
																		// 신기하게도(?) @LoginInfo의 데이터(name)를 바꿨는데 자동으로 세션에 있는 sessionLoginInfo의 데이터(name) 바뀜!!!
																		// 인터넷 엄청 찾아봤지만 안나옴...
		return "redirect:/";
	}
}
