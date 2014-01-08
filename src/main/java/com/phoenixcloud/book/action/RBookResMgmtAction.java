package com.phoenixcloud.book.action;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.annotation.Resource;

import org.springframework.stereotype.Component;

import com.opensymphony.xwork2.ActionSupport;
import com.phoenixcloud.agency.service.IAgencyMgmtService;
import com.phoenixcloud.bean.RBook;
import com.phoenixcloud.book.service.IRBookMgmtService;

@Component("bookResMgmtAction")
public class RBookResMgmtAction extends ActionSupport{
	private static final long serialVersionUID = 5600142681527501077L;
	
	@Resource(name="bookMgmtServiceImpl")
	private IRBookMgmtService iBookService;
	
	@Resource(name="agencyMgmtServiceImpl")
	private IAgencyMgmtService agencyService;
	
	public void setiBookService(IRBookMgmtService iBookService) {
		this.iBookService = iBookService;
	}

	public void setAgencyService(IAgencyMgmtService agencyService) {
		this.agencyService = agencyService;
	}
	
	private int getDepth(BigInteger orgId) {
		
	}

	public String getAll() {
		List<BigInteger> bookIds = iBookService.getBookIdsHaveRes();
		Set<BigInteger> agencyIds = new HashSet<BigInteger>();
		for (BigInteger bookId : bookIds) {
			RBook book = iBookService.findBook(bookId.toString());
			if (book == null) {
				continue;
			}
			agencyIds.add(book.getOrgId());
		}
		
		
		return "success";
	}
}
