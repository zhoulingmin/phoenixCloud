package com.phoenixcloud.book.action;

import java.io.PrintWriter;
import java.math.BigInteger;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.struts2.dispatcher.RequestMap;
import org.apache.struts2.interceptor.RequestAware;
import org.apache.struts2.interceptor.ServletResponseAware;
import org.springframework.stereotype.Component;

import com.opensymphony.xwork2.ActionSupport;
import com.phoenixcloud.bean.RBook;
import com.phoenixcloud.bean.RBookDire;
import com.phoenixcloud.book.service.IRBookMgmtService;
import com.phoenixcloud.util.MiscUtils;

@Component("bookDireMgmtAction")
public class RBookDrieMgmtAction extends ActionSupport implements RequestAware, ServletResponseAware{

	private RequestMap request;
	private HttpServletResponse response;
	private String bookId;
	@Resource(name="bookMgmtServiceImpl")
	private IRBookMgmtService iBookService;
	
	private BigInteger direId;
	private RBookDire bookDire;
	
	
	public IRBookMgmtService getiBookService() {
		return iBookService;
	}

	public void setiBookService(IRBookMgmtService iBookService) {
		this.iBookService = iBookService;
	}
	
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

	public String getBookId() {
		return bookId;
	}

	public void setBookId(String bookId) {
		this.bookId = bookId;
	}

	public BigInteger getDireId() {
		return direId;
	}

	public void setDireId(BigInteger direId) {
		this.direId = direId;
	}

	public RBookDire getBookDire() {
		return bookDire;
	}

	public void setBookDire(RBookDire bookDire) {
		this.bookDire = bookDire;
	}

	public String getAll() {
		if (bookId == null) {
			return null;
		}
		RBook book = iBookService.findBook(bookId);
		if (book == null) {
			MiscUtils.getLogger().info("没有找到合适的书籍！bookId = " + bookId);
			bookId = null;
			return null;
		}
		request.put("book", book);
		
		List<RBookDire> bookDireList = iBookService.getBookDires(BigInteger.valueOf(Long.parseLong(bookId)), BigInteger.ZERO);
		if (bookDireList.size() == 0) {
			Date curDate = new Date();
			
			// 创建默认封面
			RBookDire bookDire = new RBookDire();
			bookDire.setBPageNum(BigInteger.ZERO);
			bookDire.setEPageNum(BigInteger.ZERO);
			try {
				bookDire.setBookId(BigInteger.valueOf(Long.parseLong(book.getBookId())));
			} catch (Exception e) {
				MiscUtils.getLogger().info(e.toString());
				bookDire.setBookId(BigInteger.ZERO);
				bookDire.setDeleteState((byte)1);
			}
			bookDire.setLevel((byte)1);
			bookDire.setName("封面");
			bookDire.setStaffId(BigInteger.ONE);
			bookDire.setCreateTime(curDate);
			bookDire.setUpdateTime(curDate);
			bookDire.setParentDireId(BigInteger.ZERO);
			iBookService.saveBookDire(bookDire);
			
			// 创建默认目录
			bookDire = new RBookDire();
			bookDire.setBPageNum(BigInteger.ONE);
			bookDire.setEPageNum(BigInteger.ONE);
			try {
				bookDire.setBookId(BigInteger.valueOf(Long.parseLong(book.getBookId())));
			} catch (Exception e) {
				MiscUtils.getLogger().info(e.toString());
				bookDire.setBookId(BigInteger.ZERO);
				bookDire.setDeleteState((byte)1);
			}
			bookDire.setLevel((byte)1);
			bookDire.setName("目录");
			bookDire.setStaffId(BigInteger.ONE);
			bookDire.setCreateTime(curDate);
			bookDire.setUpdateTime(curDate);
			bookDire.setParentDireId(BigInteger.ZERO);
			iBookService.saveBookDire(bookDire);
		}
		
		bookId = null;
		return "success";
	}
	
	public String getSubDire() {
		if (direId == null) {
			direId = BigInteger.ZERO;
		}
		if (bookId == null) {
			return null;
		}
		
		JSONArray jsonArr = new JSONArray();
		List<RBookDire> bookDireList = iBookService.getBookDires(BigInteger.valueOf(Long.parseLong(bookId)), direId);
		for (RBookDire bookDire : bookDireList) {
			JSONObject dirObj = new JSONObject();
			dirObj.put("direId", bookDire.getId());
			dirObj.put("isParent", true);
			dirObj.put("name", bookDire.getName());
			dirObj.put("level", bookDire.getLevel());
			dirObj.put("bookId", bookDire.getBookId());
			dirObj.put("bPageNum", bookDire.getBPageNum());
			dirObj.put("ePageNum", bookDire.getEPageNum());
			dirObj.put("notes", bookDire.getNotes());
			dirObj.put("staffId", bookDire.getStaffId());
			jsonArr.add(dirObj);
		}
		
		response.setCharacterEncoding("utf-8"); 
        response.setContentType("html/text");
        
        try {
        	PrintWriter out = response.getWriter();
        	out.print(jsonArr.toString());
        	out.flush();
        	out.close();
        } catch (Exception e) {
        	MiscUtils.getLogger().info(e.toString());
        }
        
		direId = BigInteger.ZERO;
		bookId = null;
		
		return null;
	}
	
	public String addDire() {
		if (bookDire == null) {
			return null;
		}
		
		Date date = new Date();
		bookDire.setCreateTime(date);
		bookDire.setUpdateTime(date);
		iBookService.saveBookDire(bookDire);
		
		return null;
	}
	
}
