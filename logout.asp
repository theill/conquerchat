<% Option Explicit %>
<!-- #include file="inc.common.asp" -->
<%
	
	' 
	' $Id: logout.asp,v 1.1.1.1 2003/03/09 22:45:57 peter Exp $
	' 
	' 
	' @author	Peter Theill
	' 
	
%>
<html>

<head>
	<title><%= getMsg("application.name") %></title>
	<link rel="stylesheet" type="text/css" href="css/chat.css">
	<script language="JavaScript1.2" type="text/javascript" src="js/update.js"></script>
	<script language="JavaScript1.2" type="text/javascript">
	<!--
		
		function init() {
			executeRequest('action=logoff');
			setTimeout('window.close()', 1000);
			if (opener.closed == false) {
				opener.location.replace('<%= LOGGED_OUT_PAGE %>');
			}
		}
		
	// -->
	</script>
</head>

<body onload="init()">

<p><%= getMsg("you_have_been_logged_out") %></p>

</body>

</html>