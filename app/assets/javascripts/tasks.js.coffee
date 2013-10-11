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


