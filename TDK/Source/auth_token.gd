func getAuthToken():
	var args = OS.get_cmdline_args()
	for arg in args:
		if arg.begins_with("--tdk-auth-token"):
			var split_arg = arg.split("=")
			if split_arg.size() == 2:
				var value = split_arg[1]
				return value
	
	return null
