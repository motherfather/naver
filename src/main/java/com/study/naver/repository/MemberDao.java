package com.study.naver.repository;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.study.naver.vo.MemberVo;

@Repository
public class MemberDao {

	@Autowired SqlSession sqlSession;
	
	public void join(MemberVo vo) {
		System.out.println("회원가입 다오 : " + vo);
		sqlSession.insert("member.join", vo);
	}
	
	public MemberVo emailCheck(String email) {
		return sqlSession.selectOne("member.emailcheck", email);
	}
	
	public MemberVo login(String email, String password) {
		MemberVo memberVo = new MemberVo();
		memberVo.setEmail(email);
		memberVo.setPassword(password);
		return sqlSession.selectOne("member.login", memberVo);
	}
	
	public MemberVo modifyForm(Long no) {
		return sqlSession.selectOne("member.modifyform", no);
	}
	
	public void modify(MemberVo memberVo) {
		sqlSession.update("member.modify", memberVo);
	}
}
