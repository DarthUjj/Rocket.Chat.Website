Meteor.methods
	getStatistics: ->
		statistics = {}
		monthAgo = moment().subtract(1, 'month').toDate()

		totalInstances = ClientStatistics.aggregate [
			{ $match: { createdAt: { $gt: monthAgo, $lt: new Date() } } }
			{ $project: { uniqueId: "$uniqueId", dayOfYear: { $dayOfYear: "$createdAt" } } }
			{ $group: { _id: { uniqueId: "$uniqueId", dayOfYear: "$dayOfYear" } } }
			{ $group: { _id: "$_id.dayOfYear", count: { $sum: 1 } } }
			{ $sort: { _id: 1 } }
		]

		return {
			totalInstances: totalInstances
		}
