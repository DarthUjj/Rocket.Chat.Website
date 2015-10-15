Router.configure
	layoutTemplate: 'layout'
	notFoundTemplate: 'error'
	onBeforeAction: ->
		@next()
	onAfterAction: ->
		unless isPhantomJS?
			dataLayer.push({'event':'pageview'}) if dataLayer?

Router.route '/',
	name: "index"
	data: {}
	action: ->
		this.render 'index'

Router.route '/blog',
	name: 'blog'
	action: ->
		this.render('blog')

Router.route '/blog/:code/:slug?',
	name: 'blog-post'
	action: ->
		this.render('post')
