<% Option Explicit %>
<!-- #include file="inc.common.asp" -->
<%
	
	' 
	' $Id: users.asp,v 1.1.1.1 2003/03/09 22:45:57 peter Exp $
	' 
	' Shows a list of all active chat users in the current users room. The 
	' current user will be bolded in the list in order to separate him from
	' other users and all other users will have a link for opening their
	' profile, e.g. if you want to send a private mssage to him/her.
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
<html>
<head>
	<title><%= getMsg("application.name") %></title>
	<link rel="stylesheet" type="text/css" href="css/chat.css">
	
	<script language="JavaScript1.2" type="text/javascript" src="js/update.js"></script>
	<script language="JavaScript1.2">
	<!--
		
		/**
		 * Setup time to refresh page in intervals.
		 * 
		 * @param 	userId 	Id of this user.
		 * @param 	roomId 	Id of room user is located in.
		 * 
		 */
		function init(roomId) {
			
			refreshFunction = 'executeRequest(\'action=update.users,roomId=' + roomId + '\')';
			eval(refreshFunction);
			
			setInterval(refreshFunction, <%= (USERS_REFRESH_RATE * 1000) %>);
			
		} // > function init(...)
		
		
		function openPrivateChat(srcUserId, dstUserId) {
			
			mConquerChatPrivateChat = window.open(
				'private.dialog.asp?srcUserId=' + srcUserId + '&dstUserId=' + dstUserId,
				"ConquerChatPrivateChat" + dstUserId,
				'toolbar=no,width=320,height=240,resizable=1'
			);
			
			mConquerChatPrivateChat.focus();
			
		} // > function openPrivateChat(dstUserId)
		
		
		/**
		 *	Open window showing the users profile.
		 *	
		 *	@param	userId		Id of user for which we need to see the profile.
		 *	@param	fromUserId	Id of current user.
		 *	
		 */
		function openUserProfile(userId, fromUserId) {
			
			mConquerChatUserProfile = window.open(
				'profile.asp?userId=' + userId + '&fromUserId=' + fromUserId,
				"ConquerChatUserProfile" + userId,
				'toolbar=no,width=320,height=320,resizable=0'
			);
			
			mConquerChatUserProfile.focus();
			
		} // > function openUserProfile(...)
		
	// -->
	</script>
</head>

<body class="users" onload="init('<%= user.roomId %>')">
<div class="hdr">
	<%= getMsg("users.title") %>
</div>

<div id="data" name="data"></div>

</body>
</html>