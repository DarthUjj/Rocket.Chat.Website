Template["new-index"].events
	"click #main-nav nav a" : (event) ->
		event.preventDefault()
		event.stopPropagation()
		hash = event.currentTarget.href.replace(/(.*)#(.*)/, "$2")
		el = $(document.getElementById(hash))
		$(window).add($("html,body")).animate({scrollTop: el.position().top}, 500)



Template["new-index"].rendered = ->
	win = $(window)
	nav = $("#main-nav")
	hidden = true
	win.on "scroll", ->
		scrl = win.scrollTop()
		if scrl > 100
			if hidden is true
				hidden = false
				nav.removeClass("clean")
				return
			return
		if scrl <= 100
			if hidden is false
				hidden = true
				nav.addClass("clean")

	PageLoader.clear()

	particlesJS.load 'particles-js', '/scripts/particles.json', ->
		# lol
