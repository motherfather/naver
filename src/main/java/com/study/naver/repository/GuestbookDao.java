package com.study.naver.repository;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.study.naver.vo.GuestbookVo;

@Repository
public class GuestbookDao {

	@Autowired
	private SqlSession sqlSession;

	public void write(GuestbookVo vo) {
		sqlSession.insert("guestbook.write", vo);
		System.out.println(sqlSession.insert("guestbook.write", vo));
	}
	
	public List<GuestbookVo> list() {
		List<GuestbookVo> list = sqlSession.selectList("guestbook.list");
		return list;
	}
	
	public List<GuestbookVo> loadGuestbook(Integer page) {
		List<GuestbookVo> list = sqlSession.selectList("guestbook.loadguestbook", page);
		return list;
	}
	
	public GuestbookVo writeAjax(GuestbookVo guestbookVo) {
		sqlSession.insert("guestbook.writeajax", guestbookVo); // 받아온 게스트북vo를 디비에 입력
		return sqlSession.selectOne("guestbook.getbyno", guestbookVo.getNo()); // no값을 통해서 게스트북vo를 읽어오고 그걸 서비스로 보냄
	}
	
	public boolean deleteAjax(GuestbookVo guestbookVo) {
		int deleteResult = sqlSession.delete("guestbook.deleteajax", guestbookVo); // 삭제 성공하면 1, 실패시 0
		if (deleteResult == 1) {
			return true;
		} else {
			return false;
		}
	}
}
