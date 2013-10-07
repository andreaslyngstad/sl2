
// console.log(baseurl)
$(document).ready(function() {
	//old_url = $.param(baseurl, location.href, 2);
old_url = location.protocol + '//' + location.host + location.pathname;

	var text = 	old_url.match(/customers/i) || 
				old_url.match(/projects/i) || 
				old_url.match(/archive/i) || 
				old_url.match(/users/i) ||  
				old_url.match(/home/i) ||  
				old_url.match(/logs/i);
				
	var text2 = old_url.match(/reports/i) || 
				old_url.match(/squadlink_report/i) ||
				old_url.match(/timesheet_week/i) || 
				old_url.match(/firm_show/i) || 
				old_url.match(/home_user/i) ||  
				old_url.match(/charts/i) ||  
				old_url.match(/subscriptions/i) ||  
				old_url.match(/plans/i) ||  
				old_url.match(/payments/i) ||  
				old_url.match(/firm_edit/i)||  
				old_url.match(/firm_update/i) || 
				old_url.match(/timesheet_day/i)||
				old_url.match(/timesheet_month/i)
				;
				
	if (!(text2 == null)){
		var tab_text = text2.toString().charAt(0).toUpperCase() + text2.toString().substr(1);
		$("#html_tabs_home a.current_link").removeClass("current_link");	
		$("#month_week_tabs a.current_link").removeClass("current_link");	
		$("#html_tabs_home a:contains(" + tab_text + ")").addClass("current_link");
		if(tab_text == "Charts" ){$("#html_tabs a:contains(Statistics)").addClass("current_link");}
		if(tab_text == "Firm_show" ){$("#html_tabs a:contains(Account)").addClass("current_link");}
		if(tab_text == "Firm_edit" ){$("#html_tabs a:contains(Account)").addClass("current_link");}
		if(tab_text == "Firm_update" ){$("#html_tabs a:contains(Account)").addClass("current_link");}
		if(tab_text == "Reports" ){$("#html_tabs a:contains(Reports)").addClass("current_link");}
		if(tab_text == "Squadlink_report" ){$("#html_tabs a:contains(Reports)").addClass("current_link");}

		if(tab_text == "Timesheet_day" ){$("#html_tabs a:contains(Timesheets)").addClass("current_link");}
		if(tab_text == "Timesheet_month" ){$("#html_tabs a:contains(Timesheets)").addClass("current_link");$("#month_week_tabs a:contains(Month)").addClass("current_link");}
		if(tab_text == "Timesheet_week" ){$("#html_tabs a:contains(Timesheets)").addClass("current_link");$("#month_week_tabs a:contains(Week)").addClass("current_link");}
		if(tab_text == "Plans" ){$("#html_tabs a:contains(Account)").addClass("current_link");}
		if(tab_text == "Payments" ){$("#html_tabs a:contains(Account)").addClass("current_link");}
		if(tab_text == "Subscriptions" ){$("#html_tabs a:contains(Account)").addClass("current_link");}
	}
	if (text == null && text2 == null){
		$('#navigation li#logs_navi').addClass("current_main")
	}else if(text == null){
		$('#navigation li#home_navi').addClass("current_main")
		
	}else{
	var cap_text = text.toString();
	$('#navigation li#' + cap_text +'_navi').addClass("current_main")
	if(cap_text == "archive"){
		$('#navigation li#projects_navi').addClass("current_main")
	}

	}
  $('#navigation li').on('click', function(e) { 
   $('#navigation li').removeClass("current_main")
   $(this).addClass('current_main')

		});
  $("#active_projects").button();
  $("#archive").button().on('click', function(e) { 
  	var href =	$(this).attr("href");
  	$("#pointer-text").text(text);
  });
	$(".back_button").button();   
});


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

