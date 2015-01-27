package com.phoenixcloud.book.action;

import java.io.File;
import java.io.FileInputStream;
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
import com.phoenixcloud.common.Constants;
import com.phoenixcloud.common.PhoenixProperties;
import com.phoenixcloud.dao.ctrl.PubDdvDao;
import com.phoenixcloud.dao.ctrl.PubServerAddrDao;
import com.phoenixcloud.dao.res.RBookDao;
import com.phoenixcloud.dao.res.RBookReDao;
import com.phoenixcloud.system.service.ISysService;
import com.phoenixcloud.util.ClientHelper;
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

	//资源文件
	private File resFile;
	//资源预览文件
	private File resFilePreview;

	private String resFileContentType;
	
	//资源文件名字
	private String resFileFileName;
	//资源预览文件名字
	private String resFilePreviewFileName;

	private RBookRe bookRes;
	private RBook bookInfo;
	private String errInfo = "上传出错";
	private String isPreview;
	
	
	public File getResFilePreview() {
		return resFilePreview;
	}

	public void setResFilePreview(File resFilePreview) {
		this.resFilePreview = resFilePreview;
	}
	
	public String getResFilePreviewFileName() {
		return resFilePreviewFileName;
	}

	public void setResFilePreviewFileName(String resFilePreviewFileName) {
		this.resFilePreviewFileName = resFilePreviewFileName;
	}

	public String getIsPreview() {
		return isPreview;
	}

	public void setIsPreview(String isPreview) {
		this.isPreview = isPreview;
	}

	public String getErrInfo() {
		return errInfo;
	}

	public void setErrInfo(String errInfo) {
		this.errInfo = errInfo;
	}

	@Resource(name="bookMgmtServiceImpl")
	private IRBookMgmtService iBookService;
	
	@Resource(name="sysServiceImpl")
	private ISysService iSysService;

	public void setiSysService(ISysService iSysService) {
		this.iSysService = iSysService;
	}
	
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
//System.out.println("isPreview^^^^^^^^^^"+isPreview);
		//上传资源附件
		if(isPreview.equals("false"))			
		{
//System.out.println("现在的操作是：上传资源附件");
			if (resFile == null) {
				errInfo = "上传资源出错！";
				return "error";
			}
			
			RBookRe res = iBookService.findBookRes(bookRes.getResId());
			if (res == null) {
				errInfo = "数据库中无法找到目标资源！";
				return "error";
			}
			
			SysStaff staff = (SysStaff)session.get("user");
			if (staff == null) {
				errInfo = "没有合适用户！";
				return "error";
			}
			
			RBook book = bookDao.find(bookRes.getBookId().toString());
			if (book == null) {
				errInfo = "没有找到相应的书籍！";
				return "error";
			}
			
			/*PubServerAddr addr = null;
			do {
				// 1.先根据书籍的orgId查找
				addr = serAddrDao.findByOrgId(book.getOrgId());
				// 2.查不到则查上层机构是否有addr
				if (addr == null) {
					addr = iSysService.findParentAddrByOrgId(book.getOrgId());
				}
				// 3.查不到则用当前账号的orgId查找
				if (addr == null) {
					addr = serAddrDao.findByOrgId(staff.getOrgId());
				}
				// 4.查不到则查上层机构是否有addr
				if (addr == null) {
					addr = iSysService.findParentAddrByOrgId(staff.getOrgId());
				}
			} while (false);*/
			PubServerAddr inAddr = serAddrDao.findByOrgId(book.getOrgId(), Constants.IN_NET);
			PubServerAddr outAddr = serAddrDao.findByOrgId(book.getOrgId(), Constants.OUT_NET);
			PubServerAddr addr = iSysService.getProperAddr(inAddr, outAddr);
			if (addr == null) {
				//throw new Exception("没有找到对应的资源服务器！");
				errInfo = "没有合适的资源服务器！";
				return "error";
			}
			StringBuffer baseURL = new StringBuffer();
			baseURL.append(phoenixProp.getProperty("protocol_file_transfer") + "://");
			baseURL.append(addr.getBookSerIp() + ":" + addr.getBookSerPort() + "/");
			baseURL.append(phoenixProp.getProperty("res_server_appname"));
			baseURL.append("/rest/res/");
	
			StringBuffer suffixURL = new StringBuffer();
			suffixURL.append("/" + URLEncoder.encode(book.getBookNo(), "utf-8"));
			
			PubDdv ddv = ddvDao.find(res.getFormat().toString());
			if (ddv != null) {
				suffixURL.append("/" +  URLEncoder.encode(ddv.getValue(), "utf-8"));
			}
			
			suffixURL.append("/" + URLEncoder.encode(resFileFileName, "utf-8"));
			try {
				JSONObject retObj = upoadResToResServer(baseURL.toString() + "uploadFile" + suffixURL);
				if ((Integer)retObj.get("ret") == 1) {
					MiscUtils.getLogger().info(retObj.get("error"));
					errInfo = "上传失败！";
					return "error";
				}
			} catch (Exception e) {
				MiscUtils.getLogger().info(e.toString());
				errInfo = "无法连接资源服务器！";
				return "error";
			}
			
			//HttpServletRequest req = ServletActionContext.getRequest();
			String scheme = phoenixProp.getProperty("protocol_file_transfer") + "://";
			//String host = req.getServerName();
			//int port = addr.getBookSerPort();
			String ctxName = phoenixProp.getProperty("res_server_appname");
			
			//res.setAllAddr(scheme + host + ":" + port + "/" + ctxName +  "/rest/res/downloadFile" + suffixURL);
			
			
			if (inAddr != null){
				//资源文件地址
				res.setAllAddrInNet(scheme + inAddr.getBookSerIp() + ":" + inAddr.getBookSerPort() + "/" + ctxName +  "/rest/res/downloadFile" + suffixURL);
			}
			
			if (outAddr != null){
				//资源文件地址
				res.setAllAddrOutNet(scheme + outAddr.getBookSerIp() + ":" + outAddr.getBookSerPort() + "/" + ctxName +  "/rest/res/downloadFile" + suffixURL);
			}		
			
			res.setUpdateTime(new Date());
			res.setIsUpload((byte)1);
			res.setName(resFileFileName);
			iBookService.saveBookRes(res);
				
			return "success";
		} else {
			//上传资源预览文件
//System.out.println("现在的操作是：上传资源预览文件");			
			if (resFilePreview == null) {
				errInfo = "上传资源出错！";
				return "error";
			}
			
			RBookRe res = iBookService.findBookRes(bookRes.getResId());
			if (res == null) {
				errInfo = "数据库中无法找到目标资源！";
				return "error";
			}
			
			SysStaff staff = (SysStaff)session.get("user");
			if (staff == null) {
				errInfo = "没有合适用户！";
				return "error";
			}
			
			RBook book = bookDao.find(bookRes.getBookId().toString());
			if (book == null) {
				errInfo = "没有找到相应的书籍！";
				return "error";
			}
			
			
			PubServerAddr inAddr = serAddrDao.findByOrgId(book.getOrgId(), Constants.IN_NET);
			PubServerAddr outAddr = serAddrDao.findByOrgId(book.getOrgId(), Constants.OUT_NET);
			PubServerAddr addr = iSysService.getProperAddr(inAddr, outAddr);
			if (addr == null) {
				//throw new Exception("没有找到对应的资源服务器！");
				errInfo = "没有合适的资源服务器！";
				return "error";
			}
			StringBuffer baseURL = new StringBuffer();
			baseURL.append(phoenixProp.getProperty("protocol_file_transfer") + "://");
			baseURL.append(addr.getBookSerIp() + ":" + addr.getBookSerPort() + "/");
			baseURL.append(phoenixProp.getProperty("res_server_appname"));
			baseURL.append("/rest/res/");
	
			StringBuffer suffixURL = new StringBuffer();
			suffixURL.append("/" + URLEncoder.encode(book.getBookNo(), "utf-8"));
			
			PubDdv ddv = ddvDao.find(res.getFormat().toString());
			if (ddv != null) {
				suffixURL.append("/" +  URLEncoder.encode(ddv.getValue(), "utf-8"));
			}
			
			
			////将资源预览文件保存到Preview文件夹下
			suffixURL.append("/" + URLEncoder.encode("preview", "utf-8"));
			
			
			suffixURL.append("/" + URLEncoder.encode(resFilePreviewFileName, "utf-8"));
			try {
				JSONObject retObj = upoadResPreviewToResServer(baseURL.toString() + "uploadFile" + suffixURL);
				if ((Integer)retObj.get("ret") == 1) {
					MiscUtils.getLogger().info(retObj.get("error"));
					errInfo = "上传失败！";
					return "error";
				}
			} catch (Exception e) {
				e.printStackTrace();
				MiscUtils.getLogger().info(e.toString());
				errInfo = "无法连接资源服务器！";
				return "error";
			}
			
			String scheme = phoenixProp.getProperty("protocol_file_transfer") + "://";
			String ctxName = phoenixProp.getProperty("res_server_appname");
			
			
			if (inAddr != null){
				//资源预览文件地址
//System.out.println("PreviewAddrInNet>>>>>>>>>>>"+scheme + inAddr.getBookSerIp() + ":" + inAddr.getBookSerPort() + "/" + ctxName +  "/rest/res/downloadFile" + suffixURL);				
				res.setPreviewAddrInNet(scheme + inAddr.getBookSerIp() + ":" + inAddr.getBookSerPort() + "/" + ctxName +  "/rest/res/downloadFile" + suffixURL);
			}
			
			if (outAddr != null){
				//资源预览文件地址
//System.out.println("PreviewAddrOutNet>>>>>>>>>>>"+scheme + outAddr.getBookSerIp() + ":" + outAddr.getBookSerPort() + "/" + ctxName +  "/rest/res/downloadFile" + suffixURL);				
				res.setPreviewAddrOutNet(scheme + outAddr.getBookSerIp() + ":" + outAddr.getBookSerPort() + "/" + ctxName +  "/rest/res/downloadFile" + suffixURL);
			}		
			
			iBookService.saveBookRes(res);
				
			return "success";
		}
	}
	
	
	//上传资源文件到文件服务器
	private JSONObject upoadResToResServer(String url) throws Exception {
//System.out.println("现在的操作是：上传资源文件到文件服务器");		
		MiscUtils.getLogger().info("URL: " + url);
		Client client = null;
		if (url.startsWith("https")) {
			/*HostnameVerifier hv = new HostnameVerifier() {
				@Override
				public boolean verify(String hostname, SSLSession session) {
					MiscUtils.getLogger().warn("Warning: URL Host: " + hostname
							+ " vs. " + session.getPeerHost());
					return true;
				}
			};
			HttpsURLConnection.setDefaultHostnameVerifier(hv); 
			try {
				// Create a trust manager that does not validate certificate
				// chains
				TrustManager[] trustAllCerts = new TrustManager[] { new X509TrustManager() {
					public void checkClientTrusted(
							java.security.cert.X509Certificate[] certs,
							String authType) {
					}

					public void checkServerTrusted(
							java.security.cert.X509Certificate[] certs,
							String authType) {
					}

					public java.security.cert.X509Certificate[] getAcceptedIssuers() {
						return null;
					}
				}};

				// Install the all-trusting trust manager
				SSLContext sc = SSLContext.getInstance("SSL");
				sc.init(null, trustAllCerts, new java.security.SecureRandom());
				HttpsURLConnection.setDefaultSSLSocketFactory(sc
						.getSocketFactory());
				
				ClientConfig config = new DefaultClientConfig();
				config.getProperties().put(HTTPSProperties.PROPERTY_HTTPS_PROPERTIES,
	                    new HTTPSProperties(hv, sc));
				client = Client.create(config);
			} catch (Exception ex) {
				throw new RuntimeException(ex);
			}*/
			client = ClientHelper.createClient();
		} else {
			client = new Client();
		}
		WebResource webRes = client.resource(url);
		webRes.accept(MediaType.APPLICATION_JSON);
		client.setChunkedEncodingSize(1024);
		String contentDisposition = "attachment; filename=\"" + resFileFileName + "\"";
		String responseObj = webRes.type(MediaType.APPLICATION_OCTET_STREAM)
			.header("Content-Disposition", contentDisposition)
			.post(String.class, new FileInputStream(resFile));
		
		return JSONObject.fromObject(responseObj);
	}
	
	//上传资源预览文件到文件服务器
	private JSONObject upoadResPreviewToResServer(String url) throws Exception {
//System.out.println("现在的操作是：上传资源预览文件到文件服务器");		
		MiscUtils.getLogger().info("URL: " + url);
		Client client = null;
		if (url.startsWith("https")) {
			client = ClientHelper.createClient();
		} else {
			client = new Client();
		}
		WebResource webRes = client.resource(url);
		webRes.accept(MediaType.APPLICATION_JSON);
		client.setChunkedEncodingSize(1024);
		String contentDisposition = "attachment; filename=\"" + resFilePreviewFileName + "\"";
		String responseObj = webRes.type(MediaType.APPLICATION_OCTET_STREAM)
			.header("Content-Disposition", contentDisposition)
			.post(String.class, new FileInputStream(resFilePreview));
		
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
