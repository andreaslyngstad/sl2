$(document).ready(function() {
	var from = $(".one_month_back").data("lastmonth") 
	var to = $(".one_month_back").data("today")
	$.getJSON('/users_logs.json', {from: from, to: to}, function(data) {
	  stackedAndPie(data, users_logsColorArray)      
	}); 
});
