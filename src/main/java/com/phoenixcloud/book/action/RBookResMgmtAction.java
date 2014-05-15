package com.phoenixcloud.book.action;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.math.BigInteger;
import java.util.ArrayList;
import java.util.Date;
import java.util.EmptyStackException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Stack;


import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;
import org.apache.struts2.dispatcher.RequestMap;
import org.apache.struts2.dispatcher.SessionMap;
import org.apache.struts2.interceptor.RequestAware;
import org.apache.struts2.interceptor.ServletResponseAware;
import org.apache.struts2.interceptor.SessionAware;
import org.apache.tools.zip.ZipEntry;
import org.apache.tools.zip.ZipOutputStream;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import com.opensymphony.xwork2.ActionSupport;
import com.phoenixcloud.agency.service.IAgencyMgmtService;
import com.phoenixcloud.bean.PubOrg;
import com.phoenixcloud.bean.PubOrgCata;
import com.phoenixcloud.bean.PubServerAddr;
import com.phoenixcloud.bean.RBook;
import com.phoenixcloud.bean.RBookPageRes;
import com.phoenixcloud.bean.RBookRe;
import com.phoenixcloud.bean.SysStaff;
import com.phoenixcloud.book.service.IRBookMgmtService;
import com.phoenixcloud.book.vo.BookResNode;
import com.phoenixcloud.common.Constants;
import com.phoenixcloud.dao.ctrl.PubServerAddrDao;
import com.phoenixcloud.dao.res.RBookDao;
import com.phoenixcloud.dao.res.RBookPageResDao;
import com.phoenixcloud.dao.res.RBookReDao;
import com.phoenixcloud.system.service.ISysService;
import com.phoenixcloud.util.MiscUtils;

@Scope("prototype")
@Component("bookResMgmtAction")
public class RBookResMgmtAction extends ActionSupport implements RequestAware,ServletResponseAware,SessionAware{
	private static final long serialVersionUID = 5600142681527501077L;
	
	private RequestMap request;
	private HttpServletResponse response;
	private SessionMap session;
	
	@Resource(name="bookMgmtServiceImpl")
	private IRBookMgmtService iBookService;
	
	@Resource(name="agencyMgmtServiceImpl")
	private IAgencyMgmtService agencyService;
	
	@Autowired
	private PubServerAddrDao serAddrDao;
	
	private byte flag;
	private String resId;
	
	private RBookRe bookRes;
	private RBook bookInfo;
	private String resIdArr;
	private String pages;
	private String start;
	private String end;
	
	private String errInfo = "";
	private String downloadUrl;
	
	@Autowired
	private RBookReDao resDao;
	
	@Autowired
	private RBookPageResDao pgRsDao;
	
	@Autowired
	private RBookDao bookDao;
	
	
	@Resource(name="sysServiceImpl")
	private ISysService iSysService;
	
	public void setiSysService(ISysService iSysService) {
		this.iSysService = iSysService;
	}

	public String getResIdArr() {
		return resIdArr;
	}

	public void setResIdArr(String resIdArr) {
		this.resIdArr = resIdArr;
	}

	private int num;
	
	public void setiBookService(IRBookMgmtService iBookService) {
		this.iBookService = iBookService;
	}

	public void setAgencyService(IAgencyMgmtService agencyService) {
		this.agencyService = agencyService;
	}
	
	@Override
	public void setRequest(Map<String, Object> request) {
		// TODO Auto-generated method stub
		this.request = (RequestMap) request;
	}

	@Override
	public void setServletResponse(HttpServletResponse response) {
		// TODO Auto-generated method stub
		this.response = response; 
	}
	
	public String getResId() {
		return resId;
	}

	public void setResId(String resId) {
		this.resId = resId;
	}

	public RBookRe getBookRes() {
		return bookRes;
	}

	public void setBookRes(RBookRe bookRes) {
		this.bookRes = bookRes;
	}

	private BookResNode getDepthAddParent(BigInteger orgId, Map<String,BookResNode> resNodeMap) {
		PubOrg org = agencyService.findOrgById(orgId.toString());
		if (org == null) {
			return null;
		}
		Stack<BookResNode> tmpStack = new Stack<BookResNode>();
		
		BookResNode resNode = new BookResNode();
		resNode.setChildren(null);
		resNode.setType("org");
		resNode.setParentNode("cata_" + org.getPubOrgCata().getId());
		resNode.setBookIds(new ArrayList<String>());
		resNode.setId(orgId.toString());
		tmpStack.push(resNode);
		
		int level = 2;
		String cataId = org.getPubOrgCata().getId();
		String child = "org_" + orgId;
		// 上级目录不是顶级目录，则继续查找
		while (true) {
			// 查找上级目录是否已经加入map中
			BookResNode cataNode = null;
			if ("0".equals(cataId)) {
				cataNode = resNodeMap.get("root");
			} else {
				cataNode = resNodeMap.get("cata_" + cataId);
			}
			
			// 未加入，则将上级目录加入到map中
			if (cataNode == null) {
				cataNode = new BookResNode();
				cataNode.setChildren(new ArrayList<String>());
				cataNode.getChildren().add(child);
				cataNode.setType("cata");
				cataNode.setBookIds(null);
				cataNode.setParentNode("cata_" + cataId);
				cataNode.setId(cataId);
				tmpStack.push(cataNode);
			} else {
				// 上级目录已经在map中，检查之前的子节点是否已经
				// 最开始的时候，将上朔到跟节点
				if (!cataNode.getChildren().contains(child)) { // 这个
					cataNode.getChildren().add(child);
				}
				int tmpLevel = cataNode.getLevel();
				try {
					BookResNode tmpNode = null;
					tmpLevel++;
					while ((tmpNode = tmpStack.pop())!=null) {
						tmpNode.setLevel(tmpLevel);
						if ("cata".equals(tmpNode.getType())) {
							resNodeMap.put("cata_" + tmpNode.getId(), tmpNode);
						} else if ("org".equals(tmpNode.getType())) {
							resNodeMap.put("org_" + tmpNode.getId(), tmpNode);
						}
						tmpLevel++;						
					}
				} catch (EmptyStackException e) {}
				break;
			}
			PubOrgCata cata = agencyService.findOrgCataById(cataId);
			// 上级目录不存在，停止上溯过程
			if (cata == null) {
				level = -1;
				MiscUtils.getLogger().error("无法找到上级机构目录: cataId = " + cataId);
				break;
			}
			child = "cata_" + cataId;
			cataId = cata.getParentCataId().toString();
			level++;
		}
		
		
		return resNode;
	}

	public String getStart() {
		return start;
	}

	public void setStart(String start) {
		this.start = start;
	}

	public String getEnd() {
		return end;
	}

	public void setEnd(String end) {
		this.end = end;
	}

	public String getAll() {
		BigInteger bookId = bookRes.getBookId();
		RBook book = iBookService.findBook(bookId.toString());
		if (book == null) {
			MiscUtils.getLogger().info("Can't find book by id: " + bookId);
			return null;
		}
		List<RBookRe> resList = iBookService.getResByBookId(bookId);
		request.put("book", book);
		request.put("resList", resList);
		
		return "success";
	}
	
	public RBook getBookInfo() {
		return bookInfo;
	}

	public void setBookInfo(RBook bookInfo) {
		this.bookInfo = bookInfo;
	}

	public byte getFlag() {
		return flag;
	}

	public void setFlag(byte flag) {
		this.flag = flag;
	}

	public String getErrInfo() {
		return errInfo;
	}

	public void setErrInfo(String errInfo) {
		this.errInfo = errInfo;
	}

	public String getDownloadUrl() {
		return downloadUrl;
	}

	public void setDownloadUrl(String downloadUrl) {
		this.downloadUrl = downloadUrl;
	}

	public String queryAll() {
		List<RBookRe> resList = iBookService.getAllRes();
		request.put("resList", resList);
		return "success";
	}
	
	public String removeRes() {
		if (resIdArr == null) {
			return null;
		}
		
		String resId[] = resIdArr.split(",");
		for (String id : resId) {
			iBookService.removeRes(id);
		}
		
		return null;
	}
	
	public String editRes() throws Exception{
		bookRes = iBookService.findBookRes(bookRes.getResId());
		if (bookRes == null) {
			throw new Exception("Not found the resource by id:" + bookRes.getResId());
		}
		
		return "success";
	}
	
	public String viewRes() throws Exception{
		bookRes = iBookService.findBookRes(bookRes.getResId());
		if (bookRes == null) {
			throw new Exception("Not found the resource by id:" + bookRes.getResId());
		}
		
		return "success";
	}
	
	public String saveRes() {
		RBookRe res = iBookService.findBookRes(bookRes.getResId());
		if (res == null) {
			return null;
		}
		Date date = new Date();
		res.setCataAddr(bookRes.getCataAddr());
		res.setFormat(bookRes.getFormat());
		res.setName(bookRes.getName());
		res.setNotes(bookRes.getNotes());
		res.setUpdateTime(date);
		
		iBookService.saveBookRes(res);
		
		SysStaff curStaff = (SysStaff)session.get("user");
		removeRelatedPages(new BigInteger(res.getResId()));
		String[] pageNumArr = pages.split(",");
		for (String pageNum : pageNumArr) {
			int num = 0;
			try {
				num = Integer.parseInt(pageNum);
			} catch (Exception e) {
				continue;
			}
			RBookPageRes pgRs = pgRsDao.findByResIdPageNum(new BigInteger(res.getId()), num);
			if (pgRs == null) {
				pgRs = new RBookPageRes();
				pgRs.setPageNum(num);
				pgRs.setBookId(res.getBookId());
				pgRs.setResId(new BigInteger(res.getResId()));
				pgRs.setStaffId(new BigInteger(curStaff.getId()));
				pgRs.setCreateTime(date);
				pgRs.setUpdateTime(date);
				pgRsDao.persist(pgRs);
			} else {
				pgRs.setDeleteState((byte)0);
				pgRs.setUpdateTime(date);
				pgRs.setStaffId(new BigInteger(curStaff.getId()));
				pgRsDao.merge(pgRs);
			}
		}
		
		return null;
	}
	
	private void removeRelatedPages(BigInteger resId) {
		pgRsDao.removeByResId(resId);
	}
	
	public String addRes() {
		Date date = new Date();
		if (num < 1) {
			num = 1;
		}
		
		SysStaff curStaff = (SysStaff)session.get("user");
		PubServerAddr addr = serAddrDao.findByOrgId(curStaff.getOrgId(), Constants.OUT_NET);
		String ipAddr = "";
		if (addr != null) {
			ipAddr = addr.getBookSerIp();
		}
		
		String[] pageNumArr = pages.split(",");
		
		for (int i = 0; i < num; i++) {
			RBookRe res = new RBookRe();
			res.setBookId(bookRes.getBookId());
			res.setCataAddr(bookRes.getCataAddr());
			res.setCreateTime(date);
			res.setUpdateTime(date);
			res.setFormat(bookRes.getFormat());
			res.setName(bookRes.getName());
			res.setParentResId(bookRes.getParentResId());
			res.setStaffId(new BigInteger(curStaff.getStaffId()));
			res.setIpAddr(ipAddr);
			//iBookService.saveBookRes(res);
			resDao.persist(res);
			
			// save related pages
			for (String pageNum : pageNumArr) {
				int num = 0;
				try {
					num = Integer.parseInt(pageNum);
				} catch (Exception e) {
					continue;
				}
				
				RBookPageRes pgRs = new RBookPageRes();
				pgRs.setPageNum(num);
				pgRs.setBookId(res.getBookId());
				pgRs.setResId(new BigInteger(res.getResId()));
				pgRs.setStaffId(new BigInteger(curStaff.getId()));
				pgRs.setCreateTime(date);
				pgRs.setUpdateTime(date);
				pgRsDao.persist(pgRs);
			}
		}
		
		return null;
	}
	
	private void outputToInput(OutputStream os, InputStream is) throws IOException {
        byte[] buf = new byte[1024];
        int len;
        while ((len = is.read(buf)) > 0) {
                os.write(buf, 0, len);
        }
    }

	private void zipDownload(RBookRe res) throws Exception {
		response.setContentType("application/zip");  //octet-stream
		response.setHeader("Content-Disposition", "attachment; filename=\"" + new String(res.getName().getBytes(), "ISO8859-1") + ".zip\"");
		try {
			ZipOutputStream zos = new ZipOutputStream(response.getOutputStream());
	        zos.setLevel(9);
	        zos.setEncoding("utf-8");
	        ZipEntry resEntry = new ZipEntry(res.getName());
	        zos.putNextEntry(resEntry);
	        FileInputStream fis = new FileInputStream(res.getLocalPath());
	        outputToInput(zos, fis);
	        zos.closeEntry();
	        zos.close();
	        fis.close();
		} catch (Exception e) {
			MiscUtils.getLogger().info(e.toString());
		}
	}
	
	private void streamDownload(RBookRe res) throws Exception {
		response.setContentType("application/octet-stream");
		response.setHeader("Content-Disposition", "attachment; filename=\"" + new String(res.getName().getBytes(), "ISO8859-1") + "\"");
		try {
			FileInputStream fis = new FileInputStream(res.getLocalPath());
			OutputStream out = response.getOutputStream();
			outputToInput(out, fis);
			out.close();
			fis.close();
		} catch (Exception e) {
			MiscUtils.getLogger().info(e.toString());
		}
	}
	
	public String download() throws Exception{
		RBookRe res = iBookService.findBookRes(bookRes.getResId());
		if (res == null) {
			throw new Exception("Not found the resource by id:" + bookRes.getResId());
		}
		//zipDownload(res);
		streamDownload(res);
		return null;
	}
	
	public int getNum() {
		return num;
	}

	public void setNum(int num) {
		this.num = num;
	}

	@Override
	public void setSession(Map<String, Object> session) {
		// TODO Auto-generated method stub
		this.session = (SessionMap) session;
	}
	public String getPages() {
		return pages;
	}

	public void setPages(String pages) {
		this.pages = pages;
	}

	public void addActionError(String anErrorMessage) {
        //validationAware.addActionError(anErrorMessage);
    }

    public void addActionMessage(String aMessage) {
       // validationAware.addActionMessage(aMessage);
    }

    public void addFieldError(String fieldName, String errorMessage) {
        //validationAware.addFieldError(fieldName, errorMessage);
    }
    
    public String changeAuditStatus() {
    	String[] resIds = resIdArr.split(",");
		for (String resId : resIds) {
			RBookRe res = resDao.find(resId);
			if (res == null) {
				continue;
			}
			
			if (flag == (byte)-1 && res.getIsAudit() != (byte)0) { // 打回重新制作
				continue;
			} else if (flag == (byte)0 && res.getIsAudit() != (byte)-1) { // 提交审核
				continue;
			} else if (flag == (byte)1 && res.getIsAudit() != (byte)0) { // 提交上架
				continue;
			} else if (flag == (byte)2 && res.getIsAudit() != (byte)1 && res.getIsAudit() != (byte)3) { // 上架
				continue;
			} else if (flag == (byte)3 && res.getIsAudit() != (byte)2) { // 已下架
				continue;
			}
			
			res.setIsAudit(flag);
			res.setUpdateTime(new Date());
			resDao.merge(res);
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
    
    public String searchRes() {
    	List<RBookRe> resList = iBookService.searchRes(bookInfo, bookRes);    	
		this.request.put("resList", resList);
		if (bookInfo.getIsAudit() == (byte)-2 && bookRes.getIsAudit() == (byte)-2) {
			return "querySearch";
		}
		return "editSearch";
    }
    
    public String searchResNew() {
    	List<RBookRe> resList = iBookService.searchRes(bookInfo, bookRes);    	
		this.request.put("resList", resList);
		byte isAudit = bookRes.getIsAudit();
		if (isAudit == (byte)-2) {
			return "search";
		} else if (isAudit == (byte)0) {
			return "audit";
		} else if (isAudit == (byte)1) {
			return "release";
		}
		return "search";
    }
    
    public String searchResByPage() {
    	if (!StringUtils.isBlank(start) && !StringUtils.isBlank(end)) {
	    	int startPage = -1;
	    	int endPage = -1;
	    	if (StringUtils.isNumeric(start)) {
		    	try {
		    		startPage = Integer.parseInt(start);
		    	} catch (Exception e) {
		    		MiscUtils.getLogger().info(e.toString());
		    	}
	    	}
	    	if (StringUtils.isNumeric(end)) {
	    		try {
	        		endPage = Integer.parseInt(end);
	        	} catch (Exception e) {
	        		MiscUtils.getLogger().info(e.toString());
	        	}
	    	}
	    	
	    	List<BigInteger> resIds = pgRsDao.getResIdsByBookIdPageRange(bookRes.getBookId(), startPage, endPage);
	    	List<RBookRe> resList = new ArrayList<RBookRe>();
	    	for (BigInteger resId: resIds) {
	    		RBookRe tmp = iBookService.findBookRes(resId.toString());
	    		if (tmp == null || tmp.getDeleteState() == (byte)1){
	    			continue;
	    		}
	    		resList.add(tmp);
	    	}
			this.request.put("resList", resList);
			RBook book = iBookService.findBook(bookRes.getBookId().toString());
			this.request.put("book", book);
    	} else {
    		getAll();
    	}
		
		if (bookInfo.getIsAudit() == (byte)-1) {
			return "book_zhizuo";
		} else if (bookInfo.getIsAudit() == (byte)0) {
			return "book_audit";
		} else if (bookInfo.getIsAudit() == (byte)1) {
			return "book_release";
		}
		
		return "success";
    }
    
    public String downloadRes() {
		RBookRe res = resDao.find(bookRes.getResId());
		if (res == null) {
			errInfo = "数据库中无法找到目标资源！";
			return "error";
		}
		RBook book = bookDao.find(res.getBookId().toString());
		if (book == null) {
			errInfo = "数据库中无法找到目标书籍！";
			return "error";
		}
		
		PubServerAddr inAddr = serAddrDao.findByOrgId(book.getOrgId(), Constants.IN_NET);
		PubServerAddr outAddr = serAddrDao.findByOrgId(book.getOrgId(), Constants.OUT_NET);
		PubServerAddr addr = iSysService.getProperAddr(null, outAddr);
		if (addr != null) {
			downloadUrl = res.getAllAddrOutNet();
		} else {
			addr = iSysService.getProperAddr(inAddr, null);
			if (addr != null) {
				downloadUrl = res.getAllAddrInNet();
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
