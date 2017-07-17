package com.study.naver.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.study.naver.repository.BoardDao;
import com.study.naver.vo.BoardVo;

@Service
public class BoardService {
	
	private final int list_size = 3; // 한 페이지당 보여질 게시물의 수
	private final int page_size = 5; // 한번에 보여질 페이지의 수 (◀1 2 3 4 5▶)
	
	@Autowired
	private BoardDao boardDao;
	
	// 페이지당 보여지는 게시물 리스트
	public Map<String, Object> board(int page) {
		// 페이지당 보여지는 게시물 리스트
		// 1페이지 1~5 2페이지는 6~10 이렇게 리스트 가져옴
		List<Map<String, Object>> list = boardDao.list(page, list_size);  
		
		int totalBoard = boardDao.totalBoard(); // 총 게시물의 수
		int totalPage = (int)Math.ceil((double)totalBoard / list_size); // 총 페이지의 수
		
		// ◀1 2 3 4 5▶ ← 페이지블럭
		// 마지막 페이지블럭 ◀1 2 3 4 5▶ 1, ◀6 7 8▶ 2
		int lastPageBlock = (int)Math.ceil((double)totalPage / page_size); 
		
		// 현재 페이지블럭
		int currentPageBlock = totalPage >= page ? (int)Math.ceil((double)page / page_size) : lastPageBlock;

		// 페이지블럭에서 처음 페이지를 지정하기 위해서
		// 예시) ◀1 2 3 4 5▶  여기서는 1 ◀6 7 8▶ 여기서는 6
		int pageBlockFirstPage = (currentPageBlock - 1) * page_size + 1;
		
		// 페이지블럭에서 마지막 페이지를 지정하기 위해서
		// 현재 페이지블럭이 마지막 페이지블럭 보다 작으면 보여질 마지막 페이지의 수는 page_size의 수이고 크거나 같을경우 마지막 페이지의 수는 totalPage이다
		// 예시) ◀1 2 3 4 5▶  여기서는 5 ◀6 7 8▶ 여기서는 8
		int pageBlockLastPage = lastPageBlock > currentPageBlock ? currentPageBlock * page_size : totalPage;
		
		// 페이지블럭에서 ◀ 버튼을 누르면 뜨는 페이지
		int previousPage = currentPageBlock > 1 ? (currentPageBlock - 1) * page_size : -1;
		
		// 페이지블럭에서 ▶ 버튼을 누르면 뜨는 페이지
		int nextPage = currentPageBlock < lastPageBlock ? currentPageBlock * page_size + 1 : -1;
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("list", list);
		map.put("pageBlockLastPage", pageBlockLastPage);
		map.put("pageBlockFirstPage", pageBlockFirstPage);
		map.put("previousPage", previousPage);
		map.put("nextPage", nextPage);
		
		return map;
	}
	
	// 조회수 증가, 중복 증가 막기
	public void increaseHit(int no, HttpServletRequest request) {
		HttpSession session = request.getSession();

		if (session.getAttribute("hit_time_" + no) == null) { // 세션에 조회정보가 없을 경우
			session.setAttribute("hit_time_" + no, System.currentTimeMillis()); // 세션에 조회시간 넣음
			boardDao.increaseHit(no); // 조회수 증가
		} else { // 세션에 조회정보가 있을 경우
			if (System.currentTimeMillis() - (Long)session.getAttribute("hit_time_" + no) > 24*60*60*1000) { // 조회한지 24*60*60*1000 (24시간) 지나거나 세션이 삭제되면!
																																							// 로그아웃하면 세션이 삭제되게 만들었음
				boardDao.increaseHit(no);
			}
		}
	}

	public Map<String, Object> view(int no) {
		return boardDao.view(no); // 객체로 생성하지 않고 리턴하지 않고 값을 그대로 바로 리턴
	}
	
	public void write(BoardVo boardVo) {
		boardDao.write(boardVo);
	}

	public void delete(int no) {
		boardDao.delete(no);
	}
	
	public void modify(BoardVo boardVo) {
		boardDao.modify(boardVo);
	}
}
