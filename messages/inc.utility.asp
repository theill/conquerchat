<script language="JScript" runat="Server">
	
	/**
	 * Need to use JScript for this since I want to have optional parameters
	 * in my 'getMsg' function call.
	 * 
	 */
	
	
	/**
	 * Returns message and replaces arguments with dynamic text if the function
	 * may be called with:
	 *
	 *   getMsg("I'm pretty sure {0} taste better than {1}.", "coke", "sprite")
	 *
	 * Which will result in a line saying:
	 * 
	 *   I'm pretty sure coke taste better than sprite.
	 * 
	 * @param 	name 	Name with text string and optional {} tags
	 * @param 	...		Optional arguments to replace tags
	 * @return 	String with replaced parameter
	 * 
	 */
	function getMsg(name) {
		
		if (!all_messages.Exists(name)) {
			return "[" + name + "]";
		}
		
		var message = all_messages.Item(name);
		for (var i = 0; i < arguments.length; i++) {
			message = message.replace("\{" + i + "\}", arguments[i+1]);
		}
		
		return message;
		
	} // > function getMsg(name)
	
	function gettext(name) {
	
		if (!all_messages.Exists(name)) {
			return name;
		}
		
		var message = all_messages.Item(name);
		for (var i = 0; i < arguments.length; i++) {
			message = message.replace("\{" + i + "\}", arguments[i+1]);
		}
		
		return message;
		
	}
	
</script>