@Konecty = new class
	constructor: ->
		@connection = DDP.connect process.env.KONECTY_URL

	findAll: (data) ->
		data = _.extend data,
			authTokenId: process.env.KONECTY_AUTH_TOKEN_ID
			getTotal: true

		results = @connection.call 'data:find:all', data
		if results.success is true
			return results
		else
			throw new Meteor.Error 'konecty-error', results?.errors?[0]?.message

	findOne: (data) ->
		data = _.extend data,
			authTokenId: process.env.KONECTY_AUTH_TOKEN_ID
			limit: 1

		results = @connection.call 'data:find:all', data
		if results.success is true
			return results
		else
			throw new Meteor.Error 'konecty-error', results?.errors?[0]?.message

	findDistinct: (data) ->
		data = _.extend data,
			authTokenId: process.env.KONECTY_AUTH_TOKEN_ID

		results = @connection.call 'data:find:distinct', data
		console.log results
		if results.success is true
			return results?.data
		else
			throw new Meteor.Error 'konecty-error', results?.errors?[0]?.message
