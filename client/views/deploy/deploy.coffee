Template.deploy.events
	'keypress .editable': (e, t) ->
		if e.which is 13
			e.preventDefault()
			$('#deployForm').submit()

	'submit #deployForm': (e, t) ->
		e.preventDefault()
		toastr.clear()

		section = Session.get('deploy-section') or 'email'
		switch section
			when 'email'
				email = t.$('input[name=email]')
				emailValue = email.val().trim()

				emailPattern = /^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/
				if not emailPattern.test emailValue
					toastr.error 'The e-mail is invalid.'
					email.select()
					return

				value = Session.get('deploy-value') or {}
				value.email = emailValue
				Session.set('deploy-value', value)

				Session.set('deploy-section', 'name')
				Meteor.defer ->
					$('input[name=name]').select()

			when 'name'
				name = t.$('input[name=name]')
				nameValue = name.val().trim()

				if nameValue is ''
					toastr.error 'Name should not be empty.'
					name.select()
					return

				value = Session.get('deploy-value')
				value.name = nameValue
				value.domain = nameValue.toLowerCase().replace(/\s+/g, '-').replace(/[^0-9a-z-]/g, '')
				Session.set('deploy-value', value)

				Session.set('deploy-section', 'domain')
				Meteor.defer ->
					$('.editable').focus()
					$('.editable').focus()

			when 'domain'
				domain = t.$('.editable')
				domainValue = domain[0].innerText.trim().toLowerCase()

				if domainValue.length < 3
					toastr.error 'The domain is invalid. Please use at least 3 characters.'
					$('.editable').focus()
					$('.editable').focus()
					return

				urlPattern = /^[a-z0-9]+(-?[a-z0-9]+)*$/
				if not urlPattern.test domainValue
					toastr.error 'Domain should contain only letters, numbers and dashes.'
					$('.editable').focus()
					$('.editable').focus()
					return

				value = Session.get('deploy-value')
				value.domain = domainValue
				Session.set('deploy-value', value)

				Meteor.call 'Deploy.newInstance', value.name, value.email, value.domain, (err) ->
					toastr.clear()
					if err?.error is 'too-many-requests'
						time = parseInt(err.details.timeToReset / 1000)
						return toastr.warning "Too many requests. Please wait #{time} seconds before trying again."

					return toastr.error err.reason if err
					Session.set('deploy-section', 'deployed')


	'click .button-back': ->
		toastr.clear()
		switch Session.get('deploy-section')
			when 'domain'
				Session.set('deploy-section', 'name')
				Meteor.defer ->
					$('input[name=name]').select()
			when 'name'
				Session.set('deploy-section', 'email')
				Meteor.defer ->
					$('input[name=email]').select()


Template.deploy.onCreated ->
	PageLoader.clear()


Template.deploy.helpers
	section: ->
		return Session.get('deploy-section') or 'email'

	value: ->
		return Session.get('deploy-value') or {}
