library(shiny)
library(stringi)

section.1 <- function(phrase) {
	data.frame(suggestion = c('a', 'b', 'c'),
		score = c(30, 20, 10))
}

section.2 <- function(phrase) {
	data.frame(suggestion = c('i', 'j', 'k'),
		score = c(100, 50, 25))
}

section.3 <- function(phrase) {
	data.frame(suggestion = c('x', 'y', 'z'),
			score = c(99, 66, 33))
}

suggestions <- function(phrase) {
	if (is.null(phrase) || (stri_isempty(phrase))) {
		return (NULL);
	}

	section.1 <- apply(section.1(phrase), 1,
		function(entry) {list(suggestion = entry[[1]], score = entry[[2]])})

	section.2 <- apply(section.2(phrase), 1,
		function(entry) {list(suggestion = entry[[1]], score = entry[[2]])})

	section.3 <- apply(section.3(phrase), 1,
		function(entry) {list(suggestion = entry[[1]], score = entry[[2]])})

	list(phrase = phrase,
		'section-1-id' = section.1,
		'section-2-id' = section.2,
		'section-3-id' = section.3)
}

updateTypeaheadSuggestions <- function(session, id, suggestions) {
	message <- list(id = id,
		suggestions = suggestions)

	session$sendCustomMessage('typeahead.jsUpdateSuggestions', message)
}

shinyServer(function(input, output, session) {
	data <- reactive({
		phrase <- input$q
		suggestions <- suggestions(phrase)

		list(suggestions = suggestions)
	})

	observe({
		if (is.null(data()) || is.null(data()$suggestions)) {
			return
		}
		updateTypeaheadSuggestions(session, 'q', data()$suggestions)
	})
})
