String::contains = (it) ->
  @indexOf(it) isnt -1

showTabs = ->
  url = window.location.hash
  if url isnt ""
    id = (url)
    get_url = $("a[href=\"" + url + "\"]").attr("data-url")
    $("#html_tabs li.active").removeClass "active"
    $("#html_tabs li a.current_link").removeClass "current_link"
    url and $("a[href=\"" + url + "\"]").parent().addClass("active")
    url and $("a[href=\"" + url + "\"]").addClass("current_link")
    $(id).siblings().addClass "hide"
    $(id).removeClass "hide"
    $(".has_url").children().remove()
    if typeof (get_url) isnt "undefined"
      $(".spinning").show()
      $.get get_url
  else
    $("#html_tabs li:first").addClass "active"
    $("#html_tabs li:first a").addClass "current_link"
    get_url = $("#html_tabs li:first").find("a").attr("data-url")
    $(".spinning").show()
    $.get get_url

$(document).ready ->
  pathname = location.pathname
  if pathname.match(/customers\//i) or pathname.match(/projects\//i) or pathname.match(/users\//i) or pathname.match(/invoices\//i) 
    showTabs()
    $("#html_tabs ul li a").click ->
      url = window.location.hash
      getUrl = $(this).attr("data-url")
      id = (url)
      get_url = $(this).attr("data-url")
      $("#html_tabs li.active").removeClass "active"
      $("#html_tabs li a.current_link").removeClass "current_link"
      $(this).parent().addClass("active")
      $(this).addClass("current_link")
      $(id).siblings().addClass "hide"
      $(id).removeClass "hide"
      $(".has_url").children().remove()
      if typeof (get_url) isnt "undefined"
        $(".spinning").show()
        $.get get_url
  if pathname.match(/charts/i)
	  from = $(".one_month_back").data("lastmonth")
	  to = $(".one_month_back").data("today")
	  $.getJSON "/users_logs.json",
	    from: from
	    to: to
	  , (data) ->
	    stackedAndPie data, users_logsColorArray  
 