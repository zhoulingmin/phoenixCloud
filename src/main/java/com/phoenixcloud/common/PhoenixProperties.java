package com.phoenixcloud.common;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

import com.phoenixcloud.util.MiscUtils;

public class PhoenixProperties extends Properties {
	private static final long serialVersionUID = 6826276411016192863L;
	private static PhoenixProperties phoenixProperties = new PhoenixProperties();

	public static PhoenixProperties getInstance() {
		return phoenixProperties;
	}

	private PhoenixProperties() {
		MiscUtils.getLogger().debug("PHOENIX PROPS CONSTRUCTOR");
		try {
			readFromFile("/phoenixCloud.properties");
		} catch (IOException e) {
			MiscUtils.getLogger().error("Error", e);
		}
	}

	public void readFromFile(String url) throws IOException {
		InputStream is = getClass().getResourceAsStream(url);
		if (is == null)
			is = new FileInputStream(url);

		try {
			load(is);
		} finally {
			is.close();
		}
	}

	@Override
	public String getProperty(String key) {
		String tmp = super.getProperty(key);
		if (null == tmp) {
			return "";
		}
		return tmp.trim();
	}

	public int getIntProperty(String key) {
		try {
			String value = phoenixProperties.getProperty(key);
			return Integer.parseInt(value);
		} catch (Exception e) {
			return 0;
		}
	}

	public boolean getBooleanProperty(String key) {
		try {
			String value = phoenixProperties.getProperty(key);
			return Boolean.parseBoolean(value);
		} catch (Exception e) {
			return false;
		}
	}
}
