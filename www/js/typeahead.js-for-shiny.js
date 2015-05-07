(function() {
	var typeaheadInputBinding = new Shiny.InputBinding();

	$.extend(typeaheadInputBinding, {
		find: function(scope) {
			return $(scope).find('.typeahead');
		},
		getValue: function(element) {
			return element.value;
		},
		setValue: function(element, value) {
			element.value = value;
		},
		subscribe: function(element, callback) {
			// Use normal debouncing policy when typing
			$(element).on('keyup.typeaheadInputBinding', function(event) {
				callback(true);
			});
	
			// Send immediately after pressing enter
			$(element).on('change.typeaheadInputBinding', function(event) {
				callback(false);
			});
		},
		unsubscribe: function(element) {
			$(element).off('.typeaheadInputBinding');
		},
		getRatePolicy: function() {
			return {
				policy: 'debounce',
				delay: 1000 // 1 s
			};
		}
	});

	Shiny.inputBindings.register(typeaheadInputBinding);
})();

var typeaheadUpdatedSuggestions = {};

(function() {
	function typeaheadUpdateSuggestions(data) {
		if (!data) {
			return;
		}
		var id = data['id'];
		typeaheadUpdatedSuggestions[id] = data['suggestions'];
		if (!typeaheadUpdatedSuggestions[id]) {
			return;
		}
		$('#' + id).typeahead('updateHints');
	}

	Shiny.addCustomMessageHandler('typeahead.jsUpdateSuggestions', typeaheadUpdateSuggestions);
})();
