jQuery.fn.timeheet_user_select = function(){
		this.change(function(){
  $('.spinning').show();
  var id = this.value
  $.get("/timesheets/" + id)
  
  });
};  
$(document).ready(function() {
$("select#timeheet_user_select").timeheet_user_select();
$("table.timesheet_table tbody tr td.number input").focusout(function(){
	var val_input 	= this.value
	var project 	= $(this).attr("data-project")
	var date 		= $(this).attr("data-date")
	var regexp1 	= /^[0-9, ,]+$/  // test denne => /[0-9,:]+(?:\.[0-9]*)?/
	var regexp2		= /^[,]+$/
	if (regexp1.test(val_input)){
		// write some save AJAX call
	}else{
		alert ("Sorry, you have entered a wrong format. Please use number,number. For example 8,5")
		
	

		setTimeout(function(){
	      
		},0);}	
  });
})