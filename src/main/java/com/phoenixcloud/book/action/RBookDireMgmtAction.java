package com.phoenixcloud.book.action;

import java.io.PrintWriter;
import java.math.BigInteger;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.struts2.dispatcher.RequestMap;
import org.apache.struts2.interceptor.RequestAware;
import org.apache.struts2.interceptor.ServletResponseAware;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import com.opensymphony.xwork2.ActionSupport;
import com.phoenixcloud.bean.RBook;
import com.phoenixcloud.bean.RBookDire;
import com.phoenixcloud.book.service.IRBookMgmtService;
import com.phoenixcloud.util.MiscUtils;

@Scope("prototype")
@Component("bookDireMgmtAction")
public class RBookDireMgmtAction extends ActionSupport implements RequestAware, ServletResponseAware{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private RequestMap request;
	private HttpServletResponse response;
	private String bookId;
	@Resource(name="bookMgmtServiceImpl")
	private IRBookMgmtService iBookService;
	
	private BigInteger direId;
	private RBookDire bookDire;
	private boolean isView;
	
	private int num;
	
	
	public IRBookMgmtService getiBookService() {
		return iBookService;
	}

	public void setiBookService(IRBookMgmtService iBookService) {
		this.iBookService = iBookService;
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

	public String getBookId() {
		return bookId;
	}

	public void setBookId(String bookId) {
		this.bookId = bookId;
	}

	public BigInteger getDireId() {
		return direId;
	}

	public void setDireId(BigInteger direId) {
		this.direId = direId;
	}

	public RBookDire getBookDire() {
		return bookDire;
	}

	public void setBookDire(RBookDire bookDire) {
		this.bookDire = bookDire;
	}

	public boolean getIsView() {
		return isView;
	}

	public void setIsView(boolean isView) {
		this.isView = isView;
	}

	public String getAll() {
		if (bookId == null) {
			return null;
		}
		RBook book = iBookService.findBook(bookId);
		if (book == null) {
			MiscUtils.getLogger().info("没有找到合适的书籍！bookId = " + bookId);
			bookId = null;
			return null;
		}
		request.put("book", book);
		
		List<RBookDire> bookDireList = iBookService.getBookDires(BigInteger.valueOf(Long.parseLong(bookId)), BigInteger.ZERO);
		if (bookDireList.size() == 0) {
			Date curDate = new Date();
			
			// 创建默认封面
			RBookDire bookDire = new RBookDire();
			bookDire.setBPageNum(BigInteger.ZERO);
			bookDire.setEPageNum(BigInteger.ZERO);
			try {
				bookDire.setBookId(BigInteger.valueOf(Long.parseLong(book.getBookId())));
			} catch (Exception e) {
				MiscUtils.getLogger().info(e.toString());
				bookDire.setBookId(BigInteger.ZERO);
				bookDire.setDeleteState((byte)1);
			}
			bookDire.setName("封面");
			bookDire.setStaffId(BigInteger.ONE);
			bookDire.setCreateTime(curDate);
			bookDire.setUpdateTime(curDate);
			bookDire.setParentDireId(BigInteger.ZERO);
			iBookService.saveBookDire(bookDire);
			
			// 创建默认目录
			bookDire = new RBookDire();
			bookDire.setBPageNum(BigInteger.ONE);
			bookDire.setEPageNum(BigInteger.ONE);
			try {
				bookDire.setBookId(BigInteger.valueOf(Long.parseLong(book.getBookId())));
			} catch (Exception e) {
				MiscUtils.getLogger().info(e.toString());
				bookDire.setBookId(BigInteger.ZERO);
				bookDire.setDeleteState((byte)1);
			}
			bookDire.setName("目录");
			bookDire.setStaffId(BigInteger.ONE);
			bookDire.setCreateTime(curDate);
			bookDire.setUpdateTime(curDate);
			bookDire.setParentDireId(BigInteger.ZERO);
			iBookService.saveBookDire(bookDire);
		}
		
		int maxLevel = 0;
		JSONArray jsonArr = new JSONArray();
		List<RBookDire> direList = iBookService.getBookDires(new BigInteger(bookId), BigInteger.ZERO);
		for (RBookDire bookDire : direList) {
			JSONObject jsonObj = new JSONObject();
			jsonObj.put("level", 0);
			jsonObj.put("name", bookDire.getName());
			jsonObj.put("direId", bookDire.getDireId());
			jsonObj.put("bPageNum", bookDire.getBPageNum());
			jsonObj.put("ePageNum", bookDire.getEPageNum());
			jsonObj.put("notes", bookDire.getNotes());
			
			JSONObject tmpJosn = getSubDire(bookDire.getBookId(), new BigInteger(bookDire.getDireId()), 0);
			if (tmpJosn != null) {
				jsonObj.put("children", tmpJosn.get("children"));
				if (tmpJosn.get("maxLevel") != null) {
					int maxLevTmp = (Integer)tmpJosn.get("maxLevel");
					if (maxLevTmp > maxLevel) {
						maxLevel = maxLevTmp;
					}
				}
			}
			jsonArr.add(jsonObj);
		}
		request.put("direArr", jsonArr);
		request.put("maxLevel", maxLevel);
		
		return "success";
	}
	
	public String getSubDire() {
		if (direId == null) {
			direId = BigInteger.ZERO;
		}
		if (bookId == null) {
			return null;
		}
		
		JSONArray jsonArr = new JSONArray();
		List<RBookDire> bookDireList = iBookService.getBookDires(BigInteger.valueOf(Long.parseLong(bookId)), direId);
		for (RBookDire bookDire : bookDireList) {
			JSONObject dirObj = new JSONObject();
			dirObj.put("direId", bookDire.getId());
			dirObj.put("isParent", true);
			dirObj.put("name", bookDire.getName());
			dirObj.put("level", bookDire.getLevel());
			dirObj.put("bookId", bookDire.getBookId());
			dirObj.put("bPageNum", bookDire.getBPageNum());
			dirObj.put("ePageNum", bookDire.getEPageNum());
			dirObj.put("notes", bookDire.getNotes());
			dirObj.put("staffId", bookDire.getStaffId());
			jsonArr.add(dirObj);
		}
		
		response.setCharacterEncoding("utf-8"); 
        response.setContentType("html/text");
        
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
	
	public String addDire() {
		if (bookDire == null) {
			return null;
		}
		Date date = new Date();
		for (int i = 0; i < num; i++) {
			RBookDire dire = new RBookDire();
			dire.setCreateTime(date);
			dire.setUpdateTime(date);
			dire.setName(bookDire.getName());
			dire.setNotes(bookDire.getNotes());
			dire.setBPageNum(bookDire.getBPageNum());
			dire.setBookId(bookDire.getBookId());
			dire.setParentDireId(bookDire.getParentDireId());
			dire.setStaffId(new BigInteger("1"));
			dire.setLevel((byte)((int)bookDire.getLevel() + 1));
			iBookService.saveBookDire(dire);
		}
		
		return null;
	}
	
	public String saveDire() {
		if (bookDire == null) {
			MiscUtils.getLogger().info("无法更新书籍目录信息！");
			return null;
		}
		RBookDire dire = iBookService.findBookDire(bookDire.getDireId());
		if (dire == null) {
			return null;
		}
		dire.setBPageNum(bookDire.getBPageNum());
		dire.setEPageNum(bookDire.getEPageNum());
		dire.setName(bookDire.getName());
		dire.setNotes(bookDire.getNotes());
		dire.setUpdateTime(new Date());
		iBookService.saveBookDire(dire);
		
		return null;
	}
	
	public String editDire() {
		bookDire = iBookService.findBookDire(direId.toString());
		if (bookDire == null) {
			MiscUtils.getLogger().info("数据库中没有找到要编辑的书籍目录！");
			return null;
		}
		request.put("isView", isView);
		return "success";
	}
	
	public void removeDire() {
		// bookId direId
		if (bookId == null || direId == null) {
			MiscUtils.getLogger().info("删除书籍目录出现错误！");
			return;
		}
		iBookService.removeDire(bookId, direId);
	}
	
	private JSONObject getSubDire(BigInteger bookID, BigInteger parentDireID, int level) {
		JSONObject subDireObj = null;
		JSONArray jsonArr = null;
		int maxLevel = 0;
		List<RBookDire> direList = iBookService.getBookDires(bookID, parentDireID);
		if (direList.size() > 0) {
			level++;
			maxLevel = level;
			jsonArr = new JSONArray();
			subDireObj = new JSONObject();
			subDireObj.put("maxLevel", level);
			subDireObj.put("children", jsonArr);
		}
		for (RBookDire dire : direList) {
			JSONObject jsonObj = new JSONObject();
			jsonObj.put("level", level);
			jsonObj.put("name", dire.getName());
			jsonObj.put("direId", dire.getDireId());
			jsonObj.put("bPageNum", dire.getBPageNum());
			jsonObj.put("ePageNum", dire.getEPageNum());
			jsonObj.put("notes", dire.getNotes());
			
			JSONObject tmpJosn = getSubDire(dire.getBookId(), new BigInteger(dire.getDireId()), level);
			if (tmpJosn != null) {
				jsonObj.put("children", tmpJosn.get("children"));
				int maxLevTmp = (Integer)tmpJosn.get("maxLevel");
				if (maxLevTmp > maxLevel) {
					maxLevel = maxLevTmp;
					subDireObj.put("maxLevel", maxLevTmp);
				}
			}
			jsonArr.add(jsonObj);
		}
		if (jsonArr != null) {
			subDireObj.put("children", jsonArr);
		}
		return subDireObj;
	}

	public int getNum() {
		return num;
	}

	public void setNum(int num) {
		this.num = num;
	}
	
	public void addActionError(String anErrorMessage) {
        MiscUtils.getLogger().info(anErrorMessage);
    }

    public void addActionMessage(String aMessage) {
    	MiscUtils.getLogger().info(aMessage);
    }

    public void addFieldError(String fieldName, String errorMessage) {
    	MiscUtils.getLogger().info(fieldName + " " + errorMessage);
    }
}
