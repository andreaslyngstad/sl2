function Change_select(log_id, object_id, url){
		$('.spinning').show();
		console.log("log => " + log_id + " object_id => " + object_id);
	    if (log_id === "") {
	    	if(object_id === ""){
		      $.get("/" + url + "/0/0"  )
		    }else{
		      $.get("/" + url + "/" + object_id + "/0" )
		     }
	    }else{
		    if(object_id === ""){
		      $.get("/" + url + "/0/" + log_id  )
		    }else{		     
		      $.get("/" + url + "/" + object_id + "/" + log_id)
	    }
	    };
}

jQuery.fn.UIdialogs_tracking_logs_links = function(){
  $(this).click(function(){
  	$(".tracking_select").slideToggle();
  	$(".open_tracking_select").toggleClass("close_tracking_select");
  	  if ($(".open_tracking_select").hasClass("close_tracking_select")) {
  	  	
  	  	$("#index_log_header").animate({ top: 398}, 400) 
          $("#index_logs").animate({marginTop: 460}, 400)
  	  } else{
  	  	 $("#index_log_header").animate({ top: 279}, 400) 
          $("#index_logs").animate({marginTop: 340}, 400)
  	  	
  	  };
    var data_id = $(this).attr('data-id')
    var form_id = '#form_holder'
    
    // get todo and saving log when selecting project
	    $(form_id).find("select#logProjectIdTracking").change(function(){
		    Change_select($(this).attr("log"), this.value.toString(), "project_select_tracking")
	    });
	    $(form_id).find("select#logTodoIdTracking" + data_id).change(function(){
	   		Change_select($(this).attr("log"), this.value.toString(), "todo_select_tracking")
	    });  
	  // get employees and saving log when selecting customer
	    $(form_id).find("select#logCustomerIdTracking" + data_id).change(function(){
	    	Change_select($(this).attr("log"), this.value.toString(), "customer_select_tracking")
	    }); 
	    
	    $(form_id).find("select#logEmployeeIdTracking" + data_id).change(function(){
	    	Change_select($(this).attr("log"), this.value.toString(), "employee_select_tracking")
	    });  
   });

};

jQuery.fn.select_projects_customers = function() {
	$(this).UIdialogs();
   	$(this).dialog( "open" );	
   	var data_id = $(this).attr('data-id')
	if (data_id === undefined ) {
		$(this).find("select#logProjectId").change(function(){
    	Change_select($(this).attr("log"), this.value.toString(), "project_select")
		});
   		$(this).find("select#logTodoId").change(function(){
	    Change_select("", this.value.toString(), "todo_select")
	    });	
   		$(this).find("select#logCustomerId").change(function(){
    	Change_select("", this.value.toString(), "customer_select")	
    	});
	}else{
		$(this).find("select#logProjectId" + data_id).change(function(){
    	Change_select($(this).attr("log"), this.value.toString(), "project_select")
		});
	    $(this).find("select#logTodoId" + data_id).change(function(){
	    Change_select($(this).attr("log"), this.value.toString(), "todo_select")
   		});
	    $(this).find("select#logCustomerId" + data_id).change(function(){
    	Change_select($(this).attr("log"), this.value.toString(), "customer_select")
		});
     }; 
};



jQuery.fn.UIdialogs_log_links = function(){
  var form = '#' + $(this).attr('id') + '_form'
  $(this).button().click(function(){
  	$(form).find(".date").datepicker()
  	var log_time_from = $("#log_times_from_").val();
    var log_time_to = $("#log_times_to_").val();
    $(form).children(".new_log").validateWithErrors()
  	$(form).find(".slider_range").slider({
        range: true,
        min: 0,
        max: 1439,
        values: [ time_to_value(log_time_from), time_to_value(log_time_to) ],
        step:10,
        slide: slideTime
    });
    $(form).find(".searchableS").chosen();
    $(form).select_projects_customers();
    });

};

jQuery.fn.UIdialogs_edit_logs_links = function(){
  $(this).click(function(){
    var data_id = $(this).attr('data-id')
    var form_id = '#' + $(this).attr('id') + '_' + data_id + '_form'
    $.get("/logs/" + data_id + "/edit/")
    
    });

};


function slideTime(event, ui){
   var log = $(this).attr("log")
    var minutes0 = parseInt(ui.values[ 0 ]  % 60);
    var hours0 = parseInt(ui.values[ 0 ]  / 60 % 24);
    var minutes1 = parseInt(ui.values[ 1 ]  % 60);
    var hours1 = parseInt(ui.values[ 1 ]  / 60 % 24);
    $("#log_times_from_" + log).val(getTime(hours0, minutes0));
    $("#log_times_to_" + log).val(getTime(hours1, minutes1));
   };
 
function getTime(hours, minutes) {
    var time = null;
    minutes = minutes + "";  
    if (minutes.length == 1) {
        minutes = "0" + minutes;
    }
    hours = hours + "";
    if (hours.length == 1) {
        hours = "0" + hours;
    }
    
    return hours + ":" + minutes;
};
function time_to_value(time){
    var b = time
    var temp = new Array
    temp = b.split(":")
    
    var hours = parseInt(temp[0] *60)
    var min = parseInt(temp[1])
    
    return hours + min
};
jQuery.fn.logs_pr_date_select = function(){
		this.change(function(){
  $('.spinning').show();
  var time = this.value
  var url = $(this).attr("data-url");
  var id = $(this).attr("data-id");
  $.get("/logs_pr_date/" + time + "/" + url + "/" + id)
  
  });
  };

$(document).ready(function() {
	$(".searchableS_tracking").chosen();
  	$("select#logs_pr_date_select").logs_pr_date_select();
	$("#dialog_log").UIdialogs_log_links();
	$(".open_log_update").UIdialogs_edit_logs_links();
	$(".date").datepicker();
	$(".range_date").datepicker({
		onSelect: function() {
			$('#range_form').submit();
  		}
		}).attr( 'readOnly' , 'true' )
	$(".slider_range").slider({
	        range: true,
	        min: 0,
	        max: 1439,
	        values: [ 740, 1020 ],
	        step:10,
	        slide: slideTime
	    });
	$(".open_tracking_select").UIdialogs_tracking_logs_links();
})
