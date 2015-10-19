Meteor.methods
	'Blog.findAll': (query, tags, limit) ->
		data =
			document: 'BlogPost'
			limit: parseInt limit
			sort: [
				code: -1
			]

		tagsConditions = []
		if tags.indexOf('None') isnt -1
			tagsConditions.push
				term: 'tags'
				operator: 'exists'
				value: false

		delete tags['None']
		if tags.length
			tagsConditions.push
				term: 'tags'
				operator: 'in'
				value: tags


		data.filter =
			filters: [
				match: 'or'
				conditions: tagsConditions
			]

		if s.trim query
			data.filter.conditions = [
				term: 'title'
				operator: 'contains'
				value: s.trim query
			]

		results = Konecty.findAll data
		if results.success is true
			return results
		else
			throw new Meteor.Error 'konecty-error', results?.errors?[0]?.message

	'Blog.findOne': (slug) ->
		data =
			document: 'BlogPost'
			filter:
				conditions: [
					term: 'slug'
					operator: 'equals'
					value: s.trim slug
				]
			limit: 1

		results = Konecty.findOne data
		if results.success is true
			return results?.data?[0]
		else
			throw new Meteor.Error 'konecty-error', results?.errors?[0]?.message

	'Blog.findDistinct': (field) ->
		data =
			document: 'BlogPost'
			field: field

		return Konecty.findDistinct data
