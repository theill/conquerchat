<% Option Explicit %>
<!-- #include file="inc.common.asp" -->
<%
	
	' 
	' $Id: smilies.asp,v 1.1.1.1 2003/03/09 22:45:57 peter Exp $
	' 
	' 
	' 
	' @author	Peter Theill
	' 
	
	Response.Buffer = True
	
%>
<html>
<head>
	<title><%= getMsg("application.name") %></title>
	<link rel="stylesheet" type="text/css" href="css/chat.css">
</head>

<body class=help>
<div class=hdr>
	<a href="help.asp"><%= getMsg("help.title") %></a> &#00187; <%= getMsg("smilies.title") %>
</div>

<table border=0 width=100% cellspacing=0 cellpadding=8>
<tr>
	<td>
	
	<%= getMsg("smilies.description") %><br>
	<br>
		
<div align="center">
  <center>

<table border=0 cellspacing=0 cellpadding=6 width="50%">
<tr>
	<td nowrap class=smis>xx(</td>
	<td nowrap><img src="images/smilies/dead.gif" width=16 height=16 border=0></td>
	<td nowrap class=smi><%= getMsg("smilies.hung_over") %></td>
	<td nowrap width=32>&nbsp;</td>
	<td nowrap class=smis>:-[</td>
	<td nowrap><img src="images/smilies/angry.gif" width=16 height=16 border=0></td>
	<td nowrap class=smi><%= getMsg("smilies.angry") %></td>
</tr>

<tr>
	<td nowrap class=smis>:-)</td>
	<td nowrap><img src="images/smilies/smile.gif" width=16 height=16 border=0></td>
	<td nowrap class=smi><%= getMsg("smilies.smile") %></td>
	<td nowrap width=32>&nbsp;</td>
	<td nowrap class=smis>:-]</td>
	<td nowrap><img src="images/smilies/devil.gif" width=16 height=16 border=0></td>
	<td nowrap class=smi><%= getMsg("smilies.devil") %></td>
</tr>

<tr>
	<td nowrap class=smis>:o)</td>
	<td nowrap><img src="images/smilies/clown.gif" width=16 height=16 border=0></td>
	<td nowrap class=smi><%= getMsg("smilies.clown") %></td>
	<td nowrap width=32>&nbsp;</td>
	<td nowrap class=smis>:D</td>
	<td nowrap><img src="images/smilies/biggrin.gif" width=16 height=16 border=0></td>
	<td nowrap class=smi><%= getMsg("smilies.big_grin") %></td>
</tr>

<tr>
	<td nowrap class=smis>:-(</td>
	<td nowrap><img src="images/smilies/frown.gif" width=16 height=16 border=0></td>
	<td nowrap class=smi><%= getMsg("smilies.frown") %></td>
	<td nowrap width=32>&nbsp;</td>
	<td nowrap class=smis>:O</td>
	<td nowrap><img src="images/smilies/oh.gif" width=16 height=16 border=0></td>
	<td nowrap class=smi><%= getMsg("smilies.oh") %></td>
</tr>

<tr>
	<td nowrap class=smis>;-)</td>
	<td nowrap><img src="images/smilies/wink.gif" width=16 height=16 border=0></td>
	<td nowrap class=smi><%= getMsg("smilies.wink") %></td>
	<td nowrap width=32>&nbsp;</td>
	<td nowrap class=smis>:P</td>
	<td nowrap><img src="images/smilies/tongue.gif" width=16 height=16 border=0></td>
	<td nowrap class=smi><%= getMsg("smilies.tongue") %></td>
</tr>
</table>

  </center>
</div>
</td>
</table>

</body>
</html>