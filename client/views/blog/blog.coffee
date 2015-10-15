@blogFilters = [
	{
		name: 'Categories'
		icon: 'map-marker'
		rel: 'categories'
		categories: [
			"Features"
			"Mentions"
		]
	}
]

Template.blog.helpers
	posts: ->
		return Template.instance().posts.get()
	hasMore: ->
		return true
	blogFilters: ->
		return blogFilters
	checked: (rel, value) ->
		return true
	selected: (rel, value) ->
		return "selected"

Template.blog.events
	'click .load-more button': (e) ->
		e.preventDefault()
		BlogSubscription.set('limit', BlogSubscription.get('limit') + Blog.settings.pageSize)

	'mousedown a.unit': (e) ->
		id = $(e.currentTarget).data('id')
		Session.set 'currentBlogPost', id
		Session.set 'currentBlogPostPos', $(window).scrollTop()

Template.blog.onCreated ->
	tpl = @
	tpl.posts = new ReactiveVar

	Meteor.call 'Konecty.findAll', 'BlogPost', (err, results) ->
		tpl.posts.set results

	# tpl = @
	# @autorun ->
	# 	query = Session.get('blogSearchText')
	# 	limit = Session.get('blogSearchLimit')
	# 	subscription = tpl.subscribe 'blog-posts', { query: query, limit: limit }

Template.blog.onRendered ->
	PageLoader.clear()

	if Session.get('currentBlogPostPos')
		$(window).scrollTop(parseInt(Session.get('currentBlogPostPos')))
	else if Session.get('currentBlogPost') and $("[data-id=#{Session.get('currentBlogPost')}]").length
		$(window).scrollTop($("[data-id=#{Session.get('currentBlogPost')}]").offset().top - ($(window).height()/2) + 50)
