package com.phoenixcloud.dao;

import org.springframework.stereotype.Repository;

import com.phoenixcloud.bean.RRegCode;

@Repository
public class RRegCodeDao extends AbstractDao<RRegCode>{
	public RRegCodeDao() {
		super(RRegCode.class);
	}
}
