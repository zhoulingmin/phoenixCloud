package com.phoenixcloud.bean;

import java.io.Serializable;
import java.math.BigInteger;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

@Entity
@Table(name="pub_hardware_num")
public class PubHwNum extends AbstractModel<String> implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 6319193559802833524L;

	@Id
	@GeneratedValue(strategy=GenerationType.AUTO)
	@Column(name="HW_ID", unique=true, nullable=false)
	private String hwId;
	
	private int num;
	
	@Column(length=255)
	private String notes;

	@Column(name="STAFF_ID")
	private BigInteger staffId;

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name="UPDATE_TIME", nullable=false)
	private Date updateTime;
	
	@Temporal(TemporalType.TIMESTAMP)
	@Column(name="CREATE_TIME", nullable=false)
	private Date createTime;

	@Column(name="DELETE_STATE", nullable=false)
	private byte deleteState;
	
	
	@Column(name="HW_TYPE", nullable=false)
	private BigInteger hwType;
	
	public String getHwId() {
		return hwId;
	}

	public void setHwId(String hwId) {
		this.hwId = hwId;
	}

	public BigInteger getHwType() {
		return hwType;
	}

	public void setHwType(BigInteger hwType) {
		this.hwType = hwType;
	}

	public int getNum() {
		return num;
	}

	public void setNum(int num) {
		this.num = num;
	}

	public String getNotes() {
		return notes;
	}

	public void setNotes(String notes) {
		this.notes = notes;
	}

	public BigInteger getStaffId() {
		return staffId;
	}

	public void setStaffId(BigInteger staffId) {
		this.staffId = staffId;
	}

	public Date getUpdateTime() {
		return updateTime;
	}

	public void setUpdateTime(Date updateTime) {
		this.updateTime = updateTime;
	}

	public Date getCreateTime() {
		return createTime;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}

	public byte getDeleteState() {
		return deleteState;
	}

	public void setDeleteState(byte deleteState) {
		this.deleteState = deleteState;
	}
	
	@Override
	public String getId() {
		// TODO Auto-generated method stub
		return hwId;
	}

}
