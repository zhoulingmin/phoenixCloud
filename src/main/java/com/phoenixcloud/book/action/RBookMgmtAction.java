package com.phoenixcloud.book.action;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.math.BigInteger;
import java.net.URLEncoder;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.core.MediaType;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;
import net.sf.json.processors.JsonBeanProcessor;

import org.apache.commons.lang3.StringUtils;
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
import com.phoenixcloud.bean.SysStaff;
import com.phoenixcloud.book.service.IRBookMgmtService;
import com.phoenixcloud.common.Constants;
import com.phoenixcloud.common.PhoenixProperties;
import com.phoenixcloud.dao.ctrl.PubDdvDao;
import com.phoenixcloud.dao.ctrl.PubOrgDao;
import com.phoenixcloud.dao.ctrl.PubPressDao;
import com.phoenixcloud.dao.ctrl.PubServerAddrDao;
import com.phoenixcloud.dao.res.RBookDao;
import com.phoenixcloud.system.service.ISysService;
import com.phoenixcloud.util.ClientHelper;
import com.phoenixcloud.util.MiscUtils;
import com.phoenixcloud.util.SpringUtils;
import com.sun.jersey.api.client.Client;
import com.sun.jersey.api.client.WebResource;

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
	private PhoenixProperties phoenixProp = PhoenixProperties.getInstance();
	
	@Autowired
	private RBookDao bookDao;
	
	@Autowired
	private PubServerAddrDao serAddrDao;
	
	private byte flag;
	private RBook bookInfo;
	private String bookIdArr; // used to remove book
	private String dataType;
	private String downloadUrl;
	
	private String errInfo = "";
	
	public String getErrInfo() {
		return errInfo;
	}

	public void setErrInfo(String errInfo) {
		this.errInfo = errInfo;
	}

	private String kindSeqNo;
	public String getKindSeqNo() {
		return kindSeqNo;
	}

	public void setKindSeqNo(String kindSeqNo) {
		this.kindSeqNo = kindSeqNo;
	}

	public String getQuarter() {
		return quarter;
	}

	public void setQuarter(String quarter) {
		this.quarter = quarter;
	}

	public String getYearOfRls() {
		return yearOfRls;
	}

	public void setYearOfRls(String yearOfRls) {
		this.yearOfRls = yearOfRls;
	}

	private String quarter;
	private String yearOfRls;
	
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

	
	
	public String getDownloadUrl() {
		return downloadUrl;
	}

	public void setDownloadUrl(String downloadUrl) {
		this.downloadUrl = downloadUrl;
	}

	public String addBook() {
		JSONObject ret = new JSONObject();
		
		String bookNo = iBookService.genBookNo(bookInfo, yearOfRls, quarter, kindSeqNo);
		boolean isExist = iBookService.checkBookNoExist(bookNo);
		if (isExist) {
			ret.put("ret", 1);
			ret.put("reason", "书籍编码重复或书籍已存在！");
		} else {
			bookInfo.setBookNo(bookNo);
			Date date = new Date();
			bookInfo.setCreateTime(date);
			bookInfo.setUpdateTime(date);
			
			SysStaff curStaff = (SysStaff)session.get("user");
			if (curStaff != null) {
				bookInfo.setStaffId(new BigInteger(curStaff.getStaffId()));
				PubServerAddr serAddr = iSysService.findServerAddrByOrgId(curStaff.getOrgId(), Constants.OUT_NET);
				if (serAddr != null) {
					bookInfo.setIpAddr(serAddr.getBookSerIp());
				}
				bookInfo.setOrgId(curStaff.getOrgId());
			} else {
				bookInfo.setStaffId(BigInteger.ZERO);
			}
			try {
				iBookService.saveBook(bookInfo);
				ret.put("ret", 0);
			} catch (Exception e) {
				MiscUtils.getLogger().info(e.toString());
				ret.put("ret", 1);
				ret.put("reason", "保存书籍出错！");
			}
		}
		
		response.setCharacterEncoding("utf-8");
		response.setContentType("text/html");
		
		try {
			PrintWriter out = response.getWriter();
			out.print(ret.toString());
			out.flush();
			out.close();
		} catch (Exception e) {
			MiscUtils.getLogger().info(e.toString());
		}
		
		return null;
	}
	
	public String getDataType() {
		return dataType;
	}

	public void setDataType(String dataType) {
		this.dataType = dataType;
	}
	
	private JSONObject changeFolderName(RBook book, String newBookNo) throws Exception{
		// 1. change book folder
		// 2. change book resource folder
		
		PubServerAddr inAddr = serAddrDao.findByOrgId(book.getOrgId(), Constants.IN_NET);
		PubServerAddr outAddr = serAddrDao.findByOrgId(book.getOrgId(), Constants.OUT_NET);
		PubServerAddr addr = iSysService.getProperAddr(inAddr, outAddr);
		if (addr == null) {
			MiscUtils.getLogger().info("没有合适的资源服务器！");
			JSONObject ret = new JSONObject();
			ret.put("ret", 1);
			ret.put("error", "没有合适的资源服务器！");
			return ret;
		}
		
		StringBuffer baseURL = new StringBuffer();
		baseURL.append(phoenixProp.getProperty("protocol_file_transfer") + "://");
		baseURL.append(addr.getBookSerIp() + ":" + addr.getBookSerPort() + "/");
		baseURL.append(phoenixProp.getProperty("res_server_appname"));
		baseURL.append("/rest/manageFiles/changeFolder?");
		baseURL.append("oldFolder=" + URLEncoder.encode(book.getBookNo(), "utf-8") + "&");
		baseURL.append("newFolder=" + URLEncoder.encode(newBookNo, "utf-8"));
		
		String url = baseURL.toString();
		MiscUtils.getLogger().info(url);
		Client client = null;
		if (url.startsWith("https")) {
			client = ClientHelper.createClient();
		} else {
			client = new Client();
		}
		WebResource webRes = client.resource(url);
		webRes.accept(MediaType.APPLICATION_JSON);
		String responseObj = webRes.type(MediaType.TEXT_PLAIN).post(String.class, "");

		return JSONObject.fromObject(responseObj);
	}

	public String editBook() throws Exception {
		if (bookInfo.getName() == null) { // 
			bookInfo = iBookService.findBook(bookInfo.getBookId());
			if (bookInfo == null) {
				throw new Exception("没有找到相应的书籍！");
			}
			request.put("kindSeqNo", bookInfo.getKindSeqNo());
			request.put("quarter", bookInfo.getQuarter());
			request.put("yearOfRls", bookInfo.getYearOfRls());
		} else {
			JSONObject ret = new JSONObject();
			RBook book = iBookService.findBook(bookInfo.getBookId());
			if (book == null) {
				throw new Exception("没有找到相应的书籍！");
			}
			String bookNo = iBookService.genBookNo(bookInfo, yearOfRls, quarter, kindSeqNo);
			boolean isExist = false;
			if (!bookNo.equals(book.getBookNo())) {
				MiscUtils.getLogger().info("书籍编码变化: " + book.getBookNo() + " -->> " + bookNo);
				isExist = iBookService.checkBookNoExist(bookNo);
			}
			
			if (isExist) {
				ret.put("ret", 1);
				ret.put("reason", "修改失败，书籍编码重复或书籍已存在！");
				MiscUtils.getLogger().info("修改失败，书籍编码重复或书籍已存在！");
			} else {
				// change the folder by rest api
				boolean saveFlag = true;
				do {
					if (bookNo.equals(book.getBookNo()) || book.getIsUpload() == (byte)0) {
						break;
					}
					JSONObject changeFolderRet = changeFolderName(book, bookNo);
					if (changeFolderRet != null && changeFolderRet.getInt("ret") == 0) {
						// change book path info
						if (book.getAllAddrInNet() != null) {
							book.setAllAddrInNet(book.getAllAddrInNet().replaceAll(book.getBookNo(), bookNo));
						}
						if (book.getAllAddrOutNet() != null) {
							book.setAllAddrOutNet(book.getAllAddrOutNet().replaceAll(book.getBookNo(), bookNo));
						}
						// change cover path info
						if (book.getCoverUrlInNet() != null){
							book.setCoverUrlInNet(book.getCoverUrlInNet().replaceAll(book.getBookNo(), bookNo));
						}
						if (book.getCoverUrlOutNet() != null){
							book.setCoverUrlOutNet(book.getCoverUrlOutNet().replaceAll(book.getBookNo(), bookNo));
						}
						
						// change resource's path info
						iBookService.changeResPathInfo(new BigInteger(book.getId()), book.getBookNo(), bookNo);
						break;
					} else {
						saveFlag = false;
						ret.put("ret", 1);
						if (changeFolderRet == null || changeFolderRet.get("error") == null) {
							ret.put("reason", "保存书籍出错: 修改存储路径失败！");
							MiscUtils.getLogger().info("保存书籍出错: 修改存储路径失败！");
						} else {
							ret.put("reason", changeFolderRet.get("error"));
							MiscUtils.getLogger().info(changeFolderRet.get("error"));
						}
						
					}
				} while (false);
				
				if (saveFlag) {
					book.setClassId(bookInfo.getClassId());
					book.setKindId(bookInfo.getKindId());
					book.setName(bookInfo.getName());
					book.setNotes(bookInfo.getNotes());
					//book.setOrgId(bookInfo.getOrgId());
					book.setPageNum(bookInfo.getPageNum());
					book.setPressId(bookInfo.getPressId());
					book.setStuSegId(bookInfo.getStuSegId());
					book.setSubjectId(bookInfo.getSubjectId());
					book.setBookNo(bookNo);
					book.setUpdateTime(new Date());
					try {
						iBookService.saveBook(book);
						ret.put("ret", 0);
					} catch (Exception e) {
						MiscUtils.getLogger().info(e.toString());
						ret.put("ret", "1");
						ret.put("reason", "保存书籍出错！");
					}
				}
			}
			
			response.setCharacterEncoding("utf-8");
			response.setContentType("text/html");
			
			try {
				PrintWriter out = response.getWriter();
				out.print(ret.toString());
				out.flush();
				out.close();
			} catch (Exception e) {
				MiscUtils.getLogger().info(e.toString());
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
	
	public String searchBookNew() {
		List<RBook> bookList = iBookService.searchBook(bookInfo);
		this.request.put("bookList", bookList);
		if (bookInfo.getIsAudit() == (byte) -1) {
			return "zhizuo";
		} else if (bookInfo.getIsAudit() == (byte) 0) {
			return "audit";
		} else if (bookInfo.getIsAudit() >= (byte) 1 ) {
			return "release";
		}
		
		return "querySearch";
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
							<th>册别</th>
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
					PubDdv sub = ddvDao.find(book.getSubjectId().toString());
					if (sub == null) {
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
					obj.element("sub", sub.getValue());
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
			} else if (flag == (byte)1 && book.getIsAudit() != (byte)0) { // 提交上架
				continue;
			} else if (flag == (byte)2 && book.getIsAudit() != (byte)1 && book.getIsAudit() != (byte)3) { // 上架
				continue;
			} else if (flag == (byte)3 && book.getIsAudit() != (byte)2) { // 下架
				continue;
			}
			
			book.setIsAudit(flag);
			book.setUpdateTime(new Date());
			bookDao.merge(book);
		}
		response.setContentType("text/html");
		response.setCharacterEncoding("utf-8");
		
		try {
			PrintWriter out = response.getWriter();
			JSONObject ret = new JSONObject();
			ret.put("flag", flag);
			out.print(ret.toString());
			out.flush();
			out.close();
		} catch (Exception e) {
			MiscUtils.getLogger().info(e.toString());
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
	
	public String showCover() {
		String conType = "image/jpeg";
		try {
			do {
				if (bookInfo == null || StringUtils.isBlank(bookInfo.getBookId())) {
					break;
				}
				RBook book = bookDao.find(bookInfo.getBookId());
				if (book == null) {
					break;
				}
				conType = book.getCoverContType(); 
				byte[] imgContent = book.getCoverImg();
				if (imgContent == null || imgContent.length == 0) {
					break;
				} else {
					response.setCharacterEncoding("utf-8");
					response.setContentType(conType);
					try {
						OutputStream out = response.getOutputStream();
						out.write(imgContent);
						out.flush();
						out.close();
					} catch (Exception e) {
						MiscUtils.getLogger().info(e.toString());
						break;
					}
				}
				
			} while(false);
			
			
			InputStream in = getClass().getResourceAsStream("/cover.jpg");
						
			if (in != null) {
				response.setCharacterEncoding("utf-8");
				response.setContentType(conType);
				
				OutputStream out = response.getOutputStream();
				byte[] buf = new byte[1024*16]; // 16K
				int count = 0;
				while ((count = in.read(buf)) != -1) {
					out.write(buf, 0, count);
				}
				out.flush();
				out.close();
				in.close();
			}
		} catch (Exception e) {
			MiscUtils.getLogger().info(e.toString());
		}
		return null;
	}
	
	public String downloadBook() {
		RBook book = bookDao.find(bookInfo.getBookId());
		if (book == null) {
			errInfo = "数据库中无法找到目标书籍！";
			return "error";
		}
		
		PubServerAddr outAddr = serAddrDao.findByOrgId(book.getOrgId(), Constants.OUT_NET);
		PubServerAddr addr = iSysService.getProperAddr(null, outAddr);
		if (addr != null) {
			downloadUrl = book.getAllAddrOutNet();
		} else {
			PubServerAddr inAddr = serAddrDao.findByOrgId(book.getOrgId(), Constants.IN_NET);
			addr = iSysService.getProperAddr(inAddr, null);
			if (addr != null) {
				downloadUrl = book.getAllAddrInNet();
			}
		}
		
		if (addr == null) {
			//throw new Exception("没有找到对应的资源服务器！");
			errInfo = "没有合适的资源服务器！";
			return "error";
		}
		
		return "success";
	}
}
