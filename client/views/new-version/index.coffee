Template["new-index"].rendered = ->

	win = $(window)
	nav = $("#main-nav")
	hidden = true
	win.scroll ->
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







	particlesJS.load 'particles-js', '/scripts/particles.json', ->
		# lol
