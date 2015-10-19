Template.blog.helpers
	posts: ->
		return Template.instance().posts?.get()
	hasMore: ->
		return Template.instance().total?.get() > Template.instance().posts?.get()?.length
	blogFilters: ->
		return Blog.filters
	checked: (value) ->
		tags = Session.get('blogTags')
		return tags.indexOf(value) isnt -1
	categories: ->
		return Template.instance().tags?.get()

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

	'change .categories input[type=checkbox]': (e, t) ->
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
	tpl.total = new ReactiveVar
	tpl.tags = new ReactiveVar []

	Session.setDefault('blogLimit', 6)
	Session.setDefault('blogSearch', '')
	Session.setDefault('blogTags', [])

	Meteor.call 'Blog.findDistinct', 'tags', (err, results) ->
		results.unshift('None')

		tpl.tags.set results
		Session.set 'blogTags', results

	@autorun ->
		query = Session.get('blogSearch')
		limit = Session.get('blogLimit')
		tags = Session.get('blogTags')

		Meteor.call 'Blog.findAll', query, tags, Session.get('blogLimit'), (err, results) ->
			return toastr.error err.reason if err
			tpl.posts.set results?.data
			tpl.total.set results?.total

			Tracker.afterFlush ->
				if Session.get('currentBlogPostPos')
					$(window).scrollTop(parseInt(Session.get('currentBlogPostPos')))
				else if Session.get('currentBlogPost') and $("[data-id=#{Session.get('currentBlogPost')}]").length
					$(window).scrollTop($("[data-id=#{Session.get('currentBlogPost')}]").offset().top - ($(window).height()/2) + 50)
