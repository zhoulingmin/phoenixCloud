package com.phoenixcloud.book.action;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Date;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts2.dispatcher.RequestMap;
import org.apache.struts2.interceptor.RequestAware;
import org.apache.struts2.interceptor.ServletResponseAware;
import org.springframework.stereotype.Component;

import com.phoenixcloud.bean.RBook;
import com.phoenixcloud.book.service.IRBookMgmtService;
import com.phoenixcloud.common.PhoenixProperties;
import com.phoenixcloud.util.MiscUtils;

import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

@Component("bookUploadAction")
public class RBookUploadAction extends ActionSupport implements RequestAware, ServletResponseAware{
	private static final long serialVersionUID = -3430678334134919673L;
	private RequestMap request;
	private HttpServletResponse response;

	private File bookFile;
	private String bookFileContentType;
	private String bookFileFileName;

	private String bookId;
	
	@Resource(name="bookMgmtServiceImpl")
	private IRBookMgmtService iBookService;
	
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
		
		FileInputStream fis = null;
		FileOutputStream os = null;
		
		StringBuffer outPath = new StringBuffer();
		outPath.append(phoenixProp.getProperty("book_file_folder"));
		outPath.append(File.separator);
		
		RBook book = iBookService.findBook(bookId);
		if (book == null) {
			throw new Exception("数据库中无法找到目标书籍！");
		}
		
		outPath.append(book.getBookId());
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
			book.setAllAddr(outPath.toString());
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
}
