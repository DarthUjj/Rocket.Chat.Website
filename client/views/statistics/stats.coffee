Template.stats.onRendered ->

	Meteor.call 'getStatistics', (err, results) ->
		dataset = _.map results.totalInstances, (item, i) -> return { x: item._id, y: item.count }

		nv.addGraph ->
			chart = nv.models.lineChart().options
				transitionDuration: 300
				useInteractiveGuideline: true

			chart.xAxis.axisLabel("Date").tickFormat (d) ->
				return moment().dayOfYear(d).format('DD/MM')

			chart.yAxis.axisLabel('Instances').tickFormat (d) ->
				unless d
					return 'N/A'

				return parseInt(d)

			d3.select('#chart1').append('svg').datum([{ key: 'Instances', values: dataset }]).call(chart)
			nv.utils.windowResize(chart.update)
			return chart

		PageLoader.clear()
