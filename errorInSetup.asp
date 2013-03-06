<%
	
	Option Explicit
	
	' 
	' $Id: errorInSetup.asp,v 1.1.1.1 2003/03/09 22:45:57 peter Exp $
	' 
	' 
	' 
	' @author	Peter Theill
	' 
	
%>
<html>
<head>
	<link rel="stylesheet" type="text/css" href="css/chat.css">
</head>

<body style="font-family: Verdana, Sans-serif; font-size: 13px;">
<p style="font-size: 18px; font-family: Trebuchet MS; color: red; ">
	<i><b>initialization failed</b></i></p>

<p>
	It seems like you are missing a small critical step. In order to make this 
    chat work you will have to open and modify your &quot;global.asa&quot; file. This file 
    contains information about global objects necessary for ConquerChat to run 
    properly.</p>

<%
	
	' does user have a "global.asa" file already?
	Dim globalAsaAvailable
	
	Dim fs, readme
	Dim filename: filename = Server.MapPath("/global.asa")
	
	Set fs = Server.CreateObject("Scripting.FileSystemObject")
	
	globalAsaAvailable = fs.FileExists(filename)
	
	If (globalAsaAvailable) Then
		' show currently available global.asa file
'		Set readme = fs.OpenTextFile(filename)
'		Response.Write("<pre style='font-family: Lucida Console; font-size: 7pt;'>")
'		Do While (NOT readme.AtEndOfStream)
'			Response.Write(Server.HTMLEncode(readme.readLine) & "<br />")
'		Loop
'		Response.Write("</pre>")
'		readme.Close
	Else
		' user does not have a global.asa file
'		Set readme = fs.GetFile(Server.MapPath("global.asa"))
'		readme.Copy(filename)
	End If
	
	Set fs = Nothing
	
%>

<p>
<% If (globalAsaAvailable) Then %>
	It seems like your system already have a "global.asa" file in the root of
	your web server. You should open this file with your favourite text-editor 
	and paste in these lines exactly as show below. Paste the lines into the 
	beginning or end of your files to avoid problems.<br />
	<br />
	
<pre style="padding: 8px; background-color: #eeeeee; border: 1px solid #333333">&lt;OBJECT RUNAT=Server
	SCOPE=Application
	ID=conquerChatUsers
	PROGID=&quot;Scripting.Dictionary&quot;&gt;
&lt;/OBJECT&gt;

&lt;OBJECT RUNAT=Server
	SCOPE=Application
	ID=conquerChatRooms
	PROGID=&quot;Scripting.Dictionary&quot;&gt;
&lt;/OBJECT&gt;

&lt;OBJECT RUNAT=Server
	SCOPE=Application
	ID=conquerChatMessages
	PROGID=&quot;Scripting.Dictionary&quot;&gt;
&lt;/OBJECT&gt;
</pre>

<% Else %>
	Your system does not have a "global.asa" file. Take the file from your
	"conquerchat" directory and copy it to the <b>root</b> of your web server.
	It's very important since IIS won't use the settings if it's not located
	in this folder.
<% End If %>
</p>

<div style="text-align: center; padding: 8px; background-color: #ffdddd; font-weight: bold; border: 1px solid #ff0000">
	<a href="default.asp">Please retry my configuration. I have made the suggested changes!</a>
</div>

<p>
	If you still cannot get the chat to run after having performed the steps 
    above, please take a look at the <a href="http://www.theill.com/asp/conquerchat/faq.asp"><b>ConquerChat FAQ</b></a> 
    or ask in the <a href="http://www.theill.com/snitzforum/default.asp?CAT_ID=7">ConquerChat Forum</a>.
</p>

<p>
	System-details:<br />
	<br />
	Scripting Type: <b><%= ScriptEngine %></b><br />
	Scripting Version: <b><%= ScriptEngineMajorVersion & "." & ScriptEngineMinorVersion & "." & ScriptEngineBuildVersion %></b><br />
	Browser: <b><%= Request.ServerVariables("HTTP_USER_AGENT") %></b><br />
</p>

</body>
</html>