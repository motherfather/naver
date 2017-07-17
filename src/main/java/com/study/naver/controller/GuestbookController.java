package com.study.naver.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.study.naver.service.GuestbookService;
import com.study.naver.vo.GuestbookVo;

@Controller
@RequestMapping("/guestbook")
public class GuestbookController {
	
	@Autowired
	private GuestbookService guestbookService;

	@RequestMapping("")
	public String guestbook(@ModelAttribute GuestbookVo vo, Model model) {
		List<GuestbookVo> list = guestbookService.list();
		model.addAttribute("list", list);
		return "guestbook/guestbook";
	}
	
	@RequestMapping("/write")
	public String write(@ModelAttribute GuestbookVo vo) {
		guestbookService.write(vo);
		return "redirect:/guestbook";
	}
	
	@RequestMapping("/ajax")
	public String guestbookAjax() {
		return "guestbook/guestbook-ajax";
	}
	
	@ResponseBody
	@RequestMapping("/ajax/loadguestbook")
	public Map<String, Object> loadGuestbook(@RequestParam(value="page", required=true, defaultValue="1") Integer page) { 
		// ajax로 map을 리턴하는데 spring-servlet.xml 28번째 줄에 의해 json으로 변환되어서 리턴됨!!!
		List<GuestbookVo> list = guestbookService.loadGuestbook(page); // 게스트북을 페이지당 몇개로 나누고 페이지로 불러옴
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("loadGuestbook", list);
		return map;
	}
	
	@ResponseBody
	@RequestMapping(value="/write-ajax")
	public GuestbookVo writeAjax(@ModelAttribute GuestbookVo guestbookVo) {
		return guestbookService.writeAjax(guestbookVo); // ajax에서 받아온 guestbookVo를 서비스로 넘긴 후 서비스에서 DB에 들어갔던 guestbookVo를 다시 리턴해준다
																				  // ajax로 DB에 넣은 게스트북vo를 다시 돌려주는 이유는 새로고침 없이 바로 JSP에 입력했던 게스트북을 추가해주기 위해서
	}
	
	@ResponseBody
	@RequestMapping("/delete-ajax")
	public Map<String, Object> deleteAjax(@ModelAttribute GuestbookVo guestbookVo) {
		boolean deleteResult = guestbookService.deleteAjax(guestbookVo);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("result", deleteResult); // 삭제 성공 or 실패 결과를 담음
		map.put("no", guestbookVo.getNo()); // 게스트북의 no를 담음
		return map;
	}
}
