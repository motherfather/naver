package com.study.naver.service;

import java.io.FileOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.study.naver.repository.GalleryDao;
import com.study.naver.vo.GalleryVo;

@Service
public class GalleryService {
	
	@Autowired
	private GalleryDao galleryDao;
	
	// 갤러리 리스트 DB에서 가져오기
	public List<Map<String, Object>> list() {
		return galleryDao.list();
	}

	// galleryVo는 DB에 저장하고 업로드된 file은 c드라이브의 upload폴더에 저장하는 작업을 함
	public void upload(GalleryVo galleryVo, MultipartFile file) {
		String originalFileName = file.getOriginalFilename(); // 파일의 원래 이름 저장
		String originalFileSize = "" + file.getSize(); // 파일의 크기 저장 (getSize()가 long 타입이라서 형변환을 위해서 "" 추가!)
		String originalFileExtension = originalFileName.substring(originalFileName.lastIndexOf('.')+1, originalFileName.length()); // 파일의 확장자만 잘라서 저장
		
		// 파일의 새로운 이름을 업로드 시간으로 함
		Calendar calendar = Calendar.getInstance(); // 업로드 시간을 알기 위해서 캘린더가 필요
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyyMMddHHmmssSSS"); // 업로드시간의 모양(포맷) 변경
		String newFileName = simpleDateFormat.format(calendar.getTime()/* 현재시간 구하는 함수(이걸 쓰기 위해서 캘린더 함수 사용) */); // 현재시간을 구해서 위 모양(포맷)으로 변경
		newFileName += ('.' + originalFileExtension); // 원래 확장자를 이름에 추가해서 현재시간.확장자 형태로 만듬
		
		try { // getBytes()는 ioexception을 발생시키나봄...
			// 파일을 c드라이브의 upload폴더에 저장함
			byte[] fileData = file.getBytes(); // 파일 데이터를 구하는 함수로 이를 통해 저장함
			FileOutputStream fileOutputStream = new FileOutputStream("/upload/" + newFileName); // 저장할 위치와 저장할 파일이름 설정
			fileOutputStream.write(fileData); // 저장할 파일 데이터 설정하고 실제로 하드디스크에 저장!!
			fileOutputStream.close(); // 파일아웃풋스트림 닫기
		} catch (IOException ioException) {
			throw new RuntimeException();
		}
		
		// 하드에 저장한 파일의 이름과 크기를 galleryVo에 저장
		// 저장한 galleryVo를 DB에 저장함
		galleryVo.setImage(newFileName);
		galleryVo.setImage_size(originalFileSize);
		galleryDao.upload(galleryVo); // 다오로 정보 보냄
	}
}
