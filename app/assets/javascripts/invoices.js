function currency_converter(value){
    var currency = $(".current_firm_data").attr("data-currency");
    var language = $(".current_firm_data").attr("data-language");
    return value.toLocaleString(language, {style: "currency", currency: currency, minimumFractionDigits: 2, maximumFractionDigits: 2})
}
jQuery.fn.convert_money_field = function(){
  $(this).each(function(i, e){
    $(e).text(currency_converter(parseFloat($(e).attr("data-value"))))
  })
}

jQuery.fn.UIdialogs_invoices_link = function(){
  $(this).button().click(function(){
    $(".spinning").show()
      var url = $(this).attr("data-url");
      var id = $(this).attr("data-id");
        $.ajax({
        url: "/invoices/new/",  
        type: "GET",
          data: {url: url, id: id},
          dateType: "JSON"
        });
     });
};
jQuery.fn.UIdialogs_edit_invoices_links = function(){
  $(this).click(function(){
    var data_id = $(this).attr('data-id')
    var object = $(this).attr("data-object")
    $.get("/"+ object +"s/" + data_id + "/edit/")
    var form_id = '#' + $(this).attr('id') + '_' + data_id + '_form'
    $(form_id).find("#date" + '_' + object + '_' + data_id).datepicker();
    });
};
jQuery.fn.UIdialogs_invoices = function(){
  $(this).dialog({
      autoOpen: false,
      resizable: false,
      width: 970,
      modal: true,
      position: ['middle',50],
      close: function(event, ui) {  
        $(this).find(".hasDatepicker").datepicker( "destroy" );
        $(this).dialog("destroy"); 
      },
  });
  $(this).dialog("open")
  $('.new_invoice').validateWithErrors();
  $('.edit_invoice').validateWithErrors();
};

jQuery.fn.log_related_updates = function(){
  $('.date_format_setter').set_date_format()
  $(".total_log_time").set_hours()
  $('.clock_format_setter').set_clock_format()
  $(".open_log_update").UIdialogs_edit_logs_links();
  $('.remove_log').remove_log_from_invoice()
  $('.total_on_this').total_on_log()
  $('.total_on_this').total_on_invoice()
  $('.tax_field').change_vat()
}

function customer_project_ajax(id, object, other_object, invoice){
  $(".spinning").show()
  $.ajax({
        url: "/invoices/" + object +"_select/", 
        type: "GET",
          data: {id: id, other_object: other_object,invoice: invoice},
          dateType: "JSON"
        });
    };
 
jQuery.fn.invoice_object_select = function(){
	this.change(function(){
    var object = $(this).attr("data-object")
    var other_object = $(this).attr("data-other-object")
    var invoice = $(this).attr("data-invoice")
    var id = this.value
    if (id != ""){
      customer_project_ajax(id, object, other_object, invoice)
    };
  }); 
}


jQuery.fn.change_object = function(){
  this.click(function(event){
    var object = $(this).attr('data-object')
    var other_object = $(this).attr('data-other-object')
    if ($('#change_' + object).attr('data-customer')){
      $('#selected_customer').remove();
      $('#dialog_customer').show();
      $('#invoice_customer_select').show();
      $("select#invoice_customer_id").val("")
      $("#invoice_customer_id").trigger("chosen:updated");
    }
    $('#invoice_' + other_object + '_id').attr("data-other-object" ,"")
    $('#selected_' + object).remove();
    $('#dialog_' + object).show();
    $('#invoice_' + object + '_select').show();
    $('select#invoice_' + object + '_id').val("")
    $('#invoice_' + object + '_id').trigger("chosen:updated");
    var other = $('#invoice_' + object + '_id').attr("data-other-object")
    if (other){
      var id = other
      customer_project_ajax(id, other_object, "")
    }else{
      $('.listing_logs_invoice_container').empty();
      $('.listing_logs_invoice_container').log_related_updates()
    }
    $(".flash_error").empty()
    event.preventDefault();
});
};

jQuery.fn.total_on_log = function(){
var jsonObject = {}
var vat_array = []
  $(this).filter(":visible").each(function(index, element) {
    var price = $(element).attr("data-price");
    var quantity = $(element).attr("data-quantity");
    var vat = $(element).attr("data-vat");
    var value_ex_vat = price * quantity
    var value = value_ex_vat * (1 + vat/100)
    var vat_value = value - value_ex_vat
    if (vat_array.indexOf(vat) == -1){
      vat_array.push(vat)
    }
    if (jsonObject.hasOwnProperty(vat)){
      jsonObject[vat] = jsonObject[vat] + value_ex_vat
    }else{
      jsonObject[vat] = value_ex_vat;
    }
    $(element).text(currency_converter(value))
    $(element).attr("data-total", value)
    $(element).attr("data-totalExVat", value_ex_vat)
    });
 display_total_vat(jsonObject,vat_array)
 $('.total_on_this').total_on_invoice()
}


jQuery.fn.total_on_invoice = function(){
  var subtotal = 0
  var total = 0;
  $(this).filter(":visible").each(function(index, element){
    var log_total = parseFloat($(element).attr("data-total"))
    var log_subtotal = parseFloat($(element).attr("data-totalexvat"))
    if (!isNaN(log_subtotal) ){
    subtotal += log_subtotal
    }
    if (!isNaN(log_total) ){
    total += log_total
    }
  })
  $(".subtotal_on_invoice").text(currency_converter(subtotal))
  $(".total_on_invoice").text(currency_converter(total))
  $(".total_hidden_field").val(total.toFixed(2))
}

function display_total_vat(vat_values, vat){
  $(".invoice_vat_line").remove()
   $(vat).each(function(index,element){
    if( vat_values.hasOwnProperty(element)){
      var vat_sum = (vat_values[element]*element/100)
      $(".invoice_vat_head").after('<tr class="invoice_vat_line"><td class="cell_1">'+element+'</td><td class="cell_2">' +currency_converter(vat_values[element])+  '</td><td class="cell_3">'+ currency_converter(vat_sum) +'</td><td class="cell_4">'+ currency_converter(vat_sum+vat_values[element]) + '</td></tr>')
    }
   })
};

jQuery.fn.change_vat = function(){
  $(this).keyup(function(){
    var val = this.value
    $(this).next().attr('data-vat', val)
    $('.total_on_this').total_on_log()
  });
};
jQuery.fn.set_vat_value = function(){
  $(this).each(function(index, element){
    var val = element.val()
  element.next().attr('data-vat', val)
  })
  var val = $(this).val()
  $(this).next().attr('data-vat', val)
}
jQuery.fn.quantity_price_vat_lines = function(){
  $(this).keyup(function(){
    var val = $(this).val().replace(',', '.')
    var type = $(this).attr("data-type")
    var total_field =  $(this).closest("tr").find(".total_on_line")
    if (isNaN(val)){
      $(this).css("border", "solid 1px red")
      total_field.attr("data-" + type, 0)
     }else{
      total_field.attr("data-" + type, val)
      var total = total_field.attr("data-quantity")* total_field.attr("data-price") * (1 + total_field.attr("data-vat")/100)
      total_field.attr('data-total', total )
      total_field.attr('data-totalexvat', total_field.attr("data-quantity")* total_field.attr("data-price") )
      total_field.text( currency_converter(total))
      $(this).css("border","1px solid #dddddd")
    }
    
    $('.total_on_this').total_on_log()
  })
}

jQuery.fn.sum_fields = function(){
  $(".total_on_line").each(function(i, element ){
    console.log("test")
    var total_field = $(element)
    var total = total_field.attr("data-quantity")* total_field.attr("data-price") * (1 + total_field.attr("data-vat")/100)
    total_field.attr('data-total', total )
    total_field.attr('data-totalexvat', total_field.attr("data-quantity")* total_field.attr("data-price") )
    total_field.text( currency_converter(total))
  })
   $('.total_on_this').total_on_log()
} 

jQuery.fn.add_fields = function(){
  this.click(function(event){
    $('.free_lines_table_container').show()
    var time = new Date().getTime()
    var regexp = new RegExp($(this).data('id'), 'g')
    $(".free_lines_table").append($(this).data('fields').replace(regexp, time))
    $('.invoice_line_description').last().focus();
    $(".invoice_line_vat").quantity_price_vat_lines()
    $(".invoice_line_price").quantity_price_vat_lines()
    $(".invoice_line_quantity").quantity_price_vat_lines()
    $('.remove_fields').remove_line_from_invoice()
    event.preventDefault();
  });
};

jQuery.fn.remove_line_from_invoice = function(){
  $(this).click(function(){
    var id = $(this).closest(".invoice_line")
    $(this).prev('input[type=hidden]').val('1')
    $(id).hide()
    if ($(".invoice_line:visible").length < 1){
      $('.free_lines_table_container').hide()
    }
    $('.total_on_this').total_on_log()
    
  })
}
jQuery.fn.remove_log_from_invoice = function(){
  $(this).click(function(){
    if($(".info").length > 1){
        var id = $(this).attr('data-log-id')
        $('#logs_attributes_' + id + '_invoice_id').val("nil")
        $("#log_" + id).hide()

      }else{
        $(".log_list_element").hide()
      }

    $('.total_on_invoice').total_on_invoice()
    $('.total_on_this').total_on_log()
  })
}
jQuery.fn.invoice_pr_date_select = function(){
  this.change(function(){
    $('.spinning').show();
    var time = this.value
    var url = $(this).attr("data-url");
    var id = $(this).attr("data-id");
    $.get("/invoice_range", {time: time, url:url, id:id})  
  });
};
jQuery.fn.set_currency = function(){
  $(this).text(function(i, text) {
    var val = parseFloat($(this).attr('data-amount'))
    var converted = currency_converter(val)
    return converted
    })
} 
jQuery.fn.prepare_invoice_template = function(page_count){
  $(this).find('.page_counting_placeholder')
         .addClass('page_counting')
         .removeClass('page_counting_placeholder')
  $(this).addClass('invoice_wrapper')
         .removeClass('invoice_template')
         .attr('id', 'invoice_wrapper' + page_count)
  $(this).find('.checking_height').addClass('active_height')
  $(this).show()
}
jQuery.fn.append_lines_and_logs = function(){
  if ($(this).hasClass('line')){
    $('.active_height').find('.free_lines_table_print_container').show()
    $('.active_height').find('.free_lines_table tbody').prepend(this)
  }else{
    // listing_logs_invoice_container
    $('.active_height').find('.listing_logs_invoice_container').show().append(this)
  }
}
function make_new_page(){
  if ($('.active_height').height() + $('.active_height').find('.invoice_table').height() > $('.invoice_wrapper').height()){
    $('.old_height').removeClass('old_height')
    $('.invoice_wrapper').find('.active_height').filter(':visible').removeClass('active_height').addClass('old_height');
    if ($('.old_height').find('.line').length == 0){$('.old_height').find('.free_lines_table_print_container').hide()}
    if($('#invoice_wrapper0').find('.log').length == 0){$('#invoice_wrapper0').find('.listing_logs_invoice_container').remove()}
    $('.invoice_template').clone().appendTo('#tabs-1')
    $('.invoice_template').first().prepare_invoice_template($('.invoice_wrapper').length)
    }  
}
function move_last_line(){
  var page_count =  $('.invoice_wrapper').length
  make_new_page()
    while ($('.old_height').height() + $('.old_height').find('.invoice_table').height() > $('.invoice_wrapper').height()){
     var line = $('.old_height').find('.invoice_line').last()
     line.append_lines_and_logs()
      if ($('.old_height').height() + $('.old_height').find('.invoice_table').height() < $('.invoice_wrapper').height()){
        make_new_page()
      }
    }
    
    // make_new_page($('.active_height').height(), $('.active_height').find('.invoice_table').height())
}

function find_last_invoice_line(page_count) {
  $('#invoice_wrapper'  + (page_count - 1)).find('.invoice_line').last();
};

jQuery.fn.count_pages = function(){
  var number_of_pages = $(this).length
  $(this).each(function(i, e){
    j = i + 1
    $(e).text(j + '/' + number_of_pages)
  })
}
jQuery.fn.put_total_at_bottom = function(){
  $(this).first().css('top', (($('.invoice_wrapper').height() + parseFloat($('.invoice_wrapper').css('padding-top'))) - $(this).height()) + 'px');  
  move_last_line()
}
$(document).ready(function() {
  $('.money').convert_money_field()
  $('.total_on_this').total_on_log()
  $('.invoice_table').put_total_at_bottom();
  $(".open_invoices_update").UIdialogs_edit_invoices_links();
  $('.invoice_wrapper').find('.page_counting').count_pages()
  $("#dialog_invoice").UIdialogs_invoices_link();
  $(".open_invoices_update").UIdialogs_edit_invoices_links();
  $("select#invoices_pr_date_select").invoice_pr_date_select();
  $(".invoice_range_date").datepicker({ 
  onSelect: function() {
    $('#invoice_range_form').submit();
    }
    }).attr( 'readOnly' , 'true' )
  $('.invoice_list').find('.invoice_amount').set_currency()

});