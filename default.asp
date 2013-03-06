<%
	
	' 
	' $Id: default.asp,v 1.1.1.1 2003/03/09 22:45:57 peter Exp $
	' 
	' This page is the main entrace for ConquerChat. It shows a list of currently
	' logged in chatusers and makes it possible to log in by entering your user-
	' name in the appropriate field.
	' 
	' @author	Peter Theill
	' 
	
	Option Explicit
	
	Response.Buffer = True
	
%>
<!-- #include file="inc.common.asp" -->
<%
	
	' many users does not read the included README.TXT file before trying to 
	' set up this chat -- in order to help them a bit we check if we have the
	' required objects properly initialised
	On Error Resume Next
	If (NOT IsObject(conquerChatUsers) OR NOT IsObject(conquerChatRooms)) Then
		Response.Redirect("errorInSetup.asp")
		Response.End
	End If
	
	Dim userId
	
	' do not show login screen if a valid session exists
	If (loggedOn()) Then
		Response.Redirect "frames.asp"
		Response.End
	End If
	
	Dim mode, errorMessage
	mode = Request("mode")
	
	If (mode = "userLogin") Then
		
		Dim userName
		userName = Server.HTMLEncode(Request("username"))
		
		If (countUsers() >= USERS) Then
			errorMessage = getMsg("error.maximum_users_reached")
		ElseIf (Len(userName) = 0)  Then
			errorMessage = getMsg("error.missing_username")
		ElseIf (Len(userName) > MAX_USERNAME_LENGTH) Then
			errorMessage = getMsg("error.username_length_exceeded", MAX_USERNAME_LENGTH)
		ElseIf (userExists(userName)) Then
			errorMessage = getMsg("error.username_in_use")
		ElseIf (NOT isValidUsername(userName)) Then
			errorMessage = getMsg("error.invalid_username")
		ElseIf (isUserNameBlocked(userName)) Then
			errorMessage = getMsg("error.username_blocked")
		Else
			
			Dim p
			Set p = New Person
			p.id = -1
			p.name = userName
			p.roomId = 0
			p.ipAddress = Request.ServerVariables("REMOTE_ADDR")
			
			' we have a new chat user thus we need to create a new
			' id for him/her
			Set p = addUser(p)
			
			' tell all other users about this new user
			Call addMessage( _
				p.id, _
				"-1", _
				"<span class=LoggedIn><img src='images/new.gif' height=9 width=9>&nbsp;" & getMsg("user.logged_on", p.name, Now()) & "</span><br>" _
			)
			
			Session("user") = p.data
			
			' redirect to new frame window and create a new user login
			Response.Redirect("frames.asp")
			Response.End
			
		End If
		
	End If ' > If (mode = "userLogin") Then
	
	' make sure we don't show any inactive users for new chat users
	kickInactiveUsers()
	
	If (conquerChatRooms.Count = 0) Then
		setupRooms()
	End If
	
%>
<html>
<head>
	<title><%= getMsg("application.name") %></title>
	<link rel="stylesheet" type="text/css" href="css/chat.css" />
	<script language="JavaScript1.2" type="text/javascript">
	<!--
		
		function init() {
			// set focus on 'username' field
			f = document.frmLogin;
			if (typeof f != 'undefined' && typeof f.username != 'undefined') {
				f.username.select();
				f.username.focus();
			}
		}
		
	// -->
	</script>
</head>

<body class="frontpage" onload="init()">
	
<% If (Len(errorMessage) > 0) Then %>
<center>
	<br />
	<div class="err">
		<%= errorMessage %>
	</div>
</center>
<% End If %>

<table border="0" cellspacing="0" cellpadding="0" style="margin-top: 90px" width="100%">
<tr>
	<td class="hdr"><%= getMsg("login.join_chat", getMsg("application.name") & " " & getMsg("application.version")) %></td>
</tr>
<tr>
	<td style="background-color: #b3d68e; border-top: 1px dashed #ffffff; border-bottom: 1px dashed #ffffff" align=center>

		<br />

		<form name="frmLogin" method="GET" action="default.asp">
		<table width="240" border="0" cellspacing="0" cellpadding="2">
		<input type="hidden" name="mode" value="userLogin">
		<tr>
			<td>&nbsp;</td>
			<td align=right style="font-size: 10px;"><%= getMsg("login.username") %></td>
			<td width="100%"><input type=text name=username value="<%= Server.HTMLEncode(userName) %>" class=editField size=28 maxlength=32 tabindex=1></td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td colspan=2 align=right><input type=submit class=btn name=login value="<%= getMsg("button.login") %>" border=0 tabindex=2 title="<%= getMsg("button.login.title") %>"></td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td colspan=2 align=center style="color: #999999;">
				<br>
				<br>
				<br>
			</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td colspan="2">
			
		<table width=100% border=0 cellspacing=0 cellpadding=4 style="border-right: 3px double #003300">
		<tr>
			<td colspan=3 class=uocap><%= getMsg("login.users_online") %></td>
		</tr>
		<% If (countUsers() <> 0) Then %>
		<tr>
			<th class=uo>&nbsp;</th>
			<th class=uo><%= getMsg("login.header.username") %></th>
			<th class=uo><%= getMsg("login.header.room") %></th>
		</tr>
		<%
			
			' display all users and their associated rooms
			
			Dim user, room_
			For Each userId In conquerChatUsers
				
				Set user = getUser(userId)
				Set room_ = getRoom(user.roomId)
				If (room_ Is Nothing) Then
					Set room_ = New Room
					room_.name = "N/A"
				End If
				
				Response.Write("<tr>")
				Response.Write(" 	<td class=uo width=24><nobr><img src='images/transparent.gif' width=8 height=16><img src='images/ico.user.gif' width=16 height=16 border=0></nobr></td>")
				Response.Write(" 	<td class=uo>" & user.name & "</td>")
				Response.Write(" 	<td class=uo>" & Server.HTMLEncode(room_.name) & "</td>" & vbCrLf)
				Response.Write("</tr>")
				
			Next
			
		%>
		<tr>
			<td class=uofoot colspan=3>
				<br>
				<%= getMsg("login.users_logged_on", countUsers(), USERS) %>
			</td>
		</tr>
		<% Else %>
		<tr>
			<td class=uo colspan=3>&nbsp;<%= getMsg("login.no_users_online") %></td>
		</tr>
		<% End If %>
		</table>	
			
			</td>
			<td>&nbsp;</td>
		</tr>
		</table>
		</form>
	</td>
</tr>
<tr>
	<td style="font-size: 10px; font-weight: lighter; text-align: justify;color: #666666; padding: 8px">
		[This is the development version of ConquerChat -- you are able to log on to test the features of it but errors might occur since I'm working 
        directly on this one. This chat may not show the exact downloadable source 
        either since I might be in the progress of developing additional 
        features. If you're interested in getting the <b>free ASP source code</b> 
        for this chat, visit the <a href="http://www.theill.com/asp/conquerchat.asp" style="font-weight: bolder">ConquerChat section</a> where you're able to download all versions. If you are hosting this chat on your own server you're free to remove this notice.]
    </td>
</tr>
</table>

<center>
<script type="text/javascript"><!--
google_ad_client = "pub-8907174049372989";
/* ConquerChat &quot;footer&quot; */
google_ad_slot = "2121436745";
google_ad_width = 728;
google_ad_height = 90;
//-->
</script>
<script type="text/javascript"
src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
</script>
</center>

<!-- Copyright(c) 2003, The Theill Web Site -->
<div style="position: absolute; bottom: 4px; right: 4px; padding: 4px; border: 3px dashed #bbbbbb;"><a href="http://www.theill.com/" target="_top"><img border="0" src="http://www.theill.com/images/ani_theillcom_scroll.gif" alt="Provided for free by The Theill Web Site"></a></div>

<!-- #include virtual="/inc.tracking.asp" -->

</body>
</html>