package com.phoenixcloud.book.service.impl;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Vector;

import javax.annotation.Resource;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.phoenixcloud.bean.RBook;
import com.phoenixcloud.bean.RBookDire;
import com.phoenixcloud.bean.RBookPageRes;
import com.phoenixcloud.bean.RBookRe;
import com.phoenixcloud.bean.RRegCode;
import com.phoenixcloud.book.service.IRBookMgmtService;
import com.phoenixcloud.dao.res.RBookDao;
import com.phoenixcloud.dao.res.RBookDireDao;
import com.phoenixcloud.dao.res.RBookLogDao;
import com.phoenixcloud.dao.res.RBookPageResDao;
import com.phoenixcloud.dao.res.RBookReDao;
import com.phoenixcloud.dao.res.RRegCodeDao;

@Service("bookMgmtServiceImpl")
public class RBookMgmtServiceImpl implements IRBookMgmtService {
	
	@Autowired
	private RBookDao bookDao;
	
	@Autowired
	private RBookDireDao bookDireDao;
	
	@Autowired
	private RBookLogDao bookLogDao;
	
	@Autowired
	private RBookReDao bookReDao;
	
	@Autowired
	private RRegCodeDao regCodeDao;
	
	@PersistenceContext(unitName="resDbUnit")
	protected EntityManager resEm = null;
	
	public void setBookDao(RBookDao bookDao) {
		this.bookDao = bookDao;
	}

	public void setBookDireDao(RBookDireDao bookDireDao) {
		this.bookDireDao = bookDireDao;
	}

	public void setBookLogDao(RBookLogDao bookLogDao) {
		this.bookLogDao = bookLogDao;
	}

	public void setBookReDao(RBookReDao bookReDao) {
		this.bookReDao = bookReDao;
	}

	public void setRegCodeDao(RRegCodeDao regCodeDao) {
		this.regCodeDao = regCodeDao;
	}
	
	public List<RBook> getAllBooks() {
		List<RBook> bookList = bookDao.getAll();
		if (bookList == null) {
			bookList = new ArrayList<RBook>();
		}
		return bookList;
	}

	public void saveBook(RBook book) {
		if (book.getId() == null || book.getId().isEmpty() || book.getId() == "0") {
			bookDao.persist(book);
		} else {
			bookDao.merge(book);
		}
	}
	
	public RBook findBook(String bookId) {
		return bookDao.find(bookId);
	}
	
	public void removeBook(String bookId) {
		bookDao.remove(bookId);
	}
	
	public List<RBook> searchBook(RBook book) {
		List<RBook> bookList = bookDao.findByCriteria(book);
		if (bookList == null) {
			bookList = new ArrayList();
		}
		return bookList;
	}
	
	public boolean checkBookNoExist(String bookNo) {
		List<RBook> bookList = bookDao.findByBookNo(bookNo);
		return (bookList != null && bookList.size() > 0);
	}
		
	public List<RBookDire> getBookDires(BigInteger bookId, BigInteger parentId) {
		List<RBookDire> bdList = bookDireDao.findSubDires(bookId, parentId);
		if (bdList == null) {
			bdList = new ArrayList<RBookDire>();
		}
		return bdList;
	}
	
	public void saveBookDire(RBookDire bookDire) {
		if (bookDire.getId() == null || bookDire.getId().isEmpty() || bookDire.getId() == "0") {
			bookDireDao.persist(bookDire);
		} else {
			bookDireDao.merge(bookDire);
		}
	}
	
	public RBookDire findBookDire(String direId) {
		return bookDireDao.find(direId);
	}
	
	private void removeSubDire(BigInteger bookId, BigInteger direId, Date curDate){
		List<RBookDire> direList = bookDireDao.findSubDires(bookId, direId);
		for (RBookDire dire : direList) {
			removeSubDire(bookId, BigInteger.valueOf(Long.parseLong(dire.getId())), curDate);
			dire.setDeleteState((byte)1);
			dire.setUpdateTime(curDate);
			bookDireDao.merge(dire);
		}
	}
	
	public void removeDire(BigInteger bookId, BigInteger direId) {
		// 递归删除子节点
		RBookDire dire = bookDireDao.find(direId.toString());
		if (dire == null) {
			return;
		}
		Date curDate = new Date();
		removeSubDire(bookId, direId, curDate);
		
		dire.setDeleteState((byte)1);
		dire.setUpdateTime(curDate);
		
		bookDireDao.merge(dire);
	}
	
	public List<BigInteger> getBookIdsHaveRes() {
		return bookReDao.getAllBookIds();
	}
	
	public List<RBookRe> getResByBookId(BigInteger bookId) {
		List<RBookRe> resList = bookReDao.getAllResByBookId(bookId);
		if (resList == null) {
			resList = new ArrayList<RBookRe>();
		}
		return resList;
	}
	
	public List<RBookRe> getAllRes() {
		List<RBookRe> resList = bookReDao.getAll();
		if (resList == null) {
			resList = new ArrayList<RBookRe>();
		}
		return resList;
	}
	
	public RBookRe findBookRes(String resId) {
		return bookReDao.find(resId);
	}
	
	private void removeSubRes(BigInteger bookId, String parentResId, Date curDate) {
		List<RBookRe> resList = bookReDao.getSubRes(bookId, new BigInteger(parentResId));
		if (resList == null) {
			return;
		}
		for (RBookRe res : resList) {
			removeSubRes(res.getBookId(), res.getResId(), curDate);
			res.setDeleteState((byte)1);
			res.setUpdateTime(curDate);
			bookReDao.merge(res);
		}
	}
	
	public void removeRes(String resId) {
		RBookRe bookRes = bookReDao.find(resId);
		if (bookRes == null) {
			return;
		}
		
		Date date = new Date();
		removeSubRes(bookRes.getBookId(), resId, date);
		
		bookRes.setDeleteState((byte)1);
		bookRes.setUpdateTime(date);
		bookReDao.merge(bookRes);
	}
	
	public void saveBookRes(RBookRe bookRes) {
		bookRes.setUpdateTime(new Date());
		bookReDao.merge(bookRes);
	}
	
	public RRegCode findRegCode(String id) {
		return regCodeDao.find(id);
	}
	
	public List<RRegCode> getAllRegCodes() {
		List<RRegCode> codeList = regCodeDao.getAll();
		if (codeList == null) {
			codeList = new ArrayList<RRegCode>();
		}
		return codeList;
	}
	
	public void saveRegCode(RRegCode code) {
		if (code.getId() == null || "0".equals(code.getId())) {
			regCodeDao.persist(code);
		} else {
			regCodeDao.merge(code);
		}
	}
	
	public void removeRegCode(String id) {
		RRegCode code = regCodeDao.find(id);
		if (code != null) {
			code.setUpdateTime(new Date());
			code.setDeleteState((byte)1);
			regCodeDao.merge(code);
		}
	}
	
	@SuppressWarnings("unchecked")
	@Transactional
	public List<RBookRe> searchRes(RBook book, RBookRe res) {
		String sql = "";
		int index = 1;
		Vector params = new Vector();
		String bookId = book.getId();
		if (bookId == null || "0".equals(bookId)) {
			if (res.getBookId() != null) {
				bookId = res.getBookId().toString();
			}
		}
		if (bookId != null && !"0".equals(bookId)) {
			sql = "select rr from RBookRe rr where rr.deleteState = 0 and rr.bookId = " + bookId;
		} else {
			sql = "select rr from RBookRe rr, RBook rb where rr.bookId = rb.bookId " +
					"and rr.deleteState = 0 and rb.deleteState = 0";
			if (book.getName() != null && book.getName().trim().length() > 0) {
				sql += " and rb.name like ?" + index;
				params.add("%" + book.getName().trim() + "%");
				index++;
			}
			if (book.getStuSegId() != null && book.getStuSegId().compareTo(BigInteger.ZERO) != 0) {
				sql += " and rb.stuSegId = ?" + index;
				params.add(book.getStuSegId());
				index++;
			}
			if (book.getSubjectId() != null && book.getSubjectId().compareTo(BigInteger.ZERO) != 0) {
				sql += " and rb.subjectId = ?" + index;
				params.add(book.getSubjectId());
				index++;
			}
			if (book.getClassId() != null && book.getClassId().compareTo(BigInteger.ZERO) != 0) {
				sql += " and rb.classId = ?" + index;
				params.add(book.getClassId());
				index++;
			}
			if (book.getPressId() != null && book.getPressId().compareTo(BigInteger.ZERO) != 0) {
				sql += " and rb.pressId = ?" + index;
				params.add(book.getPressId());
				index++;
			}
			if (book.getIsAudit() != (byte) -2) {
				sql += " and rb.isAudit = " + book.getIsAudit();
			}
		}
		
		if (res.getName() != null && res.getName().trim().length() > 0) {
			sql += " and rr.name like ?" + index;
			params.add("%" + res.getName().trim() + "%");
			index++;
		}
		
		if (res.getIsAudit() != (byte)-2) { // -2: indicates all res
			if (res.getIsAudit() == (byte)1) {
				sql += " and rr.isAudit in (1,2,3)";
			} else {
				sql += " and rr.isAudit = " + res.getIsAudit();
			}
		}
				
		Query query = resEm.createQuery(sql);
		for (int i = 0; i < params.size(); i++) {
			query.setParameter((i + 1), params.get(i));
		}
		
		return query.getResultList();
	}

}
