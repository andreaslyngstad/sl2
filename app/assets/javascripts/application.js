//= require jquery
//= require jquery_ujs

//= require jquery.ui.draggable
//= require jquery.ui.droppable
//= require jquery.ui.button
//= require jquery.ui.dialog
//= require jquery.ui.slider
//= require jquery.ui.datepicker
//= require jquery.ui.accordion
//= require chosen.jquery.min

//= require jquery.validate.js


//= require jquery.quicksearch
//= require timeFormatter
//= require navigation
//= require scrolling
//= require far_right
//= require logs
//= require tasks
//= require reports
//= require log_tracking
//= require employees
//= require subscriptions

//= require sl_graphs

//= require timesheet
//= require strftime-min.js
//= require memberships
//= require jquery.xcolor.min
//= require nvd3/lib/d3.v2 

//= require nvd3/src/core
//= require nvd3/src/utils
//= require nvd3/src/models/axis
//= require nvd3/src/tooltip
//= require nvd3/src/models/legend
//= require nvd3/src/models/axis
//= require nvd3/src/models/scatter
//= require nvd3/src/models/stackedArea
//= require nvd3/src/models/stackedAreaChart
//= require nvd3/src/models/pie
//= require nvd3/src/models/pieChart
//= require nvd3/src/models/multiBar
//= require nvd3/src/models/multiBarChart
//= require colorArrays
//= require stackedAndPie
//= require_self


jQuery.ajaxSetup({ 
  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
})
function set_date_format_str(){
  var dateformat = $('.current_firm_data').data("dateformat")
  if (dateformat =="1"){
            return '%d.%m.%y'
          }else if (dateformat =="2") {
            return '%m/%d/%y'
          };
} 

jQuery.fn.set_date_format = function(){
  	$.each($('.date_format_setter'),function(k,v){
  		$(v).html(strftime(set_date_format_str(), new Date($(v).data("date"))))
    
  	});
}
jQuery.fn.set_clock_format = function(){
  var clockformat = $('.current_firm_data').data("clockformat")
  if (clockformat == 1){
  	$.each($('.clock_format_setter'),function(k,v){
  		$(v).html(strftime('%H:%M', new Date($(v).data("time"))))
  	});
  }else if (clockformat == 2)
  {
  	var time = new Date(this.data("time"))
  	$.each($('.clock_format_setter'),function(k,v){
  		$(v).html(strftime('%I:%M%P', new Date($(v).data("time"))))
  	});
   
  }
  
}

jQuery.fn.chosen_reset = function(n){
  $(this).chosen('destroy');
  $(this).prop('selectedIndex', 0);
  $(this).chosen(n)
}

jQuery.fn.display_help = function(){
  if ($(".page_help").length !== 0){  
      $(this).show()
    $(this).click(function(){
    $(this).data('clicked',!$(this).data('clicked'));
    if ($(this).data('clicked'))
      {
        var help_height = $(".page_help").height()
        $(".page_help").show()
        
      }
    else
      {  
        $(".page_help").hide()
        
      };
    });
  };
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
jQuery.fn.submit_dialog_WithAjax = function() {
    $.post(this.attr("action"), $(this).serialize(), null, "script");
    $('.spinning').show(); 
    return false;
};
jQuery.fn.membership = function (){
  this.on('click', function() { 
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
      position: ['middle',50],
      close: function(event, ui) { 	
      	$(this).find(".hasDatepicker").datepicker( "destroy" );
    	  $("#logProjectId").val('').trigger("chosen:updated")
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
	$(this).button().click(function(){
  var form = '#' + $(this).attr('id') + '_form'
  var date = '#' + $(this).attr('id') + '_date'
  var object = $(this).attr("data-object")
  	$(form).UIdialogs();
      $(date).datepicker();
       $(form).find(".new_" + object).validateWithErrors();
       $(form).find("select").chosen({width:'369px'})
      $(form).dialog( "open" );
    });

}; 
jQuery.fn.activate_projects = function(){	
	$(this).button().click(function(){
		if (confirm("The project, all its tasks, logged hours and milestones will be arcivated. You'll find the project in the arcivated projects page, where you can reopen it or delete it.")){
		$('.spinning').show();
		var id = $(this).attr("data-id")
  	$.post("/activate_projects/" + id)}
    });	
};
jQuery.fn.reopen_project = function(){	
	$(this).click(function(){
		$('.spinning').show();
		var id = $(this).attr("data-id")
  	$.post("/activate_projects/" + id)
    });	
};
    
jQuery.fn.activate_projects_no_button = function(){
  $(this).click(function(){
    if (confirm("The project, all its tasks, logged hours and milestones will be arcivated. You'll find the project in the arcivated projects page, where you can reopen it or delete it.")){
    
    $('.spinning').show();
    var id = $(this).attr("data-id")
    $.post("/activate_projects/" + id)}
    });
  
};
jQuery.fn.set_buget_width = function(){
    var procent = Math.round(this.data("procent") * 100)
    if (this.data("procent") == "Not set" || this.data("procent") == "Nothing used"){
      $(this).css("width", "100%")
        $(".budget_red").css("width", "0%")
        $(".budget_red").html("")
        $(this).html("<p>" + this.data("procent")  +"</p>")

    }else if(procent < 100) {
      var invert_procent = 100 - procent
      $(this).css("width", procent + "%")
      $(this).html(procent+ "%<p>spent</p>")
      // $(this).css("color", "white")
      $(".budget_red").css("width", invert_procent + "%")
      $(".budget_red").html(invert_procent+ "%<p>left</p>")
      
    }else if(procent > 100){
      var invert_procent = 100 - procent
      $(this).css("width", "100%")
      $(".budget_red").hide()
      $(this).html(procent+ "%<p>spent</p>")
    }
};


jQuery.fn.UIdialogs_edit_links = function(){

  $(this).click(function(){
    var data_id = $(this).attr('data-id')
    // get edit action via ajax for all in the ajax_form array
    var ajax_form = ["project", "customer", "todo", "user"]
    var object = $(this).attr("data-object")
    if ($.inArray(object, ajax_form) >= 0){
    $.get("/"+ object +"s/" + data_id + "/edit/")
    }
    var form_id = '#' + $(this).attr('id') + '_' + data_id + '_form'
    $(form_id).find("#date" + '_' + object + '_' + data_id).datepicker();
    // $(form_id).find(".edit_" + object).validateWithErrors();
   	$(form_id).find("li").css("display", "");
    $(form_id).UIdialogs();
    $(form_id).dialog( "open" );
    });

};

// jQuery.fn.add_alternate_date_field = function(){
//   var name = $(this).attr('name')
//   var value = $(this).attr('value');
//   if (/_formated/i.test(name)){
//   }else{
//     $(this).parent().append('<input id="alternate" name="' + name + '" type="hidden" value="' + $.datepicker.parseDate('mm/dd/yy', value) + '">');
//     $(this).attr('name', name + '_formated');
 
//   }
// };



//ok
  
///////////////////////////////////////////////////////////////document.ready///////////////////////////////////////////////////////
$.ajaxSetup({
  statusCode: {
  401: function(){
 
// Redirec the to the login page.
  location.href = "/sign_in";
 
  }
  }
  });

$(document).ready(function() {

  $(".range_date").datepicker({
      onSelect: function() {
        $('#range_form').submit();
        }
    }).attr( 'readOnly' , 'true' )	 
	if ($('.current_firm_data').data("dateformat") == 1 ){
			$.datepicker.setDefaults( { 
        dateFormat: "dd.mm.yy"
      } );
      
	}else if($('.current_firm_data').data("dateformat") == 2 ){
    // $('.hasDatepicker').parent().append('<input id="alternate" name="' + $(this).attr('name') + '" type="hidden" value="' + $.datepicker.parseDate('mm/dd/yy', '12/29/2013') + '">');
		$.datepicker.setDefaults( { 
        dateFormat: "mm/dd/yy"
       } );
	}
  	$('.date_format_setter').set_date_format()
  	$('.clock_format_setter').set_clock_format()

   $(".display_help").display_help();
  
//jquery UI dialogs
  $("#dialog_todo").UIdialogs_links();
  $("#dialog_project").UIdialogs_links();
  $("#dialog_customer").UIdialogs_links();
  $("#dialog_user").UIdialogs_links();
  $("#dialog_employees").UIdialogs_links();
  $("#activate_project").button();

  
  $(".open_project_update").UIdialogs_edit_links();
  $(".open_user_update").UIdialogs_edit_links();
  $(".open_customer_update").UIdialogs_edit_links();
  
  $(".open_todo_update").UIdialogs_edit_links();

  $(".account_update_select").chosen({width:'364px'});
  $(".big_selector").chosen({width:'369px'});
  $(".small_selector").chosen({width:'200px'});
  $(".mini_selector").chosen({width:'177px', disable_search:true});
  $('.logs_pr_date_select').chosen({width:'200px', disable_search:true});
  $(".date").datepicker();

 	$(".tracking_log").submitWithAjax();
	$("#form_holder").find(".edit_log").submitWithAjax();
	
	$(".button").button();
	$(".activate_project").activate_projects();
	$(".reopen_project").reopen_project();

	
  

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


 $("input.membership").membership();
 $(".register_firm").validateNoSubmit();
 $(".first_user").validateNoSubmit();

   
   // $(".slider_range").slider({
        // range: true,
        // min: 0,
        // max: 1439,
        // values: [ 740, 1020 ],
        // step:10,
        // slide: slideTime
    // });

//non-ajax search
   $("input#id_search_list").quicksearch('ul#cus_pro_us_listing li', {
   	
   }); 

})
