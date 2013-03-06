<% Option Explicit %>
<!-- #include file="inc.common.asp" -->
<%
	
	' 
	' $Id: window.asp,v 1.1.1.1 2003/03/09 22:45:57 peter Exp $
	' 
	' Prints all available chatlines out on response stream if user has a valid
	' session, i.e. hasn't been logged out of the system and has a valid chat
	' identifier.
	' 
	' This script also logs off users if they requested it or if their session
	' has timed out, e.g. if they haven't written anything in the chat window
	' for a while (default is 5 minutes)
	' 
	' @author	Peter Theill
	' 
	
	Response.Buffer = True
	
	If (NOT loggedOn()) Then
		Response.Write(getLoggedOutScript(True))
		Response.End
	End If
	
	Dim user
	Set user = getLoggedOnUser()
	
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN"
	"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<title><%= getMsg("application.name") %></title>
	<link rel="stylesheet" type="text/css" href="css/chat.css">
	<script language="JavaScript1.2" type="text/javascript" src="js/update.js"></script>
	<script language="JavaScript1.2" type="text/javascript">
		
		/**
		 * Sets up this frame to do server-poll in specific intervals. This poll 
		 * checks for changed data and updates the view if changes were found.
		 * 
		 */
		function init() {
			
			refreshFunction = 'executeRequest(\'action=refresh\')';
			eval(refreshFunction);
			
			setInterval(refreshFunction, <%= (MESSAGES_REFRESH_RATE * 1000) %>);
			
		} // > function init()
		
	</script>
</head>

<body class="messages" onload="init()">
<div class="hdr">
	<%= getMsg("application.name") %>
</div>

<div class="msgs" id="messages" name="messages"></div>

</body>
</html>