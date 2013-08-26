String.prototype.contains = function(it) { return this.indexOf(it) != -1; }; 
$(document).ready(function() {
  $(window).bind( 'hashchange', function(e) {
    var url = window.location.hash;
    if (url !== ""){
	    var id = (url)
	    var get_url = $( 'a[href="' + url + '"]' ).attr("data-url")
	    $( '#html_tabs li.active' ).removeClass( 'active' );
	    $( '#html_tabs li a.current_link' ).removeClass( 'current_link' );
	    url && $( 'a[href="' + url + '"]' ).parent().addClass( 'active' );
	    url && $( 'a[href="' + url + '"]' ).addClass( 'current_link' );

	    $(id).siblings().addClass("hide");
	    $(id).removeClass("hide");
	    $(".has_url").children().remove()
	    if (typeof(get_url) !== "undefined"){
	    	$(".spinning").show()
	    	$.get(get_url)	
	    	}
	}
	else
	{
		$( '#html_tabs li:first' ).addClass( 'active' );
		$( '#html_tabs li:first a' ).addClass( 'current_link' )
		 var get_url = $( '#html_tabs li:first' ).find("a").attr("data-url")
		 $(".spinning").show()
		 $.get(get_url)	
	}

    })
  $(window).trigger( 'hashchange' );
})