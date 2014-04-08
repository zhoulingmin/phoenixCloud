package com.phoenixcloud.book.action;

import java.io.File;
import java.io.FileInputStream;
import java.net.URLEncoder;
import java.security.cert.X509Certificate;
import java.util.Date;
import java.util.Map;

import javax.annotation.Resource;
import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSession;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;
import javax.security.cert.CertificateException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.core.MediaType;

import net.sf.json.JSONObject;

import org.apache.commons.lang3.StringUtils;
import org.apache.struts2.ServletActionContext;
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
import com.phoenixcloud.dao.res.RBookDao;
import com.phoenixcloud.util.ClientHelper;
import com.phoenixcloud.util.MiscUtils;
import com.sun.jersey.api.client.Client;
import com.sun.jersey.api.client.WebResource;
import com.sun.jersey.api.client.config.ClientConfig;
import com.sun.jersey.api.client.config.DefaultClientConfig;
import com.sun.jersey.client.urlconnection.HTTPSProperties;
import com.sun.jersey.multipart.FormDataMultiPart;
import com.sun.jersey.multipart.file.FileDataBodyPart;

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
	
	private File coverFile;
	private String coverFileContentType;
	private String coverFileFileName;

	private String bookId;
	
	@Resource(name="bookMgmtServiceImpl")
	private IRBookMgmtService iBookService;
	
	@Autowired
	private PubServerAddrDao serAddrDao;
	
	@Autowired
	private RBookDao bookDao;
	
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

	public File getCoverFile() {
		return coverFile;
	}

	public void setCoverFile(File coverFile) {
		this.coverFile = coverFile;
	}

	public String getCoverFileContentType() {
		return coverFileContentType;
	}

	public void setCoverFileContentType(String coverFileContentType) {
		this.coverFileContentType = coverFileContentType;
	}

	public String getCoverFileFileName() {
		return coverFileFileName;
	}

	public void setCoverFileFileName(String coverFileFileName) {
		this.coverFileFileName = coverFileFileName;
	}

	public String uploadBook() throws Exception {
		
		if (bookFile == null) {
			throw new Exception("上传文件出错！");
		}
		
		SysStaff staff = (SysStaff)session.get("user");
		if (staff == null) {
			throw new Exception("没有合适用户！");
		}
		
		PubServerAddr addr = serAddrDao.findByOrgId(staff.getOrgId());
		
		if (addr == null) {
			throw new Exception("没有找到对应的资源服务器！");
		}
		
		RBook book = iBookService.findBook(bookId);
		if (book == null) {
			throw new Exception("数据库中无法找到目标书籍！");
		}
		
		StringBuffer baseURL = new StringBuffer();
		baseURL.append(phoenixProp.getProperty("protocol_file_transfer") + "://");
		baseURL.append(addr.getBookSerIp() + ":" + addr.getBookSerPort() + "/");
		baseURL.append(phoenixProp.getProperty("res_server_appname"));
		baseURL.append("/rest/book/");

		StringBuffer suffixURL = new StringBuffer();
		suffixURL.append("/" + book.getBookNo());
		suffixURL.append("/" + URLEncoder.encode(bookFileFileName, "utf-8"));
		JSONObject retObj = upoadBookToResServer(baseURL.toString() + "uploadFile" + suffixURL);
		if ((Integer)retObj.get("ret") == 1) {
			MiscUtils.getLogger().info(retObj.get("error"));
			return "success";
		}
		HttpServletRequest req = ServletActionContext.getRequest();
		String scheme = phoenixProp.getProperty("protocol_file_transfer") + "://";
		String host = req.getServerName();
		int port = addr.getBookSerPort();
		String ctxName = phoenixProp.getProperty("res_server_appname");
		
		book.setAllAddr(scheme + host + ":" + port + "/" + ctxName +  "/rest/book/downloadFile" + suffixURL);
		book.setUpdateTime(new Date());
		book.setIsUpload((byte)1);
		iBookService.saveBook(book);
		
		return "success";
	}
	
	private JSONObject upoadBookToResServer(String url) throws Exception {
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
		client.setChunkedEncodingSize(1024 * 16);
		String contentDisposition = "attachment; filename=\"" + bookFileFileName + "\"";
		String responseObj = webRes.type(MediaType.APPLICATION_OCTET_STREAM)
			.header("Content-Disposition", contentDisposition)
			.post(String.class, new FileInputStream(bookFile));
		
		return JSONObject.fromObject(responseObj);
		
//		if (bookFile.length() < 10 * 1024) {
//			FormDataMultiPart form = new FormDataMultiPart();
//	        form.bodyPart(new FileDataBodyPart("file", bookFile, MediaType.MULTIPART_FORM_DATA_TYPE));
//	        webRes.accept(MediaType.APPLICATION_JSON);
//	        webRes.path(book.getBookNo()).path(bookFileFileName);
//	        String contentDisposition = "attachment; filename=\"" + bookFileFileName;
//	        webRes.type(MediaType.APPLICATION_OCTET_STREAM).
//	        JSONObject responseObj = webRes.type(MediaType.MULTIPART_FORM_DATA)
//	        		.header("Content-Disposition", contentDisposition)
//	        		.header("Content-Type", bookFileContentType).post(JSONObject.class, form);
//		} else {
//			InputStream fileInStream = new FileInputStream(bookFile);
//			String sContentDisposition = "attachment; filename=\"" + bookFile.getName()+"\"";
//			response = webRes.type(MediaType.APPLICATION_OCTET_STREAM).header("Content-Disposition", 
//					sContentDisposition).post(ClientResponse.class, fileInStream);
//		}
//		return responseObj;
	}
	
	private void uploadByForm(String url) {
		url = "http://localhost:8080/resserver/rest/book/test/";
		Client client = new Client();
		WebResource webRes = client.resource(url);
		webRes.accept(MediaType.APPLICATION_JSON);
		client.setChunkedEncodingSize(1024 * 16);
		String contentDisposition = "attachment; filename=\"" + bookFileFileName;
		
		FormDataMultiPart form = new FormDataMultiPart();
        form.bodyPart(new FileDataBodyPart("file", bookFile, MediaType.MULTIPART_FORM_DATA_TYPE));
        form.field("fileName", "testFileName");
        webRes.accept(MediaType.APPLICATION_JSON);
		
        String responseObj = webRes.type(MediaType.MULTIPART_FORM_DATA)
        		.header("Content-Disposition", contentDisposition)
        		.post(String.class, form);
        MiscUtils.getLogger().info(responseObj);
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
	
	public String uploadBookCover() {
		try {
			do {
				if (bookId == null || StringUtils.isBlank(bookId)) {
					break;
				}
				RBook book = bookDao.find(bookId);
				if (book == null) {
					break;
				}
				book.setCoverContType(coverFileContentType);
				byte[] img = new byte[(int) coverFile.length()];
				
				int count = new FileInputStream(coverFile).read(img);
				if (count != coverFile.length()) {
					book.setCoverImg(null);
				} else {
					book.setCoverImg(img);
				}
				bookDao.merge(book);
			} while(false);
		} catch (Exception e) {
			MiscUtils.getLogger().info(e.toString());
		}
		return "success";
	}
}
