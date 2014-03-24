package com.phoenixcloud.book.action;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.math.BigInteger;
import java.net.URLEncoder;
import java.util.Date;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.core.MediaType;

import net.sf.json.JSONObject;

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
import com.phoenixcloud.dao.ctrl.PubDdvDao;
import com.phoenixcloud.dao.ctrl.PubServerAddrDao;
import com.phoenixcloud.dao.res.RBookDao;
import com.phoenixcloud.dao.res.RBookReDao;
import com.phoenixcloud.util.MiscUtils;
import com.sun.jersey.api.client.Client;
import com.sun.jersey.api.client.WebResource;

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
	private RBook bookInfo;
	
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

	public RBook getBookInfo() {
		return bookInfo;
	}

	public void setBookInfo(RBook bookInfo) {
		this.bookInfo = bookInfo;
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
		
		RBook book = bookDao.find(bookRes.getBookId().toString());
		if (book == null) {
			throw new Exception("没有找到相应的书籍！");
		}
		
		PubServerAddr addr = serAddrDao.find(staff.getOrgId().toString());
		
		StringBuffer baseURL = new StringBuffer();
		baseURL.append("http://");
		baseURL.append(addr.getBookSerIp() + ":" + addr.getBookSerPort() + "/");
		baseURL.append(phoenixProp.getProperty("res_server_appname"));
		baseURL.append("/rest/res/");

		StringBuffer suffixURL = new StringBuffer();
		suffixURL.append("/" + book.getBookNo());
		suffixURL.append("/" +  URLEncoder.encode(bookRes.getCataAddr(), "utf-8"));
		suffixURL.append("/" + URLEncoder.encode(resFileFileName, "utf-8"));
		JSONObject retObj = upoadResToResServer(baseURL.toString() + "uploadFile" + suffixURL);
		if ((Integer)retObj.get("ret") == 1) {
			MiscUtils.getLogger().info(retObj.get("error"));
			return "success";
		}
		res.setAllAddr(baseURL.toString() + "downloadFile" + suffixURL);
		res.setUpdateTime(new Date());
		res.setIsUpload((byte)1);
		res.setName(resFileFileName);
		iBookService.saveBookRes(res);
			
		return "success";
	}

	private JSONObject upoadResToResServer(String url) throws Exception {
			
			Client client = new Client();
			WebResource webRes = client.resource(url);
			webRes.accept(MediaType.APPLICATION_JSON);
			client.setChunkedEncodingSize(1024 * 16);
			String contentDisposition = "attachment; filename=\"" + resFileFileName + "\"";
			String responseObj = webRes.type(MediaType.APPLICATION_OCTET_STREAM)
				.header("Content-Disposition", contentDisposition)
				.post(String.class, new FileInputStream(resFile));
			
			return JSONObject.fromObject(responseObj);
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
