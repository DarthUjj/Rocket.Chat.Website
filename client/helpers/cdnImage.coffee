@cdnImage = (picture, width, height, method) ->
	unless picture?
		return ""
	else
		if Array.isArray(picture)
			picture = picture[0]

		if not width? or width instanceof Spacebars.kw
			width = 1024

		if not height? or height instanceof Spacebars.kw
			height = 740

		if not method? or method instanceof Spacebars.kw
			method = "crop"

		url = "//dlil52wgx3qln.cloudfront.net/rest/image/#{method}/#{width}/#{height}/rocketchat/" + picture.key + "?etag=#{picture.etag}"

		return url

UI.registerHelper 'cdnImage', (picture, width, height, method, watermark, callback) ->
	if not callback or callback instanceof Spacebars.kw
		callback = (url) ->
			return url

		return callback cdnImage picture, width, height, method, watermark
