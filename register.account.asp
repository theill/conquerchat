<%
	
	' 
	' $Id: $
	' 
	' Registers new account.
	' 
	' @author	Peter Theill
	' 
	
	Option Explicit
	
%>
<!-- #include file="inc.common.asp" -->
<%
	
	
	
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN"
	"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<title><%= getMsg("application.name") %></title>
	<link rel="stylesheet" type="text/css" href="css/chat.css" />
</head>

<body class="frontpage">

<table border="0" cellspacing="0" cellpadding="0" style="position: absolute; top: 90px" width="100%" id="frm">
<tr>
	<td class="hdr"><%= gettext("Register account") %></td>
</tr>
<tr>
	<td style="background-color: #b3d68e; border-top: 1px dashed #ffffff; border-bottom: 1px dashed #ffffff" align=center>

<table border="0" cellspacing="0" cellpadding="4" width="100%" id="table1">
	<form method="POST" action="#">
		<tr>
			<td class="txt"><%= gettext("Username:") %></td>
			<td><input type="text" name="username" size="20"></td>
		</tr>
		<tr>
			<td class="txt"><%= gettext("Password:") %></td>
			<td><input type="password" name="password" size="20"></td>
		</tr>
		<tr>
			<td class="txt"><%= gettext("Avatar:") %></td>
			<td><select size="1" name="avatar"></select></td>
		</tr>
		<tr>
			<td class="txt"><%= gettext("First name:") %></td>
			<td><input type="text" name="firstname" size="20"></td>
		</tr>
		<tr>
			<td class="txt"><%= gettext("Surname:") %></td>
			<td><input type="text" name="surname" size="20"></td>
		</tr>
		<tr>
			<td class="txt"><%= gettext("Email:") %></td>
			<td><input type="text" name="email" size="20"></td>
		</tr>
		<tr>
			<td class="txt"><%= gettext("ICQ:") %></td>
			<td><input type="text" name="icq" size="20"></td>
		</tr>
		<tr>
			<td class="txt"><%= gettext("MSN:") %></td>
			<td><input type="text" name="msn" size="20"></td>
		</tr>
		<tr>
			<td class="txt"><%= gettext("Yahoo!:") %></td>
			<td><input type="text" name="yahoo" size="20"></td>
		</tr>
		<tr>
			<td class="txt"><%= gettext("Website:") %></td>
			<td><input type="text" name="website" size="20"></td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td><input type="submit" value="Create" name="create" class="btn"></td>
		</tr>
	</form>
</table>

	</td>
</tr>
</table>


</body>
</html>