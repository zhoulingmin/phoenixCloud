package com.phoenixcloud.book.action;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Component;

import com.opensymphony.xwork2.ActionSupport;
import com.phoenixcloud.book.service.IRBookMgmtService;

@Component("bookResMgmtAction")
public class RBookResMgmtAction extends ActionSupport{
	private static final long serialVersionUID = 5600142681527501077L;
	
	@Resource(name="bookMgmtServiceImpl")
	private IRBookMgmtService iBookService;
	
	public String getAll() {
		List<BigInteger> bookIds = iBookService.getBookIdsHaveRes();
		List<BigInteger> agencyIds = new ArrayList<BigInteger>();
		
		return "success";
	}
}
