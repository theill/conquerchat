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
<script language="vbscript" type="text/vbscript" runat="server">

	Dim db, rows
	Set db = new DbManager

	Function getRoomsUI(userId)
	
		Dim user
		Set user = New Person
		user.roomId = 1
		user.id = 1
		
		rows = db.GetRooms()
		
		getRoomsUI = "<table class=""Rooms"">"

		Dim room, i
		If (IsArray(rows)) Then
			For i = 0 To UBound(rows)
				Set room = New Room
				room.Load rows, i
				
				getRoomsUI = getRoomsUI & "<tr>"
				
				Dim cssClass
				If (room.id = user.roomId) Then
					' this room is where the user is located so apply different style
					cssClass = "rc"
				Else
					cssClass = "r"
				End If
				
				If (room.createdBy <> user.id) Then
					getRoomsUI = getRoomsUI & " <td class=" & cssClass & "><img src='images/ico.room.gif' width=16 height=16 alt='" & Server.HTMLEncode(room.name) & "' border=0></td>"
				Else
					getRoomsUI = getRoomsUI & " <td class=" & cssClass & "><a href='rooms.asp?chatId=" & userId & "&action=remove&roomId=" & room.id & "' onClick=""return confirmRemoveRoom('" & Server.HTMLEncode(room.name) & "')""><img src='images/ico.room.remove.gif' width=16 height=16 alt='Remove " & Server.HTMLEncode(room.name) & "' border=0></a></td>"
				End If
				
				getRoomsUI = getRoomsUI & " <td width=100% class=" & cssClass & "><a href=""javascript:goToRoom('" & room.id & "')"">" & Server.HTMLEncode(room.name) & "</a></td>"
				
				getRoomsUI = getRoomsUI & "<td align=right class=" & cssClass & ">" & countUsersInRoom(room.id) & "</td>"
				
				getRoomsUI = getRoomsUI & "</tr>"
			Next
		Else
			getRoomsUI = getRoomsUI & "<tr><td colspan=2>No rooms available</td></tr>"
		End If
		
		getRoomsUI = getRoomsUI & "</table>"
		
	End Function
	
	Response.Write getRoomsUI(1)

	Set db = Nothing

</script>
