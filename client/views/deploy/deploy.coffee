Template.deploy.events
	'submit #deployForm': (e, t) ->
		e.preventDefault()

		name = $(t.find('input[name=name]')).val()
		email = $(t.find('input[name=email]')).val()
		domain = $(t.find('input[name=domain]')).val()

		if t.validate()
			Meteor.call 'Deploy.newInstance', name, email, domain, (err) ->
				toastr.clear()
				if err?.error is 'too-many-requests'
					time = parseInt(err.details.timeToReset / 1000)
					return toastr.warning "Too many requests. Please wait #{time} seconds before trying again."

				return toastr.error err.reason if err
				toastr.success 'You have successfully deployed your instance.'
				t.clearForm()

Template.deploy.onCreated ->
	PageLoader.clear()

	@clearForm = =>
		$(@findAll('input')).val('')
		$(@find('input[name=name]')).focus()

	@validate = =>
		name = $(@find('input[name=name]')).val()
		email = $(@find('input[name=email]')).val()
		domain = $(@find('input[name=domain]')).val()

		emailPattern = /^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/
		urlPattern = /^[a-z0-9]+([\-\.]{1}[a-z0-9]+)*$/

		unless emailPattern.test email
			toastr.error 'The e-mail is invalid.'
			return false

		unless domain.length > 2
			toastr.error 'The domain is invalid. Please use at least 3 characters.'
			return false

		unless urlPattern.test domain
			toastr.error 'The domain is invalid. Please use only lowercase letters, numbers, dots and dashes.'
			return false

		return true
