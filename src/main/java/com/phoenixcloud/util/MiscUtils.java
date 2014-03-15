package com.phoenixcloud.util;

import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Random;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;

public class MiscUtils {
	private static SimpleDateFormat formatter = new SimpleDateFormat(
			"yyyyMMddHHmmss");

	private static String baseChars = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ~!@#$%^&*();':\"[]{},./<>?|\\-=_+";
	
	public static Logger getLogger() {
		StackTraceElement[] ste = Thread.currentThread().getStackTrace();
		String caller = ste[2].getClassName();
		return (Logger.getLogger(caller));
	}

	public static String getCurrentTime(String formatter) {
		SimpleDateFormat dateFformatter = new SimpleDateFormat(formatter);
		return dateFformatter.format(new Date());
	}

	public static String getCurrentTime() {
		return formatter.format(new Date());
	}

	public static InputStream getResource(String res) {
		InputStream in = null;
		if (StringUtils.isNotEmpty(res)) {
			in = MiscUtils.class.getResourceAsStream(res);
			if (in == null) {
				in = Thread.currentThread().getContextClassLoader()
						.getResourceAsStream(res);
			}
		}
		return in;
	}
	
	public static String getRandomString(int num) {
		if (num < 1) {
			num = 1;
		}
		int len = baseChars.length();
		StringBuffer randomStr = new StringBuffer();
		Random random = new Random();
		for(int i=0; i<num; i++){
			randomStr.append(baseChars.charAt(random.nextInt(len)));
		}
		return randomStr.toString();
	}
}
