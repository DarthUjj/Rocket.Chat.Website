@Konecty = new class
	constructor: ->
		@connection = DDP.connect process.env.KONECTY_URL

	findAll: (collection, filter = {}, limit = 25, skip = 0) ->
		data =
			authTokenId: process.env.KONECTY_AUTH_TOKEN_ID
			document: collection
			filter: filter
			limit: limit
			start: skip

		results = @connection.call 'data:find:all', data
		if results.success is true
			return results?.data or []
		else
			throw new Meteor.Error 'konecty-error', results?.errors?[0]?.message

	findOneByCode: (collection, code) ->
		data =
			authTokenId: process.env.KONECTY_AUTH_TOKEN_ID
			document: collection
			filter:
				conditions: [
					term: 'code'
					operator: 'equals'
					value: code
				]
			limit: 1

		results = @connection.call 'data:find:all', data
		if results.success is true
			return results?.data?[0] or {}
		else
			throw new Meteor.Error 'konecty-error', results?.errors?[0]?.message

Meteor.methods
	'Konecty.findAll': (collection, filter = {}, limit = 25, skip = 0) ->
		return Konecty.findAll(collection, filter, limit, skip)

	'Konecty.findOneByCode': (collection, _id) ->
		return Konecty.findOneByCode(collection, _id)
