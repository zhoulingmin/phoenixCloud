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
 * The persistent class for the pub_org_cata database table.
 * 
 */
@Entity
@Table(name="pub_org_cata")
public class PubOrgCata extends AbstractModel<Long> implements Serializable {
	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy=GenerationType.AUTO)
	@Column(name="ORG_CATA_ID", unique=true, nullable=false, precision=10)
	private long orgCataId;

	@Column(name="CATA_NAME", nullable=false, length=60)
	private String cataName;

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name="CREATE_TIME", nullable=false)
	private Date createTime;

	@Column(name="DELETE_STATE", nullable=false)
	private int deleteState;

	@Column(length=255)
	private String notes;

	@Column(name="PARENT_CATA_ID", precision=10)
	private BigDecimal parentCataId;

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name="UPDATE_TIME", nullable=false)
	private Date updateTime;

	public PubOrgCata() {
	}

	public long getOrgCataId() {
		return this.orgCataId;
	}

	public void setOrgCataId(long orgCataId) {
		this.orgCataId = orgCataId;
	}

	public String getCataName() {
		return this.cataName;
	}

	public void setCataName(String cataName) {
		this.cataName = cataName;
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

	public BigDecimal getParentCataId() {
		return this.parentCataId;
	}

	public void setParentCataId(BigDecimal parentCataId) {
		this.parentCataId = parentCataId;
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
		return orgCataId;
	}
}