Meteor.startup ->
	Instance.find().observe
		added: (record) ->
			console.log "[Instance Observer] New Instance added", record.domain
