<% Option Explicit %>
<!-- #include file="inc.common.asp" -->
<%
	
	' 
	' $Id: private.message.asp,v 1.1.1.1 2003/03/09 22:45:57 peter Exp $
	' 
	' Sends new message to chat room.
	' 
	' @author	Peter Theill
	' 
	
	Dim userId, dstUserId
	userId = CStr(Request("srcUserId"))
	dstUserId = CStr(Request("dstUserId"))
	
	If (NOT isLoggedIn(userId)) Then
		Response.Write(getLoggedOutScript(True))
		Response.End
	End If
	
%>
<html>

<head>
	<title><%= getMsg("application.name") %></title>
	<link rel="stylesheet" type="text/css" href="css/chat.css">
	<script language="JavaScript1.2" type="text/javascript" src="js/update.js"></script>
	<script language="JavaScript1.2">
	<!--
		
		var justSent = false;
		
		/**
		 *	Clears all text in message box.
		 *	
		 */
		function clearMessageArea() {
			if (typeof document.frmControl != 'undefined' && document.frmControl.message != 'undefined') {
				document.frmControl.message.value = '';
				return true;
			}
			
			return false;
		}
		
		function setMessageFocus(frm) {
			if (typeof frm != 'undefined' && typeof frm.message != 'undefined') {
				frm.message.focus();
			}
		}
		
		function sendMessage() {
			
			// collect required information
			var message = document.frmControl.message.value;
			
			// refresh view if user is sending an empty message
			if (message == '') {
				executeRequest('action=refresh,userId=<%= userId %>');
				return;
			}
			
			// add new message to site
			executeRequest('action=private.refresh,mode=message,message=' + escape(message) + ',userId=<%= userId %>,toUserId=<%= dstUserId %>');
			
			<% If (MESSAGE_FLOOD_TIMEOUT > 0) Then %>
				
				if (justSent) {
					alert('<%= getMsg("typing_too_fast") %>');
					return false;
				}
				
				// avoid users spamming by sending a lot of messages all the time
				justSent = true;
				setTimeout('justSent = false;', <%= MESSAGE_FLOOD_TIMEOUT %>);
				
			<% End If %>
			
			<% If (CLEAR_MESSAGE) Then %>
				
				clearMessageArea();
				
			<% End If %>
			
		} // > function sendMessage()
		
	// -->
	</script>
</head>

<body style="margin: 0px">

<table border=0 cellpadding=4>
<form name="frmControl" onSubmit="sendMessage(); setMessageFocus(this); return false;">
<tr>
   	<td width="100%"><input type=text class="editField" name="message" style="width: 100%;" size="40" taborder="1"></td>
   	<td nowrap><input type="submit" class="btn" value="<%= getMsg("button.send") %>" taborder="2" name="submit" border="0" title="<%= getMsg("button.send.title") %>"></td>
</tr>
</form>
</table>

</body>

</html>