package com.study.naver.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.study.naver.repository.GuestbookDao;
import com.study.naver.vo.GuestbookVo;

@Service
public class GuestbookService {

	@Autowired
	private GuestbookDao guestbookDao;
	
	public void write(GuestbookVo vo) {
		guestbookDao.write(vo);
	}
	
	public List<GuestbookVo> list() {
		List<GuestbookVo> list = guestbookDao.list();
		return list;
	}
	
	public List<GuestbookVo> loadGuestbook(Integer page) {
		List<GuestbookVo> list = guestbookDao.loadGuestbook(page);
		return list;
	}
	
	public GuestbookVo writeAjax(GuestbookVo guestbookVo) {
		return guestbookDao.writeAjax(guestbookVo); // 컨트롤러에서 받아온 게스트북vo를 다오로 보내고 그 다음 DB로 들어간 게스트북vo를 다시 컨트롤러로 보냄
	}
	
	public boolean deleteAjax(GuestbookVo guestbookVo) {
		return guestbookDao.deleteAjax(guestbookVo);
	}
}
