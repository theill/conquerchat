<%
	
	' 
	' $Id: expired.asp,v 1.1.1.1 2003/03/09 22:45:57 peter Exp $
	' 
	' 
	' @author	Peter Theill
	' 
	
	Option Explicit
	
%>
<!-- #include file="inc.common.asp" -->
<html>

<head>
	<title><%= getMsg("application.name") %></title>
	<link rel="stylesheet" type="text/css" href="css/chat.css">
	<script type="text/javascript">
		
		function init() {
			if (typeof parent != 'undefined' && typeof parent.message != 'undefined' && typeof parent.message.logOff != 'undefined') {
				// execute logoff method defined in the message frame
				parent.message.logOff();
			}
		}
		
	</script>
</head>

<body onLoad="init()">

<p><%= getMsg("logout.no_longer_on") %></p>

</body>

</html>