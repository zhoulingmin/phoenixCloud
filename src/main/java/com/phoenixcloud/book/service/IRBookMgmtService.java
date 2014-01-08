package com.phoenixcloud.book.service;

import java.math.BigInteger;
import java.util.List;

import com.phoenixcloud.bean.RBook;
import com.phoenixcloud.bean.RBookDire;

public interface IRBookMgmtService {
	List<RBook> getAllBooks();
	void saveBook(RBook book);
	RBook findBook(String bookId);
	void removeBook(String bookId);
	
	List<RBookDire> getBookDires(BigInteger bookId, BigInteger parentId);
	void saveBookDire(RBookDire bookDire);
	RBookDire findBookDire(String direId);
	void removeDire(String bookId, BigInteger direId);
	
	List<BigInteger> getBookIdsHaveRes();
}
