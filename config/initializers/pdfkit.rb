# PDFKit.configure do |config|
#   config.wkhtmltopdf = '/usr/bin/wkhtmltopdf'
#   #config.wkhtmltopdf = 'c:/wkhtmltopdf/wkhtmltopdf.exe'
#    config.default_options = {
#      :page_size => 'Legal',
#     #  :print_media_type => true, 
#     # :disable_smart_shrinking => true,
#     # :margin_left => "0mm", 
#     # :margin_right => "0mm", 
#     # :margin_top => "0mm", 
#     # :margin_bottom => "0mm"
#    }
#   # config.root_url = "http://localhost" # Use only if your external hostname is unavailable on the server.
# end
PDFKit.configure do |config|
  config.wkhtmltopdf = '/usr/bin/wkhtmltopdf'
  config.default_options = {
    :page_size => 'Legal',
    :print_media_type => true,
    :margin_top => "0mm"
  }
  # Use only if your external hostname is unavailable on the server.
  config.root_url = "http://localhost"

end