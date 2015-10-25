@Konecty = new class
	constructor: ->
		@connection = DDP.connect process.env.KONECTY_URL

	processSubmit: (data) ->
		data = _.extend data,
			authTokenId: process.env.KONECTY_AUTH_TOKEN_ID

		results = @connection.call 'process:submit', data
		if results.success is true
			return results
		else
			throw new Meteor.Error 'konecty-error', results?.errors?[0]?.message
