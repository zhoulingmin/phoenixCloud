package com.phoenixcloud.book.action;

import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.struts2.dispatcher.RequestMap;
import org.apache.struts2.interceptor.RequestAware;
import org.springframework.stereotype.Component;

import com.opensymphony.xwork2.ActionSupport;
import com.phoenixcloud.bean.RRegCode;
import com.phoenixcloud.book.service.IRBookMgmtService;

@Component("bookRegCodeMgmtAction")
public class RBookRegCodeMgmtAction extends ActionSupport implements RequestAware {
	
	private static final long serialVersionUID = 19227428971335852L;
	
	private RequestMap request;

	@Resource(name="bookMgmtServiceImpl")
	private IRBookMgmtService iBookService;
	
	private RRegCode regCode;
	private String regCodeIdArr;
	
	public void setiBookService(IRBookMgmtService iBookService) {
		this.iBookService = iBookService;
	}


	@Override
	public void setRequest(Map<String, Object> request) {
		// TODO Auto-generated method stub
		this.request = (RequestMap) request;
	}


	public RRegCode getRegCode() {
		return regCode;
	}


	public void setRegCode(RRegCode regCode) {
		this.regCode = regCode;
	}


	public String getRegCodeIdArr() {
		return regCodeIdArr;
	}


	public void setRegCodeIdArr(String regCodeIdArr) {
		this.regCodeIdArr = regCodeIdArr;
	}

	public String getAll() {
		List<RRegCode> codeList = iBookService.getAllRegCodes();
		request.put("codeList", codeList);
		return "success";
	}
	
	public String edit() {
		regCode = iBookService.findRegCode(regCode.getId());
		return "success";
	}
	
	public String remove() {
		String[] regCodeId = regCodeIdArr.split(",");
		for (String id : regCodeId) {
			iBookService.removeRegCode(id);
		}
		return null;
	}
	
	public String save() {
		regCode.setUpdateTime(new Date());
		iBookService.saveRegCode(regCode);
		return null;
	}
	
	public String add() {
		Date curDate = new Date();
		regCode.setUpdateTime(curDate);
		regCode.setCreateTime(curDate);
		regCode.setIsValid((byte)1);
		iBookService.saveRegCode(regCode);
		return null;
	}
}
