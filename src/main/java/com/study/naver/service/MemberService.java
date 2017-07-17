package com.study.naver.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.study.naver.repository.MemberDao;
import com.study.naver.vo.MemberVo;

@Service
public class MemberService {
	
	@Autowired MemberDao memberDao;
	
	public void join(MemberVo vo) {
		System.out.println("회원가입 서비스 : " + vo);
		memberDao.join(vo);
	}
	
	public boolean emailCheck(String email) {
		return memberDao.emailCheck(email) != null; // DB에 이메일이 존재하면 true 존재하지않으면 false 리턴
	}
	
	public MemberVo login(String email, String password) {
		return memberDao.login(email, password);
	}
	
	public MemberVo modifyForm(Long no) {
		return memberDao.modifyForm(no);
	}
	
	public void modify(MemberVo memberVo) {
		memberDao.modify(memberVo);
	}
}
