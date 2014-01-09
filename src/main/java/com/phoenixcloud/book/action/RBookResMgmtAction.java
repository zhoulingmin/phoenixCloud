package com.phoenixcloud.book.action;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.EmptyStackException;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.Stack;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts2.dispatcher.RequestMap;
import org.apache.struts2.interceptor.RequestAware;
import org.apache.struts2.interceptor.ServletResponseAware;
import org.springframework.stereotype.Component;

import com.opensymphony.xwork2.ActionSupport;
import com.phoenixcloud.agency.service.IAgencyMgmtService;
import com.phoenixcloud.bean.PubOrg;
import com.phoenixcloud.bean.PubOrgCata;
import com.phoenixcloud.bean.RBook;
import com.phoenixcloud.bean.RBookRe;
import com.phoenixcloud.book.service.IRBookMgmtService;
import com.phoenixcloud.book.vo.BookResNode;
import com.phoenixcloud.util.MiscUtils;

@Component("bookResMgmtAction")
public class RBookResMgmtAction extends ActionSupport implements RequestAware,ServletResponseAware{
	private static final long serialVersionUID = 5600142681527501077L;
	
	private RequestMap request;
	private HttpServletResponse response;
	
	@Resource(name="bookMgmtServiceImpl")
	private IRBookMgmtService iBookService;
	
	@Resource(name="agencyMgmtServiceImpl")
	private IAgencyMgmtService agencyService;
	
	private int start;
	private int end;
	
	private boolean flag;
	private String resId;
	
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
		iBookService.removeRes(resId);
		return null;
	}
}
