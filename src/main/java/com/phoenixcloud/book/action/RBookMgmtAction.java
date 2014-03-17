package com.phoenixcloud.book.action;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.math.BigInteger;
import java.util.Collection;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.mail.Session;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;
import net.sf.json.processors.JsonBeanProcessor;

import org.apache.struts2.dispatcher.RequestMap;
import org.apache.struts2.dispatcher.SessionMap;
import org.apache.struts2.interceptor.RequestAware;
import org.apache.struts2.interceptor.ServletResponseAware;
import org.apache.struts2.interceptor.SessionAware;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import com.opensymphony.xwork2.ActionSupport;
import com.phoenixcloud.bean.PubDdv;
import com.phoenixcloud.bean.PubOrg;
import com.phoenixcloud.bean.PubPress;
import com.phoenixcloud.bean.PubServerAddr;
import com.phoenixcloud.bean.RBook;
import com.phoenixcloud.bean.RBookRe;
import com.phoenixcloud.bean.SysStaff;
import com.phoenixcloud.book.service.IRBookMgmtService;
import com.phoenixcloud.common.PhoenixProperties;
import com.phoenixcloud.dao.ctrl.PubDdvDao;
import com.phoenixcloud.dao.ctrl.PubOrgDao;
import com.phoenixcloud.dao.ctrl.PubPressDao;
import com.phoenixcloud.dao.res.RBookDao;
import com.phoenixcloud.system.service.ISysService;
import com.phoenixcloud.util.MiscUtils;
import com.phoenixcloud.util.SpringUtils;

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
	
	@Autowired
	private RBookDao bookDao;
	
	private byte flag;
	
	private RBook bookInfo;
	
	private String bookIdArr; // used to remove book
	
	private String dataType;
	
	private PhoenixProperties prop = PhoenixProperties.getInstance();

	public void setiSysService(ISysService iSysService) {
		this.iSysService = iSysService;
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
		//List<RBook> bookList = bookDao.findByAuditStatus(bookInfo.getIsAudit());
		//request.put("bookList", bookList);
		return "success";
	}

	public byte getFlag() {
		return flag;
	}

	public void setFlag(byte flag) {
		this.flag = flag;
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
	
	public String getDataType() {
		return dataType;
	}

	public void setDataType(String dataType) {
		this.dataType = dataType;
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
		if (dataType == null) {
			this.request.put("bookList", bookList);
			if (bookInfo.getIsAudit() != (byte) -2) {
				return "editSearch";
			}
			
			return "querySearch";
		} else if ("json".equalsIgnoreCase(dataType)){
			JsonConfig jsonCnf = new JsonConfig();
			jsonCnf.registerJsonBeanProcessor(RBook.class, new JsonBeanProcessor() {

				@Override
				public JSONObject processBean(Object bean, JsonConfig jsonConfig) {
					// TODO Auto-generated method stub
					if (!(bean instanceof RBook)) {
						return new JSONObject(true);
					}
					RBook book = (RBook)bean;
					/*
					 * <th>书名</th>
							<th>书籍编码</th>
							<th>隶属机构</th>
							<th>学段</th>
							<th>年级</th>
							<th>学科</th>
							<th>出版社</th>
							<th>备注</th>
					 * */
					
					PubOrgDao orgDao = (PubOrgDao)SpringUtils.getBean(PubOrgDao.class);
					PubOrg org = orgDao.find(book.getOrgId().toString());
					if (org == null) {
						return new JSONObject(true);
					}
					PubDdvDao ddvDao = (PubDdvDao)SpringUtils.getBean(PubDdvDao.class);
					PubDdv stu = ddvDao.find(book.getStuSegId().toString());
					if (stu == null) {
						return new JSONObject(true);
					}
					PubDdv cls = ddvDao.find(book.getClassId().toString());
					if (cls == null) {
						return new JSONObject(true);
					}
					PubDdv kind = ddvDao.find(book.getKindId().toString());
					if (kind == null) {
						return new JSONObject(true);
					}
					PubPressDao pressDao = (PubPressDao)SpringUtils.getBean(PubPressDao.class);
					PubPress press = pressDao.find(book.getPressId().toString());
					if (press == null) {
						return new JSONObject(true);
					}
					JSONObject obj = new JSONObject();
					obj.element("bookId", book.getId());
					obj.element("name", book.getName());
					obj.element("bookNo", book.getBookNo());
					obj.element("orgName", org.getOrgName());
					obj.element("stu", stu.getValue());
					obj.element("cls", cls.getValue());
					obj.element("kind", kind.getValue());
					obj.element("press", press.getName());
					obj.element("notes", book.getNotes());
					
					return obj;
				}
				
			});
			JSONArray jsonArr = JSONArray.fromObject(bookList, jsonCnf);
			
			response.setContentType("text/html");
			response.setCharacterEncoding("utf-8");
			try {
				PrintWriter out = response.getWriter();
				out.print(jsonArr.toString());
				out.flush();
				out.close();
			} catch (Exception e) {
				MiscUtils.getLogger().info(e.toString());
			}
			return null;
		}
		return null;
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
	
	public String changeAuditStatus() {
		String[] bookIds = bookIdArr.split(",");
		for (String bookId : bookIds) {
			RBook book = bookDao.find(bookId);
			if (book == null) {
				continue;
			}
			
			if (flag == (byte)-1 && book.getIsAudit() != (byte)0) { // 打回重新制作
				continue;
			} else if (flag == (byte)0 && book.getIsAudit() != (byte)-1) { // 提交审核
				continue;
			} else if (flag == (byte)1 && book.getIsAudit() != (byte)0) { // 提交发布
				continue;
			} else if (flag == (byte)2 && book.getIsAudit() != (byte)1) { // 发布
				continue;
			}
			
			book.setIsAudit(flag);
			book.setUpdateTime(new Date());
			bookDao.merge(book);
		}
		
		return null;
	}
	private void streamDownload(RBook book) throws Exception {
		response.setContentType("application/octet-stream");
		response.setHeader("Content-Disposition", "attachment; filename=\"" + new String(book.getBookFileName().getBytes(), "ISO8859-1") + "\"");
		try {
			FileInputStream fis = new FileInputStream(book.getLocalPath());
			OutputStream out = response.getOutputStream();
			outputToInput(out, fis);
			out.close();
			fis.close();
		} catch (Exception e) {
			MiscUtils.getLogger().info(e.toString());
		}
	}
	
	public String download() throws Exception {
		RBook book = bookDao.find(bookInfo.getBookId());
		if (book == null) {
			throw new Exception("Not found the resource by id:" + bookInfo.getBookId());
		}
		//zipDownload(res);
		streamDownload(book);
		return null;
	}
	
	private void outputToInput(OutputStream os, InputStream is) throws IOException {
        byte[] buf = new byte[1024];
        int len;
        while ((len = is.read(buf)) > 0) {
                os.write(buf, 0, len);
        }
    }
}
