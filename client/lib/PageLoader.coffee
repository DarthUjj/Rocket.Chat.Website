@PageLoader = (->

	clear = ->
		time = new Date()
		if (time - TIMER) < 1000
			setTimeout ->
				clear()
			, 500
			return
		loader = document.querySelector("#page-loader")
		loader.classList.add("loaded")
		setTimeout ->
			loader.classList.add("hidden")
		, 250

	return {
		clear: clear
	}
)()
