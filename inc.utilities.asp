<%
	
	' 
	' $Id: inc.utilities.asp,v 1.1.1.1 2003/03/09 22:45:57 peter Exp $
	' 
	' A collection of utility functions used to find user information, add and
	' remove rooms, add new messages to chat, etc.
	' 
	' @author	Peter Theill
	' 
	
	'
	' The userExists(username) function is able to find a specific logged in
	' user using his or hers username (aka chatname).
	' 
	' Function returns True if user was found, False otherwise.
	'
	Function userExists(userName)
		
		userName = Trim(userName)
		
		Dim arUsers, i, user
		arUsers = conquerChatUsers.Keys
		For i = 0 To conquerChatUsers.Count-1
			
			Set user = getUser(arUsers(i))
			If (StrComp(userName, user.name, 1) = 0) Then
				UserExists = True
				Exit Function
			End If
			
		Next
		
		UserExists = False
		
	End Function ' // > Function userExists(...)
	
	
	'
	' Returns Room object specified by parameter "roomId". If the room 
	' does not exist, Nothing is returned
	'
	Function getRoom(roomId)
		
		' make sure id is treated as a String variant
		roomId = CStr(roomId)
		
		If (conquerChatRooms.Exists(roomId)) Then
			Set getRoom = New Room
			getRoom.data = conquerChatRooms.Item(roomId)
			Exit Function
		End If
		
		Set getRoom = Nothing
		
	End Function ' // > Function getRoom(...)
	
	
	Function getRoomByName(roomName)
		
		Dim roomId
		For Each roomId In conquerChatRooms
			Set getRoomByName = getRoom(roomId)
			If (NOT (getRoomByName Is Nothing)) Then
				If (StrComp(roomName, getRoomByName.name, 1) = 0) Then
					Exit Function
				End If
			End If
		Next
		
		Set getRoomByName = Nothing
		
	End Function ' // > Function getRoomByName(...)
	
	
	'
	' Generates a unique MD5 value based on users IP, User Agent and Session.
	' 
	' @return 	String with MD5 value.
	'
	Function getUserMD5()
		getUserMD5 = MD5( _
			"SID" & _
			Request.ServerVariables("REMOTE_ADDR") & _
			Request.ServerVariables("HTTP_USER_AGENT") & _
			Session.SessionID _
		)
	End Function
	
	
	'
	' The isLoggedIn(userId) function ensures a valid user login. If the user
	' has been kicked out or his/hers session has expired, the user has been
	' removed from the array of active users and thus needs to login again
	' if he/she wants to continue chatting. Be aware that this function only
	' checks if the *current* user is logged in and thus you cannot use this
	' function to check if _any_ user is available. The function uses an 
	' algorithm to ensure the user id passed to this function is the actual
	' user.
	' 
	' @return 	True if user is logged in; False otherwise.
	'
	Function isLoggedIn(userId)
		
		' check for fake userId's
		If (getUserMD5() <> userId) Then
			isLoggedIn = False
			Exit Function
		End If
		
		Dim user
		Set user = getUser(userId)
		If (NOT (user Is Nothing)) Then
			Dim room
			Set room = getRoom(user.roomId)
			If (NOT (room Is Nothing)) Then
				isLoggedIn = True
				Exit Function
			End If
		End If
		
		isLoggedIn = False
		
	End Function ' // > Function isLoggedIn(...)
	
	Function loggedOn()
		
		Dim p
		Set p = new Person
		p.data = Session(SESSIONKEY_USER)
		loggedOn = p.id <> -1
		
	End Function
	
	
	' 
	' The "addUser(user)" function adds a new user to the chat. When a 
	' user enters, a unique key is generated in order to track user properly
	' without using an ASP Session object.
	' 
	' Function returns unique id of new user.
	' 
	Function addUser(user)
		
		' generate a unique MD5 key for this user
		user.id = getUserMD5()
		
		' as default, the user is placed in the main entrance room
		user.roomId = 0
		
		' add user to our internal structure of active users
		conquerChatUsers.Add user.id, user.data
		
		' return user with updated information
		Set addUser = user
		
	End Function ' // > Function addUser(...)
	
	
	'
	' Since classes in VBScript doesn't maintains its instance between pages
	' we have to make sure all data we change on an instance will be stored
	' in our global structure of users. This method simply reset the values
	' for the specified user.
	'
	Private Function updateUser(user)
		
		' reflect local changes in global object
		conquerChatUsers.Item(user.id) = user.data
		
		Set updateUser = user
		
		Session(SESSIONKEY_USER) = user.data
		
	End Function ' // > Private Function updateUser(...)
	
	
	Sub logoutUser(userId)
		
		userId = CStr(userId)
		
		Dim user
		Set user = getUser(userId)
		If (user Is Nothing) Then
			Exit Sub
		End If
		
		Call addMessage( _
			user.id, _
			"-1", _
			"<span class='LoggedOut'><img src='images/bp.gif' height='9' width='9'>&nbsp;" & getMsg("user.logged_off", user.name, Now()) & "</span><br />" _
		)
		
		' remove user timestamps and name
		Call removeUser(userId)
		
		Set user = Nothing
		
	End Sub
	
	
	'
	' The 'removeUser(userId)' sub procedure removes a logged in user either
	' because his/hers session has expired, was kicked or clicked on logout.
	' 
	Private Sub removeUser(userId)
		
		' make sure we convert this in-parameter to a string since we store
		' user keys as strings in our global Dictionary object
		userId = CStr(userId)
		
		If (conquerChatUsers.Exists(userId)) Then
			conquerChatUsers.Remove(userId)
			
			' we need to remove all rooms for this user as well
			removeUserRooms(userId)
		End If
		
	End Sub ' // > Private Sub removeUser(...)
	
	
	'
	' Remove all rooms created by this user. Function will be called when this
	' user logs out or is kicked for inactivity.
	'
	Private Function removeUserRooms(userId)
		
		Application.Lock
		Dim roomId, room
		For Each roomId In conquerChatRooms
			Set room = getRoom(roomId)
			If (NOT room Is Nothing) Then
				If (room.createdBy = userId) Then
					removeRoom(room.id)
				End If
			End If
		Next
		Application.UnLock
		
	End Function ' // > Private Function removeUserRooms(...)
	
	
	' 
	' The countUsers function returns the number of currently logged in chat
	' users in all rooms.
	' 
	Function countUsers()
		
		countUsers = conquerChatUsers.Count
		
	End Function ' // > Function countUsers()
	
	
	Function countUsersInRoom(roomId)
		
		Dim cnt
		cnt = 0
		
		Dim userId, user
		For Each userId In conquerChatUsers
			Set user = getUser(userId)
			If (NOT user Is Nothing) Then
				If (user.roomId = roomId) Then
					cnt = cnt + 1
				End If
			End If
		Next
		
		countUsersInRoom = cnt
		
	End Function
	
	
	Sub addMessageToLogFile(timestamp, fromUserId, toUserId, message)
		
		If (Len(MESSAGES_LOGFILE) = 0) Then
			Exit Sub
		End If
		
		' get user information
		Dim user, toUser, room, toUser_name
		Set user = getUser(fromUserId)
		Set toUser = getUser(toUserId)
		Set room = getRoom(user.roomId)
		
		' find destination name and use 'All' if no destination user was specified
		If (toUser Is Nothing) Then
			toUser_name = "All"
		Else
			toUser_name = toUser.name
		End If
		
		Dim fs, f
		
		' open text file for appending - create file if it doesn't already exists
		Set fs = CreateObject("Scripting.FileSystemObject")
		Set f = fs.OpenTextFile(Server.MapPath(MESSAGES_LOGFILE), 8, True)
		
		' write a text message using format specified in configuration file
		f.WriteLine "[" & timestamp & "] [" & room.name & "] [" & user.name & " => " & toUser_name & "] """ & message & """"
		
		f.Close
		
		Set f = Nothing
		Set fs = Nothing
		
	End Sub ' // > Sub addMessageToLogFile(...)
	
	
	'
	' Adds a new message to the room the user is currently located in. The
	' message will be added to the queue of posted messages and printed for
	' all users the next time the "window.asp" page is refreshed.
	'
	Function addUserMessage(userId, message)
		
		' lock (synchronize) access to global variables
		Application.Lock
		
		' get user information
		Dim user
		Set user = getUser(userId)
		
		' log message to a text file
		Call addMessageToLogFile(Now(), userId, -1, message)
		
		' build new message
		message = formatMessage(message)
		message= formatMessageUI(user, message)
		
		' adds new message to queue
		Call addMessage(userId, -1, message)
		
		user.sendMessages = user.sendMessages + 1
		
		' update users timestamp (thus we know he/she is active)
		user.action()
		
		' update internal class structure
		updateUser(user)
		
		' unlock access to global variables
		Application.UnLock
		
	End Function ' // > Function addUserMessage(...)
	
	
	'
	'
	'
	Function addPrivateMessage(fromUserId, toUserId, message)
		
		' get user information
		Dim user, toUser
		Set user = getUser(fromUserId)
		Set toUser = getUser(toUserId)
		
		' log message to a text file
		Call addMessageToLogFile(Now(), fromUserId, toUserId, message)
		
		' format message to user before adding it to message queue
		message = formatMessage(message)
		message = formatPrivateMessageUI(user, toUser, message)
		
		' adds new message to queue
		Call addMessage(fromUserId, toUserId, message)
		
		' show message for yourself as well
		Call addMessage(fromUserId, fromUserId, message)
		
		user.sendMessages = user.sendMessages + 1
		
		' update users timestamp (thus we know he/she is active)
		user.action()
		
		' update internal class structure
		updateUser(user)
		
	End Function ' // > Function addPrivateMessage(...)
	
	
	
	' 
	' The getUser(userId) function returns the object of specified user. 
	' All users of this chat has a unique id in order to identify him/her
	' without using sessions.
	' 
	' @return 	Object of user if found, 'Nothing' object otherwise.
	' 
	Function getUser(userId)
		
		userId = CStr(userId)
		If (conquerChatUsers.Exists(userId)) Then
			Set getUser = New Person
			getUser.data = conquerChatUsers.Item(userId)
			Exit Function
		End If
		
		Set getUser = Nothing
		
	End Function ' // > Function getUser(...)
	
	
	Function getLoggedOnUser()
	
		Dim p
		Set p = new Person
		p.data = Session(SESSIONKEY_USER)
		
		Set getLoggedOnUser = p
		
	End Function ' // > Function getLoggedOnUser()
	
	
	Function getMessage(messageId)
		
		messageId = CStr(messageId)
		If (conquerChatMessages.Exists(messageId)) Then
			Set getMessage = New Message
			getMessage.data = conquerChatMessages.Item(messageId)
			Exit Function
		End If
		
		Set getMessage = Nothing
		
	End Function
	
	
	'
	' Adds a new room with specified name and owned by specified user.
	' 
	' @param 	roomName 	Name of room to add.
	' @param 	userId 		Id of user owning this room.
	' @return 	True if room was successfully created; False otherwise.
	'
	Function addRoom(roomName, userId)
		
		userId = CStr(userId)
		
		' check for valid room name if a pattern exists
		If (Len(ROOMNAME_PATTERN) > 0) Then
			Dim check
			Set check = New RegExp
			check.Pattern = ROOMNAME_PATTERN
			check.IgnoreCase = False
			check.Global = True
			If (NOT check.Test(roomName)) Then
				addRoom = False
				Exit Function
			End If
		End If
		
		Application.Lock
		If (getRoomByName(roomName) Is Nothing) Then
			Dim room
			Set room = New Room
			room.id = CStr(conquerChatRooms.Count)
			room.name = roomName
			room.createdBy = userId
			
			conquerChatRooms.Add room.id, room.data
			addRoom = True
		Else
			addRoom = False
		End If
		Application.UnLock
		
	End Function ' // > Function addRoom(...)
	
	
	'
	' Removes specified room.
	' 
	' @param 	roomId 	Id of room to remove.
	' @return 	True if room was removed; False otherwise.
	'
	Function removeRoom(roomId)
		
		' avoid VB converting type
		roomId = CStr(roomId)
		
		' make sure we actually have the room we are about to remove
		If (conquerChatRooms.Exists(roomId)) Then
			
			' remove from global internal structure
			conquerChatRooms.Remove(roomId)
			
			' transfer all users from this (removed) room to main entrance
			Dim userId, user
			For Each userId In conquerChatUsers
				Set user = getUser(userId)
				If (NOT user Is Nothing) Then
					If (user.roomId = roomId) Then
						user.roomId = 0
						updateUser(user)
					End If
				End If
			Next
			
			' room was successfully removed
			removeRoom = True
			
		Else
			
			' the room does not exist so it cannot be removed
			removeRoom = False
			
		End If
		
	End Function ' // > Function removeRoom(...)
	
	
	'
	' This user wants to switch to another room thus we have to remove
	' the id from the old one and place it in the new
	'
	Function enterRoom(userId, roomId)
		
		' avoid VB converting
		userId = CStr(userId)
		roomId = CStr(roomId)
		
		Dim user, roomOld, roomNew
		Set user = getUser(userId)
		Set roomOld = getRoom(user.roomId)
		Set roomNew = getRoom(roomId)
		
		' it's not necessary to perform anything if the user tries to enter the 
		' same room he is currently located in
		If (roomOld.name <> roomNew.name) Then
			
			Application.Lock
			
			' notify users in old room about this user leaving
			Call addMessage( _
				userId, _
				"-1", _
				"<span class=LeavingRoom>&nbsp;" & getMsg("user.left_room", user.name, Server.HTMLEncode(roomOld.name), Server.HTMLEncode(roomNew.name)) & "</span><br>" _
			)
			
			' change room in Person object and make change persistent
			user.roomId = roomId
			updateUser(user)
			
			' notify users in new room about this user joining
			Call addMessage( _
				userId, _
				"-1", _
				"<span class=EnteringRoom>&nbsp;" & getMsg("user.entered_room", user.name, Server.HTMLEncode(roomOld.name), Server.HTMLEncode(roomNew.name)) & "</span><br>" _
			)
			
			Application.UnLock
			
		End If
		
	End Function ' // > Function enterRoom(...)
	
	
	Function getNumberOfPublicMessages()
	
		Dim i, message
		
		getNumberOfPublicMessages = 0
		
		For i = 0 To conquerChatMessages.Count-1
			Set message = getMessage(CStr(i))
			If (NOT message Is Nothing) Then
				If (StrComp(CStr(message.receiverId), "-1", 1) = 0) Then
					getNumberOfPublicMessages = getNumberOfPublicMessages + 1
				End If
			End If
		Next
		
	End Function ' // > Function getNumberOfPublicMessages()
	
	
	Sub pushMessage(data)
		
		If (getNumberOfPublicMessages() >= MESSAGES) Then
			' we need to remove a public entry from message array
			
			Dim i
			For i = 0 to conquerChatMessages.Count-2
				conquerChatMessages.Item(CStr(i)) = conquerChatMessages.Item(CStr(i+1))
			Next
			
			conquerChatMessages.Remove(CStr(conquerChatMessages.Count-1))
			
		End If
		
		conquerChatMessages.Add CStr(conquerChatMessages.Count), data
		
	End Sub
	
	
	Function addMessage(userId, receiverId, text)
		
		Dim user, message
		Set user = getUser(CStr(userId))
		Set message = New Message
		
		message.roomId = user.roomId
		message.userId = user.id
		message.receiverId = receiverId
		message.text = text
		message.time = Now()
		
		pushMessage(message.data)
		
		Set addMessage = message
		
	End Function ' // > Function addMessage(...)
	
	
	'
	' Writes messages directly to output
	' 
	' @see getMessages()
	'
	Sub printMessages(roomId, userId, topToBottomOrder)
		
		Response.Write(getMessages(roomId, userId, topToBottomOrder))
		
	End Sub
	
	
	'
	' Gets all messages to be displayed in a chatroom for specified room and 
	' user. The sort order is specified to allow HTML stream to be printed
	' top to bottom or bottom to top
	'
	Function getMessages(roomId, userId, topToBottomOrder)
	
		Dim a, b, c, i, message
		
		If (topToBottomOrder) Then
			a = conquerChatMessages.Count-1
			b = 0
			c = -1
		Else
			a = 0
			b = conquerChatMessages.Count-1
			c = 1
		End If
		
		For i = a To b Step c
			Set message = getMessage(i)
			If (NOT message Is Nothing) Then
				If (message.roomId = roomId AND (NOT(CLEAN_ON_ENTER) OR message.time >= user.loggedOn)) Then
					If (StrComp(CStr(message.receiverId), "-1", 1) = 0) Then
						' messages displayed for all users
						getMessages = getMessages & message.text
					ElseIf (StrComp(CStr(message.receiverId), CStr(userId), 1) = 0) Then
						' private messages to this user only
						getMessages = getMessages & message.text
					End If
				End If
			End If
		Next
		
	End Function ' // > Function getMessages(...)
	
	
	Function getPrivateMessages(roomId, srcUserId, dstUserId, topToBottomOrder)
	
		Dim a, b, c, i, message
		
		If (topToBottomOrder) Then
			a = conquerChatMessages.Count-1
			b = 0
			c = -1
		Else
			a = 0
			b = conquerChatMessages.Count-1
			c = 1
		End If
		
		For i = a To b Step c
			Set message = getMessage(i)
			If (message.roomId = roomId) Then
				If ((message.userId = srcUserId AND message.receiverId = dstUserId) OR (message.userId = dstUserId AND message.receiverId = srcUserId)) Then
'				If (StrComp(CStr(message.receiverId), CStr(dstUserId), 1) = 0) Then
					' private messages to this user only
					getPrivateMessages = getPrivateMessages & message.text
					
				End If
			End If
			
			Set message = Nothing
		Next
	
	End Function
	
	
	'
	' Initializes available rooms by reading 'DEFAULT_ROOMS' property from 
	' configuration file and creating them in global scope.
	'
	Function setupRooms()
		
		' create default rooms if no is available (which will be the case the
		' very first time after a server restart)
		Application.Lock
		Dim defaultRooms
		defaultRooms = Split(DEFAULT_ROOMS, ";")
		If (IsArray(defaultRooms)) Then
			Dim i
			For i = 0 To UBound(defaultRooms)
				defaultRooms(i) = Trim(defaultRooms(i))
				If (defaultRooms(i) <> "") Then
					Call addRoom(defaultRooms(i), "-1")
				End If
			Next
		End If
		Application.UnLock
		
	End Function ' // > Function setupRooms()
	
	
	
	'
	' We do not want to have inactive users in our chat. In order to avoid
	' this, we enumerate all users last chat line and check the timestamp
	' on it. If it is older than the allowed inactivity limit, the user
	' is kicked from the chatroom
	'
	Function kickInactiveUsers()
		
		Dim i, now_
		now_ = Now()
		
		Application.Lock
		
		Dim userId, user
		For Each userId In conquerChatUsers
			Set user = getUser(userId)
			If (NOT user Is Nothing) Then
'				If (user.lastAction = "") Then
'					' somehow the lastAction is able to get zero or empty. I
'					' do not know why, but we take care of it by pinging the
'					' user (setting the lastAction) and .. well -- we're ex-
'					' tending his life a bit.
'					user.action()
'					Call updateUser(user)
'				End If
				
				If (DateDiff("s", CDate(user.lastAction), now_) > TIMEOUT) Then
					' this user needs to be logged out - he fell asleep in class..hmm
					Call addMessage( _
						userId, _
						"-1", _
						"<span class='LoggedOut'><img src='images/bp.gif' height=9 width=9> " & _
						getMsg( _
							"user.timed_out", _
							user.name, _
							FormatDateTime(Now(), vbShortTime) _
						) & _
						"</span><br />" _
					)
					Call removeUser(userId)
				End If
			End If
		Next
		
		Application.UnLock
		
	End Function ' // > Function kickInactiveUsers()
	
	
	'
	' Incase sensitive search for if this username is available 
	' in the list of "blocked" usernames.
	'
	Function isUserNameBlocked(userName)
		
		' remove any whitespaces from start and end of line
		userName = Trim(userName)
		
		Dim blocked, block
		blocked = Split(BLOCKED_USERNAMES, ",")
		For Each block In blocked
			If (StrComp(Trim(block), userName, 1) = 0) Then
				isUserNameBlocked = True
				Exit Function
			End If
		Next
		
		isUserNameBlocked = False
		
	End Function ' // > Function isUserNameBlocked(...)
	
	
	Function isValidUserName(userName)
		
		isValidUserName = (InStr(userName, Chr(1)) = 0) AND (InStr(userName, ",") = 0) AND (InStr(userName, "|") = 0)
		
	End Function ' // > Function isValidUserName(userName)
	
	
	
	
	
	
	
	'
	' Formats message by HTML encoding most tags and replacing typed 
	' smileys with images if selected.
	'
	Function formatMessage(msg)
		
		If (Len(msg) > 0) Then
			
			' replace tags with real data
			msg = Replace(msg, "<datetime>", Now, 1, -1, 1)
			msg = Replace(msg, "<date>", Date, 1, -1, 1)
			msg = Replace(msg, "<time>", Time, 1, -1, 1)
			
			' we do not support most tags, however <b>, <i> and <u> ARE supported, 
			' thus we have to make check for these and replace with actual tags
			msg = Server.HTMLEncode(msg)
			msg = Replace(msg, "&lt;b&gt;", "<b>", 1, -1, 1)
			msg = Replace(msg, "&lt;/b&gt;", "</b>", 1, -1, 1)
			msg = Replace(msg, "&lt;i&gt;", "<i>", 1, -1, 1)
			msg = Replace(msg, "&lt;/i&gt;", "</i>", 1, -1, 1)
			msg = Replace(msg, "&lt;u&gt;", "<u>", 1, -1, 1)
			msg = Replace(msg, "&lt;/u&gt;", "</u>", 1, -1, 1)
			msg = Replace(msg, "&lt;span style='color: black'&gt;", "<span style='color: black'>", 1, -1, 1)
			msg = Replace(msg, "&lt;span style='color: red'&gt;", "<span style='color: red'>", 1, -1, 1)
			msg = Replace(msg, "&lt;span style='color: green'&gt;", "<span style='color: green'>", 1, -1, 1)
			msg = Replace(msg, "&lt;span style='color: blue'&gt;", "<span style='color: blue'>", 1, -1, 1)
			msg = Replace(msg, "&lt;/span&gt;", "</span>", 1, -1, 1)
			
			' if wanted we replace smilies with images
			If (USE_IMAGE_SMILEY) Then
				msg = replaceSmilies(msg)
			End If
			
			' filter out bad words according to filter setup
			If (Len(BAD_WORDS_FILTER) > 0) Then
				msg = replaceBadWords(msg, BAD_WORDS_FILTER)
			End If
			
		End If
		
		formatMessage = msg
		
	End Function
	
	
	
	'
	' -------------------------------------------------------------------------
	' GUI RELATED FUNCTIONS
	' -------------------------------------------------------------------------
	'
	'
	
	'
	' Depending on the state of this user we might display different icons
	' if user has been idle for a period of time we display an "away" icon
	' or if the user has just logged on he will have a "new" icon
	'
	Function getUserIcon(user)
		
'		If (DateDiff("s", user.loggedOn, Now) < 25) Then
'			getUserIcon = "ico.user.new.gif"
'		ElseIf (DateDiff("s", user.lastAction, Now) > 100) Then
'			getUserIcon = "ico.user.idle.gif"
'		Else
			getUserIcon = "ico.user.gif"
'		End If
		
	End Function
	
	
	'
	' Replaces most commonly used smilies with small images indicating the
	' text-smiley in a more fancy way ;-)
	'
	Function replaceSmilies(s)
		
		If (Len(s) = 0) Then
			replaceSmilies = ""
			Exit Function
		End If
		
		' see also "images/smilies/moods" for additional smilies
		s = Replace(s, "xx(", "<img src='images/smilies/dead.gif' alt='xx(' align='absmiddle'>")
		s = Replace(s, ":-)", "<img src='images/smilies/smile.gif' alt=':-)' align='absmiddle'>")
		s = Replace(s, ":o)", "<img src='images/smilies/clown.gif' alt=':o)' align='absmiddle'>")
		s = Replace(s, ":-(", "<img src='images/smilies/frown.gif' alt=':-(' align='absmiddle'>")
		s = Replace(s, ":o(", "<img src='images/smilies/frown.gif' alt=':o(' align='absmiddle'>")
		s = Replace(s, ";-)", "<img src='images/smilies/wink.gif' alt=';-)' align='absmiddle'>")
		s = Replace(s, ";o)", "<img src='images/smilies/wink.gif' alt=';o)' align='absmiddle'>")
		s = Replace(s, ":-[", "<img src='images/smilies/angry.gif' alt=':-[' align='absmiddle'>")
		s = Replace(s, ":o[", "<img src='images/smilies/angry.gif' alt=':o[' align='absmiddle'>")
		s = Replace(s, ":-]", "<img src='images/smilies/devil.gif' alt=':-]' align='absmiddle'>")
		s = Replace(s, ":o]", "<img src='images/smilies/devil.gif' alt=':o]' align='absmiddle'>")
		s = Replace(s, ":)",  "<img src='images/smilies/smile.gif' alt=':)' align='absmiddle'>")
		s = Replace(s, ":(",  "<img src='images/smilies/frown.gif' alt=':(' align='absmiddle'>")
		s = Replace(s, ";)",  "<img src='images/smilies/wink.gif' alt=';)' align='absmiddle'>")
		s = Replace(s, ":]",  "<img src='images/smilies/devil.gif' alt=':]' align='absmiddle'>")
		s = Replace(s, ":[",  "<img src='images/smilies/angry.gif' alt=':[' align='absmiddle'>")
		s = Replace(s, ":D",  "<img src='images/smilies/biggrin.gif' alt=':D' align='absmiddle'>")
		s = Replace(s, ":O",  "<img src='images/smilies/oh.gif' alt=':O' align='absmiddle'>")
		s = Replace(s, ":P",  "<img src='images/smilies/tongue.gif' alt=':P' align='absmiddle'>")
		
		replaceSmilies = s
		
	End Function
	
	
	'
	' Formats standard message sent to room.
	'
	Function formatMessageUI(user, message)
		
		formatMessageUI = _
			"<div class=message>" & _
			getMsg( _
				"user.say_all", _
				"<span class=username>" & user.name & "</span>", _
				"<span class=message>" & message & "</span>" _
			) & _
			"</div>"
		
	End Function
	
	
	'
	' Formats a private message.
	'
	Function formatPrivateMessageUI(fromUser, toUser, message)
		
		formatPrivateMessageUI = _
			"<div class=privateMessage>" & _
			getMsg( _
				"user.say_private", _
				"<span class=username>" & user.name & "</span>", _
				"<span class=username>" & toUser.name & "</span>", _
				"<span class=privateMessage>" & message & "</span>" _
			) & _
			"</div>"
		
	End Function
	
	
	
	
	
	
	'
	' Encodes message for preparation in a JavaScript function call.
	'
	'
	Function jsEncode(msgs) 
		
		jsEncode = msgs
		jsEncode = Replace(jsEncode, "\", "\\")
		jsEncode = Replace(jsEncode, "'", "\'")
		jsEncode = Replace(jsEncode, """", "\""")
		jsEncode = Replace(jsEncode, vbCrLf, "\n")
		jsEncode = Replace(jsEncode, vbLf, "\r")
		jsEncode = Replace(jsEncode, vbTab, "\t")
		
	End Function
	
	Function jsBool(b)
		
		If (b) Then
			jsBool = "true"
		Else
			jsBool = "false"
		End If
		
	End Function
	
	Function padBadWordWithAsterisks(s)
		If (Len(s) < 3) Then
			padBadWordWithAsterisks = s
			Exit Function
		End If
		
		padBadWordWithAsterisks = Left(s, 1) & String(Len(Mid(s, 2, Len(s)-2)), "*") & Right(s, 1)
		
	End Function
	
	
	'
	' Replace bad words from a string with first and last character in word 
	' being replaced.
	'
	Function replaceBadWords(s, badWordsFilter)
		
		Dim badWords, badWord
		badWords = Split(badWordsFilter, ",")
		For Each badWord In badWords
			badWord = Trim(badWord)
			
			Dim regEx
			Set regEx = New RegExp
			regEx.Pattern = badWord
			regEx.IgnoreCase = True
			regEx.Global = True
			s = regEx.Replace(s, padBadWordWithAsterisks(badWord))
			
		Next
		
		replaceBadWords = s
		
	End Function	
	
%>