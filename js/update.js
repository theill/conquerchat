<!--
	
	/**
	 * Remote scripting for ConquerChat
	 * 
	 * @author Peter Theill
	 */
	 
	var SERVER_CONTROLLER = "control.asp";
	
	/**
	 * Executes a server request by patching the header request in the
	 * current document. The parameters specified will be attached to
	 * the request.
	 *
	 */
	function executeRequest(params) {
		
		var head = document.getElementsByTagName('head').item(0);
		var old  = document.getElementById('lastLoadedCmds');
		if (old) head.removeChild(old);
		
		script = document.createElement('script');
		
		parameters = new String(params).split(',');
		
		var scriptUrl = SERVER_CONTROLLER + '?rnd=' + Math.random();
		for (var i = 0; i < parameters.length; i++) {
			scriptUrl += "&" + parameters[i];
		}
		
		script.src = scriptUrl;
		script.type = 'text/javascript';
		script.defer = true;
		script.id = 'lastLoadedCmds';
		
		void(head.appendChild(script));
		
	} // > function executeRequest(...)
	
	
	/**
	 * Dynamically updates the content of a frame.
	 * 
	 */
	function update(frame, id, html) {
		
		var doc = eval(frame + '.document');
		
		if (doc.layers) {
			var l = doc[id];
			l.document.open();
			l.document.write(html);
			l.document.close();
		} else if (doc.all && doc.all[id]) {
			doc.all[id].innerHTML = html;
		} else if (doc.createRange) {
			var l = doc.getElementById(id);
			var r = doc.createRange();
			while (l.hasChildNodes()) {
				l.removeChild(l.lastChild);
			}
			r.setStartAfter(l);
			var docFrag = r.createContextualFragment(html);
			l.appendChild(docFrag);
		}
		
	} // > function update(...)
	
	
	function updateMessages(id, html) {
		update('parent.messages', id, html);
	}
	
	
	function updatePrivateMessages(id, html) {
		update('parent.messages', id, html);
	}
	
	
	function updateUsers(id, html) {
		update('parent.users', id, html);
		
		// workaround for browsers not understanding 'undefined'
		var undefined_;
		onUsersChanged(undefined_);
	}
	
	
	function updateRooms(id, html) {
		update('parent.rooms', id, html);
	}
	
	
	function onUsersChanged(data) {
		if (typeof data == 'undefined')
			return;
		
		if ((typeof parent.message != 'undefined') && (typeof parent.message.onUsersChanged != 'undefined'))
			parent.message.onUsersChanged(data);
	}
	
	function focusMessageArea() {
		if ((typeof parent.message != 'undefined') && (typeof parent.message.frmControl != 'undefined') && (typeof parent.message.frmControl.message != 'undefined')) {
			parent.message.focus();
			parent.message.frmControl.message.focus();
		}
	}
	
	function scrollToBottom(bottom) {
		
		var doc = parent.messages.document;
		var wnd = parent.messages;
		
		var y = doc.height ? doc.height : doc.body.scrollHeight;
		
//alert(doc.height + ",bottom="+bottom+",y="+y);
		
		wnd.scrollTo(
			0, 
			((bottom == 'true') ? y : 0)
		);
		
	} // > function scrollToBottom(...)
	
// -->