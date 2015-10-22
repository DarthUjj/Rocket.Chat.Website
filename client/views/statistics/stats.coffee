Template.stats.onRendered ->
	svg = d3.select("#barChart")
	dataset = ClientStatistics.find().fetch()
	PageLoader.clear()