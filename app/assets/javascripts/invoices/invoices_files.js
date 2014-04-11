function pollJob(jobId, url) {
      function poll() {
        poll.calledTimes++;
        if(poll.calledTimes < 15){
        $.ajax({
          url: "/jobs/fetch_job/", // coupled to your app's routes
          type: "GET",
            data: {id: jobId},
            dataType: 'JSON',
            statusCode: {
              200: function(data) { 
                if(url == "ajax_sending"){
                    $.ajax({
                      url: "/jobs/" + url,
                      type: "GET",
                      data: {id: jobId, file: data.file},
                      })
                }else{
                  window.location.href = "/jobs/" + url + "?file=" + data.file + "&id=" + jobId; $(".spinning").hide(); $('.flash_notice').empty() 
                }
              },
              202: function(data) { setTimeout(poll, 2000); $('.flash_notice').empty().append().text($.jsi18n.messages.crunching) },
              500: function(data) { console.log('Error!'); }
            }
        });
      }else{
        $.ajax({
            url: "/jobs/time_out",
            type: "GET",
            data: {id: jobId},
            })
      }

      };
      poll.calledTimes = 0;
      poll();

    }

jQuery.fn.sending_to_handeling_invoice = function(action){
  $(this).click(function(){
    $(this).hide()
    var id = $(this).attr("data-id")
    handeling_invoice(action, id)
     });
} 

function handeling_invoice(action, id){
  $.ajax({
        url: "/jobs/handeling_invoice/",  
        type: "POST",
          data: {id: id},
          dateType: "JSON",
          statusCode: {
            202: function(data) {$('.flash_notice').empty().append().text(data.flash), $('.spinning').hide()},
            200: function(data) {pollJob(data.id, "ajax_" + action)} 
          }
        });
  };
$(document).ready(function() {
  // $('.quick_send_invoice').send_invoice()
  $('.quick_send_invoice').sending_to_handeling_invoice("sending")
  $('.download_invoice').sending_to_handeling_invoice("download")
});