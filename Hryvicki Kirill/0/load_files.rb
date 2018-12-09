require 'mechanize'
require 'open-uri'
require 'uri'
require 'webrick'

agent = Mechanize.new
page = agent.get('http://www.belstat.gov.by/ofitsialnaya-statistika/makroekonomika-i-okruzhayushchaya-sreda/tseny/operativnaya-informatsiya_4/srednie-tseny-na-potrebitelskie-tovary-i-uslugi-po-respublike-belarus')
page.links_with(href: /.xls/).each do |link|
  str_link = link.href.to_s
  str_link = WEBrick::HTTPUtils.unescape(str_link)
  str_link = WEBrick::HTTPUtils.escape(str_link)
  f_link = if %r{http:\/\/www.belstat.gov.by}.match?(str_link)
             str_link
           else
             'http://www.belstat.gov.by' + str_link
           end
  download = URI.open(f_link)
  IO.copy_stream(download, "./data/#{download.base_uri.to_s.split('/')[-1]}")
end
