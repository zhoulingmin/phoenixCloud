package com.phoenixcloud.book.action;

import java.math.BigInteger;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts2.dispatcher.RequestMap;
import org.apache.struts2.interceptor.RequestAware;
import org.apache.struts2.interceptor.ServletResponseAware;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import com.opensymphony.xwork2.ActionSupport;
import com.phoenixcloud.bean.RBook;
import com.phoenixcloud.book.service.IRBookMgmtService;

@Scope("prototype")
@Component("bookMgmtAction")
public class RBookMgmtAction extends ActionSupport implements RequestAware, ServletResponseAware{
	private static final long serialVersionUID = -8183960496394408783L;
	private RequestMap request;
	private HttpServletResponse response;
	@Resource(name="bookMgmtServiceImpl")
	private IRBookMgmtService iBookService;
	
	private RBook bookInfo;
	private String bookIdArr; // used to remove book
	
	
	@Override
	public void setServletResponse(HttpServletResponse response) {
		// TODO Auto-generated method stub
		this.response = response; 
	}

	@Override
	public void setRequest(Map<String, Object> request) {
		// TODO Auto-generated method stub
		this.request = (RequestMap) request;
	}

	public RequestMap getRequest() {
		return request;
	}

	public void setRequest(RequestMap request) {
		this.request = request;
	}

	public HttpServletResponse getResponse() {
		return response;
	}

	public void setResponse(HttpServletResponse response) {
		this.response = response;
	}

	public void setiRBookMgmtService(IRBookMgmtService iRBookMgmtService) {
		this.iBookService = iRBookMgmtService;
	}
	
	public RBook getBookInfo() {
		return bookInfo;
	}

	public void setBookInfo(RBook bookInfo) {
		this.bookInfo = bookInfo;
	}
	
	public String getBookIdArr() {
		return bookIdArr;
	}

	public void setBookIdArr(String bookIdArr) {
		this.bookIdArr = bookIdArr;
	}

	public String getAll() {
		List<RBook> bookList = iBookService.getAllBooks();
		this.request.put("bookList", bookList);
		return "success";
	}

	public String addBook() {
		Date date = new Date();
		bookInfo.setCreateTime(date);
		bookInfo.setUpdateTime(date);
		bookInfo.setStaffId(new BigInteger("1"));
		iBookService.saveBook(bookInfo);
		bookInfo = null;
		return null;
	}
	
	public String editBook() throws Exception {
		if (bookInfo.getName() == null) { // 
			bookInfo = iBookService.findBook(bookInfo.getBookId());
			if (bookInfo == null) {
				throw new Exception("没有找到相应的书籍！");
			}
		} else {
			RBook book = iBookService.findBook(bookInfo.getBookId());
			if (book != null) {
				book.setCataAddrId(bookInfo.getCataAddrId());
				book.setClassId(bookInfo.getClassId());
				book.setKindId(bookInfo.getKindId());
				book.setName(bookInfo.getName());
				book.setNotes(bookInfo.getNotes());
				book.setOrgId(bookInfo.getOrgId());
				book.setPageNum(bookInfo.getPageNum());
				book.setPressId(bookInfo.getPressId());
				book.setStuSegId(bookInfo.getStuSegId());
				book.setSubjectId(bookInfo.getSubjectId());
				book.setUpdateTime(new Date());
				iBookService.saveBook(book);
			}
			
			return null;
		}
		return "success";
	}
	
	public String removeBook() {
		if (bookIdArr == null) {
			return null;
		}
		
		String[] bookIds = bookIdArr.split(",");
		for (String bookId : bookIds) {
			iBookService.removeBook(bookId);
		}
		
		return null;
	}
	
	public String viewBook() throws Exception{
		bookInfo = iBookService.findBook(bookInfo.getBookId());
		if (bookInfo == null) {
			throw new Exception("没有找到相应的书籍！");
		}
		return "success";
	}
}
