<%@page import="java.util.HashMap" errorPage="errorpage.jsp"%>
<%
	if (session != null) {
		Object user = session.getAttribute("user");
		if (user != null) {
			//HashMap hash=(HashMap)application.getAttribute("monitor");
			session.invalidate();
			request.getSession();
			String ip = request.getRemoteAddr();
			//LogAction.addLog((String)user, LogConst.LOGOUT, LogConst.CON_LOGIN, "", ip);
		}
	}
	String param = "";
	if (request.getParameter("login") != null) {
		param = "?login=" + request.getParameter("login");
	}
	response.sendRedirect("index.jsp" + param);
%>
