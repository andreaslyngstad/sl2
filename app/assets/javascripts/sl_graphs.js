function prepareAndCallJson(){
		var url = $("#stats").val()
		var from = $("#from").val() 
		var to = $("#to").val()
		var ColorArray = eval(url + "ColorArray")
		$("#stacked svg").empty();
		$("#pie svg").empty()
		$("#legend").empty()
    	$.getJSON('/' + url + '.json', {from: from, to: to}, function(data) {
  				stackedAndPie(data, ColorArray)      
		})
} 

$(document).ready(function() {	
	var from = $(".one_month_back").data("lastmonth") 
	var to = $(".one_month_back").data("today")
	$.getJSON('/users_logs.json', {from: from, to: to}, function(data) {
	  stackedAndPie(data, users_logsColorArray)      
	}); 
	$("#from").val(from)
	$("#to").val(to)
	$(".range_date_graphs").datepicker({
		onSelect: function() {
			prepareAndCallJson()
  		}
		}).attr( 'readOnly' , 'true' )
	
	$("#stats").change(function() {
		prepareAndCallJson()
	});

});
