Meteor.startup ->
	Instance.find({ deployed: { $ne: true } }).observe
		added: (record) ->
			console.log "[Instance Observer] New Instance added", record.domain

			name = record.domain.replace(/http:\/\/(.*)\.rocket\.chat/, '$1')
			tutum.createInstance name

			Instance.update record._id, { $set: { deployed: true } }
