Meteor.methods
	'Deploy.newInstance': (name, email, domain) ->

		emailPattern = /^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/
		urlPattern = /^[a-z0-9]+(-?[a-z0-9]+)*$/

		unless emailPattern.test email
			throw new Meteor.Error 'email-invalid', 'The e-mail is invalid.'

		unless domain.length > 2
			throw new Meteor.Error 'domain-invalid', 'The domain is invalid. Please use at least 3 characters.'

		unless urlPattern.test domain
			throw new Meteor.Error 'domain-invalid', 'The domain is invalid. Please use only lowercase letters, numbers, dots and dashes.'

		domain = 'http://' + domain + '.rocket.chat'

		instance =
			name: s.trim(s.titleize name)
			email: { address: email }
			domain: s.trim domain.toLowerCase()

		req = { data: [
			name: 'instance'
			document: 'Instance'
			data: instance
		] }

		results = Konecty.processSubmit req
		return true

# Limit setting username once per minute
DDPRateLimiter.addRule
	type: 'method'
	name: 'Deploy.newInstance'
	connectionId: -> return true
, 1, 60000
