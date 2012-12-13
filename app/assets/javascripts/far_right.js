$(document).ready(function() {
	 
	 	$( "#accordion" ).accordion({
             fillSpace: true
        });
		
		$(".task_accordion").one("click", function(){
			$.getScript("/roster_task")
		});
		
		$(".milestone_accordion").one("click", function(){
			$.getScript("/roster_milestone")
		});
	
	$(window).resize(function(){
		var elem = $(this);
		var height_of_div = $('.far_right_container').height();
		
		
		if (elem.width() <= 1340) {
			$('.far_right_container').hide().css({"top": "125px", "left": "","bottom": "", "right": "40" });;
			$('.far_right_container_min').show();
		} else{
			$('.far_right_container').show().css({"top": "125px", "left": "1180px","bottom": "", "right": "" });
			$('.far_right_container_min').hide();	
		};
	});
$(window).resize();
	$('.far_right_container').draggable(
		{handle: ".far_right_container_max", 
		 cursor: "move"});	
		
	
	$('.open_chatbox').click(function(){
		$('.far_right_container').toggle();
			$('.far_right_container_min').toggle();
        
        });
});