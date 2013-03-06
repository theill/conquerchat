<%
	
	' 
	' $Id: inc.classes.asp,v 1.1.1.1 2003/03/09 22:45:57 peter Exp $
	' 
	' All classes used in ConquerChat to store user information, rooms and 
	' messages.
	' 
	' @author	Peter Theill
	' 
	
%>
<script language="vbscript" type="text/vbscript" runat="server">
	
	Class DbManager
		Private connection_
		
		Private Sub Class_Initialize()
			If (NOT IsObject(connection_)) Then
				Set connection_ = Server.CreateObject("ADODB.Connection")
				connection_.Open(DATABASE)
			End If
		End Sub
		
		Private Sub Class_Terminate()
			If (IsObject(connection_)) Then
				connection_.Close
				Set connection_ = Nothing
			End If
		End Sub
		
		Public Function GetRooms()
			Dim sql: sql = _
				"SELECT		id, name, account_id " & _
				"FROM		room " & _
				"ORDER BY	name "
			
			Dim rows, rs
			Set rs = connection_.Execute(sql)
			If (NOT rs.EOF) Then
				GetRooms = rs.GetRows()
			Else
				Set GetRooms = Nothing
			End If
			
			rs.Close
			Set rs = Nothing
		End Function
	End Class
	
	
	Class DbRoom
		Public Function FindById(id)
			Dim sql: sql = _
				"SELECT		id, name, account_id " & _
				"FROM		room " & _
				"WHERE 		id = " & id & " "
			
			Dim a, rows, rs
			Set rs = connection_.Execute(sql)
			If (NOT rs.EOF) Then
				row = rs.GetRows()
				Set a = New Room
				a.Load(row)
				FindById = a
			Else
				Set FindById = Nothing
			End If
			
			rs.Close
			Set rs = Nothing
		End Function
	End Class
	
	
	Class Person
		
		Private id_
		Private name_
		Private roomId_
		Private lastAction_
		
		Private loggedOn_
		Private ipAddress_
		Private sendMessages_
		
		Private Sub Class_Initialize()
			id_ = -1
			name_ = "Guest"
			roomId_ = -1
			action()
			loggedOn_ = Now()
			ipAddress = ""
			sendMessages_ = 0
		End Sub
		
		Public Property Get id
			id = id_
		End Property
		
		Public Property Get name
			name = name_
		End Property
		
		Public Property Get roomId
			roomId = roomId_
		End Property
		
		Public Property Get lastAction
			lastAction = lastAction_
		End Property
		
		Public Property Get loggedOn
			loggedOn = loggedOn_
		End Property
		
		Public Property Get ipAddress
			ipAddress = ipAddress_
		End Property
		
		Public Property Get sendMessages
			sendMessages = sendMessages_
		End Property
		
		
		Public Property Let id(v)
			id_ = v
		End Property
		
		Public Property Let name(v)
			name_ = v
		End Property
		
		Public Property Let roomId(v)
			roomId_ = v
		End Property
		
		Public Sub action()
			lastAction_ = CStr(Now())
		End Sub
		
		Private Property Let loggedOn(v)
			loggedOn_ = v
		End Property
		
		Public Property Let ipAddress(v)
			ipAddress_ = v
		End Property
		
		Public Property Let sendMessages(v)
			sendMessages_ = v
		End Property
		
		Public Property Get data
			data = id_ & Chr(1) & name_ & Chr(1) & roomId_ & Chr(1) & lastAction_ & Chr(1) & loggedOn_ & Chr(1) & ipAddress_ & Chr(1) & sendMessages_
		End Property
		
		Public Property Let data(v)
			Dim dataArray
			dataArray = Split(v, Chr(1))
			If (IsArray(dataArray) AND (UBound(dataArray) >= 6)) Then
				id_ = dataArray(0)
				name_ = dataArray(1)
				roomId_ = dataArray(2)
				lastAction_ = dataArray(3)
				loggedOn_ = dataArray(4)
				ipAddress_ = dataArray(5)
				sendMessages_ = dataArray(6)
			End If
		End Property
		
		Private Sub debug()
			Response.Write "<table><tr><td colspan=4><b>User</b></td></tr><tr><td>" & id_ & "</td><td>" & name_ & "</td><td>" & roomId_ & "</td><td>" & lastAction_ & "</td></tr></table>"
		End Sub
		
	End Class ' // > Class Person
	
	
	Class Room
		
		Private id_
		Private name_		
		Private createdBy_
		
		Private Sub Class_Initialize()
			id_ = -1
			name_ = "Guest"
			createdBy_ = -1
		End Sub
		
		
		Public Property Get id
			id = id_
		End Property
		
		Public Property Get name
			name = name_
		End Property
		
		Public Property Get createdBy
			createdBy = createdBy_
		End Property
		
		
		Public Property Let id(v)
			id_ = v
		End Property
		
		Public Property Let name(v)
			name_ = v
		End Property
		
		Public Property Let createdBy(v)
			createdBy_ = v
		End Property
		
		
		Public Property Get data
			data = id_ & Chr(1) & name_ & Chr(1) & createdBy_
		End Property
		
		Public Property Let data(v)
			Dim dataArray
			dataArray = Split(v, Chr(1))
			If (IsArray(dataArray) AND (UBound(dataArray) >= 2)) Then
				id_ = dataArray(0)
				name_ = dataArray(1)
				createdBy_ = dataArray(2)
			End If
		End Property
		
		Public Sub Load(rows, rowNo)
			id_ = rows(0, rowNo)
			name_ = rows(1, rowNo)
			createdBy_ = rows(2, rowNo)
		End Sub
		
		Private Sub debug()
			Response.Write "<table><tr><td colspan=3><b>Room</b></td></tr><tr><td>" & id_ & "</td><td>" & name_ & "</td><td>" & createdBy_ & "</td></tr></table>"
		End Sub
		
	End Class ' // > Class Room
	
	
	Class Message
		
		Private roomId_				' room where message appears
		Private position_			' line number for message (starting from 0)
		Private userId_				' user sending message
		Private receiverId_		' user receiving message (-1 for all)
		Private text_					' message
		Private time_ 				' date and time (Now()) when the msg is sent
		
		Public Property Get roomId
			roomId = roomId_
		End Property
		
		Public Property Get position
			position = position_
		End Property
		
		Public Property Get userId
			userId = userId_
		End Property
		
		Public Property Get receiverId
			receiverId = receiverId_
		End Property
		
		Public Property Get text
			text = text_
		End Property
		
		Public Property Get time
			time = time_
		End property
		
		
		Public Property Let roomId(v)
			roomId_ = v
		End Property
		
		Public Property Let position(v)
			position_ = v
		End Property
		
		Public Property Let userId(v)
			userId_ = v
		End Property
		
		Public Property Let receiverId(v)
			receiverId_ = v
		End Property
		
		Public Property Let text(v)
			text_ = v
		End Property
		
		Public Property Let time(v)
			time_ = v
		End Property
		
		
		Public Property Get data
			data = roomId_ & Chr(1) & position & Chr(1) & userId_ & Chr(1) & receiverId_ & Chr(1) & text_ & Chr(1) & time_
		End Property
		
		Public Property Let data(v)
			Dim dataArray
			dataArray = Split(v, Chr(1))
			If (IsArray(dataArray) AND (UBound(dataArray) >= 5)) Then
				roomId_ = dataArray(0)
				position_ = dataArray(1)
				userId_ = dataArray(2)
				receiverId_ = dataArray(3)
				text_ = dataArray(4)
				time_ = dataArray(5)
			End If
		End Property
		
		Public Sub debug()
			Response.Write("<table><tr><td colspan=5><b>Message</b></td></tr><tr><td>" & roomId_ & "</td><td>" & position_ & "</td><td>" & userId_ & "</td><td>" & receiverId_ & "</td><td>" & text_ & "</td><td>" & time_ & "</td></tr></table>")
		End Sub
		
	End Class ' // > Class Message
	
</script>