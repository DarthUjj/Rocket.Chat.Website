Template.post.helpers
	post: ->
		return Template.instance().post.get()

	_createdAt: ->
		return moment(this._createdAt).format("DD/MM/YYYY")

	body: ->
		return Spacebars.SafeString @body.replace(/http:\/\/cdn-my.konecty.com/g,'//dlil52wgx3qln.cloudfront.net').replace(/([^>\r\n]?)(\r\n|\n\r|\r|\n)/g, '$1' + '<br>' + '$2')

Template.post.onCreated ->
	tpl = @
	tpl.post = new ReactiveVar

	code = parseInt Router.current().params['code']

	Meteor.call 'Konecty.findOneByCode', 'BlogPost', code, (err, result) ->
		tpl.post.set result

Template.post.onRendered ->
	PageLoader.clear()

