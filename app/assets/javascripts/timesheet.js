jQuery.fn.timeheet_user_select = function(){
		this.change(function(){
  $('.spinning').show();
  var id = this.value
  $.get("/timesheets/" + id)
  
  });
};  
$(document).ready(function() {

$("#timeheet_project_select").chosen().change(function(){
	    var this_value = $(this).val()
		$(".form-input").val("")
		$(".form-input").prop('disabled', false);
	if (!this_value){	
		$(".form-input").prop('disabled', true)	
	}
		
})

$("select#timeheet_user_select").timeheet_user_select();
$("table.timesheet_table tbody tr td.number input").focusout(function(){
	var val_input 	= this.value
	var project 	= $(this).attr("data-project")
	var date 		= $(this).attr("data-date")
	var regexp1 	= /^[0-9, ,]+$/  // test denne => /[0-9,:]+(?:\.[0-9]*)?/
	var regexp2		= /^[,]+$/
	if (regexp1.test(val_input)){
		$(this).css("color", "")
		$.post("/")
	}else{
		$(this).css("color", "red")
		
	

		setTimeout(function(){
	      
		},0);}	
  });
})