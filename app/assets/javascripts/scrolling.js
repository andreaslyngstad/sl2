$(document).ready(function() {
  $(window).scroll(function (event) {
		var x = $(this).scrollLeft();
		$(".hor_scroll").css("left", -x )
		$(".hor_scroll_200").css("left", -x + 200 )
		$(".hor_scroll_1180").css("left", -x + 1180 )
		$(".list_header").css("left", -x + 200 )
		
});
	
	
// $(function () {
//   
//   
//   
//   
    // var top = $('#comment').offset().top - parseFloat($('#comment').css('margin-top').replace(/auto/, 0));
    // $(window).scroll(function (event) {
      // // what the y position of the scroll is
      // var y = $(this).scrollTop();
//       
      // // whether that's below the form
      // if (y >= top) {
        // // if so, ad the fixed class
        // $('#comment').addClass('fixed');
      // } else {
        // // otherwise remove it
        // $('#comment').removeClass('fixed');
      // }
    // });
    
});