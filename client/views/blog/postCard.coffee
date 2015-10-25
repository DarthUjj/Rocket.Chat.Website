Template.postCard.helpers
	_createdAt: ->
		return moment(this._createdAt).format("DD/MM/YYYY")
	summary: ->
		# Find 1st non-empty paragraph
		matches = this.body.split /<\/div>|<\/p>|<\/blockquote>|<br><br>|\\n\\n|\\r\\n\\r\\n/m

		i = 0
		ret = ''
		while not ret and matches[i]
			# Strip tags and clean up whitespaces
			ret += matches[i++].replace(/(<([^>]+)>)/ig, ' ').replace(/(\s\.)/, '.').replace('&nbsp;', ' ').trim()
		ret
