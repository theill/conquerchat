<%
	
	' 
	' $Id: admin.display.asp,v 1.1.1.1 2003/03/09 22:45:57 peter Exp $
	' 
	' 
	'
	' @author	Peter Theill
	' 
	
 	Option Explicit
 	
	Response.Buffer = True
	
%>
<!-- #include file="inc.common.asp" -->
<%
	
	If (Session("com.theill.conquerchat.administrator") <> "True") Then
		Response.Write("Not validated")
		Response.End
	End If
	
	If (Request("action") = "kick") Then
		
		logoutUser(Request("userId"))
		
	ElseIf (Request("action") = "init") Then
		
		' initialise chat in order to fix users hanging in the chat or to apply 
		' room changes
		conquerChatUsers.RemoveAll
		conquerChatRooms.RemoveAll
		conquerChatMessages.RemoveAll
		
	ElseIf (Request("action") = "room.remove") Then
		
		removeRoom(Request("roomId"))
		
	End If
	
%>
<html>
<head>
	<title><%= getMsg("application.name") %></title>
	<link rel="stylesheet" type="text/css" href="css/chat.css" />
</head>

<body topmargin=0 leftmargin=0 marginwidth=0 marginheight=0 style="background-color: #CCCCCC">

<table width=100% border=0 cellspacing=0 cellpadding=0 style="position: absolute; top: 90px">
<tr>
	<td class="hdr"><%= getMsg("admin.login", getMsg("application.name")) %></td>
</tr>
<tr>
	<td style="background-color: #b3d68e; border-top: 1px dashed #ffffff; border-bottom: 1px dashed #ffffff" align=center>
		
		<br />
		
		<input onclick="location.replace('?action=init')" type="button" value="<%= getMsg("admin.button.init") %>" class="btn"><br />
		
		<br />
		
		<table border="0" cellpadding="4" cellspacing="1" width="320">
		<tr>
			<th class="uo"><%= gettext("Id") %></th>
			<th class="uo"><%= gettext("Username") %></th>
			<th class="uo"><%= gettext("IP Address") %></th>
			<th class="uo"><%= gettext("Actions") %></th>
		</tr>
		<%
			
			Function printUsers()
			
				Dim userId, user
				For Each userId In conquerChatUsers
						
					Set user = getUser(userId)
					
					Response.Write("<tr>") & vbCrLf
					Response.Write(" <td class=""uo"">" & user.id & "</td>") & vbCrLf
					Response.Write(" <td class=""uo"" width=""100%"">" & user.name & "</td>") & vbCrLf
					Response.Write(" <td class=""uo"">" & user.ipAddress & "</td>") & vbCrLf
					Response.Write(" <td class=""uo""><input onClick=""location.replace('?action=kick&userId=" & user.id & "')"" type=button class=btn name='action' value='" & getMsg("admin.button.kick") & "'></td>") & vbCrLf
					Response.Write("</tr>") & vbCrLf
					
				Next
				
			End Function
			
			printUsers()
			
		%>
		</table>
		
		<br />
		
		<table border="0" cellpadding="4" cellspacing="1" width="320">
		<tr>
			<th class="uo"><%= gettext("Id") %></th>
			<th class="uo"><%= gettext("Name") %></th>
<!--			<th class="uo"><%= gettext("Actions") %></th> -->
		</tr>
		<%
			
			Function printRooms()
			
				Dim roomId, room
				For Each roomId In conquerChatRooms
						
					Set room = getRoom(roomId)
					
					Response.Write("<tr>")
					Response.Write(" <td class=""uo"">" & room.id & "</td>")
					Response.Write(" <td class=""uo"" width=""100%"">" & room.name & "</td>")
'					Response.Write(" <td class=""uo""><input onclick=""location.replace('?action=room.remove&roomId=" & room.id & "')"" type=button class=btn value='" & getMsg("admin.button.remove") & "'></td>")
					Response.Write("</tr>")
					
				Next
				
			End Function
			
			printRooms()
			
		%>
		</table>
		
		<br>
		
	</td>
</tr>
</table>

<!-- Copyright(c) 2002, The Theill Web Site -->
<div style="position: absolute; bottom: 4px; right: 4px; padding: 4px; border: 3px dashed #bbbbbb;"><a href="http://www.theill.com/" target="_top"><img border="0" src="http://www.theill.com/images/ani_theillcom_scroll.gif" alt="Part of the Theill Web Site"></a></div>

</body>
</html>