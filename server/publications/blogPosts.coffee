Meteor.publish 'blogPosts', (text, tags, limit) ->
	options = {}
	options.limit = parseInt(limit) or 6
	options.sort = { code: -1 }

	query = { $or: [] }

	if tags?.indexOf('None') isnt -1
		query['$or'].push { tags: { $exists: 0 } }
		delete tags[tags.indexOf('None')]

	tags = _.compact tags

	unless _.isEmpty tags
		query['$or'].push { tags: { $in: tags } }

	if _.isEmpty query['$or']
		delete query['$or']

	if s.trim text
		query['title'] = { $regex: new RegExp(s.trim(text), 'i') }

	query['status'] = 'Active'

	console.log '[publish] blog-posts', text, tags, limit

	return BlogPost.find(query, options)

Meteor.publish 'blogPost', (slug) ->
	unless slug
		return @ready()

	return BlogPost.find({ slug: slug }, { limit: 1 })
