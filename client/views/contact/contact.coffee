Template.contact.events
	'submit form': (e, t) ->
		e.preventDefault()

		name = $(t.find('input[name=name]')).val()
		email = $(t.find('input[name=email]')).val()
		message = $(t.find('textarea[name=message]')).val()

		Meteor.call 'Contact.saveLead', name, email, message, (err, results) ->
			return toastr.error err.reason if err
			toastr.success 'You have sent us a message. Please wait while we process it. Thank you.'
			t.clearForm()

Template.contact.onCreated ->
	@clearForm = =>
		$(@findAll('input')).val('')
		$(@findAll('textarea')).val('')

	@validate = =>
		name = $(@find('input[name=name]')).val()
		email = $(@find('input[name=email]')).val()

		emailPattern = /^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/

		unless name.length
			toastr.warning 'Please write your name so we know who we\'re speaking with.'
			return false

		unless emailPattern.test email
			toastr.error 'The e-mail is invalid.'
			return false

		unless message.length
			toastr.warning 'You should try writing a message first.'
			return false

		return true
