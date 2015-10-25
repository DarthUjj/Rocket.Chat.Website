Meteor.methods
	'Contact.saveLead': (name, email, message) ->

		emailPattern = /^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/

		unless emailPattern.test email
			throw new Meteor.Error 'email-invalid', 'The e-mail is invalid.'

		unless name.length
			throw new Meteor.Error 'name-invalid', 'The name is invalid.'

		unless message.length
			throw new Meteor.Error 'message-invalid', 'The message is invalid.'

		contact =
			status: 'Lead'
			name: s.trim(s.titleize name)
			email: email

		req = { data: [
			name: 'contact'
			data: contact
		,
			name: 'message'
			data:
				type: 'Email'
				status: 'Enviando'
				subject: 'Web Contact'
				from: 'alerts@konecty.com'
				to: 'support@rocket.chat'
				body: "Name: #{contact.name}<br />E-mail: #{contact.email}<br />Message: #{message}"
			map:
				contact: 'contact'
		] }

		results = Konecty.processSubmit req
		return results
