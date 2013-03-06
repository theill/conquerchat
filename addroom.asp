<%
	
	' 
	' $Id: addroom.asp,v 1.1.1.1 2003/03/09 22:45:57 peter Exp $
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
	
	
	If (NOT loggedOn()) Then
		Response.Write(getLoggedOutScript(True))
		Response.End
	End If
	
	Dim user
	Set user = getLoggedOnUser()
	
	Dim roomName, needToRefreshRooms, noMoreRoomsAllowed, invalidRoom
	roomName = Request("ediRoomName")
	needToRefreshRooms = False
	noMoreRoomsAllowed = False
	invalidRoom = False
	If ((Request("action") = "addRoom") AND (Len(roomName) > 0)) Then
		If (conquerChatRooms.Count < NUMBER_OF_ROOMS) Then
			' a new room needs to be added the chat. We include id of the chat user
			' creating this chat. This makes it possible for us to print his/hers
			' name next to the name of the room
			invalidRoom = NOT addRoom(roomName, user.id)
			needToRefreshRooms = True
		Else
			noMoreRoomsAllowed = True
		End If
	End If
	
%>
<html>
<head>
	<title><%= getMsg("application.name") %></title>
	<link rel="stylesheet" type="text/css" href="css/chat.css">
	<script type="text/javascript">
	<!--
		
		function init() {
			;
		}
		
	<% If (needToRefreshRooms) Then %>
		if (typeof parent != 'undefined' && typeof parent.rooms != 'undefined') {
			parent.rooms.location.href = 'rooms.asp';
		} else {
			alert("Configuration Error! No 'rooms' frame is available.");
		}
	<% End If %>
	
	<% If (noMoreRoomsAllowed) Then %>
		alert('<%= getMsg("rooms.max_limit_reached", NUMBER_OF_ROOMS, getMsg("application.webmaster_email")) %>');
	<% End If %>

	<% If (invalidRoom) Then %>
		alert('<%= getMsg("rooms.name_not_allowed", ROOMNAME_PATTERN) %>');
	<% End If %>
	
	// -->
	</script>
</head>

<body class="add_room" onLoad="init()">
<table border="0" width="100%" cellspacing="0" cellpadding="0">
<form method="POST" name="frmAddRoom" action="addroom.asp">
<input type="hidden" name="action" value="addRoom">
<tr>
	<td width="100%"><input type="text" class='editField' name="ediRoomName" size=10 style="width: 100%"></td>
	<td><img src="images/dot.gif" width=4 height=16 border=0><input type=submit class=btn name=submit value="<%= getMsg("button.add") %>" title="<%= getMsg("button.add.title") %>" border="0" /></td>
</tr>
</form>
</table>
</body>
</html>