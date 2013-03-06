<%
	
	' 
	' $Id: profile.asp,v 1.1.1.1 2003/03/09 22:45:57 peter Exp $
	' 
	' Display user profile.
	' 
	' @author	Peter Theill
	' 
	
	Option Explicit
	
%>
<!-- #include file="inc.common.asp" -->
<%
	
	Dim userId, user
	userId = Request("userId")
	Set user = getUser(userId)
	If (user Is Nothing) Then
		Response.Write("User not available anymore.")
		Response.End
	End If
	
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN"
	"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<title><%= getMsg("application.name") %> - <%= getMsg("profile.title", user.name) %></title>
	<link rel="stylesheet" type="text/css" href="css/chat.css" />
</head>

<body class="profile">
<div class="hdr">
	<%= getMsg("profile.title", user.name) %>
</div>

<div style="margin: 8px">
<table border="0" width="100%" cellspacing="0" cellpadding="2">
<tr>
	<td><%= getMsg("profile.ip_address") %>&nbsp;</td>
	<td align=right><%= user.ipAddress %>&nbsp;</td>
</tr>
<tr>
	<td><%= getMsg("profile.logged_on") %>&nbsp;</td>
	<td align=right><%= user.loggedOn %>&nbsp;</td>
</tr>
<tr>
	<td><%= getMsg("profile.last_action") %>&nbsp;</td>
	<td align=right><%= user.lastAction %>&nbsp;</td>
</tr>
<tr>
	<td><%= getMsg("profile.written_messages") %>&nbsp;</td>
	<td align=right><%= user.sendMessages %>&nbsp;</td>
</tr>
</table>
</div>

<div style="position: absolute; right: 8px; bottom: 8px;">
	<input type="button" value="<%= getMsg("profile.close") %>" class="btn" onClick="window.close()" />
</div>

</body>
</html>