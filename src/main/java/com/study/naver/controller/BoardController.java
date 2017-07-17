package com.study.naver.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.study.naver.security.AccessRole;
import com.study.naver.security.LoginInfo;
import com.study.naver.service.BoardService;
import com.study.naver.vo.BoardVo;
import com.study.naver.vo.MemberVo;

@Controller
@RequestMapping("board") // 슬래시(/) 빼도 됨!
public class BoardController {
	
	@Autowired
	private BoardService boardService;
	
	// 게시판 목록 띄우기, 페이징
	@RequestMapping("")
	public String board(@RequestParam(value="page", required=true, defaultValue="1") Integer page,
			Model model) {
		Map<String, Object> map = boardService.board(page);
		model.addAllAttributes(map); // Map에 사용된 <key, value>에 대해 key를 이름으로 사용해서 value을 모델로 추가한다

		return "board/board";
	}
	
	// 글보기
	@AccessRole
	@RequestMapping("/{no}") // RequestParam이 아닌 PathVariable 방식
	public String view(@PathVariable("no") int no, HttpServletRequest request, Model model) {
		boardService.increaseHit(no, request); // 조회수 증가(세션에 조회정보를 넣어서 조회수 중복 증가를 막음)
		Map<String, Object> map = boardService.view(no); // 게시물 내용 가져옴
		model.addAttribute("board", map); // 게시물 내용 모델에 담아서 jsp로 보냄
		return "board/view";
	}
	
	// 글작성 페이지로 이동
	@AccessRole
	@RequestMapping("/writeform")
	public String writeForm() {
		return "board/writeform";
	}
	
	// 글작성해서 DB에 저장
	@AccessRole
	@RequestMapping("/write")
	public String write(@LoginInfo MemberVo loginInfo, @ModelAttribute BoardVo boardVo, Model model) {
//		model.addAttribute(memberVo); // model.addAttribute("memberVo", memberVo)와 같음
		boardVo.setMem_no(loginInfo.getNo()); // 글쓴사람을 알기 위해서 그 사람의 no값을 넣어줘야 하므로 
		boardService.write(boardVo);
		return "redirect:/board";
	}
	
	// 글삭제하고 DB에서 제거
	@AccessRole
	@RequestMapping("/delete")
	public String delete(@RequestParam("no") int no) {
		boardService.delete(no);
		return "redirect:/board";
	}
	
	// 글수정 페이지로 이동
	@AccessRole
	@RequestMapping("/modifyform")
	public String modifyform(@RequestParam("no") int no, Model model) {
		// view메서드에서 쓰던 코드 가져와서 사용!!
		Map<String, Object> map = boardService.view(no); // 게시물 내용 가져옴
		model.addAttribute("board", map); // 게시물 내용 모델에 담아서 jsp로 보냄
		return "board/modifyform";
	}
	
	// 글수정하고 수정된 데이터 DB 수정
	@AccessRole
	@RequestMapping("/modify")
	public String modify(@LoginInfo MemberVo loginInfo, @ModelAttribute BoardVo boardVo) {
		boardVo.setMem_no(loginInfo.getNo()); // 글쓴사람을 알기 위해서 그 사람의 no값을 넣어줘야 하므로 
		boardService.modify(boardVo);
		return "redirect:/board";
	}
}
