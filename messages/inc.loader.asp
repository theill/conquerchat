<%
	
	' 
	' $Id: inc.loader.asp,v 1.1.1.1 2003/03/09 22:45:58 peter Exp $
	' 
	' Loads all messages used in chat -- this function should be OPTIMIZED!
	' 
	' @author	Peter Theill
	' 
	
	Dim all_messages
	Set all_messages = CreateObject("Scripting.Dictionary")
	
	readMessages()
	
	Sub readMessages()
		Dim messageFile
		messageFile = Server.MapPath("messages/messages." & MESSAGE_LANGUAGE)
		
		Dim fs
		Set fs = CreateObject("Scripting.FileSystemObject")
		If (fs.FileExists(messageFile)) Then
			
			Dim a
			Set a = fs.OpenTextFile(messageFile)
			
			Dim line, msg
			Do While Not (a.AtEndOfStream)
				line = Trim(a.ReadLine)
				If (Len(line) > 0 AND Left(line, 1) <> "#" AND Left(line, 1) <> "'") Then
					' get messages by spliting where the = is located; notice the second 
					' parameter which is used to split the line in two parts only and 
					' thus allowing users to type = in the localized message
					msg = Split(line, "=", 2)
					If (UBound(msg) = 1) Then
						all_messages.Add Trim(msg(0)), Trim(msg(1))
					End If
				End If
			Loop
		End If
		
	End Sub
	
%><!-- #include file="inc.utility.asp" -->