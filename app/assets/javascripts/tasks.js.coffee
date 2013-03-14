jQuery.fn.countDone = ->
  done = $("#done_tasks").children(".info").size()
  notDone = $("#not_done_tasks").children(".info").size()
  percent = ((done / (notDone + done)) * 100).toFixed(2)
  @replaceWith "<div class='statistics_unit tasks_percent one_number white'>" + percent + "%</div>"

