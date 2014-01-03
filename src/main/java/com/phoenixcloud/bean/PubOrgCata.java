package com.phoenixcloud.bean;

import static javax.persistence.CascadeType.ALL;

import java.io.Serializable;
import java.math.BigInteger;
import java.util.Date;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;


/**
 * The persistent class for the pub_org_cata database table.
 * 
 */
@Entity
@Table(name="pub_org_cata")
public class PubOrgCata extends AbstractModel<String> implements Serializable {
	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy=GenerationType.AUTO)
	@Column(name="ORG_CATA_ID", unique=true, nullable=false, length=12)
	private String orgCataId;

	@Column(name="CATA_NAME", nullable=false, length=60)
	private String cataName;

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name="CREATE_TIME", nullable=false)
	private Date createTime;

	@Column(name="DELETE_STATE", nullable=false)
	private byte deleteState;

	@Column(length=255)
	private String notes;

	@Column(name="PARENT_CATA_ID", length=12)
	private BigInteger parentCataId;

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name="UPDATE_TIME", nullable=false)
	private Date updateTime;
	
	@OneToMany(mappedBy="pubOrgCata", cascade = ALL)
	private List<PubOrg> pubOrgs;

	public PubOrgCata() {
	}

	public String getOrgCataId() {
		return this.orgCataId;
	}

	public void setOrgCataId(String orgCataId) {
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

	public BigInteger getParentCataId() {
		return this.parentCataId;
	}

	public void setParentCataId(BigInteger parentCataId) {
		this.parentCataId = parentCataId;
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
		return orgCataId;
	}

	public List<PubOrg> getPubOrgs() {
		return pubOrgs;
	}

	public void setPubOrgs(List<PubOrg> pubOrgs) {
		this.pubOrgs = pubOrgs;
	}
}