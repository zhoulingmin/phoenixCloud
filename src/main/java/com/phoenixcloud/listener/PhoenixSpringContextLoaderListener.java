package com.phoenixcloud.listener;

import java.util.ArrayList;

import javax.servlet.ServletContext;

import org.apache.log4j.Logger;
import org.springframework.beans.BeanUtils;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextException;
import org.springframework.util.ObjectUtils;
import org.springframework.web.context.ConfigurableWebApplicationContext;
import org.springframework.web.context.ContextLoaderListener;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.XmlWebApplicationContext;

import com.phoenixcloud.common.PhoenixProperties;
import com.phoenixcloud.util.MiscUtils;
import com.phoenixcloud.util.SpringUtils;

public class PhoenixSpringContextLoaderListener extends ContextLoaderListener {
	
	private static final Logger logger = MiscUtils.getLogger();
	private static final String CONTEXTNAME = "classpath:applicationContext";
	private static final String PROPERTYNAME = "ModuleNames";
	
	@Override
	protected void configureAndRefreshWebApplicationContext(ConfigurableWebApplicationContext wac, ServletContext sc) {
		if (ObjectUtils.identityToString(wac).equals(wac.getId())) {
			// The application context id is still set to its original default value
			// -> assign a more useful id based on available information
			String idParam = sc.getInitParameter(CONTEXT_ID_PARAM);
			if (idParam != null) {
				wac.setId(idParam);
			}
			else {
				// Generate default id...
				if (sc.getMajorVersion() == 2 && sc.getMinorVersion() < 5) {
					// Servlet <= 2.4: resort to name specified in web.xml, if any.
					wac.setId(ConfigurableWebApplicationContext.APPLICATION_CONTEXT_ID_PREFIX +
							ObjectUtils.getDisplayString(sc.getServletContextName()));
				}
				else {
					wac.setId(ConfigurableWebApplicationContext.APPLICATION_CONTEXT_ID_PREFIX +
							ObjectUtils.getDisplayString(sc.getContextPath()));
				}
			}
		}

		// Determine parent for root web application context, if any.
		ApplicationContext parent = loadParentContext(sc);

		wac.setParent(parent);
		wac.setServletContext(sc);
		//String initParameter = sc.getInitParameter(CONFIG_LOCATION_PARAM);
		//if (initParameter != null) {
		//	wac.setConfigLocation(initParameter);
		//}
		//customizeContext(sc, wac);
		
		// to load various contexts, we need to get Modules property
		String modules = (String) PhoenixProperties.getInstance().get(PROPERTYNAME);
		String[] moduleList = new String[0];

		if (modules != null) {
			modules = modules.trim();
			
			if (modules.length() > 0) {
				moduleList = modules.split(",");
			}
		}

		// now we create an list of application context file names
		ArrayList<String> configLocations = new ArrayList<String>();

        // always load applicationContext.xml
        configLocations.add(CONTEXTNAME + ".xml");

        for (String s : moduleList) {
            configLocations.add(CONTEXTNAME + s + ".xml");
		}

        for (String s : configLocations) {
            logger.info("Preparing " + s);            
        }

		wac.setConfigLocations(configLocations.toArray(new String[0]));
		wac.refresh();
		if (SpringUtils.beanFactory==null){
			SpringUtils.beanFactory = wac;
		}
	}
	
	/*protected void customizeContext(ServletContext servletContext, ConfigurableWebApplicationContext applicationContext) {
		String contextClassName = servletContext.getInitParameter(CONTEXT_CLASS_PARAM);

        Class<?> contextClass;
        if (contextClassName != null) {
			try {
				contextClass = Class.forName(contextClassName, true, Thread.currentThread().getContextClassLoader());
			} catch (ClassNotFoundException ex) {
				throw new ApplicationContextException("Failed to load context class [" + contextClassName + "]", ex);
			}
			
			if (!ConfigurableWebApplicationContext.class.isAssignableFrom(contextClass)) {
				throw new ApplicationContextException("Custom context class [" + contextClassName + "] is not of type ConfigurableWebApplicationContext");
			}
		} else {
            contextClass = XmlWebApplicationContext.class;
        }

		ConfigurableWebApplicationContext wac = (ConfigurableWebApplicationContext) BeanUtils.instantiateClass(contextClass);
		wac.setParent(applicationContext.getParent());
		wac.setServletContext(servletContext);
		
		//wac.refresh();
		
        if (SpringUtils.beanFactory==null) SpringUtils.beanFactory=wac;
	}*/
	
}
