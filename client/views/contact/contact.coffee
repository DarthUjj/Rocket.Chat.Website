Template.contact.events
	'submit form': (e, t) ->
		e.preventDefault()

		name = $(t.find('input[name=name]')).val()
		email = $(t.find('input[name=email]')).val()
		message = $(t.find('textarea[name=message]')).val()

		Meteor.call 'Contact.saveLead', name, email, message, (err, results) ->
			console.log arguments