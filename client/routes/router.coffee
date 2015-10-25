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

Router.route '/deploy',
	name: 'deploy'
	action: ->
		this.render('deploy')

Router.route '/blog',
	name: 'blog'
	action: ->
		this.render('blog')

Router.route '/blog/:slug',
	name: 'blog-post'
	action: ->
		this.render('post')

Router.route '/contact',
	name: 'contact'
	action: ->
		this.render('contact')

Router.route '/statistics',
	name: 'statistics'
	layoutTemplate: false
	action: ->
		this.render('stats')
