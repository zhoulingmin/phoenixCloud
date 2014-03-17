package com.phoenixcloud.book.action;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Date;
import java.util.Map;

import javax.annotation.Resource;
import javax.mail.Session;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts2.dispatcher.RequestMap;
import org.apache.struts2.dispatcher.SessionMap;
import org.apache.struts2.interceptor.RequestAware;
import org.apache.struts2.interceptor.ServletResponseAware;
import org.apache.struts2.interceptor.SessionAware;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import com.opensymphony.xwork2.ActionSupport;
import com.phoenixcloud.bean.PubServerAddr;
import com.phoenixcloud.bean.RBook;
import com.phoenixcloud.bean.SysStaff;
import com.phoenixcloud.book.service.IRBookMgmtService;
import com.phoenixcloud.common.PhoenixProperties;
import com.phoenixcloud.dao.ctrl.PubServerAddrDao;
import com.phoenixcloud.util.MiscUtils;

@Scope("prototype")
@Component("bookUploadAction")
public class RBookUploadAction extends ActionSupport implements RequestAware, ServletResponseAware, SessionAware{
	private static final long serialVersionUID = -3430678334134919673L;
	private RequestMap request;
	private HttpServletResponse response;
	private SessionMap session;

	private File bookFile;
	private String bookFileContentType;
	private String bookFileFileName;

	private String bookId;
	
	@Resource(name="bookMgmtServiceImpl")
	private IRBookMgmtService iBookService;
	
	@Autowired
	private PubServerAddrDao serAddrDao;
	
	PhoenixProperties phoenixProp = PhoenixProperties.getInstance();
	
	public void setiBookService(IRBookMgmtService iBookService) {
		this.iBookService = iBookService;
	}
	
	public File getBookFile() {
		return bookFile;
	}

	public void setBookFile(File bookFile) {
		this.bookFile = bookFile;
	}


	public String getBookFileContentType() {
		return bookFileContentType;
	}

	public void setBookFileContentType(String bookFileContentType) {
		this.bookFileContentType = bookFileContentType;
	}

	public String getBookFileFileName() {
		return bookFileFileName;
	}

	public void setBookFileFileName(String bookFileFileName) {
		this.bookFileFileName = bookFileFileName;
	}

	public String getBookId() {
		return bookId;
	}

	public void setBookId(String bookId) {
		this.bookId = bookId;
	}

	public String uploadBook() throws Exception {
		
		if (bookFile == null) {
			throw new Exception("上传文件出错！");
		}
		
		SysStaff staff = (SysStaff)session.get("user");
		if (staff == null) {
			throw new Exception("没有合适用户！");
		}
		
		FileInputStream fis = null;
		FileOutputStream os = null;
		
		PubServerAddr addr = serAddrDao.find(staff.getOrgId().toString());

		StringBuffer outPath = new StringBuffer();
		if (addr != null) {
			outPath.append(addr.getBookDir());
		} else {
			outPath.append(phoenixProp.getProperty("book_file_folder"));
		}
		outPath.append(File.separator);
		
		RBook book = iBookService.findBook(bookId);
		if (book == null) {
			throw new Exception("数据库中无法找到目标书籍！");
		}
		
		outPath.append(book.getBookNo());
		outPath.append(File.separator);
		
		File bookFolder = new File(outPath.toString());
		if (!bookFolder.exists()) {
			try {
				bookFolder.mkdirs();
			} catch (SecurityException e) {
				MiscUtils.getLogger().info(e.toString());
			}
		}
		
		outPath.append(bookFileFileName);
		
		File file = new File(outPath.toString());
		try {
			if (file.exists()) {
				file.delete();
			}
			fis = new FileInputStream(bookFile);
			os = new FileOutputStream(file);
			byte[] buffer = new byte[1024 * 16];
			try {
				while ((fis.read(buffer)) != -1) {
					try {
						os.write(buffer);
					} catch (IOException e) {
						e.printStackTrace();
					}
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
			// 上传成功后，更新书籍存放地址
			String localPath = outPath.toString().replace(File.separator, "/");
			String tmpPath = "";
			do {
				tmpPath = localPath;
				localPath = localPath.replaceAll("//", "/");
			} while (tmpPath.length() != localPath.length());
			if (!localPath.startsWith("/")) {
				localPath = "/" + localPath;
			}
			String protocol = phoenixProp.getProperty("protocol_file_transfer");
			String port = phoenixProp.getProperty("hfs_port");
			book.setAllAddr(protocol + "://" + book.getIpAddr() + ":" + port + localPath);
			book.setUpdateTime(new Date());
			book.setIsUpload((byte)1);
			iBookService.saveBook(book);
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} finally {
			try {
				fis.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
			try {
				os.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		
		return "success";
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
	
	public void addActionError(String anErrorMessage) {
		MiscUtils.getLogger().info(anErrorMessage);
	}
	
	public void addActionMessage(String aMessage) {
		MiscUtils.getLogger().info(aMessage);
	}
	
	public void addFieldError(String fieldName, String errorMessage) {
		MiscUtils.getLogger().info(fieldName);
		MiscUtils.getLogger().info(errorMessage);
	}

	@Override
	public void setSession(Map<String, Object> arg0) {
		// TODO Auto-generated method stub
		this.session = (SessionMap)arg0;
	}
}
