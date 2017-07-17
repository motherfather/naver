package com.study.naver.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.study.naver.security.AccessRole;
import com.study.naver.security.LoginInfo;
import com.study.naver.service.GalleryService;
import com.study.naver.vo.GalleryVo;
import com.study.naver.vo.MemberVo;

@Controller
@RequestMapping("/gallery")
public class GalleryController {
	
	@Autowired
	private GalleryService galleryService;

	// 갤러리 목록 페이지
	@RequestMapping("")
	public String gallery(Model model) {
		List<Map<String, Object>> list = galleryService.list();
		model.addAttribute("list", list);
		return "gallery/gallery";
	}
	
	// 업로드 페이지
	@AccessRole
	@RequestMapping("/uploadform")
	public String uploadForm() {
		return "gallery/uploadform";
	}
	
	// 파일업로드
	@AccessRole
	@RequestMapping("/upload")
	public String upload(@LoginInfo MemberVo memberVo, @ModelAttribute GalleryVo galleryVo, @RequestParam("file") MultipartFile file) {
		galleryVo.setMem_no(memberVo.getNo()); // 파일업로드한 멤버의 no값을 galleryVo에 추가
		galleryService.upload(galleryVo, file); // galleryVo와 file을 서비스로 넘김 (서비스에서 file을 실제로 c드라이브에 저장함)
		return "redirect:/gallery";
	}
}
