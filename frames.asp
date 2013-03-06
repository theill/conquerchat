<% Option Explicit %>
<!-- #include file="inc.common.asp" -->
<%
	
	' 
	' $Id: frames.asp,v 1.1.1.1 2003/03/09 22:45:57 peter Exp $
	' 
	' 
	' 
	' @author	Peter Theill
	' 
	
	If (NOT loggedOn()) Then
		Response.Redirect "expired.asp?reload=true"
		Response.End
	End If
	
%>
<html>
<head>
	<title><%= getMsg("application.name") %></title>
	<link rel="stylesheet" type="text/css" href="css/chat.css">
	<script language="JavaScript1.2" type="text/javascript" src="js/update.js"></script>
	<script type="text/javascript" language="JavaScript1.2">
	<!--
		
		function showLogOffWindow() {
			document.frames['messages'].document.body.insertAdjacentHTML(
				'beforeEnd',
				'<iframe name="logoutwin" src="logout.asp" width="0" height="0" frameborder="0"></iframe>'
				);
			
			executeRequest('action=logoff');
		}
		
		function onLoggedOff() {
			;
		}
		
	// -->
	</script>
</head>

<frameset rows="*,94" onUnload="showLogOffWindow()">
	<frameset cols="*,150">
		<frame name="messages" src="window.asp">
		<frameset rows="66%,34%,36">
			<frame name="users" src="users.asp" scrolling=no>
			<frame name="rooms" src="rooms.asp" scrolling=no>
			<frame name="add_room" src="addroom.asp" scrolling=no>
		</frameset>
	</frameset>
	
	<frame name="message" src="message.asp" scrolling=no noresize>
	
	<noframes>
	<body>
		ConquerChat is a <b>frame-based</b> free chat done in ASP and includes full source code.
	</body>
	</noframes>
</frameset>

</html>