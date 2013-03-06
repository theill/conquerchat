<%

	' 
	' $Id: help.asp,v 1.1.1.1 2003/03/09 22:45:57 peter Exp $
	' 
	' Displays help window for showing user which options apply in the
	' chat window.
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
</head>

<body class="help">
<div class="hdr">
	<%= getMsg("help.title") %></div>

<table border=0 width=100% cellspacing=0 cellpadding=8 class=hlp>
<tr>
	<td class=hlp>
	
	<%= getMsg("help.commands") %><ul class="hlp">
		<li class="hlp"><%= getmsg("help.command.bold") %></li>
		<li class="hlp"><%= getmsg("help.command.italic") %></li>
		<li class="hlp"><%= getmsg("help.command.underline") %></li>
		<li class="hlp"><%= getmsg("help.command.date") %></li>
		<li class="hlp"><%= getmsg("help.command.time") %></li>
		<li class="hlp"><%= getmsg("help.command.datetime") %></li>
	</ul>
	
	<%= getMsg("help.symbols") %><ul class="hlp">
		<li class="hlp"><%= getMsg("help.symbols.log_in") %></li>
		<li class="hlp"><%= getMsg("help.symbols.log_out") %></li>
	</ul>
	
	<%= getMsg("help.hint") %><ul class="hlp">
		<li class="hlp"><%= getMsg("help.hint.refresh") %></li>
	</ul>
	
<% If (USE_IMAGE_SMILEY) Then %><%= getMsg("help.smilies") %><ul class=hlp>
		<li class="hlp"><a href="smilies.asp"><%= getMsg("help.smilies.link") %></a></li>
	</ul>
<% End If %></td>
</tr>
</table>

</body>
</html>