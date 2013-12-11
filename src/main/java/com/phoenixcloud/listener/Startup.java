package com.phoenixcloud.listener;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import org.apache.log4j.Logger;

import com.phoenixcloud.common.Constants;
import com.phoenixcloud.common.PhoenixProperties;
import com.phoenixcloud.util.MiscUtils;

public class Startup implements ServletContextListener {
	private static Logger logger = MiscUtils.getLogger();
	private PhoenixProperties p = PhoenixProperties.getInstance();

	public void contextInitialized(ServletContextEvent sc) {
		try {
			logger.debug("contextInit");

			String contextPath = "";
			String propFileName = "";

			try {
				// Anyone know a better way to do this?
				String url = sc.getServletContext().getResource("/").getPath();
				logger.info(url);
				int idx = url.lastIndexOf('/');
				url = url.substring(0, idx);

				idx = url.lastIndexOf('/');
				url = url.substring(idx + 1);

				idx = url.lastIndexOf('.');
				if (idx > 0)
					url = url.substring(0, idx);

				contextPath = url;
			} catch (Exception e) {
				logger.error("Error", e);
			}

			String propName = contextPath + ".properties";

			char sep = System.getProperty("file.separator").toCharArray()[0];
			propFileName = System.getProperty("user.home") + sep + propName;
			logger.info("looking up " + propFileName);
			// oscar.OscarProperties p = oscar.OscarProperties.getInstance();
			try {
				// This has been used to look in the users home directory that
				// started tomcat
				p.readFromFile(propFileName);
				logger.info("loading properties from " + propFileName);
			} catch (java.io.FileNotFoundException ex) {
				logger.info(propFileName + " not found");
			}
			if (p.isEmpty()) {
				/*
				 * if the file not found in the user root, look in the WEB-INF
				 * directory
				 */
				try {
					logger.info("looking up  /WEB-INF/" + propName);
					p.readFromFile("/WEB-INF/" + propName);
					logger.info("loading properties from /WEB-INF/" + propName);
				} catch (java.io.FileNotFoundException e) {
					logger.error("Configuration file: "
							+ propName
							+ " cannot be found, it should be put either in the User's home or in WEB-INF ");
					return;
				} catch (Exception e) {
					logger.error("Error", e);
					return;
				}
			}

			String classPath = getClass().getClassLoader().getResource("/")
					.getPath();
			String osName = System.getProperty("os.name");
			MiscUtils.getLogger().info("os.name=" + osName);
			if (osName != null
					&& (-1 != osName.indexOf("windows") || -1 != osName
							.indexOf("Windows"))) {
				classPath = classPath.substring(1);
			}
			MiscUtils.getLogger().debug("classPath: " + classPath);
			p.setProperty(Constants.CLASS_PATH_KEY, classPath);

		} catch (Exception e) {
			logger.error("Unexpected error.", e);
			throw (new RuntimeException(e));
		}
	}

	public void contextDestroyed(ServletContextEvent arg0) {
	}
}
