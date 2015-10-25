Meteor.methods
	'Blog.findDistinctTags': ->
		tags = []

		BlogPost.find().forEach (blogPost) ->
			if _.isArray blogPost.tags
				_.each blogPost.tags, (tag) -> tags.push tag

		return _.uniq _.compact tags
