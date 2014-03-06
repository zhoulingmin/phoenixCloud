package com.phoenixcloud.book.action;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.math.BigInteger;
import java.util.Date;
import java.util.Map;

import javax.annotation.Resource;
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
import com.phoenixcloud.bean.PubDdv;
import com.phoenixcloud.bean.PubServerAddr;
import com.phoenixcloud.bean.RBook;
import com.phoenixcloud.bean.RBookRe;
import com.phoenixcloud.bean.SysStaff;
import com.phoenixcloud.book.service.IRBookMgmtService;
import com.phoenixcloud.common.PhoenixProperties;
import com.phoenixcloud.dao.PubDdvDao;
import com.phoenixcloud.dao.PubServerAddrDao;
import com.phoenixcloud.dao.RBookDao;
import com.phoenixcloud.dao.RBookReDao;
import com.phoenixcloud.util.MiscUtils;

@Scope("prototype")
@Component("bookResUploadAction")
public class RBookResUploadAction extends ActionSupport implements RequestAware, ServletResponseAware, SessionAware{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 5594103643943274932L;
	private RequestMap request;
	private HttpServletResponse response;
	private SessionMap session;

	private File resFile;
	private String resFileContentType;
	private String resFileFileName;

	private RBookRe bookRes;
	
	@Resource(name="bookMgmtServiceImpl")
	private IRBookMgmtService iBookService;
	
	@Autowired
	private PubServerAddrDao serAddrDao;
	
	@Autowired
	private RBookDao bookDao;
	
	@Autowired
	private PubDdvDao ddvDao;
	
	@Autowired
	private RBookReDao resDao;
	
	PhoenixProperties phoenixProp = PhoenixProperties.getInstance();
	
	public void setiBookService(IRBookMgmtService iBookService) {
		this.iBookService = iBookService;
	}

	public File getResFile() {
		return resFile;
	}

	public void setResFile(File resFile) {
		this.resFile = resFile;
	}

	public String getResFileContentType() {
		return resFileContentType;
	}

	public void setResFileContentType(String resFileContentType) {
		this.resFileContentType = resFileContentType;
	}

	public String getResFileFileName() {
		return resFileFileName;
	}

	public void setResFileFileName(String resFileFileName) {
		this.resFileFileName = resFileFileName;
	}
		
	public String batchUploadBookRes() throws Exception {
		
		SysStaff staff = (SysStaff)session.get("user");
		if (staff != null) {
			PubServerAddr serAddr = serAddrDao.find(staff.getOrgId().toString());
			if (serAddr != null) {
				bookRes.setIpAddr(serAddr.getBookSerIp());
			}
			bookRes.setStaffId(new BigInteger(staff.getStaffId()));
		}
		
		Date date = new Date();
		bookRes.setCreateTime(date);
		bookRes.setUpdateTime(date);
		bookRes.setName(resFileFileName);
		resDao.persist(bookRes);
		
		uploadRes();

		return null;
	}

	public RBookRe getBookRes() {
		return bookRes;
	}

	public void setBookRes(RBookRe bookRes) {
		this.bookRes = bookRes;
	}

	public String uploadRes() throws Exception {
		
		if (resFile == null) {
			throw new Exception("上传资源出错！");
		}
		
		RBookRe res = iBookService.findBookRes(bookRes.getResId());
		if (res == null) {
			throw new Exception("数据库中无法找到目标资源！");
		}
		
		SysStaff staff = (SysStaff)session.get("user");
		if (staff == null) {
			throw new Exception("没有合适用户！");
		}
		
		FileInputStream fis = null;
		FileOutputStream os = null;
		
		RBook book = bookDao.find(bookRes.getBookId().toString());
		if (book == null) {
			throw new Exception("没有找到相应的书籍！");
		}
		
		PubServerAddr addr = serAddrDao.find(staff.getOrgId().toString());
		PubDdv cataAddr = ddvDao.find(book.getCataAddrId().toString());
		
		StringBuffer outPath = new StringBuffer();
		String localPath = "";
		if (book.getIsUpload() == (byte)0) {
			if (addr != null) {
				localPath = addr.getBookDir();
			} else {
				localPath = phoenixProp.getProperty("book_file_folder");
			}
			localPath += File.separator;
			outPath.append(localPath);
			outPath.append(book.getBookNo());
		} else {
			localPath = book.getLocalPath();
			int lastIdx = localPath.lastIndexOf("/");
			if (lastIdx != -1) {
				localPath = localPath.substring(0, lastIdx);
			}
			outPath.append(localPath);
		}
		outPath.append(File.separator);
		outPath.append(cataAddr.getValue());
		
		outPath.append(File.separator);
		outPath.append(bookRes.getCataAddr());
		
		outPath.append(File.separator);
		outPath.append(res.getResId());

		File resFolder = new File(outPath.toString());
		if (!resFolder.exists()) {
			try {
				resFolder.mkdirs();
			} catch (SecurityException e) {
				MiscUtils.getLogger().info(e.toString());
			}
		}
		
		outPath.append(File.separator);
		outPath.append(resFileFileName);
		
		File file = new File(outPath.toString());
		try {
			if (file.exists()) {
				file.delete();
			}
			fis = new FileInputStream(resFile);
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
			// 上传成功后，更新资源存放地址
			String localAllAddr = outPath.toString().replace(File.separator, "/");
			String tmpAllAddr = "";
			do {
				tmpAllAddr = localAllAddr;
				localAllAddr = localAllAddr.replaceAll("//", "/");
			} while(tmpAllAddr.length() != localAllAddr.length());
			String protocol = phoenixProp.getProperty("protocol_file_transfer");
			String port = phoenixProp.getProperty("hfs_port");
			
			res.setAllAddr(protocol + "://" + res.getIpAddr() + ":" + port + "/" + localAllAddr);
			res.setUpdateTime(new Date());
			res.setIsUpload((byte)1);
			res.setName(resFileFileName);
			iBookService.saveBookRes(res);
			
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
	public void setSession(Map<String, Object> session) {
		// TODO Auto-generated method stub
		this.session = (SessionMap)session;
	}
}
