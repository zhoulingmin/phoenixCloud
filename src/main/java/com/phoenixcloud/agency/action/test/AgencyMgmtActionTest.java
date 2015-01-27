package com.phoenixcloud.agency.action.test;

import static org.junit.Assert.*;

import org.junit.Test;

import com.phoenixcloud.agency.action.AgencyMgmtAction;

public class AgencyMgmtActionTest {

	@Test
	public void testIsNoCheckbox() {
		Boolean flag = new AgencyMgmtAction().isNoCheckbox();
		assertEquals(false, flag);
	}

}
