jQuery.fn.timeheet_user_select = function(){
		this.change(function(){
  $('.spinning').show();
  var id = this.value
  $.get("/timesheets/" + id)
  
  });
};  
function sumInputsIn(inputs) {
    var sum = 0;
    inputs.each(function() {
        sum += parseInt(this.value, 10);
    });
    return sum;
}
$(document).ready(function() {
$("tr.project_hours").each(function(){
	row = $(this).find('td.total')
	row.html(sumInputsIn($(this).find("td.number").attr("data-time")));
	
	})


$("#timeheet_project_select").chosen().change(function(){
	    var this_value = $(this).val()
	    $(".form-input").attr("data-project",this_value )
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
	var user  		= $(".timesheet_table").attr("data-user")
	var regexp1 	= /^[0-9]+.[0-9]+$/  // test denne => /[0-9,:]+(?:\.[0-9]*)?/
	var regexp2		= /^[1-9][0-9]*$/
	var params      = {project_id: project, date: date,user_id: user, val_input: val_input}
	if (regexp1.test(val_input) || regexp2.test(val_input)){
		console.log("hours: " + val_input + " project: " + project + " Date: " + date + " User: " + user)
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