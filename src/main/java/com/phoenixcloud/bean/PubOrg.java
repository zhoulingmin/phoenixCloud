package com.phoenixcloud.bean;

import java.io.Serializable;
import java.math.BigDecimal;
import java.math.BigInteger;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;


/**
 * The persistent class for the pub_org database table.
 * 
 */
@Entity
@Table(name="pub_org")
public class PubOrg extends AbstractModel<String> implements Serializable {
	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy=GenerationType.AUTO)
	@Column(name="ORG_ID", unique=true, nullable=false, length=12)
	private String orgId;

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name="CREATE_TIME", nullable=false)
	private Date createTime;

	@Column(name="DELETE_STATE", nullable=false)
	private byte deleteState;

	@Column(length=255)
	private String notes;

	@Column(name="ORG_NAME", length=60)
	private String orgName;

	@Column(name="ORG_TYPE_ID", precision=10)
	private BigInteger orgTypeId;

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name="UPDATE_TIME", nullable=false)
	private Date updateTime;
	
	@ManyToOne
	@JoinColumn(name="ORG_CATA_ID", nullable=false)
	private PubOrgCata pubOrgCata;

	public PubOrg() {
	}

	public String getOrgId() {
		return this.orgId;
	}

	public void setOrgId(String orgId) {
		this.orgId = orgId;
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

	public String getOrgName() {
		return this.orgName;
	}

	public void setOrgName(String orgName) {
		this.orgName = orgName;
	}

	public BigInteger getOrgTypeId() {
		return this.orgTypeId;
	}

	public void setOrgTypeId(BigInteger orgTypeId) {
		this.orgTypeId = orgTypeId;
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
		return orgId;
	}

	public PubOrgCata getPubOrgCata() {
		return pubOrgCata;
	}

	public void setPubOrgCata(PubOrgCata pubOrgCata) {
		this.pubOrgCata = pubOrgCata;
	}

}