package com.phoenixcloud.dao;

import org.springframework.stereotype.Repository;

import com.phoenixcloud.bean.RBookRe;

@Repository
public class RBookReDao extends AbstractDao<RBookRe>{
	public RBookReDao() {
		super(RBookRe.class);
	}
}
