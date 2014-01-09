package com.phoenixcloud.book.vo;

import java.util.List;

public class BookResNode {
	private String type; // root,cata,org
	private String id;
	private String parentNode; // type_id
	private List<String> children; // type_id
	private List<String> bookIds; // 只当type是org时才会有值
	private int level = -1;
	
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getParentNode() {
		return parentNode;
	}
	public void setParentNode(String parentNode) {
		this.parentNode = parentNode;
	}
	public List<String> getChildren() {
		return children;
	}
	public void setChildren(List<String> children) {
		this.children = children;
	}
	public List<String> getBookIds() {
		return bookIds;
	}
	public void setBookIds(List<String> bookIds) {
		this.bookIds = bookIds;
	}
	public int getLevel() {
		return level;
	}
	public void setLevel(int level) {
		this.level = level;
	}
	
	public String getParentType() {
		String[] type_id = parentNode.split("_");
		return type_id[0];
	}
	
	public String getParentId() {
		String[] type_id = parentNode.split("_");
		return type_id[1];
	}
}
