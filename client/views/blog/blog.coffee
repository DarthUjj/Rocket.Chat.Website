Template.blog.helpers
	posts: ->
		return Template.instance().posts?.get()
	hasMore: ->
		return Template.instance().hasMore.get()
	blogFilters: ->
		return Blog.filters
	checked: (value) ->
		tags = Session.get('blogTags')
		return tags.indexOf(value) isnt -1
	tags: ->
		return Template.instance().tags?.get()
	textSearch: ->
		return Session.get 'blogSearch'

Template.blog.events
	'click .load-more button': (e) ->
		e.preventDefault()
		Session.set('blogLimit', Session.get('blogLimit') + 6)

	'mousedown a.unit': (e) ->
		id = $(e.currentTarget).data('id')
		Session.set 'currentBlogPost', id
		Session.set 'currentBlogPostPos', $(window).scrollTop()

	'keyup input[name=search]': (e) ->
		Session.set 'blogSearch', s.trim($(e.currentTarget).val())

	'change .tags input[type=checkbox]': (e, t) ->
		tags = Session.get('blogTags')
		value = $(e.currentTarget).val()
		checked = $(e.currentTarget).prop('checked')
		if checked
			Session.set 'blogTags', _.union tags, [ value ]
		else
			Session.set 'blogTags', _.without tags, value

Template.blog.onCreated ->
	tpl = @
	tpl.posts = new ReactiveVar
	tpl.hasMore = new ReactiveVar
	tpl.tags = new ReactiveVar []

	Session.setDefault('blogLimit', 6)
	Session.setDefault('blogSearch', '')
	Session.setDefault('blogTags', [])

	Meteor.call 'Blog.findDistinctTags', (err, results) ->
		return toastr.error err.reason if err
		if _.isArray results
			results.unshift('None')
			tpl.tags.set results

	@autorun ->
		query = Session.get('blogSearch')
		limit = Session.get('blogLimit')
		tags = Session.get('blogTags')

		tpl.subscription = tpl.subscribe 'blogPosts', query, tags, Session.get('blogLimit'), (err) ->
			return toastr.error err.reason if err
			if tpl.subscription.ready()
				tpl.posts.set BlogPost.find()
				tpl.hasMore.set tpl.posts.get().count() is Session.get('blogLimit')

	@autorun ->
		Tracker.afterFlush ->
			if Session.get('currentBlogPostPos')
				$(window).scrollTop(parseInt(Session.get('currentBlogPostPos')))
			else if Session.get('currentBlogPost') and $("[data-id=#{Session.get('currentBlogPost')}]").length
				$(window).scrollTop($("[data-id=#{Session.get('currentBlogPost')}]").offset().top - ($(window).height()/2) + 50)
