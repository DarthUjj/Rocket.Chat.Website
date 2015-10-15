Template.sharer.events
	"click .facebook": (e) ->
		e.preventDefault()
		e.stopPropagation()
		window.open("https://www.facebook.com/sharer/sharer.php?u=" + encodeURIComponent(window.location.href),"Facebook Share","width=500,height=350")
	"click .twitter": (e) ->
		e.preventDefault()
		e.stopPropagation()
		title = $("head title").html()
		window.open("https://twitter.com/intent/tweet?text=" + encodeURIComponent(title) + "&url=" + encodeURIComponent(window.location.href),"Twitter Share","width=500,height=350")
