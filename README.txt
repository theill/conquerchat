
 ConquerChat README
 Copyright (c) 2000-2004 Peter Theill, theill.com
 
 -----------------------------------------------------------------------------
 Introduction
 -----------------------------------------------------------------------------
This archive contains my ASP chat application. Most other chat-applications works using "Cookies" but not this one. This allows you to run this chat without requiring to set a cookie on the client-machine; something some users will appreciate.
 
By using all files in this archive, you are actually able to set up and customise your own chatroom on your ASP enabled web site.
 
In order to make the chat work properly, you will have to add a couple of lines in your "global.asa" file. The lines below are also included in the downloadable package. You should insert them in the top of your file, i.e. not in any of the default defined Sub functions.

	<OBJECT RUNAT=Server
		SCOPE=Application
		ID=conquerChatUsers
		PROGID="Scripting.Dictionary">
	</OBJECT>

	<OBJECT RUNAT=Server
		SCOPE=Application
		ID=conquerChatRooms
		PROGID="Scripting.Dictionary">
	</OBJECT>

	<OBJECT RUNAT=Server
		SCOPE=Application
		ID=conquerChatMessages
		PROGID="Scripting.Dictionary">
	</OBJECT>

The lines above makes it possible to store currently logged in chat users, rooms and messages. We check this object every time we refresh the chat window page and kick out inactive users. If you do not have a 'global.asa' file use the one provided with this package. You have to place it in the root of your web server and not in the "chat" directory or where you place all the other files. You *have* to place this in the ROOT of your web server .. and *NOT* in the "chat" directory.
 
If this still does not work for you please refer to the Frequently Asked Questions available online at:

    http://www.theill.com/asp/conquerchat/faq.asp
 
 
 -----------------------------------------------------------------------------
 Customize ConquerChat
 -----------------------------------------------------------------------------
 It is possible to customize ConquerChat in many ways. Many options are 
 available for you by simply enabling or disabling a flag from within the con-
 figuration file. The configuration file is named "inc.config.asp" and every
 option is described in details.
 
 If you need me to make a customized version of ConquerChat for you, please
 contact me for details about pricing. See contact information at the contact
 page: http://www.theill.com/contact.asp
 
 
 -----------------------------------------------------------------------------
 How do I get support?
 -----------------------------------------------------------------------------
 If you have troubles setting up the chat you might want to take a look at the
 FAQ pages. There are available from:
 
  http://www.theill.com/asp/conquerchat/faq.asp
 
 Try my forum as well. It contains many posts from other ConquerChat users 
 and is a great resource if you need to see how to do a specific thing to your
 installation. The forum is available at:
 
   http://www.theill.com/forum.asp
 
 You may buy support for ConquerChat as well. It's possible if you need to 
 know how you could add an advanced administration interface, how to connect a
 database to the user logon, etc. Send me an email if you're interested in
 this and I'll get back with specific prices according to the job you need to
 have done.

 -----------------------------------------------------------------------------
 Copyright
 -----------------------------------------------------------------------------
 You are able to modify the  source-code any way you like. All  advertisements
 and/or banners shown in the downloaded chat may be removed before using it on
 your own site. ConquerChat  is 100% freeware and  enables you to get  a quick
 start setting up your own chat without any restrictions.
 
 
 -----------------------------------------------------------------------------
 Version History
 -----------------------------------------------------------------------------
 Refer to 'history.txt'
 
 Best regards,
  Peter Theill - http://www.theill.com
 -----------------------------------------------------------------------------