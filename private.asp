<% Option Explicit %>
<!-- #include file="inc.common.asp" -->
<%
	
	' 
	' $Id: private.asp,v 1.1.1.1 2003/03/09 22:45:57 peter Exp $
	' 
	' @author	Peter Theill
	' 
	
	Dim srcUserId, srcUser, dstUserId, dstUser
	srcUserId = CStr(Request("srcUserId"))
	dstUserId = CStr(Request("dstUserId"))
	
	Set srcUser = getUser(srcUserId)
	Set dstUser = getUser(dstUserId)
	
	If (dstUser Is Nothing) Then
		Response.Write("User not available anymore.")
		Response.End
	End If
	
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN"
	"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<title><%= getMsg("application.name") %></title>
	<link rel="stylesheet" type="text/css" href="css/chat.css">
	<script language="JavaScript1.2" type="text/javascript" src="js/update.js"></script>
	<script language="JavaScript1.2" type="text/javascript">
	<!--
		
		function init() {
			
			refreshFunction = 'executeRequest(\'action=private.refresh,userId=<%= srcUserId %>,toUserId=<%= dstUserId %>\')';
			eval(refreshFunction);
			
			setInterval(refreshFunction, <%= (MESSAGES_REFRESH_RATE * 1000) %>);
		}
		
	// -->
	</script>
</head>

<body class=profile onLoad="init()">
<div class=hdr>
	<%= getMsg("private.title", srcUser.name, dstUser.name) %>
</div>

<div class=msgs id=messages name=messages></div>

</body>
</html>