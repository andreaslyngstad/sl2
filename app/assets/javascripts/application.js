//= require jquery
//= require jquery_ujs
//= require jquery.ui.draggable
//= require jquery.ui.droppable
//= require jquery.ui.button
//= require jquery.ui.dialog
//= require jquery.ui.slider
//= require jquery.ui.datepicker
//= require jquery.ui.selectmenu
//= require jquery.ui.accordion
//= require chosen.jquery
//= require jquery.validate
//= require jquery.ba-bbq.min
//= require jquery.quicksearch
//= require navigation
//= require scrolling
//= require far_right
//= require logs
//= require log_tracking
//= require tabs
//= require employees
//= require timesheet
//= require memberships
//= require jquery.jclock

//= require nvd32/lib/d3.v2 


//= require nvd32/src/core
//= require nvd32/src/utils
//= require nvd32/src/models/axis
//= require nvd32/src/tooltip
//= require nvd32/src/models/legend
//= require nvd32/src/models/axis
//= require nvd32/src/models/scatter
//= require nvd32/src/models/stackedArea
//= require nvd32/src/models/stackedAreaChart
//= require nvd32/src/models/pie
//= require nvd32/src/models/pieChart
//= require nvd32/src/models/multiBar
//= require nvd32/src/models/multiBarChart
//= require colorArrays
//= require stackedAndPie
//= require json_fetcher
//= require_self

jQuery.ajaxSetup({ 
  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
})
//display help
jQuery.fn.display_help = function(){
  $(this).click(function(){
    $(".page_help").slideToggle()
   
    });
  
};

//submitting forms with ajax
jQuery.fn.submitWithAjax = function() {
  this.submit(function() { 
    $.post(this.action, $(this).serialize(), null, "script");
    $('.spinning').show();
    return false;
  })
  return this;
};
//submitting dialog forms with ajax
jQuery.fn.submit_dialog_WithAjax = function() {
    $.post(this.attr("action"), $(this).serialize(), null, "script");
    $('.spinning').show(); 
    $(".dialog_form").dialog("close")
    return false;
};

jQuery.fn.mark_todo_done = function (){
  this.live('click', function() { 
    $('.spinning').show();
    var todo_id =  $(this).attr("id");
  
  $.getScript("/mark_todo_done/" + todo_id)
    })
};
jQuery.fn.membership = function (){
  this.live('click', function() { 
    $('.spinning').show();
    var user_id =  $(this).attr("id");
    var project_id = $(this).attr("project_id")
  
  $.getScript("/membership/" + user_id + "/" + project_id)
    })
};

jQuery.fn.highlight = function (className)
{
    return this.addClass(className);
};


jQuery.fn.UIdialogs = function(){
  $(this).dialog({
      autoOpen: false,
      resizable: false,
      width: 400,
      modal: true,
      position: { 
    	my: 'top',
    	at: 'top',
    	offset: "500 0",
    	of: $('#navigation')
  		},
      close: function(event, ui) { 
      	
      	$(this).find(".hasDatepicker").datepicker( "destroy" );
    	
    	$("#logProjectId").val('').trigger("liszt:updated")
    	
      	$(this).dialog("destroy"); 
      	
      },
  });
};
jQuery.fn.disableUIdialogs = function(){
  $(this).dialog("destroy");
};


jQuery.fn.validateWithErrors = function(){
    $(this).validate({
     submitHandler: function(form) {  
    $(form).submit_dialog_WithAjax();
    $(form).parent().disableUIdialogs();
   },
   		errorElement: "div",
        wrapper: "div",  // a wrapper around the error message
     	errorPlacement: function(error, element) {
        element.before(error);
        offset = element.offset();
        error.css('left', offset.left);
        error.css('top', offset.top - element.outerHeight());
     }
   }); 
};
jQuery.fn.validateNoSubmit = function(){
    $(this).validate({
   		errorElement: "em",    
     	errorPlacement: function(error, element) {
     	$(".signup-form-field-subdomain em").remove();
         error.appendTo( element.parent("div"));
         element.css("border:1px solid red;");
     }
   }); 
};

jQuery.fn.UIdialogs_links = function(){
  var form = '#' + $(this).attr('id') + '_form'
  var date = '#' + $(this).attr('id') + '_date'
  var object = $(this).attr("data-object")
 
  $(this).button().click(function(){
  	$(form).UIdialogs();
      $(date).datepicker({ dateFormat: "yy-mm-dd" }).attr( 'readOnly' , 'true' );
       $(form).children(".new_" + object).validateWithErrors();
    
      $(form).dialog( "open" );
    
    });

}; 
jQuery.fn.activate_projects = function(){	
	$(this).button().click(function(){
		if (confirm("The project, all its tasks, logged hours and milestones will be arcivated. You'll find the project in the arcivated projects page, where you can reopen it or delete it.")){
		$('.spinning').show();
		var id = $(this).attr("data-id")
  	$.get("/activate_projects/" + id)}
    });	
};
jQuery.fn.reopen_project = function(){	
	$(this).click(function(){
		$('.spinning').show();
		var id = $(this).attr("data-id")
  	$.get("/activate_projects/" + id)
    });	
};
    
jQuery.fn.activate_projects_no_button = function(){
	$(this).click(function(){
		if (confirm("The project, all its tasks, logged hours and milestones will be arcivated. You'll find the project in the arcivated projects page, where you can reopen it or delete it.")){
		
		$('.spinning').show();
		var id = $(this).attr("data-id")
  	$.get("/activate_projects/" + id)}
    });
	
};


jQuery.fn.UIdialogs_edit_links = function(){
  $(this).click(function(){
    var data_id = $(this).attr('data-id')
    var object = $(this).attr("data-object")
    var form_id = '#' + $(this).attr('id') + '_' + data_id + '_form'
    
    $(form_id).find("#date" + '_' + object + '_' + data_id).datepicker({ dateFormat: "yy-mm-dd" }).attr( 'readOnly' , 'true' );
    $(form_id).children(".edit_" + object).validateWithErrors();
   	$(form_id).find("li").css("display", "");
    $(form_id).UIdialogs();
    $(form_id).dialog( "open" );
    });

};

jQuery.fn.current_link = function(){
  $(this).click(function(){
  $("#html_tabs a.current_link").removeClass("current_link")
  $(this).addClass("current_link")
    
    });

};




//ok
  
///////////////////////////////////////////////////////////////document.ready///////////////////////////////////////////////////////

$.fn.chosenDestroy = function () {
$(this).show().removeClass('chzn-done');
$(this).next().remove();

  return $(this);
}
  
  
$(document).ready(function() {	  
	
	$('.left_slider').click(function(){
	  $(".milestone_slider").animate({"left": "+=122px"}, "slow");
	});
	
	$('.right_slider').click(function(){
	  $(".milestone_slider").animate({"left": "-=122px"}, "slow");
	});
	var p = $(".milestone_slider").find(".upcomming:first").position()
	if (p != null){
	$('.milestone_slider').animate({"left": "-=" + (parseInt(p.left) - 122)}, "slow");
	}
   $('.jclock').jclock();
   
   $("#html_tabs a").current_link();
   $(".display_help").display_help();
//jquery UI dialogs

  $("#dialog_milestone").UIdialogs_links();
  
  $("#dialog_task").UIdialogs_links();
  

  
  $("#dialog_project").UIdialogs_links();
 
  $("#dialog_customer").UIdialogs_links();
 
  $("#dialog_user").UIdialogs_links();
 
  $("#activate_project").button().click(function(){
  	var id = $(this).attr("data-id")
  	
  	alert(id);
    });

  
  $(".open_project_update").UIdialogs_edit_links();
  $(".open_user_update").UIdialogs_edit_links();
  $(".open_customer_update").UIdialogs_edit_links();
  $(".open_milestone_update").UIdialogs_edit_links();
  $(".open_todo_update").UIdialogs_edit_links();
	
	
 
  $(".small_selector").selectmenu({width:200});
  $(".big_selector").selectmenu({width:369});
  
  $(".range").find(":submit").button();
  $(".date").datepicker({ dateFormat: "yy-mm-dd" }).attr( 'readOnly' , 'true' );
  
  $(".show_avatar_upload").click(function(){
  	$(".avatar_upload").show();
  	$(".avatar_show_page").hide();
  	return false	
  });
  $(".hide_avatar_upload").click(function(){
  	$(".avatar_upload").hide();
  	$(".avatar_show_page").show();
  	return false	
  });
  
//submitting new_project
  $(".new_project_form").validateWithErrors();

//submitting new_employee   
    $(".new_employee").validateWithErrors();
//    $(".edit_employee").validateWithErrors();
//submitting new_milestone  
   $(".new_milestone").validateWithErrors();
   $("#employee_formtastic").validateWithErrors();
//submitting new_project
   $(".new_project").validateWithErrors();
//   $(".edit_project").validateWithErrors();
//submitting new_todo
   	$(".new_todo").validateWithErrors();
   	$(".edit_todo").validateWithErrors();
   	$(".searchableTaskCustomer").chosen();
//submitting new_log
   	$(".new_log").validateWithErrors();
 	$(".tracking_log").submitWithAjax();
	$("#form_holder").find(".edit_log").submitWithAjax();
	
	$(".button").button();
	$(".activate_project").activate_projects();
	$(".reopen_project").reopen_project();
	$(".activate_projects_no_button").activate_projects_no_button();
	

 $(".background_style_color").css({"background-color":$("input.background_style").val()})
  $(".text_style_color").css({"background-color":$("input.text_style").val()})
  $(".background_style").keyup(function(){
  	var val_input = this.value
  $(".background_style_color").css({"background-color":val_input})
  
	});
  $(".text_style").keyup(function(){
  	var val_input = this.value
  $(".text_style_color").css({"background-color":val_input})
  
	});

 $("input.done_box").mark_todo_done();
 $("input.membership").membership();
 $(".register_firm").validateNoSubmit();
 $(".first_user").validateNoSubmit();
$(".range_date").datepicker({ dateFormat: "yy-mm-dd" }).attr( 'readOnly' , 'true' );
   
   $(".slider_range").slider({
        range: true,
        min: 0,
        max: 1439,
        values: [ 740, 1020 ],
        step:10,
        slide: slideTime
    });

//non-ajax search
   $("input#id_search_list").quicksearch('ul#cus_pro_us_listing li', {
   	
   }); 

})
