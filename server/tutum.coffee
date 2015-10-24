@tutum = new class
	host = 'https://dashboard.tutum.co'
	apiKey = process.env.TUTUM_API_KEY

	mongoService = null
	redisService = null

	getRedis = ->
		result = run 'GET', '/api/v1/service/', { params: { name: 'redis' } }
		return result?.data?.objects?[0]?.public_dns

	getMongo = ->
		result = run 'GET', '/api/v1/service/', { params: { name: 'mongo' } }
		return result?.data?.objects?[0]?.resource_uri

	run = (type, url, options) ->
		optionsDefault =
			headers:
				'Authorization': "ApiKey #{apiKey}"
				'Accept': 'application/json'
				'Content-Type': 'application/json'

		options = _.extend optionsDefault, options

		return HTTP.call type, (host + url), options

	scale = (uuid) ->
		run 'POST', "/api/v1/service/#{uuid}/scale/", null

	createService = (name) ->
		return false unless mongoService? and redisService?

		data = { "image": "rocketchat/rocket.chat", "name": name, "target_num_containers": 1 }
		data.container_envvars = [
			{
				key: 'MONGO_URL'
				value: 'mongodb://mongo:27017/' + name
			}
			{
				key: 'TUTUM_REDIS_HOST'
				value: "redis://:ABC123@#{redisService}:6379"
			}
			{
				key: 'TUTUM_CLIENT_NAME'
				value: name
			}
			{
				key: 'TUTUM_CLIENT_HOST'
				value: name + ".rocket.chat"
			}
		]
		data.linked_to_service = [
			{
				"to_service": mongoService,
				"name": "mongo"
			}
		]
		data.tags = [
			{ name: 'free' }
			{ name: 'rocketchat' }
			# { name: 'rocketchat-002' }
		]
		run 'POST', "/api/v1/service/", { data: data }

	startService: (uuid) ->
		run 'POST', "/api/v1/service/#{uuid}/start/", null

	terminateService: (uuid) ->
		run 'DELETE', "/api/v1/service/#{uuid}/", null

	createInstance: (name) ->
		mongoService = getMongo()
		redisService = getRedis()

		service = createService name

		scale service.data.uuid

	run: run


