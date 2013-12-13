package com.phoenixcloud.bean;

import java.io.Serializable;
import java.math.BigDecimal;
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
 * The persistent class for the pub_org database table.
 * 
 */
@Entity
@Table(name="pub_org")
public class PubOrg extends AbstractModel<Long> implements Serializable {
	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy=GenerationType.AUTO)
	@Column(name="ORG_ID", unique=true, nullable=false, precision=10)
	private long orgId;

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name="CREATE_TIME", nullable=false)
	private Date createTime;

	@Column(name="DELETE_STATE", nullable=false)
	private int deleteState;

	@Column(length=255)
	private String notes;

	@Column(name="ORG_CATA_ID", precision=10)
	private BigDecimal orgCataId;

	@Column(name="ORG_NAME", length=60)
	private String orgName;

	@Column(name="ORG_TYPE_ID", precision=10)
	private BigDecimal orgTypeId;

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name="UPDATE_TIME", nullable=false)
	private Date updateTime;

	public PubOrg() {
	}

	public long getOrgId() {
		return this.orgId;
	}

	public void setOrgId(long orgId) {
		this.orgId = orgId;
	}

	public Date getCreateTime() {
		return this.createTime;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}

	public int getDeleteState() {
		return this.deleteState;
	}

	public void setDeleteState(int deleteState) {
		this.deleteState = deleteState;
	}

	public String getNotes() {
		return this.notes;
	}

	public void setNotes(String notes) {
		this.notes = notes;
	}

	public BigDecimal getOrgCataId() {
		return this.orgCataId;
	}

	public void setOrgCataId(BigDecimal orgCataId) {
		this.orgCataId = orgCataId;
	}

	public String getOrgName() {
		return this.orgName;
	}

	public void setOrgName(String orgName) {
		this.orgName = orgName;
	}

	public BigDecimal getOrgTypeId() {
		return this.orgTypeId;
	}

	public void setOrgTypeId(BigDecimal orgTypeId) {
		this.orgTypeId = orgTypeId;
	}

	public Date getUpdateTime() {
		return this.updateTime;
	}

	public void setUpdateTime(Date updateTime) {
		this.updateTime = updateTime;
	}

	@Override
	public Long getId() {
		// TODO Auto-generated method stub
		return orgId;
	}

}