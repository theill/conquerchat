<%
	
	' 
	' ---------------------------------- A P P L I C A T I O N   S E T T I N G S
	'
	
	'
	' The password needed to be entered when accessing the administrator
	' module of ConquerChat. This password MUST be changed before using the
	' chat since other users are able to download the source for this and
	' guess the password.
	' 
	' Default Value: "changeme"
	'
	Const ADMINISTRATOR_PASSWORD = "changeme"
	
	'
	' OBSOLETED OPTION - this will be removed in future versions. Refer to
	' "messages/messages.en" for configuration of this
	' 
	Const APPLICATION_NAME = "ConquerChat On·Line"
	
	'
	' OBSOLETED OPTION - this will be removed in future versions. Refer to
	' "messages/messages.en" for configuration of this
	'
	Const WEBMASTER_EMAIL = "webmaster@mydomain.com"
	
	'
	' Defines used language for all messages shown. Change this value to
	' a language of your chat and create a new message file in the 'messages'
	' directory called: "messages.<language code>", i.e. if you want to
	' create one for danish use "messages.da" and change the setting below
	' to "da".
	' 
	' Default Value: "en"
	'
	Const MESSAGE_LANGUAGE = "en"
	
	'
	' The maximum number of shown messages on the screen. You may want to 
	' limit this number in order to have all messages written on one page
	' without the user having to scroll his/hers chat window. The value is
	' on a 'per room' basis.
	'
	' Default Value: 25
	'
	Const MESSAGES = 25
	
	' 
	' This specifies the number of users allowed to log into this chat. If
	' you have a large site you may want to increase this number to allow
	' more users.
	'
	' Default Value: 30
	' 
	Const USERS = 30
	
	'
	' No more than X rooms are allowed to be created for any chat. This value
	' will limit the number of rooms for the entire chat -- not just for one
	' user.
	'
	' Default Value: 10
	'
	Const NUMBER_OF_ROOMS = 10
	
	'
	' Indicates pattern of room names used when creating new rooms. If the 
	' name doesn't match up with the pattern an error is given to the user. If
	' you do not wish to limit the room-names you might set the pattern to an
	' empty string.
	' 
	' Default Value: [a-zA-Z0-9 ]
	'
	Const ROOMNAME_PATTERN = "[a-zA-Z0-9 ]"
	
	' 
	' Timeout in seconds - a session times out after 5 minutes (5*60=300) thus
	' if a logged in user hasn't entered anything in the window he will be
	' logged out in order to avoid taking up a space in the chat.
	' 
	' Default Value: 300
	' 
	Const TIMEOUT = 300
	
	'
	' Number of milliseconds a user needs to wait before sending a new 
	' message. This setting prevents "message flooding" so a user do not
	' sends the same message a great number of times. Set this number to 
	' zero (0) if you want to disable it.
	' 
	' Default Value: 500
	' 
	Const MESSAGE_FLOOD_TIMEOUT = 500
	
	' 
	' Specify is all messages should be wiped, when last user leaves the 
	' chatroom. This feature is also called the 'whiteboard cleaner'.
	' 
	' Default Value: False
	' 
	Const CLEAR_ON_EMPTY = False
	
	' 
	' Cleans active message log when a new user enter so that user cannot
	' see messages typed by users before he logged on. This feature is 
	' usually referred to as 'IRC Mode'.
	'
	' Default Value: True
	' 
	Const CLEAN_ON_ENTER = true
	
	' 
	' Clears message in textbox when it has been send off to the chat room.
	' If this setting is False, the message will stay in the textbox, but
	' will be highlighted to indicate you are able to just type in a new
	' message to override the existing one.
	' 
	' Default Value: True
	' 
	Const CLEAR_MESSAGE = True
	
	' 
	' If True, a typed smiley (e.g. :-) will be replaced by a small image
	' representation.
	' 
	' Default Value: True
	' 
	Const USE_IMAGE_SMILEY = True
	
	'
	' List of default rooms available for all users. Rooms are separated
	' using a simicolon (;) and first room is _always_ the default room,
	' i.e. where all new users are placed. When changing the rooms you need
	' to reinitialize the chat which can be done from the admin page (point
	' your browser to 'admin.asp'.
	'
	' Default Value: "Entrance;Music;Sport"
	'
	Const DEFAULT_ROOMS = "Entrance;Music;Sport"
	
	'
	' Indicates if all chat messages should print from top-to-bottom or from
	' bottom-to-top. If this flag is set to True new messages will be
	' printed in the top of the chat area otherwise a new message appear
	' in the bottom.
	'
	' Default Value: True
	'
	Const NEWEST_MESSAGE_IN_TOP = False
	
	'
	' This value indicates the maximum length of a username. If a user enters
	' a username larger than this value, he will be prompted to enter another
	' name.
	' 
	' Default Value: 20
	'
	Const MAX_USERNAME_LENGTH = 20
	
	'
	' Refresh rates for updating windows with messages, users and rooms. All
	' rates are defined in seconds. Do not set these values too low since it
	' may influence on the performance of your chat application.
	' 
	' Default Value: 5
	'
	Const MESSAGES_REFRESH_RATE = 5
	
	' Default Value: 15
	Const USERS_REFRESH_RATE = 15
	
	' Default Value: 15
	Const ROOMS_REFRESH_RATE = 15
	
	'
	' Filters out words from this list by replacing characters between first
	' and last character with asterisks.
	' 
	' Default Value: "fuck, shit, cunt, bitch, asshole, prick, dick"
	'
	Const BAD_WORDS_FILTER = "fuck, shit, cunt, bitch, asshole, prick, dick"
	
	'
	' Disallow certain usernames so a chatuser is unable to log on to the 
	' chat if this username is entered. 
	' 
	' Default Value: "admin, administrator, conquerchat"
	' 
	Const BLOCKED_USERNAMES = "admin, administrator, conquerchat"
	
	'
	' Specifies location of logfile to store messages send to the chat. All
	' messages will be in the format:
	'
	'  [<timestamp>] [<roomname>] [<source username> => <dest. username>] "<message>"
	' 
	' When specifying a filename for your logfile make sure you have WRITE 
	' access in that directory and that you're using a relative path name, i.e.
	' something like "../_private/conquerchat.log".
	' 
	' Default Value: ""
	'
	Const MESSAGES_LOGFILE = ""
	
	'
	' Not currently in use - development setting
	'
'	Const DATABASE = "Driver={Microsoft Access Driver (*.mdb)};DBQ=/conquerchat/database/conquerchat.mdb"
	Const DATABASE = "DRIVER={Microsoft Access Driver (*.mdb)};DBQ=d:\www2\theill\database\conquerchat.mdb"
	
	'
	' Internal constant used for debugging this chat application. You should 
	' not need to enable it unless you are customizing ConquerChat and want
	' to have a better detail level of used ids, etc.
	'
	' Default Value: False
	'
	Const DEBUG__ = False
	
	
	' Internal constants used within ConquerChat -- warning: please do not 
	' modify these values unless you know what you are doing!
	Const USER_UNAVAILABLE = "-1"
	Const NOT_SELECTED = "-1"
	Const PAGE_EXPIRED = "expired.asp"
	Const LOGGED_OUT_PAGE = "default.asp"
	Const SESSIONKEY_USER = "user"
	
%>