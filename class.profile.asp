<%
	
	' 
	' $Id: inc.classes.asp,v 1.1.1.1 2003/03/09 22:45:57 peter Exp $
	' 
	' Maps "profile" database table.
	' 
	' Details about a "Profile" using the chat. It's possible for users to 
	' setup their own profile.
	' 
	' @author	Peter Theill
	' 
	
	Class Profile
		
		Private accountId_
		Private firstname_
		Private surname_
		Private email_
		Private icq_
		Private msn_
		Private yahoo_
		Private website_
		
		Private loggedOn_
		
		Private Sub Class_Initialize()
			loggedOn_ = Now()
		End Sub
		
		Public Property Get AccountId
			AccountId = accountId_
		End Property
		
		
		
		Public Property Get loggedOn
			loggedOn = loggedOn_
		End Property
		
		
		
		Public Property Let AccountId(v)
			accountId_ = v
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
		
	End Class
	
%>