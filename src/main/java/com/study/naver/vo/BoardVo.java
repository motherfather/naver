package com.study.naver.vo;

public class BoardVo {

	private Long no;
	private String title;
	private String content;
	private String reg_date;
	private Long hit;
	private Long mem_no;
	
	public Long getNo() {
		return no;
	}
	public void setNo(Long no) {
		this.no = no;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getReg_date() {
		return reg_date;
	}
	public void setReg_date(String reg_date) {
		this.reg_date = reg_date;
	}
	public Long getHit() {
		return hit;
	}
	public void setHit(Long hit) {
		this.hit = hit;
	}
	public Long getMem_no() {
		return mem_no;
	}
	public void setMem_no(Long mem_no) {
		this.mem_no = mem_no;
	}
	
	@Override
	public String toString() {
		return "BoardVo [no=" + no + ", title=" + title + ", content=" + content + ", reg_date=" + reg_date + ", hit="
				+ hit + ", mem_no=" + mem_no + "]";
	}
	
}
