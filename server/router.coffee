Router.route '/stats', ->
	statistics = this.request.body
	unless statistics?.uniqueId
		return this.response.end(JSON.stringify { success: false })

	console.log "Received Client Statistics: #{statistics?.uniqueId}"

	Meteor.defer ->
		statistics = _.pick statistics, [ "uniqueId", "version", "versionDate", "totalUsers", "activeUsers", "nonActiveUsers", "onlineUsers", "awayUsers", "offlineUsers", "totalRooms", "totalChannels", "totalPrivateGroups", "totalDirect", "totalMessages", "maxRoomUsers", "avgChannelUsers", "avgPrivateGroupUsers", "os", "createdAt" ]
		console.log statistics
	
		for strField in [ "uniqueId", "version", "versionDate" ]
			if statistics[strField]? and not _.isString statistics[strField]
				delete statistics[strField]

		for numField in [ "totalUsers", "activeUsers", "nonActiveUsers", "onlineUsers", "awayUsers", "offlineUsers", "totalRooms", "totalChannels", "totalPrivateGroups", "totalDirect", "totalMessages", "maxRoomUsers", "avgChannelUsers", "avgPrivateGroupUsers" ]
			if statistics[numField]? and not _.isNumber statistics[numField]
				delete statistics[numField]

		if statistics.os
			os = _.pick statistics.os, [ "type", "platform", "arch", "release", "uptime", "totalmem", "freemem", "loadavg", "cpus" ]
			for strField in [ "type", "platform", "arch", "release" ]
				if os[strField]? and not _.isString os[strField]
					delete os[strField]

			for numField in [ "uptime", "totalmem", "freemem" ]
				if os[numField]? and not _.isNumber os[numField]
					delete os[numField]

			if os.loadavg and _.isArray os.loadavg
				for key, value of os.loadavg
					if not _.isNumber value
						delete os.loadavg
						break
			else
				delete os.loadavg

			if os.cpus and _.isArray os.cpus
				for key, cpuObject of os.cpus
					if not _.isObject cpuObject
						delete os.cpus
						break

					if not _.isString cpuObject.model
						delete os.cpus[key]
						continue
					if not _.isNumber cpuObject.speed
						delete os.cpus[key]
						continue

					delete os.cpus[key].times
			else
				delete os.cpus

		if not _.isEmpty statistics
			ClientStatistics.insert statistics
		else
			return this.response.end(JSON.stringify { success: false })
	
	return this.response.end(JSON.stringify { success: true })

, { where: 'server' }