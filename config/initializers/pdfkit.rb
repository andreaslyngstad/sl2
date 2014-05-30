
Shrimp.configure do |config|
  # The path to the phantomjs executable
  # defaults to `where phantomjs`
  config.phantomjs = '/usr/local/bin/phantomjs'

  # the default pdf output format
  # e.g. "5in*7.5in", "10cm*20cm", "A4", "Letter"
  config.format           = 'A4'

  # the default margin
  config.margin           = '0cm'

  # the zoom factor
  config.zoom             = 1

  # the page orientation 'portrait' or 'landscape'
  config.orientation      = 'portrait'

  # a temporary dir used to store tempfiles like cookies
  %w(shrimp).each do |dir_to_make|
    FileUtils.mkdir_p(Rails.root.join('tmp', dir_to_make))
  end
  config.tmpdir           = Rails.root.join('tmp', 'shrimp')
	
  # the default rendering time in ms
  # increase if you need to render very complex pages
  config.rendering_time   = 1000

  # the timeout for the phantomjs rendering process in ms
  # this needs always to be higher than rendering_time
  config.rendering_timeout = 3000
end
# WickedPdf.config = {
#   :exe_path => `which wkhtmltopdf`.gsub(/\n/, '')
# }

# PDFKit.configure do |config|
#   config.wkhtmltopdf = `which wkhtmltopdf`.gsub(/\n/, '')
#   #config.wkhtmltopdf = 'c:/wkhtmltopdf/wkhtmltopdf.exe'
#    config.default_options = {
#      :page_size => 'Legal',
#      # :print_media_type => true, 
#     # :disable_smart_shrinking => true,
#     :margin_left => "0mm", 
#     :margin_right => "0mm", 
#     :margin_top => "0mm", 
#     :margin_bottom => "0mm"
#    }
  # config.root_url = "http://localhost" # Use only if your external hostname is unavailable on the server.
# end
PDFKit.configure do |config|
  config.wkhtmltopdf = `which wkhtmltopdf`.gsub(/\n/, '')
  config.default_options = {
    :page_size => 'Legal',
    :print_media_type => true,
    :margin_top => "0mm"
  }
  # Use only if your external hostname is unavailable on the server.
  config.root_url = "http://localhost"

end