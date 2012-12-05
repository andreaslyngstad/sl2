$.getJSON('/users_logs.json', function(data) {
  stackedAndPie(data, users_logsColorArray)      
});

$(document).ready(function() {	 

	$("#stats").change(function() {
		var url = $(this).val()
		var ColorArray = eval(url + "ColorArray")	
		$("#stacked svg").empty();
		$("#pie svg").empty()
		$("#legend").empty()
		$.getJSON('/' + url + '.json', function(data) {
  				stackedAndPie(data, ColorArray)      
		});
	});

});
