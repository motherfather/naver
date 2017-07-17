package com.study.naver.repository;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.study.naver.vo.GalleryVo;

@Repository
public class GalleryDao {

	@Autowired
	private SqlSession sqlSession;
	
	public List<Map<String, Object>> list() {
		return sqlSession.selectList("gallery.list");
	}
	
	public void upload(GalleryVo galleryVo) {
		sqlSession.insert("gallery.upload", galleryVo);
	}
}
