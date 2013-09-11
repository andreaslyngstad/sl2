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
    	var hours = $(element).data("hours")
        total += parseFloat(hours);
        $(element).html(secondsToString(hours, firm_format))
    });
    row.data("hours", total)
    row.html(secondsToString(total, firm_format));
});
 var total = 0;
$("td.timesheet_day_total").each(function(index, element) {
	 total += parseFloat($(element).data("hours"));
	$(element).html(secondsToString($(element).data("hours"), firm_format))
})
$("td.timesheet_week_total").html(secondsToString(total, firm_format))
$("td.timesheet_week_total").data("hours", total)
$("#timeheet_project_select").chosen().change(function(){
	    var this_value = $(this).val()
	    $(".form_input_cell").each(function(i,v){
	    	$(v).addClass("log_date_" + $(v).data("date"))
	    })
	    $(".form_input_cell").data("project", this_value)
		$(".form_input_cell").val("")
		$(".form_input_cell").data("logid", "")
		$(".form_input_cell").data("prehours", "")
		
		$(".form_input_cell").prop('disabled', false);
	if (!this_value){	
		$(".form_input_cell").prop('disabled', true)	
	}
		
})
$("select#timeheet_user_select").chosen()
$("select#timeheet_user_select").timeheet_user_select();
$("table.timesheet_table tbody tr td.number input").focusout(function(){
	var logid		= $(this).data("logid")
	var val_input 	= this.value
	var project 	= $(this).data("project")
	var date 		= $(this).data("date")
	var user  		= $(".timesheet_table").data("user")
	var regexp1 	= /^[0-9]+.[0-9]+$/  // test denne => /[0-9,:]+(?:\.[0-9]*)?/
	var regexp2		= /^[0-9][0-9]*$/
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