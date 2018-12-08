require 'mechanize'
require 'open-uri'
require 'uri'

agent = Mechanize.new
page = agent.get('http://www.belstat.gov.by/ofitsialnaya-statistika/makroekonomika-i-okruzhayushchaya-sreda/tseny/operativnaya-informatsiya_4/srednie-tseny-na-potrebitelskie-tovary-i-uslugi-po-respublike-belarus')
page.links_with(:href => /.xls/).each do |link|
    str_link = link.href.to_s
    str_link = URI.unescape(str_link)
    str_link = URI.escape(str_link)
    if /http:\/\/www.belstat.gov.by/ === str_link
        f_link = str_link
    else
        f_link = 'http://www.belstat.gov.by' + str_link
    end
    download = open(f_link)
    IO.copy_stream(download, "./data/#{download.base_uri.to_s.split('/')[-1]}")
end