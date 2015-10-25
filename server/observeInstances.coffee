Meteor.startup ->
	Instance.find({ deployed: { $ne: true } }).observe
		added: (record) ->
			Instance.update record._id, { $set: { deployed: true } }
			console.log "[Instance Observer] New Instance added", record.domain
