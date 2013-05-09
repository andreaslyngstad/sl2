jQuery.fn.timeheet_user_select = function(){
		this.change(function(){
  $('.spinning').show();
  var id = this.value
  $.get("/timesheet_week/" + id)
  
  });
};  

$(document).ready(function() {
	var firm_format = $(".current_firm_data").data("timeformat") 
	$(".calendar_span").set_hours()
$("tr.project_hours").each(function(index, element) {
    var row = $(this).find('td.total');
    var total = 0;
    $(this).find("td.number").each(function (index, element) {
    	var hours = $(element).attr("data-hours")
        total += parseFloat(hours);
        $(element).html(secondsToString(hours, firm_format))
    });
    row.attr("data-hours", total)
    row.html(secondsToString(total, firm_format));
});
 var total = 0;
$("td.timesheet_day_total").each(function(index, element) {
	 total += parseFloat($(element).attr("data-hours"));
	$(element).html(secondsToString($(element).attr("data-hours"), firm_format))
})
$("td.timesheet_week_total").html(secondsToString(total, firm_format))
$("td.timesheet_week_total").attr("data-hours", total)
$("#timeheet_project_select").chosen().change(function(){
	    var this_value = $(this).val()
	    $(".form-input").each(function(i,v){
	    	$(v).addClass("log_date_" + $(v).attr("data-date"))
	    })
	    $(".form-input").attr("data-project", this_value)
		$(".form-input").val("")
		$(".form-input").attr("data-logid", "")
		$(".form-input").attr("data-prehours", "")
		
		$(".form-input").prop('disabled', false);
	if (!this_value){	
		$(".form-input").prop('disabled', true)	
	}
		
})
$("select#timeheet_user_select").chosen()
$("select#timeheet_user_select").timeheet_user_select();
$("table.timesheet_table tbody tr td.number input").focusout(function(){
	var logid		= $(this).attr("data-logid")
	var val_input 	= this.value
	var project 	= $(this).attr("data-project")
	var date 		= $(this).attr("data-date")
	var user  		= $(".timesheet_table").attr("data-user")
	var regexp1 	= /^[0-9]+.[0-9]+$/  // test denne => /[0-9,:]+(?:\.[0-9]*)?/
	var regexp2		= /^[1-9][0-9]*$/
	var params      = {project_id: project, date: date,user_id: user, val_input: val_input, log_id: logid}
	if (regexp1.test(val_input) || regexp2.test(val_input)){
		$(this).css("color", "")
		
		
			$('.spinning').show();
		$.ajax({
			url: "/add_hour_to_project/",	
			type: "POST",
    		data: params,
    		chache:false,
    		dateType: "JSON"
			});	
	
	}else{
		$(this).css("color", "red")
		
		setTimeout(function(){
	      
		},0);}	
  });
})