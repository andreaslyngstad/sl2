window.sQuadLink ?= {}
jQuery.fn.countDone = ->
  done = $(".tasks_percent").data("complete")
  notDone = $(".tasks_percent").data("notcomplete")
  if done > 0 
    percent = ((done / (notDone + done)) * 100).toFixed(0)
  else
    percent = '0'
  @text percent + '%'
    
jQuery.fn.submitDoneWithAjax = (id) -> 
  $.post("/todos/" + id, $(this).serialize(), null, "script")

sQuadLink.todosTab = ->
	$(".logs_pluss").click ->
	  $(".flash_notice").empty()
	  $(".spinning").show()
	  $(this).hide()
	  $(this).next(".logs_minus").show()
	  $.get "/get_logs_todo/" + $(this).attr("id")
	$(".logs_minus").click ->
	  $(".flash_notice").empty()
	  id = $(this).attr("id")
	  $("#todo_logs_" + id).slideUp()
	  $("#todo_logs_" + id).children().empty().remove()
	  $(this).hide()
	  $(this).prev(".logs_pluss").show()
	$(".done_box").on "click", ->
	  id = $(this).attr("id")
	  $("#edit_done_todo_" + id).submitDoneWithAjax id
	$(".todo_range_date").datepicker(onSelect: ->
  	$("#todo_range_form").submit()
	).attr "readOnly", "true"
	$('#todos_pr_date_select').pr_date_select()