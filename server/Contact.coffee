Meteor.methods
	'Contact.saveLead': (name, email, message) ->
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
		console.log results
		return results