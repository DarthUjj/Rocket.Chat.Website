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
	tpl = @
	tpl.clearForm = ->
		$(tpl.find('input[name=name]')).val('')
		$(tpl.find('input[name=email]')).val('')
		$(tpl.find('textarea[name=message]')).val('')