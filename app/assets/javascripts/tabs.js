$(document).ready(function() {
  $(window).bind( 'hashchange', function(e) {
    var url = e.fragment;
    if (url !== ""){
	    var id = ("#" + url)
	    var get_url = $( 'a[href="#' + url + '"]' ).attr("data-url")
	    $( '#sub_tabs li.active' ).removeClass( 'active' );
	    url && $( 'a[href="#' + url + '"]' ).parent().addClass( 'active' );
	    $(id).siblings().addClass("hide");
	    $(id).removeClass("hide");
	    $(".has_url").children().remove()
	    console.log(get_url)
	    if (typeof(get_url) !== "undefined"){
	    	$(".spinning").show()
	    	$.get(get_url)	
	    	}
	}
	else
	{
		$( '#sub_tabs li:first' ).addClass( 'active' );
		var get_url = $( '#sub_tabs li:first' ).find("a").attr("data-url")
		$(".spinning").show()
		$.get(get_url)	
	}
    })
  $(window).trigger( 'hashchange' );
})