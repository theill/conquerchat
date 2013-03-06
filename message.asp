<% Option Explicit %>
<!-- #include file="inc.common.asp" -->
<%
	
	' 
	' $Id: message.asp,v 1.1.1.1 2003/03/09 22:45:57 peter Exp $
	' 
	' Allows a user to send a new message to the chatroom.
	' 
	' @author	Peter Theill
	' 
	
	Response.Buffer = True
	
	If (NOT loggedOn()) Then
		Response.Write(getLoggedOutScript(True))
		Response.End
	End If
	
	Dim user
	Set user = getLoggedOnUser()
	
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<html>
<head>
	<title><%= getMsg("application.name") %></title>
	<link rel="stylesheet" type="text/css" href="css/chat.css">
	<script language="JavaScript1.2" type="text/javascript" src="js/update.js"></script>
	<script language="JavaScript1.2" type="text/javascript">
	<!--
		
		// using styles for messages being sent
		var boldStyle = false, italicStyle = false, underlineStyle = false;
		
		var justSent = false;
		
		function init() {
			setMessageFocus();
		}
		
		function setMessageFocus() {
			if (typeof document.frmControl != 'undefined' && typeof document.frmControl.message != 'undefined') {
				document.frmControl.message.focus();
			}
		}
		
		function sendMessage() {
			
			var frm = document.frmControl;
			
			// collect required information
			var toUserId = frm.users.options[frm.users.selectedIndex].value;
			var message = frm.message.value;
			var color = frm.colors.value;
			
			// show help window if user requests this
			if (message == '/help' || message == '/?') {
				openHelp();
				return;
			}
			
			// force refresh if user is sending an empty message
			if (message == '') {
				executeRequest('action=refresh');
				return;
			}
			
			// apply styles if appropriate
			if (boldStyle) {
				message = "<b>" + message + "</b>";
			}
			
			if (italicStyle) {
				message = "<i>" + message + "</i>";
			}
			
			if (underlineStyle) {
				message = "<u>" + message + "</u>";
			}
			
			if (color != '') {
				// colorize entire text
				message = "<span style='color: " + color + "'>" + message + "</span>";
			}
			
			// add new message to site
			executeRequest('action=refresh,mode=message,message=' + escape(message) + ',toUserId=' + toUserId);
			
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
			
			// return focus to message area in case the 'enter' key moved it to a
			// frameset or submit button. resolves an issue on some browsers.
			setMessageFocus();
			
		} // > function sendMessage()
		
		
		/**
		 * Logs out of chat.
		 * 
		 */
		function logOff() {
			executeRequest('action=logoff');
		}
		
		
		/**
		 * Opens op a new dialog for showing help.
		 * 
		 */
		function openHelp() {
			var mConquerChatHelp = window.open(
				'help.asp',
				mConquerChatHelp,
				'toolbar=no,width=380,height=380,resizable=0'
			);
			
			mConquerChatHelp.focus();
			
		} // > function openHelp()
		
		
		/**
		 * Clears all text in message box.
		 *	
		 */
		function clearMessageArea() {
			
			if (typeof document.frmControl != 'undefined' && typeof document.frmControl.message != 'undefined') {
				document.frmControl.message.value = '';
				return true;
			}
			
			return false;
		}
		
		
		function insertSmiley(s) {
			
			if (typeof document.frmControl != 'undefined' && typeof document.frmControl.message != 'undefined') {
				document.frmControl.message.value += s;
			}
			
			setMessageFocus();
		}
		
		
		function toggleStyle(image, styleName) {
			
			var pressed = false;
			switch (styleName) {
				case "bold":
					pressed = boldStyle = !boldStyle;
					break;
					
				case "italic":
					pressed = italicStyle = !italicStyle;
					break;
					
				case "underline":
					pressed = underlineStyle = !underlineStyle;
					break;
			}
			
			image.src = "images/ico." + styleName + (pressed ? ".down" : "") + ".gif"
			
		} // > function toggleStyle(...)
		
		
		/**
		 * Callback function executed when the number of users have changed and 
		 * thus require this client to refresh the "Users" view.
		 * 
		 */
		function onUsersChanged(data) {
			// data is setup like "1|Peter,2|Bill,3|Steve"
			
			if (typeof document.frmControl.users == 'undefined') {
				// delay initialization a second to ensure fully load of page
//				setTimeout("onUsersChanged('" + data + "')", 1000);
//				return;
			}
			
			// setup required data
			var slb = document.frmControl.users;
			var selectedUserId = slb.options[slb.selectedIndex].value;
			
			// build selection box
			for (var i = 0; i < slb.options.length; i++) {
				slb.options[i] = null;
			}
			
			slb.options[0] = new Option('<%= jsEncode(getMsg("users.all")) %>', '-1');
			
			if (typeof data != 'undefined' && data.length > 0) {
				var users = data.split(',');
				for (var i = 0, idx = 1; i < users.length; i++) {
					var user = users[i].split('|');
					if (user[0] != '<%= user.id %>') {
						slb.options[idx] = new Option(user[1], user[0]);
						if (user[0] == selectedUserId) {
							slb.options[idx].selected = true;
						}
						
						idx++;
					}
				}
			}
			
		} // > function onUsersChanged(..)
		
		/**
		 * This user has logged off.
		 *
		 */
		function onLoggedOff() {
			alert('<%= getMsg("logout.no_longer_on") %>');
			parent.location.replace('<%= LOGGED_OUT_PAGE %>');
		}
		
	// -->
	</script>
</head>

<body onload="init()" class=message>
<div class=hdr>
	<%= getMsg("message.title") %>
</div>

<table border="0" cellspacing="8" cellpadding="0">
<form name="frmControl" method="post" action="#" onsubmit="sendMessage(); return false;">
<tr>
	<td width="100%"><input type="text" class="editField" name="message" style="width: 100%;" size="40" taborder="1"></td>
	<td nowrap="nowrap">
		<input type="submit" class="btn" value="<%= getMsg("button.send") %>" taborder="2" name="submit" border="0" title="<%= getMsg("button.send.title") %>" />
		<input type="button" class="btn" value="<%= getMsg("button.help") %>" onclick="openHelp(); return false;" border="0" title="<%= getMsg("button.help.title") %>" />
		<input type="button" class="btn" value="<%= getMsg("button.logout") %>" onclick="logOff(); return false;" border="0" title="<%= getMsg("button.logout.title") %>" />
	</td>
</tr>
<tr>
	<td>
		<table border=0 cellspacing=0 cellpadding=0>
		<tr>
			<td>
				<select name="users">
					<option value="-1"><%= getMsg("users.initializing") %></option>
				</select>
			</td>
			<td>&nbsp;</td>
			<td>
				<select name="colors">
					<option value=""><%= getMsg("colors.none") %></option>
					<option value="black" style="color: black"><%= getMsg("colors.black") %></option>
					<option value="red" style="color: red"><%= getMsg("colors.red") %></option>
					<option value="green" style="color: green"><%= getMsg("colors.green") %></option>
					<option value="blue" style="color: blue"><%= getMsg("colors.blue") %></option>
				</select>
			</td>
			<td>&nbsp;</td>
			<td>
				<img src="images/ico.bold.gif" width=16 height=16 border=0 class=lnk onClick="toggleStyle(this, 'bold')">
				<img src="images/ico.italic.gif" width=16 height=16 border=0 class=lnk onClick="toggleStyle(this, 'italic')">
				<img src="images/ico.underline.gif" width=16 height=16 border=0 class=lnk onClick="toggleStyle(this, 'underline')">
			</td>
			<td>&nbsp;</td>
			<td>
				<img src="images/smilies/dead.gif" width=16 height=16 border=0 class=lnk onClick="insertSmiley('xx(')">
				<img src="images/smilies/clown.gif" width=16 height=16 border=0 class=lnk onClick="insertSmiley(':o)')">
				<img src="images/smilies/smile.gif" width=16 height=16 border=0 class=lnk onClick="insertSmiley(':-)')">
				<img src="images/smilies/devil.gif" width=16 height=16 border=0 class=lnk onClick="insertSmiley(':-]')">
				<img src="images/smilies/biggrin.gif" width=16 height=16 border=0 class=lnk onClick="insertSmiley(':D')">
				<img src="images/smilies/frown.gif" width=16 height=16 border=0 class=lnk onClick="insertSmiley(':-(')">
				<img src="images/smilies/oh.gif" width=16 height=16 border=0 class=lnk onClick="insertSmiley(':O')">
				<img src="images/smilies/wink.gif" width=16 height=16 border=0 class=lnk onClick="insertSmiley(';-)')">
				<img src="images/smilies/tongue.gif" width=16 height=16 border=0 class=lnk onClick="insertSmiley(':P')">
			</td>
		</tr>
		</table>
	</td>
	<td></td>
</tr>

<!-- what action are being performed -->
<input type="hidden" name="mode" value="message">

<!-- who are going to receive this message -->
<input type="hidden" name="scope" value="-1">

</form>
</table>

</body>
</html>