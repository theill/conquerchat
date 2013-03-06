<%
	
	' 
	' $Id: control.asp,v 1.1.1.1 2003/03/09 22:45:57 peter Exp $
	' 
	' Controls all server-side processing when a user request list of users,
	' rooms, messages, etc.
	' 
	' @author	Peter Theill
	' 
	
	Option Explicit
	
%>
<!-- #include file="inc.common.asp" -->
<!-- #include file="inc.view.asp" -->
<%
	
	If (NOT loggedOn()) Then
		Response.Write(getLoggedOutScript(False))
		Response.End
	End If
	
	Dim user
	Set user = getLoggedOnUser()
	
	If (Request("mode") = "message") Then
		
		' a new message has been send to chat. We want this message to 
		' be added our list of messages, indicating which user sent it
		
		Dim textMessage: textMessage = Request("message")
		
		' do not add empty messages to chat
		If (Len(textMessage) > 0) Then
			
			If (Request("toUserId") = "" OR Request("toUserId") = "-1") Then
				Call addUserMessage(user.id, textMessage)
			Else
				Call addPrivateMessage(user.id, CStr(Request("toUserId")), textMessage)
			End If
			
		End If ' > If (Len(textMessage) > 0) Then
		
	End If
	
	
	' user wants to logoff, so we will have to notify all other users 
	' about this by printing some kind of 'user X is now logging off' 
	' message.
	If (Request("action") = "logoff") Then
		
		' add a leaving message to chatroom and remove user from list of active
		' users in this chat room
		logoutUser(user.id)
		
		' remove user variable stored in session
		Session.Contents.Remove(SESSIONKEY_USER)
		
		' execute javascript function where redirection occurs
		Response.Write("onLoggedOff();")
		
	End If
	
	kickInactiveUsers()
	
	If (CLEAR_ON_EMPTY AND (countUsers() = 0)) Then
		
		' clear all messages in all rooms
		conquerChatMessages.RemoveAll
		
	End If
	
	If (Request("action") = "refresh") Then
		
		Response.Write("updateMessages('messages', '" & jsEncode(getMessages(user.roomId, user.id, NEWEST_MESSAGE_IN_TOP)) & "');")
		Response.Write("scrollToBottom('" & jsBool(Not NEWEST_MESSAGE_IN_TOP) & "');")
		
	End If
	
	If (Request("action") = "private.refresh") Then
		
		Dim touser
		Set touser = getUser(CStr(Request("toUserId")))
		If (NOT touser Is Nothing) Then
			Response.Write("updatePrivateMessages('messages', '" & jsEncode(getPrivateMessages(user.roomId, user.id, touser.id, NEWEST_MESSAGE_IN_TOP)) & "');")
			Response.Write("scrollToBottom('" & jsBool(Not NEWEST_MESSAGE_IN_TOP) & "');")
		End If
		
	End If
	
	If (Request("action") = "update.users") Then
		
		Response.Write("updateUsers('data', '" & jsEncode(getUsersUI(user.id)) & "');")
		
		Dim data, userId_, user_
		data = ""
		
		For Each userId_ In conquerChatUsers
			Set user_ = getUser(userId_)
			If (user_.roomId = user.roomId) Then
				data = data & user_.id & "|" & user_.name & ","
			End If
		Next
		
		If (Len(data) > 1) Then
			data = Left(data, Len(data)-1)
		End If
		
		Response.Write("onUsersChanged('" & data & "');")
		
	End If
	
	If (Request("action") = "update.rooms") Then
		
		Response.Write("updateRooms('data', '" & jsEncode(getRoomsUI(user.id)) & "');")
		
	End If
	
	
	' user clicked on a new room and thus we need to put the user into the 
	' selected room and refresh list of messages, users and rooms
	If (Request("action") = "room.switch") Then
		
		' get room destination
		Dim roomId
		roomId = Request("roomId")
		If (roomId = "") Then	' this ought not to happen, but ...
			roomId = user.roomId
		End If
		
		' switch to new room
		Call enterRoom(CStr(user.id), CStr(roomId))
		
		Response.Write("updateRooms('data', '" & jsEncode(getRoomsUI(user.id)) & "');")
		Response.Write("updateUsers('data', '" & jsEncode(getUsersUI(user.id)) & "');")
		Response.Write("updateMessages('messages', '" & jsEncode(getMessages(user.roomId, user.id, NEWEST_MESSAGE_IN_TOP)) & "');")
		Response.Write("scrollToBottom('" & LCase(CStr(Not NEWEST_MESSAGE_IN_TOP)) & "');")
		
	End If
	
%>