package com.phoenixcloud.book.action;

import java.io.PrintWriter;
import java.math.BigInteger;
import java.util.Collection;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.mail.Session;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.apache.struts2.dispatcher.RequestMap;
import org.apache.struts2.dispatcher.SessionMap;
import org.apache.struts2.interceptor.RequestAware;
import org.apache.struts2.interceptor.ServletResponseAware;
import org.apache.struts2.interceptor.SessionAware;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import com.opensymphony.xwork2.ActionSupport;
import com.phoenixcloud.bean.PubDdv;
import com.phoenixcloud.bean.PubServerAddr;
import com.phoenixcloud.bean.RBook;
import com.phoenixcloud.bean.SysStaff;
import com.phoenixcloud.book.service.IRBookMgmtService;
import com.phoenixcloud.common.PhoenixProperties;
import com.phoenixcloud.dao.PubDdvDao;
import com.phoenixcloud.system.service.ISysService;

@Scope("prototype")
@Component("bookMgmtAction")
public class RBookMgmtAction extends ActionSupport implements RequestAware, ServletResponseAware, SessionAware{
	private static final long serialVersionUID = -8183960496394408783L;
	private RequestMap request;
	private HttpServletResponse response;
	private SessionMap session;
	@Resource(name="bookMgmtServiceImpl")
	private IRBookMgmtService iBookService;
	@Resource(name="sysServiceImpl")
	private ISysService iSysService;
	@Resource
	private PubDdvDao ddvDao;
	
	private PhoenixProperties prop = PhoenixProperties.getInstance();

	public void setiSysService(ISysService iSysService) {
		this.iSysService = iSysService;
	}

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
	
	public void setDdvDao(PubDdvDao ddvDao) {
		this.ddvDao = ddvDao;
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
		
		SysStaff curStaff = (SysStaff)session.get("user");
		if (curStaff != null) {
			bookInfo.setStaffId(new BigInteger(curStaff.getStaffId()));
			PubServerAddr serAddr = iSysService.findServerAddrByOrgId(curStaff.getOrgId());
			if (serAddr != null) {
				bookInfo.setIpAddr(serAddr.getBookSerIp());
			}
		} else {
			bookInfo.setStaffId(BigInteger.ZERO);
		}
		
		iBookService.saveBook(bookInfo);
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
	
	public String searchBook() {
		
		List<RBook> bookList = iBookService.searchBook(bookInfo);
		this.request.put("bookList", bookList);
		
		return "success";
	}
	
	public void addActionError(String anErrorMessage) {
        //validationAware.addActionError(anErrorMessage);
    }

    public void addActionMessage(String aMessage) {
        //validationAware.addActionMessage(aMessage);
    }

    public void addFieldError(String fieldName, String errorMessage) {
        //validationAware.addFieldError(fieldName, errorMessage);
    }
    
    public String checkBookNo() {
    	boolean isExist = iBookService.checkBookNoExist(bookInfo.getBookNo());
    	JSONObject obj = new JSONObject();
    	obj.put("ret", isExist);
    	
    	response.setContentType("text/html");
    	response.setCharacterEncoding("utf-8");
    	
    	try {
    		PrintWriter out = response.getWriter();
    		out.print(obj.toString());
    		out.flush();
    		out.close();
    	} catch (Exception e) {}
    	
    	return null;
    }

	@SuppressWarnings("rawtypes")
	@Override
	public void setSession(Map<String, Object> session) {
		// TODO Auto-generated method stub
		this.session = (SessionMap)session;
	}
}
