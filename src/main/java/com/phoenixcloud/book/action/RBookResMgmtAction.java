package com.phoenixcloud.book.action;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
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
import com.phoenixcloud.bean.RBookRe;
import com.phoenixcloud.bean.SysStaff;
import com.phoenixcloud.book.service.IRBookMgmtService;
import com.phoenixcloud.book.vo.BookResNode;
import com.phoenixcloud.dao.PubServerAddrDao;
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
	
	private int start;
	private int end;
	
	private boolean flag;
	private String resId;
	
	private RBookRe bookRes;
	private String resIdArr;
	
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
	
	public int getStart() {
		return start;
	}

	public void setStart(int start) {
		this.start = start;
	}

	public int getEnd() {
		return end;
	}

	public void setEnd(int end) {
		this.end = end;
	}
	
	public boolean isFlag() {
		return flag;
	}

	public void setFlag(boolean flag) {
		this.flag = flag;
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
	
	public String queryAll() {
		List<RBookRe> resList = iBookService.getAllRes();
		request.put("resList", resList);
		return "success";
	}
	
	public String getAll_ext() {
		// key: type_id, type: cata,org  or key: root
		Map<String,BookResNode> resNodeMap = new HashMap<String, BookResNode>();
		BookResNode root = new BookResNode();
		root.setType("root");
		root.setLevel(0);
		root.setChildren(new ArrayList<String>());
		root.setParentNode(null);
		root.setBookIds(null);
		root.setId("0");
		resNodeMap.put("root", root);
		
		int maxLevel = 0;
		List<BigInteger> bookIds = iBookService.getBookIdsHaveRes();
		for (BigInteger bookId : bookIds) {
			RBook book = iBookService.findBook(bookId.toString());
			if (book == null) {
				continue;
			}
			BookResNode resNode = resNodeMap.get("org_" + book.getOrgId());
			if (resNode == null) {
				resNode = getDepthAddParent(book.getOrgId(), resNodeMap);
				if (resNode == null) {
					continue;
				}
			}
			resNode.getBookIds().add(bookId.toString());
			int curLv = resNode.getLevel();
			if (maxLevel < curLv) {
				maxLevel = curLv;
			}
		}

		request.put("maxLevel", maxLevel);
		request.put("resNodeMap", resNodeMap);
		//request.put("bookIds", bookIds);
		//request.put("agencyIds", agencyIds);
		start = 0;
		end = 0;
		return "success";
	}
	
	public String auditRes() {
		RBookRe res = iBookService.findBookRes(resId);
		if (flag) {
			res.setIsAudit((byte)1);
		} else {
			res.setIsAudit((byte)0);
		}
		iBookService.saveBookRes(res);
		return null;
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
		
		res.setCataAddr(bookRes.getCataAddr());
		res.setFormat(bookRes.getFormat());
		res.setName(bookRes.getName());
		res.setNotes(bookRes.getNotes());
		res.setUpdateTime(new Date());
		
		iBookService.saveBookRes(res);
	
		return null;
	}
	
	public String addRes() {
		Date date = new Date();
		if (num < 1) {
			num = 1;
		}
		
		SysStaff curStaff = (SysStaff)session.get("user");
		PubServerAddr addr = serAddrDao.findByOrgId(curStaff.getOrgId());
		String ipAddr = "";
		if (addr != null) {
			ipAddr = addr.getBookSerIp();
		}
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
			iBookService.saveBookRes(res);
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
	public void addActionError(String anErrorMessage) {
        //validationAware.addActionError(anErrorMessage);
    }

    public void addActionMessage(String aMessage) {
       // validationAware.addActionMessage(aMessage);
    }

    public void addFieldError(String fieldName, String errorMessage) {
        //validationAware.addFieldError(fieldName, errorMessage);
    }
}
