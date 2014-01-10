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


/**
 * The persistent class for the sys_staff_purview database table.
 * 
 */
@Entity
@Table(name="sys_staff_purview")
public class SysStaffPurview extends AbstractModel<String> implements Serializable {
	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy=GenerationType.AUTO)
	@Column(name="STA_PUR_ID", unique=true, nullable=false)
	private String staPurId;

	@Column(name="CFG_STAFF_ID")
	private BigInteger cfgStaffId;

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name="CREATE_TIME", nullable=false)
	private Date createTime;

	@Column(name="DELETE_STATE", nullable=false)
	private byte deleteState;

	@Column(length=255)
	private String notes;

	@Column(name="PURVIEW_ID")
	private BigInteger purviewId;

	@Column(name="STAFF_ID")
	private BigInteger staffId;

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name="UPDATE_TIME", nullable=false)
	private Date updateTime;

	public SysStaffPurview() {
	}

	public String getStaPurId() {
		return this.staPurId;
	}

	public void setStaPurId(String staPurId) {
		this.staPurId = staPurId;
	}

	public BigInteger getCfgStaffId() {
		return this.cfgStaffId;
	}

	public void setCfgStaffId(BigInteger cfgStaffId) {
		this.cfgStaffId = cfgStaffId;
	}

	public Date getCreateTime() {
		return this.createTime;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}

	public byte getDeleteState() {
		return this.deleteState;
	}

	public void setDeleteState(byte deleteState) {
		this.deleteState = deleteState;
	}

	public String getNotes() {
		return this.notes;
	}

	public void setNotes(String notes) {
		this.notes = notes;
	}

	public BigInteger getPurviewId() {
		return this.purviewId;
	}

	public void setPurviewId(BigInteger purviewId) {
		this.purviewId = purviewId;
	}

	public BigInteger getStaffId() {
		return this.staffId;
	}

	public void setStaffId(BigInteger staffId) {
		this.staffId = staffId;
	}

	public Date getUpdateTime() {
		return this.updateTime;
	}

	public void setUpdateTime(Date updateTime) {
		this.updateTime = updateTime;
	}

	@Override
	public String getId() {
		// TODO Auto-generated method stub
		return staPurId;
	}

}