package com.study.naver.repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.study.naver.vo.BoardVo;

@Repository
public class BoardDao {
	
	@Autowired
	private SqlSession sqlSession;
	
	// 페이지당 보여지는 게시물 리스트
	public List<Map<String, Object>> list(int page, int list_size) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("page", page);
		map.put("list_size", list_size);
		return sqlSession.selectList("board.list", map);
	}
	
	// 총 게시물의 개수
	public int totalBoard() {
		return sqlSession.selectOne("board.totalboard");
	}
	
	public void increaseHit(int no) {
		sqlSession.update("board.increaseHit", no);
	}
	
	public Map<String, Object> view(int no) {
		return sqlSession.selectOne("board.view", no);
	}
	
	public void write(BoardVo boardVo) {
		sqlSession.insert("board.write", boardVo);
	}
	
	public void delete(int no) {
		sqlSession.delete("board.delete", no);
	}
	
	public void modify(BoardVo boardVo) {
		sqlSession.update("board.modify", boardVo);
	}

}
